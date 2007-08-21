Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbXHUSpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbXHUSpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760071AbXHUSo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:44:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55674 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593AbXHUSo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:44:58 -0400
Date: Tue, 21 Aug 2007 22:45:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: taoyue <yue.tao@windriver.com>
Cc: linux-kernel@vger.kernel.org, Mark Zhan <rongkai.zhan@windriver.com>,
       Bruce Ashfield <bruce.ashfield@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG]: posix timer: slab error 'double free'
Message-ID: <20070821184516.GA139@tv-sign.ru>
References: <46CB0BE8.8010903@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CB0BE8.8010903@windriver.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(maintainers cc'ed)

On 08/21, taoyue wrote:
>
> I write a simple stress test program for posix timer subsystem, to 
> reproduce the problem in the lastest mainline kernel.
> My test program creates 200 threads, and each thread does the following job:
>
> Please see my test program in the attachemnt "posix_timer_test.c". You 
> can compile my test program via the following command line:

Now we have a testcase. Great, thanks a lot!

Unfortunately, I can't use it because my /lib/libc-2.3.3.so doesn't implement
SIGEV_THREAD (this is a user-space thing).

However,

> [<c0103941>] show_trace_log_lvl+0x1a/0x30
> [<c0104593>] show_trace+0x12/0x14
> [<c01045ab>] dump_stack+0x16/0x18
> [<c015637b>] __slab_error+0x26/0x28
> [<c0156bbf>] cache_free_debugcheck+0x1d9/0x298
> [<c0156eaa>] kmem_cache_free+0x66/0xb5
> [<c0122f4d>] __sigqueue_free+0x2f/0x32
> [<c0123147>] __dequeue_signal+0xdc/0x174
> [<c0124960>] dequeue_signal+0xbb/0x149
> [<c012569e>] sys_rt_sigtimedwait+0x7f/0x240
> [<c01029e6>] syscall_call+0x7/0xb

This is very nice trace, which says loudly that sigqueue_free() is racy
wrt collect_signal(). Very old bug, very small window.

I'll try to send the "right" fix tomorrow after sleep, but in the meanwhile,
could you please try the patch at the end?

(I am _not_ sure this can explain all problems you were seeing, though).

> And I also apply the four patches from Oleg Nesterov from lkml:
> 
> http://lkm.org/lkml/2007/8/12/193
> http://lkm.org/lkml/2007/8/12/194
> http://lkm.org/lkml/2007/8/12/195
> http://lkm.org/lkml/2007/8/12/196
         ^^^
        (should be lkml)

Please drop them, except the first one. They have nothing to do with
these problems, and in fact you apllied the wrong versions.

Thanks!

Oleg.

--- t/kernel/signal.c~	2007-08-21 22:29:25.000000000 +0400
+++ t/kernel/signal.c	2007-08-21 22:30:05.000000000 +0400
@@ -1305,7 +1305,7 @@ void sigqueue_free(struct sigqueue *q)
 	 * If the signal is still pending remove it from the
 	 * pending queue.
 	 */
-	if (unlikely(!list_empty(&q->list))) {
+	if (1) {
 		spinlock_t *lock = &current->sighand->siglock;
 		read_lock(&tasklist_lock);
 		spin_lock_irqsave(lock, flags);

