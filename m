Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZEFOFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZEFOFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZEFOEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:04:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:39940 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbZEFOEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:04:51 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	<d6200be20905051358m34c2be02ped84ad4158cd9865@mail.gmail.com>
	<87eiv35eg6.fsf@deeprootsystems.com> <200905060127.24777.rjw@sisk.pl>
	<87y6tb3x6r.fsf@deeprootsystems.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 06 May 2009 07:04:48 -0700
In-Reply-To: <87y6tb3x6r.fsf@deeprootsystems.com> (Kevin Hilman's message of "Tue\, 05 May 2009 17\:13\:48 -0700")
Message-ID: <871vr22upr.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman <khilman@deeprootsystems.com> writes:

> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>
>> On Wednesday 06 May 2009, Kevin Hilman wrote:

[...]

>>> 
>>> [...]
>>> 
>>> >>>
>>> >>> If this fixes some bug then please provide a description of that bug?
>>> >>
>>> >> The bug is that on TI OMAP, interrupts that are used for wakeup events
>>> >> are disabled by this code causing the system to no longer wake up.
>>> >
>>> > What do you do if the interrupt triggers right after your driver has
>>> > returned from its late suspend hook?  
>>> 
>>> If it's a wakeup IRQ, I assume you want it to prevent suspend.
>>> 
>>> But I don't see how that can happen in the current code. IIUC, by the
>>> time your late suspend hook is run, your device IRQ is already
>>> disabled, so it won't trigger an interrupt that will be caught by
>>> check_wakeup_irqs() anyways.
>>
>> My understanding of __disable_irq() was that it didn't actually disable the
>> IRQ at the hardware level, allowing the CPU to actually receive the interrupt
>> and acknowledge it, but preventing the device driver for receiving it.  
>
>> Does it work differently on the affected systems?
>
> Yes.
>
> __disable_irq() calls the irq_chip's disable method which is platform
> specific.  On OMAP, this masks the IRQ at the hardware level
> preventing the CPU from seeing the interrupt.

Looking at x86, the i8259 disable hook also seems to mask the IRQ at
the PIC level.

The various IO-APIC irq_chips do not have a disable hook so the
__disable_irq() here is a NOP.

Kevin
