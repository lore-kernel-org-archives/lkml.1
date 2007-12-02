Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbXLBUEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbXLBUEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXLBUEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:04:10 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:37624 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbXLBUEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:04:08 -0500
Date: Sun, 2 Dec 2007 21:04:05 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] arch/powerpc: Add missing of_node_put
Message-ID: <Pine.LNX.4.64.0712022101010.3361@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There should be an of_node_put when breaking out of a loop that iterates
using for_each_node_by_type.

This was detected and fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
identifier d;
type T;
expression e;
iterator for_each_node_by_type;
@@

T *d;
...
for_each_node_by_type(d,...)
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

diff -u -p a/arch/powerpc/platforms/cell/cbe_regs.c b/arch/powerpc/platforms/cell/cbe_regs.c
--- a/arch/powerpc/platforms/cell/cbe_regs.c 2007-10-22 11:24:59.000000000 +0200
+++ b/arch/powerpc/platforms/cell/cbe_regs.c 2007-12-02 17:40:26.000000000 +0100
@@ -256,6 +256,7 @@ void __init cbe_regs_init(void)
 			printk(KERN_ERR "cbe_regs: More BE chips than supported"
 			       "!\n");
 			cbe_regs_map_count--;
+			of_node_put(cpu);
 			return;
 		}
 		map->cpu_node = cpu;
