Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZKFFjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZKFFjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZKFFjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:39:44 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35473 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbZKFFjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=OtQ07kUJxKaBrjszk6uL0XQOMsDqnzeAVTJUt5t5hzVkMzLt42WAm+B2CbTC9bG2ld
         W9Va6KI4YHBuOpQjZqxPUVZcYL+l9/0lgw+PMlreff3pUPQv3c2NWOQg6PLjBLlDz6Lb
         4i3tHg27PMPJpiG7xl+o/QqAWzmwD+edcrvyQ=
Subject: Re: [PATCH -queue v0 4/6] [loongson] add basic fuloong2f support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
       huhb@lemote.com, yanh@lemote.com, Zhang Le <r0bertz@gentoo.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
In-Reply-To: <20091105131603.GA18232@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	 <0f805f7d12c5a7cbcc125ba4a1b70113ec2047a6.1257325319.git.wuzhangjin@gmail.com>
	 <20091105131603.GA18232@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 06 Nov 2009 13:39:44 +0800
Message-ID: <1257485984.2299.21.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 14:16 +0100, Ralf Baechle wrote:
> On Wed, Nov 04, 2009 at 05:05:47PM +0800, Wu Zhangjin wrote:
> 
> > diff --git a/arch/mips/loongson/fuloong-2f/irq.c b/arch/mips/loongson/fuloong-2f/irq.c
> > new file mode 100644
> > index 0000000..22c45fd
> > --- /dev/null
> > +++ b/arch/mips/loongson/fuloong-2f/irq.c
> > @@ -0,0 +1,114 @@
> > +/*
> > + * Copyright (C) 2007 Lemote Inc.
> > + * Author: Fuxin Zhang, zhangfx@lemote.com
> > + *
> > + *  This program is free software; you can redistribute  it and/or modify it
> > + *  under  the terms of  the GNU General  Public License as published by the
> > + *  Free Software Foundation;  either version 2 of the  License, or (at your
> > + *  option) any later version.
> > + */
> > +
> > +#include <linux/interrupt.h>
> > +
> > +#include <asm/irq_cpu.h>
> > +#include <asm/i8259.h>
> > +#include <asm/mipsregs.h>
> > +
> > +#include <loongson.h>
> > +#include <machine.h>
> > +
> > +#define LOONGSON_TIMER_IRQ	(MIPS_CPU_IRQ_BASE + 7)	/* cpu timer */
> > +#define LOONGSON_PERFCNT_IRQ	(MIPS_CPU_IRQ_BASE + 6) /* cpu perf counter */
> > +#define LOONGSON_NORTH_BRIDGE_IRQ	(MIPS_CPU_IRQ_BASE + 6)	/* bonito */
> > +#define LOONGSON_UART_IRQ	(MIPS_CPU_IRQ_BASE + 3)	/* cpu serial port */
> > +#define LOONGSON_SOUTH_BRIDGE_IRQ	(MIPS_CPU_IRQ_BASE + 2)	/* i8259 */
> > +
> > +#define LOONGSON_INT_BIT_INT0		(1 << 11)
> > +#define LOONGSON_INT_BIT_INT1		(1 << 12)
> > +
> > +static int mach_i8259_irq(void)
> > +{
> > +	int irq, isr, imr;
> > +
> > +	irq = -1;
> > +
> > +	if ((LOONGSON_INTISR & LOONGSON_INTEN) & LOONGSON_INT_BIT_INT0) {
> > +		imr = inb(0x21) | (inb(0xa1) << 8);
> > +		isr = inb(0x20) | (inb(0xa0) << 8);
> > +		isr &= ~0x4;	/* irq2 for cascade */
> > +		isr &= ~imr;
> > +		irq = ffs(isr) - 1;
> > +	}
> 
> Any reason why you're not using i8259_irq() from <asm/i8259.h> here?
> That function not only gets the locking right, it also minimizes the number
> of accesses to the i8259 - which even on modern silicon can be stuningly
> slow.
> 

Hi, Ralf

Just asked Yanhua, He told me there is a bug in cs5536, if using the
i8259_irq() directly, we can not get the irq. and just tried it, the
kernel hang on booting.

Regards,
	Wu Zhangjin

