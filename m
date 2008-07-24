Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYGXSwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYGXSwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYGXSv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:51:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:7273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYGXSvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:51:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,248,1215414000"; 
   d="scan'208";a="600711069"
Date: Thu, 24 Jul 2008 11:50:53 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
Message-ID: <20080724185053.GJ14380@linux-os.sc.intel.com>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:31:42AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 24 Jul 2008, Suresh Siddha wrote:
> >
> > In the error condition for restore_fpu_checking() (especially during
> > the 64bit signal return), we are doing init_fpu(), which saves the live
> > FPU register state (possibly belonging to some other process context) into the
> > thread struct (through unlazy_fpu() in init_fpu()). This is wrong and can leak
> > the FPU data.
> >
> > Remove the unlazy_fpu() from the init_fpu(). init_fpu() will now always
> > init the FPU data in the thread struct. For the error conditions in
> > restore_fpu_checking(), restore the initialized FPU data from the thread
> > struct.
> 
> Why? The thread struct is guaranteed to contain pointless data.

init_fpu() will set it to sane init state, from where we can restore.

> If we cannot restore the FP state from the signal stack, we should not try
> to restore it from anywhere _else_ either, since nowhere else will have
> any better results.
> 
> I suspect we should just reset the x87 state (which was the _intention_ of
> the code), possibly by just doing "stts + used_math = 0". The signal
> handling code already checks for errors, and will force a SIGSEGV if this
> ever happens.

Yes, this was what I had in mind earlier and should be ok for signal handling
case. But as you also noted below:

> (Yes, there is also a restore_fpu_checking() in math_state_restore(), but
> that one _already_ uses &current->thread.xstate->fxsave as the buffer to
> restore from, so trying to do that _again_ when it fails seems to be
> really really wrong - we already _did_ that, and that was what failed to
> begin with)

We are doing init_fpu(), which should make the data sane again.

This is a paranoid case, just to make sure that the next
math_state_restore()  doesn't cause #GP, after someone sets illegal values
through ptrace() or 32bit signal handling (which modifies fpu state in thread
struct). I say paranoid, because we already do the necessary checks
in the corresponding locations like ptrace/32-bit signal handling.

If we don't do init_fpu() + restore from the sane init state, process has
to be killed, in the paranoid failing scenario of math_state_restore()

thanks,
suresh
