Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbXIMQnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbXIMQnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXIMQnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:43:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37297 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbXIMQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:43:46 -0400
Date: Thu, 13 Sep 2007 09:43:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Adrian Bunk <bunk@stusta.de>, Adrian Bunk <bunk@kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.0.999.0709130912060.16478@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org
 >
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Sep 2007, Alan Stern wrote:
> 
> But mainly it's a question of maintenance and modification.  Kernel
> developers don't really enjoy maintaining black- or whitelists of
> devices, together with all the work involved in sorting through the
> issues when somebody posts an email saying "My device doesn't work!".

Yeah.

In general, I think the USB blacklist/whitelists are generally a sign of 
some deeper bug.

We used to have a lot of those things due to simply incorrect SCSI 
probing, causing devices to lock up because Linux probed them with bad or 
unexpected modepages etc. I suspect we still have old blacklist entries 
from those days that just never got cleaned up, because nobody ever dared 
remove the blacklist entry.

We should strive to make the default behaviour be so safe that we never 
need a black-list (or a whitelist), and basically consider blacklists to 
be not a way to "fix up a device", but a way to avoid some really serious 
AND *RARE* error.

The moment you have lots of devices having the same blacklist entry, 
that's a sign that the blacklist is wrong, and the subsystem itself is 
likely doing something bad!

So, I would seriously suggest:
 - look at USB quirks that have more than ten entries (and the entries 
   aren't just the exact same device in various guises)
 - start considering that feature to be something that is known broken, 
   and shouldn't be done AT ALL by default.
 - have some way to enable some extension on a device-by-device basis from 
   the /sysfs interface, and then users can enable those things on their 
   own with a graphical interface or something (or using whitelists in 
   user space saying "ok, this device can actually do this")
 - REMOVE THE DAMN QUIRK

It looks like the current situation now is that the latest autosuspend 
patches did basically everything but the last point.

Btw, this is in no way just an AUTOSUSPEND issue. The USB layer has a 
*lot* of these quirks. They are often called "UNUSUAL_DEV()", but the 
thing is, some of those things seem to be so usual that the naming is 
dubious, and thus calling it a "quirk" or "unusual" is pretty dubious too. 

For example, why do we have that US_FL_MAX_SECTORS_64 at all? The fact 
that some USB device is broken with more than 64 sectors would seem to 
indicate that Windows *never* does more than 64 sectors, and that in turn 
means that pretty much *no* devices have ever been tested with anything 
bigger.

So why not make the 64 sector limit be the default? Get rid of the quirk: 
we already allow people to override it in /sys if they really want to, but 
realistically, it's probably not going to make any difference what-so-ever 
for *any* normal load. So we seem to have a quirk that really doesn't buy 
us anything but headache.

Other quirks worth looking at (but likely unfixable) are:
 - US_FL_IGNORE_RESIDUE:
	Does this really matter? Can we not just always do the 
	US_FL_IGNORE_RESIDUE thing? Windows must not be doing what we're 
	doing.
 - US_FL_FIX_CAPACITY: 
	This is a generic SCSI issue, not a USB one, and maybe there are 
	better solutions to it. Are we perhaps doing something wrong? Is 
	there some patterns we haven't seen? Why do we need this, when 
	presumably Windows does not?
 - US_FL_SINGLE_LUN:
	At least a few of these seem to indicate that the real problem 
	could be detected dynamically ("device reports Sub=ff") rather 
	than with a quirk. Quirks are unmaintainable (and change), but 
	noticing when devices return impossible values and going into a 
	"safe mode" is just defensive programming.

> Maybe you're concerned about propagating updates as painlessly as 
> possible -- if the whitelist is in the kernel then every kernel release 
> would include an update.  But in userspace it's possible to do updates 
> even more quickly and painlessly.  For example, there could be a 
> network server available for both interactive lookups and automatic 
> queries from HAL.

For a lot of these things, you probably do not need a whitelist *at*all*!

IOW, just default to something safe (the 64 sector example), and then 
perhaps allow people to explicitly play with their settings in a hardware 
manager. People actually tend to *like* being able to tweak meaningless 
things, and it makes them feel in control. So you'd have the Gentoo people 
who want to optimize their iPod access times by 0.2% by raising the 
maximum sector number - good for them! They'll feel empowered, and if it 
stops working, they know it was because of something *they* did.

So at least in some cases, I think we should "default to stupid, but give 
users rope".

		Linus
