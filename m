Return-Path: <linux-kernel-owner+w=401wt.eu-S1765612AbXIMTN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765612AbXIMTN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762090AbXIMTNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:13:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56632 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762122AbXIMTNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:13:48 -0400
Date: Thu, 13 Sep 2007 15:13:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Adrian Bunk <bunk@stusta.de>, Adrian Bunk <bunk@kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oneukum@suse.de>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <alpine.LFD.0.999.0709130912060.16478@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0709131421130.7406-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Linus Torvalds wrote:

> In general, I think the USB blacklist/whitelists are generally a sign of 
> some deeper bug.
> 
> We used to have a lot of those things due to simply incorrect SCSI 
> probing, causing devices to lock up because Linux probed them with bad or 
> unexpected modepages etc. I suspect we still have old blacklist entries 
> from those days that just never got cleaned up, because nobody ever dared 
> remove the blacklist entry.

I don't just suspect -- I know for a fact that we do.  Partly because
of laziness and partly because of not being able to verify that an
entry is no longer needed.

> We should strive to make the default behaviour be so safe that we never 
> need a black-list (or a whitelist), and basically consider blacklists to 
> be not a way to "fix up a device", but a way to avoid some really serious 
> AND *RARE* error.

In general I agree.  However there are some problems for which nobody 
has been able to come up with another solution.  See below.

> The moment you have lots of devices having the same blacklist entry, 
> that's a sign that the blacklist is wrong, and the subsystem itself is 
> likely doing something bad!
> 
> So, I would seriously suggest:
>  - look at USB quirks that have more than ten entries (and the entries 
>    aren't just the exact same device in various guises)
>  - start considering that feature to be something that is known broken, 
>    and shouldn't be done AT ALL by default.
>  - have some way to enable some extension on a device-by-device basis from 
>    the /sysfs interface, and then users can enable those things on their 
>    own with a graphical interface or something (or using whitelists in 
>    user space saying "ok, this device can actually do this")
>  - REMOVE THE DAMN QUIRK
> 
> It looks like the current situation now is that the latest autosuspend 
> patches did basically everything but the last point.

Yes, none of those USB_QUIRK_NO_AUTOSUSPEND entries are needed any 
more.  They can all be removed and handed over to the HAL people as a 
starting point.

> Btw, this is in no way just an AUTOSUSPEND issue. The USB layer has a 
> *lot* of these quirks. They are often called "UNUSUAL_DEV()", but the 
> thing is, some of those things seem to be so usual that the naming is 
> dubious, and thus calling it a "quirk" or "unusual" is pretty dubious too. 

You have concentrated your attention on the list for usb-storage,
but the usbhid driver also has an impressively long quirks list.

> For example, why do we have that US_FL_MAX_SECTORS_64 at all? The fact 
> that some USB device is broken with more than 64 sectors would seem to 
> indicate that Windows *never* does more than 64 sectors, and that in turn 
> means that pretty much *no* devices have ever been tested with anything 
> bigger.
> 
> So why not make the 64 sector limit be the default? Get rid of the quirk: 
> we already allow people to override it in /sys if they really want to, but 
> realistically, it's probably not going to make any difference what-so-ever 
> for *any* normal load. So we seem to have a quirk that really doesn't buy 
> us anything but headache.

That's true now, but it wasn't always.  Until the last year or so, 
cdrecord wouldn't work properly with USB CD drives having a 64-sector 
limit unless the user added a particular command-line argument.

In fact, setting max_sectors down to 64 is probably overkill -- 120
ought to be enough.  But there may have been one or two oddball devices
that really did have a 32-KB limit, and better safe than sorry.  At one
point an engineer from Genesys said their devices did, although they do
seem to work perfectly well with 64-KB transfers (and that's what 
Windows gives them).

> Other quirks worth looking at (but likely unfixable) are:
>  - US_FL_IGNORE_RESIDUE:
> 	Does this really matter? Can we not just always do the 
> 	US_FL_IGNORE_RESIDUE thing? Windows must not be doing what we're 
> 	doing.

Windows does indeed ignore the residue field, as far as I can tell.

But this is a rather tricky thing.  The USB mass-storage spec
specifically says that one way a device can signal a short transfer is
to pad the data with 0s to the requested length and then set the
residue to indicate how much of the data is valid.  If we ignore the
residue then we run a risk of misinterpreting the 0s as valid data.

Now in practice this doesn't matter much because short transfers of
block data (READ_10) generally involve other errors that would show up
anyway, and for non-block data (MODE SENSE) the padding probably
wouldn't matter.  Still it seems like a dangerous sort of thing to do,
which is why I have resisted it.

(And by the way, there _definitely_ are devices which use this
signalling method.  In fact, Linux contains a driver that does it.)

>  - US_FL_FIX_CAPACITY: 
> 	This is a generic SCSI issue, not a USB one, and maybe there are 
> 	better solutions to it. Are we perhaps doing something wrong? Is 
> 	there some patterns we haven't seen? Why do we need this, when 
> 	presumably Windows does not?

This is another hard case.  No, we aren't doing anything wrong.  If
there are any patterns we haven't seen, we aren't aware of them.  :-)  
You might think that if a device claims to have an odd number of
sectors then it must be wrong, but this turns out not to be true.

Why doesn't Windows need this?  For all we know, it does.  Has anybody
ever tried forcing Windows to read the sector beyond the end of one of
these buggy devices?

For one reason or another, Linux supports filesystems/partitioning
schemes which do need to access the last sector (EFI GUID, md, maybe
others).  Some devices are so buggy that trying to read the nonexistent
"last" sector causes them to lock up, requiring a power cycle.  
Obviously we can't probe for this sort of behavior.  (There was one
report of a device which _could_ read its last sector correctly, but
only if the transfer was exactly 1 sector long!  Attempts to read two
sectors starting from the second-to-last sector would cause it to
crash.)

There's a straightforward solution: Never try to use the last sector --
in effect, assume every device has the FIX_CAPACITY flag set.  Doing 
this universally could cause data loss, however, so again I have been 
opposed to it.

>  - US_FL_SINGLE_LUN:
> 	At least a few of these seem to indicate that the real problem 
> 	could be detected dynamically ("device reports Sub=ff") rather 
> 	than with a quirk. Quirks are unmaintainable (and change), but 
> 	noticing when devices return impossible values and going into a 
> 	"safe mode" is just defensive programming.

This is almost certainly a case where lots of the entries are no longer 
needed.  But it isn't easy to tell which ones can safely be removed.

The problem here isn't that the device reports impossible values -- 
what happens is that it responds to commands for any LUN, causing the 
kernel to think it is really multiple devices.

> For a lot of these things, you probably do not need a whitelist *at*all*!
> 
> IOW, just default to something safe (the 64 sector example), and then 
> perhaps allow people to explicitly play with their settings in a hardware 
> manager. People actually tend to *like* being able to tweak meaningless 
> things, and it makes them feel in control. So you'd have the Gentoo people 
> who want to optimize their iPod access times by 0.2% by raising the 
> maximum sector number - good for them! They'll feel empowered, and if it 
> stops working, they know it was because of something *they* did.
> 
> So at least in some cases, I think we should "default to stupid, but give 
> users rope".

This will work in some cases, but not in others.  In particular, it 
won't work when the values have to known at device-detection time.  
Once the sysfs files have been set up and the user can put in the 
correct values, it's already too late.

Still, I agree that we can get rid of MAX_SECTORS_64.  Similarly,
FIX_INQUIRY shouldn't be needed, since any device which does need it
would fail to work under Windows.  However the really popular flags are 
the ones which would be hardest to remove.

Alan Stern

