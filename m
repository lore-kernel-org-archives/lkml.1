Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZLCIAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZLCIAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZLCIAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:00:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:57306 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZLCIAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:00:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,331,1257148800"; 
   d="scan'208";a="519349753"
Subject: Re: Backlight device class redesign
From: Zhang Rui <rui.zhang@intel.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <b170af450911291209o33ebfc36n850826e54096f3b4@mail.gmail.com>
References: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com>
	 <b170af450911291209o33ebfc36n850826e54096f3b4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 16:01:14 +0800
Message-ID: <1259827274.27069.50.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 04:09 +0800, Rafał Miłecki wrote:
> W dniu 28 listopada 2009 01:30 użytkownik Rafał Miłecki
> <zajec5@gmail.com> napisał:
> > As discussed in http://marc.info/?t=124947671300008&r=1&w=2 we need to
> > redesign our backlight device class.
> 
> I was trying to make it work this way:
> 1. Everytime register request comes, look for backlight_display with given name.
> 1. A. If needed, create new backlight_display
> 2. Add new device to devices list of backlight_display
> 3. Find best device on devices list of backlight_display
> 4. Register if under /sys/class/backlight/name_of_display
> 
> This didn't work because of registering only the best device. Look at
> this code in drivers/acpi/video.c:
> 

> device->backlight = backlight_device_register(name,
>     NULL, device, &acpi_backlight_ops);
> (...)
> result = sysfs_create_link(&device->backlight->dev.kobj,
>     &device->dev->dev.kobj, "device");
> 
IMO, we should create one device for one display.
For example, device /sys/class/backlight/panel0 is created the first
time a backlight_ops for this display is registered.
And create the symbol link from the backlight class device to "physical
device" (device that invokes backlight_device_register) in the backlight
class device driver, if we really need it.
Remove and recreate a link pointing to the new physical device when the
backlight mode is changed.

thanks,
rui

> It expects device to be registered (have dev.kobj) after calling
> backlight_device_register.
> 
> So in summary we just can not do lazy registration. Every device
> passed to backlight_device_register has to be registered in that
> function or never.
> 
> So I think we have to register every device and just keep symlink
> /sys/class/backlight/display_name pointing best device. We could
> register devices in
> 1) /sys/class/backlight/.devicename (hidden)
> 2) some /sys/class/internal-usage/devicename
> 
> Do you agree on this?
> 


