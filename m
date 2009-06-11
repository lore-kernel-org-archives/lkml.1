Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbZFKItM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbZFKItM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZFKIs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:48:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2585 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZFKIs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:48:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ZqcMqT04FIsaamosHnhlDrOAOYVSmWAuyi0tTVeoz2lyiT08E//HqEwvJuOdOmT4O
	37lMYIM/IbAqHmHpDm3GA==
MIME-Version: 1.0
In-Reply-To: <20090611082532.GE8592@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
	 <20090610213710.GA8472@elf.ucw.cz>
	 <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com>
	 <20090611082532.GE8592@elf.ucw.cz>
Date: Thu, 11 Jun 2009 01:48:57 -0700
Message-ID: <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 1:25 AM, Pavel Machek<pavel@ucw.cz> wrote:
> On Wed 2009-06-10 14:55:52, Brian Swetland wrote:
>> I'm not sure the smd (shared memory driver / virtual serial channels)
>> that everything else depends on makes sense outside of mach-msm, given
>> it's all very specific to the baseband and firmware that runs on it.
>
> Well, it is still a driver for your baseband chip, right?

Yes -- what I meant is more "does it belong under arch/arm/mach-msm/"
(given that it's very specific to that architecture and unlikely to
ever be useful elsewhere) or "does it belong somewhere else" (because
it's a pretty big pile of code compared to other stuff like
gpio/interrupt/etc stuff that tends to live under arch/arm/mach-*/).

> ...drivers/staging is _not_ final place for your code. When the code
> is good enough, it should move. But it is place where stuff like TI
> wifi driver would be acceptable.

Interesting -- reading up more on staging now.  I know that Greg KH
has been pulling some of the "generic" android drivers into staging
(Thanks, Greg!), but hadn't really looked at the rationale behind
staging in general.

Sounds like packing up the serial, sdio, nand, framebuffer, etc
drivers for submission into staging might make sense.  We can do the
obvious stuff like make sure they're checkpatch clean and reasonably
tidy first.

In order to actually have the peripherals work, though, we'd need to
add to board-*.c, devices.c, etc so that the platform devices are
defined so the platform drivers (which almost all of these are) are
actually probed.

>> Basically there's a stack:
>>
>> smsm  -- "shared memory state machine" (used for power collapse coordination)
>> smd -- "shared memory driver" (virtual serial channels, 8k bidirectional fifos)
>> rpcrouter/oncrpc -- rpc transport layer used for audio, audio routing, etc
>>
>> These are linux implementations of protocols the baseband speaks.
>>
>> Other stuff then stacks on smd (rmnet -- virtual ethernet, at control
>> channels, etc) and oncrpc (dsp control, rtc, gps, some media control).
>
> Is it all neccessary for boot? Getting it booting with display should
> be the first goal... GPS/RTC/... can come later.

The lowest layer IPC (proc_comm) is used for clock/power control and
is already in mainline, and that gets the clk_* framework functional
and allows most of the peripheral drivers to work, thankfully.  Things
like the serial driver, framebuffer, sdio, nand controller, etc all
should be happy without additional core architecture support.

Thanks,

Brian
