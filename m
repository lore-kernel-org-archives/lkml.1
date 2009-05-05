Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbZEEXPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbZEEXPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZEEXPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:15:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:59211 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZEEXPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:15:42 -0400
To: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	<20090504235405.647772ed.akpm@linux-foundation.org>
	<87ocu7a6ng.fsf@deeprootsystems.com>
	<d6200be20905051358m34c2be02ped84ad4158cd9865@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 05 May 2009 16:15:37 -0700
In-Reply-To: <d6200be20905051358m34c2be02ped84ad4158cd9865@mail.gmail.com>
 ("Arve =?iso-8859-1?Q?Hj=F8nnev=E5g=22's?= message of "Tue\, 5 May 2009
 13\:58\:36 -0700")
Message-ID: <87eiv35eg6.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> writes:

> On Tue, May 5, 2009 at 8:52 AM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>> Andrew Morton <akpm@linux-foundation.org> writes:
>>
>>> On Mon,  4 May 2009 17:27:04 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:
>>>
>>>> Interrupts that are flagged as wakeup sources via set_irq_wake()
>>>> should not be disabled for suspend.
>>>>
>>>
>>> Why not?
>>>
>>
>> If an interrupt is a wakeup source, and it is disabled at the chip
>> level, it will no longer generate interrupts, and thus no longer wake
>> up the system.
>>
>> I'd be interested in hearing why wakeup interrupts should be disabled
>> during suspend.
>>

[...]

>>>
>>> If this fixes some bug then please provide a description of that bug?
>>
>> The bug is that on TI OMAP, interrupts that are used for wakeup events
>> are disabled by this code causing the system to no longer wake up.
>
> What do you do if the interrupt triggers right after your driver has
> returned from its late suspend hook?  

If it's a wakeup IRQ, I assume you want it to prevent suspend.

But I don't see how that can happen in the current code. IIUC, by the
time your late suspend hook is run, your device IRQ is already
disabled, so it won't trigger an interrupt that will be caught by
check_wakeup_irqs() anyways.

> By leaving the interrupt enabled you prevent check_wakeup_irqs from
> aborting suspend.

Yes, but it doesn't prevent platform-specific code from aborting
suspend.  On OMAP, the platform-specific suspend enter hook does a
last check for pending enabled interrupts very late in the sequence.
It seems to me that the platform specific code is the best place to do
this.

On a related note, what happens if your device triggers an interrupt
between check_wakeup_irqs() and the actual suspend?  Since it is a
wakeup IRQ, wouldn't you want it to abort the suspend too?

But all this discussion still leaves the bigger question unanswered:

Without my patch, how do we expect wakeup-enabled device IRQs to:

1) abort a suspend between suspend_device_irqs() and actual HW suspend, and
2) wake up the system *after it is suspended*

Kevin
