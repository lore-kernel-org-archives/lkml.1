Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYGZOiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYGZOiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 10:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYGZOiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 10:38:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59578 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYGZOiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 10:38:14 -0400
Date: Sat, 26 Jul 2008 16:37:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
Message-ID: <20080726143756.GK4401@elte.hu>
References: <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org> <20080724202728.GL14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org> <20080724212351.GM14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241431180.8109@nehalem.linux-foundation.org> <20080724222523.GN14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241532240.8109@nehalem.linux-foundation.org> <20080725010755.GQ14380@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725010755.GQ14380@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Thu, Jul 24, 2008 at 03:43:44PM -0700, Linus Torvalds wrote:
> > So how about this patch as a starting point? This is the RightThing(tm) to
> > do regardless, and if it then makes it easier to do some other cleanups,
> > we should do it first. What do you think?
> 
> Linus, Attached is my last attempt for the day. Please review. Thanks.
> ---
> 
> restore_fpu_checking() calls init_fpu() in error conditions. While 
> this is wrong(as our main intention is to clear the fpu state of the 
> thread), this was benign before the commit 
> 92d140e21f1ce8cf99320afbbcad73879128e6dc.
> 
> Post commit 92d140e21f1ce8cf99320afbbcad73879128e6dc, live FPU 
> registers may not belong to this process at this error scenario.
> 
> In the error condition for restore_fpu_checking() (especially during 
> the 64bit signal return), we are doing init_fpu(), which saves the 
> live FPU register state (possibly belonging to some other process 
> context) into the thread struct (through unlazy_fpu() in init_fpu()). 
> This is wrong and can leak the FPU data.
> 
> For the signal handler restore error condition in restore_i387(), 
> clear the fpu state present in the thread struct(before ultimately 
> sending a SIGSEGV for badframe).
> 
> For the paranoid error condition check in math_state_restore(), send a 
> SIGSEGV, if we fail to restore the state.

i've applied your patch to tip/x86/fpu for further testing. I suspect 
once it proves reliable we can merge it into v2.6.27, after -rc1.

	Ingo
