Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbXLBUAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbXLBUAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbXLBUAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:00:43 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:37283 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbXLBUAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:00:42 -0500
Date: Sun, 2 Dec 2007 21:00:38 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Subject: [PATCH] arch/powerpc/platforms/powermac: Drop unneeded
 of_node_put
Message-ID: <Pine.LNX.4.64.0712022058570.3361@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

After using for_each_node_by_name, there is no need for of_node_put unless
there was a break in the loop body, as for_each_node_by_name does a
of_node_put on each of the elements it returns.

This was detected and fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
iterator for_each_node_by_name;
expression d;
@@

  for_each_node_by_name(d,...) {
    ... when != break;
  }
  ... when != d
?- of_node_put(d);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
--- a/arch/powerpc/platforms/powermac/feature.c 2007-08-12 13:27:05.000000000 +0200
+++ b/arch/powerpc/platforms/powermac/feature.c 2007-12-02 17:16:04.000000000 +0100
@@ -2861,7 +2861,6 @@ set_initial_features(void)
 				core99_airport_enable(np, 0, 0);
 			}
 		}
-		of_node_put(np);
 	}
 
 	/* On all machines that support sound PM, switch sound off */
diff -u -p a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
--- a/arch/powerpc/platforms/powermac/pci.c 2007-10-22 11:24:59.000000000 +0200
+++ b/arch/powerpc/platforms/powermac/pci.c 2007-12-02 17:16:05.000000000 +0100
@@ -1162,13 +1162,11 @@ void __init pmac_pcibios_after_init(void
 			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, nd, 0, 0);
 		}
 	}
-	of_node_put(nd);
 	for_each_node_by_name(nd, "ethernet") {
 		if (nd->parent && of_device_is_compatible(nd, "gmac")
 		    && of_device_is_compatible(nd->parent, "uni-north"))
 			pmac_call_feature(PMAC_FTR_GMAC_ENABLE, nd, 0, 0);
 	}
-	of_node_put(nd);
 }
 
 #ifdef CONFIG_PPC32
