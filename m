Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZFYFNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZFYFNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZFYFNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:13:35 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1433 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZFYFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:13:34 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/19] Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:16 -0700
Message-Id: <cover.1245906151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI_VDEVICE macro can simplify declarations.
Converted source code to use it via the script below:

#! /bin/bash

for line in \
    $(grep -ioP "PCI_VENDOR_ID_\w+\s+0x[a-f0-9]{4,4}" include/linux/pci_ids.h | \
    sed -r -e "s/PCI_VENDOR_ID_(\w+)\s+(0x[a-fA-F0-9]{1,4})/\2:\1/g" | \
    grep -vi "0x1102") ; do
    
    constant=$(echo $line | cut -f1 -d":")
    vendor=$(echo $line | cut -f2 -d":")

    echo "$constant -> $vendor"

    for file in $(grep -rP --include=*.[ch] -li -w \
	$constant drivers sound) ; do

	perl -i -e \
	    "local $/; while(<>) { s/\b$constant\s*,\s*(\w+)\s*,\s*PCI_ANY_ID\s*,\s*PCI_ANY_ID\s*,\s*0\s*,\s*0\s*,\s*/PCI_VDEVICE\($vendor, \1\), /gi; print; }" $file
    done

    for file in $(grep -rP --include=*.[ch] -li -w \
	PCI_VENDOR_ID_$vendor drivers sound) ; do

	perl -i -e \
	    "local $/; while(<>) { s/\bPCI_VENDOR_ID_$vendor\s*,\s*(\w+)\s*,\s*PCI_ANY_ID\s*,\s*PCI_ANY_ID\s*,\s*0\s*,\s*0\s*,\s*/PCI_VDEVICE\($vendor, \1\), /g; print; }" $file
    done

done

---------

Joe Perches (19):
  drivers/ata: Use PCI_VDEVICE
  drivers/atm: Use PCI_VDEVICE
  drivers/block: Use PCI_VDEVICE
  drivers/char/hw_random: Use PCI_VDEVICE
  drivers/isdn: Use PCI_VDEVICE
  drivers/media: Use PCI_VDEVICE
  drivers/memstick: Use PCI_VDEVICE
  drivers/misc: Use PCI_VDEVICE
  drivers/mmc: Use PCI_VDEVICE
  drivers/net/wan: Use PCI_VDEVICE
  drivers/net/wireless: Use PCI_VDEVICE
  drivers/net: Use PCI_VDEVICE
  drivers/parport: Use PCI_VDEVICE
  drivers/scsi: Use PCI_VDEVICE
  drivers/serial: Use PCI_VDEVICE
  drivers/staging: Use PCI_VDEVICE
  drivers/telephony: Use PCI_VDEVICE
  drivers/video: Use PCI_VDEVICE
  sound: Use PCI_VDEVICE

 drivers/ata/ata_piix.c                             |   98 ++--
 drivers/ata/pata_scc.c                             |    3 +-
 drivers/atm/ambassador.c                           |    6 +-
 drivers/atm/eni.c                                  |    6 +-
 drivers/atm/firestream.c                           |    6 +-
 drivers/atm/fore200e.c                             |    3 +-
 drivers/atm/he.c                                   |    3 +-
 drivers/atm/horizon.c                              |    3 +-
 drivers/atm/idt77252.c                             |    3 +-
 drivers/atm/nicstar.c                              |    3 +-
 drivers/atm/solos-pci.c                            |    2 +-
 drivers/atm/zatm.c                                 |    6 +-
 drivers/block/sx8.c                                |    4 +-
 drivers/char/hw_random/amd-rng.c                   |    4 +-
 drivers/char/hw_random/geode-rng.c                 |    3 +-
 drivers/isdn/hardware/eicon/divasmain.c            |   34 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |    9 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |   69 +--
 drivers/media/video/bt8xx/bttv-driver.c            |   12 +-
 drivers/media/video/meye.c                         |    3 +-
 drivers/memstick/host/jmb38x_ms.c                  |    3 +-
 drivers/misc/tifm_7xx1.c                           |    9 +-
 drivers/mmc/host/via-sdmmc.c                       |    3 +-
 drivers/net/3c59x.c                                |   90 ++--
 drivers/net/8139too.c                              |   18 +-
 drivers/net/amd8111e.c                             |    3 +-
 drivers/net/arcnet/com20020-pci.c                  |    6 +-
 drivers/net/bnx2.c                                 |   24 +-
 drivers/net/bnx2x_main.c                           |    9 +-
 drivers/net/cassini.c                              |    6 +-
 drivers/net/cxgb3/cxgb3_main.c                     |    2 +-
 drivers/net/irda/via-ircc.c                        |   10 +-
 drivers/net/natsemi.c                              |    2 +-
 drivers/net/ne2k-pci.c                             |   12 +-
 drivers/net/pci-skeleton.c                         |    4 +-
 drivers/net/sis900.c                               |    6 +-
 drivers/net/spider_net.c                           |    3 +-
 drivers/net/starfire.c                             |    2 +-
 drivers/net/sundance.c                             |    6 +-
 drivers/net/sungem.c                               |   24 +-
 drivers/net/tehuti.c                               |    6 +-
 drivers/net/tlan.c                                 |   39 +-
 drivers/net/tokenring/tmspci.c                     |    8 +-
 drivers/net/tulip/de2104x.c                        |    6 +-
 drivers/net/tulip/de4x5.c                          |   12 +-
 drivers/net/tulip/tulip_core.c                     |   28 +-
 drivers/net/tulip/uli526x.c                        |    4 +-
 drivers/net/tulip/winbond-840.c                    |    4 +-
 drivers/net/typhoon.c                              |   18 +-
 drivers/net/wan/farsync.c                          |   21 +-
 drivers/net/wan/pc300_drv.c                        |   12 +-
 drivers/net/wan/pc300too.c                         |   12 +-
 drivers/net/wan/wanxl.c                            |    9 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |   10 +-
 drivers/net/wireless/prism54/islpci_hotplug.c      |    4 +-
 drivers/net/yellowfin.c                            |    4 +-
 drivers/parport/parport_pc.c                       |   98 ++---
 drivers/parport/parport_serial.c                   |   93 ++---
 drivers/scsi/3w-9xxx.c                             |   12 +-
 drivers/scsi/3w-xxxx.c                             |    6 +-
 drivers/scsi/BusLogic.c                            |    9 +-
 drivers/scsi/a100u2w.c                             |    2 +-
 drivers/scsi/aacraid/linit.c                       |    6 +-
 drivers/scsi/dmx3191d.c                            |    3 +-
 drivers/scsi/fdomain.c                             |    3 +-
 drivers/scsi/initio.c                              |   20 +-
 drivers/scsi/megaraid.c                            |    9 +-
 drivers/scsi/qla1280.c                             |   18 +-
 drivers/scsi/stex.c                                |   18 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |   45 +--
 drivers/scsi/tmscsim.c                             |    3 +-
 drivers/serial/8250_pci.c                          |  526 +++++---------------
 .../staging/comedi/drivers/addi-data/addi_common.c |   54 +-
 drivers/staging/epl/Edrv8139.c                     |    2 +-
 drivers/staging/vt6655/device_main.c               |    2 +-
 drivers/telephony/ixj.c                            |    3 +-
 drivers/video/aty/aty128fb.c                       |  141 ++----
 drivers/video/aty/radeon_base.c                    |    2 +-
 drivers/video/cirrusfb.c                           |    2 +-
 drivers/video/cyber2000fb.c                        |    9 +-
 drivers/video/i810/i810_main.c                     |   18 +-
 drivers/video/igafb.c                              |    3 +-
 drivers/video/imsttfb.c                            |    6 +-
 drivers/video/matrox/matroxfb_base.c               |   33 +-
 drivers/video/neofb.c                              |   27 +-
 drivers/video/pm2fb.c                              |    9 +-
 drivers/video/pm3fb.c                              |    3 +-
 drivers/video/pvr2fb.c                             |    3 +-
 drivers/video/riva/fbdev.c                         |  126 ++----
 drivers/video/savage/savagefb_driver.c             |   69 +--
 drivers/video/sis/sis_main.h                       |   20 +-
 drivers/video/tridentfb.c                          |   42 +-
 sound/oss/kahlua.c                                 |    2 +-
 sound/pci/atiixp.c                                 |    8 +-
 sound/pci/atiixp_modem.c                           |    4 +-
 sound/pci/au88x0/au8810.c                          |    3 +-
 sound/pci/au88x0/au8820.c                          |    3 +-
 sound/pci/au88x0/au8830.c                          |    3 +-
 sound/pci/cmipci.c                                 |   10 +-
 sound/pci/cs4281.c                                 |    2 +-
 sound/pci/cs46xx/cs46xx.c                          |    6 +-
 sound/pci/ens1370.c                                |    6 +-
 sound/pci/es1938.c                                 |    2 +-
 sound/pci/ice1712/ice1712.c                        |    2 +-
 sound/pci/ice1712/ice1724.c                        |    2 +-
 sound/pci/intel8x0.c                               |   46 +-
 sound/pci/intel8x0m.c                              |   34 +-
 sound/pci/mixart/mixart.c                          |    2 +-
 sound/pci/nm256/nm256.c                            |    6 +-
 sound/pci/rme32.c                                  |    9 +-
 sound/pci/rme96.c                                  |   12 +-
 sound/pci/sonicvibes.c                             |    2 +-
 sound/pci/via82xx.c                                |    4 +-
 sound/pci/via82xx_modem.c                          |    2 +-
 sound/pci/ymfpci/ymfpci.c                          |   12 +-
 115 files changed, 838 insertions(+), 1508 deletions(-)

