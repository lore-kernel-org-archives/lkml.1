Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZBHVoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZBHVoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZBHVoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:44:20 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55153 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbZBHVoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:44:19 -0500
Date: Sun, 8 Feb 2009 22:44:16 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: davem@davemloft.net, netdev@vger.kernel.org, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/6] drivers/atm: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0902082243200.25891@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/atm/solos-pci.c             |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 72fc0f7..89d7a6e 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -685,6 +685,7 @@ static int fpga_probe(struct pci_dev *dev, const struct pci_device_id *id)
  out_release_regions:
 	pci_release_regions(dev);
  out:
+	kfree(card);
 	return err;
 }
 
