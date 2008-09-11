Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYIKQJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYIKQJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYIKQIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:08:46 -0400
Received: from senator.holtmann.net ([87.106.208.187]:53087 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbYIKQIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:08:43 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <48C8D33F.2050804@suse.com>
References: <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <1221088512.13621.58.camel@macbook.infradead.org>
	 <20080910.162423.40167601.davem@davemloft.net>
	 <1221119068.6309.8.camel@californication>  <48C8D33F.2050804@suse.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 18:09:10 +0200
Message-Id: <1221149350.6309.29.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

> >>> It's definitely not something we should be doing upstream though.
> >> So you think it's ok that every Debian user has to learn this
> >> magic incantation just to use current kernels?
> >>
> >> I don't think it's nice to break things like this on people,
> >> especially such a large group.  Getting this stuff to work is hard
> >> enough, and we're just putting yet another barrier into the situation
> >> and that can only mean less testers and contributors.
> >>
> >> I do know several people who aren't testing and contributing because
> >> the whole firmware shakeup is so bolixed and they really are exasperated
> >> after spending hours trying to get it to work.
> > 
> > it is that the Debian maintainer screwed this up. Upstream never
> > promoted kernel versioned directories for the firmware. I had a long
> > discussion with Dave about it at OLS and using the kernel version is
> > just plain wrong. The driver maintainers should version the firmware if
> > they break it in an API incompatible way.
> 
> They "should," but is that happening now? Out of all the firmware blobs
> installed with 2.6.27-rcX, only the edgeport drier actually versions
> them - and they're versioned because the driver requires different
> versions for different hardware.

let me repeat this, if a driver depends on newer firmware version, then
it should make sure that the firmware itself is versioned. Everything
else will break eventually.

The Intel wireless drivers started to version their firmware a long time
ago. That is the way to go. How will a user tell different firmwares
apart otherwise.

> > To shed some light into the problem with Debian/Ubuntu. They install the
> > firmware in /lib/firmware/`uname -r`/ and everytime they bump their ABI
> > number, they have to install all the firmware again. This is just
> > braindead. Their udev script actually checks /lib/firmware first and
> > then the kernel versioned directory. So that is just fine.
> 
> Well, what we're doing is including the firmware blobs inside the kernel
> packages. So, yeah, we install all the firmware blobs again, but they're
> installed with the modules that we're installing all over again anyway.
> All the firmware blobs currently included in 2.6.27-rcs total about
> 540k, so the wasted disk space is largely negligible when compared to
> the size of installing an additional kernel and module set.
> 
> We check /lib/firmware/$(uname -r) /lib/firmware
> /usr/local/lib/firmware, in that order.

Checking /lib/firmware/$(uname -r) is not the issue. The issue is that
when installing a self-compiled kernel, the firmware is not present
in /lib/firmware.

> > Problem comes when installing let say 2.6.27 since then the firmware
> > will be looked up in /lib/firmware/ and /lib/firmware/2.6.27/ and
> > actually it will not be found. Since it is in /lib/firmware/2.6.26-xx/
> > or something similar.
> 
> In what case? After you install a new kernel and then reboot? You have
> the same problem with the modules that need the firmware blobs.

If the firmware is not in /lib/firmware (especially external firmware)
it will not be found and the module will be useless if it depends on
that firmware. And the biggest part of the firmware is not distributed
with the kernel because of GPL restrictions. So whatever we decide for
the kernel right now helps nothing if the user needs external firmware
for their devices.

Just take the Intel wireless drivers as an example. If I boot my own
kernel, I have to make sure I either copied or linked them from the
distro directory to /lib/firmware or downloaded them. Whatever the
kernel firmware prefix is makes no difference here.

> > So having the kernel install everything in /lib/firmware works just fine
> > with every distro. However looking for firmware that is not shipped with
> > the kernel, we have a problem since Debian/Ubuntu just not installs it
> > in the right directory. And there is nothing the kernel can do about it
> > since it will not touch firmware it doesn't ship. The distro has to fix
> > their firmware or the users have to place a copy in /lib/firmware/ where
> > it actually should have been in the first place.
> 
> It works just fine until the user wants to install an additional, newer,
> kernel and the blob has changed but the filename hasn't.

That is the whole point and Dave and I discussed this deeply. If the
blob changes in an incompatible way or if a driver needs a newer
firmware, the firmware filename should change.

Regards

Marcel


