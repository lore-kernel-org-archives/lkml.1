Return-Path: <linux-kernel-owner+w=401wt.eu-S932220AbXGVJ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbXGVJ76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbXGVJ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:59:49 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:33450 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbXGVJ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lyTSR3c2CJjXczjmM5SlfvJ4/2IRyyiqleFs9o3gTH+4odv8tgzf1vZOS3TEkjrn3iVsXQSokLMENb4BJSX/6s5XrxuvYVe/N6i14lc5cznNF9js4o9Tnt9QYH/rBvMJHFtIcBrfu/EWt8NRCBYxrwdBamHMoH7LVuj+zNsCg7M=
Message-ID: <19061b0b0707220259h207f27d7wa836b1973c547e63@mail.gmail.com>
Date: Sun, 22 Jul 2007 10:59:46 +0100
From: Bartek <poemann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Pata support for IDE Controller 82801G ICH7 in Linux 2.6.22
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have a laptop Asus A6JM with Intel IDE Controller 82801G ICH7
Family. I wanna give a try a new PATA driver instead the old one
(IDE), so I compiled these modules in the Linux 2.6.22 (CONFIG_IDE is
not set) :
# SCSI device support
CONFIG_SCSI=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

# SCSI support type (disk, tape, CD-ROM)
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SCH=m

# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

# SCSI Transports
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m

# SATA/PATA driver configuration
CONFIG_ATA=m
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=m
CONFIG_ATA_PIIX=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_PCMCIA=m

Then I added to /etc/initramfs-tools/modules these modules:
ata_generic, libata, ata_piix
After installing the new kernel and rebooting, the system stopped
showing a message:
"Waiting for root file system..."
Then, after 2 or 3 minutes initramfs shell appeared. So I checked if
82801G controller is supported, and I found this in
linux/drivers/ata/ata_piix.c
/* 82801GB/GR/GH (ICH7, identical to ICH6) */
{ 0x8086, 0x27c0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich6_sata_ahci },
/* 2801GBM/GHM (ICH7M, identical to ICH6M) */
{ 0x8086, 0x27c4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich6m_sata_ahci },

My question is there a Linux PATA driver for the IDE Controller 82801G
ICH7 Family or is there any plan to support it?

My /etc/fstab looks like:
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
LABEL=ROOT       /               ext3    defaults,errors=remount-ro 0       1
LABEL=BOOT       /boot           ext3    defaults        0       2
LABEL=HOME       /home           ext3
noatime,defaults,errors=remount-ro         0       2
LABEL=SWAP       none            swap    sw              0       0

The fragment of /boot/grub/menu.lst
title           Debian GNU/Linux, kernel 2.6.22
root            (hd0,0)
kernel          /vmlinuz-2.6.22 root=LABEL=ROOT ro vga=792
initrd          /initrd.img-2.6.22
savedefault

Output of lspci -vvv
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1237
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ffa0 [size=16]

Regards
Bartek
