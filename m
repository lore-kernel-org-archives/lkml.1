Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbYEEKVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbYEEKVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbYEEKRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:17:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33985 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbYEEKRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:17:52 -0400
Message-ID: <481EDEC5.10000@firstfloor.org>
Date: Mon, 05 May 2008 12:17:41 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, sandeen@sandeen.net
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
 II
References: <20080502091806.GA26062@basil.nowhere.org> <20080502094543.GA11114@basil.nowhere.org> <alpine.LFD.1.10.0805051135530.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805051135530.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 2 May 2008, Andi Kleen wrote:
>> +static void stack_overflow(void)
>> +{
>> +	printk("low stack detected by irq handler\n");
> 
> Needs a KERN_ERR

Just moving code. If there is one added it should be in another patch.
Besides if anything it's a KERN_WARN I guess.

> 
>> +		/* Execute warning on interrupt stack */
>> +		if (unlikely(overflow))
>> +			call_on_stack2(stack_overflow, isp, 0, 0);
>> +
>> +		call_on_stack2(desc->handle_irq, isp, irq, desc);
> 
> arch/x86/kernel/irq_32.c:148: warning: passing argument 2 of ¡call_on_stack2¢ makes integer from pointer without a cast
> arch/x86/kernel/irq_32.c:150: warning: passing argument 2 of ¡call_on_stack2¢ makes integer from pointer without a cast
> arch/x86/kernel/irq_32.c:150: warning: passing argument 4 of ¡call_on_stack2¢ makes integer from pointer without a cast

Hmm, strange. I don't see that here


  CC      arch/x86/kernel/irq_32.o
  CC      arch/x86/kernel/time_32.o

gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)

What compiler are you using? Or did you change anything? (I know you
like to do that)


>>  	} else
>>  #endif
>> -		desc->handle_irq(irq, desc);
>> +	{
>> +		/* AK: Slightly bogus here */
> 
> Bogus comment. This applies to both the !4KSTACKS and the overflow of
> the irq stack in the 4KSTACKS case.

The comment refers to that the check here doesn't check the process
stack, but the interrupt stack. In fact if the interrupt stack is near
overflow we should probably just reject the interrupt? Although that
might cause hangs too. Or perhaps just enlarge it [that is now possible
with i386 pda with some effort]. Anyways it is probably not an
interesting case because nested interrupts are rare.

>> +		if (overflow)
> 
> unlikely(overflow) ?

Doesn't matter really. The whole branch is unlikely.

-Andi
