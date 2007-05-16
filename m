Return-Path: <linux-kernel-owner+w=401wt.eu-S1763028AbXEPW4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763028AbXEPW4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbXEPW4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:56:08 -0400
Received: from mail.screens.ru ([213.234.233.54]:45985 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbXEPW4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:56:07 -0400
Date: Thu, 17 May 2007 02:55:43 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zilvinas@wilibox.com, linux-kernel@vger.kernel.org
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux 2.6.22-rc1 + CFS v12)
Message-ID: <20070516225543.GA337@tv-sign.ru>
References: <1179338441.4265.13.camel@zv.wilibox.com> <20070516121538.7b108c10.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516121538.7b108c10.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 21:00:41 +0300
Zilvinas Valinskas <zilvinas@wilibox.com> wrote:
> 
> In short, on shutdown my laptop is always freezing now. I was able to
> capture the 'sysrq-P' (hit that several times), sysrq-T outputs. Please
> see .config and log messages at http://barclay.balt.net/~zilvinas/oops/ 
> 
> Kernel version I had built according git is :
> 
> zilvinas@zv:/projects/linux-amd64.git$ git describe HEAD
> v2.6.22-rc1-29-gfaa8b6c
> 
> On top of that I have CFS v12 applied (no other changes otherwise).
> Please note that there is ''fglrx.ko'' loaded and kernel is tainted
> because of that (feel free to ignore the report ...).
> 
> Anyway, 'sysrq-P' always show that PC is stuck at (NFS lockd?) and it is
> always the same backtrace is shown. 'sysrq-t' output is in
> 'kernel-nfs-freeze.log' file (did not want to post it here).
> 
>  Pid: 3652, comm: lockd Tainted: P       2.6.22-rc1-cfs-v12 #1
> 
> [<ffffffff8024a5a0>] wq_barrier_func+0x0/0x10
> [<ffffffff8024a7e5>] destroy_workqueue+0x75/0xa0
> [<ffffffff8833cd34>] :sunrpc:rpciod_down+0xf4/0x170
> [<ffffffff8836dd74>] :lockd:lockd+0x244/0x300
> [<ffffffff80233e1f>] schedule_tail+0x3f/0xb0
> [<ffffffff8020b0f8>] child_rip+0xa/0x12
> [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> [<ffffffff8020b0ee>] child_rip+0x0/0x12
> 
> Hope this helps. Thanks in advance for any advice how to solve problem !
> For now I am back to '2.6.21.1-cfs-v10'.
> 

Nice, thanks.

Zilvinas, could you try the patch below?

It is a shot in the dark. I hope I'll suggest somethimg better tomorrow.

Oleg.

--- OLD/kernel/workqueue.c~	2007-05-17 00:15:37.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-05-17 02:51:15.000000000 +0400
@@ -752,16 +752,25 @@ static void cleanup_workqueue_thread(str
 	spin_unlock_irq(&cwq->lock);
 
 	if (alive) {
+		int n;
+
 		wait_for_completion(&barr.done);
 
-		while (unlikely(cwq->thread != NULL))
-			cpu_relax();
-		/*
-		 * Wait until cwq->thread unlocks cwq->lock,
-		 * it won't touch *cwq after that.
-		 */
-		smp_rmb();
-		spin_unlock_wait(&cwq->lock);
+		for (n = 0;; ++n) {
+			spin_lock_irq(&cwq->lock);
+			alive = (cwq->thread != NULL);
+			spin_unlock_irq(&cwq->lock);
+
+			if (!alive)
+				break;
+
+			if (n > 1000) {
+				printk(KERN_CRIT "ERR!! wq: %s\n", cwq->wq->name);
+				break;
+			}
+
+			yield();
+		}
 	}
 }
 

