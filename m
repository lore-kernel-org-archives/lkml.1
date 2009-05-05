Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZEEU6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZEEU6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZEEU6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:58:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:13676 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbZEEU6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:58:37 -0400
MIME-Version: 1.0
In-Reply-To: <87ocu7a6ng.fsf@deeprootsystems.com>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	 <20090504235405.647772ed.akpm@linux-foundation.org>
	 <87ocu7a6ng.fsf@deeprootsystems.com>
Date: Tue, 5 May 2009 13:58:36 -0700
Message-ID: <d6200be20905051358m34c2be02ped84ad4158cd9865@mail.gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 8:52 AM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
>
>> On Mon,  4 May 2009 17:27:04 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:
>>
>>> Interrupts that are flagged as wakeup sources via set_irq_wake()
>>> should not be disabled for suspend.
>>>
>>
>> Why not?
>>
>
> If an interrupt is a wakeup source, and it is disabled at the chip
> level, it will no longer generate interrupts, and thus no longer wake
> up the system.
>
> I'd be interested in hearing why wakeup interrupts should be disabled
> during suspend.
>
>>>
>>> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
>>> index 638d8be..99113bd 100644
>>> --- a/kernel/irq/pm.c
>>> +++ b/kernel/irq/pm.c
>>> @@ -28,6 +28,9 @@ void suspend_device_irqs(void)
>>>      for_each_irq_desc(irq, desc) {
>>>              unsigned long flags;
>>>
>>> +            if (desc->status & IRQ_WAKEUP)
>>> +                    continue;
>>> +
>>>              spin_lock_irqsave(&desc->lock, flags);
>>>              __disable_irq(desc, irq, true);
>>>              spin_unlock_irqrestore(&desc->lock, flags);
>>
>> If this fixes some bug then please provide a description of that bug?
>
> The bug is that on TI OMAP, interrupts that are used for wakeup events
> are disabled by this code causing the system to no longer wake up.

What do you do if the interrupt triggers right after your driver has
returned from its late suspend hook? By leaving the interrupt enabled
you prevent check_wakeup_irqs from aborting suspend.

-- 
Arve Hjønnevåg
