Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYGOLuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYGOLuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYGOLt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:49:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55707 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbYGOLt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:49:56 -0400
Date: Tue, 15 Jul 2008 13:49:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	000000000000000e (reset_prng_context)
Message-ID: <20080715114928.GA29792@elte.hu>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715113304.GA30565@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > On Tue, Jul 15, 2008 at 12:25:37AM +0100, Simon Arlott wrote:
> > > http://img182.imageshack.us/img182/7205/1005489hh6.jpg
> > > 
> > > .config attached
> > > 
> > > -- 
> > > Simon Arlott
> > 
> > Looks like you don't have rfc3686(ctr(aes)) compiled in.  Add 
> > CONFIG_CRYPTO_CTR to your config, IIRC.  I'll add a depends directive 
> > to Kconfig for that in my next update.
> 
> i have just triggered this crash too. Please, when you know about 
> bootup crashes in your code send a patch to the lkml thread so that 
> people can apply it and have a working system.

btw., here's another crypto bug, in the same driver, in prng_mod_init():

[    0.552014] calling  crypto_authenc_module_init+0x0/0x10
[    0.552014] initcall crypto_authenc_module_init+0x0/0x10 returned 0 after 0 msecs
[    0.552014] calling  prng_mod_init+0x0/0x60
[    0.552014] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.552014] Pid: 1, comm: swapper Not tainted 2.6.26-tip #2739
[    0.552014]  [<b012dd4c>] __schedule_bug+0x5c/0x70
[    0.552014]  [<b07a6d0c>] schedule+0x52c/0x900
[    0.552014]  [<b0126368>] ? __enqueue_entity+0xb8/0xe0
[    0.552014]  [<b0124990>] ? __resched_task+0x20/0x70
[    0.552014]  [<b07a7315>] schedule_timeout+0x75/0xc0
[    0.552014]  [<b07a8bb1>] ? _spin_unlock_irqrestore+0x31/0x40
[    0.552014]  [<b012a5ef>] ? try_to_wake_up+0xdf/0x280
[    0.552014]  [<b07a669f>] wait_for_common+0x6f/0x110
[    0.552014]  [<b012a790>] ? default_wake_function+0x0/0x10
[    0.552014]  [<b07a67d2>] wait_for_completion+0x12/0x20
[    0.552014]  [<b0144070>] kthread_create+0x70/0xa0
[    0.552014]  [<b02ff760>] ? cryptomgr_probe+0x0/0xa0
[    0.552014]  [<b02ff744>] cryptomgr_notify+0x244/0x260
[    0.552014]  [<b02ff760>] ? cryptomgr_probe+0x0/0xa0
[    0.552014]  [<b014843d>] notifier_call_chain+0x2d/0x60
[    0.552014]  [<b0148674>] __blocking_notifier_call_chain+0x44/0x60
[    0.552014]  [<b01486aa>] blocking_notifier_call_chain+0x1a/0x20
[    0.552014]  [<b02fa61e>] crypto_alg_mod_lookup+0x2e/0x80
[    0.552014]  [<b02fa6b2>] crypto_alloc_base+0x22/0x80
[    0.552014]  [<b03106c8>] reset_prng_context+0xc8/0x1f0
[    0.552014]  [<b0310847>] alloc_prng_context+0x37/0x70
[    0.552014]  [<b0a6fabe>] prng_mod_init+0xe/0x60
[    0.552014]  [<b01478f9>] ? ktime_get+0x19/0x40
[    0.552014]  [<b0a5972e>] kernel_init+0x1be/0x2d0
[    0.552014]  [<b0a6fab0>] ? prng_mod_init+0x0/0x60
[    0.552014]  [<b012da99>] ? schedule_tail+0x19/0x50
[    0.552014]  [<b0103d66>] ? ret_from_fork+0x6/0x20
[    0.552014]  [<b0a59570>] ? kernel_init+0x0/0x2d0
[    0.552014]  [<b0a59570>] ? kernel_init+0x0/0x2d0
[    0.552014]  [<b0105187>] kernel_thread_helper+0x7/0x10
[    0.552014]  =======================
[    0.552014] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.552014] Pid: 1, comm: swapper Not tainted 2.6.26-tip #2739
[    0.552014]  [<b012dd4c>] __schedule_bug+0x5c/0x70
[    0.552014]  [<b07a6d0c>] schedule+0x52c/0x900
[    0.552014]  [<b01268e7>] ? enqueue_task_fair+0x47/0x50
[    0.552014]  [<b01240c7>] ? enqueue_task+0x57/0x70
[    0.552014]  [<b013a6d5>] ? lock_timer_base+0x25/0x50
[    0.552014]  [<b013a811>] ? __mod_timer+0x91/0xb0
[    0.552014]  [<b07a72e8>] schedule_timeout+0x48/0xc0
[    0.552014]  [<b013a540>] ? process_timeout+0x0/0x10
[    0.552014]  [<b07a669f>] wait_for_common+0x6f/0x110
[    0.552014]  [<b012a790>] ? default_wake_function+0x0/0x10
[    0.552014]  [<b07a677d>] wait_for_completion_interruptible_timeout+0xd/0x10
[    0.552014]  [<b02fa2df>] crypto_larval_wait+0x1f/0x60
[    0.552014]  [<b02fa667>] crypto_alg_mod_lookup+0x77/0x80
[    0.552014]  [<b02fa6b2>] crypto_alloc_base+0x22/0x80
[    0.552014]  [<b03106c8>] reset_prng_context+0xc8/0x1f0
[    0.552014]  [<b0310847>] alloc_prng_context+0x37/0x70
[    0.552014]  [<b0a6fabe>] prng_mod_init+0xe/0x60
[    0.552014]  [<b01478f9>] ? ktime_get+0x19/0x40
[    0.556035]  [<b0a5972e>] kernel_init+0x1be/0x2d0
[    0.556035]  [<b0a6fab0>] ? prng_mod_init+0x0/0x60
[    0.556035]  [<b012da99>] ? schedule_tail+0x19/0x50
[    0.556035]  [<b0103d66>] ? ret_from_fork+0x6/0x20
[    0.556035]  [<b0a59570>] ? kernel_init+0x0/0x2d0
[    0.556035]  [<b0a59570>] ? kernel_init+0x0/0x2d0
[    0.556035]  [<b0105187>] kernel_thread_helper+0x7/0x10
[    0.556035]  =======================
[    0.556035] initcall prng_mod_init+0x0/0x60 returned 0 after 2 msecs
[    0.556035] calling  noop_init+0x0/0x20
[    0.556035] io scheduler noop registered

it calls a blocking notifier from atomic context.

	Ingo
