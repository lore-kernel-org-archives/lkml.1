Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbZHAI7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbZHAI7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZHAI7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 04:59:18 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36888 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZHAI7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 04:59:17 -0400
Date: Sat, 1 Aug 2009 10:53:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/10] arch/powerpc: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0908011052510.23408@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds the problem is as follows:
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
 arch/powerpc/sysdev/ipic.c          |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index 69e2630..040144e 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -735,8 +735,10 @@ struct ipic * __init ipic_init(struct device_node *node, unsigned int flags)
 	ipic->irqhost = irq_alloc_host(node, IRQ_HOST_MAP_LINEAR,
 				       NR_IPIC_INTS,
 				       &ipic_host_ops, 0);
-	if (ipic->irqhost == NULL)
+	if (ipic->irqhost == NULL) {
+		kfree(ipic);
 		return NULL;
+	}
 
 	ipic->regs = ioremap(res.start, res.end - res.start + 1);
 
