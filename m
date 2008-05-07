Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbYEGQgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbYEGQgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYEGQgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:36:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239AbYEGQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:36:34 -0400
Date: Wed, 7 May 2008 09:35:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507162012.GA10096@elte.hu>
Message-ID: <alpine.LFD.1.10.0805070929310.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org>
 <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <20080507162012.GA10096@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Ingo Molnar wrote:
> 
> I think it is far more likely that it's due to the different scheduling 
> and wakeup behavior of the new kernel/semaphore.c code. So the fix would 
> be to restore the old scheduling behavior - that's what Yanmin's manual 
> revert did and that's what got him back the previous AIM7 performance.

Yes, Yanmin's manual revert got rid of the new semaphores entirely. Which 
was what, 7500 lines of code removed that got reverted.

And the *WHOLE* and *ONLY* excuse for dropping the spinlock lock_kernel 
was this (and I quote your message):

    remove the !PREEMPT_BKL code.
    
    this removes 160 lines of legacy code.

in other words, your only stated valid reason for getting rid of the 
spinlock was 160 lines, and the comment didn't even match what it did (it 
removed the spinlocks entirely, not just the preemptible version).

In contrast, the revert adds 7500 lines. If you go by the only documented 
reason for the crap that is the current BKL, then I know which one I'll 
take. I'll take the spinlock back, and I'd rather put preemption back 
than ever take those semaphores.

And even that's ignoring another issue: did anybody ever even do that AIM7 
benchmark comparing spinlocks to the semaphore-BKL? It's quite possible 
that the semaphores (even the well-behaved ones) behaved worse than the 
spinlocks.

		Linus
