Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbZIHVnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbZIHVnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 17:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZIHVnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 17:43:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36176 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZIHVnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 17:43:15 -0400
Subject: Re: [boot crash] Re: [tip:timers/core] clocksource: Resolve cpu
 hotplug dead lock with TSC unstable
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090903185806.GA5949@elte.hu>
References: <tip-7285dd7fd375763bfb8ab1ac9cf3f1206f503c16@git.kernel.org>
	 <20090831101928.4c00c797@skybase>
	 <alpine.LFD.2.00.0908311754590.19335@localhost.localdomain>
	 <20090903181743.GA22431@elte.hu>  <20090903185806.GA5949@elte.hu>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 14:43:13 -0700
Message-Id: <1252446193.3376.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 20:58 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i tried to bisect it but it's inconclusive:
> > 
> >  # bad:  [32beef9c] Merge branch 'perfcounters/core'
> >  # bad:  [b6413360] manual merge of x86/platform
> >  # bad:  [d9e5f39a] Merge branch 'auto-oprofile-next' into auto-latest
> >  # bad:  [cbaff272] Merge branch 'auto-timers-next' into auto-latest
> > 
> > as the bisection comes up with that merge commit. Perhaps the 
> > combination of the x86/platform changes and the clocksource 
> > changes triggered it?
> 
> That seems to be the case - i just tested a combination merge of 
> tip:auto-timers-next and tip:auto-x86-next and the result crashed in 
> a similar way too.
> 
> Since normal bisection cannot find such breakages, i did a topical 
> bisection (merging the finegrained tip:x86/* topics into the timer 
> tree gradually and testing each merge).
> 
> That way i could exclude: x86/platform, x86/pat, x86/asm, x86/apic, 
> x86/percpu, x86/cpu, x86/mm and arrived to x86/tsc - which contains 
> a single commit:
> 
>   d3b8f88: x86: Make tsc=reliable override boot time stability checks
> 
> Reverting that commit from tip:master gives me a non-crashing 
> bootup.

Huh. Does dropping the last chunk of the patch make the issue go away?

I'm suspecting fixing the bug Thomas noticed in the tsc_unstable
assignment (we set tsc_unstable before calling mark_tsc_unstable,
causing the TSC rating to not change) that I included in this patch is
colliding with the clocksource rework from Martin.

Although I'm not sure I see that in the backtrace, so I'm likely wrong.
Hrmm..

-john




