Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbYAXTil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbYAXTil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYAXTfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:09 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46545 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbYAXTeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:36 -0500
Message-Id: <20080124193416.379218079@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:42 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 01/26] mount options: add documentation
Content-Disposition: inline; filename=fs_options_doc.patch
Cc: Steve French <sfrench@us.ibm.com>, Lachlan McIlroy <lachlan@sgi.com>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Russell King <rmk@arm.linux.org.uk>,
       Roman Zippel <zippel@linux-m68k.org>,
       David Howells <dhowells@redhat.com>, Ian Kent <raven@themaw.net>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       Karsten Keil <kkeil@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Theodore Ts'o" <tytso@MIT.EDU>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jeff Dike <jdike@addtoit.com>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       William Irwin <wli@holomorphy.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Jeff Mahoney <jeffm@suse.com>, Paul Mackerras <paulus@samba.org>,
       Hugh Dickins <hugh@veritas.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This series addresses the problem of showing mount options in
/proc/mounts.

Several filesystems which use mount options, have not implemented a
.show_options superblock operation.  Several others have implemented
this callback, but have not kept it fully up to date with the parsed
options.

Q: Why do we need correct option showing in /proc/mounts?
A: We want /proc/mounts to fully replace /etc/mtab.  The reasons for
   this are:
    - unprivileged mounters won't be able to update /etc/mtab
    - /etc/mtab doesn't work with private mount namespaces
    - /etc/mtab can become out-of-sync with reality

Q: Can't this be done, so that filesystems need not bother with
   implementing a .show_mounts callback, and keeping it up to date?
A: Only in some cases.  Certain filesystems allow modification of a
   subset of options in their remount_fs method.  It is not possible
   to take this into account without knowing exactly how the
   filesystem handles options.

For the simple case (no remount or remount resets all options) the
patchset introduces two helpers:

  generic_show_options()
  save_mount_options()

These can also be used to emulate the old /etc/mtab behavior, until
proper support is added.  Even if this is not 100% correct, it's still
better than showing no options at all.

The following patches fix up most in-tree filesystems, they have been
compile tested only.  I would like to ask maintainers (CC-d on
respective patches) to please review, test and ACK these changes.

The following filesystems still need fixing: CIFS, NFS, XFS, Unionfs,
Reiser4.  For CIFS, NFS and XFS I wasn't able to understand how some
of the options are used.  The last two are not yet in mainline, so I
leave fixing those to their respective maintainers out of pure
laziness.

Table displaying status of all in-kernel filesystems:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
legend:

  none - fs has options, but doesn't define ->show_options()
  some - fs defines ->show_options(), but some only options are shown
  most - fs defines ->show_options(), and shows most of them
  good - fs shows all options
  noopt - fs does not have options
  patch - a patch will be posted

9p          good
adfs        patch
affs        patch
afs         patch
autofs      patch
autofs4     patch
befs        patch
bfs         noopt
cifs        some
coda        noopt
configfs    noopt
cramfs      noopt
debugfs     noopt
devpts      patch
ecryptfs    good
efs         noopt
ext2        patch
ext3        good
ext4        patch
fat         patch
freevxfs    noopt
fuse        patch
fusectl	    noopt
gfs2        good
gfs2meta    noopt
hfs         good
hfsplus     good
hostfs      patch
hpfs        patch
hppfs       noopt
hugetlbfs   patch
isofs       patch
jffs2       noopt
jfs         patch
minix       noopt
msdos       ->fat
ncpfs       patch
nfs         patch,most
nfsd        noopt
ntfs        good
ocfs2       good
ocfs2/dlmfs noopt
openpromfs  noopt
proc        noopt
qnx4        noopt
ramfs       noopt
reiserfs    patch
romfs       noopt
smbfs       good
sysfs       noopt
sysv        noopt
udf         patch
ufs         good
vfat        ->fat
xfs         most

mm/shmem.c                                    patch
drivers/oprofile/oprofilefs.c                 noopt
drivers/infiniband/hw/ipath/ipath_fs.c        noopt
drivers/misc/ibmasm/ibmasmfs.c                noopt
drivers/usb/core (usbfs)                      patch
drivers/usb/gadget (gadgetfs)                 noopt
drivers/isdn/capi/capifs.c                    patch
kernel/cpuset.c                               noopt
fs/binfmt_misc.c                              noopt
net/sunrpc/rpc_pipe.c                         noopt
arch/powerpc/platforms/cell/spufs             patch
arch/s390/hypfs                               good
ipc/mqueue.c                                  noopt
security (securityfs)                         noopt
security/selinux/selinuxfs.c                  noopt
kernel/cgroup.c                               good
security/smack/smackfs.c                      noopt

in -mm:

reiser4     some
unionfs     none
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

This patch:

Document the rules for handling mount options in the .show_options
super operation.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/Documentation/filesystems/vfs.txt
===================================================================
--- linux.orig/Documentation/filesystems/vfs.txt	2008-01-24 11:42:48.000000000 +0100
+++ linux/Documentation/filesystems/vfs.txt	2008-01-24 17:12:25.000000000 +0100
@@ -151,7 +151,7 @@ The get_sb() method has the following ar
   const char *dev_name: the device name we are mounting.
 
   void *data: arbitrary mount options, usually comes as an ASCII
-	string
+	string (see "Mount Options" section)
 
   struct vfsmount *mnt: a vfs-internal representation of a mount point
 
@@ -182,7 +182,7 @@ A fill_super() method implementation has
   	must initialize this properly.
 
   void *data: arbitrary mount options, usually comes as an ASCII
-	string
+	string (see "Mount Options" section)
 
   int silent: whether or not to be silent on error
 
@@ -291,7 +291,8 @@ or bottom half).
 
   umount_begin: called when the VFS is unmounting a filesystem.
 
-  show_options: called by the VFS to show mount options for /proc/<pid>/mounts.
+  show_options: called by the VFS to show mount options for
+	/proc/<pid>/mounts.  (see "Mount Options" section)
 
   quota_read: called by the VFS to read from filesystem quota file.
 
@@ -969,6 +970,45 @@ manipulate dentries:
 For further information on dentry locking, please refer to the document
 Documentation/filesystems/dentry-locking.txt.
 
+Mount Options
+=============
+
+Parsing options
+---------------
+
+On mount and remount the filesystem is passed a string containing a
+comma separated list of mount options.  The options can have either of
+these forms:
+
+  option
+  option=value
+
+The <linux/parser.h> header defines an API that helps parse these
+options.  There are plenty of examples on how to use it in existing
+filesystems.
+
+Showing options
+---------------
+
+If a filesystem accepts mount options, it must define show_options()
+to show all the currently active options.  The rules are:
+
+  - options MUST be shown which are not default or their values differ
+    from the default
+
+  - options MAY be shown which are enabled by default or have their
+    default value
+
+Options used only internally between a mount helper and the kernel
+(such as file descriptors), or which only have an effect during the
+mounting (such as ones controlling the creation of a journal) are exempt
+from the above rules.
+
+A simple method of saving options at mount/remount time and showing
+them is provided with the save_mount_options() and
+generic_show_options() helper functions.  Please note, that using
+these may have drawbacks.  For more info see header comments for these
+functions in fs/namespace.c.
 
 Resources
 =========

--
