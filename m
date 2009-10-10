Return-Path: <linux-kernel-owner+w=401wt.eu-S964879AbZJJPjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbZJJPjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbZJJPjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:39:44 -0400
Received: from www.tglx.de ([62.245.132.106]:55681 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934412AbZJJPjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:39:31 -0400
Message-Id: <20091010153349.154442560@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:35:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/28] net: Remove BKL from tun
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=drivers-net-tun-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock_kernel/unlock_kernel() in cycle_kernel_lock() which is called
in tun_chr_open() is not serializing against anything and safe to
remove.

tun_chr_fasync() is serialized by get/put_tun() and fasync_helper()
has no dependency on BKL. The modification of tun->flags is racy with
and without the BKL so removing it does not make it worse.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>

---
 drivers/net/tun.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6-tip/drivers/net/tun.c
===================================================================
--- linux-2.6-tip.orig/drivers/net/tun.c
+++ linux-2.6-tip/drivers/net/tun.c
@@ -44,7 +44,6 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
 #include <linux/init.h>
@@ -1285,7 +1284,6 @@ static int tun_chr_fasync(int fd, struct
 
 	DBG(KERN_INFO "%s: tun_chr_fasync %d\n", tun->dev->name, on);
 
-	lock_kernel();
 	if ((ret = fasync_helper(fd, file, on, &tun->fasync)) < 0)
 		goto out;
 
@@ -1298,7 +1296,6 @@ static int tun_chr_fasync(int fd, struct
 		tun->flags &= ~TUN_FASYNC;
 	ret = 0;
 out:
-	unlock_kernel();
 	tun_put(tun);
 	return ret;
 }
@@ -1306,7 +1303,7 @@ out:
 static int tun_chr_open(struct inode *inode, struct file * file)
 {
 	struct tun_file *tfile;
-	cycle_kernel_lock();
+
 	DBG1(KERN_INFO "tunX: tun_chr_open\n");
 
 	tfile = kmalloc(sizeof(*tfile), GFP_KERNEL);


