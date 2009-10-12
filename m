Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZJLIY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZJLIY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZJLIY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:24:56 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:46139 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbZJLIYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BticOWFqpaTnbYLzcsBYd/bTkED4eZ/0tUuDkat0Ws1pQgw3rHLXe5trqoflfDk+fZ
         sjcZ4mzb1tNc3080d/Gibyvq0PnkxEb8B4wSLIV5poF0XuWpkoaEOXN9wiEK5Kttm+AG
         /XEPiU29eWgPs2ge5rkBnRPC8Rg0IPfijRWkk=
MIME-Version: 1.0
In-Reply-To: <20091009.162120.164441279.davem@davemloft.net>
References: <505766fa0909230040m13e3dc34x2ceb83848767d825@mail.gmail.com>
	 <505766fa0909231903t2fe2f7b6y26d2681d6d38ef0e@mail.gmail.com>
	 <20091009.150829.218507309.davem@davemloft.net>
	 <20091009.162120.164441279.davem@davemloft.net>
Date: Mon, 12 Oct 2009 16:23:47 +0800
Message-ID: <505766fa0910120123l51b57b8aja30a5d0fd1225c0d@mail.gmail.com>
Subject: Re: Linux guest domain with two vnets bound to the same vswitch 
	experiences hung in bootup (sun_netraT5220)
From: hyl <heyongli@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/10 David Miller <davem@davemloft.net>:
> From: David Miller <davem@davemloft.net>
> Date: Fri, 09 Oct 2009 15:08:29 -0700 (PDT)
>
>> Thank you for this bug report and patch, I am looking at
>> it now.
>
> I'm trying to figure out how the deadlock can even occur,
> and I've failed so far, please help me :-)
>
> See, we always take the VIO and LDC locks in the same order
> (VIO then LDC) and always with interrupts disabled, so it is
> not possible to deadlock.
>
> The only way we could deadlock is if:
>
> 1) There is some path that takes the LDC lock before the VIO one.
>
> 2) There is some path that takes either lock with interrupts
>   enabled.
>
> And I cannot find any such case.
David
 Thank you, i try to figure out the path which lead to system hang. i got the
output log :(the same output run18350079 times and going forever ... )

ctl: 17, data:0 err:0, abr:0   runcc:18350079 CPUId:0, event: 0x00000004
qall Trace:
s[00000000004acb30] _handle_IRQ_event+0x50/0x120
C[00000000004acc70] handle_IRQ_event+0x70/0x120
 [00000000004af14c] handle_fasteoi_irq+0xcc/0x180
 [000000000042ee54] handler_irq+0x134/0x160
 [00000000004208b4] tl0_irq5+0x14/0x20
 [00000000004acbac] _handle_IRQ_event+0xcc/0x120
 [00000000004acc70] handle_IRQ_event+0x70/0x120
 [00000000004af14c] handle_fasteoi_irq+0xcc/0x180
 [000000000042ee54] handler_irq+0x134/0x160
 [00000000004208b4] tl0_irq5+0x14/0x20
 [00000000004acbac] _handle_IRQ_event+0xcc/0x120
 [00000000004acc70] handle_IRQ_event+0x70/0x120
 [00000000004af14c] handle_fasteoi_irq+0xcc/0x180
 [000000000042ee54] handler_irq+0x134/0x160
 [00000000004208b4] tl0_irq5+0x14/0x20
 [00000000007e7ffc] _spin_unlock_irqrestore+0x3c/0x60



>runcc:18350079 CPUId:0, event: 0x00000004
the runcc is the count  of  times ldx_rx been run. dump code:

static irqreturn_t ldc_rx(int irq, void *dev_id)
{
  ....
  atomic64_inc(&runcc);
  ....
  printk(KERN_INFO"runcc:%lld CPUId:%d, event: 0x%08x\n",
  atomic_read(&runcc), smp_processor_id(),event_mask);
   dump_stack();

}

look the console output, system seems hang on a live lock:
tl0_irq5 triggered just after the irq been re-enable in the handler
of irq5: the ldc_rx.

i have no idea about the t10_irq5, just guess that: the special
configuration lead to t10_irq5 been triggered continuously, and
the trigger condition can not been cleared.


Pauli He



>
> It might help if you run your test case with lockdep enabled.  It will
> find such deadlocks and report them precisely to the kernel logs.
>
> Thank you!
>
