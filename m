Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZEFAN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZEFAN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 20:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZEFANu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 20:13:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:58468 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZEFANu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 20:13:50 -0400
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
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 05 May 2009 17:13:48 -0700
In-Reply-To: <200905060127.24777.rjw@sisk.pl> (Rafael J. Wysocki's message of "Wed\, 6 May 2009 01\:27\:23 +0200")
Message-ID: <87y6tb3x6r.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday 06 May 2009, Kevin Hilman wrote:
>> Arve Hjønnevåg <arve@android.com> writes:
>> 
>> > On Tue, May 5, 2009 at 8:52 AM, Kevin Hilman
>> > <khilman@deeprootsystems.com> wrote:
>> >> Andrew Morton <akpm@linux-foundation.org> writes:
>> >>
>> >>> On Mon,  4 May 2009 17:27:04 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:
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
> and acknowledge it, but preventing the device driver for receiving it.  

Hmm, that's not normally what I think of as disabled.  ;)

> Does it work differently on the affected systems?

Yes.

__disable_irq() calls the irq_chip's disable method which is platform
specific.  On OMAP, this masks the IRQ at the hardware level
preventing the CPU from seeing the interrupt.

Kevin


