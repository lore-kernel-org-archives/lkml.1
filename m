Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbXLDKLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbXLDKLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXLDKKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:10:53 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59880 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbXLDKKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:10:52 -0500
Date: Tue, 4 Dec 2007 11:10:46 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: olof@lixom.net, paulus@samba.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/powerpc: Add missing of_node_put
Message-ID: <Pine.LNX.4.64.0712041109560.23712@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There should be an of_node_put when breaking out of a loop that iterates
over calls to of_find_all_nodes, as this function does an of_node_get on
the value it returns.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier d;
expression e;
@@

T *d;
...
for (d = NULL; (d = of_find_all_nodes(d)) != NULL; )
 {... when != of_node_put(d)
      when != e = d
(
   return d;
|
+  of_node_put(d);
?  return ...;
)
...}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/arch/powerpc/platforms/iseries/iommu.c b/arch/powerpc/platforms/iseries/iommu.c
--- a/arch/powerpc/platforms/iseries/iommu.c	2007-12-01 17:56:55.000000000 +0100
+++ b/arch/powerpc/platforms/iseries/iommu.c	2007-12-02 16:39:23.000000000 +0100
@@ -163,8 +163,10 @@ static struct iommu_table *iommu_table_f
 		    (it->it_type == TCE_PCI) &&
 		    (it->it_offset == tbl->it_offset) &&
 		    (it->it_index == tbl->it_index) &&
-		    (it->it_size == tbl->it_size))
+		    (it->it_size == tbl->it_size)) {
+			of_node_put(node);
 			return it;
+		}
 	}
 	return NULL;
 }
