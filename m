Return-Path: <linux-kernel-owner+w=401wt.eu-S965194AbXCHHsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965194AbXCHHsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 02:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965071AbXCHHsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 02:48:55 -0500
Received: from mtaout1.012.net.il ([84.95.2.1]:12299 "EHLO mtaout1.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965194AbXCHHsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 02:48:54 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 02:48:54 EST
Date: Thu, 08 Mar 2007 09:43:47 +0200
From: Avi Kivity <avi@argo.co.il>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
In-reply-to: <20070307144816.GQ18774@holomorphy.com>
To: Bill Irwin <bill.irwin@oracle.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45EFBEB3.20708@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Thu,
 08 Mar 2007 09:43:47 +0200 (IST)
References: <45E5913D.3080505@redhat.com>
 <20070228204144.GA32316@one.firstfloor.org>
 <20070304015031.GA4224@holomorphy.com> <45EDBA1B.8050007@redhat.com>
 <Pine.LNX.4.64.0703061937450.19813@blonde.wat.veritas.com>
 <20070306203432.GD18774@holomorphy.com>
 <1173241715.3236.16.camel@laptopd505.fenrus.org>
 <20070307064423.GH18774@holomorphy.com>
 <1173270892.3176.4.camel@laptopd505.fenrus.org>
 <20070307144816.GQ18774@holomorphy.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
> On Tue, 2007-03-06 at 22:44 -0800, Bill Irwin wrote:
>   
>>> What do you see as the obstacle to eliminating nested IRQ's?
>>>       
>
> On Wed, Mar 07, 2007 at 04:34:52AM -0800, Arjan van de Ven wrote:
>   
>> political will, or maybe just the lack of convincing people so far
>>     
>
> Political issues are significantly more difficult to resolve than
> technical ones.
>
>
> On Tue, 2007-03-06 at 22:44 -0800, Bill Irwin wrote:
>   
>>>  It doesn't
>>> seem so far out to test for being on the interrupt stack and defer the
>>> call to do_IRQ() until after the currently-running instance of do_IRQ()
>>> has returned, or to move to per-irq stacks modulo special arrangements
>>> for the per-cpu IRQ's. Or did you have other methods in mind?
>>>       
>
> On Wed, Mar 07, 2007 at 04:34:52AM -0800, Arjan van de Ven wrote:
>   
>> it's simpler...
>> irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
>> { 
>>         irqreturn_t ret, retval = IRQ_NONE;
>>         unsigned int status = 0;
>>
>>         handle_dynamic_tick(action);
>>    
>>         if (!(action->flags & IRQF_DISABLED))
>>                 local_irq_enable_in_hardirq();
>>
>> just removing the if() and the explicit IRQ enabling already makes irqs no longer nest...
>>     
>
> I can see why that would raise eyebrows. I can see getting bashed
> mercilessly with interrupt latency concerns as a result here. Can you
> suggest any defenses?
>   

I don't understand why interrupt latency suffers.  Sure, the interrupt 
that's being masked is delayed, but on the other hand the interrupt 
that's doing the masking is not.  We're moving the latency from the 
first interrupt to the second, probably with a slight gain in overall 
throughput.

It *does* matter if the interrupts have meaningful priorities.  Is that 
the case here?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

