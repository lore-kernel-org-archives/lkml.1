Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbXHaOmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbXHaOmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760118AbXHaOmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:42:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53365 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759969AbXHaOmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:42:37 -0400
Date: Fri, 31 Aug 2007 20:25:42 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rene Herman <rene.herman@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net
Subject: Re: DRM and/or X trouble
In-Reply-To: <46D7F0FE.2040306@gmail.com>
Message-ID: <alpine.LFD.0.999.0708312004540.9261@enigma.security.iitk.ac.in>
References: <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com>
 <20070829041827.GA8733@elte.hu> <1188361749.21502.123.camel@koto.keithp.com>
 <20070829044614.GA13225@elte.hu> <1188374249.21502.155.camel@koto.keithp.com>
 <20070829080417.GB19386@elte.hu> <1188403075.21502.158.camel@koto.keithp.com>
 <46D5CF5F.6090505@gmail.com> <46D66C2D.3010900@gmail.com>
 <20070831064638.GA5315@code-monkey.de> <46D7F0FE.2040306@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Trimmed Cc: list, dropped sched folk, retained DRM. ]


On Fri, 31 Aug 2007, Rene Herman wrote:

> On 08/31/2007 08:46 AM, Tilman Sauerbeck wrote:
> 
> > > On 08/29/2007 09:56 PM, Rene Herman wrote:
> 
> > > > > With X server 1.3, I'm getting consistent crashes with two glxgear
> > > > > instances running. So, if you're getting any output, it's better than
> > > > > my
> > > > > situation.
> > > > Before people focuss on software rendering too much -- also with 1.3.0
> > > > (and a Matrox Millenium G550 AGP, 32M) glxgears also works decidedly
> > > > crummy using hardware rendering. While I can move the glxgears window
> > > > itself, the actual spinning wheels stay in the upper-left corner of the
> > > > screen and the movement leaves a non-repainting trace on the screen.
> > 
> > This sounds like you're running an older version of Mesa.
> > The bugfix went into Mesa 6.3 and 7.0.
> 
> I have Mesa 6.5.2 it seems (slackware-12.0 standard):
> 
> OpenGL renderer string: Mesa DRI G400 20061030 AGP 2x x86/MMX+/3DNow!+/SSE
> OpenGL version string: 1.2 Mesa 6.5.2
> 
> The bit of the problem sketched above -- the gears just sitting there in the
> upper left corner of the screen and not moving alongside their window is fully
> reproduceable. The bit below ... :
> 
> > > > Running a second instance of glxgears in addition seems to make both
> > > > instances unkillable -- and when I just now forcefully killed X in this
> > > > situation (the spinning wheels were covering the upper left corner of
> > > > all
> > > > my desktops) I got the below.
> 
> [ two kernel BUGs ]
> 
> ... isn't. This seems to (again) have been a race of sorts that I hit by
> accident since I haven't reproduced yet. Had the same type of "racyness"
> trouble with keyboard behaviour in this version of X earlier.

Dave (Airlie), this is an oops first reported at:
http://lkml.org/lkml/2007/8/30/9

mga_freelist_get() is inlined at its only callsite mga_dma_get_buffers()
that is in turn inlined at its only callsite in mga_dma_buffers(). This
oops was hit ...

static struct drm_buf *mga_freelist_get(struct drm_device * dev)
{
	...
	head = MGA_READ(MGA_PRIMADDRESS); <=== ... HERE.
	...
}

MGA_READ() is DRM_READ32(), and dev_priv->mmio was found to be NULL when
trying to access dev_priv->mmio->handle as shown above.


> > Running two instances of glxgears and killing them works for me, too.
> > 
> > I'm using xorg-server 1.3.0.0, Mesa 7.0.1 with the latest DRM bits from
> > http://gitweb.freedesktop.org/?p=mesa/drm.git;a=summary
> 
> For me, everything standard slackware-12.0 (X.org 1.3.0) and kernel 2.6.22
> DRM.
> 
> > I'm not running CFS though, but I guess the oops wasn't related to that.
> 
> I've noticed before the Matrox driver seems to get little attention/testing so
> maybe that's just it. A G550 is ofcourse in graphics-time a Model T by now.
> I'm rather decidedly not a graphics person so I don't care a lot but every
> time I try to do something fashionable (run Google Earth for example) I notice
> things are horribly, horribly broken.
> 
> X bugs I do not find very interesting (there's just too many) and the kernel
> bugs are requiring more time to reproduce than I have available. If the BUGs
> as posted aren't enough for a diagnosis, please consider the report withdrawn.

As you already know by now, this oops isn't a bug or anything in the
scheduler at all, but more likely a race in the DRM itself (which possibly
could have been exposed by some aspect of CFS). So it makes sense to
"withdraw" this as a CFS-related bug report, but definitely not as a DRM-
related bug report.


Satyam
