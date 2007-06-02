Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbXFBWzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbXFBWzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763949AbXFBWzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:55:09 -0400
Received: from hera.cwi.nl ([192.16.191.8]:63170 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763917AbXFBWzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:55:07 -0400
Date: Sun, 3 Jun 2007 00:54:54 +0200
From: Andries Brouwer <Andries.Brouwer@cwi.nl>
To: Jonathan Schleifer <js@h3c.de>
Cc: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ignore partition table on device
Message-ID: <20070602225454.GA24367@apps.cwi.nl>
References: <20070602205513.0312ebe0@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602205513.0312ebe0@localhost>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 08:55:13PM +0200, Jonathan Schleifer wrote:

> This patch adds a new kernel parameter (ignore_partitions=device) to
> the kernel. It is useful when using a fake RAID with dmraid so that
> Linux won't complain about attemps to access the drive beyond its
> boundaries when udev and/or hald are started.
> 
> +static char * __initdata ignore_dev;

> +	if (ignore_dev != NULL && !strcmp(state->name, ignore_dev)) {

I agree that the current behaviour of touching all devices seen
at boot time is rather undesirable. It adds twenty seconds to the
boot time of my machine, where Linux tries to read nonexisting media
in the on-board usb storage devices, starting error-recovery when that
fails, etc. (These days it also seems that even when no errors occur
everything is done twice - maybe a libata bug, I have not looked,
attached a dmesg fragment.) And the unasked-for guessing has caused
a thin trickle of problems for over ten years.

But this patch is not really an improvement.
It allows you to tell about a single device that the kernel should
not try to find a partition table there, because even if it finds
something that resembles a partition table, it would be mistaken.
The general case is that one wants to say the same thing about
several devices - if you ask me, about all devices, except possibly
for an explicitly specified boot device.

It should be userspace that directs the kernel to probe a device.
It should be udev or some such program that tells the kernel to
look for a partition table on a newly found device. Perhaps even
for a partition table of known type. Or maybe userspace does the
looking itself, using partx or so - sometimes userspace knows better
what to expect.

Maybe there already is such an option in the vanilla kernel,
but if there isnt't it should be added: noautoreadpt.

Andries

"done twice":
[   26.505536] SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
[   26.505584] sda: Write Protect is off
[   26.505616] sda: Mode Sense: 00 3a 00 00
[   26.505630] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.505713] SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
[   26.505755] sda: Write Protect is off
[   26.505787] sda: Mode Sense: 00 3a 00 00
[   26.505801] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.505844]  sda: sda1 sda2 < sda5 >
[   26.535025] sd 0:0:0:0: Attached scsi disk sda

"done twice":
[   25.839447] scsi6 : SCSI emulation for USB Mass Storage devices
[   30.844107] sd 6:0:0:0: Attached scsi removable disk sdb
[   42.519502] sdb : READ CAPACITY failed.
[   42.770997] scsi7 : SCSI emulation for USB Mass Storage devices
[   48.024083] sd 7:0:0:0: Attached scsi removable disk sdb
[   49.326683] sdb : READ CAPACITY failed.
[   49.331174] scsi 7:0:0:0: rejecting I/O to dead device

There is nothing wrong with sdb (and sdc, sdd, sde).
They are just USB card readers without media.

This is an Ubuntu 2.6.20 kernel.
