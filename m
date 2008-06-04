Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbYFDKxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbYFDKxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYFDKxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:53:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYFDKxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:53:44 -0400
Date: Wed, 4 Jun 2008 12:53:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=FCrgen?= Mell <j.mell@t-online.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, hpa@zytor.com,
       tglx@linutronix.de,
       Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Message-ID: <20080604105317.GA17874@elte.hu>
References: <200806011101.06491.j.mell@t-online.de> <20080602213756.GB25114@linux-os.sc.intel.com> <20080602225727.GC25114@linux-os.sc.intel.com> <200806040944.15815.j.mell@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806040944.15815.j.mell@t-online.de>
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


* Jürgen Mell <j.mell@t-online.de> wrote:

> > Jürgen, I think I found the reason for your issue aswell.
> >
> > As you observed, it is probably coming from the commit
> > acc207616a91a413a50fdd8847a747c4a7324167, i386: add sleazy FPU
> > optimization
> >
> > It's a side affect though. This is the failing scenario:
> >
> > process 'A' in save_i387_ia32() just after clear_used_math()
> >
> > Got an interrupt and pre-empted out.
> >
> > At the next context switch to process 'A' again, kernel tries to restore
> > the math state proactively and sees a fpu_counter > 0 and
> > !tsk_used_math()
> >
> > This results in init_fpu() during the __switch_to()'s
> > math_state_restore()
> >
> > And resulting in fpu corruption which will be saved/restored
> > (save_i387_fxsave and restore_i387_fxsave) during the remaining
> > part of the signal handling after the context switch.
> >
> > So in short, yes the problem shows up for preempt enabled kernels and
> > the same patch I sent out 30 mins back (appended again) should fix your
> > issue aswell. Can you please test this and check if my theory is indeed
> > correct. If it fixes your issue aswell, then I will re-post the patch
> > with a new changelog and updated comments in the patch.
> >
> 
> I have applied your patch to both an openSUSE 2.6.22.17 kernel and a 
> 2.6.26-rc4 kernel.org kernel and run the test with Einstein@home on 
> two different machines. One machine is running 24 hours now, the other 
> 18 hours.
> 
> During this time there were no faults on both machines.
> 
> As it never before took more than 12 hours until the first appearance 
> of the problem, I think your patch fixed it. Very good work!
> 
> I will continue running the test, but I believe we can call this 
> fixed.
> 
> Thank you again!

fix applied to tip/x86/urgent. Thanks everyone, nice find!

	Ingo
