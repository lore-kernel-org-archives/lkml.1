Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYE0JqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYE0JqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 05:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYE0JqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 05:46:12 -0400
Received: from gw.goop.org ([64.81.55.164]:40088 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbYE0JqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 05:46:11 -0400
Message-ID: <483BD843.5080009@goop.org>
Date: Tue, 27 May 2008 10:45:39 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: Question about interrupt routing and irq allocation
References: <483B34CA.8000600@goop.org> <20080527083729.GF29246@elte.hu>
In-Reply-To: <20080527083729.GF29246@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, in theory the highest quality method would be to do this on the 
> genirq level and register your own special "Xen irq-chip" methods. [see 
> include/linux/irq.h's "struct irq_chip" and kernel/irq/*.c]
>   

I already have one of those for pv guests, and I think I can reuse it 
more or less unchanged.

> you can use set_irq_chip() to claim a specific irq and set up its 
> handling at the highest level. That way you dont have to do anything in 
> the x86 hw vector space at all and you'd avoid all the overhead and 
> complications of x86 irq vectors. You can control how these interrupts 
> are named in /proc/interrupts, etc.
>   

Yeah, that was my plan.

> but this needs synchronization with all the other entities that claim 
> specific irqs and expect to be able to get them. MSI already does that 
> to a certain level, see arch_setup_msi_irq() / set_irq_msi(). But that 
> wastes x86 vectors and we dont really want to waste them as you dont 
> actually want to use any separate per irq hw vectoring mechanism for 
> these interrupts.
>   

OK.  So if I just used create_irq() that would get me an irq I can use, 
but would also end up allocating a vector too.

> So the most intelligent method would be to reserve the Linux irq itself 
> but not the vector, i.e. allocate from irq_cfg[] in 
> arch/x86/kernel/io_apic_64.c so that the irq number does not get reused 
> - setting irq_cfg[irq].vector to -1 will achieve that.
>   

I'm initially targeting 32-bit, though obviously I'd like something that 
works for both 32 and 64 bit.  irq_cfg[] is missing in io_apic_32.c; 
would I achieve the same effect by setting irq_vector[irq] = 0xff or 
something?

Thanks,
    J
