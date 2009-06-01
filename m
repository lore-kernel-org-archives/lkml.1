Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZFAWyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZFAWyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZFAWyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:54:23 -0400
Received: from iabervon.org ([66.92.72.58]:43025 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZFAWyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:54:23 -0400
Date: Mon, 1 Jun 2009 18:54:23 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: Re: fishy code in arch/x86/kernel/tsc.c:time_cpufreq_notifier()
In-Reply-To: <20090601142104.GA15907@infradead.org>
Message-ID: <alpine.LNX.2.00.0906011749170.2147@iabervon.org>
References: <20090601142104.GA15907@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009, Christoph Hellwig wrote:

> Just notice the following error from gcc 4.4:
> 
> arch/x86/kernel/tsc.c: In function 'time_cpufreq_notifier':
> arch/x86/kernel/tsc.c:634: warning: 'dummy' may be used uninitialized in this function
> 
> dummy is only used in the following way in this function:
> 
> 	lpj = &dummy;
> 
> and then dummy might be overriden in the following odd way:
> 
> 	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> #ifdef CONFIG_SMP
> 		lpj = &cpu_data(freq->cpu).loops_per_jiffy;
> #else
> 	lpj = &boot_cpu_data.loops_per_jiffy;
> #endif

This is misindented; the if applies to both CONFIG_SMP and otherwise. For 
that matter, cpu_data(anything) == boot_cpu_data if !CONFIG_SMP. So the 
current code is equivalent to:

	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
		lpj = &cpu_data(freq->cpu).loops_per_jiffy;

> and then is used in
> 
> 	if (!ref_freq) {
> 		ref_freq = freq->old;
> 		loops_per_jiffy_ref = *lpj;
> 		tsc_khz_ref = tsc_khz;
> 	}
> 
> to me that looks like it can indeed be used unitialized for the case
> where we do have CONFIG_SMP set, freq->flags & CPUFREQ_CONST_LOOPS is
> true and ref_freq is false.
> 
> Can that case actually happen?

Looks to me like loops_per_jiffy_ref is only used to compute a new value 
for *lpj. So the case that matters is if this function can be called the 
first time with freq->flags & CPUFREQ_CONST_LOOPS and then without; 
otherwise, the uninitialized values only contribute to a dead assignment 
(and the junk in the static variable).

I'd guess that, if freq->flags & CPUFREQ_CONST_LOOPS, no processor's 
loops_per_jiffy should get scaled, so the current code is essentially 
correct, although it's hard to read and far too hard for the compiler to 
analyze.

Probably the right answer is to move the *lpj = ... in with 
mark_tsc_unstable and drop the earlier if and dummy.

	-Daniel
*This .sig left intentionally blank*
