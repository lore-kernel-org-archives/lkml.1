Return-Path: <linux-kernel-owner+w=401wt.eu-S934520AbZHEO3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520AbZHEO3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934404AbZHEO3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:29:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45950 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934290AbZHEO3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:29:05 -0400
Date: Wed, 5 Aug 2009 15:29:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <teheo@suse.de>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805152942.42e785f3@lxorguk.ukuu.org.uk>
In-Reply-To: <4A799392.3000108@suse.de>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A7951B0.10208@suse.de>
	<20090805110031.51424dbe@lxorguk.ukuu.org.uk>
	<4A796C94.5040301@suse.de>
	<20090805134823.4409e197@lxorguk.ukuu.org.uk>
	<4A799392.3000108@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And it can then be a good citizen and share the resource. CUSE needs to
> > do the same for video/misc/framebuffer/tty/usb/etc so this is a general
> > pattern it needs to handle. In short cuse needs to grow this ability
> > anyway if it wants to be support these sorts of device.
> 
> The sharing and mixing and matching can happen very gracefully at
> chrdev level.  Does it make sense to drag it down to each subsystem
> level just to use custom module alises?  Not at all to me.  The same
> goes for video or whatever.  There is no reason to claim unused device
> numbers anymore and as long as that holds everyone is good citizen at
> the chrdev region.  That's _much_ cleaner.

I would suggest you read the code for the others. OSS is probably the
easy one to kill but the others create objects for platform wide sysfs
files and the like (as indeed OSS once did for a proc file) so in the
general case CUSE needs to work through them.

>  * OSS compatibility as seen from userland apps : relevant
> 
>  * doing everything right by sound_core.c which basically is only used
>    by in-kernel emulation : not so much

So instead of weird config magic why not send both messages. Initially
soundcore can generate both requests for sound-slot-foo and also fake up
its own char requests. It's easy to do, it doesn't put any code into the
kernel we'll be stuck with for years with weird config options. It
doesn't require the user choose a magic kernel option - it just works.

It's not much code either - just another request call in soundcore_open -
one line extra to write, a year to wait (4 releases ?) and then the old
stuff can go away, ALSA can then avoid soundcore and soundcore can vanish.

Much cleaner, and I believe one line of code ?
