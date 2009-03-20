Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZCTOIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZCTOIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbZCTOIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:08:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:7222 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbZCTOIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:08:12 -0400
Message-ID: <49C3A346.5040202@monstr.eu>
Date: Fri, 20 Mar 2009 15:08:06 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu> <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu> <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu> <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain> <49C2AB09.9040300@monstr.eu> <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> On Thu, 19 Mar 2009, Michal Simek wrote:
>>>> +	__do_IRQ(irq);
>>> You use irq chips now and you set the type handlers (edge/level), but
>>> you still call __do_IRQ() the all in one fits nothing handler, which
>>> is going to be deprecated and removed.
>> I know about.
>>> Please call 
>>>        generic_handle_irq(irq);
>>>
>>> which will call the correct flow handlers.
>> I would like to use it but don't work with edge interrupt.
>> __do_IRQ handle it in right way.
>>
>> I used this implementation but I did some change edge/level handling and I can't
>> use it.
>> http://developer.petalogix.com/git/gitweb.cgi?p=linux-2.6-microblaze.git;a=blob_plain;f=arch/microblaze/kernel/irq.c;hb=3645d887ad6443a262bbeddf384038321172db2b
>>
>> Any hints what could be wrong?
>  
> Look at the different handling schemes of __do_IRQ and handle_edge_irq
> vs. the chip functions:
> 
> __do_IRQ() does:
> {
> 	   chip->ack();
> 	   
> 	   handle_IRQ_event();
> 
> 	   chip->end();
> }
> 
> handle_edge_irq() does:
> {
> 	if ((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
>                     !desc->action)) {
>                 desc->status |= (IRQ_PENDING | IRQ_MASKED);
>                 mask_ack_irq(desc, irq);
> 		goto out_unlock;
> 	}
> 
> 	chip->ack();
> 	handle_IRQ_event();
> 
> }
> 
> I guess the problem is in your chip->xxx functions.

I fixed it. There were one additional line.
+ I set GENERIC_HARDIRQS_NO__DO_IRQ=y.

BTW: Below is full chip description where function enable is unmask
and disable is mask. Do I have keep there enable and disable function pointers?
I commented them and works without them too.


static struct irq_chip intc_dev = {
	.name = "Xilinx INTC",
	.enable = intc_enable_or_unmask,
	.unmask = intc_enable_or_unmask,
	.disable = intc_disable_or_mask,
	.mask = intc_disable_or_mask,
	.ack = intc_ack,
	.mask_ack = intc_mask_ack,
	.end = intc_end,
};

Thanks,
Michal
