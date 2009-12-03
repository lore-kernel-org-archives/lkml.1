Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZLCWfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZLCWfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZLCWfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:35:51 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34724 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753546AbZLCWfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:35:44 -0500
Message-Id: <20091203223550.134790000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 03 Dec 2009 16:34:16 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 2/2] GRU - send cross partition interrupts using the gru
References: <20091203223414.393107000@sgi.com>
Content-Disposition: inline; filename=uv_gru_message_queue_ipi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

GRU Message queue instructions are used to deliver messages to
other SSIs within the numalink domain. In most cases, a single GRU
mesq instruction will deliver both the message AND an interrupt
to notify the other SSI that a messsage is present. In some cases,
however, the interrupt must be sent explicitly.

To improve resilency, the GRU driver should send these explicit
interrupts using the GRU to write the remote chipset register.
Current code sends the interrupt using a cpu instruction to write the
chipset register.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru_instructions.h |   12 +++++++++
 drivers/misc/sgi-gru/grukservices.c     |   39 +++++++++++++++++++-------------
 2 files changed, 36 insertions(+), 15 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2009-12-03 09:46:53.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2009-12-03 09:47:17.000000000 -0600
@@ -367,6 +367,18 @@ static inline void gru_vload_phys(void *
 					(unsigned long)tri0, CB_IMA(hints)));
 }
 
+static inline void gru_vstore_phys(void *cb, unsigned long gpa,
+		unsigned int tri0, int iaa, unsigned long hints)
+{
+	struct gru_instruction *ins = (struct gru_instruction *)cb;
+
+	ins->baddr0 = (long)gpa | ((unsigned long)iaa << 62);
+	ins->nelem = 1;
+	ins->op1_stride = 1;
+	gru_start_instruction(ins, __opdword(OP_VSTORE, 0, XTYPE_DW, iaa, 0,
+					(unsigned long)tri0, CB_IMA(hints)));
+}
+
 static inline void gru_vload(void *cb, unsigned long mem_addr,
 		unsigned int tri0, unsigned char xtype, unsigned long nelem,
 		unsigned long stride, unsigned long hints)
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-12-03 09:46:53.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-12-03 09:46:57.000000000 -0600
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <linux/delay.h>
+#include <asm/io_apic.h>
 #include "gru.h"
 #include "grulib.h"
 #include "grutables.h"
@@ -566,7 +567,7 @@ int gru_create_message_queue(struct gru_
 	mqd->mq = mq;
 	mqd->mq_gpa = uv_gpa(mq);
 	mqd->qlines = qlines;
-	mqd->interrupt_pnode = UV_NASID_TO_PNODE(nasid);
+	mqd->interrupt_pnode = nasid >> 1;
 	mqd->interrupt_vector = vector;
 	mqd->interrupt_apicid = apicid;
 	return 0;
@@ -703,18 +704,6 @@ cberr:
 }
 
 /*
- * Send a cross-partition interrupt to the SSI that contains the target
- * message queue. Normally, the interrupt is automatically delivered by hardware
- * but some error conditions require explicit delivery.
- */
-static void send_message_queue_interrupt(struct gru_message_queue_desc *mqd)
-{
-	if (mqd->interrupt_vector)
-		uv_hub_send_ipi(mqd->interrupt_pnode, mqd->interrupt_apicid,
-				mqd->interrupt_vector);
-}
-
-/*
  * Handle a PUT failure. Note: if message was a 2-line message, one of the
  * lines might have successfully have been written. Before sending the
  * message, "present" must be cleared in BOTH lines to prevent the receiver
@@ -723,7 +712,8 @@ static void send_message_queue_interrupt
 static int send_message_put_nacked(void *cb, struct gru_message_queue_desc *mqd,
 			void *mesg, int lines)
 {
-	unsigned long m;
+	unsigned long m, *val = mesg, gpa, save;
+	int ret;
 
 	m = mqd->mq_gpa + (gru_get_amo_value_head(cb) << 6);
 	if (lines == 2) {
@@ -734,7 +724,26 @@ static int send_message_put_nacked(void 
 	gru_vstore(cb, m, gru_get_tri(mesg), XTYPE_CL, lines, 1, IMA);
 	if (gru_wait(cb) != CBS_IDLE)
 		return MQE_UNEXPECTED_CB_ERR;
-	send_message_queue_interrupt(mqd);
+
+	if (!mqd->interrupt_vector)
+		return MQE_OK;
+
+	/*
+	 * Send a cross-partition interrupt to the SSI that contains the target
+	 * message queue. Normally, the interrupt is automatically delivered by
+	 * hardware but some error conditions require explicit delivery.
+	 * Use the GRU to deliver the interrupt. Otherwise partition failures
+	 * could cause unrecovered errors.
+	 */
+	gpa = uv_global_gru_mmr_address(mqd->interrupt_pnode, UVH_IPI_INT);
+	save = *val;
+	*val = uv_hub_ipi_value(mqd->interrupt_apicid, mqd->interrupt_vector,
+				dest_Fixed);
+	gru_vstore_phys(cb, gpa, gru_get_tri(mesg), IAA_REGISTER, IMA);
+	ret = gru_wait(cb);
+	*val = save;
+	if (ret != CBS_IDLE)
+		return MQE_UNEXPECTED_CB_ERR;
 	return MQE_OK;
 }
 

