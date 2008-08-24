Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYHXWvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYHXWvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 18:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYHXWvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 18:51:00 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:54746 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYHXWvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 18:51:00 -0400
Date: Sun, 24 Aug 2008 22:50:58 +0000
From: Sean Young <sean@mess.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Alok Kataria <akataria@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Message-ID: <20080824225058.GA55406@atlantis.8hz.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241141470.3363@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808241141470.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 11:52:06AM -0700, Linus Torvalds wrote:
> On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11354
> > Subject		: AMD Elan regression with 2.6.27-rc3
> > Submitter	: Sean Young <sean@mess.org>
> > Date		: 2008-08-15 18:37 (9 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121882578430056&w=4
> 
> Peter? Ingo? Alok?
> 
> This _looks_ like it might be due to "x86: merge the TSC cpu-freq code" 
> thing by Alok, where we do this:
> 
> 	+static struct notifier_block time_cpufreq_notifier_block = {
> 	+       .notifier_call  = time_cpufreq_notifier
> 	+};
> 	+
> 	+static int __init cpufreq_tsc(void)
> 	+{
> 	+       cpufreq_register_notifier(&time_cpufreq_notifier_block,
> 	+                               CPUFREQ_TRANSITION_NOTIFIER);
> 	+       return 0;
> 	+}
> 
> but that's just _insane_ if the CPU doesn't even support TSC to begin 
> with. Also, in the actual time_cpufreq_notifier(), we do:
> 
> 	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
> 		return 0;
> 
> and this is stupid because:
> 
>  (a) if the CPU has no TSC at all, then it sure as hell won't have a 
>      _constant_ one, so we'll actually continue into the function.
> 
>  (b) and why the hell is this done at run-time in the notifier, and not in 
>      the "cpufreq_tsc" init function? If anybody mixes totally different 
>      kinds of CPU's in SMP, they deserve whatever they want.
> 
> so why is the patch not something like the appended?
> 
> Sean, does this make any difference for you?

Yes, this patch fixes it.

Thanks
Sean
