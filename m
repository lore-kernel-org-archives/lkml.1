Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbXLXO3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbXLXO3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXLXO3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:29:10 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:33626 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbXLXO3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:29:08 -0500
Date: Mon, 24 Dec 2007 15:28:42 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: rolandd@cisco.com, mshefty@ichips.intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 15/38] drivers/infiniband: Use time_before, time_before_eq,
 etc.
Message-ID: <Pine.LNX.4.64.0712241528140.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
--- a/drivers/infiniband/hw/ipath/ipath_intr.c	2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c	2007-12-23 20:30:39.000000000 +0100
@@ -32,6 +32,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/jiffies.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
@@ -94,7 +95,7 @@ static void ipath_disarm_senderrbufs(str
 	if (sbuf[0] || sbuf[1] || (piobcnt > 128 && (sbuf[2] || sbuf[3]))) {
 		int i;
 		if (ipath_debug & (__IPATH_PKTDBG|__IPATH_DBG) &&
-			dd->ipath_lastcancel > jiffies) {
+			time_before(jiffies, dd->ipath_lastcancel)) {
 			__IPATH_DBG_WHICH(__IPATH_PKTDBG|__IPATH_DBG,
 					  "SendbufErrs %lx %lx", sbuf[0],
 					  sbuf[1]);
@@ -635,7 +636,7 @@ static int handle_errors(struct ipath_de
 
 	/* likely due to cancel, so suppress */
 	if ((errs & (INFINIPATH_E_SPKTLEN | INFINIPATH_E_SPIOARMLAUNCH)) &&
-		dd->ipath_lastcancel > jiffies) {
+		time_before(jiffies, dd->ipath_lastcancel)) {
 		ipath_dbg("Suppressed armlaunch/spktlen after error send cancel\n");
 		errs &= ~(INFINIPATH_E_SPIOARMLAUNCH | INFINIPATH_E_SPKTLEN);
 	}
diff -r -u -p a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
--- a/drivers/infiniband/hw/ipath/ipath_mad.c	2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c	2007-12-23 20:35:37.000000000 +0100
@@ -1334,7 +1334,8 @@ static int process_subn(struct ib_device
 	}
 
 	/* Is the mkey in the process of expiring? */
-	if (dev->mkey_lease_timeout && jiffies >= dev->mkey_lease_timeout) {
+	if (dev->mkey_lease_timeout &&
+	    time_before_eq(jiffies, dev->mkey_lease_timeout)) {
 		/* Clear timeout and mkey protection field. */
 		dev->mkey_lease_timeout = 0;
 		dev->mkeyprot = 0;
