Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZKULvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZKULvA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 06:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZKULu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 06:50:59 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38434 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZKULu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 06:50:58 -0500
Date: Sat, 21 Nov 2009 12:51:02 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/8] drivers/edac: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0911211250370.23681@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
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
 drivers/edac/i7core_edac.c          |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index e944b63..4de5a18 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1215,8 +1215,10 @@ int i7core_get_onedevice(struct pci_dev **prev, int devno,
 			return -ENOMEM;
 		i7core_dev->pdev = kzalloc(sizeof(*i7core_dev->pdev) * n_devs,
 					   GFP_KERNEL);
-		if (!i7core_dev->pdev)
+		if (!i7core_dev->pdev) {
+			kfree(i7core_dev);
 			return -ENOMEM;
+		}
 		i7core_dev->socket = socket;
 		i7core_dev->n_devs = n_devs;
 		list_add_tail(&i7core_dev->list, &i7core_edac_list);
