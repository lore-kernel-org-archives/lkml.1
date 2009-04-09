Return-Path: <linux-kernel-owner+w=401wt.eu-S1761753AbZDIGG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753AbZDIGG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZDIGGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:06:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60399 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792AbZDIGGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:06:16 -0400
Date: Thu, 9 Apr 2009 08:05:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: powerpc: add nmi_enter/nmi_exit calls
Message-ID: <20090409060556.GK5352@elte.hu>
References: <18909.31952.873098.336615@cargo.ozlabs.ibm.com> <20090409052002.GE5352@elte.hu> <18909.35969.369573.720803@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18909.35969.369573.720803@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > I'm wondering, what was the real impact? Was it a crash or some 
> > other misbehavior? This impact line:
> > 
> > 	Impact: powerpc bug fix
> > 
> > is a bit too generic to be useful in practice. Something like:
> > 
> > 	Impact: fix stuck NMIs on powerpc
> > 	Impact: fix NMI crash on powerpc
> > 
> > would have been more descriptive about the real, hands-on impact of 
> > this patch.
> 
> I was looking at Peter's patches and I noticed he used in_nmi(), 
> and I wondered "what's that?", so I went looking and found it, and 
> realized that I needed to be calling nmi_enter/exit for it to 
> work.  I never actually booted a kernel that had the patch to use 
> in_nmi() but not my patch to call nmi_enter/exit.
> 
> The impact would have been that in_nmi() always returned 0, so I 
> expect that I would have seen deadlocks and/or memory corruption 
> had I booted a kernel without my fix.

thanks, i've amended the commit with:

    Impact: fix potential deadlocks on powerpc

i try to keep the habit of good impact-lines even for development 
branches - they make the -stable tagging effort quite a bit more 
robust once a piece of code is upstream.

They also give good, standard looking feedback about the kinds of 
problems/risks that a given topic has triggered historically.

For example:

earth4:~/tip> git log v2.6.29..v2.6.30-rc1 arch/x86/kernel/apic/  | \
                  grep Impact: | sort | uniq -c | sort -n

      1     Impact: build fix
      1     Impact: build fix, cleanup
      1     Impact: cleanup, paranoia
      1     Impact: cleanup, reduce memory usage for CONFIG_CPUMASK_OFFSTACK=y
      1     Impact: cleanup, remove cpumask from stack
      1     Impact: fix bug with irq-descriptor moving when logical flat
      1     Impact: fix incorrect error message
      1     Impact: fix possible race
      1     Impact: fix spurious IRQs
      1     Impact: get correct smp_affinity as user requested
      1     Impact: interface augmentation (not yet used)
      1     Impact: make kexec work with x2apic
      1     Impact: optimize APIC IPI related barriers
      1     Impact: simplification
     10     Impact: cleanup

Shows that we had 5-6 runtime problems (mostly misbehavior) in the 
APIC code during the last development window.

Or:

earth4:~/tip> git log v2.6.29..v2.6.30-rc1 kernel/sched.c  | grep 
Impact: | sort | uniq -c | sort -n
      1     Impact: cleanup, micro-optimization
      1     Impact: cleanup, new schedstat ABI
      1     Impact: fix boot crash
      1     Impact: fix circular locking
      1     Impact: fix function graph trace hang / drop pointless softirq on UP
      1     Impact: fix to preempt trace triggering lockdep check_flag failure
      1     Impact: more precise avg_overlap metric - better load-balancing
      1     Impact: struct rq size optimization
      2     Impact: micro-optimization
     12     Impact: cleanup

Shows that we had ~4 runtime problems (crashes or lockdep asserts) 
in the schedule during the last development window.

The shortlog tends to clone the patch-submission subject lines and 
tends to be more detailed and differently structured - so it's a lot 
harder to extract this information from it, at a glance.

So the impact line standardizes this kind of risk/impact info - and 
while we are still experimenting with exactly how to shape it (you 
can see several small variants), it's already pretty useful in the 
history too - not just while queueing it up.

	Ingo
