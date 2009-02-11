Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZBKM4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZBKM4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZBKM4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:56:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51415 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZBKM4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:56:43 -0500
Date: Wed, 11 Feb 2009 10:56:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [build bug] uvc_status_cleanup(): undefined reference to
 `input_unregister_device'
Message-ID: <20090211105600.32eefe7b@pedra.chehab.org>
In-Reply-To: <200902111247.39922.laurent.pinchart@skynet.be>
References: <20090208145835.GA1649@elte.hu>
	<200902100144.22532.laurent.pinchart@skynet.be>
	<20090211062933.3c9cd5a5@pedra.chehab.org>
	<200902111247.39922.laurent.pinchart@skynet.be>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Feb 2009 12:47:39 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Hi Mauro,
> 
> On Wednesday 11 February 2009 09:29:33 Mauro Carvalho Chehab wrote:
> > On Tue, 10 Feb 2009 01:44:22 +0100
> >
> > Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > >
> > > I'm not completely satisfied with this though, as the
> > > USB_VIDEO_CLASS_INPUT_EVDEV completely disappears from the configuration
> > > menu if INPUT is set to 'm' and USB_VIDEO_CLASS to 'y'. Being no Kconfig
> > > guru, I'd appreciate if someone could help me to find a nicer fix (if
> > > that's possible at all).
> >
> > This doesn't seem to be right. You're just disabling INPUT, if CONFIG_INPUT
> > = m and USB_VIDEO_CLASS=y. You should, instead, force USB_VIDEO_CLASS to be
> > 'm' or 'n' on such case.
> >
> > IMO, a better approach would be the one on the patch bellow.
> >
> > Cheers,
> > Mauro
> >
> > Fix input dependencies on uvc driver
> >
> > As reported by Ingo:
> > -tip testing found that certain (user-reachable) Kconfig combinations
> > can cause this build failure on latest mainline:
> >
> >  drivers/built-in.o: In function `uvc_status_cleanup':
> >   (.text+0x221cca): undefined reference to `input_unregister_device'
> >   drivers/built-in.o: In function `uvc_status_init':
> >   (.text+0x221d4c): undefined reference to `input_allocate_device'
> >   drivers/built-in.o: In function `uvc_status_init':
> >   (.text+0x221db3): undefined reference to `input_free_device'
> >   drivers/built-in.o: In function `uvc_status_init':
> >   (.text+0x221ec6): undefined reference to `input_register_device'
> >   drivers/built-in.o: In function `uvc_status_complete':
> >   uvc_status.c:(.text+0x2222ec): undefined reference to `input_event'
> >
> > triggered on v2.6.29-rc3-697-gae1a25d. The problem is this combination:
> >
> >   CONFIG_INPUT=m
> >   CONFIG_USB_VIDEO_CLASS=y
> >   CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >
> > diff --git a/drivers/media/video/uvc/Kconfig
> > b/drivers/media/video/uvc/Kconfig index c2d9760..fab4733 100644
> > --- a/drivers/media/video/uvc/Kconfig
> > +++ b/drivers/media/video/uvc/Kconfig
> > @@ -1,5 +1,6 @@
> >  config USB_VIDEO_CLASS
> >  	tristate "USB Video Class (UVC)"
> > +	depends on !USB_VIDEO_CLASS_INPUT_EVDEV || INPUT
> >  	---help---
> >  	  Support for the USB Video Class (UVC).  Currently only video
> >  	  input devices, such as webcams, are supported.
> > @@ -9,7 +10,7 @@ config USB_VIDEO_CLASS
> >  config USB_VIDEO_CLASS_INPUT_EVDEV
> >  	bool "UVC input events device support"
> >  	default y
> > -	depends on USB_VIDEO_CLASS && INPUT
> > +	depends on INPUT
> >  	---help---
> >  	  This option makes USB Video Class devices register an input device
> >  	  to report button events.
> 
> That's even worse. The following configurations would then be valid
> 
> INPUT = m/y
> USB_VIDEO_CLASS = n
> USB_VIDEO_CLASS_INPUT_EVDEV = m/y
> 
> USB_VIDEO_CLASS_INPUT_EVDEV must depend on USB_VIDEO_CLASS to be displayed as 
> a child of USB_VIDEO_CLASS in the configuration menu.

USB_VIDEO_CLASS_INPUT_EVDEV can't be m, since it is bool. But, you're right:
we'll loose the dependency of USB_VIDEO_CLASS_INPUT_EVDEV and USB_VIDEO_CLASS.

There's another alternative, if we consider that all systems but a few embedded
ones have input defined.

We may do something like:

diff --git a/drivers/media/video/uvc/Kconfig b/drivers/media/video/uvc/Kconfig index c2d9760..14e7537 100644
--- a/drivers/media/video/uvc/Kconfig
+++ b/drivers/media/video/uvc/Kconfig
@@ -1,5 +1,6 @@
 config USB_VIDEO_CLASS
 	tristate "USB Video Class (UVC)"
+	depends on INPUT
 	---help---
 	  Support for the USB Video Class (UVC).  Currently only video
 	  input devices, such as webcams, are supported.

I suspect that this will work fine for all practical usages.

Another option would be to have a generic option at V4L for evdev interfaces
(config MEDIA_EVDEV), that is independent of uvc (the same kind of dependency
exists on other drivers at the subsystem, like cx88, saa7134, etc). It will be
a larger changeset, but maybe useful, since someone may disable EVDEV interface
for other V4L/DVB drivers as well.

Cheers,
Mauro.
