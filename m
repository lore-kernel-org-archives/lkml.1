Return-Path: <linux-kernel-owner+w=401wt.eu-S1422838AbXBHAaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422838AbXBHAaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422839AbXBHAaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:30:20 -0500
Received: from ns1.suse.de ([195.135.220.2]:56290 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422838AbXBHAaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:30:18 -0500
Date: Wed, 7 Feb 2007 16:29:08 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 2.6.20
Message-ID: <20070208002908.GA4796@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of Driver core, sysfs, and driver model patches for
2.6.20-git

They include the conversion of the network drivers to use 'struct
device' instead of 'struct class' (the patch has been in -mm for over 6
months and was acked by David Miller) some module sysfs additions to
make userspace tools simpler, and lots of cleanups and fixes.  See the
full log below for details.

All of these have been in the -mm tree for quite a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

 Documentation/HOWTO                       |    1 +
 drivers/base/class.c                      |   21 ++-
 drivers/base/core.c                       |  203 +++++++++++++-------
 drivers/base/dd.c                         |   21 ++-
 drivers/base/firmware_class.c             |    2 +-
 drivers/base/platform.c                   |   11 +-
 drivers/ide/setup-pci.c                   |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   33 ++--
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c |   11 +-
 drivers/input/serio/serio.c               |    6 +-
 drivers/net/arm/at91_ether.c              |    2 +-
 drivers/net/arm/etherh.c                  |    2 +-
 drivers/net/bonding/bond_sysfs.c          |  287 +++++++++++++++++-----------
 drivers/net/iseries_veth.c                |    2 +-
 drivers/net/macb.c                        |   36 ++--
 drivers/net/smc911x.c                     |    2 +-
 drivers/net/smc91x.c                      |    2 +-
 drivers/net/wireless/hostap/hostap_main.c |    2 +-
 drivers/net/wireless/orinoco.c            |    4 +-
 drivers/net/wireless/orinoco_cs.c         |    2 +-
 drivers/net/wireless/spectrum_cs.c        |    2 +-
 drivers/pci/pci-driver.c                  |    4 +-
 drivers/pcmcia/cs.c                       |   34 ++--
 drivers/pcmcia/cs_internal.h              |    4 +-
 drivers/pcmcia/ds.c                       |   14 +-
 drivers/pcmcia/i82092.c                   |    2 +-
 drivers/pcmcia/i82365.c                   |    2 +-
 drivers/pcmcia/pcmcia_ioctl.c             |    1 -
 drivers/pcmcia/pcmcia_resource.c          |    1 -
 drivers/pcmcia/pd6729.c                   |    2 +-
 drivers/pcmcia/rsrc_nonstatic.c           |   56 +++---
 drivers/pcmcia/soc_common.c               |    6 +-
 drivers/pcmcia/socket_sysfs.c             |  104 ++++++-----
 drivers/pcmcia/tcic.c                     |    2 +-
 drivers/pcmcia/yenta_socket.c             |    2 +-
 drivers/spi/pxa2xx_spi.c                  |    2 +-
 drivers/spi/spi.c                         |   32 ++--
 drivers/spi/spi_bitbang.c                 |    6 +-
 drivers/spi/spi_butterfly.c               |    4 +-
 drivers/usb/core/driver.c                 |    4 +-
 drivers/usb/input/hid-lgff.c              |    4 +-
 fs/sysfs/bin.c                            |    6 +-
 fs/sysfs/dir.c                            |  214 ++++++++++++++++++----
 fs/sysfs/file.c                           |   82 ++++++---
 fs/sysfs/group.c                          |    2 +
 fs/sysfs/inode.c                          |   36 ++++-
 fs/sysfs/mount.c                          |   11 +-
 fs/sysfs/symlink.c                        |    1 +
 fs/sysfs/sysfs.h                          |   21 ++
 include/linux/device.h                    |   12 +-
 include/linux/ide.h                       |    4 +-
 include/linux/kobject.h                   |    4 +
 include/linux/module.h                    |    3 +-
 include/linux/netdevice.h                 |    5 +-
 include/linux/pci.h                       |    5 +-
 include/linux/serio.h                     |    5 +
 include/linux/spi/spi.h                   |   10 +-
 include/linux/sysfs.h                     |   24 ++-
 include/linux/usb.h                       |    5 +-
 include/pcmcia/ss.h                       |    2 +-
 kernel/module.c                           |   76 ++++++--
 kernel/params.c                           |   28 ++-
 lib/kobject.c                             |   73 ++++++--
 net/bridge/br_if.c                        |    2 +-
 net/bridge/br_sysfs_br.c                  |  234 +++++++++++++-----------
 net/bridge/br_sysfs_if.c                  |    2 +-
 net/core/dev.c                            |    6 +-
 net/core/net-sysfs.c                      |  175 ++++++++++--------
 net/core/skbuff.c                         |    2 +-
 69 files changed, 1286 insertions(+), 709 deletions(-)

---------------

Cornelia Huck (6):
      driver core: Remove device_is_registered() in device_move().
      driver core: Allow device_move(dev, NULL).
      driver core fixes: make_class_name() retval checks
      driver core fixes: device_register() retval check in platform.c
      driver core: Don't stop probing on ->probe errors.
      driver core: Change function call order in device_bind_driver().

Dave Jones (1):
      Driver Core: Increase the default timeout value of the firmware subsystem

Eric W. Biederman (1):
      sysfs: Shadow directory support

Frank Haverkamp (1):
      SYSFS: Fix missing include of list.h in sysfs.h

Frederik Deweerdt (1):
      sysfs: suppress lockdep warnings

Greg Kroah-Hartman (8):
      Kobject: make kobject apis more robust in handling NULL pointers
      Driver core: convert pcmcia code to use struct device
      Driver core: convert SPI code to use struct device
      Network: convert network devices to use struct device instead of class_device
      Modules: only add drivers/ direcory if needed
      PCI: add the sysfs driver name to all modules
      SERIO: add the sysfs driver name to all modules
      USB: add the sysfs driver name to all modules

Kay Sievers (5):
      MODULES: add the module name for built in kernel drivers
      /sys/modules/*/holders
      Driver core: add uevent vars for devices of a class
      Driver core: add device_type to struct device
      Driver core: allow to delay the uevent at device creation time

Mariusz Kozlowski (2):
      sysfs: kobject_put cleanup
      kobject: kobject_put cleanup

Oliver Neukum (2):
      Driver core: fix race in sysfs between sysfs_remove_file() and read()/write()
      sysfs: error handling in sysfs, fill_read_buffer()

Robert P. J. Day (1):
      HOWTO: Add a reference to Harbison and Steele

