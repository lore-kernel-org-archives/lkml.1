Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbZEEXv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbZEEXv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZEEXvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:51:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:50908 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbZEEXvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:51:19 -0400
MIME-Version: 1.0
In-Reply-To: <200905060127.24777.rjw@sisk.pl>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	 <d6200be20905051358m34c2be02ped84ad4158cd9865@mail.gmail.com>
	 <87eiv35eg6.fsf@deeprootsystems.com> <200905060127.24777.rjw@sisk.pl>
Date: Tue, 5 May 2009 16:51:19 -0700
Message-ID: <d6200be20905051651i7164a873i5f194bc7ec293a60@mail.gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 4:27 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
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

If the irq_chip implements mask and unmask, then this is how it works,
but it can override this by also implementing disable. If the irq_chip
disable hook turns off the edge detection for an edge triggered wakeup
interrupt, it will not allow drivers or the framework to use
disable_irq to mask an interrupt.

-- 
Arve Hjønnevåg
