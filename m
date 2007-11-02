Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbXKBX64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbXKBX64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 19:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbXKBX6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 19:58:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47433 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXKBX6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 19:58:48 -0400
Date: Fri, 2 Nov 2007 16:57:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com
Subject: [RFC] kobject and kset core changes and cleanups
Message-ID: <20071102235758.GA9803@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


So, I go on vacation for a week or so and come back to an overflowing
inbox.  Instead of trying to wade through all of that, I decide to
finish up the work Kay and I had started on cleaning up the kset core
code.

Here's a large patch series that is in my tree and should be for 2.6.25.
It does quite a few things:
	- lots of struct kset work and cleanup.  It's much simpler now
	  and will be documented while I still remember what is going
	  one...
	- almost all (only 5 left) struct kset are dynamically created
	  with the new function call, kset_create_and_register().  This
	  fixes up a lot of issues with static kobjects in structures
	  and other messy things like that.
	- struct bus_type is now split into two, a static and a dynamic
	  part.  The dynamic part is under control of the driver core,
	  and handles the ksets.  The static part is under control of
	  the bus that defined it.
	- decl_subsys() is now gone and buried, good riddance
	- subsys_attribute is now gone and replaced with:
	- kobj_attribute is now availble to make attributes for kobjects
	  MUCH simpler than ever before.  I've cleaned up some portions
	  of the kernel, and all older users of subsys_attribute have
	  been fixed.  This takes away one of the biggest complaints
	  about dealing with "raw" kobjects.
	- firmware subsystem has been all but removed as it was
	  pointless.


I'm posting the patches here so that people can take a look at them and
not be surprised when they go in to 2.6.25 in a few months and show up
in the next -mm releases.

One note, the efivars sysfs file removal patch is incorrect, and I'll be
fixing that up properly, so Matt, don't worry, I haven't forgotten :)

And hey, with all this work, we ended up removing more code than we
added, always a very good thing.

Now, on to face that scary inbox...

thanks,

greg k-h

---------------

 Documentation/vm/slabinfo.c            |    2 +-
 Documentation/vm/slub.txt              |    2 +-
 arch/arm/mach-omap1/pm.c               |   23 ++---
 arch/powerpc/platforms/pseries/power.c |   33 ++---
 arch/s390/hypfs/inode.c                |   15 ++-
 arch/s390/kernel/ipl.c                 |  149 +++++++++++++----------
 block/genhd.c                          |    5 +-
 drivers/acpi/bus.c                     |   12 ++-
 drivers/acpi/system.c                  |    2 +-
 drivers/base/base.h                    |   32 +++++-
 drivers/base/bus.c                     |  142 +++++++++++++--------
 drivers/base/class.c                   |   27 +++--
 drivers/base/core.c                    |   24 ++--
 drivers/base/dd.c                      |    4 +-
 drivers/base/driver.c                  |    2 +-
 drivers/base/firmware.c                |   27 ++---
 drivers/base/hypervisor.c              |   14 ++-
 drivers/base/platform.c                |    4 +-
 drivers/base/power/shutdown.c          |    2 +-
 drivers/base/sys.c                     |   31 ++---
 drivers/edac/edac_mc_sysfs.c           |    2 +-
 drivers/firmware/edd.c                 |   15 ++-
 drivers/firmware/efivars.c             |  214 ++++---------------------------
 drivers/parisc/pdc_stable.c            |  186 ++++++++++++++--------------
 drivers/pci/hotplug/acpiphp_ibm.c      |    4 +-
 drivers/pci/hotplug/pci_hotplug_core.c |   22 ++--
 drivers/pci/hotplug/rpadlpar_sysfs.c   |    2 +-
 drivers/pci/probe.c                    |   11 +-
 drivers/uio/uio.c                      |    2 +-
 fs/configfs/mount.c                    |   14 +-
 fs/debugfs/inode.c                     |   14 +-
 fs/dlm/lockspace.c                     |   22 ++--
 fs/ecryptfs/main.c                     |  130 +++----------------
 fs/fuse/inode.c                        |   27 +++--
 fs/gfs2/locking/dlm/sysfs.c            |   24 ++--
 fs/gfs2/sys.c                          |   15 +--
 fs/namespace.c                         |   14 ++-
 fs/ocfs2/cluster/masklog.c             |    4 +-
 fs/ocfs2/cluster/sys.c                 |   83 +++---------
 fs/sysfs/file.c                        |   65 ++--------
 include/acpi/acpi_bus.h                |    2 +-
 include/linux/device.h                 |   21 +---
 include/linux/fs.h                     |    2 +-
 include/linux/kobject.h                |   76 ++++--------
 include/linux/module.h                 |    3 +-
 include/linux/pci_hotplug.h            |    2 +-
 include/linux/sched.h                  |    9 +-
 kernel/ksysfs.c                        |   83 ++++++++-----
 kernel/module.c                        |    6 +-
 kernel/params.c                        |   26 ++---
 kernel/power/disk.c                    |   20 ++-
 kernel/power/main.c                    |   24 ++--
 kernel/power/power.h                   |    4 +-
 kernel/user.c                          |  104 ++++++++--------
 lib/kobject.c                          |  129 +++++++++++++++++---
 mm/slub.c                              |   20 ++--
 security/inode.c                       |   12 +-
 57 files changed, 900 insertions(+), 1065 deletions(-)

---------------

Greg Kroah-Hartman (50):
      ecryptfs: clean up attribute mess
      KOBJECT: remove struct kobj_type from struct kset
      KOBJECT: remove kobj_set_kset_s as no one is using it anymore
      kset: add kset_create_and_register function
      kset: convert fuse to use kset_create
      kset: convert securityfs to use kset_create
      kset: convert debugfs to use kset_create
      kset: convert configfs to use kset_create
      kset: convert ecryptfs to use kset_create
      kset: convert main fs kset to use kset_create
      kset: convert gfs2 to use kset_create
      kset: convert gfs2 dlm to use kset_create
      kset: convert dlm to use kset_create
      kset: convert pci hotplug to use kset_create_and_register
      kset: remove decl_subsys_name
      kset: convert kernel_subsys to use kset_create
      kset: convert drivers/base/bus.c kset_create_and_register
      kset: convert drivers/base/class.c kset_create_and_register
      kset: convert drivers/base/firmware.c kset_create_and_register
      kset: convert /sys/devices to use kset_create
      kset: convert /sys/hypervisor to use kset_create
      kset: convert /sys/devices/system to use kset_create
      kset: convert slub to use kset_create
      kset: move /sys/slab to /sys/kernel/slab
      kset: convert /sys/module to use kset_create
      kset: convert /sys/power to use kset_create
      kset: convert s390 hypervisor kset to use kset_create
      kset: convert struct bus_device->devices to use kset_create
      kset: convert struct bus_device->drivers to use kset_create
      driver core: remove owner field from struct bus_type
      driver core: add way to get to bus kset
      driver core: add way to get to bus device klist
      driver core: remove fields from struct bus_type
      ecryptfs: remove version_str file from sysfs
      efivars: remove new_var and del_var files from sysfs
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
      kset: convert acpi to use kset_create
      firmware: remove firmware_(un)register()
      kset: convert ocfs2 to use kset_create
      kset: remove decl_subsys macro

Kay Sievers (4):
      Driver Core: add kobj_attribute handling
      Driver Core: switch all dynamic ksets to kobj_sysfs_ops
      fix struct user_info export's sysfs interaction
      Driver Core: kill subsys_attribute and default sysfs ops

