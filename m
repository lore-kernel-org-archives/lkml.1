Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZLSTyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZLSTyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 14:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZLSTyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 14:54:17 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52019 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbZLSTyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 14:54:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=L5zSnmsqELRWr9Ny5Bd5LiKCiRgz1B1nbw9i1l96ZBlbnd1wbewgeydFrwSFOoN5dP
         AJAqxtGebVd0YaLqrWBs35o47oiAcBZx5yX2Y6sDZTvkaUiaor+sUEBY0fQAnTZcHkvR
         efYjHTeRvr02XaSg5M3fFijYji1ej5Awtv5TE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912171745160.15740@localhost.localdomain>
References: <alpine.LFD.2.00.0912171745160.15740@localhost.localdomain>
Date: Sat, 19 Dec 2009 20:54:13 +0100
Message-ID: <64bb37e0912191154n4a7ea5benbb3da57f1aabdbe6@mail.gmail.com>
Subject: Re: Linux 2.6.33-rc1
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Vroon <tony@linx.net>, Robert Hancock <hancockrwd@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       Vivek Mahajan <vivek.mahajan@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 3:05 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Please give it a good testing, so that we can start figuring out the
> inevitably regressions,

2.6.33 works for me with the default settings, but if I try to active
MSI for my sata ports, writes to my hard disks start to fail.

MSI support was added to sata_sil24 for 2.6.33 with commit
dae77214fa71898b84514e43721fb7bf260b026a .
MSI support for sata_nv is older (commit
51c8949950647afeeb897e08dd75ad99078adb50 ), but today I retried it an
it also fails.

Both default to off, but can be easily actived with sata_sil24.msi=1 /
sata_nv.msi=1.

My system itself should support MSI, as my network cards (2x tg3) and
video card (X300 radeon) do work correctly with MSI enabled.

Differences from the dmesg for sata_sil24:
normal boot:
[    2.516332] sata_sil24 0000:04:00.0: PCI INT A -> Link[LNEB] -> GSI
19 (level, low) -> IRQ 19
[    2.525167] scsi0 : sata_sil24
[    2.528372] scsi1 : sata_sil24
[    2.531548] ata1: SATA max UDMA/100 host m128@0xefeffc00 port
0xefef8000 irq 19
[    2.538880] ata2: SATA max UDMA/100 host m128@0xefeffc00 port
0xefefa000 irq 19

with sata_sil24.msi=1:
[    3.326435] sata_sil24 0000:04:00.0: version 1.1
[    3.331111] sata_sil24 0000:04:00.0: PCI INT A -> Link[LNEB] -> GSI
19 (level, low) -> IRQ 19
[    3.339742]   alloc irq_desc for 29 on node 0
[    3.341086]   alloc kstat_irqs on node 0
[    3.348104] sata_sil24 0000:04:00.0: irq 29 for MSI/MSI-X
[    3.353544] sata_sil24 0000:04:00.0: Using MSI
[    3.358004] sata_sil24 0000:04:00.0: setting latency timer to 64
[    3.364281] scsi0 : sata_sil24
[    3.367512] scsi1 : sata_sil24
[    3.370686] ata1: SATA max UDMA/100 host m128@0xefeffc00 port
0xefef8000 irq 29
[    3.378017] ata2: SATA max UDMA/100 host m128@0xefeffc00 port
0xefefa000 irq 29
The system starts to boot, but early in the userspace boot sequence
(probably after the first write accesses) access to the disks fails:
[   56.039444] Loglevel set to 6
[   73.082542] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[   73.093594] ata2.00: failed command: READ FPDMA QUEUED
[   73.102649] ata2.00: cmd 60/10:00:aa:93:89/00:00:26:00:00/40 tag 0
ncq 8192 in
[   73.102653]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   73.120050] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[   73.120061] ata1.00: failed command: READ FPDMA QUEUED
[   73.120074] ata1.00: cmd 60/00:00:02:69:b4/01:00:26:00:00/40 tag 0
ncq 131072 in
[   73.120077]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   73.120083] ata1.00: status: { DRDY }
[   73.120100] ata1: controller in dubious state, performing PORT_RST
[   73.186584] ata2.00: status: { DRDY }
[   73.194452] ata2: controller in dubious state, performing PORT_RST
[   80.380057] ata1.00: qc timeout (cmd 0xec)
[   80.460046] ata2.00: qc timeout (cmd 0xec)
[   80.483769] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   80.494237] ata1.00: revalidation failed (errno=-5)
[   80.503388] ata1: controller in dubious state, performing PORT_RST
[   80.560026] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   80.570329] ata2.00: revalidation failed (errno=-5)
[   80.579274] ata2: controller in dubious state, performing PORT_RST
[   92.770064] ata1.00: qc timeout (cmd 0xec)
[   92.840039] ata2.00: qc timeout (cmd 0xec)
[   92.870025] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   92.880293] ata1.00: revalidation failed (errno=-5)
[   92.889332] ata1: limiting SATA link speed to 1.5 Gbps
[   92.898630] ata1: controller in dubious state, performing PORT_RST
[   92.940040] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   92.950384] ata2.00: revalidation failed (errno=-5)
[   92.959454] ata2: limiting SATA link speed to 1.5 Gbps
[   92.968820] ata2: controller in dubious state, performing PORT_RST
[  125.160111] ata1.00: qc timeout (cmd 0xec)
[  125.230039] ata2.00: qc timeout (cmd 0xec)
[  125.260025] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  125.270227] ata1.00: revalidation failed (errno=-5)
[  125.279118] ata1.00: disabled
[  125.286045] ata1: controller in dubious state, performing PORT_RST
[  125.330034] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  125.340221] ata2.00: revalidation failed (errno=-5)
[  125.349170] ata2.00: disabled
[  125.356174] ata2: controller in dubious state, performing PORT_RST
[  127.550078] ata1.00: device reported invalid CHS sector 0
[  127.559741] end_request: I/O error, dev sda, sector 649357570
[  127.569739] raid1: sda3: rescheduling sector 609355720
[  127.579052] raid1: sda3: rescheduling sector 609355968
[  127.588396] end_request: I/O error, dev sda, sector 20000711
[  127.598257] end_request: I/O error, dev sda, sector 20000711
[  127.608052] md: super_written gets error=-5, uptodate=0
[  127.608244] raid1: Disk failure on sda1, disabling device.
[  127.608244] raid1: Operation continuing on 1 devices.
[  127.620054] ata2.00: device reported invalid CHS sector 0
[  127.620123] end_request: I/O error, dev sdb, sector 646550442
[  127.620131] raid1: sdb3: rescheduling sector 606548592
[  127.620184] end_request: I/O error, dev sdb, sector 20000711
[  127.620194] end_request: I/O error, dev sdb, sector 20000711
[  127.620200] md: super_written gets error=-5, uptodate=0
[  127.620244] end_request: I/O error, dev sdb, sector 1250258514
[  127.620253] end_request: I/O error, dev sdb, sector 1250258514
[  127.620260] md: super_written gets error=-5, uptodate=0
[  127.620265] raid1: Disk failure on sdb3, disabling device.
[  127.620267] raid1: Operation continuing on 1 devices.
[  127.620302] end_request: I/O error, dev sdb, sector 1250258530
[  127.620312] end_request: I/O error, dev sdb, sector 1250258530
(snip)
[  128.226010] end_request: I/O error, dev sda, sector 343164306
[  128.234891] end_request: I/O error, dev sda, sector 645188325
[  128.243714] Device dm-0, XFS metadata write error block 0x12090018 in dm-0
[  128.253779] I/O error in filesystem ("dm-0") meta-data dev dm-0
block 0x241261a3
   ("xlog_iodone") error 5 buf count 31232
[  128.268481] xfs_force_shutdown(dm-0,0x2) called from line 968 of
file fs/xfs/xfs_log
.c.  Return address = 0xffffffff811978fe
[  128.283555] Filesystem "dm-0": Log I/O Error Detected.  Shutting
down filesystem: dm
-0
[  128.294999] Please umount the filesystem, and rectify the problem(s)
[  128.305410] end_request: I/O error, dev sda, sector 344029066

After the shutdown of the root fs, the system can't even load agetty
and the only thing left is to reboot via SysRq.

Differences from the dmesg for sata_nv:
normal boot:
[    3.385490] sata_nv 0000:00:05.0: version 3.5
[    3.390199] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    3.395967]   alloc irq_desc for 23 on node 0
[    3.400003]   alloc kstat_irqs on node 0
[    3.404318] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23
(level, low) -> IRQ 23
[    3.412632] sata_nv 0000:00:05.0: Using SWNCQ mode
[    3.417471] sata_nv 0000:00:05.0: setting latency timer to 64
[    3.423387] scsi2 : sata_nv
[    3.426378] scsi3 : sata_nv
[    3.429399] ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 23
[    3.436579] ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 23
[    3.444055] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    3.449822]   alloc irq_desc for 22 on node 0
[    3.453752]   alloc kstat_irqs on node 0
[    3.458175] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22
(level, low) -> IRQ 22
[    3.466487] sata_nv 0000:00:05.1: Using SWNCQ mode
[    3.471341] sata_nv 0000:00:05.1: setting latency timer to 64
[    3.477223] scsi4 : sata_nv
[    3.480191] scsi5 : sata_nv
[    3.483198] ata5: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xb800 irq 22
[    3.491455] ata6: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb808 irq 22
[    3.500021] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 21
[    3.506897]   alloc irq_desc for 21 on node 0
[    3.511264]   alloc kstat_irqs on node 0
[    3.517542] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21
(level, low) -> IRQ 21
[    3.527049] sata_nv 0000:00:05.2: Using SWNCQ mode
[    3.533128] sata_nv 0000:00:05.2: setting latency timer to 64
[    3.540261] scsi6 : sata_nv
[    3.544479] scsi7 : sata_nv
[    3.548753] ata7: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xac00 irq 21
[    3.557238] ata8: SATA max UDMA/133 cmd 0xb080 ctl 0xb000 bmdma 0xac08 irq 21

with sata_nv.msi=1:
[    3.357305] sata_nv 0000:00:05.0: version 3.5
[    3.361994] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    3.367762]   alloc irq_desc for 23 on node 0
[    3.371694]   alloc kstat_irqs on node 0
[    3.376116] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23
(level, low) -> IRQ 23
[    3.384430] sata_nv 0000:00:05.0: Using SWNCQ mode
[    3.389273] sata_nv 0000:00:05.0: Using MSI
[    3.393502]   alloc irq_desc for 29 on node 0
[    3.397875]   alloc kstat_irqs on node 0
[    3.401836] sata_nv 0000:00:05.0: irq 29 for MSI/MSI-X
[    3.406992] sata_nv 0000:00:05.0: setting latency timer to 64
[    3.412898] scsi2 : sata_nv
[    3.415886] scsi3 : sata_nv
[    3.418908] ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 29
[    3.426089] ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 29
[    3.433551] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    3.439315]   alloc irq_desc for 22 on node 0
[    3.443263]   alloc kstat_irqs on node 0
[    3.447667] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22
(level, low) -> IRQ 22
[    3.455982] sata_nv 0000:00:05.1: Using SWNCQ mode
[    3.460835] sata_nv 0000:00:05.1: Using MSI
[    3.465039]   alloc irq_desc for 30 on node 0
[    3.469408]   alloc kstat_irqs on node 0
[    3.473379] sata_nv 0000:00:05.1: irq 30 for MSI/MSI-X
[    3.479572] sata_nv 0000:00:05.1: setting latency timer to 64
[    3.486532] scsi4 : sata_nv
[    3.490563] scsi5 : sata_nv
[    3.494639] ata5: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xb800 irq 30
[    3.502921] ata6: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb808 irq 30
[    3.511524] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 21
[    3.518447]   alloc irq_desc for 21 on node 0
[    3.521260]   alloc kstat_irqs on node 0
[    3.529194] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21
(level, low) -> IRQ 21
[    3.538748] sata_nv 0000:00:05.2: Using SWNCQ mode
[    3.544870] sata_nv 0000:00:05.2: Using MSI
[    3.550367]   alloc irq_desc for 31 on node 0
[    3.556036]   alloc kstat_irqs on node 0
[    3.561318] sata_nv 0000:00:05.2: irq 31 for MSI/MSI-X
[    3.567808] sata_nv 0000:00:05.2: setting latency timer to 64
[    3.575070] scsi6 : sata_nv
[    3.579396] scsi7 : sata_nv
[    3.583808] ata7: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xac00 irq 31
[    3.592405] ata8: SATA max UDMA/133 cmd 0xb080 ctl 0xb000 bmdma 0xac08 irq 31

When I start to write to the disk attached to the first port (ata3)
the following happens:
[  437.011295] ata3: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
[  437.022710] ata3: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
[  437.022714]   dhfis 0x1 dmafis 0x0 sdbfis 0x0
[  437.044529] ata3: ATA_REG 0x40 ERR_REG 0x0
[  437.044534] ata3: tag : dhfis dmafis sdbfis sacitve
[  437.044540] ata3: tag 0x0: 1 0 0 1
[  437.044557] ata3.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[  437.044566] ata3.00: failed command: WRITE FPDMA QUEUED
[  437.044578] ata3.00: cmd 61/d8:00:17:6d:39/01:00:00:00:00/40 tag 0
ncq 241664 out
[  437.044582]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[  437.044587] ata3.00: status: { DRDY }
[  469.040046] ata3: EH in SWNCQ mode,QC:qc_active 0x3E sactive 0x3E
[  469.050969] ata3: SWNCQ:qc_active 0x6 defer_bits 0x38 last_issue_tag 0x2
[  469.050973]   dhfis 0x2 dmafis 0x0 sdbfis 0x0
[  469.071578] ata3: ATA_REG 0x40 ERR_REG 0x0
[  469.071582] ata3: tag : dhfis dmafis sdbfis sacitve
[  469.071587] ata3: tag 0x1: 1 0 0 1
[  469.071592] ata3: tag 0x2: 0 0 0 1
[  469.071609] ata3.00: exception Emask 0x0 SAct 0x3e SErr 0x0 action 0x6 frozen
[  469.071617] ata3.00: failed command: WRITE FPDMA QUEUED
[  469.071629] ata3.00: cmd 61/18:08:07:10:39/00:00:00:00:00/40 tag 1
ncq 12288 out
[  469.071633]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  469.071638] ata3.00: status: { DRDY }
[  469.071643] ata3.00: failed command: WRITE FPDMA QUEUED
[  469.071652] ata3.00: cmd 61/20:10:d7:13:39/00:00:00:00:00/40 tag 2
ncq 16384 out
[  469.071656]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  469.071661] ata3.00: status: { DRDY }
[  469.071665] ata3.00: failed command: WRITE FPDMA QUEUED
[  469.071675] ata3.00: cmd 61/20:18:c7:1f:39/00:00:00:00:00/40 tag 3
ncq 16384 out
[  469.071678]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  469.071683] ata3.00: status: { DRDY }
[  469.071687] ata3.00: failed command: WRITE FPDMA QUEUED
[  469.071697] ata3.00: cmd 61/30:20:0f:3b:39/00:00:00:00:00/40 tag 4
ncq 24576 out
[  469.071701]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  469.071705] ata3.00: status: { DRDY }
[  469.071710] ata3.00: failed command: WRITE FPDMA QUEUED
[  469.071720] ata3.00: cmd 61/58:28:8f:3a:3d/02:00:00:00:00/40 tag 5
ncq 307200 out
[  469.071723]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  469.071728] ata3.00: status: { DRDY }
[  469.811913] ata3.00: device reported invalid CHS sector 0
[  469.822053] ata3.00: device reported invalid CHS sector 0
[  469.832066] ata3.00: device reported invalid CHS sector 0
[  469.832072] ata3.00: device reported invalid CHS sector 0
[  469.832092] ata3.00: device reported invalid CHS sector 0
[  500.040052] ata3: EH in SWNCQ mode,QC:qc_active 0x1F sactive 0x1F
[  500.050748] ata3: SWNCQ:qc_active 0x3 defer_bits 0x1C last_issue_tag 0x1
[  500.050752]   dhfis 0x1 dmafis 0x0 sdbfis 0x0
[  500.070826] ata3: ATA_REG 0x40 ERR_REG 0x0
[  500.070830] ata3: tag : dhfis dmafis sdbfis sacitve
[  500.070835] ata3: tag 0x0: 1 0 0 1
[  500.070839] ata3: tag 0x1: 0 0 0 1
[  500.070851] ata3.00: NCQ disabled due to excessive errors
[  500.070857] ata3.00: exception Emask 0x0 SAct 0x1f SErr 0x0 action 0x6 frozen
[  500.070864] ata3.00: failed command: WRITE FPDMA QUEUED
[  500.070875] ata3.00: cmd 61/58:00:8f:3a:3d/02:00:00:00:00/40 tag 0
ncq 307200 out
[  500.070879]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[  500.070884] ata3.00: status: { DRDY }
[  500.070889] ata3.00: failed command: WRITE FPDMA QUEUED
[  500.070899] ata3.00: cmd 61/30:08:0f:3b:39/00:00:00:00:00/40 tag 1
ncq 24576 out
[  500.070902]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  500.070907] ata3.00: status: { DRDY }
[  500.070911] ata3.00: failed command: WRITE FPDMA QUEUED
[  500.070921] ata3.00: cmd 61/20:10:c7:1f:39/00:00:00:00:00/40 tag 2
ncq 16384 out
[  500.070924]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  500.070929] ata3.00: status: { DRDY }
[  500.070934] ata3.00: failed command: WRITE FPDMA QUEUED
[  500.070943] ata3.00: cmd 61/20:18:d7:13:39/00:00:00:00:00/40 tag 3
ncq 16384 out
[  500.070947]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  500.070952] ata3.00: status: { DRDY }
[  500.070956] ata3.00: failed command: WRITE FPDMA QUEUED
[  500.070966] ata3.00: cmd 61/18:20:07:10:39/00:00:00:00:00/40 tag 4
ncq 12288 out
[  500.070969]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  500.070974] ata3.00: status: { DRDY }
[  500.708720] ata3.00: device reported invalid CHS sector 0
[  500.718685] ata3.00: device reported invalid CHS sector 0
[  500.728469] ata3.00: device reported invalid CHS sector 0
[  500.728474] ata3.00: device reported invalid CHS sector 0

With sata_nv.msi=1 the output of /proc/interrupts is:
           CPU0       CPU1       CPU2       CPU3
  0:         37          0          0          4   IO-APIC-edge      timer
  1:          0         84          0       1823   IO-APIC-edge      i8042
  4:          0          0         58        185   IO-APIC-edge      serial
  7:          1          0          0          0   IO-APIC-edge
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          0          0          0          4   IO-APIC-edge      i8042
 14:          0          0          0          0   IO-APIC-edge      pata_amd
 15:          0          0          0          0   IO-APIC-edge      pata_amd
 16:          0          0          0          3   IO-APIC-fasteoi   ohci1394
 19:       4171          2          1       4644   IO-APIC-fasteoi
sata_sil24, bttv0, Bt87x audio
 20:          0          0          0          2   IO-APIC-fasteoi
ehci_hcd:usb1
 23:          0          0        133        209   IO-APIC-fasteoi
ohci_hcd:usb2
 28:       1720          0         12       1473   PCI-MSI-edge      radeon
 29:       1645          0          3        248   PCI-MSI-edge      sata_nv
 30:          0          0          0          0   PCI-MSI-edge      sata_nv
 31:          0          0          0          0   PCI-MSI-edge      sata_nv
 32:          0          0          0        137   PCI-MSI-edge      HDA Intel
 33:          0          0          0          3   PCI-MSI-edge      eth0
 34:          5          0          1         37   PCI-MSI-edge      eth1
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      10578       8061       8095      11323   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance
monitoring interrupts
PND:          0          0          0          0   Performance pending work
RES:       5943       5782       7845       5965   Rescheduling interrupts
CAL:       2047         40        227         36   Function call interrupts
TLB:        227       1173        203       1035   TLB shootdowns
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          2          2          2          2   Machine check polls
ERR:          1
MIS:          0

Normal,working config, without any MSI commandline options:
           CPU0       CPU1       CPU2       CPU3
  0:         36          0          0         14   IO-APIC-edge      timer
  1:          0          0          4       9318   IO-APIC-edge      i8042
  4:          0          0        825        183   IO-APIC-edge      serial
  7:          1          0          0          0   IO-APIC-edge
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          0          0          0          4   IO-APIC-edge      i8042
 14:          0          0          0          0   IO-APIC-edge      pata_amd
 15:          0          0          0          0   IO-APIC-edge      pata_amd
 16:          0          0          0          3   IO-APIC-fasteoi   ohci1394
 19:      47808          4          2       4508   IO-APIC-fasteoi
sata_sil24, bttv0, Bt87x audio
 20:          0          0          1          1   IO-APIC-fasteoi
ehci_hcd:usb1
 21:          0          0          0          0   IO-APIC-fasteoi   sata_nv
 22:          0          0          0          0   IO-APIC-fasteoi   sata_nv
 23:        282      19539          2        267   IO-APIC-fasteoi
sata_nv, ohci_hcd:usb2
 28:      70439          0         10       1250   PCI-MSI-edge      radeon
 29:          1        700          0        140   PCI-MSI-edge      HDA Intel
 30:          0          0          0          3   PCI-MSI-edge      eth0
 31:      97810          0          0         37   PCI-MSI-edge      eth1
NMI:          0          0          0          0   Non-maskable interrupts
LOC:     127366     116789      99269      60557   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance
monitoring interrupts
PND:          0          0          0          0   Performance pending work
RES:     234954     290789      54777      55492   Rescheduling interrupts
CAL:       8085      36613      56971      38870   Function call interrupts
TLB:        659       1395       1054       1785   TLB shootdowns
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          8          8          8          8   Machine check polls
ERR:          1
MIS:          0

Hardware I'm using:
2x 2218 Opterons with a NVidia MCP55 chipset, the Sil24-Chip is part
of the mainboard.

-[0000:00]-+-00.0  nVidia Corporation MCP55 Memory Controller
           +-01.0  nVidia Corporation MCP55 LPC Bridge
           +-01.1  nVidia Corporation MCP55 SMBus
           +-02.0  nVidia Corporation MCP55 USB Controller
           +-02.1  nVidia Corporation MCP55 USB Controller
           +-04.0  nVidia Corporation MCP55 IDE
           +-05.0  nVidia Corporation MCP55 SATA Controller
           +-05.1  nVidia Corporation MCP55 SATA Controller
           +-05.2  nVidia Corporation MCP55 SATA Controller
           +-06.0-[05]--+-06.0  Brooktree Corporation Bt878 Video Capture
           |            +-06.1  Brooktree Corporation Bt878 Audio Capture
           |            \-08.0  Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link)
           +-06.1  nVidia Corporation MCP55 High Definition Audio
           +-0b.0-[04]----00.0  Silicon Image, Inc. SiI 3132 Serial
ATA Raid II Controller
           +-0c.0-[03]----00.0  Broadcom Corporation NetXtreme BCM5754
Gigabit Ethernet PCI Express
           +-0d.0-[02]----00.0  Broadcom Corporation NetXtreme BCM5754
Gigabit Ethernet PCI Express
           +-0f.0-[01]--+-00.0  ATI Technologies Inc RV370 5B60
[Radeon X300 (PCIE)]
           |            \-00.1  ATI Technologies Inc RV370 [Radeon X300SE]
           +-18.0  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Address Map
           +-18.2  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
DRAM Controller
           +-18.3  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
           +-19.0  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
           +-19.1  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Address Map
           +-19.2  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
DRAM Controller
           \-19.3  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control


Also strange:
[    1.630081] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.635605] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.641162] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.646691] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.652247] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.657781] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.663348] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.668889] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.674458] pci 0000:00:00.0: Found enabled HT MSI Mapping

and:
[    5.061998] EDAC MC: Ver: 2.1.0 Dec 18 2009
[    5.062186] EDAC amd64_edac:  Ver: 3.3.0 Dec 18 2009
[    5.062235] EDAC amd64: ECC is enabled by BIOS.
[    5.062297] EDAC amd64: ECC is enabled by BIOS.
[    5.128332] EDAC MC: Rev F or later detected
[    5.134186] EDAC amd64: amd64_read_mc_registers: error reading F2x190.
[    5.142290] EDAC amd64: amd64_read_mc_registers: error reading F2x194.
[    5.150355] EDAC MC: DCT0 chip selects:
[    5.150357] EDAC MC:  0:   512MB 1:   512MB
[    5.150358] EDAC MC:  2:     0MB 3:     0MB
[    5.150361] EDAC MC:  4:     0MB 5:     0MB
[    5.150362] EDAC MC:  6:     0MB 7:     0MB
[    5.150519] EDAC MC0: Giving out device to 'amd64_edac' 'RevF': DEV
0000:00:18.2
[    5.150522] EDAC MC: Rev F or later detected
[    5.150530] EDAC amd64: amd64_read_mc_registers: error reading F2x190.
[    5.150532] EDAC amd64: amd64_read_mc_registers: error reading F2x194.
[    5.150533] EDAC MC: DCT0 chip selects:
[    5.150535] EDAC MC:  0:   512MB 1:   512MB
[    5.150536] EDAC MC:  2:     0MB 3:     0MB
[    5.150537] EDAC MC:  4:     0MB 5:     0MB
[    5.150539] EDAC MC:  6:     0MB 7:     0MB
[    5.150664] EDAC MC1: Giving out device to 'amd64_edac' 'RevF': DEV
0000:00:19.2
[    5.150742] EDAC PCI0: Giving out device to module 'amd64_edac'
controller 'EDAC PCI
 controller': DEV '0000:00:18.2' (POLLED)

The system has 4x 1GB RAM sticks (2 on each CPU).
And there is no line like 'EDAC PCI0' for the DRAM controller of the
second CPU (19.2). Is that normal?

Torsten
