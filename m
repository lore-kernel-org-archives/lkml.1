Return-Path: <linux-kernel-owner+w=401wt.eu-S965544AbXDGI23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbXDGI23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXDGIYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:24:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:60676 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965524AbXDGIXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=iUuB06Xh4g3GZHnew0jbTzkxFksxqoQ9MfUmg6zsHDSti7LPrWiaY1E5LKFUH2Pl+OrDFPilcEl8X8x2x9SvywL4HEnf4c8ZkQhnHJnT+h0ZK+85RJ2sM9usJigz0RynXEItf+g+vpdPlXWcZ8FWmZlmP9Ppy+sgRJbBvjeasKg=
Subject: [PATCHSET #master] sysfs: make sysfs disconnect immediately from kobject on deletion
In-Reply-To: 
X-Mailer: git-send-email
Date: Sat, 7 Apr 2007 17:23:46 +0900
Message-Id: <1175934226928-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset is result of the following thread.

  http://thread.gmane.org/gmane.linux.kernel/510293

This patchset takes sysfs out of device driver lifetime equation which
not not only fixes several race conditions caused by sysfs not holding
onto the proper module when referencing kobject, but also helps fixing
and simplifying lifetime management in driver model.

sysfs is peculiar in how it's intertwined with driver model via
kobject and fs layer by using dentry to record some of its hierarchy.
This not only complicates lifetime management outside of sysfs but
also inside sysfs proper.  We end up with several different yet
inter-dependent lifetime rules.

For example, dentry depends on sysfs_dirent for file accesses as any
dentry would depend on inode and its backing fs private data to do so,
while sysfs_dirent depends on dentry to walk sysfs_dirent tree for
internal purpose (symlink walk) and the initial access to the dentry
happens by going through kobject pointer.  This interdependcy is okay
while all the objects are on memory but hell breaks loose when it's
time to kill those objects.  dentry and sysfs_dirent depend on each
other.  Unless they go away at the same time or use some way to safely
break the loop, one side ends up with dangled pointer to the other.

This patchset solves this by making sysfs_dirent behave more like fs
internal inodes in other filesystems which don't depend on dentry or
other external entity to manage itself.  Most information is already
there.  Only sd->s_parent and s_name are added.  These do increase the
size of sysfs_dirent a bit but makes the logic look designed more in
Earth instead of Mars and with further changes, dentry and inode for
kobject can be made reclaimable which can probably compensate the
added space overhead.

Sysfs lifetime rules are much simpler now.  sd denotes sysfs_dirent.

* sd has default reference of 1 on creation which is dropped on
  deletion.

* dentry holds reference to sd.  dentry->d_fsdata can be safely
  dereferenced while referecne to dentry is held.

* sd->s_parent points to the parent sd and each child holds a
  reference to its parent which is released when the child is released
  (reference reaches zero), so sd->s_parent can be dereferenced
  recursively if reference to the sd is held.

* sd->s_name can always be read while sd is valid.

* sd->s_elem.dir.kobj should only be accessed while
  sd->s_elem.dir.rwsem is read locked, which can be done by calling
  sysfs_get_dir_kobj() on the sd.

* sd->s_elem.[bin_]attr.[bin_attr] should only be accessed while its
  parent's sd->s_elem.dir.rwsem is read locked.  If
  sysfs_get_dir_kobj() returns NULL, attr pointer might point to
  released area.

* sysfs doesn't reference foreign objects for internal purpose.
  Foreign objets are accessed from the callbacks or interface
  functions where the caller is responsible for guaranteeing
  accessbility - symlink interface function is currently an exception.
  sysfs should export sysfs_dirent based interface and kobject code
  should do the locking.

* Directory dentries are still pinned as they are used in interface
  function - this should change in the future.

This patchset is consisted of the following 14 patches.

#01	: fix i_no handling bug and reduce dependency to inode
#02	: fix error handling in binattr write
#03-05	: prep for symlink reimplementation
#06-07	: add s_parent and s_name
#08	: make s_elem a union so that chaning what it points to doesn't
	  cause chaos and s_elem can contain more than one pointer
#09	: implement kobj_sysfs_assoc_lock to protect kobj->s_dentry
	  which will be used to keep symlink interface compatible
#10	: reimplement symlink using only sysfs_dirent tree
#11	: implement bin_buffer for immediate-kobject-disconnect
#12	: implement immediate-kobject-disconnect
#13-14	: kill now obsolete stuff

The first 11 are some fixes and preparation for
immediate-kobject-disconnect.  Depencies to external objects are
gradually removed such that only accesses during file ops remain which
are converted by patch #12.  The last two patches remove now
unnecessary attribute orphaning and attribute->owner.

I've run the following test on a UP machine for several hours without
any oops or memory leak and the test is currently running on a dual
processor (hyperthreading) machine for about half an hour.  I'll keep
it running for at least 5 hours.

 # (cd kernel-build-dir; while true; do echo [Loading...]; insmod drivers/scsi/scsi_mod.ko; insmod drivers/scsi/sd_mod.ko; insmod drivers/ata/libata.ko; insmod drivers/ata/ahci.ko; sleep 1; echo [Unloading...]; while lsmod | grep -q sd_mod; do rmmod ahci; rmmod libata; rmmod sd_mod; rmmod scsi_mod; sleep .1; done; done) &
 # (cd /sys; while true; do ls -liR > /dev/null; done) &
 # (cd /sys; while true; do find . | xargs cat > /dev/null 2>&1; done) &
 # (cd /sys; while true; do find . | sort | xargs cat > /dev/null 2>&1; done) &

Three harddisks and a dvd writer are attached to on-board ahci
controller, so there are plenty of sysfs activities going on involving
symlinks and all.

Thanks.

--
tejun

 drivers/base/class.c                        |    2 -
 drivers/base/core.c                         |    4 -
 drivers/base/firmware_class.c               |    2 +-
 drivers/block/pktcdvd.c                     |    3 +-
 drivers/char/ipmi/ipmi_msghandler.c         |   10 -
 drivers/cpufreq/cpufreq_stats.c             |    3 +-
 drivers/cpufreq/cpufreq_userspace.c         |    2 +-
 drivers/cpufreq/freq_table.c                |    1 -
 drivers/firmware/dcdbas.h                   |    3 +-
 drivers/firmware/dell_rbu.c                 |    6 +-
 drivers/firmware/edd.c                      |    2 +-
 drivers/firmware/efivars.c                  |    6 +-
 drivers/i2c/chips/eeprom.c                  |    1 -
 drivers/i2c/chips/max6875.c                 |    1 -
 drivers/infiniband/core/sysfs.c             |    1 -
 drivers/input/mouse/psmouse.h               |    1 -
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |   13 --
 drivers/misc/asus-laptop.c                  |    3 +-
 drivers/pci/hotplug/acpiphp_ibm.c           |    1 -
 drivers/pci/pci-sysfs.c                     |    4 -
 drivers/pcmcia/socket_sysfs.c               |    2 +-
 drivers/rtc/rtc-ds1553.c                    |    1 -
 drivers/rtc/rtc-ds1742.c                    |    1 -
 drivers/scsi/arcmsr/arcmsr_attr.c           |    3 -
 drivers/scsi/lpfc/lpfc_attr.c               |    2 -
 drivers/scsi/qla2xxx/qla_attr.c             |    6 -
 drivers/spi/at25.c                          |    1 -
 drivers/video/aty/radeon_base.c             |    2 -
 drivers/video/backlight/backlight.c         |    2 +-
 drivers/video/backlight/lcd.c               |    2 +-
 drivers/w1/slaves/w1_ds2433.c               |    1 -
 drivers/w1/slaves/w1_therm.c                |    1 -
 drivers/w1/w1.c                             |    2 -
 fs/ecryptfs/main.c                          |    2 -
 fs/ocfs2/cluster/masklog.c                  |    1 -
 fs/partitions/check.c                       |    1 -
 fs/sysfs/bin.c                              |  189 ++++++++++++-------
 fs/sysfs/dir.c                              |  270 ++++++++++++++++-----------
 fs/sysfs/file.c                             |  206 ++++++++++-----------
 fs/sysfs/inode.c                            |   61 +------
 fs/sysfs/mount.c                            |   10 +-
 fs/sysfs/symlink.c                          |  121 ++++++-------
 fs/sysfs/sysfs.h                            |  109 ++++-------
 include/linux/sysdev.h                      |    3 +-
 include/linux/sysfs.h                       |    8 +-
 kernel/module.c                             |    9 +-
 kernel/params.c                             |    1 -
 net/bridge/br_sysfs_br.c                    |    3 +-
 net/bridge/br_sysfs_if.c                    |    3 +-
 49 files changed, 496 insertions(+), 596 deletions(-)


