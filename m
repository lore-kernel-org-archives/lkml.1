Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbXGZNzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbXGZNzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbXGZNyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:54:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:58922 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbXGZNyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ilFZNZJntrJay11/mK+oBVD4h8N+CeN/HcuiyvOVHQjguHKLI+P2VTFh3g8/CFlCLzrX5qIsVyQDyUVG9zcbYCOv0zdSb6M/NJcY/c/03XLTHI7mhPRUXMq52tGQH8nV/1E3bCclC9AIFqx0XWO5m2R9KmM8QwxHqfvqg1qBhKo=
Message-ID: <d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
Date: Thu, 26 Jul 2007 09:54:50 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?=" 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH] fix return value of i8042_aux_test_irq
Cc: linux-kernel@vger.kernel.org, vojtech@suse.cz, akpm@linux-foundation.org
In-Reply-To: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/26/07, Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:
> I made an interesting finding while testing the two patches below.
>
> http://lkml.org/lkml/2007/7/19/685
> http://lkml.org/lkml/2007/7/19/687
>
> These patches modify the traditional CONFIG_DEBUG_KERNEL in such a way
> that the request_irq prints a warning if after calling the handler it
> returned IRQ_HANDLED .
>
> The code looks like this:
>
> int request_irq(unsigned int irq, irq_handler_t handler,
>                unsigned long irqflags, const char *devname, void
> *dev_id)
> .....
>        if (irqflags & IRQF_DISABLED) {
>                unsigned long flags;
>
>                local_irq_save(flags);
>                retval = handler(irq, dev_id);
>                local_irq_restore(flags);
>        } else
>                retval = handler(irq, dev_id);
>        if (retval == IRQ_HANDLED) {
>                printk(KERN_WARNING
>                       "%s (IRQ %d) handled a spurious interrupt\n",
>                       devname, irq);
>        }
> .....
>
> I discovered that i8042_aux_test_irq handles the "fake" interrupt,
> which, in principle, is not correct because it obviously isn't a real
> interrupt and it could have been a spurious interrupt as well.
>
> The problem is that the interrupt handler unconditionally returns IRQ
> handled, which does not seem correct. Anyway I am not very familiar with
> this code so I may be missing the whole point. I would appreciate your
> comments on this.
>

The handler does handle the interrupt - both status and data registers
are read so from the keyboard controller point of view the interrupt
has been handled even if we happen to discard the data. As far as I
know IRQ12 is never shared by BIOS... Vojtech, do you remember why we
request IRQ12 with IRQF_SHARED?

-- 
Dmitry
