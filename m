Return-Path: <linux-kernel-owner+w=401wt.eu-S1764622AbXGZOjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764622AbXGZOjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXGZOjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:39:15 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:51229 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbXGZOjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:39:15 -0400
Message-ID: <1422.172.50.1.13.1185460753.squirrel@172.19.0.2>
In-Reply-To: <d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
References: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp>
    <d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
Date: Thu, 26 Jul 2007 23:39:13 +0900 (JST)
Subject: Re: [PATCH] fix return value of i8042_aux_test_irq
From: fernando@oss.ntt.co.jp
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, vojtech@suse.cz,
       akpm@linux-foundation.org
User-Agent: SquirrelMail/1.4.8-2.el4
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, July 26, 2007 10:54 pm, Dmitry Torokhov wrote:
> Hi,
>
> On 7/26/07, Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:
>> I made an interesting finding while testing the two patches below.
>>
>> http://lkml.org/lkml/2007/7/19/685
>> http://lkml.org/lkml/2007/7/19/687
>>
>> These patches modify the traditional CONFIG_DEBUG_KERNEL in such a way
>> that the request_irq prints a warning if after calling the handler it
>> returned IRQ_HANDLED .
>>
>> The code looks like this:
>>
>> int request_irq(unsigned int irq, irq_handler_t handler,
>>                unsigned long irqflags, const char *devname, void
>> *dev_id)
>> .....
>>        if (irqflags & IRQF_DISABLED) {
>>                unsigned long flags;
>>
>>                local_irq_save(flags);
>>                retval = handler(irq, dev_id);
>>                local_irq_restore(flags);
>>        } else
>>                retval = handler(irq, dev_id);
>>        if (retval == IRQ_HANDLED) {
>>                printk(KERN_WARNING
>>                       "%s (IRQ %d) handled a spurious interrupt\n",
>>                       devname, irq);
>>        }
>> .....
>>
>> I discovered that i8042_aux_test_irq handles the "fake" interrupt,
>> which, in principle, is not correct because it obviously isn't a real
>> interrupt and it could have been a spurious interrupt as well.
>>
>> The problem is that the interrupt handler unconditionally returns IRQ
>> handled, which does not seem correct. Anyway I am not very familiar with
>> this code so I may be missing the whole point. I would appreciate your
>> comments on this.
>>
>
> The handler does handle the interrupt - both status and data registers
> are read so from the keyboard controller point of view the interrupt
> has been handled even if we happen to discard the data. As far as I
> know IRQ12 is never shared by BIOS... Vojtech, do you remember why we
> request IRQ12 with IRQF_SHARED?
Hi Dmitry,

Thank you for the feedback.

Isn't there a way to tell whether the interrupt came from a different
source? If it is not possible the IRQF_SHARED flag does not seem
appropriate to me. If we return IRQ_HANDLED unconditionally we may end up
preventing the right interrupt handler from executing. Am I missing
something?

Fernando

