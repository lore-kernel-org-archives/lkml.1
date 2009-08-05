Return-Path: <linux-kernel-owner+w=401wt.eu-S934484AbZHEONr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484AbZHEONr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934373AbZHEONq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:13:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934333AbZHEONp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:13:45 -0400
Message-ID: <4A799392.3000108@suse.de>
Date: Wed, 05 Aug 2009 23:13:38 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de>	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>	<4A7951B0.10208@suse.de>	<20090805110031.51424dbe@lxorguk.ukuu.org.uk>	<4A796C94.5040301@suse.de> <20090805134823.4409e197@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805134823.4409e197@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Cox wrote:
>> The only problem here is the now obsolete hackish way OSS module
>> auto-loading is handled.  CUSE is being a regular chardev citizen.
> 
> "obsolete hackish". It's the same mechanism used by just about every
> other driver that multiplexes. Doesn't seem obsolete to me. You are
> expected to register subdrivers of most specialist interfaces through
> that interface. You use misc_register, video_register_device etc.

Subsystem registration isn't hackish or obsolete but claiming all
minor devices to use custom module alises is at best obsolete.  There
just is no reason to do that.

> Providing you do so it all works nicely.
> 
> The OSS device major is owned by OSS (soundcore). If you want to use it
> your driver should use the interfaces provided by soundcore. Ditto any
> other similar interface.

None of this would be a problem if OSS doesn't claim minors it doesn't
have actual device for and as I said multiple times there is no
benefit in doing that, not anymore and the only reason to keep that
around is to maintain backward compatibility for a mostly unused and
easy to work around feature.

>> Given the situation, I sure can add hacks to CUSE so that it doesn't
>> do regular chardev thing but does OSS specific stuff if OSS major is
>> detected.  To me, this would be much painful exercise in spreading the
>> hack.
> 
> And it can then be a good citizen and share the resource. CUSE needs to
> do the same for video/misc/framebuffer/tty/usb/etc so this is a general
> pattern it needs to handle. In short cuse needs to grow this ability
> anyway if it wants to be support these sorts of device.

The sharing and mixing and matching can happen very gracefully at
chrdev level.  Does it make sense to drag it down to each subsystem
level just to use custom module alises?  Not at all to me.  The same
goes for video or whatever.  There is no reason to claim unused device
numbers anymore and as long as that holds everyone is good citizen at
the chrdev region.  That's _much_ cleaner.

>> I don't see much reason to go through feature removal process for the
>> now obsolete OSS-specific module requesting feature.  Allowing distros
>> to make the switch as they see fit and letting the code wither away is
>> the least painful way.
> 
> You appear to be self contradictory here. Either
> 
> - OSS is irrelevant in which case we don't need the CUSE stuff either
> - OSS is relevant in which case we shouldn't break it

What's broken?  Module aliases?  The whole point of the patch is to
let people keep the module alises while allowing distros which wish to
try or switch to different mechanism to do so.

> A few old old games still use OSS, are proprietary apps and have never
> been re-released. Some of them also do irritiating to emulate things like
> use mmap. Flash at least appears to have finally gotten the message.

I like backward compatibility and think it's relevant but its
relevance is much lower than current stuff and ever diminishing.  Plus
the current in-kernel emulation has annoying limitations which can be
alleviated by userland implementation.  So,

 * OSS compatibility as seen from userland apps : relevant

 * doing everything right by sound_core.c which basically is only used
   by in-kernel emulation : not so much

Thanks.

-- 
tejun
