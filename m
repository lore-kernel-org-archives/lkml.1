Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbZHEMrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbZHEMrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933520AbZHEMrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:47:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51108 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933395AbZHEMrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:47:46 -0400
Date: Wed, 5 Aug 2009 13:48:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <teheo@suse.de>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805134823.4409e197@lxorguk.ukuu.org.uk>
In-Reply-To: <4A796C94.5040301@suse.de>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A7951B0.10208@suse.de>
	<20090805110031.51424dbe@lxorguk.ukuu.org.uk>
	<4A796C94.5040301@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only problem here is the now obsolete hackish way OSS module
> auto-loading is handled.  CUSE is being a regular chardev citizen.

"obsolete hackish". It's the same mechanism used by just about every
other driver that multiplexes. Doesn't seem obsolete to me. You are
expected to register subdrivers of most specialist interfaces through
that interface. You use misc_register, video_register_device etc.

Providing you do so it all works nicely.

The OSS device major is owned by OSS (soundcore). If you want to use it
your driver should use the interfaces provided by soundcore. Ditto any
other similar interface.

If you want to completely pre-empt soundcore then use a different
(probably dynamic) major number and tweak your udev rules to create
different /dev files.

None of this requires ugly kernel hacks and weird user config options and
module params.

> Given the situation, I sure can add hacks to CUSE so that it doesn't
> do regular chardev thing but does OSS specific stuff if OSS major is
> detected.  To me, this would be much painful exercise in spreading the
> hack.

And it can then be a good citizen and share the resource. CUSE needs to
do the same for video/misc/framebuffer/tty/usb/etc so this is a general
pattern it needs to handle. In short cuse needs to grow this ability
anyway if it wants to be support these sorts of device.

> However, in-kernel OSS is largely dead or at least is dying a slow
> death.  Native OSS drivers are no longer in development and the only
> left user is in-kernel emulation from ALSA, which I'm sure have its
> places but is getting more and more inadequate for general desktop
> usage due to lack of software multiplexing.

The desktop uses pulseaudio for the most part (or jack in some setups).
OSS uses are pretty rare now that flash has gone away. Unfortunately
many of those existing users aren't terribly fixable
 
> I don't see much reason to go through feature removal process for the
> now obsolete OSS-specific module requesting feature.  Allowing distros
> to make the switch as they see fit and letting the code wither away is
> the least painful way.

You appear to be self contradictory here. Either

- OSS is irrelevant in which case we don't need the CUSE stuff either
- OSS is relevant in which case we shouldn't break it

A few old old games still use OSS, are proprietary apps and have never
been re-released. Some of them also do irritiating to emulate things like
use mmap. Flash at least appears to have finally gotten the message.

Alan

