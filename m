Return-Path: <linux-kernel-owner+w=401wt.eu-S1031214AbXDQREo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031214AbXDQREo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031213AbXDQREo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:04:44 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33287 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031206AbXDQREm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:04:42 -0400
Date: Tue, 17 Apr 2007 13:04:40 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: What's in libata-dev.git?
Message-ID: <20070417170440.GA27992@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I just checked in some useful improvements, so I thought it would be a
good time to review what's queued for 2.6.21 in
git://git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

Here is a quick tour of the branches currently available:
ALL		Meta-branch.  Conduit for external testing.
		Contains all branches noted as "in -mm".
mv-ahci		Marvell AHCI SATA support (in -mm)
reset-seq	Updated ATA reset sequence (in -mm)
upstream	Changes queued for 2.6.22 (in -mm)
sii-lbt		Enables SiI 311x enhanced DMA support
			(Works for some, but not all)
mv-eh		sata_mv conversion to new EH
			(Works for some, but not all)

Feel free to ask about other branches, if you want more details.  The
most interesting branch is 'upstream', which among other stuff contains
these notable changes:

* Remove PCI/IDE/libata combined mode quirk.  This should result in
  happier users, getting better performance.  Now that both old-IDE and
  libata are fully capable of driving the old-style Intel PIIX PCI IDE
  interface, we can eliminate the performance-killing split-driver
  configuration created by the quirk.

  Now, after the quirk has been removed, normal kernel resource
  reservation code will decide whether old-IDE or libata attaches to
  Intel PIIX PATA/SATA. Thus, module choice / load order is the main
  factor that determines which driver attaches.

  The lone downside is that this change will result in a few users
  having to suffer through an hdX<->sdX change for their devices. This
  should be mitigated on modern distros by mount-by-LABEL and LVM, which
  makes such changes more seamless. (me)

* Moves libata driver API to a sane register/unregister style model.
  This eliminates a lot of pointless duplication and copying.  This is a
  far more natural way to write drivers, and mimics several other
  well-known kernel APIs. Life is now easier for driver writers. (Tejun)

* Host Protected Area "HPA" support.  ATA drives allow BIOS to reserve a
  portion of your hard drive for its own use, thus "protecting" the data
  from the "host" (OS).  The old-IDE driver makes this area available to
  Linux users, but libata did not (until now).  Controlled by a module
  option ignore_hpa, if you wish to alter the default behavior. (Alan)

* Improving libata API, so that ->post_set_mode hook can be removed (Alan)

* Further PATA work, bringing the PATA drivers up to snuff.  Fedora
  is testing libata PATA support for Fedora 7, so that area is getting a
  lot of attention right now.  (Alan)

* Remove hardcoded 512 sector size, and enable support for ATA commands
  READ/WRITE LONG. (Mark)

* New ->cable_detect() hook, which simplifies the code (Alan)


Diffstat and shortlog for 'upstream' branch:

 arch/i386/defconfig                 |    1 -
 arch/parisc/configs/c3000_defconfig |    1 -
 arch/x86_64/defconfig               |    1 -
 drivers/ata/Kconfig                 |   43 +-
 drivers/ata/Makefile                |    1 +
 drivers/ata/ahci.c                  |  444 ++++++++--------
 drivers/ata/ata_generic.c           |   32 +--
 drivers/ata/ata_piix.c              |   56 +--
 drivers/ata/libata-core.c           |  978 ++++++++++++++++++++++++-----------
 drivers/ata/libata-eh.c             |    6 +-
 drivers/ata/libata-scsi.c           |   85 +++-
 drivers/ata/libata-sff.c            |  631 +++++++++++++++--------
 drivers/ata/libata.h                |   10 +-
 drivers/ata/pata_ali.c              |   74 +---
 drivers/ata/pata_amd.c              |   94 ++--
 drivers/ata/pata_artop.c            |   26 +-
 drivers/ata/pata_atiixp.c           |   26 +-
 drivers/ata/pata_cmd640.c           |  304 +++++++++++
 drivers/ata/pata_cmd64x.c           |   34 +-
 drivers/ata/pata_cs5520.c           |  145 +++---
 drivers/ata/pata_cs5530.c           |   15 +-
 drivers/ata/pata_cs5535.c           |   24 +-
 drivers/ata/pata_cypress.c          |   14 +-
 drivers/ata/pata_efar.c             |   31 +-
 drivers/ata/pata_hpt366.c           |   26 +-
 drivers/ata/pata_hpt37x.c           |  368 ++++++--------
 drivers/ata/pata_hpt3x2n.c          |   29 +-
 drivers/ata/pata_hpt3x3.c           |   22 +-
 drivers/ata/pata_isapnp.c           |   44 +-
 drivers/ata/pata_it8213.c           |   36 +-
 drivers/ata/pata_it821x.c           |   36 +--
 drivers/ata/pata_ixp4xx_cf.c        |   40 +-
 drivers/ata/pata_legacy.c           |   45 +-
 drivers/ata/pata_marvell.c          |   20 +-
 drivers/ata/pata_mpc52xx.c          |   49 +-
 drivers/ata/pata_mpiix.c            |   40 +-
 drivers/ata/pata_netcell.c          |   31 +-
 drivers/ata/pata_ns87410.c          |    6 +-
 drivers/ata/pata_oldpiix.c          |    6 +-
 drivers/ata/pata_opti.c             |    5 +-
 drivers/ata/pata_optidma.c          |   54 +-
 drivers/ata/pata_pcmcia.c           |   77 ++-
 drivers/ata/pata_pdc2027x.c         |  158 +++---
 drivers/ata/pata_pdc202xx_old.c     |   45 +--
 drivers/ata/pata_platform.c         |   44 +-
 drivers/ata/pata_qdi.c              |   47 +-
 drivers/ata/pata_radisys.c          |   37 +--
 drivers/ata/pata_rz1000.c           |   28 +-
 drivers/ata/pata_sc1200.c           |    1 +
 drivers/ata/pata_scc.c              |   51 +--
 drivers/ata/pata_serverworks.c      |   34 +-
 drivers/ata/pata_sil680.c           |   11 +-
 drivers/ata/pata_sis.c              |  109 +---
 drivers/ata/pata_sl82c105.c         |    2 +-
 drivers/ata/pata_triflex.c          |    4 +-
 drivers/ata/pata_via.c              |   27 +-
 drivers/ata/pata_winbond.c          |   99 ++--
 drivers/ata/pdc_adma.c              |   85 ++--
 drivers/ata/sata_inic162x.c         |   86 ++--
 drivers/ata/sata_mv.c               |  213 ++++----
 drivers/ata/sata_nv.c               |  130 +++---
 drivers/ata/sata_promise.c          |  398 ++++++++-------
 drivers/ata/sata_qstor.c            |   62 +--
 drivers/ata/sata_sil.c              |  118 +++---
 drivers/ata/sata_sil24.c            |  122 ++---
 drivers/ata/sata_sis.c              |   50 +--
 drivers/ata/sata_svw.c              |  107 ++--
 drivers/ata/sata_sx4.c              |  150 +++---
 drivers/ata/sata_uli.c              |   65 +--
 drivers/ata/sata_via.c              |  217 ++++-----
 drivers/ata/sata_vsc.c              |   72 +--
 drivers/pci/quirks.c                |  113 ----
 drivers/scsi/ipr.c                  |    3 +-
 include/linux/ata.h                 |    8 +
 include/linux/ioport.h              |    1 -
 include/linux/libata.h              |   68 ++--
 include/linux/pci.h                 |    1 +
 include/linux/pci_ids.h             |    1 -
 kernel/resource.c                   |   21 -
 lib/devres.c                        |   26 +
 80 files changed, 3548 insertions(+), 3276 deletions(-)
 create mode 100644 drivers/ata/pata_cmd640.c

Alan Cox (34):
      libata: dev_config does not need ap and adev passing
      libata: cable detection fixes
      pata_cmd640: CMD640 PCI support
      pata_it8213: Cable detect
      pata_marvell: Cable and reset fixes
      pata_sis: Clean up using cable_detect methods
      pata_via: Use cable_detect method
      pata_cmd640: Multiple updates
      libata: Restore Kconfig updated experimental levels and correct
      libata-core: fix comments on cable type
      sata_promise: Switch to cable method, clean up some bits as a result
      pata_platform: Add cable_detect method
      pata_rz1000: support cable_detect
      pata_sc1200: restore cable type
      pata_radisys: support cable_detect
      pata_atiixp: support ->cable_detect
      pata_efar: support ->cable_detect
      pata_hpt366: support ->cable_detect
      pata_hpt37x: Updates from drivers/ide work
      pata: expose set_mode method so it can be wrapped
      libata-core: Fix the iordy methods
      sata_sil: First step to removing ->post_set_mode
      libata: Change prototype of mode_filter to remove ata_port*
      pcmcia - spot slave decode flaws (for testing)
      pata_ali: remove all the crap again and switch to cable_detect method
      pata_qdI: restore cable detect
      pata_netcell: re-remove all the crud
      pata_sl82c105: restore cable detect method
      pata_winbond: restore cable method
      pata_optidma: rework for cable detect and to remove post_set_mode()
      pata: cable methods
      pata_winbond
      pata_pdc2027x: Updates
      libata: HPA support

Andrew Morton (1):
      git-libata-all-ipr-fix

Conke Hu (1):
      ahci.c: remove non-existing SB600 raid id (re-send)

Dmitriy Monakhov (1):
      libata: handle ata_pci_device_do_resume() failure while resuming

Jeff Garzik (8):
      [libata] sata_mv: remove extra braces
      [libata] export sata_print_link_status()
      [libata] sata_mv: clean up DMA boundary issues, turn on 64-bit DMA
      [libata] Update several PATA drivers for new ->cable_detect hook
      [libata] More PATA driver ->cable_detect support
      [libata] sata_mv: support ->cable_detect
      [libata] turn on !IORDY filter
      libata/IDE: remove combined mode quirk

Mark Lord (2):
      RESEND: libata: check cdb len per dev instead of per host
      libata: add support for READ/WRITE LONG

Mikael Pettersson (4):
      sata_promise: add missing cable_detect hooks
      sata_promise: separate SATA and PATA ops
      sata_promise: decode and report error reasons
      sata_promise: fix error decode regression

Morrison, Tom (1):
      Support for Marvell 7042 Chip

Robert Hancock (2):
      libata: warn if speed limited due to 40-wire cable
      sata_nv: don't read shadow registers when in ADMA mode

Robin H\. Johnson (1):
      Add notation that the Asus W5F laptop has a short cable instead of 80-wire.

Tejun Heo (20):
      iomap: implement pcim_iounmap_regions()
      libata: hardreset on SERR_INTERNAL
      ahci: implement ata_save/restore_initial_config()
      ahci: move port_map handling to ahci_save_initial_config()
      libata: fix native mode disabled port handling
      libata: improve AC_ERR_DEV handling for ->post_internal_cmd
      libata: kill type mismatch compile warning
      ahci: add PCI ID for new VIA chip
      libata: allocate ap separately from shost
      libata: separate out ata_host_start()
      libata: separate out ata_host_alloc() and ata_host_register()
      libata: implement ata_host_alloc_pinfo() and ata_host_register()
      libata: convert legacy PCI host handling to new init model
      libata: convert native PCI host handling to new init model
      libata: add init helpers including ata_pci_prepare_native_host()
      libata: convert drivers with combined SATA/PATA ports to new init model
      libata: convert ata_pci_init_native_mode() users to new init model
      libata: convert the remaining SATA drivers to new init model
      libata: convert the remaining PATA drivers to new init model
      libata: kill probe_ent and related helpers

