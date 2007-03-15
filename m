Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbXCOW1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbXCOW1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422983AbXCOW1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:27:35 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33699 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbXCOWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 18 of 33] IB/ipath - Fix calculation for number of kernel PIO
	buffers
X-Mercurial-Node: 878b6054e9ca5327db9c9438f66265afaf88b055
Message-Id: <878b6054e9ca5327db9c.1173995102@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:02 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID 878b6054e9ca5327db9c9438f66265afaf88b055
# Parent  a023ffe32d9df8cba7d8b15c24e7918eeb236a2c
IB/ipath - Fix calculation for number of kernel PIO buffers

If the module parameter "kpiobufs" is set too high, the calculation
to reset it to a sane value was incorrect.

Signed-off-by: Ralph Campbell <ralph.campbell@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r a023ffe32d9d -r 878b6054e9ca drivers/infiniband/hw/ipath/ipath_init_chip.c
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c	Thu Mar 15 14:34:25 2007 -0700
@@ -668,6 +668,7 @@ int ipath_init_chip(struct ipath_devdata
 {
 	int ret = 0, i;
 	u32 val32, kpiobufs;
+	u32 piobufs, uports;
 	u64 val;
 	struct ipath_portdata *pd = NULL; /* keep gcc4 happy */
 	gfp_t gfp_flags = GFP_USER | __GFP_COMP;
@@ -702,16 +703,17 @@ int ipath_init_chip(struct ipath_devdata
 	 * the in memory DMA'ed copies of the registers.  This has to
 	 * be done early, before we calculate lastport, etc.
 	 */
-	val = dd->ipath_piobcnt2k + dd->ipath_piobcnt4k;
+	piobufs = dd->ipath_piobcnt2k + dd->ipath_piobcnt4k;
 	/*
 	 * calc number of pioavail registers, and save it; we have 2
 	 * bits per buffer.
 	 */
-	dd->ipath_pioavregs = ALIGN(val, sizeof(u64) * BITS_PER_BYTE / 2)
+	dd->ipath_pioavregs = ALIGN(piobufs, sizeof(u64) * BITS_PER_BYTE / 2)
 		/ (sizeof(u64) * BITS_PER_BYTE / 2);
+	uports = dd->ipath_cfgports ? dd->ipath_cfgports - 1 : 0;
 	if (ipath_kpiobufs == 0) {
 		/* not set by user (this is default) */
-		if ((dd->ipath_piobcnt2k + dd->ipath_piobcnt4k) > 128)
+		if (piobufs >= (uports * IPATH_MIN_USER_PORT_BUFCNT) + 32)
 			kpiobufs = 32;
 		else
 			kpiobufs = 16;
@@ -719,31 +721,25 @@ int ipath_init_chip(struct ipath_devdata
 	else
 		kpiobufs = ipath_kpiobufs;
 
-	if (kpiobufs >
-	    (dd->ipath_piobcnt2k + dd->ipath_piobcnt4k -
-	     (dd->ipath_cfgports * IPATH_MIN_USER_PORT_BUFCNT))) {
-		i = dd->ipath_piobcnt2k + dd->ipath_piobcnt4k -
-			(dd->ipath_cfgports * IPATH_MIN_USER_PORT_BUFCNT);
+	if (kpiobufs + (uports * IPATH_MIN_USER_PORT_BUFCNT) > piobufs) {
+		i = (int) piobufs -
+			(int) (uports * IPATH_MIN_USER_PORT_BUFCNT);
 		if (i < 0)
 			i = 0;
-		dev_info(&dd->pcidev->dev, "Allocating %d PIO bufs for "
-			 "kernel leaves too few for %d user ports "
+		dev_info(&dd->pcidev->dev, "Allocating %d PIO bufs of "
+			 "%d for kernel leaves too few for %d user ports "
 			 "(%d each); using %u\n", kpiobufs,
-			 dd->ipath_cfgports - 1,
-			 IPATH_MIN_USER_PORT_BUFCNT, i);
+			 piobufs, uports, IPATH_MIN_USER_PORT_BUFCNT, i);
 		/*
 		 * shouldn't change ipath_kpiobufs, because could be
 		 * different for different devices...
 		 */
 		kpiobufs = i;
 	}
-	dd->ipath_lastport_piobuf =
-		dd->ipath_piobcnt2k + dd->ipath_piobcnt4k - kpiobufs;
-	dd->ipath_pbufsport = dd->ipath_cfgports > 1
-		? dd->ipath_lastport_piobuf / (dd->ipath_cfgports - 1)
-		: 0;
-	val32 = dd->ipath_lastport_piobuf -
-		(dd->ipath_pbufsport * (dd->ipath_cfgports - 1));
+	dd->ipath_lastport_piobuf = piobufs - kpiobufs;
+	dd->ipath_pbufsport =
+		uports ? dd->ipath_lastport_piobuf / uports : 0;
+	val32 = dd->ipath_lastport_piobuf - (dd->ipath_pbufsport * uports);
 	if (val32 > 0) {
 		ipath_dbg("allocating %u pbufs/port leaves %u unused, "
 			  "add to kernel\n", dd->ipath_pbufsport, val32);
@@ -754,8 +750,7 @@ int ipath_init_chip(struct ipath_devdata
 	dd->ipath_lastpioindex = dd->ipath_lastport_piobuf;
 	ipath_cdbg(VERBOSE, "%d PIO bufs for kernel out of %d total %u "
 		   "each for %u user ports\n", kpiobufs,
-		   dd->ipath_piobcnt2k + dd->ipath_piobcnt4k,
-		   dd->ipath_pbufsport, dd->ipath_cfgports - 1);
+		   piobufs, dd->ipath_pbufsport, uports);
 
 	dd->ipath_f_early_init(dd);
 
