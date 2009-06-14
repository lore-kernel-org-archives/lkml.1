Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZFNIdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZFNIdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 04:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZFNIdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 04:33:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbZFNIdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 04:33:07 -0400
Date: Sun, 14 Jun 2009 10:32:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: tty_ldisc_try_get(): BUG kmalloc-8: Poison overwritten
Message-ID: <20090614083254.GA23149@elte.hu>
References: <20090614081052.GA9276@elte.hu> <4A34B2E2.7080702@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A34B2E2.7080702@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
>
> Ingo Molnar wrote:
>> Ok, this is one for those who like to look at weird crashes/bugs.
>>
>> Here's a new regression that popped up in this merge window, there's  
>> some sort of slab corruption going on in tty data structures:
>>
>> [   74.900215] =============================================================================
>> [   74.908193] BUG kmalloc-8: Poison overwritten
>> [   74.908193] -----------------------------------------------------------------------------
>> [   74.908193] [   74.908193] INFO: 0x5d883a14-0x5d883a14. First byte 
>> 0x6a instead of 0x6b
>> [   74.908193] INFO: Allocated in tty_ldisc_try_get+0x1a/0xb0 age=8015 cpu=0 pid=1
>> [   74.908193] INFO: Freed in tty_ldisc_put+0x48/0x50 age=4 cpu=3 pid=4236
>> [   74.908193] INFO: Slab 0x42c6eeb4 objects=73 used=61 fp=0x5d883a10 flags=0x1d0000c3
>> [   74.908193] INFO: Object 0x5d883a10 @offset=2576 fp=0x5d883d90
>> [   74.908193] [   74.908193] Bytes b4 0x5d883a00:  01 00 00 00 de 04 
>> ff ff 5a 5a 5a 5a 5a 5a 5a 5a ....�.��ZZZZZZZZ
>> [   74.908193]   Object 0x5d883a10:  6b 6b 6b 6b 6a 6b 6b a5            
>>              kkkkjkk�        
>
> This is struct tty_ldisc and the corruption happens in the first byte of  
> ->refcount. This probably just means that there's a race condition and  
> someone is doing tty_ldisc_deref() after tty_ldisc_put().
>
> You could add something like
>
>   WARN_ON(ld->refcount == 0x6b)
>
> to tty_ldisc_deref() to see if that triggers.

I've committed the debug hack below - will let you know if it 
triggers.

	Ingo

------------->
>From 2f5eb191a6fd392d8f66f5e249bd05b3444b5420 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 14 Jun 2009 10:30:31 +0200
Subject: [PATCH] [not for upstream] tty: Add debug check to tty_ldisc_deref()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Try to catch this SLAB corruption earlier:

[   74.900215] =============================================================================
[   74.908193] BUG kmalloc-8: Poison overwritten
[   74.908193] -----------------------------------------------------------------------------
[   74.908193]
[   74.908193] INFO: 0x5d883a14-0x5d883a14. First byte 0x6a instead of 0x6b
[   74.908193] INFO: Allocated in tty_ldisc_try_get+0x1a/0xb0 age=8015 cpu=0 pid=1
[   74.908193] INFO: Freed in tty_ldisc_put+0x48/0x50 age=4 cpu=3 pid=4236
[   74.908193] INFO: Slab 0x42c6eeb4 objects=73 used=61 fp=0x5d883a10 flags=0x1d0000c3
[   74.908193] INFO: Object 0x5d883a10 @offset=2576 fp=0x5d883d90
[   74.908193]
[   74.908193] Bytes b4 0x5d883a00:  01 00 00 00 de 04 ff ff 5a 5a 5a 5a 5a 5a 5a 5a ....Þ.ÿÿZZZZZZZZ
[   74.908193]   Object 0x5d883a10:  6b 6b 6b 6b 6a 6b 6b a5                         kkkkjkk¥
[   74.908193]  Redzone 0x5d883a18:  bb bb bb bb                                     »»»»
[   74.908193]  Padding 0x5d883a40:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
[   74.908193] Pid: 4230, comm: mingetty Not tainted 2.6.30-tip #744
[   74.908193] Call Trace:
[   74.908193]  [<410ae628>] print_trailer+0xc8/0xd0
[   74.908193]  [<410ae6a3>] check_bytes_and_report+0x73/0x90
[   74.908193]  [<410ae941>] check_object+0xa1/0x130
[   74.908193]  [<410aef1e>] alloc_debug_processing+0x5e/0xd0
[   74.908193]  [<410af99e>] __slab_alloc+0x11e/0x150
[   74.908193]  [<413d9c7a>] ? tty_ldisc_try_get+0x1a/0xb0
[   74.908193]  [<410afcdb>] kmem_cache_alloc+0x7b/0x120
[   74.908193]  [<413d9c7a>] ? tty_ldisc_try_get+0x1a/0xb0
[   74.908193]  [<413d9c7a>] ? tty_ldisc_try_get+0x1a/0xb0
[   74.908193]  [<413d9c7a>] tty_ldisc_try_get+0x1a/0xb0
[   74.908193]  [<410b06a3>] ? __kmalloc+0x163/0x170
[   74.908193]  [<413d9d77>] tty_ldisc_get+0x17/0x40
[   74.908193]  [<413da63d>] tty_ldisc_init+0xd/0x30
[   74.908193]  [<413d4098>] initialize_tty_struct+0x38/0x210
[   74.908193]  [<413d5d6f>] tty_init_dev+0x4f/0xb0
[   74.908193]  [<413d5f25>] __tty_open+0x155/0x2d0
[   74.908193]  [<413d60b7>] tty_open+0x17/0x30
[   74.908193]  [<410bb599>] chrdev_open+0xe9/0x100
[   74.908193]  [<410b721e>] __dentry_open+0xbe/0x190
[   74.908193]  [<410b813c>] nameidata_to_filp+0x2c/0x50
[   74.908193]  [<410bb4b0>] ? chrdev_open+0x0/0x100
[   74.908193]  [<410c2eba>] do_filp_open+0x2aa/0x580
[   74.908193]  [<4100a1bb>] ? sched_clock+0xb/0x20
[   74.908193]  [<410596c7>] ? put_lock_stats+0x17/0x30
[   74.908193]  [<41059734>] ? lock_release_holdtime+0x54/0x60
[   74.908193]  [<4105d4d9>] ? lock_release_nested+0x99/0xd0
[   74.908193]  [<41377421>] ? debug_spin_unlock+0x21/0x80
[   74.908193]  [<41377495>] ? _raw_spin_unlock+0x15/0x20
[   74.908193]  [<410cad50>] ? alloc_fd+0xc0/0xd0
[   74.908193]  [<410b7020>] do_sys_open+0x40/0x80
[   74.908193]  [<410b70ae>] sys_open+0x1e/0x30
[   74.908193]  [<4100388f>] sysenter_do_call+0x12/0x3c
[   74.908193] FIX kmalloc-8: Restoring 0x5d883a14-0x5d883a14=0x6b
[   74.908193]
[   74.908193] FIX kmalloc-8: Marking all objects used
[   75.188226] warning: `sudo' uses deprecated v2 capabilities in a way that may be insecure.

Note, a value of 0x6b is legit for the refcount in theory, so this
debug hack is not suitable for upstream.

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/tty_ldisc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 39c8f86..dd1daf3 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -361,6 +361,7 @@ void tty_ldisc_deref(struct tty_ldisc *ld)
 	unsigned long flags;
 
 	BUG_ON(ld == NULL);
+	WARN_ON_ONCE(ld->refcount == 0x6b);
 
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
 	if (ld->refcount == 0)
