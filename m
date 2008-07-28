Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYG1OmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYG1OmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYG1OmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:42:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57582 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYG1OmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:42:05 -0400
Date: Mon, 28 Jul 2008 16:41:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Mike Travis <travis@sgi.com>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Linuxppc-dev@ozlabs.org, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CONFIG_FRAME_POINTER [was [PATCH] x86: BUILD_IRQ say .text]
Message-ID: <20080728144133.GH18144@elte.hu>
References: <Pine.LNX.4.64.0807211828470.26173@blonde.site> <20080724104459.GI28817@elte.hu> <Pine.LNX.4.64.0807251839190.20617@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807251839190.20617@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> [PATCH] sched: move sched_clock before first use
> 
> Move sched_clock() up to stop warning: weak declaration of 
> `sched_clock' after first use results in unspecified behavior (if 
> -fno-unit-at-a-time).
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

applied to tip/sched/urgent - thanks Hugh.

> I rather think CONFIG_FRAME_POINTER shouldn't exist at all (or be a 
> private, config-user-invisible, specific-to-a-few-arches thing): what 
> one wants to configure is how far to sacrifice cpu performance and 
> kernel smallness to getting a good stacktrace.  Frame pointer is just 
> an implementation detail on that, appropriate to some arches. Perhaps 
> three settings: no stacktrace, fair stacktrace, best stacktrace.

actually, we consciously use and rely on frame pointers on x86. The 
runtime cost on 64-bit is miniscule and the improved backtrace output in 
recent kernels makes backtraces _much_ easier to interpret:

 Call Trace:
  <NMI>  [<ffffffff80480779>] _raw_spin_trylock+0x19/0x50
  [<ffffffff808fb2e9>] _spin_lock_irqsave+0x59/0x90
  [<ffffffff80261ab4>] atomic_notifier_chain_register+0x24/0x60
  [<ffffffff80262f38>] ? __profile_tick+0x58/0x90
  [<ffffffff808fd1a9>] nmi_watchdog_tick+0x59/0x1e0
  [<ffffffff808fc79a>] default_do_nmi+0x6a/0x220
  [<ffffffff808fc9b4>] do_nmi+0x64/0xb0
  [<ffffffff808fc032>] nmi+0xa2/0xc2
  [<ffffffff80285bd1>] ? stopmachine+0x61/0xd0
  <<EOE>>  [<ffffffff8020dca9>] child_rip+0xa/0x11
  [<ffffffff8020cf3e>] ? restore_args+0x0/0x30
  [<ffffffff80285b70>] ? stopmachine+0x0/0xd0
  [<ffffffff8020dc9f>] ? child_rip+0x0/0x11

we experimented with using dwarf2 data in the past but it proved to be 
very fragile in practice - we depended too much on the whims of 
gcc/binutils being absolutely correct, etc.

Something as fundamental to the kernel's general health as backtraces 
must not be fragile. So the EBP based backtracing code was ported to 
64-bit as well and it was improved further upon.

kudos to Arjan for that.

	Ingo
