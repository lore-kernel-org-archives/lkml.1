Return-Path: <linux-kernel-owner+w=401wt.eu-S1751083AbXAXLBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083AbXAXLBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXAXLBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:01:31 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:59895 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbXAXLBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:01:30 -0500
Subject: Re: SATA hotplug from the user side ?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45B6BF5D.1070300@gmail.com>
References: <1168588629.5403.7.camel@localhost>
	 <45A7BFB0.9090308@garzik.org> <1168639639.3707.6.camel@localhost>
	 <45A83C22.6050409@gmail.com> <1168672966.3707.24.camel@localhost>
	 <45AAE52B.2070705@gmail.com> <1169456682.2901.18.camel@localhost>
	 <20070122210312.GD4516@khazad-dum.debian.net> <45B5A9C7.5050700@gmail.com>
	 <20070123131040.GB13467@khazad-dum.debian.net> <45B6BF5D.1070300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Jan 2007 10:09:49 +0100
Message-Id: <1169629789.3779.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 11:07 +0900, Tejun Heo wrote:
> Henrique de Moraes Holschuh wrote:
> > On Tue, 23 Jan 2007, Tejun Heo wrote:
> >> Henrique de Moraes Holschuh wrote:
> >>> Does SATA electrical conector keying let the disk firmware unload
> >>> heads before the user manages to pull it out enough to sever power?
> >> I don't think so.
[...]
> Agreed.

OK, so here comes the next revision, I hope it can be put in the docs/on
the web page now:

SATA Hotplug from the User Side

In general, before unplugging a drive you must stop using it. This means
unmounting all partitions, removing the disk from a potential raid
array / device mapper / crypt setup. Also depending on your disk-bay it
might be a good idea to power down the drive using hdparm -Y followed by
a scsiadd -r.

BIG FAT WARNING: if your SATA bay does not do electrical connector
keying to let the disk firmware unload heads before the user manages to
pull it out the drive will do an emergency head unload, which is not
good and will likely reduce the drive's lifetime.

• For SIL3114 and SIL3124, AHCI and the CK804 flavour of sata_nv you -
in principle - don't have to run any commands at all. It should notice
when you yank the cable, or plug in a new device. All you have to do is
to stop using the devices before unplugging, e.g. unmount partitions on
the disk or remove the disk from a dm setup). However it is recommended
to power down the drive using hdparm -Y followed by a scsiadd -r as
stated above. One can validate which disks are attached using ``scsiadd
-p''. In the following example the disk on scsi host 3 channel 0 id 0
lun 0 will be removed:

# scsiadd -p

Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3400832AS      Rev: 3.01
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3400620AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI SCSI revision: 05

# scsiadd -r 3 0 0 0
 
Note that the device name may change from e.g. /dev/sdd to /dev/sde on a
remove/reinsert cycle (this can be fixed by using udev-provided
persistent names). Also note that it is perfectly normal to see messages
like this in dmesg:

<removing /dev/sdd>

ata4: exception Emask 0x10 SAct 0x0 SErr 0x10000 action 0x2 frozen
ata4: hard resetting port
ata4: SATA link down (SStatus 0 SControl 310)
ata4: failed to recover some devices, retrying in 5 secs
ata4: hard resetting port
ata4: SATA link down (SStatus 0 SControl 310)
ata4: failed to recover some devices, retrying in 5 secs
ata4: hard resetting port
ata4: SATA link down (SStatus 0 SControl 310)
ata4.00: disabled
ata4: EH complete
ata4.00: detaching (SCSI 3:0:0:0)
Synchronizing SCSI cache for disk sdd: 
FAILED
  status = 0, message = 00, host = 4, driver = 00
  <3>ata4: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2 frozen
ata4: hard resetting port
ata4: COMRESET failed (device not ready)
ata4: hardreset failed, retrying in 5 secs
ata4: hard resetting port
ata4: COMRESET failed (device not ready)
ata4: hardreset failed, retrying in 5 secs
ata4: hard resetting port

<reinserting the disk>
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata4.00: ATA-7, max UDMA/133, 1465149168 sectors: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/100
ata4: EH complete
scsi 3:0:0:0: Direct-Access     ATA      ST3750640AS      3.AA PQ: 0
ANSI: 5
SCSI device sde: 1465149168 512-byte hdwr sectors (750156 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: drive cache: write back
SCSI device sde: 1465149168 512-byte hdwr sectors (750156 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: drive cache: write back
 sde: unknown partition table
sd 3:0:0:0: Attached scsi disk sde
sd 3:0:0:0: Attached scsi generic sg3 type 0

However if you happen to see messages like

scsi 3:0:0:0: rejecting I/O to dead device
scsi 4:0:0:0: rejecting I/O to dead device
scsi 5:0:0:0: rejecting I/O to dead device

you did not stop using the devices before unplugging (check that you
unmounted all partitions, removed the disk from a raid array, dmsetup,
cryptsetup).  If you have no pending IO to the device, there won't be
'rejects IO to dead device' messages.

• For other chipsets one in addition might have to run scsiadd -s on
reinserting the disk.
• Note that it might not be such a good idea to do the above on drivers
which don't implement the new EH yet. Those are as of January 2007:
sata_nv, sata_promise (getting there) and sata_sx4.

Soeren (beeing stuck in a train which again seems to be stuck in a lot
of snow somewhere in southern germany...)
-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
