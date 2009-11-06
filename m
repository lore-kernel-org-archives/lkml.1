Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZKFIej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZKFIej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZKFIei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:34:38 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35164 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZKFIeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:34:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=fQkAQYdg/Gp+VLroKUEVJGTzQQ9iPZve2cK2Rf+g4doWjVsjj6JIN+pMPSUlaViQh0
         I8503DJKn1EqgrHLrqwD8zLO//8Z2BnHsOMaqAWg3h+iWGczqZnt2943PFB7PBJDlmxi
         YAIevvNgc/kaQuTpPUZo49JtV8ue6I5L3WfpE=
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
Date: Fri, 06 Nov 2009 16:34:41 +0800
Message-ID: <1257496481.2299.30.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-11-05 at 14:16 +0100, Ralf Baechle wrote:
[...]
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

Just checked it again, seems we can only access the ISR registers, but
even if with this restriction, we can also optimize it to minimize the
number of accesses to the i8259, this is the new version:

+ isr = inb(PIC_MASTER_CMD) &
+     ~inb(PIC_MASTER_IMR) & ~(1 << PIC_CASCADE_IR);
+ if (!isr)
+    isr = (inb(PIC_SLAVE_CMD) & ~inb(PIC_SLAVE_IMR)) << 8;

Will resend it with this version.

Thanks,
	Wu Zhangjin

