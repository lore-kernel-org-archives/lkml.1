Return-Path: <linux-kernel-owner+w=401wt.eu-S933357AbXBXCqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbXBXCqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 21:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933355AbXBXCqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 21:46:31 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:39795 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352AbXBXCqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 21:46:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZFJ+985pj25sIK9xFIjeB7+r4XFGHtZP9Lmmrjv7GJLIw7AqICCxs4tYmMqT3TLsRM5gj5peuJZGjwXFCPrRWpR8+VBnlfNHoFUQh7NAboVmR9+AXn/BMluebq3gkAySdPTHNifrQjecoAVU36jocBlUXX1Bh1pDSWtxpF4SNy4=
Message-ID: <f2b55d220702231846l7052d65g4fe56534e0f28ef@mail.gmail.com>
Date: Fri, 23 Feb 2007 18:46:29 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Jose Goncalves" <jose.goncalves@inov.pt>,
       "Frederik Deweerdt" <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
In-Reply-To: <20070219232020.GL27370@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070220144814.GJ566@slug> <45D9D073.7020701@inov.pt>
	 <20070219164200.GF27370@flint.arm.linux.org.uk>
	 <45D9E46C.4030408@inov.pt>
	 <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com>
	 <20070219205153.GH27370@flint.arm.linux.org.uk>
	 <f2b55d220702191324s17c9cc87xc581a9beba2644f8@mail.gmail.com>
	 <20070219213151.GJ27370@flint.arm.linux.org.uk>
	 <f2b55d220702191416k479aa8c0gad4f42e306f26ecb@mail.gmail.com>
	 <20070219232020.GL27370@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell, thanks again for offering to look at this; the more oopses
and soft lockups I see on this board, the more I think you're right
and we have an IRQ handling race.

Here's the struct irqchip setup:

/* mask irq, refer ssection 2.6 under chip 8618 document */
static void mv88w8xx8_mask_irq(unsigned int irq)
{
        MV88W8XX8_REG_WRITE(MV88W8XX8_INT_ENABLE_CLR,(1 << irq));
}

/* unmask irq, refer ssection 2.6 under chip 8618 document */
static void mv88w8xx8_unmask_irq(unsigned int irq)
{
        MV88W8XX8_REG_WRITE(MV88W8XX8_INT_ENABLE_SET,(1 << irq));
}

/* ack to CPU interrupts and also individual timer interrupts */
static void mv88w8xx8_mask_ack_irq(unsigned int irq)
{
        mv88w8xx8_mask_irq(irq);

        if (irq < IRQ_TIMER1 || irq > IRQ_TIMER4) return;

        /* write 0 to clear interrupt and  re-enable further interrupts */
        MV88W8XX8_REG_WRITE(MV88W8XX8_TIMER_INT_SOURCE, ~(1<<(irq-4)));
}

static struct irqchip mv88w8xx8_chip = {
        .ack    = mv88w8xx8_mask_ack_irq,
        .mask   = mv88w8xx8_mask_irq,
        .unmask = mv88w8xx8_unmask_irq,
};

/**
 * called by core.c to  initialize the IRQ module
 */
void mv88w8xx8_init_irq(void)
{
        int irq;

        for (irq = 0; irq < NR_IRQS; irq++) {
                set_irq_chip(irq, &mv88w8xx8_chip);
                set_irq_handler(irq, do_level_IRQ);
                set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
        }
}
