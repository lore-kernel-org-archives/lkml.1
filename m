Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbZFZPzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbZFZPzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZFZPz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:55:29 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:46890 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZFZPz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:55:29 -0400
X-Greylist: delayed 897 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2009 11:55:28 EDT
Message-ID: <4A44EBEE.9070503@numericable.fr>
Date: Fri, 26 Jun 2009 17:40:30 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: bzolnier@gmail.com, davem@davemloft.net
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [REGRESSION] 2.6.29=>2.6.30 suspend to ram regression (IDE related)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

kernel v2.6.29 suspends to RAM reliably on my computer; v2.6.30 doesn't resume after STR 
I tried also 2.6.31-rc1 doesn't work either
I bisected it to :

etienne@etienne-desktop:~/linux-2.6$ git bisect bad
2f0d0fd2a605666d38e290c5c0d2907484352dc4 is first bad commit
commit 2f0d0fd2a605666d38e290c5c0d2907484352dc4             
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>      
Date:   Tue Mar 24 23:22:42 2009 +0100                      

    ide-acpi: cleanup do_drive_get_GTF()
                                        
    * ide_noacpi is already checked by ide_acpi_exec_tfs()
      which is the only user of do_drive_get_GTF().       
                                                          
    * ide_acpi_exec_tfs() prints sufficient debug info about the
      device so no need to have excessive data about port/host. 
                                                                
    * It is sufficient to check for drive->acpidata->obj_handle 
      as it will be NULL if dev == NULL or hwif->acpidata == NULL
      or device is not present.                                  
                                                                 
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

If i revert this patch on top of 2.6.31-rc1, STR Works OK
(i think the only device handled by the legacy IDE subsystem on my computer is my CDROM drive)

thanks,
Etienne

etienne@etienne-desktop:~/linux-2.6$ lspci
00:00.0 Host bridge: Intel Corporation 82915G/P/GV/GL/PL/910GL Memory Controller Hub (rev 04)
00:01.0 PCI bridge: Intel Corporation 82915G/P/GV/GL/PL/910GL PCI Express Root Port (rev 04)
00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 1 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d3)
00:1f.0 ISA bridge: Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC Interface Bridge (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) IDE Controller (rev 03)
00:1f.2 IDE interface: Intel Corporation 82801FB/FW (ICH6/ICH6W) SATA Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus Controller (rev 03)
01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)]
01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
03:00.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
03:00.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (rev 04)
03:08.0 Ethernet controller: Intel Corporation 82562ET/EZ/GT/GZ - PRO/100 VE (LOM) Ethernet Controller (rev 03)

etienne@etienne-desktop:~/linux-2.6$ cat .config|grep IDE
CONFIG_HAVE_IDE=y
CONFIG_IDE=y
# Please see Documentation/ide/ide.txt for help/info on IDE drives
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y
# IDE chipset support/bugfixes
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y
# PCI IDE chipsets support
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_IDEDMA=y



