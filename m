Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbYCLJZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbYCLJZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYCLJZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:25:27 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:36046 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYCLJZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:25:26 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG() at mnt_want_write().
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, penguin-kernel@i-love.sakura.ne.jp,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <20080311202212.9fe1e5c1.akpm@linux-foundation.org>
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp>
	 <1205291010.9828.60.camel@nimitz.home.sr71.net>
	 <20080311202212.9fe1e5c1.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 10:25:18 +0100
Message-Id: <1205313918.8514.215.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 20:22 -0700, Andrew Morton wrote:
> On Tue, 11 Mar 2008 20:03:30 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:
> 
> > On Wed, 2008-03-12 at 10:37 +0900, penguin-kernel@i-love.sakura.ne.jp
> > ...
> > > checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> > > Brought up 2 CPUs
> > > khelper used greatest stack depth: 2684 bytes left
> > > net_namespace: 320 bytes
> > > NET: Registered protocol family 16
> > > INFO: trying to register non-static key.

It means the lock_class_key ended up in non-static storage.

In practise it often means you initialized a on-stack structure
incorrectly. DECLARE_WAIT_QUEUE_HEAD() vs
DECLARE_WAIT_QUEUE_HEAD_ONSTACK() for example.

> > > the code is fine but needs lockdep annotation.
> > > turning off the locking correctness validator.
> > > Pid: 1, comm: swapper Not tainted 2.6.25-rc5-mm1 #1
> > >  [<c013dd91>] __lock_acquire+0x194/0x6a3
> > >  [<c0167ded>] ? cache_free_debugcheck+0x1fd/0x219
> > >  [<c0168938>] ? kfree+0xdb/0xe5
> > >  [<c013e775>] lock_acquire+0x6a/0x87
> > >  [<c01368e4>] ? down+0xc/0x2f
> > >  [<c03492b1>] _spin_lock_irqsave+0x25/0x55
> > >  [<c01368e4>] ? down+0xc/0x2f
> > >  [<c01368e4>] down+0xc/0x2f
> > >  [<c022caf3>] device_add+0x152/0x243
> > >  [<c022cbf6>] device_register+0x12/0x15
> > >  [<c022ce9b>] device_create+0x76/0x90
> > >  [<c04a1861>] vtconsole_class_init+0x72/0xb9
> > >  [<c048d8ae>] ? kernel_init+0x0/0x88
> > >  [<c048d784>] do_initcalls+0x59/0x134
> > >  [<c014bcb1>] ? register_irq_proc+0xb1/0xca
> > >  [<c01a0000>] ? proc_symlink+0x5/0x73
> > >  [<c048d8ae>] ? kernel_init+0x0/0x88
> > >  [<c048d87b>] do_basic_setup+0x1c/0x1e
> > >  [<c048d8fb>] kernel_init+0x4d/0x88
> > >  [<c01045b7>] kernel_thread_helper+0x7/0x10
> > >  =======================
> > 

/me & git fetch mm && git checkout mm/v2.6.25-rc5-mm1

/me twiddles thumbs..

/me tries to untangle the sysfs stuff, finds nothing wrong, looks at
semaphore code, and.. the winner is: Matthew messed up the semaphores.

Tssk, rewriting locking primitives and not using lockdep...

Compile tested defconfig with lockdep and !lockdep.

---
Subject: lockdep: fixup the new semaphore implementation

The new semaphores failed to properly initialize its spinlock. Non
static spinlocks should use spin_lock_init(). Alternatively you should
supply a static key yourself.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/semaphore.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/include/linux/semaphore.h
===================================================================
--- linux-2.6.orig/include/linux/semaphore.h
+++ linux-2.6/include/linux/semaphore.h
@@ -41,7 +41,11 @@ struct semaphore {
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
+	static struct lock_class_key __key;
+
 	*sem = (struct semaphore) __SEMAPHORE_INITIALIZER(*sem, val);
+
+	lockdep_init_map(&sem->lock.dep_map, "semaphore->lock", &__key, 0);
 }
 
 #define init_MUTEX(sem)		sema_init(sem, 1)


