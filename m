Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYIFSWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYIFSWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIFSWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:22:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40293 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbYIFSWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:22:07 -0400
Date: Sat, 6 Sep 2008 20:21:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       Jes Sorensen <jes@sgi.com>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] smp: reduce stack requirements for
	smp_call_function_mask
Message-ID: <20080906182146.GB21872@elte.hu>
References: <20080905214019.821172000@polaris-admin.engr.sgi.com> <20080906132944.GC4910@elte.hu> <48C2C810.3070809@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C2C810.3070809@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >>   * Cleanup cpumask_t usages in smp_call_function_mask function chain
> >>     to prevent stack overflow problem when NR_CPUS=4096.
> >>
> >>   * Reduce the number of passed cpumask_t variables in the following
> >>     call chain for x86_64:
> >>
> >> 	smp_call_function_mask -->
> >> 	    arch_send_call_function_ipi->
> >> 		    smp_ops.send_call_func_ipi -->
> >> 			    genapic->send_IPI_mask
> >>
> >>     Since the smp_call_function_mask() is an EXPORTED function, we
> >>     cannot change it's calling interface for a patch to 2.6.27.
> >>
> >>     The smp_ops.send_call_func_ipi interface is internal only and
> >>     has two arch provided functions:
> >>
> >> 	arch/x86/kernel/smp.c:  .send_call_func_ipi = native_send_call_func_ipi
> >> 	arch/x86/xen/smp.c:     .send_call_func_ipi = xen_smp_send_call_function_ipi
> >> 	arch/x86/mach-voyager/voyager_smp.c:    (uses native_send_call_func_ipi)
> >>
> >>     Therefore modifying the internal interface to use a cpumask_t pointer
> >>     is straight-forward.
> >>
> >>     The changes to genapic are much more extensive and are affected by the
> >>     recent additions of the x2apic modes, so they will be done for 2.6.28 only.
> >>
> >> Based on 2.6.27-rc5-git6.
> >>
> >> Applies to linux-2.6.tip/master (with FUZZ).
> > 
> > applied to tip/cpus4096, thanks Mike.
> 
> Thanks Ingo!  Could you send me the git id for the merge?

the commits are:

363a5e3: x86: add MAXSMP
01f569c: x86: restore 4096 limit for NR_CPUS
ae74da3: x86: reduce stack requirements for send_call_func_ipi
562d8c2: smp: reduce stack requirements for smp_call_function_mask

the merge into tip/master is:

| commit 7f5d26f9425851e20ca9774acbd13d0e3b96d9dd
| Merge: da5e209... 363a5e3...
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Sat Sep 6 15:29:18 2008 +0200
|
|     Merge branch 'cpus4096'

That merge commit will go away on the next integration run though.

your changes seem to be largely problem-free so far - with two dozen 
MAXSMP=y random bootups already.

> > I'm still wondering whether we should get rid of non-reference based 
> > cpumask_t altogether ...
> 
> I've got a whole slew of "get-ready-to-remove-cpumask_t's" coming 
> soon. There are two phases, one completely within the x86 arch and the 
> 2nd hits the generic smp_call_function_mask ABI (won't be doable as a 
> back-ported patch to 2.6.27.)

ok. None of this can go into v2.6.27 obviously - the stack corruptions 
were rather nasty. But it's looking good for v2.6.28 - especially if you 
are removing cpumask_t.

> > Did you have a chance to look at the ftrace/stacktrace tracer in 
> > latest tip/master, which will show the maximum stack footprint that 
> > can occur?
> 
> Hmm, no.  I'm using a default config right now as I can boot that 
> pretty easily.  I'll turn on the ftrace thing and check it out.

it's CONFIG_STACK_TRACER=y and rather nifty.

> > Also, i've applied the patch below as well to restore MAXSMP in a 
> > muted form - with big warning signs added as well.
> 
> The main thing is to allow the distros to set it manually for their QA 
> testing of 2.6.27.  I'm sure I'll get back bugs because of just that.
> 
> (Is there a way to have them know to assign bugzilla's to me if 
> NR_CPUS=4k is the root of the problem?  This is an extremely serious 
> issue for SGI and I'd like to avoid any delays in me finding out about 
> problems.)

i dont think there's any easy mapping.

	Ingo
