Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYK0MUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYK0MUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYK0MTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:19:54 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:37267 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYK0MTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:19:53 -0500
Date: Thu, 27 Nov 2008 13:19:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/mtd/nand/pasemi_nand.c: Add missing pci_dev_put
Message-ID: <Pine.LNX.4.64.0811271319070.15160@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

pci_get_device increments a reference count that should be decremented
using pci_dev_put.  I have thus added an extra label in the error handling
code to do this.  I don't know, however, whether there should be a
pci_dev_put before the return 0 as well.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S,S1;
position p1,p2,p3;
expression E,E1;
type T,T1;
expression *ptr != NULL;
@@

(
 if ((x@p1 = pci_get_device(...)) == NULL) S
|
 x@p1 = pci_get_device(...);
)
 ... when != pci_dev_put(...,(T)x,...)
     when != if (...) { <+... pci_dev_put(...,(T)x,...) ...+> }
     when != true x == NULL || ...
     when != x = E
     when != E = (T)x
     when any
(
 if (x == NULL || ...) S1
|
 if@p2 (...) {
  ... when != pci_dev_put(...,(T1)x,...)
      when != if (...) { <+... pci_dev_put(...,(T1)x,...) ...+> }
      when != x = E1
      when != E1 = (T1)x
(
  return \(0\|<+...x...+>\|ptr\);
|
  return@p3 ...;
)
}
)

@ script:python @
p1 << r.p1;
p3 << r.p3;
@@

print "* file: %s pci_get_device: %s return: %s" % (p1[0].file,p1[0].line,p3[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/nand/pasemi_nand.c      |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index 75c8990..ceae196 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -144,7 +144,7 @@ static int __devinit pasemi_nand_probe(struct of_device *ofdev,
 
 	if (!request_region(lpcctl, 4, driver_name)) {
 		err = -EBUSY;
-		goto out_ior;
+		goto out_pdev;
 	}
 
 	chip->cmd_ctrl = pasemi_hwcontrol;
@@ -176,6 +176,8 @@ static int __devinit pasemi_nand_probe(struct of_device *ofdev,
 
  out_lpc:
 	release_region(lpcctl, 4);
+ out_pdev:
+	pci_dev_put(pdev);
  out_ior:
 	iounmap(chip->IO_ADDR_R);
  out_mtd:
