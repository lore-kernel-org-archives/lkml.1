Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbYDKP5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbYDKP5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759907AbYDKP5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:57:47 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38508 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759537AbYDKP5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:57:47 -0400
X-Sasl-enc: 6WdE5oA75BXAxWmQSlhCoOqRn/KJHYGkGj+5rEkxjRqM 1207929465
Message-ID: <47FF8A74.4000002@ladisch.de>
Date: Fri, 11 Apr 2008 17:57:40 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Dimitri Gorokhovik <dimitri.gorokhovik@leacom.fr>
CC: tglx@linutronix.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HPET: register additional counter-only char device
References: <1207904307.13216.15.camel@laphroaig>	 <47FF658E.2040808@ladisch.de> <1207922810.26014.33.camel@laphroaig>
In-Reply-To: <1207922810.26014.33.camel@laphroaig>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Gorokhovik wrote:
> On Fri, 2008-04-11 at 15:20 +0200, Clemens Ladisch wrote:
> > Dimitri Gorokhovik wrote:
> > > I need to have many processes all reading from userspace the counter register
> > > of the (same) HPET hardware.  [...]
> > > What would be the right way to implement such a support? For now, I simply
> > > register a new misc device, '/dev/hpetctr', along with '/dev/hpet', for the same
> > > ACPI device and on the same occasion.
> >
> > Your patch circumvents CONFIG_HPET_MMAP.
>
> Right. I hesitated to put it in, but multiple #ifdef/endif clutter too
> much the resulting code. Something better should be devised in this
> case, like separating the added code into another file, changing a
> couple of symbols from static to extern etc.
>
> However, why people wanted the original 'mmap' of /dev/hpet to be
> disabled? Probably to prevent the HPET registers from poking with?

Reading HPET registers should not be dangerous in any way, but it might
be possible to read other devices' registers that happen to lie inside
the same memory page (HPET registers are only 1024 bytes).

> > Another possibility would be to allow the device to be opened
> > infinitely many times but not to allocate a hardware timer until one of
> > the ioctls is called.  This means that opening /dev/hpet does not
> > guarantee that a timer is available, but this has already been possible
> > previously because request_irq() might fail.
>
> Good point. The patch would be much more intrusive and voluminous (and
> coming from a total newcomer). Would there be an interest for such a
> patch?

Yes, definitely.  I've wanted to do this patch for some time but haven't
found the time.

> -- to me, /dev/hpet is primarily a timer, not just a counter. It seems
> wrong to me if it, once opened, would mostly fail to its primary
> function (but this of course is all subjective matter).

There are at least as many available timers as before the change -- a
program that tries to use a timer will still get a timer, and now this
will succeed even if there are other programs that use only the counter.

Even now, for most programs using /dev/hpet, it actually is just a
counter.


Regards,
Clemens
