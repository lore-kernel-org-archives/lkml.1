Return-Path: <linux-kernel-owner+w=401wt.eu-S1751140AbZLRLXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140AbZLRLXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 06:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbZLRLXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 06:23:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZLRLXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 06:23:20 -0500
Date: Fri, 18 Dec 2009 12:23:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: -tip: origin tree build failure
Message-ID: <20091218112300.GA25726@elte.hu>
References: <20091217094041.GA24708@elte.hu>
 <20091217122316.GB14088@elte.hu>
 <87bphxu5ef.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bphxu5ef.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >>  config MEMORY_FAILURE
> >>  	depends on MMU
> >>  	depends on ARCH_SUPPORTS_MEMORY_FAILURE
> >> +	select PROC_PAGE_MONITOR
> >>  	bool "Enable recovery from hardware memory errors"
> >
> > It also needs to depend on PROC_FS in that case - as per the updated patch 
> > below.
> 
> Thanks for the report.
> 
> MEMORY_FAILURE itself doesn't depend on the page flags, just the injector 
> which has a separate config option. It already has a select 
> PROC_PAGE_MONITOR, but the proc dependency is indeed missing.
> 
> I think the correct fix is the appended patch.

No, your patch is not the correct fix. As i said, PROC_PAGE_MONITOR provides 
the facility and mm/memory-failure.c uses that facility - and your patch does 
not solve that fundamental dependency issue, it just fudges around the 
dependencies.

So your patch can still produce the same kind of build failure (with other 
Kconfig variations):

 mm/built-in.o: In function `hwpoison_filter':
 (.text+0x430ba): undefined reference to `stable_page_flags'

This should be cleaned up for real - there's no reason why stable_page_flags() 
(which is an MM facility) should live in fs/proc/. That's the root of the 
problem.

Also a few more (very small) nits:

> HWPOISON: Add PROC_FS dependency to hwpoison injector

It would be really useful if hwpoison commit titles were in lower case, like 
most other commits in the kernel do? Upper-case is used in special cases - IMO 
this case does not qualify.

> The injector filter requires stable_page_flags() which is supplied by 
> procfs. So make it dependent on that.
> 
> Reported by Ingo Molnar

FYI, we have a Reported-by tag that can be (and should be) used in such cases.

Thanks,

	Ingo
