Return-Path: <linux-kernel-owner+w=401wt.eu-S964885AbXG0Ntd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbXG0Ntd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933601AbXG0NtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:49:23 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:53768 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbXG0NtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:49:21 -0400
To: linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, kzak@redhat.com,
       ericvh@gmail.com, lucho@ionkov.net, zippel@linux-m68k.org,
       hpa@zytor.com, raven@themaw.net, rathamahata@php4.ru,
       dhowells@redhat.com, sfrench@samba.org, mhalcrow@us.ibm.com,
       phillip@hellewell.homeip.net, hirofumi@mail.parknet.co.jp,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
       shaggy@austin.ibm.com, vandrove@vc.cvut.cz, trond.myklebust@fys.uio.no,
       aia21@cantab.net, mark.fasheh@oracle.com, kurt.hackel@oracle.com,
       reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu,
       dushistov@mail.ru, xfs-masters@oss.sgi.com, arnd@arndb.de,
       holzheu@de.ibm.com
Subject: request for patches: showing mount options
Message-Id: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 27 Jul 2007 15:45:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[please consider pruning the CC list if discussing some aspect, which
doesn't concern all]

I've done an audit of all filesystems with regards to showing mount
options in /proc/<pid>/mounts.  Unfortunately most of them show none
or only a part of all accepted options (for details see list of
filesystems at the end of the mail).

This is currently not a big problem, because mount(8) stores the given
options in /etc/mtab.  However we want to get rid of mtab, and this
requires, that the option showing be fixed up.

It would be easiest if this was done by the VFS instead of having to
deal with it in filesystems.  However there are differences in how
filesytems handle options during mount and remount, and it would be
impossible to take this into account in all cases.

If you are CC-ed, and responsible for one of these filesystems, please
take a moment to fully implement the ->show_options() method.  In most
cases it should be an easy task.

If for some reason you are unable to do this, please let me know and
I'll fix it up.

Here are some guidelines for showing options.  I'll also add these to
Documentation/filesystems/vfs.txt

+   If a filesystem accepts mount options, it must define show_options()
+   to show all the currently active options.  The rules are:
+
+     - options MUST be shown which are not default or their values differ
+       from the default
+
+     - options MAY be shown which are enabled by default or have their
+       default value
+
+   Options used only internally between a mount helper and the kernel
+   (such as file descriptors), or which only have an effect during the
+   mounting (such as ones controlling the creation of a journal) are exempt
+   from the above rules.

Thanks,
Miklos

-------
legend:

  all - fs has options, but doesn't define ->show_options()
  some - fs defines ->show_options(), but some options are not shown
  noopt - fs does not have options
  good - fs shows all options
  patch - I have a patch


9p          some
adfs        all (maintainer?)
affs        all
afs         all
autofs      all
autofs4     some
befs        all
bfs         noopt
cifs        some (odd parser)
coda        noopt
configfs    noopt
cramfs      noopt
debugfs     noopt
devpts      patch
ecryptfs    some
efs         noopt
ext2        patch
ext3        patch
ext4        patch
fat         some
freevxfs    noopt
fuse        patch
gfs2        good
hfs         good
hfsplus     good
hostfs      patch
hpfs        all
hppfs       noopt
hugetlbfs   all
isofs       all (maintainer?)
jffs2       noopt
jfs         some
minix       noopt
msdos       ->fat
ncpfs       all (FS_BINARY_MOUNTDATA?)
nfs         some
nfsd        noopt
ntfs        good (odd parser)
ocfs2       all
openpromfs  noopt
proc        noopt
qnx4        noopt
ramfs       noopt
reiserfs    all
romfs       noopt
smbfs       good (odd parser) (maintainer?)
sysfs       noopt
sysv        noopt
udf         all
ufs         all
vfat        ->fat
xfs         some (odd parser)

mm/shmem.c                                    patch
drivers/oprofile/oprofilefs.c                 noopt
drivers/infiniband/hw/ipath/ipath_fs.c        noopt
drivers/misc/ibmasm/ibmasmfs.c                noopt
drivers/usb/core (usbfs)                      noopt
drivers/usb/gadget (gadgetfs)                 noopt
drivers/isdn/capi/capifs.c                    noopt
kernel/cpuset.c                               noopt
fs/binfmt_misc.c                              noopt
net/sunrpc/rpc_pipe.c                         noopt
arch/powerpc/platforms/cell/spufs             all
arch/s390/hypfs                               all
ipc/mqueue.c                                  noopt
security (securityfs)                         noopt
security/selinux/selinuxfs.c                  noopt

in -mm:

reiser4                some (odd parser)
kernel/container.c     good (odd parser)
