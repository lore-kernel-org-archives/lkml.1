Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZBKLoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZBKLoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 06:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZBKLo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 06:44:29 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:46568 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbZBKLo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 06:44:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkFACtHkknCTsYx/2dsb2JhbACBbtFQhBoG
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [build bug] uvc_status_cleanup(): undefined reference to `input_unregister_device'
Date: Wed, 11 Feb 2009 12:47:39 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.28; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090208145835.GA1649@elte.hu> <200902100144.22532.laurent.pinchart@skynet.be> <20090211062933.3c9cd5a5@pedra.chehab.org>
In-Reply-To: <20090211062933.3c9cd5a5@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902111247.39922.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wednesday 11 February 2009 09:29:33 Mauro Carvalho Chehab wrote:
> On Tue, 10 Feb 2009 01:44:22 +0100
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> >
> > I'm not completely satisfied with this though, as the
> > USB_VIDEO_CLASS_INPUT_EVDEV completely disappears from the configuration
> > menu if INPUT is set to 'm' and USB_VIDEO_CLASS to 'y'. Being no Kconfig
> > guru, I'd appreciate if someone could help me to find a nicer fix (if
> > that's possible at all).
>
> This doesn't seem to be right. You're just disabling INPUT, if CONFIG_INPUT
> = m and USB_VIDEO_CLASS=y. You should, instead, force USB_VIDEO_CLASS to be
> 'm' or 'n' on such case.
>
> IMO, a better approach would be the one on the patch bellow.
>
> Cheers,
> Mauro
>
> Fix input dependencies on uvc driver
>
> As reported by Ingo:
> -tip testing found that certain (user-reachable) Kconfig combinations
> can cause this build failure on latest mainline:
>
>  drivers/built-in.o: In function `uvc_status_cleanup':
>   (.text+0x221cca): undefined reference to `input_unregister_device'
>   drivers/built-in.o: In function `uvc_status_init':
>   (.text+0x221d4c): undefined reference to `input_allocate_device'
>   drivers/built-in.o: In function `uvc_status_init':
>   (.text+0x221db3): undefined reference to `input_free_device'
>   drivers/built-in.o: In function `uvc_status_init':
>   (.text+0x221ec6): undefined reference to `input_register_device'
>   drivers/built-in.o: In function `uvc_status_complete':
>   uvc_status.c:(.text+0x2222ec): undefined reference to `input_event'
>
> triggered on v2.6.29-rc3-697-gae1a25d. The problem is this combination:
>
>   CONFIG_INPUT=m
>   CONFIG_USB_VIDEO_CLASS=y
>   CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/video/uvc/Kconfig
> b/drivers/media/video/uvc/Kconfig index c2d9760..fab4733 100644
> --- a/drivers/media/video/uvc/Kconfig
> +++ b/drivers/media/video/uvc/Kconfig
> @@ -1,5 +1,6 @@
>  config USB_VIDEO_CLASS
>  	tristate "USB Video Class (UVC)"
> +	depends on !USB_VIDEO_CLASS_INPUT_EVDEV || INPUT
>  	---help---
>  	  Support for the USB Video Class (UVC).  Currently only video
>  	  input devices, such as webcams, are supported.
> @@ -9,7 +10,7 @@ config USB_VIDEO_CLASS
>  config USB_VIDEO_CLASS_INPUT_EVDEV
>  	bool "UVC input events device support"
>  	default y
> -	depends on USB_VIDEO_CLASS && INPUT
> +	depends on INPUT
>  	---help---
>  	  This option makes USB Video Class devices register an input device
>  	  to report button events.

That's even worse. The following configurations would then be valid

INPUT = m/y
USB_VIDEO_CLASS = n
USB_VIDEO_CLASS_INPUT_EVDEV = m/y

USB_VIDEO_CLASS_INPUT_EVDEV must depend on USB_VIDEO_CLASS to be displayed as 
a child of USB_VIDEO_CLASS in the configuration menu.

Regards,

Laurent Pinchart

