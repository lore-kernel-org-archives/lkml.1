Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbYEEMkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbYEEMkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYEEMkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:40:04 -0400
Received: from www.tglx.de ([62.245.132.106]:53705 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbYEEMkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:40:01 -0400
Date: Mon, 5 May 2008 14:39:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandeen@sandeen.net
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
 II
In-Reply-To: <481EDEC5.10000@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0805051434200.3318@apollo.tec.linutronix.de>
References: <20080502091806.GA26062@basil.nowhere.org> <20080502094543.GA11114@basil.nowhere.org> <alpine.LFD.1.10.0805051135530.3318@apollo.tec.linutronix.de> <481EDEC5.10000@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-176431814-1209991182=:3318"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-176431814-1209991182=:3318
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Mon, 5 May 2008, Andi Kleen wrote:
> Thomas Gleixner wrote:
> > On Fri, 2 May 2008, Andi Kleen wrote:
> >> +static void stack_overflow(void)
> >> +{
> >> +	printk("low stack detected by irq handler\n");
> > 
> > Needs a KERN_ERR
> 
> Just moving code. If there is one added it should be in another patch.

Err, you are not moving code. The printk is pretty different and
adding the KERN_xx in the same go is nothing which makes the patch
harder to understand.

> Besides if anything it's a KERN_WARN I guess.

KERN_WARN is fine, even if I consider a stack overflow as an error.

> > 
> >> +		/* Execute warning on interrupt stack */
> >> +		if (unlikely(overflow))
> >> +			call_on_stack2(stack_overflow, isp, 0, 0);
> >> +
> >> +		call_on_stack2(desc->handle_irq, isp, irq, desc);
> > 
> > arch/x86/kernel/irq_32.c:148: warning: passing argument 2 of ¡call_on_stack2¢ makes integer from pointer without a cast
> > arch/x86/kernel/irq_32.c:150: warning: passing argument 2 of ¡call_on_stack2¢ makes integer from pointer without a cast
> > arch/x86/kernel/irq_32.c:150: warning: passing argument 4 of ¡call_on_stack2¢ makes integer from pointer without a cast
> 
> Hmm, strange. I don't see that here
> 
> 
>   CC      arch/x86/kernel/irq_32.o
>   CC      arch/x86/kernel/time_32.o
> 
> gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)
> 
> What compiler are you using? Or did you change anything? (I know you
> like to do that)

I noticed on review and just compiled the unmodified patch with 4KSTACKS=y. 
 
> >>  	} else
> >>  #endif
> >> -		desc->handle_irq(irq, desc);
> >> +	{
> >> +		/* AK: Slightly bogus here */
> > 
> > Bogus comment. This applies to both the !4KSTACKS and the overflow of
> > the irq stack in the 4KSTACKS case.
> 
> The comment refers to that the check here doesn't check the process
> stack, but the interrupt stack. In fact if the interrupt stack is near
> overflow we should probably just reject the interrupt? Although that
> might cause hangs too. Or perhaps just enlarge it [that is now possible
> with i386 pda with some effort]. Anyways it is probably not an
> interesting case because nested interrupts are rare.

Err, it checks the process stack when 4KSTACKS=n

> >> +		if (overflow)
> > 
> > unlikely(overflow) ?
> 
> Doesn't matter really. The whole branch is unlikely.

There is no branch with 4KSTACKS=n

Thanks,

	tglx
--8323328-176431814-1209991182=:3318--
