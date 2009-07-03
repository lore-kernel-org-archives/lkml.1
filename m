Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbZGCSNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbZGCSNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZGCSNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:13:15 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:34111 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZGCSNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E1B7WFUAqZcCs2wz2TcOqteE3tdk6RUl/2l6CPhPfw5WddzGmLG/R2MysOrKhVQfqk
         QUxFkTGY3+VddtbE1rbxd7F3a8yHqujczEnP+iU3dqKPRy4WJ3wQ0VHd7S4Z4FNFn2c7
         L/sH2q6BpBsI1ZrWgcYygWnz6QINR1jvEmW8M=
MIME-Version: 1.0
In-Reply-To: <200907031751.46280.arnd@arndb.de>
References: <8bd0f97a0907030114g459863e9l829a6291e990b9cf@mail.gmail.com> 
	<200907031751.46280.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 3 Jul 2009 14:12:58 -0400
Message-ID: <8bd0f97a0907031112k3b1c0941r41bd126d9fcedcfc@mail.gmail.com>
Subject: Re: making asm-generic/futex.h completely usable
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 11:51, Arnd Bergmann wrote:
> On Friday 03 July 2009, Mike Frysinger wrote:
>> ive been reading up on futexes of late and have been poking around the
>> futex kernel pieces to see what is needed to get Blackfin working with
>> it.
>>
>> Blackfin falls into the "no hardware atomic instructions" category as
>> can easily be seen in our atomic.h: disable interrupts, do
>> load/stores, restore interrupts.  my understanding of the
>> futex_atomic_op_inuser() function is that this runs in process
>> context, so this same interrupt trick should work fine.  which leads
>> me to wonder why doesnt the asm-generic/futex.h header already take
>> this approach ?
>
> The code does not run in user space, the name indicates that it
> operates on variables in user space while running in the kernel.

when i said "process context" i didnt mean it was running in usermode.
 i meant the context of the kernel execution is of a process, so it
can sleep.  since it needs to use get/put user, that means it can
sleep fine.

> The irq-disable trick fundamentally does not work on SMP systems,
> which need architecture specific atomic operations for this.

i'm guessing spin lock with irq semantics wouldnt work due to the
possibility of get/put user sleeping ...

>> seems to me that the SuperH implementation fits the bill nicely.
>> their arch/sh/include/asm/futex-irq.h looks like it could be literally
>> straight copied into asm-generic/futex.h thus making it fully
>> functional for everyone by default.
>
> That sounds reasonable for the arch/sh/include/asm/futex.h file, but
> the futex-irq.h file would still be reserved for non-SMP architectures.
> I believe that out of the architectures currently using asm-generic/futex.h,
> blackfin is the only one that supports SMP, so you still lose ;-)

if the functions were able to be overridden on a per-function basis,
that is easy to handle with CONFIG_SMP in the Blackfin header.
-mike
