Return-Path: <linux-kernel-owner+w=401wt.eu-S2992762AbXBJBJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992762AbXBJBJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992759AbXBJBJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:09:17 -0500
Received: from havoc.gtf.org ([69.61.125.42]:53956 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992540AbXBJBJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:09:15 -0500
Date: Fri, 9 Feb 2007 20:09:14 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates 1 of 3
Message-ID: <20070210010914.GA19717@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(just sent this upstream to Andrew and Linus)

This is libata push 1 of 3.  This is largely the "accumulated driver
updates" push: lots of minor changes.  A few new drivers.

The most notable thing is "devres", an optional subsystem for drivers
that greatly simplifies the task of driver housekeeping, if you have
to acquire+map then later unmap+free a bunch of MMIO resources,
some PIO resources, an IRQ (or two or three) like we do with ATA
host controllers.  devres is only used by libata drivers at the moment,
but the APIs are generic enough to be used by any driver.  This should
enable the elimination of several highly common code patterns in various
drivers.

devres, in turn, has enabled us to finally merge the patches that convert
libata to using the lib/iomap.c stuff.  Anyone with eyes can see the
code savings in libata-sff that iomap brings.

Kudos to Tejun Heo for the devres work.

I will be pushing ACPI support on Saturday or Sunday, in order to stage
it into a separate 2.6.20-gitX snapshot.  That's libata push 2 of 3.

The third push will eliminate the ugly split-driver configuration
created by quirk_intel_ide_combined() and ____request_resource(),
whereby libata claims one half of a controller (SATA), and old-IDE
claims the other half (PATA).  libata wins the battle for DMA and IRQ,
and so old-IDE (PATA) is driven via the slower PIO data xfer methods.

Was necessary at the time, as libata lacked ATAPI support and old-IDE
failed to handle irq storms created by newer Intel IDE irq-ack behavior.
But times have changed, and neither conditions remain true.  So we can
remove the hacks.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/driver-model/devres.txt |  268 +++++++++++
 drivers/ata/Kconfig                   |   41 ++-
 drivers/ata/Makefile                  |    3 +
 drivers/ata/ahci.c                    |  236 +++-------
 drivers/ata/ata_generic.c             |    8 +-
 drivers/ata/ata_piix.c                |   56 ++--
 drivers/ata/libata-core.c             |  591 ++++++++-----------------
 drivers/ata/libata-eh.c               |    7 +-
 drivers/ata/libata-scsi.c             |   98 +++--
 drivers/ata/libata-sff.c              |  641 ++++++++-------------------
 drivers/ata/libata.h                  |    4 +-
 drivers/ata/pata_ali.c                |   32 +-
 drivers/ata/pata_amd.c                |   36 +-
 drivers/ata/pata_artop.c              |   12 +-
 drivers/ata/pata_atiixp.c             |    6 +-
 drivers/ata/pata_cmd64x.c             |   18 +-
 drivers/ata/pata_cs5520.c             |   41 ++-
 drivers/ata/pata_cs5530.c             |   41 +-
 drivers/ata/pata_cs5535.c             |    6 +-
 drivers/ata/pata_cypress.c            |    6 +-
 drivers/ata/pata_efar.c               |    6 +-
 drivers/ata/pata_hpt366.c             |   26 +-
 drivers/ata/pata_hpt37x.c             |   61 +--
 drivers/ata/pata_hpt3x2n.c            |   26 +-
 drivers/ata/pata_hpt3x3.c             |    8 +-
 drivers/ata/pata_isapnp.c             |   21 +-
 drivers/ata/pata_it8213.c             |  354 +++++++++++++++
 drivers/ata/pata_it821x.c             |   58 +--
 drivers/ata/pata_ixp4xx_cf.c          |   50 +--
 drivers/ata/pata_jmicron.c            |    8 +-
 drivers/ata/pata_legacy.c             |  166 ++++----
 drivers/ata/pata_marvell.c            |   12 +-
 drivers/ata/pata_mpc52xx.c            |  538 +++++++++++++++++++++++
 drivers/ata/pata_mpiix.c              |  113 ++---
 drivers/ata/pata_netcell.c            |    6 +-
 drivers/ata/pata_ns87410.c            |    6 +-
 drivers/ata/pata_oldpiix.c            |   24 +-
 drivers/ata/pata_opti.c               |   24 +-
 drivers/ata/pata_optidma.c            |   40 +-
 drivers/ata/pata_pcmcia.c             |   27 +-
 drivers/ata/pata_pdc2027x.c           |  122 ++---
 drivers/ata/pata_pdc202xx_old.c       |   41 +-
 drivers/ata/pata_platform.c           |   67 +---
 drivers/ata/pata_qdi.c                |   50 ++-
 drivers/ata/pata_radisys.c            |    6 +-
 drivers/ata/pata_rz1000.c             |    6 +-
 drivers/ata/pata_sc1200.c             |    6 +-
 drivers/ata/pata_serverworks.c        |   31 +-
 drivers/ata/pata_sil680.c             |    8 +-
 drivers/ata/pata_sis.c                |   70 +++-
 drivers/ata/pata_sl82c105.c           |   10 +-
 drivers/ata/pata_triflex.c            |    6 +-
 drivers/ata/pata_via.c                |   22 +-
 drivers/ata/pata_winbond.c            |   49 ++-
 drivers/ata/pdc_adma.c                |  120 ++----
 drivers/ata/sata_inic162x.c           |  781 +++++++++++++++++++++++++++++++++
 drivers/ata/sata_mv.c                 |  200 +++------
 drivers/ata/sata_nv.c                 |  629 ++++++++++++++++-----------
 drivers/ata/sata_promise.c            |  379 +++++++++++-----
 drivers/ata/sata_qstor.c              |  138 ++----
 drivers/ata/sata_sil.c                |   99 ++---
 drivers/ata/sata_sil24.c              |  178 +++-----
 drivers/ata/sata_sis.c                |  161 +++++---
 drivers/ata/sata_svw.c                |  127 +++---
 drivers/ata/sata_sx4.c                |  207 +++------
 drivers/ata/sata_uli.c                |   66 ++--
 drivers/ata/sata_via.c                |  193 ++++++---
 drivers/ata/sata_vsc.c                |  134 +++---
 drivers/base/Kconfig                  |   12 +
 drivers/base/Makefile                 |    1 +
 drivers/base/base.h                   |    1 +
 drivers/base/core.c                   |    2 +
 drivers/base/dd.c                     |    3 +
 drivers/base/devres.c                 |  644 +++++++++++++++++++++++++++
 drivers/base/dma-mapping.c            |  218 +++++++++
 drivers/base/dmapool.c                |   59 +++
 drivers/pci/pci.c                     |  127 ++++++-
 drivers/pci/quirks.c                  |    2 +-
 include/linux/ata.h                   |   13 +-
 include/linux/device.h                |   38 ++
 include/linux/dma-mapping.h           |   29 ++-
 include/linux/dmapool.h               |    7 +
 include/linux/interrupt.h             |    6 +
 include/linux/io.h                    |   21 +
 include/linux/ioport.h                |   20 +
 include/linux/libata.h                |  131 ++----
 include/linux/pci.h                   |    9 +
 include/linux/pci_ids.h               |    3 +
 kernel/irq/manage.c                   |   86 ++++
 kernel/resource.c                     |   62 +++
 lib/Makefile                          |    3 +-
 lib/iomap.c                           |  299 +++++++++++++-
 92 files changed, 6210 insertions(+), 3217 deletions(-)
 create mode 100644 Documentation/driver-model/devres.txt
 create mode 100644 drivers/ata/pata_it8213.c
 create mode 100644 drivers/ata/pata_mpc52xx.c
 create mode 100644 drivers/ata/sata_inic162x.c
 create mode 100644 drivers/base/devres.c
 create mode 100644 drivers/base/dma-mapping.c

Adrian Bunk (2):
      drivers/ata/: make 4 functions static
      fix CONFIG_SATA_SIS=y compile error

Akira Iguchi (2):
      libata: add another IRQ calls (core and headers)
      libata: add another IRQ calls (libata drivers)

Alan (10):
      pata_it8213: Add new driver for the IT8213 card
      sata_via: PATA support
      libata-sff: Don't try and activate channels which are not in use
      ahci: Remove jmicron fixup
      libata: PIIX3 support
      libata: trivial stuff
      sata_sis: Support for PATA supports
      Kconfig: clarify ATA_PIIX description
      ata: Add defines for the iordy bits
      libata: Early CFA adapters are not required to support mode setting

Alan Cox (1):
      pci: Move PCI_VDEVICE from libata to core

Andrew Morton (2):
      libata piix3 support warning fix
      git-libata-all: forward declare struct device

Arjan van de Ven (1):
      user of the jiffies rounding patch: ATA subsystem

Conke Hu (1):
      Add pci class code for SATA & AHCI, and replace some magic numbers.

Dan Wolstenholme (1):
      [libata] sata_vsc: support PCI MSI

Eric D. Mudama (1):
      libata: rearrange dmesg info to add full ATA revision

J J (1):
      ata_piix: add ICH7 on Acer 3682WLMi to laptop list

Jakub W. Jozwicki J (1):
      pata_sis: implement laptop list and add ASUS A6K/A6U

Jeff Garzik (5):
      [libata] trim trailing whitespace
      [libata] sata_vsc: build fix after PCI MSI feature addition
      [libata] Shuffle DRV_xxx in core and SiS drivers, to kill warnings
      libata: build fix after dmesg probe output changes
      libata: kill ATA_ENABLE_PATA

Mikael Pettersson (5):
      sata_promise: TX2plus PATA support
      sata_promise: ATAPI support
      sata_promise: ATAPI cleanup
      sata_promise: issue ATAPI commands as normal packets
      sata_promise: handle ATAPI_NODATA ourselves

Robert Hancock (5):
      sata_nv: add suspend/resume support v3 (Resubmit)
      sata_nv: cleanup ADMA error handling
      sata_nv: use ADMA for NODATA commands
      sata_nv: wait for response on entering/leaving ADMA mode
      sata_nv: propagate ata_pci_device_do_resume return value

Sergei Shtylyov (4):
      pata_sl82c105: wrong assumptions about compatible PIO modes
      (2.6.20) pata_oldpiix: fix PIO2 underclocking
      (2.6.20) pata_mpiix: fix PIO setup issues
      (2.6.20) pata_mpiix: probing cleanup (resend)

Sylvain Munaut (1):
      libata: Add support for the MPC52xx ATA controller

Tejun Heo (18):
      libata: straighten out ATA_ID_* constants
      libata: use ata_id_c_string()
      libata: handle pci_enable_device() failure while resuming
      libata: kill qc->nsect and cursect
      sata_inic162x: finally, driver for initio 162x SATA controllers, take #2
      sata_promise: kill qc->nsect
      libata: implement HDIO_GET_IDENTITY
      devres: device resource management
      libata: implement ata_host_detach()
      libata: update libata core layer to use devres
      libata: update libata LLDs to use devres
      libata: remove unused functions
      devres: implement pcim_iomap_regions()
      iomap: iomap should be in obj-y not in lib-y
      pata_platform: fix devres conversion
      libata: convert to iomap
      libata: add 150ms between completion of hardreset and status checking
      sata_inic162x: fix a few glitches in hardreset

Uwe Koziolek (1):
      sata_sis: support SiS966/966L


