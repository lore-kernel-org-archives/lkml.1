Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYI2SAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYI2SAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYI2SAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:00:25 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:22673 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbYI2SAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:00:24 -0400
From: Frans Pop <elendil@planet.nl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: sdhci: Loads of scary messages during suspend/resume with SD card inserted
Date: Mon, 29 Sep 2008 20:00:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx,
       linux-pm@lists.linux-foundation.org
References: <200809282146.57960.elendil@planet.nl> <20080929113857.GA17379@srcf.ucam.org> <20080929121142.GA18486@srcf.ucam.org>
In-Reply-To: <20080929121142.GA18486@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809292000.19489.elendil@planet.nl>
X-OriginalArrivalTime: 29 Sep 2008 18:00:20.0473 (UTC) FILETIME=[3CD5FE90:01C9225D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2008, Matthew Garrett wrote:
> More to the point, how about this one? It should also handle the resume
> case, but I haven't tested it yet.

Thanks Matthew.

For the second part of the quirk the device name is incorrect. It should
be r5c832 instead of rl5c832 and the DECLAREs also have the wrong device.
I think it would probably be good to add a printk for an info or debug
message saying that the proprietary controller has been disabled.

After fixing that it compiles correctly and does improve things a lot, but
there are still remaining issues. I suspect these are probably unrelated
to the proprietary controller though.

During suspend I now get:
Suspending console(s) (use no_console_suspend to debug)
pci 0000:00:02.0: PCI INT A disabled
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
mmc0: card 8879 removed
MMC: killing requests for dead queue
ACPI handle has no context!
sdhci-pci 0000:02:06.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
iwlagn 0000:10:00.0: PCI INT A disabled
[...]

This means that all those register dumps are gone, but I'm not sure about
the "killing requests for dead queue" message.

During resume I get:
sdhci-pci 0000:02:06.2: restoring config space at offset 0xf (was 0x300, writing 0x30a)
sdhci-pci 0000:02:06.2: restoring config space at offset 0x4 (was 0x0, writing 0xe0102000)
sdhci-pci 0000:02:06.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
sdhci-pci 0000:02:06.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
mmc0: new SD card at address 8879
mmc mmc0:8879: parent mmc0 should not be sleeping
mmcblk0: mmc0:8879 SU02G 1985024KiB
 mmcblk0: p1

The "parent should not be sleeping" message is still there.

All that was still without having a partition mounted. After resume a vfat
partition on the card can be mounted successfully.


I've also tried suspending while a partition on the card (vfat) was
mounted. This gives the same messages during suspend/resume, but reading
from the device after resume fails:
$ ls /mnt/
ls: cannot access /mnt/firmware: Input/output error
firmware
$ ls /mnt/firmware
ls: cannot access /mnt/firmware: Input/output error

(I guess the first command returns "firmware" because that was still
buffered from an 'ls' I did before suspending.)

And in dmesg:
FAT: Filesystem panic (dev mmcblk0p1)
    fat_get_cluster: invalid cluster chain (i_pos 0)
    File system has been set read-only

Only after unmounting the partition *and* ejecting/reinserting the card
is all well again.

Cheers,
FJP
