Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbYGYKjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbYGYKjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbYGYKjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:39:08 -0400
Received: from nox.protox.org ([88.191.38.29]:57290 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbYGYKjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:39:07 -0400
X-Greylist: delayed 1563 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 06:39:07 EDT
Date: Fri, 25 Jul 2008 12:12:59 +0200
From: Jerome Glisse <glisse@freedesktop.org>
To: Jonathan McDowell <noodles@earth.li>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: X "Hangs" with RS690 + 2.6.26
Message-Id: <20080725121259.757499a9.glisse@freedesktop.org>
In-Reply-To: <20080725094334.GC30002@earth.li>
References: <20080725094334.GC30002@earth.li>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 10:43:34 +0100
Jonathan McDowell <noodles@earth.li> wrote:

> Hi.
> 
> I've started to see "hangs" with X on an ATI RS690 with a 2.6.26 kernel.
> The symptoms are that load average goes up, X stops accepting keypresses
> or mouse clicks, but the cursor still moves around the screen in
> response to the mouse being moved. I can't switch to a VT but can ssh in
> remotely to see that things are still running. I don't seem to be able
> to kill X but "shutdown -r now" cleanly reboots.
> 
> gdb fails to attach - complains about an internal error. strace shows
> lots of ioctls against the DRM device all returning EBUSY.
> 
> 2.6.25 appears to work fine. I originally had PAT enabled under 2.6.26
> but have seen a patch fixing that go into git, so disabled it for my
> 2.6.26 kernel to see if that was the issue; no change AFAICT.
> 
> Enabling DRM debug (echo 1 > /sys/module/drm/parameters/debug) gives
> lots of output from radeon_freelist_get, after the following ioctl is
> received:
> 
> Jul 25 10:11:14 meepok kernel: [drm:drm_ioctl] pid=3302, cmd=0xc0406429, nr=0x29 , dev 0xe200, auth=1
> 
> and then a returning NULL message.
> 
> radeon driver is recent git - 1c5858484da4fb1c9bc3ac3b4d7a97863ab99730
> but I've seen it with older revisions too.
> 
> It can take a couple of days for me to hit the problem, so a git bisect
> could be a lengthy process. If anyone has any suggestions about faster
> ways to track down the issue I'd like to hear them.
> 
> Machine is a dual core AMD64 with 4GB of RAM running Debian unstable,
> card is:
> 
> 01:05.0 VGA compatible controller [0300]: ATI Technologies Inc RS690 [Radeon X1200 Series] [1002:791e]
> 
> Kernel configs at:
> 
> http://the.earth.li/~noodles/radeon-2.6.26-hang/config-2.6.25
> http://the.earth.li/~noodles/radeon-2.6.26-hang/config-2.6.26
> 
> Debug log from enabling drm debug:
> 
> http://the.earth.li/~noodles/radeon-2.6.26-hang/debug
> 
> Full dmesg (no obvious errors):
> 
> http://the.earth.li/~noodles/radeon-2.6.26-hang/meepok.dmesg
> 
> Xorg log file (no obvious errors):
> 
> http://the.earth.li/~noodles/radeon-2.6.26-hang/Xorg.0.log
> 
> J.
> 

This looks like usual engine lockup followed by CP lockup so
that DMA buffer age never get written and we run out of DMA
buffer thus freelist failing in infinite loop.

I think we now know all the reason why we lockup, while a
fix could be made for old ioctl we believe the best plan is
to work on new ioctl with this fix in mind.

So i don't think a bisect will help, there is certainly somethings
that made this lockup more probable to happen on your config
but best things is to fix lockup.

If you really got time you can still do bisect and find out
what makes this lockups more obvious on your config this could
be helpfull to check that our theories are goods.

Cheers,
Jerome Glisse
