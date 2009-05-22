Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZEVC7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZEVC7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 22:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZEVC7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 22:59:04 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:50801 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbZEVC7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 22:59:02 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 May 2009 22:59:01 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y3vDEMvLpP9RM5s9vTUW8TU3iOS+JhpokZJRyGVvWyjwGhRQUDM5JkOb1cYxjAQtWW
         9FhlJHfo/BSl0bvJHJDybO29DmdeBzmLnMdkwbUjXlhyG/LFdOrz6Xae1ae9z+HsTIq/
         +5xwuWqCd9ErHge9QHRZ1v/frzSLrdUfxB6wU=
MIME-Version: 1.0
In-Reply-To: <200905060127.24777.rjw@sisk.pl>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	 <d6200be20905051358m34c2be02ped84ad4158cd9865@mail.gmail.com>
	 <87eiv35eg6.fsf@deeprootsystems.com> <200905060127.24777.rjw@sisk.pl>
Date: Fri, 22 May 2009 11:53:07 +0900
Message-ID: <4d34a0a70905211953r1138a554w3b7aa99770ba15e2@mail.gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
From: Kim Kyuwon <chammoru@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 6, 2009 at 8:27 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday 06 May 2009, Kevin Hilman wrote:
>> Arve Hjønnevåg <arve@android.com> writes:
>>
>> > On Tue, May 5, 2009 at 8:52 AM, Kevin Hilman
>> > <khilman@deeprootsystems.com> wrote:
>> >> Andrew Morton <akpm@linux-foundation.org> writes:
>> >>
>> >>> On Mon,  4 May 2009 17:27:04 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:
>> >>>
>> >>>> Interrupts that are flagged as wakeup sources via set_irq_wake()
>> >>>> should not be disabled for suspend.
>> >>>>
>> >>>
>> >>> Why not?
>> >>>
>> >>
>> >> If an interrupt is a wakeup source, and it is disabled at the chip
>> >> level, it will no longer generate interrupts, and thus no longer wake
>> >> up the system.
>> >>
>> >> I'd be interested in hearing why wakeup interrupts should be disabled
>> >> during suspend.
>
> That depends on whether or not they are used for anything else than wake-up.
>
>>
>> [...]
>>
>> >>>
>> >>> If this fixes some bug then please provide a description of that bug?
>> >>
>> >> The bug is that on TI OMAP, interrupts that are used for wakeup events
>> >> are disabled by this code causing the system to no longer wake up.
>> >
>> > What do you do if the interrupt triggers right after your driver has
>> > returned from its late suspend hook?
>>
>> If it's a wakeup IRQ, I assume you want it to prevent suspend.
>>
>> But I don't see how that can happen in the current code. IIUC, by the
>> time your late suspend hook is run, your device IRQ is already
>> disabled, so it won't trigger an interrupt that will be caught by
>> check_wakeup_irqs() anyways.
>
> My understanding of __disable_irq() was that it didn't actually disable the
> IRQ at the hardware level, allowing the CPU to actually receive the interrupt
> and acknowledge it, but preventing the device driver for receiving it.  Does
> it work differently on the affected systems?

Hi, Rafael.
Sorry for bring the old issue but please let me ask you about
suspend_device_irqs() function.

__disable_irq() disables the IRQ at the hardware level in the
following irq_chips

i8259A_chip
i8259_pic
i8259A_chip
bfin_internal_irqchip
crisv10_irq_type
crisv32_irq_type
h8300irq_chip
m_irq_chip
mn10300_cpu_pic_level
xtensa_irq_chip
iop13xx_msi_chip
msi_irq

Because these irq_chips mask interrupts in 'disable' hook.

Thus, your suspend_device_irqs() function disables all IRQs at the
hardware level on all architectures which use irq_chips listed above
in suspend state.
Is this really what you wanted?

If interrupt can wake up the system from suspend in some architectures
and if disable_irq_wake is not supported in these architectures, I
wonder if suspend_device_irqs() don't allow waking up by interrupt.

Regards,
Kyuwon
