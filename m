Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbXEURdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbXEURdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbXEURdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:33:07 -0400
Received: from outbound-mail-69.bluehost.com ([69.89.21.29]:48219 "HELO
	outbound-mail-69.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755107AbXEURdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:33:05 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Mon, 21 May 2007 10:32:58 -0700
User-Agent: KMail/1.9.6
Cc: "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com> <200705210934.58559.jbarnes@virtuousgeek.org> <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
In-Reply-To: <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211032.58509.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, Jon Smirl wrote:
> On 5/21/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Monday, May 21, 2007, Jesse Barnes wrote:
> > > > There is more to fbdev than mode setting. It is also how non-x86
> > > > platforms achieve their boot display. How will boot display be
> > > > handled with the your design? What about console display on
> > > > non-x86 platforms? Loading both fbdev and the new code puts us
> > > > right back into the multiple driver fight we have today.
> > >
> > > Maybe you should take a look at the patches. :)  The code I posted
> > > actually creates an fb device as a slave of the DRM device, and uses
> > > that for the boot console.  Once you've booted, you can use the new
> > > interfaces to do whatever you want with the graphics device...
> > > though it doesn't create /dev/fb* devices per-CRTC like you seem to
> > > want, it's really easy to do the equivalent with a small userspace
> > > program (though I haven't actually tested sharing of buffer objects,
> > > it should work).
> >
> > Actually, scratch that last bit.  I forgot about a recent change alanh
> > committed that did just that:  per-CRTC FB devices.  So please take a
> > close look (modesetting-101 of mesa/drm git at freedesktop.org) and
> > let me know if you see any gaping holes.
>
> Here are some of the goals that I believe a rewrite of the graphics
> system should address:

I think we're talking past each other.  I addressed many of the points 
below in my initial post...

> 1) Be upwards compatible with the existing fbdev drivers. This lets us
> avoid rewriting the 90 existing drivers. New drivers shouldn't break
> any old apps.

That's there, see the patches.

> 2) Address the long outstanding issue of multi-seat at the console
> level. My solution to this is the one device per CRTC model.

Also covered.

> 3) Eliminate the need for a root priv controlling process. Get rid of
> the potential for a security hole.

This is an implementation detail.  I can understand not wanting to run a 
huge X server for this purpose, but I've already said that it can be done 
with far less code for environments with different needs.

> 4) OOPS should always display even if in a graphics mode

This is definitely a goal, and something I spelled out in my initial post.  
I think we'll need a new KD_* type to cover this case (i.e. not KD_TEXT 
but not quite KD_GRAPHICS either).  This should be fairly straightforward 
once I have some good user level apps running on top of these interfaces.

> 5) Support Secure Attention Key (SAK).

This is more of a console issue, not really a graphics design issue I 
think.

> 6) Eliminate the existing VT swap driver free for all. I would compile
> out the VT layer and replace it with a compatible API that enforces
> some sanity.

Again, called out in my initial post.  Yes, the kernel should save/restore 
state by itself and not rely on some userspace application.  However, we 
don't want to break the VT switch API either, so we'll still likely need a 
heavyweight save/restore state mechanism somewhere.

> 7) Support Unicode on the console

A userspace console using these interfaces could do this, it's not really a 
kernel graphics problem.

> 8) Allow multiple user space graphics systems to run. These user space
> systems should not touch the hardware, instead they ask the kernel
> driver to manipulate the hardware on their behalf. Of course the
> kernel driver is only the minimum code needed to arbitrate control of
> the resources - it doesn't do things like implement drawing
> algorithms.

This is already done.

> 9) Booting on non-VGA hardware still needs to work.

I don't see what this has to do with the overall design, it's a driver 
problem (well aside from polluting the generic interfaces with VGA 
knowledge, which I'm not planning on doing).

> 10) Support things like cloning and output device selection.

Already done.

Again, *please* take a look at the description in my initial post and the 
patches themselves (or the modesetting-101 branch in the drm tree).  I 
think that'll lead to a more concrete discussion about what's 
missing/needed, etc.

Thanks,
Jesse
