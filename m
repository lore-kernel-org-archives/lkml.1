Return-Path: <linux-kernel-owner+w=401wt.eu-S934856AbXGKXbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934856AbXGKXbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932650AbXGKXbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:31:14 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49792 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643AbXGKXbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:31:13 -0400
Date: Wed, 11 Jul 2007 16:30:21 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] sysfs and driver core patches for 2.6.22
Message-ID: <20070711233021.GA5253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core and sysfs patches against your 2.6.22 git
tree.

The majority of the work here is a sysfs rework from Tejun that splits
the dependency between sysfs and kobjecs apart, fixing loads of
reference counting issues all at once.  This rework is needed for his
upcoming libata hotplug work.

DMI module autoloading is also added here, along with some power
management core work.

Also some documentation about the future of sysfs has been added.

All of these patches have been in the -mm tree for a few months.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

 .../firmware_sample_firmware_class.c               |    2 +
 Documentation/sysfs-rules.txt                      |  166 +++
 arch/arm/common/locomo.c                           |   11 +-
 arch/arm/common/sa1111.c                           |   13 +-
 arch/arm/mach-sa1100/neponset.c                    |   15 +-
 arch/ppc/syslib/mv64x60.c                          |    1 -
 arch/s390/kernel/ipl.c                             |    2 -
 drivers/base/attribute_container.c                 |    1 +
 drivers/base/base.h                                |    2 +-
 drivers/base/bus.c                                 |   24 +-
 drivers/base/class.c                               |   46 +-
 drivers/base/core.c                                |   58 +-
 drivers/base/dd.c                                  |   21 +-
 drivers/base/devres.c                              |    2 +
 drivers/base/firmware_class.c                      |    6 +-
 drivers/base/power/main.c                          |   44 +-
 drivers/base/power/power.h                         |    4 +-
 drivers/base/power/resume.c                        |   23 +-
 drivers/base/power/runtime.c                       |   12 +-
 drivers/base/power/suspend.c                       |   72 +-
 drivers/base/sys.c                                 |   24 +-
 drivers/block/pktcdvd.c                            |    3 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   10 -
 drivers/cpufreq/cpufreq_stats.c                    |    3 +-
 drivers/cpufreq/cpufreq_userspace.c                |    2 +-
 drivers/cpufreq/freq_table.c                       |    1 -
 drivers/firmware/Kconfig                           |    9 +
 drivers/firmware/Makefile                          |    1 +
 drivers/firmware/dcdbas.c                          |   10 +-
 drivers/firmware/dcdbas.h                          |    3 +-
 drivers/firmware/dell_rbu.c                        |   31 +-
 drivers/firmware/dmi-id.c                          |  222 ++++
 drivers/firmware/dmi_scan.c                        |   73 +-
 drivers/firmware/edd.c                             |    2 +-
 drivers/firmware/efivars.c                         |    6 +-
 drivers/i2c/chips/eeprom.c                         |    4 +-
 drivers/i2c/chips/max6875.c                        |    6 +-
 drivers/infiniband/core/sysfs.c                    |    1 -
 drivers/input/mouse/psmouse.h                      |    1 -
 drivers/macintosh/windfarm_core.c                  |    2 -
 drivers/misc/asus-laptop.c                         |    3 +-
 drivers/misc/msi-laptop.c                          |   44 +-
 drivers/net/ibmveth.c                              |    2 +-
 drivers/parisc/pdc_stable.c                        |    4 +-
 drivers/pci/hotplug/acpiphp_ibm.c                  |    7 +-
 drivers/pci/pci-sysfs.c                            |   22 +-
 drivers/pci/probe.c                                |    2 -
 drivers/pcmcia/socket_sysfs.c                      |   10 +-
 drivers/rapidio/rio-sysfs.c                        |    7 +-
 drivers/rtc/rtc-ds1553.c                           |   11 +-
 drivers/rtc/rtc-ds1742.c                           |   11 +-
 drivers/s390/cio/chp.c                             |   12 +-
 drivers/s390/net/qeth_sys.c                        |    2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c                  |   18 +-
 drivers/scsi/ipr.c                                 |   18 +-
 drivers/scsi/libsas/sas_expander.c                 |   17 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   14 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   56 +-
 drivers/spi/at25.c                                 |    7 +-
 drivers/usb/core/hub.c                             |    5 -
 drivers/video/aty/radeon_base.c                    |   10 +-
 drivers/video/backlight/backlight.c                |    2 +-
 drivers/video/backlight/lcd.c                      |    2 +-
 drivers/w1/slaves/w1_ds2433.c                      |   11 +-
 drivers/w1/slaves/w1_therm.c                       |    8 +-
 drivers/w1/w1.c                                    |   14 +-
 drivers/zorro/zorro-sysfs.c                        |    6 +-
 fs/debugfs/inode.c                                 |   63 +
 fs/ecryptfs/main.c                                 |    2 -
 fs/ocfs2/cluster/masklog.c                         |    1 -
 fs/partitions/check.c                              |    1 -
 fs/sysfs/bin.c                                     |  195 ++--
 fs/sysfs/dir.c                                     | 1297 ++++++++++++++------
 fs/sysfs/file.c                                    |  379 +++----
 fs/sysfs/group.c                                   |   55 +-
 fs/sysfs/inode.c                                   |  221 +---
 fs/sysfs/mount.c                                   |   36 +-
 fs/sysfs/symlink.c                                 |  150 ++--
 fs/sysfs/sysfs.h                                   |  169 ++--
 include/linux/debugfs.h                            |    9 +
 include/linux/device.h                             |    5 -
 include/linux/dmi.h                                |    8 +
 include/linux/idr.h                                |   29 +
 include/linux/kobject.h                            |    9 +-
 include/linux/pm.h                                 |    5 -
 include/linux/sysdev.h                             |    3 +-
 include/linux/sysfs.h                              |   43 +-
 kernel/module.c                                    |    9 +-
 kernel/params.c                                    |    1 -
 lib/idr.c                                          |  332 +++++-
 lib/kobject.c                                      |   19 +-
 net/bridge/br_sysfs_br.c                           |    8 +-
 net/bridge/br_sysfs_if.c                           |    3 +-
 93 files changed, 2822 insertions(+), 1494 deletions(-)
 create mode 100644 Documentation/sysfs-rules.txt
 create mode 100644 drivers/firmware/dmi-id.c

---------------

Adrian Bunk (1):
      Driver core: fix devres_release_all() return value

Cornelia Huck (1):
      Driver core: coding style cleanup

Jan Kara (1):
      debugfs: add rename for debugfs files

Kay Sievers (2):
      Rules on how to use sysfs in userspace programs
      Driver core: add missing kset uevent

Lennart Poettering (1):
      DMI-based module autoloading

Matthias Kaehlcke (2):
      sysdev: use mutex instead of semaphore
      Power Management: use mutexes instead of semaphores

Michael S. Tsirkin (1):
      Driver core: include linux/mutex.h from attribute_container.c

Rafael J. Wysocki (8):
      PM: Remove pm_parent from struct dev_pm_info
      PM: Remove saved_state from struct dev_pm_info
      PM: Simplify suspend_device
      PM: Remove prev_state from struct dev_pm_info
      PM: Remove power_state.event checks from suspend core code
      PM: Do not check parent state in suspend and resume core code
      PM: do not use saved_state from struct dev_pm_info on ARM
      sysfs: Fix oops in sysfs_drop_dentry on x86_64

Stefan Richter (2):
      driver core: properly get driver in device_release_driver
      driver core: fix kernel doc of device_release_driver

Tejun Heo (41):
      idr: fix obscure bug in allocation path
      idr: separate out idr_mark_full()
      ida: implement idr based id allocator
      sysfs: move release_sysfs_dirent() to dir.c
      sysfs: allocate inode number using ida
      sysfs: make sysfs_put() ignore NULL sd
      sysfs: fix error handling in binattr write()
      sysfs: flatten cleanup paths in sysfs_add_link() and create_dir()
      sysfs: flatten and fix sysfs_rename_dir() error handling
      sysfs: consolidate sysfs_dirent creation functions
      sysfs: add sysfs_dirent->s_parent
      sysfs: add sysfs_dirent->s_name
      sysfs: make sysfs_dirent->s_element a union
      sysfs: implement kobj_sysfs_assoc_lock
      sysfs: reimplement symlink using sysfs_dirent tree
      sysfs: implement bin_buffer
      sysfs: implement sysfs_dirent active reference and immediate disconnect
      sysfs: kill attribute file orphaning
      sysfs: separate out sysfs_attach_dentry()
      sysfs: reimplement sysfs_drop_dentry()
      sysfs: kill unnecessary attribute->owner
      driver-core: make devt_attr and uevent_attr static
      sysfs: make sysfs_alloc_ino() static
      sysfs: fix parent refcounting during rename and move
      sysfs: reorganize sysfs_new_indoe() and sysfs_create()
      sysfs: use iget_locked() instead of new_inode()
      sysfs: fix root sysfs_dirent -> root dentry association
      sysfs: move s_active functions to fs/sysfs/dir.c
      sysfs: slim down sysfs_dirent->s_active
      sysfs: use singly-linked list for sysfs_dirent tree
      sysfs: make sysfs_drop_dentry() access inodes using ilookup()
      sysfs: rename sysfs_dirent->s_type to s_flags and make room for flags
      sysfs: implement SYSFS_FLAG_REMOVED flag
      sysfs: implement sysfs_find_dirent() and sysfs_get_dirent()
      sysfs: make kobj point to sysfs_dirent instead of dentry
      sysfs: consolidate sysfs spinlocks
      sysfs: use sysfs_mutex to protect the sysfs_dirent tree
      sysfs: restructure add/remove paths and fix inode update
      sysfs: move sysfs_drop_dentry() to dir.c and make it static
      sysfs: implement sysfs_get_dentry()
      sysfs: make directory dentries and inodes reclaimable

Zhang Rui (1):
      sysfs: add parameter "struct bin_attribute *" in .read/.write methods for sysfs binary attributes

