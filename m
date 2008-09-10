Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbYIJL6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbYIJL6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYIJL5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:57:39 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:52226 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbYIJL5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:57:24 -0400
Date: Wed, 10 Sep 2008 13:57:19 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] arch/ia64/sn/pci/tioca_provider.c: introduce missing
 kfree
Message-ID: <Pine.LNX.4.64.0809101356590.15308@pc-004.diku.dk>
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
 arch/ia64/sn/pci/tioca_provider.c   |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
index 529462c..7916512 100644
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -420,8 +420,10 @@ tioca_dma_mapped(struct pci_dev *pdev, u64 paddr, size_t req_size)
 		entry = find_next_zero_bit(map, mapsize, last_entry);
 	}
 
-	if (entry > mapsize)
+	if (entry > mapsize) {
+		kfree(ca_dmamap);
 		goto map_return;
+	}
 
 	for (i = 0; i < entries; i++)
 		set_bit(entry + i, map);
