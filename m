Return-Path: <linux-kernel-owner+w=401wt.eu-S933939AbXCOWVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939AbXCOWVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXCOWTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:35 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33715 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 24 of 33] IB/ipath - fix driver crash (in interrupt or during
	unload) after chip reset
X-Mercurial-Node: 3e81a6b18b42bbe6dffab382fb26d754dfdf83a1
Message-Id: <3e81a6b18b42bbe6dffa.1173995108@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:08 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Michael Albaugh <Michael.Albaugh@QLogic.com>
# Date 1173994465 25200
# Node ID 3e81a6b18b42bbe6dffab382fb26d754dfdf83a1
# Parent  01cde17958018b5262570cd9ea399378f95051e7
IB/ipath - fix driver crash (in interrupt or during unload) after chip reset

Re-init of the kernel structures after a chip reset was leaving the
portdata structure for port zero in an inconsistent state, and a pointer
to it either stale (in re-init code) or NULL (in devdata) Fixing the
order of operations on this struct, and the condition for interrupt
access, prevents the crashes.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 01cde1795801 -r 3e81a6b18b42 drivers/infiniband/hw/ipath/ipath_init_chip.c
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c	Thu Mar 15 14:34:25 2007 -0700
@@ -216,6 +216,20 @@ static int bringup_link(struct ipath_dev
 	return ret;
 }
 
+static struct ipath_portdata *create_portdata0(struct ipath_devdata *dd)
+{
+	struct ipath_portdata *pd = NULL;
+
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (pd) {
+		pd->port_dd = dd;
+		pd->port_cnt = 1;
+		/* The port 0 pkey table is used by the layer interface. */
+		pd->port_pkeys[0] = IPATH_DEFAULT_P_KEY;
+	}
+	return pd;
+}
+
 static int init_chip_first(struct ipath_devdata *dd,
 			   struct ipath_portdata **pdp)
 {
@@ -271,20 +285,16 @@ static int init_chip_first(struct ipath_
 		goto done;
 	}
 
-	dd->ipath_pd[0] = kzalloc(sizeof(*pd), GFP_KERNEL);
-
-	if (!dd->ipath_pd[0]) {
+	pd = create_portdata0(dd);
+
+	if (!pd) {
 		ipath_dev_err(dd, "Unable to allocate portdata for port "
 			      "0, failing\n");
 		ret = -ENOMEM;
 		goto done;
 	}
-	pd = dd->ipath_pd[0];
-	pd->port_dd = dd;
-	pd->port_port = 0;
-	pd->port_cnt = 1;
-	/* The port 0 pkey table is used by the layer interface. */
-	pd->port_pkeys[0] = IPATH_DEFAULT_P_KEY;
+	dd->ipath_pd[0] = pd;
+
 	dd->ipath_rcvtidcnt =
 		ipath_read_kreg32(dd, dd->ipath_kregs->kr_rcvtidcnt);
 	dd->ipath_rcvtidbase =
@@ -838,11 +848,24 @@ int ipath_init_chip(struct ipath_devdata
 	 * Set up the port 0 (kernel) rcvhdr q and egr TIDs.  If doing
 	 * re-init, the simplest way to handle this is to free
 	 * existing, and re-allocate.
+	 * Need to re-create rest of port 0 portdata as well.
 	 */
 	if (reinit) {
-		struct ipath_portdata *pd = dd->ipath_pd[0];
-		dd->ipath_pd[0] = NULL;
-		ipath_free_pddata(dd, pd);
+		/* Alloc and init new ipath_portdata for port0,
+		 * Then free old pd. Could lead to fragmentation, but also
+		 * makes later support for hot-swap easier.
+		 */
+		struct ipath_portdata *npd;
+		npd = create_portdata0(dd);
+		if (npd) {
+			ipath_free_pddata(dd, pd);
+			dd->ipath_pd[0] = pd = npd;
+		} else {
+			ipath_dev_err(dd, "Unable to allocate portdata for"
+				      "  port 0, failing\n");
+			ret = -ENOMEM;
+			goto done;
+		}
 	}
 	dd->ipath_f_tidtemplate(dd);
 	ret = ipath_create_rcvhdrq(dd, pd);
diff -r 01cde1795801 -r 3e81a6b18b42 drivers/infiniband/hw/ipath/ipath_stats.c
--- a/drivers/infiniband/hw/ipath/ipath_stats.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_stats.c	Thu Mar 15 14:34:25 2007 -0700
@@ -207,7 +207,7 @@ void ipath_get_faststats(unsigned long o
 	 * don't access the chip while running diags, or memory diags can
 	 * fail
 	 */
-	if (!dd->ipath_kregbase || !(dd->ipath_flags & IPATH_PRESENT) ||
+	if (!dd->ipath_kregbase || !(dd->ipath_flags & IPATH_INITTED) ||
 	    ipath_diag_inuse)
 		/* but re-arm the timer, for diags case; won't hurt other */
 		goto done;
