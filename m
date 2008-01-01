Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYAAVFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYAAVFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYAAVFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:05:21 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:39546 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbYAAVFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:05:19 -0500
Date: Tue, 1 Jan 2008 22:04:56 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: paulus@samba.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] arch/powerpc/sysdev: Add missing of_node_put
Message-ID: <Pine.LNX.4.64.0801012203561.19803@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions of_find_compatible_node and of_find_node_by_type both call
of_node_get on their result.  So any error handling code thereafter should
call of_node_put(np).  This is taken care of in the case where there is a goto
out, but not when there is a direct return.

The function irq_alloc_host puts np into the returned structure, which is
stored in the global variable mpc8xx_pic_host, so the reference count
should be set for the lifetime of that variable.  The current solution ups
the reference count again in the argument to irq_alloc_host so that it can
be decremented on the way out.  This seems a bit unnecessary, and also
doesn't work in the case where irq_alloc_host fails, because then the
reference count only goes does by one, whereas it should go down by two.  A
better solution is to not increment the reference count in the argument to
irq_alloc_host and only decrement it on the way out in an error case.

The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2,x3;
int ret;
@@

  T E;
  ...
* E = \(of_get_parent\|of_find_compatible_node\)(...);
  if (E == NULL) S
  ... when != of_node_put(...,(T1)E,...)
      when != if (E != NULL) { ... of_node_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (...) {
    ... when != of_node_put(...,(T2)E,...)
        when != if (E != NULL) { ... of_node_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/arch/powerpc/sysdev/mpc8xx_pic.c b/arch/powerpc/sysdev/mpc8xx_pic.c
--- a/arch/powerpc/sysdev/mpc8xx_pic.c	2008-01-01 13:42:21.000000000 +0100
+++ b/arch/powerpc/sysdev/mpc8xx_pic.c	2008-01-01 14:37:45.000000000 +0100
@@ -175,15 +175,19 @@ int mpc8xx_pic_init(void)
 		goto out;
 
 	siu_reg = ioremap(res.start, res.end - res.start + 1);
-	if (siu_reg == NULL)
-		return -EINVAL;
+	if (siu_reg == NULL) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	mpc8xx_pic_host = irq_alloc_host(of_node_get(np), IRQ_HOST_MAP_LINEAR,
+	mpc8xx_pic_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
 					 64, &mpc8xx_pic_host_ops, 64);
 	if (mpc8xx_pic_host == NULL) {
 		printk(KERN_ERR "MPC8xx PIC: failed to allocate irq host!\n");
 		ret = -ENOMEM;
+		goto out;
 	}
+	return 0;
 
 out:
 	of_node_put(np);
