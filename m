Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYAYHNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYAYHNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYAYHNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:13:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33385 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbYAYHNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:13:01 -0500
Date: Thu, 24 Jan 2008 23:11:27 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches against 2.6.24
Message-ID: <20080125071127.GA4860@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the low level nature of these patches, and because they touch so
many different parts of the kernel, a number of the subsystem
maintainers have asked me to get them in first to make merging other
trees easier.

Here are a pretty large number of kobject, documentation, and driver
core patches against your 2.6.24 git tree.

They can be broken down into these major areas:
	- Documentation updates (language translations and fixes, as
	  well as kobject and kset documenatation updates.)
	- major kset/kobject/ktype rework and fixes.  This cleans up the
	  kset and kobject and ktype relationship and architecture,
	  making sense of things now, and good documenation and samples
	  are provided for others to use.  Also the attributes for
	  kobjects are much easier to handle now.  This cleaned up a LOT
	  of code all through the kernel, making kobjects easier to use
	  if you want to.
	- struct bus_type has been reworked to now handle the lifetime
	  rules properly, as the kobject is properly dynamic.
	- struct driver has also been reworked, and now the lifetime
	  issues are resolved.
	- the block subsystem has been converted to use struct device
	  now, and not "raw" kobjects.  This patch has been in the -mm
	  tree for over a year now, and finally all the issues are
	  worked out with it.  Older distros now properly work with new
	  kernels, and no userspace updates are needed at all.
	- nozomi driver is added.  This has also been in -mm for a long
	  time, and many people have asked for it to go in.  It is now
	  in good enough shape to do so.
	- lots of class_device conversions to use struct device instead.
	  The tree is almost all cleaned up now, only SCSI and IB is the
	  remaining code to fix up...


Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

All of these patches have been in the -mm tree for a number of months.

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/kobject.txt                          |  489 +++--
 Documentation/pnp.txt                              |    4 +-
 Documentation/s390/cds.txt                         |    2 +-
 Documentation/vm/slabinfo.c                        |    2 +-
 Documentation/vm/slub.txt                          |    2 +-
 Documentation/zh_CN/CodingStyle                    |  701 +++++++
 Documentation/zh_CN/HOWTO                          |   10 +-
 Documentation/zh_CN/SubmittingDrivers              |  168 ++
 Documentation/zh_CN/SubmittingPatches              |  416 ++++
 Documentation/zh_CN/oops-tracing.txt               |  212 +++
 Documentation/zh_CN/sparse.txt                     |  100 +
 Documentation/zh_CN/stable_kernel_rules.txt        |   66 +
 .../zh_CN/volatile-considered-harmful.txt          |  113 ++
 arch/arm/kernel/time.c                             |    4 +-
 arch/arm/mach-integrator/integrator_ap.c           |    2 +-
 arch/arm/mach-omap1/pm.c                           |   23 +-
 arch/arm/mach-pxa/cm-x270.c                        |    2 +-
 arch/arm/mach-pxa/lpd270.c                         |    2 +-
 arch/arm/mach-pxa/lubbock.c                        |    2 +-
 arch/arm/mach-pxa/mainstone.c                      |    2 +-
 arch/arm/mach-s3c2410/s3c2410.c                    |    2 +-
 arch/arm/mach-s3c2412/s3c2412.c                    |    2 +-
 arch/arm/mach-s3c2440/mach-osiris.c                |    2 +-
 arch/arm/mach-s3c2443/s3c2443.c                    |    2 +-
 arch/arm/mach-sa1100/irq.c                         |    2 +-
 arch/arm/oprofile/common.c                         |    2 +-
 arch/arm/plat-omap/gpio.c                          |    2 +-
 arch/arm/plat-s3c24xx/dma.c                        |    2 +-
 arch/arm/plat-s3c24xx/s3c244x.c                    |    4 +-
 arch/avr32/kernel/time.c                           |    2 +-
 arch/cris/arch-v32/drivers/iop_fw_load.c           |   11 +
 arch/ia64/kernel/topology.c                        |   26 +-
 arch/mips/kernel/i8259.c                           |    2 +-
 arch/powerpc/platforms/cell/spu_base.c             |    2 +-
 arch/powerpc/platforms/powermac/pic.c              |    2 +-
 arch/powerpc/platforms/pseries/power.c             |   32 +-
 arch/powerpc/sysdev/ipic.c                         |    2 +-
 arch/powerpc/sysdev/mpic.c                         |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |    2 +-
 arch/ppc/syslib/ipic.c                             |    2 +-
 arch/ppc/syslib/open_pic.c                         |    2 +-
 arch/ppc/syslib/open_pic2.c                        |    2 +-
 arch/s390/hypfs/inode.c                            |   13 +-
 arch/s390/kernel/ipl.c                             |  147 +-
 arch/s390/kernel/time.c                            |    2 +-
 arch/sh/drivers/dma/dma-sysfs.c                    |    2 +-
 arch/sh/kernel/cpu/sh4/sq.c                        |   13 +-
 arch/sh/kernel/time.c                              |    2 +-
 arch/x86/kernel/apic_32.c                          |    2 +-
 arch/x86/kernel/apic_64.c                          |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |   24 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c                |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c            |   30 +-
 arch/x86/kernel/cpuid.c                            |    6 +-
 arch/x86/kernel/i8237.c                            |    2 +-
 arch/x86/kernel/i8259_32.c                         |    2 +-
 arch/x86/kernel/i8259_64.c                         |    2 +-
 arch/x86/kernel/io_apic_32.c                       |    2 +-
 arch/x86/kernel/io_apic_64.c                       |    2 +-
 arch/x86/kernel/msr.c                              |    6 +-
 arch/x86/kernel/nmi_32.c                           |    2 +-
 arch/x86/kernel/nmi_64.c                           |    2 +-
 arch/x86/oprofile/nmi_int.c                        |    2 +-
 block/elevator.c                                   |    8 +-
 block/genhd.c                                      |  419 ++---
 block/ll_rw_blk.c                                  |   11 +-
 drivers/acpi/bus.c                                 |   11 +-
 drivers/acpi/pci_link.c                            |    2 +-
 drivers/acpi/system.c                              |   13 +-
 drivers/base/Makefile                              |    3 +
 drivers/base/attribute_container.c                 |    9 +-
 drivers/base/base.h                                |   64 +-
 drivers/base/bus.c                                 |  501 +++---
 drivers/base/class.c                               |  319 +++-
 drivers/base/core.c                                |  582 +++---
 drivers/base/cpu.c                                 |    2 +-
 drivers/base/dd.c                                  |  164 +-
 drivers/base/driver.c                              |  216 ++-
 drivers/base/firmware.c                            |   26 +-
 drivers/base/hypervisor.c                          |   12 +-
 drivers/base/init.c                                |   10 +-
 drivers/base/memory.c                              |    2 +-
 drivers/base/module.c                              |   94 +
 drivers/base/node.c                                |    2 +-
 drivers/base/platform.c                            |  239 ++--
 drivers/base/power/Makefile                        |    1 -
 drivers/base/power/main.c                          |  502 ++++--
 drivers/base/power/power.h                         |   19 +-
 drivers/base/power/shutdown.c                      |   48 -
 drivers/base/sys.c                                 |   49 +-
 drivers/block/aoe/aoeblk.c                         |   51 +-
 drivers/block/aoe/aoechr.c                         |    7 +-
 drivers/block/nbd.c                                |   15 +-
 drivers/block/paride/pg.c                          |    6 +-
 drivers/block/paride/pt.c                          |   12 +-
 drivers/block/pktcdvd.c                            |   27 +-
 drivers/char/Kconfig                               |   10 +
 drivers/char/Makefile                              |    1 +
 drivers/char/hvc_console.c                         |   80 +-
 drivers/char/hvcs.c                                |   78 +-
 drivers/char/nozomi.c                              | 1993 ++++++++++++++++++++
 drivers/cpufreq/cpufreq.c                          |   12 +-
 drivers/cpuidle/sysfs.c                            |   21 +-
 drivers/dma/dmaengine.c                            |   43 +-
 drivers/edac/edac_device_sysfs.c                   |   49 +-
 drivers/edac/edac_mc_sysfs.c                       |   40 +-
 drivers/edac/edac_module.c                         |    2 +-
 drivers/edac/edac_pci_sysfs.c                      |   35 +-
 drivers/firmware/edd.c                             |   25 +-
 drivers/firmware/efivars.c                         |  130 +-
 drivers/i2c/chips/isp1301_omap.c                   |    6 -
 drivers/ide/ide-probe.c                            |    2 +-
 drivers/ide/ide-tape.c                             |   14 +-
 drivers/ieee1394/nodemgr.c                         |  314 ++--
 drivers/infiniband/core/sysfs.c                    |   39 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |   13 +-
 drivers/infiniband/hw/ipath/ipath_driver.c         |   17 +-
 drivers/infiniband/hw/ipath/ipath_kernel.h         |    3 +-
 drivers/infiniband/hw/ipath/ipath_sysfs.c          |   30 +-
 drivers/isdn/capi/capi.c                           |    6 +-
 drivers/isdn/gigaset/gigaset.h                     |    6 -
 drivers/kvm/kvm_main.c                             |    2 +-
 drivers/macintosh/adb.c                            |    2 +-
 drivers/macintosh/via-pmu.c                        |    2 +-
 drivers/md/dm.c                                    |    4 +-
 drivers/md/md.c                                    |   31 +-
 drivers/mfd/ucb1x00-assabet.c                      |   17 +-
 drivers/mfd/ucb1x00-core.c                         |   14 +-
 drivers/mfd/ucb1x00.h                              |    4 +-
 drivers/misc/ibmasm/command.c                      |   12 +-
 drivers/misc/ibmasm/ibmasm.h                       |   10 +-
 drivers/misc/tifm_7xx1.c                           |    4 +-
 drivers/misc/tifm_core.c                           |   24 +-
 drivers/mtd/mtdchar.c                              |   12 +-
 drivers/net/ibmveth.c                              |   12 +-
 drivers/net/iseries_veth.c                         |   19 +-
 drivers/net/wan/cosa.c                             |    5 +-
 drivers/parisc/pdc_stable.c                        |  194 +-
 drivers/pci/hotplug/acpiphp_ibm.c                  |    4 +-
 drivers/pci/hotplug/pci_hotplug_core.c             |   39 +-
 drivers/pci/hotplug/rpadlpar_sysfs.c               |  113 +-
 drivers/pci/pci-driver.c                           |   59 +-
 drivers/pci/probe.c                                |   11 +-
 drivers/pcmcia/ds.c                                |    3 +-
 drivers/power/apm_power.c                          |  116 +-
 drivers/power/power_supply_core.c                  |   74 +-
 drivers/rtc/interface.c                            |   22 +-
 drivers/s390/net/netiucv.c                         |   16 +-
 drivers/s390/scsi/zfcp_ccw.c                       |   14 +-
 drivers/s390/scsi/zfcp_ext.h                       |    3 +-
 drivers/s390/scsi/zfcp_sysfs_driver.c              |   27 +-
 drivers/scsi/hosts.c                               |   24 +-
 drivers/scsi/libsas/sas_scsi_host.c                |    2 +-
 drivers/serial/icom.c                              |   24 +-
 drivers/serial/icom.h                              |    2 +-
 drivers/spi/spi.c                                  |   26 +-
 drivers/uio/uio.c                                  |   95 +-
 drivers/usb/core/driver.c                          |    8 +-
 fs/block_dev.c                                     |    8 +-
 fs/char_dev.c                                      |    6 +-
 fs/coda/psdev.c                                    |    8 +-
 fs/configfs/mount.c                                |   13 +-
 fs/debugfs/inode.c                                 |   13 +-
 fs/dlm/lockspace.c                                 |   50 +-
 fs/ecryptfs/main.c                                 |  129 +--
 fs/fuse/inode.c                                    |   26 +-
 fs/gfs2/locking/dlm/sysfs.c                        |   38 +-
 fs/gfs2/sys.c                                      |   29 +-
 fs/namespace.c                                     |   11 +-
 fs/ocfs2/cluster/masklog.c                         |    4 +-
 fs/ocfs2/cluster/sys.c                             |   83 +-
 fs/partitions/check.c                              |  327 ++---
 fs/sysfs/dir.c                                     |    2 +-
 fs/sysfs/file.c                                    |   67 +-
 fs/sysfs/symlink.c                                 |   88 +-
 include/acpi/acpi_bus.h                            |    2 +-
 include/linux/device.h                             |  360 ++--
 include/linux/dmaengine.h                          |    3 +-
 include/linux/fs.h                                 |    2 +-
 include/linux/genhd.h                              |   37 +-
 include/linux/kobject.h                            |  184 +--
 include/linux/kref.h                               |    1 +
 include/linux/module.h                             |   19 +-
 include/linux/pci_hotplug.h                        |    2 +-
 include/linux/pktcdvd.h                            |    2 +-
 include/linux/platform_device.h                    |    2 +-
 include/linux/sched.h                              |    9 +-
 include/linux/sysdev.h                             |    1 +
 include/linux/tifm.h                               |    2 +-
 include/linux/uio_driver.h                         |    6 +-
 include/rdma/ib_verbs.h                            |    2 +-
 init/Kconfig                                       |    1 +
 init/do_mounts.c                                   |  108 +-
 kernel/ksysfs.c                                    |   82 +-
 kernel/module.c                                    |  128 +--
 kernel/params.c                                    |   44 +-
 kernel/power/disk.c                                |   20 +-
 kernel/power/main.c                                |   23 +-
 kernel/power/power.h                               |    4 +-
 kernel/rtmutex-tester.c                            |    2 +-
 kernel/time/clocksource.c                          |    2 +-
 kernel/time/timekeeping.c                          |    2 +-
 kernel/user.c                                      |  107 +-
 lib/kobject.c                                      |  734 +++++---
 lib/kobject_uevent.c                               |   38 +-
 lib/kref.c                                         |   15 +-
 mm/slub.c                                          |   23 +-
 net/bridge/br_if.c                                 |   12 +-
 net/bridge/br_private.h                            |    2 +-
 net/bridge/br_sysfs_br.c                           |   14 +-
 net/bridge/br_sysfs_if.c                           |    2 +-
 samples/Kconfig                                    |   10 +
 samples/Makefile                                   |    2 +-
 samples/kobject/Makefile                           |    1 +
 samples/kobject/kobject-example.c                  |  137 ++
 samples/kobject/kset-example.c                     |  278 +++
 security/inode.c                                   |   11 +-
 217 files changed, 8870 insertions(+), 4631 deletions(-)
 create mode 100644 Documentation/zh_CN/CodingStyle
 create mode 100644 Documentation/zh_CN/SubmittingDrivers
 create mode 100644 Documentation/zh_CN/SubmittingPatches
 create mode 100644 Documentation/zh_CN/oops-tracing.txt
 create mode 100644 Documentation/zh_CN/sparse.txt
 create mode 100644 Documentation/zh_CN/stable_kernel_rules.txt
 create mode 100644 Documentation/zh_CN/volatile-considered-harmful.txt
 create mode 100644 drivers/base/module.c
 delete mode 100644 drivers/base/power/shutdown.c
 create mode 100644 drivers/char/nozomi.c
 create mode 100644 samples/kobject/Makefile
 create mode 100644 samples/kobject/kobject-example.c
 create mode 100644 samples/kobject/kset-example.c

---------------

Alan Stern (2):
      Driver core: fix race in __device_release_driver
      Kobject: drop child->parent ref at unregistration

Bryan Wu (1):
      Chinese: add translation of volatile-considered-harmful.txt

Cornelia Huck (4):
      driver core: Introduce default attribute groups.
      netiucv: Use device_driver default attribute groups.
      zfcp: Use device_driver default attribute groups.
      Driver core: Cleanup get_device_parent() in device_add() and device_move()

Dave Young (7):
      Chinese: add translation of oops-tracing.txt
      Driver Core: add class iteration api
      ieee1394: use class iteration api
      power supply : use class iteration api
      rtc: use class iteration api
      scsi: use class iteration api
      spi: use class iteration api

Denis Cheng (1):
      Driver core: use LIST_HEAD instead of call to INIT_LIST_HEAD in __init

Emil Medve (1):
      driver core: Make the dev_*() family of macros in device.h complete

Evgeniy Polyakov (1):
      kref: add kref_set()

Frank Seidel (1):
      nozomi driver

Greg Kroah-Hartman (140):
      kobject: remove incorrect comment in kobject_rename
      ecryptfs: clean up attribute mess
      kobject: convert ibmasm to use kref, not kobject
      kobject: convert hvc_console to use kref, not kobject
      kobject: convert hvcs to use kref, not kobject
      kobject: convert icom to use kref, not kobject
      kobject: fix up kobject_set_name to use kvasprintf
      kobject: make kobject_cleanup be static
      kobject: add kobject_init_ng function
      kobject: add kobject_add_ng function
      kobject: add kobject_init_and_add function
      kobject: remove struct kobj_type from struct kset
      kobject: remove kobj_set_kset_s as no one is using it anymore
      kset: add kset_create_and_add function
      kobject: add kobject_create_and_add function
      kobject: get rid of kobject_add_dir
      kobject: get rid of kobject_kset_add_dir
      kobject: convert fuse to use kobject_create
      kobject: convert securityfs to use kobject_create
      kobject: convert debugfs to use kobject_create
      kobject: convert configfs to use kobject_create
      kset: convert ecryptfs to use kset_create
      kobject: convert main fs kobject to use kobject_create
      kset: convert gfs2 to use kset_create
      kset: convert gfs2 dlm to use kset_create
      kset: convert dlm to use kset_create
      kset: convert pci hotplug to use kset_create_and_add
      kset: remove decl_subsys_name
      kset: convert kernel_subsys to use kset_create
      kset: convert drivers/base/bus.c to use kset_create
      kset: convert drivers/base/class.c to use kset_create
      kset: convert drivers/base/firmware.c to use kset_create
      kset: convert /sys/devices to use kset_create
      kobject: convert /sys/hypervisor to use kobject_create
      kobject: convert s390 hypervisor to use kobject_create
      kset: convert /sys/devices/system to use kset_create
      kset: convert slub to use kset_create
      kset: move /sys/slab to /sys/kernel/slab
      kset: convert /sys/module to use kset_create
      kset: convert /sys/power to use kset_create
      kset: convert struct bus_device->devices to use kset_create
      kset: convert struct bus_device->drivers to use kset_create
      ecryptfs: remove version_str file from sysfs
      efivars: make new_var and del_var binary sysfs files
      kobject: convert efivars to kobj_attr interface
      firmware: export firmware_kset so that people can use that instead of the braindead firmware_register interface
      kset: convert efivars to use kset_create for the efi subsystem.
      kset: convert efivars to use kset_create for the vars sub-subsystem.
      kobject: convert arm/mach-omap1/pm.c to kobj_attr interface
      kobject: convert pseries/power.c to kobj_attr interface
      kobject: convert s390 ipl.c to kobj_attr interface
      kset: convert s390 ipl.c to use kset_create
      kobject: convert parisc/pdc_stable to kobj_attr interface
      kset: convert parisc/pdc_stable.c to use kset_create
      kset: convert edd to use kset_create
      kobject: convert /sys/firmware/acpi/ to use kobject_create
      firmware: remove firmware_(un)register()
      firmware: change firmware_kset to firmware_kobj
      kset: convert ocfs2 to use kset_create
      kset: convert block_subsys to use kset_create
      kset: remove decl_subsys macro
      kobject: convert kernel_kset to be a kobject
      kobject: remove subsystem_(un)register functions
      kobject: clean up rpadlpar horrid sysfs abuse
      kobject: convert ecryptfs to use kobject_create
      kobject: convert efivars to use kobject_create
      kobject: convert parisc/pdc_stable to use kobject_create
      driver core: clean up shutdown.c
      driver core: clean up device_shutdown
      driver core: make /sys/power a kobject
      kobject: grab the kset reference in kobject_add, not kobject_init
      kobject: clean up debugging messages
      UIO: fix kobject usage
      Kobject: change net/bridge to use kobject_create_and_add
      Kobject: change GFS2 to use kobject_init_and_add
      Kobject: change drivers/infiniband to use kobject_init_and_add
      Kobject: change drivers/firmware/edd.c to use kobject_init_and_add
      Kobject: change drivers/firmware/efivars.c to use kobject_init_and_add
      Kobject: change drivers/cpufreq/cpufreq.c to use kobject_init_and_add
      Kobject: change drivers/edac to use kobject_init_and_add
      Kobject: change drivers/cpuidle/sysfs.c to use kobject_init_and_add
      Kobject: change drivers/pci/hotplug/pci_hotplug_core.c to use kobject_init_and_add
      Kobject: change drivers/base/sys.c to use kobject_init_and_add
      Kobject: change arch/x86/kernel/cpu/intel_cacheinfo.c to use kobject_init_and_add
      Kobject: change drivers/acpi/system.c to use kobject_create_and_add
      Kobject: change drivers/block/pktcdvd.c to use kobject_init_and_add
      Kobject: change arch/sh/kernel/cpu/sh4/sq.c to use kobject_init_and_add
      Kobject: change drivers/net/ibmveth.c to use kobject_init_and_add
      Kobject: change drivers/parisc/pdc_stable.c to use kobject_init_and_add
      Kobject: change arch/ia64/kernel/topology.c to use kobject_init_and_add
      Kobject: change drivers/md/md.c to use kobject_init_and_add
      Kobject: change arch/x86/kernel/cpu/mcheck/mce_amd_64.c to use kobject_create_and_add
      Kobject: change arch/x86/kernel/cpu/mcheck/mce_amd_64.c to use kobject_init_and_add
      Kobject: the cris iop_fw_load.c code is broken
      Kobject: convert drivers/base/class.c to use kobject_init/add_ng()
      Kobject: convert drivers/base/core.c to use kobject_init/add_ng()
      Kobject: convert drivers/net/iseries_veth.c to use kobject_init/add_ng()
      Kobject: convert fs/char_dev.c to use kobject_init/add_ng()
      Kobject: convert kernel/params.c to use kobject_init/add_ng()
      Kobject: convert kernel/user.c to use kobject_init/add_ng()
      Kobject: convert mm/slub.c to use kobject_init/add_ng()
      Kobject: convert net/bridge/br_if.c to use kobject_init/add_ng()
      driver core: remove owner field from struct bus_type
      driver core: add way to get to bus kset
      driver core: add way to get to bus device klist
      driver core: remove fields from struct bus_type
      USB: use proper call to driver_create_file
      PCMCIA: use proper call to driver_create_file
      PCI: use proper call to driver_create_file
      PCI: remove foolish code from pci-driver.c
      Infiniband: make ipath driver use default driver groups.
      Driver: add driver_add_kobj for looney iseries_veth driver
      Driver core: move the driver specific module code into the driver core
      Driver core: move the static kobject out of struct driver
      Driver core: clean up debugging messages
      Kobject: change drivers/base/bus to use kobject_init_and_add
      Kobject: convert block/elevator.c to use kobject_init/add_ng()
      Kobject: convert block/ll_rw_blk.c to use kobject_init/add_ng()
      Kobject: convert drivers/md/md.c to use kobject_init/add_ng()
      Kobject: convert kernel/module.c to use kobject_init/add_ng()
      Kobject: remove kobject_add() as no one uses it anymore
      Kobject: rename kobject_add_ng() to kobject_add()
      Kobject: remove kobject_init() as no one uses it anymore
      Kobject: rename kobject_init_ng() to kobject_init()
      Kobject: remove kobject_register()
      Kset: remove kset_add function
      Modules: remove unneeded release function
      Kobject: convert arch/* from kobject_unregister() to kobject_put()
      Kobject: convert drivers/* from kobject_unregister() to kobject_put()
      Kobject: convert fs/* from kobject_unregister() to kobject_put()
      Kobject: convert remaining kobject_unregister() to kobject_put()
      Kobject: remove kobject_unregister() as no one uses it anymore
      kobject: remove old, outdated documentation.
      kobject: update the kobject/kset documentation
      kobject: add sample code for how to use kobjects in a simple manner.
      kobject: add sample code for how to use ksets/ktypes/kobjects
      Driver core: fix coding style issues in device.h
      Kobject: fix coding style issues in kobject.h
      Kobject: fix coding style issues in kobject c files
      Driver core: coding style fixes

Jan Engelhardt (1):
      UIO: constify function pointer tables

Jean Delvare (1):
      sysfs: Fix a copy-n-paste typo in comment

Jiri Slaby (1):
      sysfs: remove SPIN_LOCK_UNLOCKED

Kay Sievers (11):
      coda: convert struct class_device to struct device
      sysfs: create optimal relative symlink targets
      Driver Core: add kobj_attribute handling
      Driver Core: switch all dynamic ksets to kobj_sysfs_ops
      fix struct user_info export's sysfs interaction
      Driver Core: kill subsys_attribute and default sysfs ops
      Driver core: fix class glue dir cleanup logic
      sysfs: fix /sys/module/*/holders after sysfs logic change
      Driver core: convert block from raw kobjects to core devices
      Kobject: auto-cleanup on final unref
      Driver core: change sysdev classes to use dynamic kobject names

Li Yang (5):
      Chinese: Add the known_regression URI to the HOWTO
      Chinese: rephrase English introduction in HOWTO
      Chinese: Change man-pages maintainer address in HOWOTO
      Chinese: add translation of SubmittingDrivers
      Chinese: add translation of sparse.txt

Rafael J. Wysocki (1):
      PM: Acquire device locks on suspend

Randy Dunlap (2):
      sysfs: make SYSFS_DEPRECATED depend on SYSFS
      driver core: fix build with SYSFS=n

Robert P. J. Day (1):
      Documentation: Replace obsolete "driverfs" with "sysfs".

Stephen Rothwell (1):
      Driver Core: constify the name passed to platform_device_register_simple

Tony Jones (11):
      aoechr: Convert from class_device to device
      DMA: Convert from class_device to device for DMA engine
      IDE: Convert from class_device to device for ide-tape
      ISDN: Convert from class_device to device for ISDN capi
      adb: Convert from class_device to device
      MCP_UCB1200: Convert from class_device to device
      mtd: Convert from class_device to device for MTD/mtdchar
      paride: Convert from class_device to device for block/paride
      pktcdvd: Convert from class_device to device for block/pktcdvd
      tifm: Convert from class_device to device for TI flash media
      cosa: Convert from class_device to device for cosa sync driver

TripleX Chung (2):
      Chinese: add translation of SubmittingPatches
      Chinese: add translation of stable_kernel_rules.txt

Zhang Le (1):
      Chinese: add translation of Codingstyle

