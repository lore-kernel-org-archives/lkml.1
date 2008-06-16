Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYFPG6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYFPG6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYFPG6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:58:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYFPG6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:58:33 -0400
Date: Mon, 16 Jun 2008 08:58:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@redhat.com, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 2.6.26-rc6] x86-32: fix boot failure on TSC-less
	processors
Message-ID: <20080616065802.GA24421@elte.hu>
References: <200806150019.m5F0JujB026872@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806150019.m5F0JujB026872@harpo.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Booting 2.6.26-rc6 on my 486 DX/4 fails with a "BUG: Int 6" (invalid 
> opcode) and a kernel halt immediately after the kernel has been 
> uncompressed. The BUG shows EIP pointing to an rdtsc instruction in 
> native_read_tsc(), invoked from native_sched_clock().
> 
> (This error occurs so early that not even the serial console can 
> capture it.)
> 
> A bisection showed that this bug first occurs in 2.6.26-rc3-git7, via 
> commit 9ccc906c97e34fd91dc6aaf5b69b52d824386910:
> 
> >x86: distangle user disabled TSC from unstable
> >
> >tsc_enabled is set to 0 from the command line switch "notsc" and from
> >the mark_tsc_unstable code. Seperate those functionalities and replace
> >tsc_enable with tsc_disable. This makes also the native_sched_clock()
> >decision when to use TSC understandable.
> >
> >Preparatory patch to solve the sched_clock() issue on 32 bit.
> >
> >Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> The core reason for this bug is that native_sched_clock() gets
> called before tsc_init().
> 
> Before the commit above, tsc_32.c used a "tsc_enabled" variable
> which defaulted to 0 == disabled, and which only got enabled late
> in tsc_init(). Thus early calls to native_sched_clock() would skip
> the TSC and use jiffies instead.
> 
> After the commit above, tsc_32.c uses a "tsc_disabled" variable
> which defaults to 0, meaning that the TSC is Ok to use. Early calls
> to native_sched_clock() now erroneously try to use the TSC on
> !cpu_has_tsc processors, leading to invalid opcode exceptions.
> 
> My proposed fix is to initialise tsc_disabled to a "soft disabled"
> state distinct from the hard disabled state set up by the "notsc"
> kernel option. This fixes the native_sched_clock() problem. It also
> allows tsc_init() to be simplified: instead of setting tsc_disabled = 1
> on every error return, we just set tsc_disabled = 0 once when all
> checks have succeeded.
> 
> I've verified that this lets my 486 boot again. I've also verified 
> that a Core2 machine still uses the TSC as clocksource after the 
> patch.

applied to tip/x86/urgent - thanks Mikael! The soft-disabled state is a 
pretty good solution.

	Ingo
