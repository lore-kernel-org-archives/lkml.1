Return-Path: <linux-kernel-owner+w=401wt.eu-S1030721AbXEAMRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721AbXEAMRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031181AbXEAMRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:17:09 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:23795 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030721AbXEAMRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:17:07 -0400
Date: Tue, 1 May 2007 08:17:03 -0400
From: William Thompson <wt@electro-mechanical.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: 2.6.20 libata cdrom
Message-ID: <20070501121703.GH5942@electro-mechanical.com>
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4636C2C7.8090206@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 06:32:07AM +0200, Tejun Heo wrote:
> [cc'ing linux-ide and Albert, Hi!]

And be sure to keep me in CC, I'm not on any of these lists.

> William Thompson wrote:
> > On Mon, Apr 30, 2007 at 12:22:21PM +0200, Tejun Heo wrote:
> >> William Thompson wrote:
> >>> I've been playing with libata on a few machines and I found that this machine
> >>> (An old Dell Dimension L866r) gives me this when it loads and does not give me
> >>> access to the cdrom.  This is the only machine that I've tested that I know
> >>> for a fact cannot do DMA on the cdrom.  I searched and noticed a similar
> >>> problem with 2.6.19-rc versions but I'm not sure if it's the same problem.
> >>>
> >>> dmesg output:
> >>> libata version 2.00 loaded.
> >>> ata_piix 0000:00:1f.1: version 2.00ac7
> >>> PCI: Setting latency timer of device 0000:00:1f.1 to 64
> >>> ata1: PATA max UDMA/66 cmd 0x1F0 ctl 0x3F6 bmdma 0xFFA0 irq 14
> >>> ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xFFA8 irq 15
> >>> scsi0 : ata_piix
> >>> ata1.00: ATA-4, max UDMA/33, 10018890 sectors: LBA
> >>> ata1.00: ata1: dev 0 multi count 16
> >>> ata1.00: configured for UDMA/33
> >>> scsi1 : ata_piix
> >>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
> >> Hmm... IDENTIFY failed on the second port.  How reproducible is the
> >> problem?  Every time?  Does it work with the IDE driver?  If so, please
> >> post the result of 'hdparm -I /dev/hdX'.
> > 
> > Reproducible?  Everytime
> > 
> > Yes, it works fine with the IDE driver, so long as DMA is disabled.
> > 
> > hdparm -I:
> > /dev/hdc:
> > 
> > ATAPI CD-ROM, with removable media
> >         Model Number:           Lite-On LTN483S 48x Max
> >         Serial Number:
> >         Firmware Revision:      PD02
> > Standards:
> >         Used: ATAPI for CD-ROMs, SFF-8020i, r2.5
> >         Supported: CD-ROM ATAPI-1
> > Configuration:
> >         DRQ response: <=10ms with INTRQ
> >         Packet size: 12 bytes
> > Capabilities:
> >         LBA, IORDY(can be disabled)
> >         DMA: sdma0 sdma1 sdma2 mdma0 mdma1 mdma2 udma0 udma1 *udma2
> >              Cycle time: min=120ns recommended=120ns
> >         PIO: pio0 pio1 pio2 pio3 pio4
> >              Cycle time: no flow control=120ns  IORDY flow control=120ns
> 
> The err_mask is AC_ERR_DEV indicating that the device raised aborted the
> IDENTIFY command.  I wonder what's going on.

FYI: This did work with ide-scsi.  But I don't think that really matters.

> Can you change "#undef ATA_DEBUG" in include/linux/libata.h to "#define
> ATA_DEBUG" and report the resulting dmesg?  There will be a LOT of
> messages so you probably want to increase printk buffer size and detach
> other devices if possible.  It would be best if your root device isn't
> driven by libata so that you can just insert the module and store the
> resulting dmesg.

Yes, definately.  The system is a generic system bootable from usb, cdrom,
or network.  It's not installed on the local hard disk.

The following is a diff between before loading any libata modules and after
loading ata_piix.

--- noata	2007-05-01 08:04:00.207711900 +0000
+++ libata-atapiix	2007-05-01 08:04:33.398212573 +0000
@@ -180,3 +180,162 @@
 logips2pp: Detected unknown logitech mouse model 90
 input: ImExPS/2 Logitech Explorer Mouse as /class/input/input1
 eth0:  setting full-duplex.
+libata version 2.00 loaded.
+piix_init: pci_register_driver
+ata_piix 0000:00:1f.1: version 2.00ac7
+ata_pci_init_one: ENTER
+PCI: Setting latency timer of device 0000:00:1f.1 to 64
+ata_device_add: ENTER
+ata_port_add: ENTER
+ata_port_start: prd alloc, virt cd0f3000, dma d0f3000
+ata1: PATA max UDMA/66 cmd 0x1F0 ctl 0x3F6 bmdma 0xFFA0 irq 14
+__ata_port_freeze: ata1 port frozen
+ata_port_add: ENTER
+ata_port_start: prd alloc, virt cd0eb000, dma d0eb000
+ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xFFA8 irq 15
+__ata_port_freeze: ata2 port frozen
+ata_device_add: probe begin
+scsi1 : ata_piix
+ata_port_schedule_eh: port EH scheduled
+ata_scsi_error: ENTER
+ata_port_flush_task: ENTER
+ata_port_flush_task: flush #1
+ata1: ata_port_flush_task: flush #2
+ata1: ata_port_flush_task: EXIT
+ata_eh_autopsy: ENTER
+ata_eh_recover: ENTER
+ata_eh_prep_resume: ENTER
+ata_eh_prep_resume: EXIT
+__ata_port_freeze: ata1 port frozen
+ata_std_softreset: ENTER
+ata_std_softreset: about to softreset, devmask=3
+ata_bus_softreset: ata1: bus reset via SRST
+ata_dev_classify: found ATA device by sig
+ata_dev_classify: found ATA device by sig
+ata_std_softreset: EXIT, classes[0]=1 [1]=5
+ata_std_postreset: ENTER
+ata_std_postreset: EXIT
+ata_eh_thaw_port: ata1 port thawed
+ata_eh_revalidate_and_attach: ENTER
+ata1.00: ata_dev_read_id: ENTER, host 1, dev 0
+ata_exec_command_pio: ata1: cmd 0xEC
+ata_hsm_move: ata1: protocol 2 task_state 1 (dev_stat 0x58)
+ata_pio_sector: data read
+ata_hsm_move: ata1: protocol 2 task_state 2 (dev_stat 0x50)
+ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
+ata_port_flush_task: ENTER
+ata_port_flush_task: flush #1
+ata1: ata_port_flush_task: flush #2
+ata1: ata_port_flush_task: EXIT
+ata1.00: ATA-4, max UDMA/33, 10018890 sectors: LBA 
+ata1.00: ata1: dev 0 multi count 16
+ata_eh_revalidate_and_attach: EXIT
+ata_eh_resume: ENTER
+ata_eh_resume: EXIT
+ata_dev_set_xfermode: set features - xfer mode
+ata_exec_command_pio: ata1: cmd 0xEF
+ata_hsm_move: ata1: protocol 1 task_state 2 (dev_stat 0x50)
+ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
+ata_port_flush_task: ENTER
+ata_port_flush_task: flush #1
+ata1: ata_port_flush_task: flush #2
+ata1: ata_port_flush_task: EXIT
+ata_dev_set_xfermode: EXIT, err_mask=0
+ata1.00: ata_dev_read_id: ENTER, host 1, dev 0
+ata_exec_command_pio: ata1: cmd 0xEC
+ata_hsm_move: ata1: protocol 2 task_state 1 (dev_stat 0x58)
+ata_pio_sector: data read
+ata_hsm_move: ata1: protocol 2 task_state 2 (dev_stat 0x50)
+ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
+ata_port_flush_task: ENTER
+ata_port_flush_task: flush #1
+ata1: ata_port_flush_task: flush #2
+ata1: ata_port_flush_task: EXIT
+ata_dev_set_mode: xfer_shift=12, xfer_mode=0x42
+ata1.00: configured for UDMA/33
+ata_eh_suspend: ENTER
+ata_eh_suspend: EXIT
+ata_eh_recover: EXIT, rc=0
+ata_scsi_error: EXIT
+scsi2 : ata_piix
+ata_port_schedule_eh: port EH scheduled
+ata_scsi_error: ENTER
+ata_port_flush_task: ENTER
+ata_port_flush_task: flush #1
+ata2: ata_port_flush_task: flush #2
+ata2: ata_port_flush_task: EXIT
+ata_eh_autopsy: ENTER
+ata_eh_recover: ENTER
+ata_eh_prep_resume: ENTER
+ata_eh_prep_resume: EXIT
+__ata_port_freeze: ata2 port frozen
+ata_std_softreset: ENTER
+ata_std_softreset: about to softreset, devmask=1
+ata_bus_softreset: ata2: bus reset via SRST
+ata_dev_classify: found ATA device by sig
+ata_dev_classify: unknown device
+ata_std_softreset: EXIT, classes[0]=1 [1]=5
+ata_std_postreset: ENTER
+ata_std_postreset: EXIT
+ata_eh_thaw_port: ata2 port thawed
+ata_eh_revalidate_and_attach: ENTER
+ata2.00: ata_dev_read_id: ENTER, host 2, dev 0
+ata_exec_command_pio: ata2: cmd 0xEC
+ata_hsm_move: ata2: protocol 2 task_state 1 (dev_stat 0x51)
+ata_hsm_move: ata2: protocol 2 task_state 3 (dev_stat 0x51)
+ata_port_flush_task: ENTER
+ata_port_flush_task: flush #1
+ata2: ata_port_flush_task: flush #2
+ata2: ata_port_flush_task: EXIT
+ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
+ata_eh_revalidate_and_attach: EXIT
+ata_eh_prep_resume: ENTER
+ata_eh_prep_resume: EXIT
+__ata_port_freeze: ata2 port frozen
+ata_std_softreset: ENTER
+ata_std_softreset: about to softreset, devmask=1
+ata_bus_softreset: ata2: bus reset via SRST
+ata_dev_classify: unknown device
+ata_std_softreset: EXIT, classes[0]=5 [1]=5
+ata_std_postreset: ENTER
+ata_std_postreset: EXIT, no device
+ata_eh_thaw_port: ata2 port thawed
+ata_eh_revalidate_and_attach: ENTER
+ata_eh_revalidate_and_attach: EXIT
+ata_eh_resume: ENTER
+ata_eh_resume: EXIT
+ata_eh_suspend: ENTER
+ata_eh_suspend: EXIT
+ata_eh_recover: EXIT, rc=0
+ata_scsi_error: EXIT
+ata_device_add: host probe begin
+ata_scsi_dump_cdb: CDB (1:0,0,0) 12 00 00 00 24 00 00 00 00
+ata_scsi_dump_cdb: CDB (1:0,0,0) 12 00 00 00 60 00 00 00 00
+scsi 1:0:0:0: Direct-Access     ATA      QUANTUM FIREBALL A08. PQ: 0 ANSI: 5
+ata_scsi_dump_cdb: CDB (1:0,0,0) 00 00 00 00 00 00 00 00 00
+ata_scsi_dump_cdb: CDB (1:0,0,0) 25 00 00 00 00 00 00 00 00
+SCSI device sdb: 10018890 512-byte hdwr sectors (5130 MB)
+ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 3f 00 00 00 00 00 08
+sdb: Write Protect is off
+sdb: Mode Sense: 00 3a 00 00
+ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 08
+ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 24
+SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
+ata_scsi_dump_cdb: CDB (1:0,0,0) 00 00 00 00 00 00 00 00 24
+ata_scsi_dump_cdb: CDB (1:0,0,0) 25 00 00 00 00 00 00 00 00
+SCSI device sdb: 10018890 512-byte hdwr sectors (5130 MB)
+ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 3f 00 00 00 00 00 08
+sdb: Write Protect is off
+sdb: Mode Sense: 00 3a 00 00
+ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 08
+ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 24
+SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
+ sdb:<3>ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 00 00 00 00 00 00 08
+ata_sg_setup: 1 sg elements mapped
+ata_exec_command_pio: ata1: cmd 0xC8
+ata_hsm_move: ata1: protocol 3 task_state 2 (dev_stat 0x50)
+ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
+ sdb1
+sd 1:0:0:0: Attached scsi disk sdb
+sd 1:0:0:0: Attached scsi generic sg1 type 0
+piix_init: done
