Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbYLAWBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbYLAWBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYLAWA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:00:59 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34260 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYLAWA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:00:58 -0500
Date: Mon, 1 Dec 2008 23:00:55 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       olof@lixom.net
Subject: [PATCH retry] drivers/mtd/nand/pasemi_nand.c: Add missing pci_dev_put
Message-ID: <Pine.LNX.4.64.0812012259590.1541@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

pci_get_device increments a reference count that should be decremented
using pci_dev_put.

The semantic patch that finds the problem is as follows:
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
 drivers/mtd/nand/pasemi_nand.c      |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index 75c8990..9bd6c9a 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -141,6 +141,7 @@ static int __devinit pasemi_nand_probe(struct of_device *ofdev,
 	}
 
 	lpcctl = pci_resource_start(pdev, 0);
+	pci_dev_put(pdev);
 
 	if (!request_region(lpcctl, 4, driver_name)) {
 		err = -EBUSY;
