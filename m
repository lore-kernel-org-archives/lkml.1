Return-Path: <linux-kernel-owner+w=401wt.eu-S933276AbZKXPM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbZKXPM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933256AbZKXPHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:49 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39134 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933132AbZKXPHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:46 -0500
Message-Id: <20091124150752.432406000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:06 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 09/29] GRU - Improve messages for malfunctioning GRUs
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_debug_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Improve error messages for malfunctioning GRUs. Identify
the type of instruction that is failing.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gruhandles.c |   22 +++++++++++++++++++---
 drivers/misc/sgi-gru/gruhandles.h |    6 ++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

Index: linux/drivers/misc/sgi-gru/gruhandles.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.c	2009-11-20 09:32:14.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruhandles.c	2009-11-20 09:32:30.000000000 -0600
@@ -54,6 +54,21 @@ static void start_instruction(void *h)
 	gru_flush_cache(h);
 }
 
+static void report_instruction_timeout(void *h)
+{
+	unsigned long goff = GSEGPOFF((unsigned long)h);
+	char *id = "???";
+
+	if (TYPE_IS(CCH, goff))
+		id = "CCH";
+	else if (TYPE_IS(TGH, goff))
+		id = "TGH";
+	else if (TYPE_IS(TFH, goff))
+		id = "TFH";
+
+	panic(KERN_ALERT "GRU %p (%s) is malfunctioning\n", h, id);
+}
+
 static int wait_instruction_complete(void *h, enum mcs_op opc)
 {
 	int status;
@@ -64,9 +79,10 @@ static int wait_instruction_complete(voi
 		status = GET_MSEG_HANDLE_STATUS(h);
 		if (status != CCHSTATUS_ACTIVE)
 			break;
-		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time))
-			panic("GRU %p is malfunctioning: start %ld, end %ld\n",
-			      h, start_time, (unsigned long)get_cycles());
+		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time)) {
+			report_instruction_timeout(h);
+			start_time = get_cycles();
+		}
 	}
 	if (gru_options & OPT_STATS)
 		update_mcs_stats(opc, get_cycles() - start_time);
Index: linux/drivers/misc/sgi-gru/gruhandles.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.h	2009-11-20 09:32:14.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruhandles.h	2009-11-20 09:32:30.000000000 -0600
@@ -91,6 +91,12 @@
 /* Convert an arbitrary handle address to the beginning of the GRU segment */
 #define GRUBASE(h)		((void *)((unsigned long)(h) & ~(GRU_SIZE - 1)))
 
+/* Test a valid handle address to determine the type */
+#define TYPE_IS(hn, h)		((h) >= GRU_##hn##_BASE && (h) <	\
+		GRU_##hn##_BASE + GRU_NUM_##hn * GRU_HANDLE_STRIDE &&   \
+		(((h) & (GRU_HANDLE_STRIDE - 1)) == 0))
+
+
 /* General addressing macros. */
 static inline void *get_gseg_base_address(void *base, int ctxnum)
 {

