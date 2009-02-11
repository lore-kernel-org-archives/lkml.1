Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZBKIa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZBKIa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZBKIaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:30:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55165 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZBKIaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:30:16 -0500
Date: Wed, 11 Feb 2009 06:29:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [build bug] uvc_status_cleanup(): undefined reference to
 `input_unregister_device'
Message-ID: <20090211062933.3c9cd5a5@pedra.chehab.org>
In-Reply-To: <200902100144.22532.laurent.pinchart@skynet.be>
References: <20090208145835.GA1649@elte.hu>
	<200902100144.22532.laurent.pinchart@skynet.be>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 10 Feb 2009 01:44:22 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Hi Ingo,
> 
> On Sunday 08 February 2009 15:58:35 Ingo Molnar wrote:
> > Hi, havent seen this reported on lkml yet.
> >
> > -tip testing found that certain (user-reachable) Kconfig combinations
> > can cause this build failure on latest mainline:
> >
> >  drivers/built-in.o: In function `uvc_status_cleanup':
> >  (.text+0x221cca): undefined reference to `input_unregister_device'
> >  drivers/built-in.o: In function `uvc_status_init':
> >  (.text+0x221d4c): undefined reference to `input_allocate_device'
> >  drivers/built-in.o: In function `uvc_status_init':
> >  (.text+0x221db3): undefined reference to `input_free_device'
> >  drivers/built-in.o: In function `uvc_status_init':
> >  (.text+0x221ec6): undefined reference to `input_register_device'
> >  drivers/built-in.o: In function `uvc_status_complete':
> >  uvc_status.c:(.text+0x2222ec): undefined reference to `input_event'
> >
> > triggered on v2.6.29-rc3-697-gae1a25d. The problem is this combination:
> >
> >  CONFIG_INPUT=m
> >  CONFIG_USB_VIDEO_CLASS=y
> >  CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
> 
> Thanks for the report. The following patch should fix the issue.
> 
> diff --git a/drivers/media/video/uvc/Kconfig b/drivers/media/video/uvc/Kconfig
> index c2d9760..0dbe7b9 100644
> --- a/drivers/media/video/uvc/Kconfig
> +++ b/drivers/media/video/uvc/Kconfig
> @@ -9,7 +9,7 @@ config USB_VIDEO_CLASS
>  config USB_VIDEO_CLASS_INPUT_EVDEV
>         bool "UVC input events device support"
>         default y
> -       depends on USB_VIDEO_CLASS && INPUT
> +       depends on USB_VIDEO_CLASS && (INPUT = y || INPUT = USB_VIDEO_CLASS)
>         ---help---
>           This option makes USB Video Class devices register an input device
>           to report button events.
> 
> I'm not completely satisfied with this though, as the 
> USB_VIDEO_CLASS_INPUT_EVDEV completely disappears from the configuration menu 
> if INPUT is set to 'm' and USB_VIDEO_CLASS to 'y'. Being no Kconfig guru, I'd 
> appreciate if someone could help me to find a nicer fix (if that's possible at 
> all).

This doesn't seem to be right. You're just disabling INPUT, if CONFIG_INPUT = m
and USB_VIDEO_CLASS=y. You should, instead, force USB_VIDEO_CLASS to be 'm' or
'n' on such case.

IMO, a better approach would be the one on the patch bellow.

Cheers,
Mauro

Fix input dependencies on uvc driver

As reported by Ingo:
-tip testing found that certain (user-reachable) Kconfig combinations
can cause this build failure on latest mainline:

 drivers/built-in.o: In function `uvc_status_cleanup':
  (.text+0x221cca): undefined reference to `input_unregister_device'
  drivers/built-in.o: In function `uvc_status_init':
  (.text+0x221d4c): undefined reference to `input_allocate_device'
  drivers/built-in.o: In function `uvc_status_init':
  (.text+0x221db3): undefined reference to `input_free_device'
  drivers/built-in.o: In function `uvc_status_init':
  (.text+0x221ec6): undefined reference to `input_register_device'
  drivers/built-in.o: In function `uvc_status_complete':
  uvc_status.c:(.text+0x2222ec): undefined reference to `input_event'

triggered on v2.6.29-rc3-697-gae1a25d. The problem is this combination:

  CONFIG_INPUT=m
  CONFIG_USB_VIDEO_CLASS=y
  CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/uvc/Kconfig b/drivers/media/video/uvc/Kconfig
index c2d9760..fab4733 100644
--- a/drivers/media/video/uvc/Kconfig
+++ b/drivers/media/video/uvc/Kconfig
@@ -1,5 +1,6 @@
 config USB_VIDEO_CLASS
 	tristate "USB Video Class (UVC)"
+	depends on !USB_VIDEO_CLASS_INPUT_EVDEV || INPUT
 	---help---
 	  Support for the USB Video Class (UVC).  Currently only video
 	  input devices, such as webcams, are supported.
@@ -9,7 +10,7 @@ config USB_VIDEO_CLASS
 config USB_VIDEO_CLASS_INPUT_EVDEV
 	bool "UVC input events device support"
 	default y
-	depends on USB_VIDEO_CLASS && INPUT
+	depends on INPUT
 	---help---
 	  This option makes USB Video Class devices register an input device
 	  to report button events.

