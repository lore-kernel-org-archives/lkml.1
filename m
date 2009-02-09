Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZBIQqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZBIQqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZBIQqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:46:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZBIQqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:46:14 -0500
Subject: Re: mm_alloc()'ed structure leak
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <1234192363.5951.129.camel@laptop>
References: <1234181898.16083.26.camel@pc1117.cambridge.arm.com>
	 <1234190649.16083.44.camel@pc1117.cambridge.arm.com>
	 <1234192363.5951.129.camel@laptop>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 17:45:50 +0100
Message-Id: <1234197950.5951.132.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 16:12 +0100, Peter Zijlstra wrote:
> On Mon, 2009-02-09 at 14:44 +0000, Catalin Marinas wrote:
> > On Mon, 2009-02-09 at 12:18 +0000, Catalin Marinas wrote:
> > > Basically bash forks and executes a command like "host kernel.org" which
> > > finishes normally but the corresponding mm_struct isn't freed (I get
> > > this consistently every time I run the above command):
> > > 
> > > unreferenced object 0xcfed4070 (size 368):
> > >   comm "bash", pid 1674, jiffies 421592
> > >   backtrace:
> > >     [<c0082bd4>] kmemleak_alloc+0x140/0x2b0
> > >     [<c007ff2c>] kmem_cache_alloc+0xd0/0x100
> > >     [<c0036980>] mm_alloc+0x14/0x44
> > >     [<c008a99c>] bprm_mm_init+0xc/0x13c
> > >     [<c008ab70>] do_execve+0xa4/0x218
> > >     [<c002718c>] sys_execve+0x34/0x54
> > >     [<c0023e80>] ret_fast_syscall+0x0/0x28
> > 
> > Dumping the object in question:
> > 
> > mm_struct.mm_users = 0
> > mm_struct.mm_count = 1
> > 
> > It looks like the mm_count didn't get to 0 hence no structure freeing
> > via mmdrop().
> > 
> > The leak disappears if I revert commit 38d47c1b7075 - "futex: rely on
> > get_user_pages() for shared futexes". Peter, any idea?
> 
> Looks like the futex key references go wrong somewhere, I'll go look at
> it.

How does this work for you?

Not-signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/futex.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f89d373..4aecf77 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -55,6 +55,7 @@
 #include <linux/magic.h>
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
+#include <linux/ftrace.h>
 
 #include <asm/futex.h>
 
@@ -156,9 +157,15 @@ static void get_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
+		ftrace_printk("(%lx:%x) inode++: %p\n", 
+				key->both.word, key->both.offset & ~3,
+				&key->shared.inode);
 		atomic_inc(&key->shared.inode->i_count);
 		break;
 	case FUT_OFF_MMSHARED:
+		ftrace_printk("(%lx:%x) mm++: %p\n", 
+				key->both.word, key->both.offset & ~3,
+				&key->shared.inode);
 		atomic_inc(&key->private.mm->mm_count);
 		break;
 	}
@@ -178,9 +185,15 @@ static void drop_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
+		ftrace_printk("(%lx:%x) inode--: %p\n", 
+				key->both.word, key->both.offset & ~3,
+				&key->shared.inode);
 		iput(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
+		ftrace_printk("(%lx:%x) mm--: %p\n", 
+				key->both.word, key->both.offset & ~3,
+				&key->shared.inode);
 		mmdrop(key->private.mm);
 		break;
 	}
@@ -1284,17 +1297,20 @@ retry:
 	 */
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
+	ret = 0;
 	if (!unqueue_me(&q))
-		return 0;
+		goto out_put_key;
+	ret = -ETIMEDOUT;
 	if (rem)
-		return -ETIMEDOUT;
+		goto out_put_key;
 
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
+	ret = -ERESTARTSYS;
 	if (!abs_time)
-		return -ERESTARTSYS;
+		goto out_put_key;
 	else {
 		struct restart_block *restart;
 		restart = &current_thread_info()->restart_block;
@@ -1309,11 +1325,13 @@ retry:
 			restart->futex.flags |= FLAGS_SHARED;
 		if (clockrt)
 			restart->futex.flags |= FLAGS_CLOCKRT;
-		return -ERESTART_RESTARTBLOCK;
+		ret = -ERESTARTSYS;
+		goto out_put_key;
 	}
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
+out_put_key:
 	put_futex_key(fshared, &q.key);
 
 out:


