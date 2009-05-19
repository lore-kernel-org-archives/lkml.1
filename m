Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZESLJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZESLJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZESLJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:09:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZESLJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:09:03 -0400
Date: Tue, 19 May 2009 13:08:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090519110837.GA10548@elte.hu>
References: <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <20090519095918.GA11790@elte.hu> <4A12A46A02000078000017E1@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A12A46A02000078000017E1@vpn.id2.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 19.05.09 11:59 >>>
>
> > Exactly what is 'bizarre' about using the API defined by the 
> > _CPU_ already, without adding any ad-hoc hypecall? Catch the 
> > dom0 WRMSRs, filter out the MTRR indices - that's it.
> 
> But that is *not* the same as using the hypercalls: The hypercall 
> tells Xen "Change all CPUs' MTRRs with the indicated index to the 
> indicated value", while the MSR write says "Change the MTRR with 
> the given index on the physical CPU the current virtual CPU 
> happens to run on to the given value". [...]

The change of MTRR's on _any_ of the guest CPUs in a dom0 context 
should immediately be refected on all CPUs. Assymetric MTRR settings 
are madness.

( And the thing is, changing MTRRs is fragile and racy on native 
  Linux no matter what - even without any hypervisors - due to SMM 
  contexts possibly relying on them etc. )

> [...] A write-base/write-mask pair may happen to get interrupted 
> (preempted) by the hypervisor, and hence the two writes may happen 
> on different pCPU-s. Teaching the hypervisor to (correctly!) guess 
> what the guest meant in that situation isn't trivial, as then it 
> needs to handle all possible situations (and it can never know 
> whether Dom0 really intended to do something that may look 
> bogus/inconsistent at the first glance). [...]

None of this is a problem really if a sane approach is used: a 
change to the MTRR state on dom0 is applied symmetrically on all 
CPUs.

Or, alternatively, the hypervisor can expose its own administrative 
interface to manage MTRRs.

There's no need to fuglify the Linux kernel for that.

	Ingo
