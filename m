Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZKYKu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZKYKu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZKYKu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:50:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46994 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZKYKu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:50:57 -0500
Date: Wed, 25 Nov 2009 11:50:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: percpu tree build warning
Message-ID: <20091125105004.GA18163@elte.hu>
References: <20091125214219.f37935e8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125214219.f37935e8.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> arch/x86/kernel/hw_breakpoint.c: In function 'arch_install_hw_breakpoint':
> arch/x86/kernel/hw_breakpoint.c:121: warning: assignment from incompatible pointer type
> arch/x86/kernel/hw_breakpoint.c: In function 'arch_uninstall_hw_breakpoint':
> arch/x86/kernel/hw_breakpoint.c:156: warning: assignment from incompatible pointer type
> 
> I am not sure where this one came from ...

the code does:

DEFINE_PER_CPU(unsigned long, dr7);

int arch_install_hw_breakpoint(struct perf_event *bp)
{
...
        unsigned long *dr7;
...
        dr7 = &__get_cpu_var(dr7);
...
}

Tejun, is it perhaps a problem of the percpu code getting confused 
between the local and file scope 'dr7' variable shadowing each other?

If yes then that needs to be fixed in the percpu tree. per-cpu variables 
used to have a __per_cpu prefix and that should be maintained - the two 
namespaces are obviously separate on the logical space, so they should 
never overlap in the implementational space either.

	Ingo
