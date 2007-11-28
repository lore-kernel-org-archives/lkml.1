Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbXK1RmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbXK1RmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbXK1RmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:42:00 -0500
Received: from mxintern.schlund.de ([212.227.126.205]:64818 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbXK1Rl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:41:58 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2007 12:41:58 EST
Date: Wed, 28 Nov 2007 18:21:32 +0100
From: Anders Henke <anders.henke@1und1.de>
To: linux-kernel@vger.kernel.org
Subject: broken dpt_i2o (was: ext2_check_page: bad entry in directory)
Message-ID: <20071128172132.GA30202@schlund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: 1&1 Internet AG
User-Agent: Mutt/1.5.13 (2006-08-11)
X-UI-Msg-Verification: fd341ea385740a610583962ada388a5e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been bitten by the problem noted in the lkml message of rougly the same
subject, dated back on Oct/24/2007. 
My boxes were running 2.6.19 and have been upgraded to 2.6.23.1, but their
bootup failed when trying to mount the root (ext2) filesystem:

---cut
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
ACPI: PCI Interrupt 0000:04:08.0[A] -> GSI 48 (level, low) -> IRQ 16
Adaptec I2O RAID controller 0 irq=16
     BAR0 f8880000 - size= 100000
     BAR1 f8a00000 - size= 1000000
dpti: If you have a lot of devices this could take a few minutes.
dpti0: Reading the hardware resource table.
TID 008  Vendor: ADAPTEC      Device: AIC-7902     Rev: 00000001    
TID 009  Vendor: ADAPTEC      Device: AIC-7902     Rev: 00000001    
TID 515  Vendor: ESG-SHV S    Device: SCA HSBP M21 Rev: 0.080       
TID 518  Vendor: ADAPTEC R    Device: RAID-1       Rev: 3B0AD       
scsi0 : Vendor: Adaptec  Model: 2010S            FW:3B0A
scsi 0:1:0:0: Direct-Access     ADAPTEC  RAID-1           3B0A PQ: 0
ANSI: 2
scsi 0:1:6:0: Processor         ESG-SHV  SCA HSBP M21     0.08 PQ: 0
ANSI: 2
Adaptec aacraid driver 1.1-5[2449]-ms
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
sd 0:1:0:0: [sda] 143374336 512-byte hardware sectors (73408 MB)
sd 0:1:0:0: [sda] Write Protect is off
sd 0:1:0:0: [sda] Write cache: enabled, read cache: enabled, supports
DPO and FUA
sd 0:1:0:0: [sda] 143374336 512-byte hardware sectors (73408 MB)
sd 0:1:0:0: [sda] Write Protect is off
sd 0:1:0:0: [sda] Write cache: enabled, read cache: enabled, supports
DPO and FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:1:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please
boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
md: raid1 personality registered for level 1
EDAC MC: Ver: 2.1.0 Oct 23 2007
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI Shortcut mode
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 264k freed
EXT2-fs error (device sda1): ext2_check_page: bad entry in directory #2:
rec_len is smaller than minimal - offset=0, inode=0, rec_len=0,
name_len=0
Warning: unable to open an initial console.
Kernel panic - not syncing: No init found.  Try passing init= option to
kernel.
Rebooting in 30 seconds..
---cut

Rebooting the box into 2.6.19 works without any problems.

I've checked the changelogs for 2.6.24-rc*, but haven't come across a
solution for this issue; but maybe I've also overseen the point.

http://lkml.org/lkml/2007/10/24/224, this bug has been reported earlier.

I've contacted Jan Kara off-list; as booting into 2.6.19 works and e2fsck 
on an e2image file doesn't show any errors, we assumed that the Ext2 itself
is fine.

As "everything is reported as being zero" is quite odd an Jan took a
guess that it might be block-layer or driver-related, I've assumed
that the driver is responsible for this; just out of the curiousity, 
I've manually replaced the dpt_i2o driver by the 2.6.19 one by copying 
driver/scsi/dpt_i2o.c driver/scsi/dpti.h and driver/scsi/dpt/ into a 
vanilla 2.6.23.1. kernel; using this kernel fixed the issue for me.

I haven't yet fine-tested from which kernel release on the dpt_i2o driver 
behaves like this and spews out zeroed blocks when trying to mount
the rootfs. Maybe this is just some timing issue.


For some strange reason, this doesn't affect all boxes running the
dpt_i2o driver.

Affected (verified on 6 out of 6 tested boxes so far):

Intel SE7501WV2S using an Adaptec 2010S with the following "lspci -vn"-section:

0000:04:08.0 0104: 1044:a511 (rev 01)
        Subsystem: 1044:c035
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
        BIST result: 00
        Memory at fe900000 (32-bit, non-prefetchable) [size=1M]
        Memory at fb000000 (32-bit, prefetchable) [size=16M]
        Memory at f8000000 (32-bit, prefetchable) [size=32M]
        Expansion ROM at f6200000 [disabled] [size=32K]
        Capabilities: [44] Power Management version 2

Not affected are e.g. a box with a Supermicro X5DPR using an Adaptec 2015S
and the following "lspci -vn"-section:

0000:03:03.0 0104: 1044:a511 (rev 01)
        Subsystem: 1044:c034
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
        BIST result: 00
        Memory at f8300000 (32-bit, non-prefetchable) [size=1M]
        Memory at fb000000 (32-bit, prefetchable) [size=16M]
        Memory at fc000000 (32-bit, prefetchable) [size=32M]
        Capabilities: [44] Power Management version 2

... and of course boxes not using an dpt_i2o-driven Controller.

The Adaptec 2010S-boxes are currently running the Adaptec firmware 3B05,
while the Adaptec 2015S box is running firmware 3B0A. As those
controllers are capable of running the same firmware image, maybe
a firmware update might resolve this issue as well (well, unlikely
according to the changelog); the above bootup log is from an updated
box, so the firmware update didn't help. What really helps is the older
driver.




Anders
-- 
1&1 Internet AG              System Design
Brauerstrasse 48             v://49.721.91374.50
D-76135 Karlsruhe            f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren
