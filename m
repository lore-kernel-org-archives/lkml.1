Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYEaAhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYEaAhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbYEaAh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:37:27 -0400
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:52520 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbYEaAhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:37:24 -0400
X-Greylist: delayed 2099 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 20:37:24 EDT
Message-ID: <48409544.7080807@inf.tu-dresden.de>
Date: Sat, 31 May 2008 02:01:08 +0200
From: =?UTF-8?B?UGFzY2FsIEJyw7xja25lcg==?= 
	<pascal.brueckner@inf.tu-dresden.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tom@dbservic ... wrote:
> Will this patch or the other bay/dock related patches you send in the
> past days allow me to undock my laptop and still be able to
> suspend/resume without locking the laptop up? And without having to 
> run any userspace scripts?

I'm using a ThinkPad X31 with the Ultrabase X3, containing an Ultrabay,
which sends events on removal or undocking thanks to the "dock" and
"bay" modules. Unfortunately, hibernate/suspend to disk doesn't work
with any patch to libata seen here (i'm using the ata_piix module), if
the cd drive in my Ultrabay was removed before suspending.

Ejecting and reinserting during the running system works great, when the
bay module is loaded before ata_piix (via initrd) or with
"libata.noacpi=1" boot parameter. For these tasks i'm using the example
scripts listed on thinkwiki [1] and udev.

For example, removing looks like the following in syslog (on 2.6.24):
  ACPI: \_SB_.PCI0.IDE0.SCND.MSTR: Bay event
  ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
  ata2.00: waking up from sleep
  ata2: soft resetting link
  ata2.00: configured for UDMA/33
  ata2: EH complete
  ata2.00: disabled
  ACPI: \_SB_.PCI0.IDE0.SCND.MSTR: Ejecting device

After this, undocking works by pressing the "undock" button on my Ultrabase:
  ACPI: \_SB_.GDCK - undocking

Reinserting the ThinkPad into the docking station just sends a dock event:
  ACPI: \_SB_.GDCK - docking

So i need to trigger the cd device recognition via udev (and the switch
on the Ultrabay):
  ACPI: \_SB_.PCI0.IDE0.SCND.MSTR: Bay event
  ata2: soft resetting link
  ata2.00: ATAPI: MATSHITADVD-ROM SR-8177, NB21, max UDMA/33
  ata2.00: configured for UDMA/33
  ata2: EH complete
  scsi 1:0:0:0: CD-ROM            MATSHITA DVD-ROM SR-8177  NB21 PQ: 0
ANSI: 5
  sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
  sr 1:0:0:0: Attached scsi CD-ROM sr0
  sr 1:0:0:0: Attached scsi generic sg1 type 5

So ejecting and reinserting of the bay devices and docking/undocking
works, as long as - to come to my problem - i don't try to hibernate.
Hibernating (tried plain echo disk > /sys/power/state, too) just freezes
the entire system without leaving a message anywhere. When using
tuxonice/suspend2, it hangs at "Doing atomic copy".
I discovered a new strange behaviour with recent 2.6.26 kernel and your
attached patch, too: If i remove the Ultrabay device via script, leaving
the device plugged in, it is discovered and spinning up again
automatically on hibernation (which works in this case, because the
device is present).

Seems like the device isn't completely removed in the driver (/dev/*
block device not present and hald not running) and on hibernation
something tries to access the nonexistent device and locks up the
system. I tried stable 2.6.24, 2.6.25 and plain 2.6.26, 2.6.26 from
zen-sources git, 2.6.26 patched with the patches in this thread and in [2].

Hope this helps,
Pascal

[1] http://www.thinkwiki.org/wiki/How_to_hotswap_UltraBay_devices
[2] http://lkml.org/lkml/2008/2/14/123

