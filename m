Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYGXSfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYGXSfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYGXSfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:35:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbYGXSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:34:59 -0400
Date: Thu, 24 Jul 2008 11:31:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: x86@kernel.org, andi@firstfloor.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
In-Reply-To: <20080724180429.GI14380@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org>
References: <20080724180429.GI14380@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jul 2008, Suresh Siddha wrote:
> 
> In the error condition for restore_fpu_checking() (especially during
> the 64bit signal return), we are doing init_fpu(), which saves the live
> FPU register state (possibly belonging to some other process context) into the
> thread struct (through unlazy_fpu() in init_fpu()). This is wrong and can leak
> the FPU data.
> 
> Remove the unlazy_fpu() from the init_fpu(). init_fpu() will now always
> init the FPU data in the thread struct. For the error conditions in
> restore_fpu_checking(), restore the initialized FPU data from the thread
> struct.

Why? The thread struct is guaranteed to contain pointless data.

If we cannot restore the FP state from the signal stack, we should not try 
to restore it from anywhere _else_ either, since nowhere else will have 
any better results.

I suspect we should just reset the x87 state (which was the _intention_ of 
the code), possibly by just doing "stts + used_math = 0". The signal 
handling code already checks for errors, and will force a SIGSEGV if this 
ever happens.

(Yes, there is also a restore_fpu_checking() in math_state_restore(), but 
that one _already_ uses &current->thread.xstate->fxsave as the buffer to 
restore from, so trying to do that _again_ when it fails seems to be 
really really wrong - we already _did_ that, and that was what failed to 
begin with)

				Linus
