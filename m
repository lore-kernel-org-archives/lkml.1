Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZCYAZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZCYAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZCYAZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:25:11 -0400
Received: from kroah.org ([198.145.64.141]:47199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752292AbZCYAZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:25:07 -0400
Date: Tue, 24 Mar 2009 17:16:59 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.30 merge window
Message-ID: <20090325001659.GA22461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the driver-core patches for the 2.6.30 merge window.

The final remanants of the big "bus_id" removal to use dev_name are in
here, they have all been send to the different subsystem maintainers and
either ignored for 6 months, or acked.

There is a bit of rework of struct device, moving some private fields
out of the public eye, so they don't get in trouble by using them
improperly (parisc had to be fixed up here because of this, that change
has been acked as well.)

The dynamic debug code has also been reworked and merged with existing
code, to hopefully make it easier for everyone to use properly.

And there's a new UIO driver, for some video-timestamp hardware, that is
already being used in the field by a number of crazy users.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/DocBook/uio-howto.tmpl    |   29 +-
 Documentation/dynamic-debug-howto.txt   |  240 ++++++++++
 Documentation/kernel-parameters.txt     |    5 -
 arch/mips/basler/excite/excite_iodev.c  |   27 +-
 arch/powerpc/platforms/ps3/system-bus.c |    4 +-
 drivers/acpi/dock.c                     |    2 +-
 drivers/amba/bus.c                      |    4 +-
 drivers/base/base.h                     |   31 ++
 drivers/base/bus.c                      |   44 ++-
 drivers/base/core.c                     |  108 +++--
 drivers/base/dd.c                       |   40 +-
 drivers/base/driver.c                   |   15 +-
 drivers/base/firmware_class.c           |    4 +-
 drivers/base/platform.c                 |   60 ++-
 drivers/base/power/main.c               |   44 ++
 drivers/base/power/power.h              |    8 +
 drivers/base/sys.c                      |   54 ++--
 drivers/block/floppy.c                  |    3 +-
 drivers/char/tpm/tpm_atmel.c            |   28 +-
 drivers/char/tpm/tpm_tis.c              |   28 +-
 drivers/char/vc_screen.c                |   16 +-
 drivers/char/vt.c                       |    5 +-
 drivers/dio/dio.c                       |    4 +-
 drivers/dma/dw_dmac.c                   |    2 +-
 drivers/edac/cell_edac.c                |    2 +-
 drivers/edac/mpc85xx_edac.c             |    2 +-
 drivers/edac/mv64x60_edac.c             |    8 +-
 drivers/eisa/eisa-bus.c                 |    4 +-
 drivers/gpio/bt8xxgpio.c                |    2 +-
 drivers/gpu/drm/drm_sysfs.c             |    4 +-
 drivers/i2c/i2c-core.c                  |    2 +-
 drivers/ide/au1xxx-ide.c                |   36 +-
 drivers/isdn/gigaset/ser-gigaset.c      |    3 +-
 drivers/mca/mca-bus.c                   |    4 +-
 drivers/media/radio/radio-tea5764.c     |    3 +-
 drivers/media/video/v4l2-device.c       |    2 +-
 drivers/mfd/mcp-core.c                  |    2 +-
 drivers/mfd/ucb1x00-core.c              |    2 +-
 drivers/mmc/host/atmel-mci.c            |    2 +-
 drivers/mmc/host/of_mmc_spi.c           |    2 +-
 drivers/mtd/maps/pxa2xx-flash.c         |   37 +-
 drivers/mtd/nand/excite_nandflash.c     |   25 +-
 drivers/mtd/nand/ndfc.c                 |    2 +-
 drivers/mtd/onenand/generic.c           |   26 +-
 drivers/net/arm/ks8695net.c             |    2 +-
 drivers/net/au1000_eth.c                |    8 +-
 drivers/net/bfin_mac.c                  |   12 +-
 drivers/net/bmac.c                      |    2 +-
 drivers/net/cpmac.c                     |    2 +-
 drivers/net/declance.c                  |    6 +-
 drivers/net/depca.c                     |    6 +-
 drivers/net/ehea/ehea_main.c            |    2 +-
 drivers/net/jazzsonic.c                 |    6 +-
 drivers/net/macb.c                      |   10 +-
 drivers/net/macsonic.c                  |   15 +-
 drivers/net/mipsnet.c                   |   26 +-
 drivers/net/mv643xx_eth.c               |    2 +-
 drivers/net/sb1250-mac.c                |   10 +-
 drivers/net/smc911x.c                   |    2 +-
 drivers/net/smc91x.c                    |    2 +-
 drivers/net/smsc911x.c                  |    7 +-
 drivers/net/smsc9420.c                  |    4 +-
 drivers/net/tc35815.c                   |    4 +-
 drivers/net/wimax/i2400m/driver.c       |    2 +-
 drivers/net/wimax/i2400m/usb-notif.c    |    2 +-
 drivers/net/xtsonic.c                   |    2 +-
 drivers/pci/hotplug/cpqphp_sysfs.c      |    3 +-
 drivers/pcmcia/au1000_generic.c         |   37 +-
 drivers/pcmcia/i82365.c                 |   28 +-
 drivers/pcmcia/m32r_cfc.c               |   30 +-
 drivers/pcmcia/m32r_pcc.c               |   30 +-
 drivers/pcmcia/rsrc_mgr.c               |    2 +-
 drivers/pcmcia/sa1100_generic.c         |   38 ++-
 drivers/pcmcia/tcic.c                   |   30 +-
 drivers/pcmcia/vrc4171_card.c           |   34 +-
 drivers/rapidio/rio-driver.c            |    2 +-
 drivers/rtc/rtc-at91sam9.c              |    4 +-
 drivers/rtc/rtc-omap.c                  |    4 +-
 drivers/rtc/rtc-twl4030.c               |    2 +-
 drivers/s390/cio/ccwgroup.c             |    5 +-
 drivers/s390/cio/chsc_sch.c             |    4 +-
 drivers/s390/cio/css.c                  |    4 +-
 drivers/s390/cio/device.c               |   13 +-
 drivers/s390/net/qeth_l3_main.c         |    2 +-
 drivers/scsi/a4000t.c                   |   29 +-
 drivers/scsi/bvme6000_scsi.c            |   29 +-
 drivers/scsi/mvme16x_scsi.c             |   29 +-
 drivers/serial/sunzilog.c               |    4 +-
 drivers/sh/maple/maple.c                |    8 +-
 drivers/sh/superhyway/superhyway.c      |    4 +-
 drivers/spi/atmel_spi.c                 |    8 +-
 drivers/spi/mpc52xx_psc_spi.c           |    2 +-
 drivers/spi/omap2_mcspi.c               |    2 +-
 drivers/spi/omap_uwire.c                |   12 +-
 drivers/spi/orion_spi.c                 |    2 +-
 drivers/spi/pxa2xx_spi.c                |    4 +-
 drivers/spi/spi_bfin5xx.c               |    4 +-
 drivers/spi/spi_gpio.c                  |    2 +-
 drivers/spi/spi_imx.c                   |    5 +-
 drivers/spi/spi_mpc83xx.c               |    4 +-
 drivers/spi/spi_txx9.c                  |    3 +-
 drivers/tc/tc.c                         |    8 +-
 drivers/uio/Kconfig                     |   18 +
 drivers/uio/Makefile                    |    1 +
 drivers/uio/uio.c                       |   25 +-
 drivers/uio/uio_aec.c                   |  175 +++++++
 drivers/usb/gadget/ci13xxx_udc.c        |    2 +-
 drivers/usb/gadget/imx_udc.c            |    4 +-
 drivers/usb/host/fhci-dbg.c             |    2 +-
 drivers/usb/host/fhci-hcd.c             |    4 +-
 drivers/video/au1100fb.c                |   31 +-
 drivers/video/au1200fb.c                |   25 +-
 drivers/video/pmag-ba-fb.c              |   17 +-
 drivers/video/pmagb-b-fb.c              |   17 +-
 drivers/video/ps3fb.c                   |    2 +-
 drivers/video/sh_mobile_lcdcfb.c        |    2 +-
 drivers/video/tmiofb.c                  |    2 +-
 drivers/watchdog/rm9k_wdt.c             |   27 +-
 drivers/zorro/zorro.c                   |    4 +-
 fs/partitions/check.c                   |   10 +-
 fs/sysfs/bin.c                          |  253 ++++++++++-
 fs/sysfs/dir.c                          |   33 ++-
 fs/sysfs/file.c                         |   26 +-
 fs/sysfs/inode.c                        |   17 +
 fs/sysfs/mount.c                        |    6 +-
 fs/sysfs/sysfs.h                        |    3 +
 include/asm-generic/vmlinux.lds.h       |   15 +-
 include/linux/console.h                 |    4 +-
 include/linux/device.h                  |   38 +-
 include/linux/dynamic_debug.h           |   88 ++++
 include/linux/dynamic_printk.h          |   93 ----
 include/linux/kernel.h                  |    7 +-
 include/linux/kobject.h                 |    3 +
 include/linux/mod_devicetable.h         |    9 +
 include/linux/platform_device.h         |    7 +
 include/linux/pm.h                      |   11 +
 include/linux/uio_driver.h              |    4 +
 include/linux/wimax/debug.h             |    2 +-
 kernel/module.c                         |   25 +-
 lib/Kconfig.debug                       |   74 ++--
 lib/Makefile                            |    2 +-
 lib/dynamic_debug.c                     |  769 +++++++++++++++++++++++++++++++
 lib/dynamic_printk.c                    |  414 -----------------
 lib/kobject.c                           |    2 +-
 lib/kobject_uevent.c                    |    9 +-
 net/bluetooth/hci_sysfs.c               |    2 +-
 net/bluetooth/rfcomm/tty.c              |    5 +-
 net/netfilter/nf_conntrack_pptp.c       |    2 +-
 scripts/Makefile.lib                    |    2 +-
 scripts/mod/file2alias.c                |   12 +
 150 files changed, 2670 insertions(+), 1175 deletions(-)
 create mode 100644 Documentation/dynamic-debug-howto.txt
 create mode 100644 drivers/uio/uio_aec.c
 create mode 100644 include/linux/dynamic_debug.h
 delete mode 100644 include/linux/dynamic_printk.h
 create mode 100644 lib/dynamic_debug.c
 delete mode 100644 lib/dynamic_printk.c

---------------

Alex Chiang (2):
      sysfs: sysfs_add_one WARNs with full path to duplicate filename
      sysfs: only allow one scheduled removal callback per kobj

Arjan van de Ven (1):
      kobject: don't block for each kobject_uevent

Brandon Philips (1):
      uio: add the uio_aec driver

Cornelia Huck (1):
      Driver core: Fix device_move() vs. dpm list ordering, v2

Dave Young (1):
      driver-core: do not register a driver with bus_type not registered

Eric Miao (2):
      platform: make better use of to_platform_{device,driver}() macros
      platform: introduce module id table for platform devices

Eric W. Biederman (3):
      sysfs: Take sysfs_mutex when fetching the root inode.
      sysfs: reference sysfs_dirent from sysfs inodes
      sysfs: don't block indefinitely for unmapped files.

Geert Uytterhoeven (1):
      scsi/m68k: Kill NCR_700_detect() warnings

Greg Banks (2):
      Dynamic debug: allow simple quoting of words
      Dynamic debug: fix pr_fmt() build error

Greg Kroah-Hartman (5):
      PS3: replace bus_id usage
      driver core: create a private portion of struct device
      driver core: move klist_children into private structure
      driver core: move knode_driver into private structure
      driver core: move knode_bus into private structure

Hans J. Koch (1):
      UIO: Add name attributes for mappings and port regions

Hugh Dickins (1):
      sysfs: fix some bin_vm_ops errors

Ian Abbott (1):
      UIO: Take offset into account when determining number of pages that can be mapped

Jason Baron (2):
      dynamic debug: combine dprintk and dynamic printk
      dynamic debug: update docs

Kay Sievers (28):
      edac: struct device - replace bus_id with dev_name(), dev_set_name()
      spi: struct device - replace bus_id with dev_name(), dev_set_name()
      video: struct device - replace bus_id with dev_name(), dev_set_name()
      zorro: struct device - replace bus_id with dev_name(), dev_set_name()
      mmc: struct device - replace bus_id with dev_name(), dev_set_name()
      mtd: struct device - replace bus_id with dev_name(), dev_set_name()
      pci: struct device - replace bus_id with dev_name(), dev_set_name()
      rapidio: struct device - replace bus_id with dev_name(), dev_set_name()
      s390: struct device - replace bus_id with dev_name(), dev_set_name()
      serial: struct device - replace bus_id with dev_name(), dev_set_name()
      sh: struct device - replace bus_id with dev_name(), dev_set_name()
      tc: struct device - replace bus_id with dev_name(), dev_set_name()
      pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()
      rtc: struct device - replace bus_id with dev_name(), dev_set_name()
      net: struct device - replace bus_id with dev_name(), dev_set_name()
      drm: struct device - replace bus_id with dev_name(), dev_set_name()
      v4l: struct device - replace bus_id with dev_name(), dev_set_name()
      amba: struct device - replace bus_id with dev_name(), dev_set_name()
      dio: struct device - replace bus_id with dev_name(), dev_set_name()
      dma: struct device - replace bus_id with dev_name(), dev_set_name()
      eisa: struct device - replace bus_id with dev_name(), dev_set_name()
      gpio: struct device - replace bus_id with dev_name(), dev_set_name()
      mca: struct device - replace bus_id with dev_name(), dev_set_name()
      mfd: struct device - replace bus_id with dev_name(), dev_set_name()
      wimax: struct device - replace bus_id with dev_name(), dev_set_name()
      usb: struct device - replace bus_id with dev_name(), dev_set_name()
      driver core: get rid of struct device's bus_id string array
      vcs: hook sysfs devices into object lifetime instead of "binding"

Ming Lei (6):
      driver core: check bus->match without holding device lock
      platform driver: fix incorrect use of 'platform_bus_type' with 'struct device_driver'
      driver core: remove polling for driver_probe_done(v5)
      driver core: move platform_data into platform_device
      driver core: fix passing platform_data
      Driver core: implement uevent suppress in kobject

Qinghuang Feng (1):
      SYSFS: use standard magic.h for sysfs

Sachin Sant (1):
      USB: FHCI: use dev_name() in place of bus_id.

Zhenwen Xu (1):
      Driver core: some cleanup on drivers/base/sys.c

