Return-Path: <linux-kernel-owner+w=401wt.eu-S1759159AbZBMINV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159AbZBMINV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 03:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZBMINK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 03:13:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbZBMINJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 03:13:09 -0500
Date: Fri, 13 Feb 2009 09:12:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RFC] Fix for LS21 + HPET = boot hang (since 2.6.24-rc1)
Message-ID: <20090213081232.GA1670@elte.hu>
References: <1233974209.7141.7.camel@localhost.localdomain> <1234254831.6323.10.camel@jstultz-laptop> <1234493333.7042.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234493333.7042.2.camel@localhost.localdomain>
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


* john stultz <johnstul@us.ibm.com> wrote:

> Between 2.6.23 and 2.6.24-rc1 a change was made that broke IBM LS21
> systems that had the HPET enabled in the BIOS, resulting in boot hangs
> for x86_64. 
> 
> Specifically commit b8ce33590687888ebb900d09557b8807c4539022, which
> merges the i386 and x86_64 HPET code.
> 
> Prior to this commit, when we setup the HPET timers in x86_64, we did
> the following:
> 
> 	hpet_writel(HPET_TN_ENABLE | HPET_TN_PERIODIC | HPET_TN_SETVAL |
>                     HPET_TN_32BIT, HPET_T0_CFG);
> 
> However after the i386/x86_64 HPET merge, we do the following:
> 
> 	cfg = hpet_readl(HPET_Tn_CFG(timer));
> 	cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
> 			HPET_TN_SETVAL | HPET_TN_32BIT;
> 	hpet_writel(cfg, HPET_Tn_CFG(timer));
> 
> 
> However on LS21s with HPET enabled in the BIOS, the HPET_T0_CFG register
> boots with Level triggered interrupts (HPET_TN_LEVEL) enabled. This
> causes the periodic interrupt to be not so periodic, and that results in
> the boot time hang I reported earlier in the delay calibration.
> 
> 
> My fix: Always disable HPET_TN_LEVEL when setting up periodic mode.
> 
> Does that seem ok to folks? I've not been able to run this on an i386
> system, so it could use some extra testing. So while it is a regression
> fix, the bug has been around for awhile, so I'd probably queue it for
> 2.6.30.

Makes perfect sense - and i dont think we can actually survive the
bootup with this IRQ being level-triggered, so there's little risk
of introducing additional regressions. I'll give it a good workout
nevertheless.

Applied to tip:x86/urgent, thanks John for tracking this one down!

	Ingo
