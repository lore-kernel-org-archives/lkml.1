Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbZEWAnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbZEWAnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 20:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbZEWAnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 20:43:09 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:46648 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbZEWAnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 20:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bN982wzW3gHUJN8jczmu2ocmDD40jWGg1LQLKAZCe7UIGdO25luJ3ibiXgbnl6L58q
         JjVpsPDr+drsN9l0giukvKVy1tQvAqMdkvO4VlS3WFNHjF9oBFqXuEMkmnaabq1LzSva
         pexY8nF9JP9/KutzEYw+JuJmP8PvsJZidGF5c=
MIME-Version: 1.0
In-Reply-To: <200905230147.16037.rjw@sisk.pl>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com> 
	<200905222325.27950.rjw@sisk.pl> <4d34a0a70905221532l772d03b6gb6436f0b8eb10274@mail.gmail.com> 
	<200905230147.16037.rjw@sisk.pl>
From: Kim Kyuwon <chammoru@gmail.com>
Date: Sat, 23 May 2009 09:42:49 +0900
Message-ID: <4d34a0a70905221742rd2456f7tbef5bf01f7797e8f@mail.gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Kyungmin Park <kyungmin.park@samsung.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 8:47 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >>> > What do you do if the interrupt triggers right after your driver has
>> >> >>> > returned from its late suspend hook?
>> >> >>>
>> >> >>> If it's a wakeup IRQ, I assume you want it to prevent suspend.
>> >> >>>
>> >> >>> But I don't see how that can happen in the current code. IIUC, by the
>> >> >>> time your late suspend hook is run, your device IRQ is already
>> >> >>> disabled, so it won't trigger an interrupt that will be caught by
>> >> >>> check_wakeup_irqs() anyways.
>> >> >>
>> >> >> My understanding of __disable_irq() was that it didn't actually disable the
>> >> >> IRQ at the hardware level, allowing the CPU to actually receive the interrupt
>> >> >> and acknowledge it, but preventing the device driver for receiving it.  Does
>> >> >> it work differently on the affected systems?
>> >> >
>> >> > Hi, Rafael.
>> >> > Sorry for bring the old issue but please let me ask you about
>> >> > suspend_device_irqs() function.
>> >> >
>> >> > __disable_irq() disables the IRQ at the hardware level in the
>> >> > following irq_chips
>> >> >
>> >> > i8259A_chip
>> >> > i8259_pic
>> >> > i8259A_chip
>> >> > bfin_internal_irqchip
>> >> > crisv10_irq_type
>> >> > crisv32_irq_type
>> >> > h8300irq_chip
>> >> > m_irq_chip
>> >> > mn10300_cpu_pic_level
>> >> > xtensa_irq_chip
>> >> > iop13xx_msi_chip
>> >> > msi_irq
>> >> >
>> >> > Because these irq_chips mask interrupts in 'disable' hook.
>> >> >
>> >> > Thus, your suspend_device_irqs() function disables all IRQs at the
>> >> > hardware level on all architectures which use irq_chips listed above
>> >> > in suspend state.
>> >> > Is this really what you wanted?
>> >> >
>> >> > If interrupt can wake up the system from suspend in some architectures
>> >> > and if disable_irq_wake is not supported in these architectures, I
>> >> > wonder if suspend_device_irqs() don't allow waking up by interrupt.
>> >> >
>> >> > Regards,
>> >> > Kyuwon
>> >> >
>> >>
>> >> I saw resume_device_irqs() is invoked after arch_suspend_enable_irqs()
>> >> in your resume code.
>> >> So in this gap between resume_device_irqs() and
>> >> arch_suspend_enable_irqs(), a few interrupts would be discarded.
>> >> i.e, a few data would be lost.
>> >>
>> >> If keypad wake up the system, first key pressed information would be lost.
>> >> If I2C, USB, SPI, UART wake up the system, first a few data would be lost.
>> >>
>> >> Did you also consider this issue?
>> >
>> > I think it would happen anyway with the old code, wouldn't it?
>>
>> That's not quite right.
>>
>> For example, let's assume a keypad device is alive in suspend/resume
>> state to wake up the system. Before arch_suspend_enable_irqs(), none
>> of keypad irqs is dropped. It is just pending.
>>
>> But in your code, a few irqs are discarded due to your resume_device_irqs().
>
> You can't say for sure they are discarded, but there's a small window in which
> they can be discarded.  The question is whether it does cause problems in
> practice.

I tested it on my S3C6410(NCP) Board with MAX7359 keypad which is in
the Dmitry's Input repo.

> Anyway, IMO the device that caused a wake-up event should be deactivated before
> arch_suspend_enable_irqs() and remain inactive until its driver is actually
> ready to handle interrupts generated by it.

Some devices such as Bluetooth chip, keypad(including gpio-key),
Modem(Telephony, Wlan) chip and etc, should be activated while the
system suspend/resume state. Because these devices may communicate
other systems and should receive external wake-up events.

Thanks
Kyuwon
