Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbYEDI4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbYEDI4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYEDI4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:56:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:43382 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbYEDI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kYfR/UlKWBUoQXEybS8qdzdLhhdy+doTBLLm19kCZaqagyPVwUFNUIs80v1RzdxEz63/lZouixeT7h4IxvPgWptLnDL0vkFDin5X/3hKvcgvD/kTd+jIKqx9rihbt8JUsgSVLAoM6SmazW+v1UuTed+0KiY7iytvAHUIRz7vLS0=
Message-ID: <19f34abd0805040156i614db705xc642b301259a4d04@mail.gmail.com>
Date: Sun, 4 May 2008 10:56:36 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] kconfig: warn about complex selects
Cc: "Ingo Molnar" <mingo@elte.hu>, "Roman Zippel" <zippel@linux-m68k.org>,
       "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080504082147.GA17276@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504054044.GA32030@damson>
	 <20080504082147.GA17276@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 10:21 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> On Sun, May 04, 2008 at 07:40:44AM +0200, Vegard Nossum wrote:
>  > Hi,
>  >
>  > Given recent discussion about kconfig and the "select" feature, I have made
>  > the following quick & dirty patch to detect what I call "complex selects".
>  >
>  > For v2.6.25, I get these warnings:
>  > sound/pci/Kconfig:512:error: found complex select: SND_FM801_TEA575X -> VIDEO_V4L1
>  > drivers/ide/Kconfig:890:error: found complex select: ETRAX_IDE -> BLK_DEV_IDEDMA
>  > drivers/acpi/Kconfig:185:error: found complex select: ACPI_HOTPLUG_CPU -> ACPI_CONTAINER
>  >
>  > While for v2.6.26-rc1, I get these:
>  > sound/pci/Kconfig:528:error: found complex select: SND_FM801_TEA575X -> VIDEO_V4L1
>  > drivers/media/video/em28xx/Kconfig:2:error: found complex select: VIDEO_EM28XX -> MEDIA_TUNER
>  > drivers/media/video/bt8xx/Kconfig:2:error: found complex select: VIDEO_BT848 -> MEDIA_TUNER
>  > drivers/media/video/saa7134/Kconfig:2:error: found complex select: VIDEO_SAA7134 -> MEDIA_TUNER
>  > drivers/media/video/cx88/Kconfig:2:error: found complex select: VIDEO_CX88 -> MEDIA_TUNER
>  > drivers/media/video/cx23885/Kconfig:2:error: found complex select: VIDEO_CX23885 -> MEDIA_TUNER
>  > drivers/media/video/ivtv/Kconfig:2:error: found complex select: VIDEO_IVTV -> MEDIA_TUNER
>  > drivers/media/video/cx18/Kconfig:2:error: found complex select: VIDEO_CX18 -> MEDIA_TUNER
>  > drivers/media/video/pvrusb2/Kconfig:2:error: found complex select: VIDEO_PVRUSB2 -> MEDIA_TUNER
>  > drivers/media/video/Kconfig:690:error: found complex select: VIDEO_MXB -> MEDIA_TUNER
>  > drivers/media/video/usbvision/Kconfig:2:error: found complex select: VIDEO_USBVISION -> MEDIA_TUNER
>  > drivers/acpi/Kconfig:188:error: found complex select: ACPI_HOTPLUG_CPU -> ACPI_CONTAINER
>  >
>  > (In other words, the number of these has increased significantly since the
>  > last release, and these will probably be hit as compile errors at one point
>  > or another.)
>  >
>  > I am not a kconfig expert, so I might have missed some things. Roman, is this
>  > even remotely good? I think it's probably a good start anyway.
>
>  I did a small test of this using following configuration:
>  config A
>         bool "a"
>
>  config B
>         bool "b"
>         depends on A
>         default AA || AAA
>
>  config BB
>         bool "bb"
>         depends on A
>
>  config C
>         bool "c"
>         select B
>
>  config CC
>         bool "cc"
>         select BB
>
>
>  I had expected a warning about complex select for
>  both C and CC. But only C triggered the warning
>  due to the complex default value of B.
>  So we need to work on this a bit more.

Oops, yes. What I am checking is in fact only the "default" property,
not the "depends on". Hm. How to get the list of dependencies? :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
