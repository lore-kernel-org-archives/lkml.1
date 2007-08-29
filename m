Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbXH2Xas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbXH2Xas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXH2Xah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:30:37 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51691 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509AbXH2Xag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:30:36 -0400
X-Sasl-enc: 8ugo5J2I5mswOka1B99FAQrWQJIXbdDIc/ZXYASbnO2w 1188430234
Date: Wed, 29 Aug 2007 20:30:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Yan Burman <burman.yan@gmail.com>
Cc: hdaps-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Hdaps-devel] [PATCH 2.6.23-rc2] hwmon: HP Mobile Data
	Protection System 3D ACPI driver (resend)
Message-ID: <20070829233024.GA7433@khazad-dum.debian.net>
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz> <46D01420.3070400@gmail.com> <20070827171107.GA15647@khazad-dum.debian.net> <46D5A742.8090201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D5A742.8090201@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007, Yan Burman wrote:
> I don't mind doing it this way, it's just that from what I saw all 
> current applications use the sys interface, so I figured that people
> would like to be able to use those.

Well, they will have to fix their applications to use the input device, if
the other drivers do all of us a big favour and NOT implement that hideous
crap HDAPS unforunately started with.

That said, if you decide to implement it, we can also live with that.  It
just takes one warning on the driver to the likes of "warning: application
with pid foo is using an outdated, power-wasting interface, please port it
to the accelerometer input device" to syslog anytime you notice someone is
trying to read it often enough.

HDAPS with input device support is quite new.  hdapsd was patched to talk to
it, too.  I suppose we should port the input device support to the driver
in-tree just so that we get it in tree as well.  Sounds like an useful
reason to bother with in-tree hdaps.  Not that it will save much power with
the in-tree driver, but at least it will be widely available from there.

> Debian/Ubuntu also have some stuff for hdaps in their repositories. So 
> it seems to me that people are using the sys interface.

They didn't have a choice until a few weeks ago... not for HDAPS, at least.

> > driver gets the dibs on how to implement those interfaces in a proper
> > generic way.  Want to be the one? Please?  We in hdaps-devel can certainly
> > help with ideas and fix out-of-tree hdaps to also implement the interface.
> >   
> I agree that the sys interface is probably not the best choice, but the 
> accelerometer data should provide not only position, but also generate 
> an event when it detects
> that it's falling. From what I understood hdaps does not have that info, 

You can generate events on input devices, but I am not sure that's the best
way to go about it for this.  Things that block on read until an interrupt
happens might work better.  And there is also netlink sockets, and other
ways to send events to user space.  I don't know which way would be best,
this is something to ask in LKML.

I'd suggest an accelerometer sysfs interface, that we implement in hdaps
(in and out-of-tree), ams and hpmdp.  One input device for joystick
emulation (optional), one input device with accelerometer data in mg or ug,
and an optional one with the raw accelerometer data.  Also, an optional way
to send events notifying of free-fall to userspace *and* to other kernel
drivers (so that you can actually hook it to the queue-freeze engine
in-kernel, I fail to see why ams and hpmdp should need userspace at all,
unless someone wants to implement their own free-fall algorithms instead of
using whatever is in the firmware).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
