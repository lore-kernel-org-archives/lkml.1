Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXKRUQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXKRUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 15:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXKRUQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 15:16:48 -0500
Received: from neopsis.com ([213.239.204.14]:51590 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752074AbXKRUQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 15:16:48 -0500
Message-ID: <47409DA3.7070909@dbservice.com>
Date: Sun, 18 Nov 2007 21:16:35 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz> <4740692E.7010801@dbservice.com>
In-Reply-To: <4740692E.7010801@dbservice.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.248,
	required 5, autolearn=spam, AWL 0.17, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10, TW_CF 0.08)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since this is becoming more an IDE/ATA issue, I added
linux-ide@vger.kernel.org to CC. I hope that's the right mailinglist.

Tomas Carnecky wrote:
> (3) Once the notebook was in the docking station (whether I boot it
> while in the dock or boot it outside and then put it into the dock) and
> I take it out (press the 'undock' button on the dock, wait for the green
> led, then take out the notebook) things get interesting:
> 
> (a) I initiate STR, notebook correctly goes to sleep, but it only wakes
> up if I have it in the docking station. If I try to wake it up outside
> of the docking station it will fail.

  Magic number: 0:971:888
  hash matches drivers/base/power/main.c:82
  hash matches device ptyuf
  hash matches device 0000:00:1f.1

00:1f.1 IDE interface: Intel Corporation Mobile IDE Controller (rev 03)

> (5) If the notebook is in the dock, I press the undock button and wait
> for the green led then initiate STR, I can take the notebook out but
> resuming doesn't work - unless I resume it while the notebook is back in
> the docking station (see point 3a)

  Magic number: 0:648:888
  hash matches drivers/base/power/main.c:103
  hash matches device ptyuf
  hash matches device 0000:00:1f.1

00:1f.1 IDE interface: Intel Corporation Mobile IDE Controller (rev 03)


I kindof had suspected that. The docking station has an ultrabay slot
where I currently have a cdrom drive (since the notebook itself doesn't
have any cdrom drive. Once I took the cdrom drive out, I was able to
successfully perform what I wanted to do in points 3a and 5!

The 'undock' button probably doesn't tell the kernel that it should
unload the cdrom driver. Even though after pressing the undock button
the drive becomes unusable (the green led that is on the side of the
ultrabay disables and it's impossible to open the tray). Though pressing
the undock button causes the usb ports to be removed from the kernel, at
least that's what dmesg suggests (I put the notebook into the dock,
waited a bit and then pressed the undock button):

usb 1-4: new high speed USB device using ehci_hcd and address 11
usb 1-4: configuration #1 chosen from 1 choice
hub 1-4:1.0: USB hub found
hub 1-4:1.0: 4 ports detected
ACPI: \_SB_.GDCK - docking
ACPI: \_SB_.GDCK - undocking
usb 1-4: USB disconnect, address 11

The notebook+dock+STR works as long as the notebook doesn't know about
the ultrabay device. That can be because the notebook was started
outside of the docking station, or inside the docking station but with
the ultrabay removed. But once the notebook sees the ultrabay device
it's over. As little as one suspend/resume cycle inside the docking
station and with a ultrabay device plugged in is enough to make the
kernel (partially) recognize the device - the kernel doesn't recognize
the device as a cdrom drive, but only as an UDMA/33 device. After one
suspend/resume cycle I see this in dmesg:

ata4.00: ACPI cmd ef/03:45:00:00:00:a0 failed (Emask=0x1 Stat=0x51 Err=0x04)
ata4: failed to recover some devices, retrying in 5 secs
Coming out of suspend...
[... snip ...]
ata4.00: ACPI cmd ef/03:45:00:00:00:a0 failed (Emask=0x1 Stat=0x51 Err=0x04)
ata4.00: ACPI on devcfg failed the second time, disabling (errno=-5)
ata4.00: revalidation failed (errno=1)
ata4: failed to recover some devices, retrying in 5 secs
ata4.00: configured for UDMA/33

And after that I can't resume outside of the docking station. So the
description of point 3 was incomplete, sorry about that.

At least the two failures 3a and 5 can be explained...

tom
