Return-Path: <linux-kernel-owner+w=401wt.eu-S933016AbXK3PwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbXK3PwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762273AbXK3Pvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:51:54 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:42741 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761824AbXK3Pvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:51:53 -0500
Date: Fri, 30 Nov 2007 16:51:50 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/macintosh/via-pmu.c: Added a missing iounmap
Message-ID: <Pine.LNX.4.64.0711301651020.26269@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The error handling code should undo the ioremap as well.

The problem was detected using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2;
constant C;
int ret;
@@

  T E;
  ...
* E = ioremap(...);
  if (E == NULL) S
  ... when != iounmap(E)
      when != if (E != NULL) { ... iounmap(E); ...}
      when != x1 = (T1)E
  if (...) {
    ... when != iounmap(E)
        when != if (E != NULL) { ... iounmap(E); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return C;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
--- a/drivers/macintosh/via-pmu.c	2007-11-18 20:43:10.000000000 +0100
+++ b/drivers/macintosh/via-pmu.c	2007-11-29 18:47:46.000000000 +0100
@@ -2336,6 +2336,7 @@ powerbook_sleep_3400(void)
 	ret = pmac_suspend_devices();
 	if (ret) {
 		pbook_free_pci_save();
+		iounmap(mem_ctrl);
 		printk(KERN_ERR "Sleep rejected by devices\n");
 		return ret;
 	}
