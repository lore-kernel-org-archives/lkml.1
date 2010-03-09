Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab0CIMtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 07:49:10 -0500
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:43123 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751239Ab0CIMtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 07:49:07 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 07:49:06 EST
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-input@vger.kernel.org
Subject: Re: [BUG?] hid-core.c: hid->name = dev->manufacturer + dev->product ... why not + dev->serial?
Date: Tue, 9 Mar 2010 13:42:20 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33; KDE/4.3.5; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-iio@vger.kernel.org
References: <201003071655.06644@rk-nord.at> <20100309082216.GG17288@core.coreip.homeip.net>
In-Reply-To: <20100309082216.GG17288@core.coreip.homeip.net>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003091342.20273@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

* Dmitry Torokhov -- Tuesday 09 March 2010:
> I'm adding a few CCs and takinng discussion a bit away from your patch
> ;)

Hmm ... I wonder if they'll all be happy about that. But I can't cut them
off now, either. Sorry.  :-}



> On Sun, Mar 07, 2010 at 04:55:06PM +0100, Melchior FRANZ wrote:
> > The Linux kernel creates the HID/"joystick name" from only iManufacturer and
> > iProduct, ignoring iSerial. That way, JSIOCGNAME returns the same string
> > for all such devices, making an actual identification impossible.

> This is nicely illustrates one of the reasons why input subsystem is
> ill-suited for generic data acquisition.

No. It demonstrates that Linux shouldn't drop essential information on
the floor for no good reason. So, why is iSerial ignored? After all,
my simple patch solves my problems. Most input devices probably don't
have iSerial set anyway, so there wouldn't be much change. But those
devices that *do* set it may have a reason to do so.



> You may have 2 joysticks and prefer to use one in one game and other
> in another game.

Sure. And that's still possible, just like before. The difference is,
that *if* an application actually cares about the name, then it does
now get an actual identifier, not just a generic product name. And not
just "some" identifier, but the one that the manufacturer set, which
includes the serial number. If an application does only want to look
up the product, rather than the specific devices, then it can simply
search for the longest match in its db.



> With default setup you could grab either one and start playing, ABS_X
> from either mapping on horizontal movements, ABS_Y on vertical... Same
> with keyboards - you plug an external keyboard into laptop and you just
> start typing

Yes, and that works no matter if serial is in the name or not. Because
that's how usb/hid works. But *iff* an application wants to query the
device's identifier, then it better be specific, no? That's what identifiers
are about.



> > The patch below fixed the problem for me. But, certainly, the current
> > (mis)behaviour wasn't an accident, but intentional. But what was the
> > intention? What happens if I attach two actual identical joysticks?
> > What's the purpose of them having the same name on the system under
> > /dev/input/{js,event}? 
> 
> They will have different event nodes.

Sure. Unfortunatly that doesn't buy me anything. Of cousre, I can just
work around the strange omission and do the USB querying myself. But the
question still is, why do I have to? Because the kernel dropped information
that I now have to retrieve again the hard way?  :-)



> Nevertheless serials are exported in sysfs ('uniq' attribute). Also udev
> can give persistent names device nodes based on physocal connection,
> serial numbers, etc.

It's not much fun to use all sorts of additional Linux specific interfaces,
because the responsible one doesn't do its job.

Anyway, my kernel is "fixed", so it's not about me at all. I just feel a
bit uncomfortably if I have to hack my kernel. Before the fix I got this
information from js_demo/JSIOCGNAME:

  Joystick 0: "Leo Bodnar BU0836A Interface"
  Joystick 1: "Leo Bodnar BU0836A Interface"
  Joystick 2: "SAITEK CYBORG 3D USB"

and now I get:

  Joystick 0: "Leo Bodnar BU0836A Interface A12107"
  Joystick 1: "Leo Bodnar BU0836A Interface A12100"
  Joystick 2: "SAITEK CYBORG 3D USB"

As you see, nothing changed for the Saitek. They don't bother setting
iSerial, as probably most vendors. (Reminder: These are circuit boards
and can have very different sensors attached to their inputs, so it's
essential to identify them safely).

m.
