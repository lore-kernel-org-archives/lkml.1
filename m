Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYFOJwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYFOJwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 05:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbYFOJwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 05:52:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:2166 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbYFOJwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 05:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UFpn3CXVi1OZ9k0Ln//icEolDf2p8wO2A2sdA8EYK6v7Gp5tMcs0zVLZUwoCnVtjl4
         7F4AES8atxGxh7ANLgRDryWLflOh0bb/EtXaUF7gtzzLgDzUu5/mAm9Gz84F8kJ9O1BO
         PN2GY1c/PAbNEkiFnTvUjyma5RBhC41p7YkaU=
Message-ID: <6278d2220806150252h10230d2s775913c75d16b793@mail.gmail.com>
Date: Sun, 15 Jun 2008 10:52:35 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH] debugobjects: fix lockdep warning
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Lameter" <clameter@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20080614225826.GA8211@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080614225826.GA8211@damson.getinternet.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 11:58 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> I don't know whether this is truly the Right Fix; if it isn't, feel free
> to re-use my commit template for when the RF appears... ;-)
>
> Daniel, is there any chance you can try it out? Thanks.

I get a warning [1] about pool-lock being IRQ-unsafe as-is.
Additionally promoting pool_lock to be IRQ-safe [2] resolves the
issue, but this may not be desired. Ping me for further tests and
thanks!

Daniel

> Vegard
>
>
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sun, 15 Jun 2008 00:47:36 +0200
> Subject: [PATCH] debugobjects: fix lockdep warning
>
> Daniel J Blueman reported:
> | =======================================================
> | [ INFO: possible circular locking dependency detected ]
> | 2.6.26-rc5-201c #1
> | -------------------------------------------------------
> | nscd/3669 is trying to acquire lock:
> |  (&n->list_lock){.+..}, at: [<ffffffff802bab03>] deactivate_slab+0x173/0x1e0
> |
> | but task is already holding lock:
> |  (&obj_hash[i].lock){++..}, at: [<ffffffff803fa56f>]
> | __debug_object_init+0x2f/0x350
> |
> | which lock already depends on the new lock.
>
> There are two locks involved here; the first is a SLUB-local lock, and
> the second is a debugobjects-local lock. They are basically taken in two
> different orders:
>
> 1. SLUB { debugobjects { ... } }
> 2. debugobjects { SLUB { ... } }
>
> This patch changes pattern #2 by trying to fill the memory pool (e.g.
> the call into SLUB/kmalloc()) outside the debugobjects lock, so now the
> two patterns look like this:
>
> 1. SLUB { debugobjects { ... } }
> 2. SLUB { } debugobjects { ... }
>
> Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  lib/debugobjects.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index a76a5e1..19acf8c 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -110,16 +110,13 @@ static struct debug_obj *lookup_object(void *addr, struct debug_bucket *b)
>  }
>
>  /*
> - * Allocate a new object. If the pool is empty and no refill possible,
> - * switch off the debugger.
> + * Allocate a new object. If the pool is empty, switch off the debugger.
>  */
>  static struct debug_obj *
>  alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
>  {
>        struct debug_obj *obj = NULL;
> -       int retry = 0;
>
> -repeat:
>        spin_lock(&pool_lock);
>        if (obj_pool.first) {
>                obj         = hlist_entry(obj_pool.first, typeof(*obj), node);
> @@ -141,9 +138,6 @@ repeat:
>        }
>        spin_unlock(&pool_lock);
>
> -       if (fill_pool() && !obj && !retry++)
> -               goto repeat;
> -
>        return obj;
>  }
>
> @@ -261,6 +255,8 @@ __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
>        struct debug_obj *obj;
>        unsigned long flags;
>
> +       fill_pool();
> +
>        db = get_bucket((unsigned long) addr);
>
>        spin_lock_irqsave(&db->lock, flags);

--- [1]

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.26-rc6-202c #2
---------------------------------------------------------
start-stop-daem/3154 just changed the state of lock:
 (pool_lock){-+..}, at: [<ffffffff803fa921>] __debug_object_init+0x221/0x330
but this lock was taken by another, hard-irq-safe lock in the past:
 (&obj_hash[i].lock){++..}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
no locks held by start-stop-daem/3154.

the first lock's dependencies:
-> (pool_lock){-+..} ops: 0 {
   initial-use  at:
                                       [<ffffffff802783ed>]
__lock_acquire+0x17d/0x1020
                                       [<ffffffff802792f5>]
lock_acquire+0x65/0x90
                                       [<ffffffff805e1031>] _spin_lock+0x31/0x60
                                       [<ffffffff803fa7e3>]
__debug_object_init+0xe3/0x330
                                       [<ffffffff803faa79>]
debug_object_init+0x19/0x20
                                       [<ffffffff8026ca09>]
hrtimer_init+0x29/0x50
                                       [<ffffffff80821723>]
sched_init+0x83/0x370
                                       [<ffffffff80812e09>]
start_kernel+0x189/0x3c0
                                       [<ffffffff80812414>]
x86_64_start_kernel+0x214/0x270
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   in-softirq-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   hardirq-on-W at:
                                       [<ffffffff802785c0>]
__lock_acquire+0x350/0x1020
                                       [<ffffffff802792f5>]
lock_acquire+0x65/0x90
                                       [<ffffffff805e1031>] _spin_lock+0x31/0x60
                                       [<ffffffff803fa921>]
__debug_object_init+0x221/0x330
                                       [<ffffffff803faa79>]
debug_object_init+0x19/0x20
                                       [<ffffffff8025d978>] init_timer+0x18/0x30
                                       [<ffffffff805223ac>]
sock_init_data+0xcc/0x280
                                       [<ffffffff805a3c3c>]
unix_create1+0x8c/0x180
                                       [<ffffffff805a487f>]
unix_stream_connect+0x7f/0x400
                                       [<ffffffff8051daf1>]
sys_connect+0x71/0xa0
                                       [<ffffffff802264ab>]
system_call_after_swapgs+0x7b/0x80
                                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff807896f8>] pool_lock+0x18/0x40

the second lock's dependencies:
-> (&obj_hash[i].lock){++..} ops: 0 {
   initial-use  at:
                                       [<ffffffff802783ed>]
__lock_acquire+0x17d/0x1020
                                       [<ffffffff802792f5>]
lock_acquire+0x65/0x90
                                       [<ffffffff805e1417>]
_spin_lock_irqsave+0x47/0x80
                                       [<ffffffff803fa742>]
__debug_object_init+0x42/0x330
                                       [<ffffffff803faa79>]
debug_object_init+0x19/0x20
                                       [<ffffffff8026ca09>]
hrtimer_init+0x29/0x50
                                       [<ffffffff80821723>]
sched_init+0x83/0x370
                                       [<ffffffff80812e09>]
start_kernel+0x189/0x3c0
                                       [<ffffffff80812414>]
x86_64_start_kernel+0x214/0x270
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   in-hardirq-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   in-softirq-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff80cdef90>] __key.16362+0x0/0x8
 -> (pool_lock){-+..} ops: 0 {
    initial-use  at:
                                         [<ffffffff802783ed>]
__lock_acquire+0x17d/0x1020
                                         [<ffffffff802792f5>]
lock_acquire+0x65/0x90
                                         [<ffffffff805e1031>]
_spin_lock+0x31/0x60
                                         [<ffffffff803fa7e3>]
__debug_object_init+0xe3/0x330
                                         [<ffffffff803faa79>]
debug_object_init+0x19/0x20
                                         [<ffffffff8026ca09>]
hrtimer_init+0x29/0x50
                                         [<ffffffff80821723>]
sched_init+0x83/0x370
                                         [<ffffffff80812e09>]
start_kernel+0x189/0x3c0
                                         [<ffffffff80812414>]
x86_64_start_kernel+0x214/0x270
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-W at:
                                         [<ffffffff802785c0>]
__lock_acquire+0x350/0x1020
                                         [<ffffffff802792f5>]
lock_acquire+0x65/0x90
                                         [<ffffffff805e1031>]
_spin_lock+0x31/0x60
                                         [<ffffffff803fa921>]
__debug_object_init+0x221/0x330
                                         [<ffffffff803faa79>]
debug_object_init+0x19/0x20
                                         [<ffffffff8025d978>]
init_timer+0x18/0x30
                                         [<ffffffff805223ac>]
sock_init_data+0xcc/0x280
                                         [<ffffffff805a3c3c>]
unix_create1+0x8c/0x180
                                         [<ffffffff805a487f>]
unix_stream_connect+0x7f/0x400
                                         [<ffffffff8051daf1>]
sys_connect+0x71/0xa0
                                         [<ffffffff802264ab>]
system_call_after_swapgs+0x7b/0x80
                                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff807896f8>] pool_lock+0x18/0x40
 ... acquired at:
   [<ffffffff80278e4d>] __lock_acquire+0xbdd/0x1020
   [<ffffffff802792f5>] lock_acquire+0x65/0x90
   [<ffffffff805e1031>] _spin_lock+0x31/0x60
   [<ffffffff803fa7e3>] __debug_object_init+0xe3/0x330
   [<ffffffff803faa79>] debug_object_init+0x19/0x20
   [<ffffffff8026ca09>] hrtimer_init+0x29/0x50
   [<ffffffff80821723>] sched_init+0x83/0x370
   [<ffffffff80812e09>] start_kernel+0x189/0x3c0
   [<ffffffff80812414>] x86_64_start_kernel+0x214/0x270
   [<ffffffffffffffff>] 0xffffffffffffffff


stack backtrace:
Pid: 3154, comm: start-stop-daem Not tainted 2.6.26-rc6-202c #2

Call Trace:
 [<ffffffff802764ac>] print_irq_inversion_bug+0x13c/0x160
 [<ffffffff8027745a>] check_usage_backwards+0x4a/0x60
 [<ffffffff802778b7>] mark_lock+0x347/0x5e0
 [<ffffffff802785c0>] __lock_acquire+0x350/0x1020
 [<ffffffff802bbb70>] ? __slab_alloc+0xc0/0x550
 [<ffffffff803fa977>] ? __debug_object_init+0x277/0x330
 [<ffffffff802bc185>] ? kmem_cache_alloc+0xa5/0xd0
 [<ffffffff802792f5>] lock_acquire+0x65/0x90
 [<ffffffff803fa921>] ? __debug_object_init+0x221/0x330
 [<ffffffff805e1031>] _spin_lock+0x31/0x60
 [<ffffffff803fa921>] __debug_object_init+0x221/0x330
 [<ffffffff803faa79>] debug_object_init+0x19/0x20
 [<ffffffff8025d978>] init_timer+0x18/0x30
 [<ffffffff805223ac>] sock_init_data+0xcc/0x280
 [<ffffffff805a3c3c>] unix_create1+0x8c/0x180
 [<ffffffff805a487f>] unix_stream_connect+0x7f/0x400
 [<ffffffff8051daf1>] sys_connect+0x71/0xa0
 [<ffffffff802264ab>] system_call_after_swapgs+0x7b/0x80

--- [2]

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a76a5e1..91109e8 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -66,6 +66,8 @@ static const char *obj_states[ODEBUG_STATE_MAX] = {

 static int fill_pool(void)
 {
+	unsigned long flags;
+
 	gfp_t gfp = GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
 	struct debug_obj *new;

@@ -81,10 +83,10 @@ static int fill_pool(void)
 		if (!new)
 			return obj_pool_free;

-		spin_lock(&pool_lock);
+		spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&new->node, &obj_pool);
 		obj_pool_free++;
-		spin_unlock(&pool_lock);
+		spin_unlock_irqrestore(&pool_lock, flags);
 	}
 	return obj_pool_free;
 }
@@ -117,10 +119,9 @@ static struct debug_obj *
 alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 {
 	struct debug_obj *obj = NULL;
-	int retry = 0;
+	unsigned long flags;

-repeat:
-	spin_lock(&pool_lock);
+	spin_lock_irqsave(&pool_lock, flags);
 	if (obj_pool.first) {
 		obj	    = hlist_entry(obj_pool.first, typeof(*obj), node);

@@ -139,10 +140,7 @@ repeat:
 		if (obj_pool_free < obj_pool_min_free)
 			obj_pool_min_free = obj_pool_free;
 	}
-	spin_unlock(&pool_lock);
-
-	if (fill_pool() && !obj && !retry++)
-		goto repeat;
+	spin_unlock_irqrestore(&pool_lock, flags);

 	return obj;
 }
@@ -153,17 +151,18 @@ repeat:
 static void free_object(struct debug_obj *obj)
 {
 	unsigned long idx = (unsigned long)(obj - obj_static_pool);
+	unsigned long flags;

 	if (obj_pool_free < ODEBUG_POOL_SIZE || idx < ODEBUG_POOL_SIZE) {
-		spin_lock(&pool_lock);
+		spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&obj->node, &obj_pool);
 		obj_pool_free++;
 		obj_pool_used--;
-		spin_unlock(&pool_lock);
+		spin_unlock_irqrestore(&pool_lock, flags);
 	} else {
-		spin_lock(&pool_lock);
+		spin_lock_irqsave(&pool_lock, flags);
 		obj_pool_used--;
-		spin_unlock(&pool_lock);
+		spin_unlock_irqrestore(&pool_lock, flags);
 		kmem_cache_free(obj_cache, obj);
 	}
 }
@@ -261,6 +260,8 @@ __debug_object_init(void *addr, struct
debug_obj_descr *descr, int onstack)
 	struct debug_obj *obj;
 	unsigned long flags;

+       fill_pool();
+
 	db = get_bucket((unsigned long) addr);

 	spin_lock_irqsave(&db->lock, flags);
-- 
Daniel J Blueman
