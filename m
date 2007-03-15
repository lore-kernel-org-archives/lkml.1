Return-Path: <linux-kernel-owner+w=401wt.eu-S933890AbXCOWPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbXCOWPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933879AbXCOWPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:38 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33695 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbXCOWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 04 of 33] IB/ipath - don't initialize port memory for subports
X-Mercurial-Node: d90faa722f120e0896aff3643a623b1e0c0c69d0
Message-Id: <d90faa722f120e0896af.1173995088@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:48 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Ralph Campbell <ralph.campbell@qlogic.com>
# Date 1173994464 25200
# Node ID d90faa722f120e0896aff3643a623b1e0c0c69d0
# Parent  e2eec96f356a7269b46a68f29fc5e711d2f5a7a4
IB/ipath - don't initialize port memory for subports

A recent change was made to allocate memory for a port after CPU
affinity is set. That change didn't account for subports and
was trying to allocate memory for the port twice.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r e2eec96f356a -r d90faa722f12 drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:24 2007 -0700
@@ -178,8 +178,7 @@ static int ipath_get_base_info(struct fi
 
 		kinfo->spi_rcvhdr_base = ((u64) pd->subport_rcvhdr_base +
 			pd->port_rcvhdrq_size * slave) & MMAP64_MASK;
-		kinfo->spi_rcvhdr_tailaddr =
-			(u64) pd->port_rcvhdrqtailaddr_phys & MMAP64_MASK;
+		kinfo->spi_rcvhdr_tailaddr = 0;
 		kinfo->spi_rcv_egrbufs = ((u64) pd->subport_rcvegrbuf +
 			dd->ipath_rcvegrcnt * dd->ipath_rcvegrbufsize * slave) &
 			MMAP64_MASK;
@@ -1443,6 +1442,7 @@ static int init_subports(struct ipath_de
 	pd->port_subport_cnt = uinfo->spu_subport_cnt;
 	pd->port_subport_id = uinfo->spu_subport_id;
 	pd->active_slaves = 1;
+	set_bit(IPATH_PORT_MASTER_UNINIT, &pd->port_flag);
 	goto bail;
 
 bail_rhdr:
@@ -1764,11 +1764,17 @@ static int ipath_do_user_init(struct fil
 			      const struct ipath_user_info *uinfo)
 {
 	int ret;
-	struct ipath_portdata *pd;
+	struct ipath_portdata *pd = port_fp(fp);
 	struct ipath_devdata *dd;
 	u32 head32;
 
-	pd = port_fp(fp);
+	/* Subports don't need to initialize anything since master did it. */
+	if (subport_fp(fp)) {
+		ret = wait_event_interruptible(pd->port_wait,
+			!test_bit(IPATH_PORT_MASTER_UNINIT, &pd->port_flag));
+		goto done;
+	}
+
 	dd = pd->port_dd;
 
 	if (uinfo->spu_rcvhdrsize) {
@@ -1826,6 +1832,11 @@ static int ipath_do_user_init(struct fil
 			 dd->ipath_rcvctrl & ~INFINIPATH_R_TAILUPD);
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_rcvctrl,
 			 dd->ipath_rcvctrl);
+	/* Notify any waiting slaves */
+	if (pd->port_subport_cnt) {
+		clear_bit(IPATH_PORT_MASTER_UNINIT, &pd->port_flag);
+		wake_up(&pd->port_wait);
+	}
 done:
 	return ret;
 }
diff -r e2eec96f356a -r d90faa722f12 drivers/infiniband/hw/ipath/ipath_kernel.h
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h	Thu Mar 15 14:34:24 2007 -0700
@@ -701,6 +701,8 @@ int ipath_set_rx_pol_inv(struct ipath_de
 #define IPATH_PORT_WAITING_RCV   2
 		/* waiting for a PIO buffer to be available */
 #define IPATH_PORT_WAITING_PIO   3
+		/* master has not finished initializing */
+#define IPATH_PORT_MASTER_UNINIT 4
 
 /* free up any allocated data at closes */
 void ipath_free_data(struct ipath_portdata *dd);
