Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZICS6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZICS6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbZICS6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:58:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58096 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbZICS6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:58:21 -0400
Date: Thu, 3 Sep 2009 20:58:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:timers/core] clocksource: Resolve cpu
	hotplug dead lock with TSC unstable
Message-ID: <20090903185806.GA5949@elte.hu>
References: <tip-7285dd7fd375763bfb8ab1ac9cf3f1206f503c16@git.kernel.org> <20090831101928.4c00c797@skybase> <alpine.LFD.2.00.0908311754590.19335@localhost.localdomain> <20090903181743.GA22431@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903181743.GA22431@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> i tried to bisect it but it's inconclusive:
> 
>  # bad:  [32beef9c] Merge branch 'perfcounters/core'
>  # bad:  [b6413360] manual merge of x86/platform
>  # bad:  [d9e5f39a] Merge branch 'auto-oprofile-next' into auto-latest
>  # bad:  [cbaff272] Merge branch 'auto-timers-next' into auto-latest
> 
> as the bisection comes up with that merge commit. Perhaps the 
> combination of the x86/platform changes and the clocksource 
> changes triggered it?

That seems to be the case - i just tested a combination merge of 
tip:auto-timers-next and tip:auto-x86-next and the result crashed in 
a similar way too.

Since normal bisection cannot find such breakages, i did a topical 
bisection (merging the finegrained tip:x86/* topics into the timer 
tree gradually and testing each merge).

That way i could exclude: x86/platform, x86/pat, x86/asm, x86/apic, 
x86/percpu, x86/cpu, x86/mm and arrived to x86/tsc - which contains 
a single commit:

  d3b8f88: x86: Make tsc=reliable override boot time stability checks

Reverting that commit from tip:master gives me a non-crashing 
bootup.

	Ingo
