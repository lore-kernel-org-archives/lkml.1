Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZB1WP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZB1WP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZB1WPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:15:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:54350 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbZB1WPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:15:14 -0500
MIME-Version: 1.0
In-Reply-To: <200902281106.41793.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0902270948540.2926-100000@iolanthe.rowland.org>
	 <alpine.LFD.2.00.0902271221360.3111@localhost.localdomain>
	 <d6200be20902271954q16697282ia056d4f40ab49184@mail.gmail.com>
	 <200902281106.41793.rjw@sisk.pl>
Date: Sat, 28 Feb 2009 14:15:10 -0800
Message-ID: <d6200be20902281415k656e0dfei9d540ddf04d9929f@mail.gmail.com>
Subject: Re: [linux-pm] [RFC][PATCH 2/2] PM: Rework handling of interrupts 
	during suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 2:06 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday 28 February 2009, Arve Hjønnevåg wrote:
>> On Fri, Feb 27, 2009 at 12:30 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> >
>> >
>> > On Fri, 27 Feb 2009, Alan Stern wrote:
>> >>
>> >> Perhaps these aren't all the sort of usage you're talking about, but I
>> >> bet most of them are.  It certainly looks like more than just ARM.
>> >> Maybe not all that much more, but definitely more.  And the number will
>> >> only grow in the future.
>> >
>> > Are you really sure? Because it can't be x86. I'm pretty sure that that is
>> > simply not how x86 wake events _work_ - they're not interrupts.
>>
>> They are not interrupts on every arm platform that implements set_wake
>> either, but it is useful to pretend that they are. If the platform
>> code reads the wakeup status and marks the corresponding interrupt
>> pending, the driver does not need to know if the event occurred before
>> or after the system entered the low power state. I don't know if this
>> can be implemented on x86, but it might be worth looking into.
>
> That would have been a new feature, no?  And I don't think anyone except for
> you does it.  So, what you're saying boils down to "please don't break my new
> feature that hasn't been merged yet".

I was not referring to our platform, so not this is not a new feature.

>> > And that's the big point that people seem to be missing here: the whole
>> > "wake up interrupt" thing is not some generic model in the first place. I
>> > strongly suspect that it literally only works on certain architectures.
>>
>> My point was that it was not specific to our platform. I don't have a
>> problem fixing our platform if this patch is merged, but this is case
>> where a change to the generic code breaks some platforms.
>
> Quite frankly, I don't really think it will break anything else than your
> platform.

That is quite possible, but do other platforms not break because they
are already broken? I saw no attempt to avoid race conditions on
suspend in the drivers I looked at.

> Still, if Linus agrees, I can put the loop suggested by him directly into
> sysdev_suspend().  Linus?

I vote for this.

>
>> I don't think there is a good reason to make the fix arm specific, trivial or
>> not, since any platform implementing set_wake may run into the race
>> condition that this patch introduced. If the platform does not
>> implement set_wake, IRQ_WAKEUP never gets set, and the fix should not
>> have any effect.
>
> The point is, if we put anything like this into the generic code, platforms
> start to rely on this and it will become more and more difficult to change at
> the generic level if need be.
>
> The fact that your platform relies on the generic code to disable IRQs on
> the CPU at a particular point shows the mechanism very well. :-)

If the generic code did not clear the interrupt I think this would be
a stronger point. Since our hardware does not have a mask register,
only enable, I find this feature (leave the interrupt enabled, and
mask it only if it triggers) of the generic interrupt code quite
useful. If the generic code did not do this, the platform code would
have to.

-- 
Arve Hjønnevåg
