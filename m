Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZBJAlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZBJAlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZBJAlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:41:14 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:10243 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbZBJAlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:41:13 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAMBakElR8Vzi/2dsb2JhbACBbtADhBoG
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build bug] uvc_status_cleanup(): undefined reference to `input_unregister_device'
Date: Tue, 10 Feb 2009 01:44:22 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.28; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090208145835.GA1649@elte.hu>
In-Reply-To: <20090208145835.GA1649@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902100144.22532.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sunday 08 February 2009 15:58:35 Ingo Molnar wrote:
> Hi, havent seen this reported on lkml yet.
>
> -tip testing found that certain (user-reachable) Kconfig combinations
> can cause this build failure on latest mainline:
>
>  drivers/built-in.o: In function `uvc_status_cleanup':
>  (.text+0x221cca): undefined reference to `input_unregister_device'
>  drivers/built-in.o: In function `uvc_status_init':
>  (.text+0x221d4c): undefined reference to `input_allocate_device'
>  drivers/built-in.o: In function `uvc_status_init':
>  (.text+0x221db3): undefined reference to `input_free_device'
>  drivers/built-in.o: In function `uvc_status_init':
>  (.text+0x221ec6): undefined reference to `input_register_device'
>  drivers/built-in.o: In function `uvc_status_complete':
>  uvc_status.c:(.text+0x2222ec): undefined reference to `input_event'
>
> triggered on v2.6.29-rc3-697-gae1a25d. The problem is this combination:
>
>  CONFIG_INPUT=m
>  CONFIG_USB_VIDEO_CLASS=y
>  CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y

Thanks for the report. The following patch should fix the issue.

diff --git a/drivers/media/video/uvc/Kconfig b/drivers/media/video/uvc/Kconfig
index c2d9760..0dbe7b9 100644
--- a/drivers/media/video/uvc/Kconfig
+++ b/drivers/media/video/uvc/Kconfig
@@ -9,7 +9,7 @@ config USB_VIDEO_CLASS
 config USB_VIDEO_CLASS_INPUT_EVDEV
        bool "UVC input events device support"
        default y
-       depends on USB_VIDEO_CLASS && INPUT
+       depends on USB_VIDEO_CLASS && (INPUT = y || INPUT = USB_VIDEO_CLASS)
        ---help---
          This option makes USB Video Class devices register an input device
          to report button events.

I'm not completely satisfied with this though, as the 
USB_VIDEO_CLASS_INPUT_EVDEV completely disappears from the configuration menu 
if INPUT is set to 'm' and USB_VIDEO_CLASS to 'y'. Being no Kconfig guru, I'd 
appreciate if someone could help me to find a nicer fix (if that's possible at 
all).

Laurent Pinchart

