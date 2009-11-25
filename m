Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbZKYL7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbZKYL7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbZKYL7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:59:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49864 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbZKYL7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:59:15 -0500
Date: Wed, 25 Nov 2009 12:58:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: percpu tree build warning
Message-ID: <20091125115856.GA17856@elte.hu>
References: <20091125214219.f37935e8.sfr@canb.auug.org.au>
 <20091125105004.GA18163@elte.hu>
 <200911252144.08686.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911252144.08686.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Linus and Andrew)

* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wed, 25 Nov 2009 09:20:04 pm Ingo Molnar wrote:
> > If yes then that needs to be fixed in the percpu tree. per-cpu variables 
> > used to have a __per_cpu prefix and that should be maintained - the two 
> > namespaces are obviously separate on the logical space, so they should 
> > never overlap in the implementational space either.
> 
> No, we've been through this.
> 
> sparse annotations replace the per_cpu prefix now per-cpu vars can be 
> used withn other than per-cpu ops (ie. their address can be usefully 
> taken).
> 
> The prefix crutch predated sparse.  And it was certainly never 
> supposed to let people write confusing and crap code like this.

What's confusing and crap about the code below? I dont think it is 
confusing, nor crap:

int arch_install_hw_breakpoint(struct perf_event *bp)
{
	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
	unsigned long *dr7;
	int i;

	for (i = 0; i < HBP_NUM; i++) {
		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);

		if (!*slot) {
			*slot = bp;
			break;
		}
	}

	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
		return -EBUSY;

	set_debugreg(info->address, i);
	__get_cpu_var(cpu_debugreg[i]) = info->address;

	dr7 = &__get_cpu_var(dr7);
	*dr7 |= encode_dr7(i, info->len, info->type);

	set_debugreg(*dr7, 7);

	return 0;
}

This is basically equivalent to:

	pid = task->pid;

the 'dr7' in the local scope is clearly different from the 
__get_cpu_var(dr7) variable.

percpu variables are basically in a special struct. It's not like you 
can _ever_ access 'dr7' the percpu variable like that - it _always_ has 
to go via a proper percpu wrapper construct. So this change is 
needlessly obtrusive.

Really, guys, while the workaround is easy (a rename), this might be 
going a bit too far. I already think that the recently introduced 
limitation to name local percpu symbols globally sucked - but i'm not 
sure whether this new rule of not allowing such clear and clean looking 
code is acceptable.

Percpu variables now pollute _both_ the global and the local namespace - 
i dont think you can have it both ways.

	Ingo
