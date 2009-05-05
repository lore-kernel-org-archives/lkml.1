Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZEEPxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZEEPxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZEEPwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:52:55 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59268 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZEEPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:52:54 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	<20090504235405.647772ed.akpm@linux-foundation.org>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 05 May 2009 08:52:51 -0700
In-Reply-To: <20090504235405.647772ed.akpm@linux-foundation.org> (Andrew Morton's message of "Mon\, 4 May 2009 23\:54\:05 -0700")
Message-ID: <87ocu7a6ng.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon,  4 May 2009 17:27:04 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:
>
>> Interrupts that are flagged as wakeup sources via set_irq_wake()
>> should not be disabled for suspend.
>> 
>
> Why not?
>

If an interrupt is a wakeup source, and it is disabled at the chip
level, it will no longer generate interrupts, and thus no longer wake
up the system.

I'd be interested in hearing why wakeup interrupts should be disabled
during suspend.

>> 
>> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
>> index 638d8be..99113bd 100644
>> --- a/kernel/irq/pm.c
>> +++ b/kernel/irq/pm.c
>> @@ -28,6 +28,9 @@ void suspend_device_irqs(void)
>>  	for_each_irq_desc(irq, desc) {
>>  		unsigned long flags;
>>  
>> +		if (desc->status & IRQ_WAKEUP)
>> +			continue;
>> +
>>  		spin_lock_irqsave(&desc->lock, flags);
>>  		__disable_irq(desc, irq, true);
>>  		spin_unlock_irqrestore(&desc->lock, flags);
>
> If this fixes some bug then please provide a description of that bug?

The bug is that on TI OMAP, interrupts that are used for wakeup events
are disabled by this code causing the system to no longer wake up.

I'll update the patch description.

Kevin
