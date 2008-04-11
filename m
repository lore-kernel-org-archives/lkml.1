Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbYDKOHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbYDKOHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbYDKOHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:07:09 -0400
Received: from mail4.zarcrom.net ([209.236.236.162]:40993 "EHLO
	mail4.zarcrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbYDKOHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:07:08 -0400
Subject: Re: [RFC][PATCH] HPET: register additional counter-only char device
From: Dimitri Gorokhovik <dimitri.gorokhovik@leacom.fr>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: tglx@linutronix.de, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <47FF658E.2040808@ladisch.de>
References: <1207904307.13216.15.camel@laphroaig>
	 <47FF658E.2040808@ladisch.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Apr 2008 16:06:50 +0200
Message-Id: <1207922810.26014.33.camel@laphroaig>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
X-Originating-IP: 83.206.44.221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 15:20 +0200, Clemens Ladisch wrote:
> Dimitri Gorokhovik wrote:
> > I need to have many processes all reading from userspace the counter register
> > of the (same) HPET hardware. Just reading counter values, not handling timers,
> > enabling/disabling interrupts etc. `/dev/hpet' doesn't allow for this, as the
> > number of times it can be opened is limited by the number of timers available.
> 
> Indeed.  The driver assumes that userspace wants to program its own
> timer (like an RTC device).  Allowing mmap() on the hardware counter was
> more an afterthought.
> 
> > What would be the right way to implement such a support? For now, I simply
> > register a new misc device, '/dev/hpetctr', along with '/dev/hpet', for the same
> > ACPI device and on the same occasion.
> 
> Your patch circumvents CONFIG_HPET_MMAP.

Right. I hesitated to put it in, but multiple #ifdef/endif clutter too
much the resulting code. Something better should be devised in this
case, like separating the added code into another file, changing a
couple of symbols from static to extern etc.

However, why people wanted the original 'mmap' of /dev/hpet to be
disabled? Probably to prevent the HPET registers from poking with? Gain
in code size is too small, can't think it was the primary reason. If so,
isn't having a read-only mapping enough in itself?


> Another possibility would be to allow the device to be opened
> infinitely many times but not to allocate a hardware timer until one of
> the ioctls is called.  This means that opening /dev/hpet does not
> guarantee that a timer is available, but this has already been possible
> previously because request_irq() might fail.

Good point. The patch would be much more intrusive and voluminous (and
coming from a total newcomer). Would there be an interest for such a
patch? If yes, I might find some time to spend on it.

I did try to figure out the cleanest way by myself before posting, and I
couldn't mix and match several points about HPET:

-- /dev/hpet can only be opened with O_RDONLY, but for fiddling with
interrupts IMO write perms suit much better. One could imagine opening
lots of instances under O_RDONLY. Obviously, this way is doomed now
because of legacy apps.

-- to me, /dev/hpet is primarily a timer, not just a counter. It seems
wrong to me if it, once opened, would mostly fail to its primary
function (but this of course is all subjective matter).


Thanks for your comments!



 
> 
> 
> Regards,
> Clemens
