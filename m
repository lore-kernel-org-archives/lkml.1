Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbZAIVb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbZAIVb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZAIVbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:31:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:56117 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbZAIVbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:31:48 -0500
Date: Fri, 9 Jan 2009 13:30:30 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: post 2.6.28 regression: device_initialize() now sleeps, and
	may fail without recovery strategy
Message-ID: <20090109213030.GA20553@suse.de>
References: <496798FE.8030900@s5r6.in-berlin.de> <20090109205633.GB19904@suse.de> <4967BE13.6070003@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4967BE13.6070003@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 10:13:55PM +0100, Stefan Richter wrote:
> Greg KH wrote:
> > On Fri, Jan 09, 2009 at 07:35:42PM +0100, Stefan Richter wrote:
> >> We can fix the bug by changing firewire-core, but
> >>   a) it'd be more than a one-liner,
> >>   b) who knows which other subsystems are affected.
> > 
> > I agree.
> > 
> > I originally looked at changing this to be at device_add time, but I
> > think there are some code paths that do device_initialize and then do
> > some operations on the device before calling device_add.
> 
> get_device() and put_device() seem to be about the only things that are
> interesting before device_add().
> 
> Don't know if a final put_device() in this situation

Hm, that could be pretty simple to handle.  I'd really like to force the
kobject itself to be dynamic, and inside the private portion of the
device structure.  If I do that, then get_ and put_ would need to
allocate the object if it wasn't present.  But that would mean that
get_device could sleep, which isn't the case today (put_device() can
always sleep, that's not an issue.)

> > But I could be
> > wrong, let me do some testing first before forcing you to make that big
> > change to the firewire core.
> 
> It isn't actually that big.  And the added complication could hopefully
> be covered by comments about the caveats.
> 
> Actually, maybe it would be better for the firewire stack to move the
> concerned stuff into a non-atomic context.  There are other things we do
> in there and atomic context isn't very comfortable for all this.  But
> that would be a much bigger change.

Well, I'd always recommend doing things in non-atomic context wherever
possible, so I'll not object that hard to your patch either way :)

> >> Next, the above code is bogus.  In 2.6.28, device_initialize() could
> >> never fail and was thus safe to use as a void-valued function.
> >>
> >> How does driver core handle dev->p == NULL in subsequent usages of dev now?
> > 
> > It dies a flaming horrible death, pretty much like the whole rest of the
> > system if allocating such a small ammount of memory is causing failures
> > :)
> 
> Well, at least code which allocates struct device can check for failure
> and handle it, while the allocator of dev->p can't even check.  Unless
> you change device_initialize() to return error status and add error
> handling all over the place...

yeah, that would be a much bigger task than I'm really pondering,
although it probably is the correct thing to do...

thanks,

greg k-h
