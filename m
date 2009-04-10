Return-Path: <linux-kernel-owner+w=401wt.eu-S939079AbZDJHeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939079AbZDJHeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938110AbZDJHX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:23:58 -0400
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:62033 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938138AbZDJHXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:23:42 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 01/29] aufs documents
Date: Fri, 10 Apr 2009 16:02:15 +0900
Message-Id: <1239346963-30953-2-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
design and manual

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/filesystems/aufs/README              |  252 ++++
 Documentation/filesystems/aufs/aufs.5              | 1538 ++++++++++++++++++++
 Documentation/filesystems/aufs/design/01intro.txt  |  128 ++
 Documentation/filesystems/aufs/design/02struct.txt |  205 +++
 Documentation/filesystems/aufs/design/03lookup.txt |   95 ++
 Documentation/filesystems/aufs/design/04branch.txt |   67 +
 .../filesystems/aufs/design/05wbr_policy.txt       |   57 +
 .../filesystems/aufs/design/06fmode_exec.txt       |   24 +
 Documentation/filesystems/aufs/design/07mmap.txt   |   44 +
 Documentation/filesystems/aufs/design/08plan.txt   |  169 +++
 10 files changed, 2579 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/aufs/README
 create mode 100644 Documentation/filesystems/aufs/aufs.5
 create mode 100644 Documentation/filesystems/aufs/design/01intro.txt
 create mode 100644 Documentation/filesystems/aufs/design/02struct.txt
 create mode 100644 Documentation/filesystems/aufs/design/03lookup.txt
 create mode 100644 Documentation/filesystems/aufs/design/04branch.txt
 create mode 100644 Documentation/filesystems/aufs/design/05wbr_policy.txt
 create mode 100644 Documentation/filesystems/aufs/design/06fmode_exec.txt
 create mode 100644 Documentation/filesystems/aufs/design/07mmap.txt
 create mode 100644 Documentation/filesystems/aufs/design/08plan.txt

diff --git a/Documentation/filesystems/aufs/README b/Documentation/filesystems/aufs/README
new file mode 100644
index 0000000..82842af
--- /dev/null
+++ b/Documentation/filesystems/aufs/README
@@ -0,0 +1,252 @@
+
+Aufs2 -- advanced multi layered unification filesystem version 2
+http://aufs.sf.net
+Junjiro R. Okajima
+
+
+0. Introduction
+----------------------------------------
+In the early days, aufs was entirely re-designed and re-implemented
+Unionfs Version 1.x series. After many original ideas, approaches,
+improvements and implementations, it becomes totally different from
+Unionfs while keeping the basic features.
+Recently, Unionfs Version 2.x series begin taking some of the same
+approaches to aufs1's.
+Unionfs is being developed by Professor Erez Zadok at Stony Brook
+University and his team.
+
+This version of AUFS, aufs2 has several purposes.
+- to be reviewed easily and widely.
+- to make the source files simpler and smaller by dropping several
+  original features.
+
+Through this work, I found some bad things in aufs1 source code and
+fixed them. Some of the dropped features will be reverted in the future,
+but not all I'm afraid.
+Aufs2 supports linux-2.6.27 and later. If you want older kernel version
+support, try aufs1 from CVS on SourceForge.
+
+
+1. Features
+----------------------------------------
+- unite several directories into a single virtual filesystem. The member
+  directory is called as a branch.
+- you can specify the permission flags to the branch, which are 'readonly',
+  'readwrite' and 'whiteout-able.'
+- by upper writable branch, internal copyup and whiteout, files/dirs on
+  readonly branch are modifiable logically.
+- dynamic branch manipulation, add, del.
+- etc...
+
+Also there are many enhancements in aufs1, such as:
+- keep inode number by external inode number table
+- keep the timestamps of file/dir in internal copyup operation
+- seekable directory, supporting NFS readdir.
+- support mmap(2) including /proc/PID/exe symlink, without page-copy
+- whiteout is hardlinked in order to reduce the consumption of inodes
+  on branch
+- do not copyup, nor create a whiteout when it is unnecessary
+- revert a single systemcall when an error occurs in aufs
+- remount interface instead of ioctl
+- maintain /etc/mtab by an external command, /sbin/mount.aufs.
+- loopback mounted filesystem as a branch
+- kernel thread for removing the dir who has a plenty of whiteouts
+- support copyup sparse file (a file which has a 'hole' in it)
+- default permission flags for branches
+- selectable permission flags for ro branch, whether whiteout can
+  exist or not
+- export via NFS.
+- support <sysfs>/fs/aufs and <debugfs>/aufs.
+- support multiple writable branches, some policies to select one
+  among multiple writable branches.
+- a new semantics for link(2) and rename(2) to support multiple
+  writable branches.
+- no glibc changes are required.
+- pseudo hardlink (hardlink over branches)
+- allow a direct access manually to a file on branch, e.g. bypassing aufs.
+  including NFS or remote filesystem branch.
+- and more...
+
+Currently these features are dropped temporary from this version, aufs2.
+See design/08plan.txt in detail.
+- exporting via NFS
+- test only the highest one for the directory permission (dirperm1)
+- show whiteout mode (shwh)
+- copyup on open (coo=)
+- nested mount, i.e. aufs as readonly no-whiteout branch of another aufs
+  (robr)
+- statistics of aufs thread (/sys/fs/aufs/stat)
+- delegation mode (dlgt)
+  a delegation of the internal branch access to support task I/O
+  accounting, which also supports Linux Security Modules (LSM) mainly
+  for Suse AppArmor.
+- intent.open/create (file open in a single lookup)
+
+Features or just an idea in the future (see also design/*.txt),
+- reorder the branch index without del/re-add.
+- permanent xino files for NFSD
+- an option for refreshing the opened files after add/del branches
+- 'move' policy for copy-up between two writable branches, after
+  checking free space.
+- O_DIRECT
+- light version, without branch manipulation. (unnecessary?)
+- copyup in userspace
+- inotify in userspace
+- readv/writev
+- xattr, acl
+
+
+2. Download
+----------------------------------------
+Kindly one of aufs user, the Center for Scientific Computing and Free
+Software (C3SL), Federal University of Parana offered me a public GIT
+tree space.
+
+There are three GIT trees, aufs2-2.6, aufs2-standalone and aufs2-util.
+While the aufs2-util is always necessary, you need either of aufs2-2.6
+or aufs2-standalone.
+
+The aufs2-2.6 tree includes the whole linux-2.6 GIT tree,
+git://git.kernel.org/.../torvalds/linux-2.6.git.
+And you cannot select CONFIG_AUFS_FS=m for this version, eg. you cannot
+build aufs2 as an externel kernel module.
+If you already have linux-2.6 GIT tree, you may want to pull and merge
+the "aufs2" branch from this tree.
+
+On the other hand, the aufs2-standalone tree has only aufs2 source files
+and a necessary patch, and you can select CONFIG_AUFS_FS=m. In other
+words, the aufs2-standalone tree is generated from aufs2-2.6 tree by,
+- extract new files and modifications.
+- generate a single patch file from modifications.
+- generate a ChangeLog file from git-log.
+- commit the files newly and no log messages. this is not git-pull.
+
+Both of aufs2-2.6 and aufs2-standalone trees have a branch whose name is
+in form of "aufs2-xx" where "xx" represents the linux kernel version,
+"linux-2.6.xx".
+
+o aufs2-2.6 tree
+$ git clone --reference /your/linux-2.6/git/tree \
+	http://git.c3sl.ufpr.br/pub/scm/aufs/aufs2-2.6.git \
+	aufs2-2.6.git
+- if you don't have linux-2.6 GIT tree, then remove "--reference ..."
+$ cd aufs2-2.6.git
+$ git checkout origin/aufs2-xx	# for instance, aufs2-27 for linux-2.6.27
+				# aufs2 (no -xx) for the latest -rc version.
+
+o aufs2-standalone tree
+$ git clone http://git.c3sl.ufpr.br/pub/scm/aufs/aufs2-standalone.git \
+	aufs2-standalone.git
+$ cd aufs2-standalone.git
+$ git checkout origin/aufs2-xx	# for instance, aufs2-27 for linux-2.6.27
+				# aufs2 (no -xx) for the latest -rc version.
+- apply "aufs2-standalone.patch" to your kernel source files.
+
+o aufs2-util tree
+$ git clone http://git.c3sl.ufpr.br/pub/scm/aufs/aufs2-util.git \
+	aufs2-util.git
+$ cd aufs2-util.git
+- no particular tag/branch currently.
+
+
+3. Configuration and Compilation
+----------------------------------------
+For aufs2-2.6 tree,
+- enable CONFIG_EXPERIMENTAL and CONFIG_AUFS_FS.
+- set other aufs configurations if necessary.
+
+For aufs2-standalone tree,
+- enable CONFIG_EXPERIMENTAL and CONFIG_AUFS_FS, you can select =m.
+- edit fs/aufs/config.mk and set other aufs configurations if necessary.
+
+And then,
+- build your kernel (or a module) by "make"
+- install it and reboot your system
+- read README in aufs2-util, build and install it
+
+
+4. Usage
+----------------------------------------
+At first, make sure aufs2-util are installed, and please read the aufs
+manual, ./Documentation/filesystems/aufs/aufs.5.
+$ man -l aufs.5
+
+And then,
+$ mkdir /tmp/rw /tmp/aufs
+# mount -t aufs -o br=/tmp/rw:${HOME}=ro none /tmp/aufs
+
+Here is another example. The result is equivalent.
+# mount -t aufs -o br=/tmp/rw:${HOME} none /tmp/aufs
+  Or
+# mount -t aufs -o br:/tmp/rw none /tmp/aufs
+# mount -o remount,append:${HOME} /tmp/aufs
+
+Then, you can see whole tree of your home dir through /tmp/aufs. If
+you modify a file under /tmp/aufs, the one on your home directory is
+not affected, instead the same named file will be newly created under
+/tmp/rw. And all of your modification to a file will be applied to
+the one under /tmp/rw. This is called the file based Copy on Write
+(COW) method.
+Aufs mount options are described in aufs.5.
+
+Additionally, there are some sample usages of aufs which are a
+diskless system with network booting, and LiveCD over NFS.
+See sample dir in CVS tree on SourceForge.
+
+
+5. Contact
+----------------------------------------
+When you have any problems or strange behaviour in aufs, please let me
+know with:
+- /proc/mounts (instead of the output of mount(8))
+- /sys/module/aufs/*
+- /sys/fs/aufs/* (if you have them)
+- /debug/aufs/* (if you have them)
+- linux kernel version
+  if your kernel is not plain, for example modified by distributor,
+  the url where i can download its source is necessary too.
+- aufs version which was printed at loading the module or booting the
+  system, instead of the date you downloaded.
+- configuration (define/undefine CONFIG_AUFS_xxx)
+- kernel configuration or /proc/config.gz (if you have it)
+- behaviour which you think to be incorrect
+- actual operation, reproducible one is better
+- mailto: aufs-users at lists.sourceforge.net
+
+Usually, I don't watch the Public Areas(Bugs, Support Requests, Patches,
+and Feature Requests) on SourceForge. Please join and write to
+aufs-users ML.
+
+
+6. Acknowledgements
+----------------------------------------
+Thanks to everyone who have tried and are using aufs, whoever
+have reported a bug or any feedback.
+
+Especially donors:
+Tomas Matejicek(slax.org) made a donation (much more than once).
+Dai Itasaka made a donation (2007/8).
+Chuck Smith made a donation (2008/4, 10 and 12).
+Henk Schoneveld made a donation (2008/9).
+Chih-Wei Huang, ASUS, CTC donated Eee PC 4G (2008/10).
+Francois Dupoux made a donation (2008/11).
+Bruno Cesar Ribas and Luis Carlos Erpen de Bona, C3SL serves public GIT
+tree (2009/2).
+William Grant made a donation (2009/3).
+
+Thank you very much.
+Donations are always, including future donations, very important and
+helpful for me to keep on developing aufs.
+
+
+7.
+----------------------------------------
+If you are an experienced user, no explanation is needed. Aufs is
+just a linux filesystem.
+
+
+Enjoy!
+
+# Local variables: ;
+# mode: text;
+# End: ;
diff --git a/Documentation/filesystems/aufs/aufs.5 b/Documentation/filesystems/aufs/aufs.5
new file mode 100644
index 0000000..31fc0ab
--- /dev/null
+++ b/Documentation/filesystems/aufs/aufs.5
@@ -0,0 +1,1538 @@
+.ds AUFS_VERSION aufs2
+.ds AUFS_XINO_FNAME .aufs.xino
+.ds AUFS_XINO_DEFPATH /tmp/.aufs.xino
+.ds AUFS_DIRWH_DEF 3
+.ds AUFS_WH_PFX .wh.
+.ds AUFS_WH_PFX_LEN 4
+.ds AUFS_WKQ_NAME aufsd
+.ds AUFS_NWKQ_DEF 4
+.ds AUFS_WH_DIROPQ .wh..wh..opq
+.ds AUFS_WH_BASE .wh..wh.aufs
+.ds AUFS_WH_PLINKDIR .wh..wh.plnk
+.ds AUFS_BRANCH_MAX 127
+.ds AUFS_MFS_SECOND_DEF 30
+.\".so aufs.tmac
+.
+.eo
+.de TQ
+.br
+.ns
+.TP \$1
+..
+.de Bu
+.IP \(bu 4
+..
+.ec
+.\" end of macro definitions
+.
+.\" ----------------------------------------------------------------------
+.TH aufs 5 \*[AUFS_VERSION] Linux "Linux Aufs User\[aq]s Manual"
+.SH NAME
+aufs \- another unionfs. version \*[AUFS_VERSION]
+
+.\" ----------------------------------------------------------------------
+.SH DESCRIPTION
+Aufs is a stackable unification filesystem such as Unionfs, which unifies
+several directories and provides a merged single directory.
+In the early days, aufs was entirely re-designed and re-implemented
+Unionfs Version 1.x series. After
+many original ideas, approaches and improvements, it
+becomes totally different from Unionfs while keeping the basic features.
+See Unionfs Version 1.x series for the basic features.
+Recently, Unionfs Version 2.x series begin taking some of same
+approaches to aufs\[aq]s.
+
+.\" ----------------------------------------------------------------------
+.SH MOUNT OPTIONS
+At mount-time, the order of interpreting options is,
+.RS
+.Bu
+simple flags, except xino/noxino and udba=inotify
+.Bu
+branches
+.Bu
+xino/noxino
+.Bu
+udba=inotify
+.RE
+
+At remount-time,
+the options are interpreted in the given order,
+e.g. left to right.
+.RS
+.Bu
+create or remove
+whiteout-base(\*[AUFS_WH_BASE]) and
+whplink-dir(\*[AUFS_WH_PLINKDIR]) if necessary
+.RE
+.
+.TP
+.B br:BRANCH[:BRANCH ...] (dirs=BRANCH[:BRANCH ...])
+Adds new branches.
+(cf. Branch Syntax).
+
+Aufs rejects the branch which is an ancestor or a descendant of another
+branch. It is called overlapped. When the branch is loopback-mounted
+directory, aufs also checks the source fs-image file of loopback
+device. If the source file is a descendant of another branch, it will
+be rejected too.
+
+After mounting aufs or adding a branch, if you move a branch under
+another branch and make it descendant of another branch, aufs will not
+work correctly.
+.
+.TP
+.B [ add | ins ]:index:BRANCH
+Adds a new branch.
+The index begins with 0.
+Aufs creates
+whiteout-base(\*[AUFS_WH_BASE]) and
+whplink-dir(\*[AUFS_WH_PLINKDIR]) if necessary.
+
+If there is the same named file on the lower branch (larger index),
+aufs will hide the lower file.
+You can only see the highest file.
+You will be confused if the added branch has whiteouts (including
+diropq), they may or may not hide the lower entries.
+.\" It is recommended to make sure that the added branch has no whiteout.
+
+Even if a process have once mapped a file by mmap(2) with MAP_SHARED
+and the same named file exists on the lower branch,
+the process still refers the file on the lower(hidden)
+branch after adding the branch.
+If you want to update the contents of a process address space after
+adding, you need to restart your process or open/mmap the file again.
+.\" Usually, such files are executables or shared libraries.
+(cf. Branch Syntax).
+.
+.TP
+.B del:dir
+Removes a branch.
+Aufs does not remove
+whiteout-base(\*[AUFS_WH_BASE]) and
+whplink-dir(\*[AUFS_WH_PLINKDIR]) automatically.
+For example, when you add a RO branch which was unified as RW, you
+will see whiteout-base or whplink-dir on the added RO branch.
+
+If a process is referencing the file/directory on the deleting branch
+(by open, mmap, current working directory, etc.), aufs will return an
+error EBUSY.
+.
+.TP
+.B mod:BRANCH
+Modifies the permission flags of the branch.
+Aufs creates or removes
+whiteout-base(\*[AUFS_WH_BASE]) and/or
+whplink-dir(\*[AUFS_WH_PLINKDIR]) if necessary.
+
+If the branch permission is been changing \[oq]rw\[cq] to \[oq]ro\[cq], and a process
+is mapping a file by mmap(2)
+.\" with MAP_SHARED
+on the branch, the process may or may not
+be able to modify its mapped memory region after modifying branch
+permission flags.
+(cf. Branch Syntax).
+.
+.TP
+.B append:BRANCH
+equivalent to \[oq]add:(last index + 1):BRANCH\[cq].
+(cf. Branch Syntax).
+.
+.TP
+.B prepend:BRANCH
+equivalent to \[oq]add:0:BRANCH.\[cq]
+(cf. Branch Syntax).
+.
+.TP
+.B xino=filename
+Use external inode number bitmap and translation table.
+It is set to
+<FirstWritableBranch>/\*[AUFS_XINO_FNAME] by default, or
+\*[AUFS_XINO_DEFPATH].
+Comma character in filename is not allowed.
+
+The files are created per an aufs and per a branch filesystem, and
+unlinked. So you
+cannot find this file, but it exists and is read/written frequently by
+aufs.
+
+If you enable CONFIG_SYSFS, the path of xino files are not shown in
+/proc/mounts (and /etc/mtab), instead it is shown in
+<sysfs>/fs/aufs/si_<id>/xi_path.
+Otherwise, it is shown in /proc/mounts unless it is not the default
+path.
+(cf. External Inode Number Bitmap, Translation Table).
+.
+.TP
+.B noxino
+Stop using external inode number bitmap and translation table.
+
+If you use this option,
+Some applications will not work correctly.
+.\" And pseudo link feature will not work after the inode cache is
+.\" shrunk.
+(cf. External Inode Number Bitmap, Translation Table).
+.
+.TP
+.B trunc_xib
+Truncate the external inode number bitmap file. The truncation is done
+automatically when you delete a branch unless you do not specify
+\[oq]notrunc_xib\[cq] option.
+(cf. External Inode Number Bitmap, Translation Table).
+.
+.TP
+.B notrunc_xib
+Stop truncating the external inode number bitmap file when you delete
+a branch.
+(cf. External Inode Number Bitmap, Translation Table).
+.
+.TP
+.B create_policy | create=CREATE_POLICY
+.TQ
+.B copyup_policy | copyup | cpup=COPYUP_POLICY
+Policies to select one among multiple writable branches. The default
+values are \[oq]create=tdp\[cq] and \[oq]cpup=tdp\[cq].
+link(2) and rename(2) systemcalls have an exception. In aufs, they
+try keeping their operations in the branch where the source exists.
+(cf. Policies to Select One among Multiple Writable Branches).
+.
+.TP
+.B verbose | v
+Print some information.
+Currently, it is only busy file (or inode) at deleting a branch.
+.
+.TP
+.B noverbose | quiet | q | silent
+Disable \[oq]verbose\[cq] option.
+This is default value.
+.
+.TP
+.B sum
+df(1)/statfs(2) returns the total number of blocks and inodes of
+all branches.
+Note that there are cases that systemcalls may return ENOSPC, even if
+df(1)/statfs(2) shows that aufs has some free space/inode.
+.
+.TP
+.B nosum
+Disable \[oq]sum\[cq] option.
+This is default value.
+.
+.TP
+.B dirwh=N
+Watermark to remove a dir actually at rmdir(2) and rename(2).
+
+If the target dir which is being removed or renamed (destination dir)
+has a huge number of whiteouts, i.e. the dir is empty logically but
+physically, the cost to remove/rename the single
+dir may be very high.
+It is
+required to unlink all of whiteouts internally before issuing
+rmdir/rename to the branch.
+To reduce the cost of single systemcall,
+aufs renames the target dir to a whiteout-ed temporary name and
+invokes a pre-created
+kernel thread to remove whiteout-ed children and the target dir.
+The rmdir/rename systemcall returns just after kicking the thread.
+
+When the number of whiteout-ed children is less than the value of
+dirwh, aufs remove them in a single systemcall instead of passing
+another thread.
+This value is ignored when the branch is NFS.
+The default value is \*[AUFS_DIRWH_DEF].
+.
+.TP
+.B plink
+.TQ
+.B noplink
+Specifies to use \[oq]pseudo link\[cq] feature or not.
+The default is \[oq]plink\[cq] which means use this feature.
+(cf. Pseudo Link)
+.
+.TP
+.B clean_plink
+Removes all pseudo-links in memory.
+In order to make pseudo-link permanent, use
+\[oq]auplink\[cq] utility just before one of these operations,
+unmounting aufs,
+using \[oq]ro\[cq] or \[oq]noplink\[cq] mount option,
+deleting a branch from aufs,
+adding a branch into aufs,
+or changing your writable branch as readonly.
+If you installed both of /sbin/mount.aufs and /sbin/umount.aufs, and your
+mount(8) and umount(8) support them,
+\[oq]auplink\[cq] utility will be executed automatically and flush pseudo-links.
+(cf. Pseudo Link)
+.
+.TP
+.B udba=none | reval | inotify
+Specifies the level of UDBA (User\[aq]s Direct Branch Access) test.
+(cf. User\[aq]s Direct Branch Access and Inotify Limitation).
+.
+.TP
+.B diropq=whiteouted | w | always | a
+Specifies whether mkdir(2) and rename(2) dir case make the created directory
+\[oq]opaque\[cq] or not.
+In other words, to create \[oq]\*[AUFS_WH_DIROPQ]\[cq] under the created or renamed
+directory, or not to create.
+When you specify diropq=w or diropq=whiteouted, aufs will not create
+it if the
+directory was not whiteouted or opaqued. If the directory was whiteouted
+or opaqued, the created or renamed directory will be opaque.
+When you specify diropq=a or diropq==always, aufs will always create
+it regardless
+the directory was whiteouted/opaqued or not.
+The default value is diropq=w, it means not to create when it is unnecessary.
+If you define CONFIG_AUFS_COMPAT at aufs compiling time, the default will be
+diropq=a.
+You need to consider this option if you are planning to add a branch later
+since \[oq]diropq\[cq] affects the same named directory on the added branch.
+.
+.TP
+.B warn_perm
+.TQ
+.B nowarn_perm
+Adding a branch, aufs will issue a warning about uid/gid/permission of
+the adding branch directory,
+when they differ from the existing branch\[aq]s. This difference may or
+may not impose a security risk.
+If you are sure that there is no problem and want to stop the warning,
+use \[oq]nowarn_perm\[cq] option.
+The default is \[oq]warn_perm\[cq] (cf. DIAGNOSTICS).
+
+.\" ----------------------------------------------------------------------
+.SH Module Parameters
+.TP
+.B nwkq=N
+The number of kernel thread named \*[AUFS_WKQ_NAME].
+
+Those threads stay in the system while the aufs module is loaded,
+and handle the special I/O requests from aufs.
+The default value is \*[AUFS_NWKQ_DEF].
+
+The special I/O requests from aufs include a part of copy-up, lookup,
+directory handling, pseudo-link, xino file operations and the
+delegated access to branches.
+For example, Unix filesystems allow you to rmdir(2) which has no write
+permission bit, if its parent directory has write permission bit. In aufs, the
+removing directory may or may not have whiteout or \[oq]dir opaque\[cq] mark as its
+child. And aufs needs to unlink(2) them before rmdir(2).
+Therefore aufs delegates the actual unlink(2) and rmdir(2) to another kernel
+thread which has been created already and has a superuser privilege.
+
+If you enable CONFIG_SYSFS, you can check this value through
+<sysfs>/module/aufs/parameters/nwkq.
+
+.
+.TP
+.B brs=1 | 0
+Specifies to use the branch path data file under sysfs or not.
+
+If the number of your branches is large or their path is long
+and you meet the limitation of mount(8) ro /etc/mtab, you need to
+enable CONFIG_SYSFS and set aufs module parameter brs=1.
+
+When this parameter is set as 1, aufs does not show \[oq]br:\[cq] (or dirs=)
+mount option through /proc/mounts (and /etc/mtab). So you can
+keep yourself from the page limitation of
+mount(8) or /etc/mtab.
+Aufs shows branch paths through <sysfs>/fs/aufs/si_XXX/brNNN.
+Actually the file under sysfs has also a size limitation, but I don\[aq]t
+think it is harmful.
+
+There is one more side effect in setting 1 to this parameter.
+If you rename your branch, the branch path written in /etc/mtab will be
+obsoleted and the future remount will meet some error due to the
+unmatched parameters (Remember that mount(8) may take the options from
+/etc/mtab and pass them to the systemcall).
+If you set 1, /etc/mtab will not hold the branch path and you will not
+meet such trouble. On the other hand, the entires for the
+branch path under sysfs are generated dynamically. So it must not be obsoleted.
+But I don\[aq]t think users want to rename branches so often.
+
+If CONFIG_SYSFS is disable, this paramater is always set to 0.
+.
+.TP
+.B sysrq=key
+Specifies MagicSysRq key for debugging aufs.
+You need to enable both of CONFIG_MAGIC_SYSRQ and CONFIG_AUFS_DEBUG.
+Currently this is for developers only.
+The default is \[oq]a\[cq].
+.
+.TP
+.B debug= 0 | 1
+Specifies disable(0) or enable(1) debug print in aufs.
+This parameter can be changed dynamically.
+You need to enable CONFIG_AUFS_DEBUG.
+Currently this is for developers only.
+The default is \[oq]0\[cq] (disable).
+
+.\" ----------------------------------------------------------------------
+.SH Entries under Sysfs and Debugfs
+See linux/Documentation/ABI/*/{sys,debug}fs-aufs.
+
+.\" ----------------------------------------------------------------------
+.SH Branch Syntax
+.TP
+.B dir_path[ =permission [ + attribute ] ]
+.TQ
+.B permission := rw | ro | rr
+.TQ
+.B attribute := wh | nolwh
+dir_path is a directory path.
+The keyword after \[oq]dir_path=\[cq] is a
+permission flags for that branch.
+Comma, colon and the permission flags string (including \[oq]=\[cq])in the path
+are not allowed.
+
+Any filesystem can be a branch, But some are not accepted such like
+sysfs, procfs and unionfs.
+If you specify such filesystems as an aufs branch, aufs will return an error
+saying it is unsupported.
+
+Cramfs in linux stable release has strange inodes and it makes aufs
+confused. For example,
+.nf
+$ mkdir -p w/d1 w/d2
+$ > w/z1
+$ > w/z2
+$ mkcramfs w cramfs
+$ sudo mount -t cramfs -o ro,loop cramfs /mnt
+$ find /mnt -ls
+    76    1 drwxr-xr-x   1 jro      232            64 Jan  1  1970 /mnt
+     1    1 drwxr-xr-x   1 jro      232             0 Jan  1  1970 /mnt/d1
+     1    1 drwxr-xr-x   1 jro      232             0 Jan  1  1970 /mnt/d2
+     1    1 -rw-r--r--   1 jro      232             0 Jan  1  1970 /mnt/z1
+     1    1 -rw-r--r--   1 jro      232             0 Jan  1  1970 /mnt/z2
+.fi
+
+All these two directories and two files have the same inode with one
+as their link count. Aufs cannot handle such inode correctly.
+Currently, aufs involves a tiny workaround for such inodes. But some
+applications may not work correctly since aufs inode number for such
+inode will change silently.
+If you do not have any empty files, empty directories or special files,
+inodes on cramfs will be all fine.
+
+A branch should not be shared as the writable branch between multiple
+aufs. A readonly branch can be shared.
+
+The maximum number of branches is configurable at compile time.
+The current value is \*[AUFS_BRANCH_MAX] which depends upon
+configuration.
+
+When an unknown permission or attribute is given, aufs sets ro to that
+branch silently.
+
+.SS Permission
+.
+.TP
+.B rw
+Readable and writable branch. Set as default for the first branch.
+If the branch filesystem is mounted as readonly, you cannot set it \[oq]rw.\[cq]
+.\" A filesystem which does not support link(2) and i_op\->setattr(), for
+.\" example FAT, will not be used as the writable branch.
+.
+.TP
+.B ro
+Readonly branch and it has no whiteouts on it.
+Set as default for all branches except the first one. Aufs never issue
+both of write operation and lookup operation for whiteout to this branch.
+.
+.TP
+.B rr
+Real readonly branch, special case of \[oq]ro\[cq], for natively readonly
+branch. Assuming the branch is natively readonly, aufs can optimize
+some internal operation. For example, if you specify \[oq]udba=inotify\[cq]
+option, aufs does not set inotify for the things on rr branch.
+Set by default for a branch whose fs-type is either \[oq]iso9660\[cq],
+\[oq]cramfs\[cq] or \[oq]romfs\[cq].
+
+When your branch exists on slower device and you have some
+capacity on your hdd, you may want to try ulobdev tool in ULOOP sample.
+It can cache the contents of the real devices on another faster device,
+so you will be able to get the better access performance.
+The ulobdev tool is for a generic block device, and the ulohttp is for a
+filesystem image on http server.
+If you want to spin down your hdd to save the
+battery life or something, then you may want to use ulobdev to save the
+access to the hdd, too.
+See $AufsCVS/sample/uloop in detail.
+
+.SS Attribute
+.
+.TP
+.B wh
+Readonly branch and it has/might have whiteouts on it.
+Aufs never issue write operation to this branch, but lookup for whiteout.
+Use this as \[oq]<branch_dir>=ro+wh\[cq].
+.
+.TP
+.B nolwh
+Usually, aufs creates a whiteout as a hardlink on a writable
+branch. This attributes prohibits aufs to create the hardlinked
+whiteout, including the source file of all hardlinked whiteout
+(\*[AUFS_WH_BASE].)
+If you do not like a hardlink, or your writable branch does not support
+link(2), then use this attribute.
+But I am afraid a filesystem which does not support link(2) natively
+will fail in other place such as copy-up.
+Use this as \[oq]<branch_dir>=rw+nolwh\[cq].
+Also you may want to try \[oq]noplink\[cq] mount option, while it is not recommended.
+
+.\" .SS FUSE as a branch
+.\" A FUSE branch needs special attention.
+.\" The struct fuse_operations has a statfs operation. It is OK, but the
+.\" parameter is struct statvfs* instead of struct statfs*. So almost
+.\" all user\-space implementaion will call statvfs(3)/fstatvfs(3) instead of
+.\" statfs(2)/fstatfs(2).
+.\" In glibc, [f]statvfs(3) issues [f]statfs(2), open(2)/read(2) for
+.\" /proc/mounts,
+.\" and stat(2) for the mountpoint. With this situation, a FUSE branch will
+.\" cause a deadlock in creating something in aufs. Here is a sample
+.\" scenario,
+.\" .\" .RS
+.\" .\" .IN -10
+.\" .Bu
+.\" create/modify a file just under the aufs root dir.
+.\" .Bu
+.\" aufs aquires a write\-lock for the parent directory, ie. the root dir.
+.\" .Bu
+.\" A library function or fuse internal may call statfs for a fuse branch.
+.\" The create=mfs mode in aufs will surely call statfs for each writable
+.\" branches.
+.\" .Bu
+.\" FUSE in kernel\-space converts and redirects the statfs request to the
+.\" user\-space.
+.\" .Bu
+.\" the user\-space statfs handler will call [f]statvfs(3).
+.\" .Bu
+.\" the [f]statvfs(3) in glibc will access /proc/mounts and issue
+.\" stat(2) for the mountpoint. But those require a read\-lock for the aufs
+.\" root directory.
+.\" .Bu
+.\" Then a deadlock occurs.
+.\" .\" .RE 1
+.\" .\" .IN
+.\" 
+.\" In order to avoid this deadlock, I would suggest not to call
+.\" [f]statvfs(3) from fuse. Here is a sample code to do this.
+.\" .nf
+.\" struct statvfs stvfs;
+.\" 
+.\" main()
+.\" {
+.\" 	statvfs(..., &stvfs)
+.\" 	or
+.\" 	fstatvfs(..., &stvfs)
+.\" 	stvfs.f_fsid = 0
+.\" }
+.\" 
+.\" statfs_handler(const char *path, struct statvfs *arg)
+.\" {
+.\" 	struct statfs stfs
+.\" 
+.\" 	memcpy(arg, &stvfs, sizeof(stvfs))
+.\" 
+.\" 	statfs(..., &stfs)
+.\" 	or
+.\" 	fstatfs(..., &stfs)
+.\" 
+.\" 	arg->f_bfree = stfs.f_bfree
+.\" 	arg->f_bavail = stfs.f_bavail
+.\" 	arg->f_ffree = stfs.f_ffree
+.\" 	arg->f_favail = /* any value */
+.\" }
+.\" .fi
+
+.\" ----------------------------------------------------------------------
+.SH External Inode Number Bitmap, Translation Table (xino)
+Aufs uses one external bitmap file and one external inode number
+translation table files per an aufs and per a branch
+filesystem by default.
+The bitmap is for recycling aufs inode number
+and the others
+are a table for converting an inode number on a branch to
+an aufs inode number. The default path
+is \[oq]first writable branch\[cq]/\*[AUFS_XINO_FNAME].
+If there is no writable branch, the
+default path
+will be \*[AUFS_XINO_DEFPATH].
+.\" A user who executes mount(8) needs the privilege to create xino
+.\" file.
+
+If you enable CONFIG_SYSFS, the path of xino files are not shown in
+/proc/mounts (and /etc/mtab), instead it is shown in
+<sysfs>/fs/aufs/si_<id>/xi_path.
+Otherwise, it is shown in /proc/mounts unless it is not the default
+path.
+
+Those files are always opened and read/write by aufs frequently.
+If your writable branch is on flash memory device, it is recommended
+to put xino files on other than flash memory by specifying \[oq]xino=\[cq]
+mount option.
+
+The
+maximum file size of the bitmap is, basically, the amount of the
+number of all the files on all branches divided by 8 (the number of
+bits in a byte).
+For example, on a 4KB page size system, if you have 32,768 (or
+2,599,968) files in aufs world,
+then the maximum file size of the bitmap is 4KB (or 320KB).
+
+The
+maximum file size of the table will
+be \[oq]max inode number on the branch x size of an inode number\[cq].
+For example in 32bit environment,
+
+.nf
+$ df -i /branch_fs
+/dev/hda14           2599968  203127 2396841    8% /branch_fs
+.fi
+
+and /branch_fs is an branch of the aufs. When the inode number is
+assigned contiguously (without \[oq]hole\[cq]), the maximum xino file size for
+/branch_fs will be 2,599,968 x 4 bytes = about 10 MB. But it might not be
+allocated all of disk blocks.
+When the inode number is assigned discontinuously, the maximum size of
+xino file will be the largest inode number on a branch x 4 bytes.
+Additionally, the file size is limited to LLONG_MAX or the s_maxbytes
+in filesystem\[aq]s superblock (s_maxbytes may be smaller than
+LLONG_MAX). So the
+support-able largest inode number on a branch is less than
+2305843009213693950 (LLONG_MAX/4\-1).
+This is the current limitation of aufs.
+On 64bit environment, this limitation becomes more strict and the
+supported largest inode number is less than LLONG_MAX/8\-1.
+
+The xino files are always hidden, i.e. removed. So you cannot
+do \[oq]ls \-l xino_file\[cq].
+If you enable CONFIG_DEBUG_FS, you can check these information through
+<debugfs>/aufs/<si_id>/{xib,xi[0-9]*,xigen}. xib is for the bitmap file,
+xi0 ix for the first branch, and xi1 is for the next. xigen is for the
+generation table.
+xib and xigen are in the format of,
+
+.nf
+<blocks>x<block size> <file size>
+.fi
+
+Note that a filesystem usually has a
+feature called pre-allocation, which means a number of
+blocks are allocated automatically, and then deallocated
+silently when the filesystem thinks they are unnecessary.
+You do not have to be surprised the sudden changes of the number of
+blocks, when your filesystem which xino files are placed supports the
+pre-allocation feature.
+
+The rests are hidden xino file information in the format of,
+
+.nf
+<file count>, <blocks>x<block size> <file size>
+.fi
+
+If the file count is larger than 1, it means some of your branches are
+on the same filesystem and the xino file is shared by them.
+Note that the file size may not be equal to the actual consuming blocks
+since xino file is a sparse file, i.e. a hole in a file which does not
+consume any disk blocks.
+
+Once you unmount aufs, the xino files for that aufs are totally gone.
+It means that the inode number is not permanent across umount or
+shutdown.
+
+The xino files should be created on the filesystem except NFS.
+If your first writable branch is NFS, you will need to specify xino
+file path other than NFS.
+Also if you are going to remove the branch where xino files exist or
+change the branch permission to readonly, you need to use xino option
+before del/mod the branch.
+
+The bitmap file can be truncated.
+For example, if you delete a branch which has huge number of files,
+many inode numbers will be recycled and the bitmap will be truncated
+to smaller size. Aufs does this automatically when a branch is
+deleted.
+You can truncate it anytime you like if you specify \[oq]trunc_xib\[cq] mount
+option. But when the accessed inode number was not deleted, nothing
+will be truncated.
+If you do not want to truncate it (it may be slow) when you delete a
+branch, specify \[oq]notrunc_xib\[cq] after \[oq]del\[cq] mount option.
+
+If you do not want to use xino, use noxino mount option. Use this
+option with care, since the inode number may be changed silently and
+unexpectedly anytime.
+For example,
+rmdir failure, recursive chmod/chown/etc to a large and deep directory
+or anything else.
+And some applications will not work correctly.
+.\" When the inode number has been changed, your system
+.\" can be crazy.
+If you want to change the xino default path, use xino mount option.
+
+After you add branches, the persistence of inode number may not be
+guaranteed.
+At remount time, cached but unused inodes are discarded.
+And the newly appeared inode may have different inode number at the
+next access time. The inodes in use have the persistent inode number.
+
+When aufs assigned an inode number to a file, and if you create the
+same named file on the upper branch directly, then the next time you
+access the file, aufs may assign another inode number to the file even
+if you use xino option.
+Some applications may treat the file whose inode number has been
+changed as totally different file.
+
+.\" ----------------------------------------------------------------------
+.SH Pseudo Link (hardlink over branches)
+Aufs supports \[oq]pseudo link\[cq] which is a logical hard-link over
+branches (cf. ln(1) and link(2)).
+In other words, a copied-up file by link(2) and a copied-up file which was
+hard-linked on a readonly branch filesystem.
+
+When you have files named fileA and fileB which are
+hardlinked on a readonly branch, if you write something into fileA,
+aufs copies-up fileA to a writable branch, and write(2) the originally
+requested thing to the copied-up fileA. On the writable branch,
+fileA is not hardlinked.
+But aufs remembers it was hardlinked, and handles fileB as if it existed
+on the writable branch, by referencing  fileA\[aq]s inode on the writable
+branch as fileB\[aq]s inode.
+
+Once you unmount aufs, the plink info for that aufs kept in memory are totally
+gone.
+It means that the pseudo-link is not permanent.
+If you want to make plink permanent, try \[oq]auplink\[cq] utility just before
+one of these operations,
+unmounting your aufs,
+using \[oq]ro\[cq] or \[oq]noplink\[cq] mount option,
+deleting a branch from aufs,
+adding a branch into aufs,
+or changing your writable branch to readonly.
+
+This utility will reproduces all real hardlinks on a writable branch by linking
+them, and removes pseudo-link info in memory and temporary link on the
+writable branch.
+Since this utility access your branches directly, you cannot hide them by
+\[oq]mount \-\-bind /tmp /branch\[cq] or something.
+
+If you are willing to rebuild your aufs with the same branches later, you
+should use auplink utility before you umount your aufs.
+If you installed both of /sbin/mount.aufs and /sbin/umount.aufs, and your
+mount(8) and umount(8) support them,
+\[oq]auplink\[cq] utility will be executed automatically and flush pseudo-links.
+
+.nf
+# auplink /your/aufs/root flush
+# umount /your/aufs/root
+or
+# auplink /your/aufs/root flush
+# mount -o remount,mod:/your/writable/branch=ro /your/aufs/root
+or
+# auplink /your/aufs/root flush
+# mount -o remount,noplink /your/aufs/root
+or
+# auplink /your/aufs/root flush
+# mount -o remount,del:/your/aufs/branch /your/aufs/root
+or
+# auplink /your/aufs/root flush
+# mount -o remount,append:/your/aufs/branch /your/aufs/root
+.fi
+
+The plinks are kept both in memory and on disk. When they consumes too much
+resources on your system, you can use the \[oq]auplink\[cq] utility at anytime and
+throw away the unnecessary pseudo-links in safe.
+
+Additionally, the \[oq]auplink\[cq] utility is very useful for some security reasons.
+For example, when you have a directory whose permission flags
+are 0700, and a file who is 0644 under the 0700 directory. Usually,
+all files under the 0700 directory are private and no one else can see
+the file. But when the directory is 0711 and someone else knows the 0644
+filename, he can read the file.
+
+Basically, aufs pseudo-link feature creates a temporary link under the
+directory whose owner is root and the permission flags are 0700.
+But when the writable branch is NFS, aufs sets 0711 to the directory.
+When the 0644 file is pseudo-linked, the temporary link, of course the
+contents of the file is totally equivalent, will be created under the
+0711 directory. The filename will be generated by its inode number.
+While it is hard to know the generated filename, someone else may try peeping
+the temporary pseudo-linked file by his software tool which may try the name
+from one to MAX_INT or something.
+In this case, the 0644 file will be read unexpectedly.
+I am afraid that leaving the temporary pseudo-links can be a security hole.
+It makes sense to execute \[oq]auplink /your/aufs/root flush\[cq]
+periodically, when your writable branch is NFS.
+
+When your writable branch is not NFS, or all users are careful enough to set 0600
+to their private files, you do not have to worry about this issue.
+
+If you do not want this feature, use \[oq]noplink\[cq] mount option.
+
+.SS The behaviours of plink and noplink
+This sample shows that the \[oq]f_src_linked2\[cq] with \[oq]noplink\[cq] option cannot follow
+the link.
+
+.nf
+none on /dev/shm/u type aufs (rw,xino=/dev/shm/rw/.aufs.xino,br:/dev/shm/rw=rw:/dev/shm/ro=ro)
+$ ls -li ../r?/f_src_linked* ./f_src_linked* ./copied
+ls: ./copied: No such file or directory
+15 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ../ro/f_src_linked
+15 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ../ro/f_src_linked2
+22 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ./f_src_linked
+22 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ./f_src_linked2
+$ echo abc >> f_src_linked
+$ cp f_src_linked copied
+$ ls -li ../r?/f_src_linked* ./f_src_linked* ./copied
+15 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ../ro/f_src_linked
+15 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ../ro/f_src_linked2
+36 -rw-r--r--  2 jro jro 6 Dec 22 11:03 ../rw/f_src_linked
+53 -rw-r--r--  1 jro jro 6 Dec 22 11:03 ./copied
+22 -rw-r--r--  2 jro jro 6 Dec 22 11:03 ./f_src_linked
+22 -rw-r--r--  2 jro jro 6 Dec 22 11:03 ./f_src_linked2
+$ cmp copied f_src_linked2
+$
+
+none on /dev/shm/u type aufs (rw,xino=/dev/shm/rw/.aufs.xino,noplink,br:/dev/shm/rw=rw:/dev/shm/ro=ro)
+$ ls -li ../r?/f_src_linked* ./f_src_linked* ./copied
+ls: ./copied: No such file or directory
+17 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ../ro/f_src_linked
+17 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ../ro/f_src_linked2
+23 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ./f_src_linked
+23 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ./f_src_linked2
+$ echo abc >> f_src_linked
+$ cp f_src_linked copied
+$ ls -li ../r?/f_src_linked* ./f_src_linked* ./copied
+17 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ../ro/f_src_linked
+17 -rw-r--r--  2 jro jro 2 Dec 22 11:03 ../ro/f_src_linked2
+36 -rw-r--r--  1 jro jro 6 Dec 22 11:03 ../rw/f_src_linked
+53 -rw-r--r--  1 jro jro 6 Dec 22 11:03 ./copied
+23 -rw-r--r--  2 jro jro 6 Dec 22 11:03 ./f_src_linked
+23 -rw-r--r--  2 jro jro 6 Dec 22 11:03 ./f_src_linked2
+$ cmp copied f_src_linked2
+cmp: EOF on f_src_linked2
+$
+.fi
+
+.\"
+.\" If you add/del a branch, or link/unlink the pseudo-linked
+.\" file on a branch
+.\" directly, aufs cannot keep the correct link count, but the status of
+.\" \[oq]pseudo-linked.\[cq]
+.\" Those files may or may not keep the file data after you unlink the
+.\" file on the branch directly, especially the case of your branch is
+.\" NFS.
+
+If you add a branch which has fileA or fileB, aufs does not follow the
+pseudo link. The file on the added branch has no relation to the same
+named file(s) on the lower branch(es).
+If you use noxino mount option, pseudo link will not work after the
+kernel shrinks the inode cache.
+
+This feature will not work for squashfs before version 3.2 since its
+inode is tricky.
+When the inode is hardlinked, squashfs inodes has the same inode
+number and correct link count, but the inode memory object is
+different. Squashfs inodes (before v3.2) are generated for each, even
+they are hardlinked.
+
+.\" ----------------------------------------------------------------------
+.SH User\[aq]s Direct Branch Access (UDBA)
+UDBA means a modification to a branch filesystem manually or directly,
+e.g. bypassing aufs.
+While aufs is designed and implemented to be safe after UDBA,
+it can make yourself and your aufs confused. And some information like
+aufs inode will be incorrect.
+For example, if you rename a file on a branch directly, the file on
+aufs may
+or may not be accessible through both of old and new name.
+Because aufs caches various information about the files on
+branches. And the cache still remains after UDBA.
+
+Aufs has a mount option named \[oq]udba\[cq] which specifies the test level at
+access time whether UDBA was happened or not.
+.
+.TP
+.B udba=none
+Aufs trusts the dentry and the inode cache on the system, and never
+test about UDBA. With this option, aufs runs fastest, but it may show
+you incorrect data.
+Additionally, if you often modify a branch
+directly, aufs will not be able to trace the changes of inodes on the
+branch. It can be a cause of wrong behaviour, deadlock or anything else.
+
+It is recommended to use this option only when you are sure that
+nobody access a file on a branch.
+It might be difficult for you to achieve real \[oq]no UDBA\[cq] world when you
+cannot stop your users doing \[oq]find / \-ls\[cq] or something.
+If you really want to forbid all of your users to UDBA, here is a trick
+for it.
+With this trick, users cannot see the
+branches directly and aufs runs with no problem, except \[oq]auplink\[cq] utility.
+But if you are not familiar with aufs, this trick may make
+yourself confused.
+
+.nf
+# d=/tmp/.aufs.hide
+# mkdir $d
+# for i in $branches_you_want_to_hide
+> do
+>	mount -n --bind $d $i
+> done
+.fi
+
+When you unmount the aufs, delete/modify the branch by remount, or you
+want to show the hidden branches again, unmount the bound
+/tmp/.aufs.hide.
+
+.nf
+# umount -n $branches_you_want_to_unbound
+.fi
+
+If you use FUSE filesystem as an aufs branch which supports hardlink,
+you should not set this option, since FUSE makes inode objects for
+each hardlinks (at least in linux\-2.6.23). When your FUSE filesystem
+maintains them at link/unlinking, it is equivalent
+to \[oq]direct branch access\[cq] for aufs.
+
+.
+.TP
+.B udba=reval
+Aufs tests only the existence of the file which existed. If
+the existed file was removed on the branch directly, aufs
+discard the cache about the file and
+re-lookup it. So the data will be updated.
+This test is at minimum level to keep the performance and ensure the
+existence of a file.
+This is default and aufs runs still fast.
+
+This rule leads to some unexpected situation, but I hope it is
+harmless. Those are totally depends upon cache. Here are just a few
+examples.
+.
+.RS
+.Bu
+If the file is cached as negative or
+not-existed, aufs does not test it. And the file is still handled as
+negative after a user created the file on a branch directly. If the
+file is not cached, aufs will lookup normally and find the file.
+.
+.Bu
+When the file is cached as positive or existed, and a user created the
+same named file directly on the upper branch. Aufs detects the cached
+inode of the file is still existing and will show you the old (cached)
+file which is on the lower branch.
+.
+.Bu
+When the file is cached as positive or existed, and a user renamed the
+file by rename(2) directly. Aufs detects the inode of the file is
+still existing. You may or may not see both of the old and new files.
+Todo: If aufs also tests the name, we can detect this case.
+.RE
+
+If your outer modification (UDBA) is rare and you can ignore the
+temporary and minor differences between virtual aufs world and real
+branch filesystem, then try this mount option.
+.
+.TP
+.B udba=inotify
+Aufs sets `inotify' to all the accessed directories on its branches
+and receives the event about the dir and its children. It consumes
+resources, cpu and memory. And I am afraid that the performance will be
+hurt, but it is most strict test level.
+There are some limitations of linux inotify, see also Inotify
+Limitation.
+So it is recommended to leave udba default option usually, and set it
+to inotify by remount when you need it.
+
+When a user accesses the file which was notified UDBA before, the cached data
+about the file will be discarded and aufs re-lookup it. So the data will
+be updated.
+When an error condition occurs between UDBA and aufs operation, aufs
+will return an error, including EIO.
+To use this option, you need to enable CONFIG_INOTIFY and
+CONFIG_AUFS_UDBA_INOTIFY.
+
+To rename/rmdir a directory on a branch directory may reveal the same named
+directory on the lower branch. Aufs tries re-lookuping the renamed
+directory and the revealed directory and assigning different inode
+number to them. But the inode number including their children can be a
+problem. The inode numbers will be changed silently, and
+aufs may produce a warning. If you rename a directory repeatedly and
+reveal/hide the lower directory, then aufs may confuse their inode
+numbers too. It depends upon the system cache.
+
+When you make a directory in aufs and mount other filesystem on it,
+the directory in aufs cannot be removed expectedly because it is a
+mount point. But the same named directory on the writable branch can
+be removed, if someone wants. It is just an empty directory, instead
+of a mount point.
+Aufs cannot stop such direct rmdir, but produces a warning about it.
+
+If the pseudo-linked file is hardlinked or unlinked on the branch
+directly, its inode link count in aufs may be incorrect. It is
+recommended to flush the psuedo-links by auplink script.
+
+.\" ----------------------------------------------------------------------
+.SH Linux Inotify Limitation
+Unfortunately, current inotify (linux\-2.6.18) has some limitations,
+and aufs must derive it.
+
+.SS IN_ATTRIB, updating atime
+When a file/dir on a branch is accessed directly, the inode atime (access
+time, cf. stat(2)) may or may not be updated. In some cases, inotify
+does not fire this event. So the aufs inode atime may remain old.
+
+.SS IN_ATTRIB, updating nlink
+When the link count of a file on a branch is incremented by link(2)
+directly,
+inotify fires IN_CREATE to the parent
+directory, but IN_ATTRIB to the file. So the aufs inode nlink may
+remain old.
+
+.SS IN_DELETE, removing file on NFS
+When a file on a NFS branch is deleted directly, inotify may or may
+not fire
+IN_DELETE event. It depends upon the status of dentry
+(DCACHE_NFSFS_RENAMED flag).
+In this case, the file on aufs seems still exists. Aufs and any user can see
+the file.
+
+.SS IN_IGNORED, deleted rename target
+When a file/dir on a branch is unlinked by rename(2) directly, inotify
+fires IN_IGNORED which means the inode is deleted. Actually, in some
+cases, the inode survives. For example, the rename target is linked or
+opened. In this case, inotify watch set by aufs is removed by VFS and
+inotify.
+And aufs cannot receive the events anymore. So aufs may show you
+incorrect data about the file/dir.
+
+.\" ----------------------------------------------------------------------
+.SH Copy On Write, or aufs internal copyup and copydown
+Every stackable filesystem which implements copy\-on\-write supports the
+copyup feature. The feature is to copy a file/dir from the lower branch
+to the upper internally. When you have one readonly branch and one
+upper writable branch, and you append a string to a file which exists on
+the readonly branch, then aufs will copy the file from the readonly
+branch to the writable branch with its directory hierarchy. It means one
+write(2) involves several logical/internal mkdir(2), creat(2), read(2),
+write(2) and close(2) systemcalls
+before the actual expected write(2) is performed. Sometimes it may take
+a long time, particulary when the file is very large.
+If CONFIG_AUFS_DEBUG is enabled, aufs produces a message saying `copying
+a large file.\[aq]
+
+You may see the message when you change the xino file path or
+truncate the xino/xib files. Sometimes those files can be large and may
+take a long time to handle them.
+
+.\" ----------------------------------------------------------------------
+.SH Policies to Select One among Multiple Writable Branches
+Aufs has some policies to select one among multiple writable branches
+when you are going to write/modify something. There are two kinds of
+policies, one is for newly create something and the other is for
+internal copy-up.
+You can select them by specifying mount option \[oq]create=CREATE_POLICY\[cq]
+or \[oq]cpup=COPYUP_POLICY.\[cq]
+These policies have no meaning when you have only one writable
+branch. If there is some meaning, it must hurt the performance.
+
+.SS Exceptions for Policies
+In every cases below, even if the policy says that the branch where a
+new file should be created is /rw2, the file will be created on /rw1.
+.
+.Bu
+If there is a readonly branch with \[oq]wh\[cq] attribute above the
+policy-selected branch and the parent dir is marked as opaque,
+or the target (creating) file is whiteouted on the ro+wh branch, then
+the policy will be ignored and the target file will be created on the
+nearest upper writable branch than the ro+wh branch.
+.RS
+.nf
+/aufs = /rw1 + /ro+wh/diropq + /rw2
+/aufs = /rw1 + /ro+wh/wh.tgt + /rw2
+.fi
+.RE
+.
+.Bu
+If there is a writable branch above the policy-selected branch and the
+parent dir is marked as opaque or the target file is whiteouted on the
+branch, then the policy will be ignored and the target file will be
+created on the highest one among the upper writable branches who has
+diropq or whiteout. In case of whiteout, aufs removes it as usual.
+.RS
+.nf
+/aufs = /rw1/diropq + /rw2
+/aufs = /rw1/wh.tgt + /rw2
+.fi
+.RE
+.
+.Bu
+link(2) and rename(2) systemcalls are exceptions in every policy.
+They try selecting the branch where the source exists as possible since
+copyup a large file will take long time. If it can\[aq]t be, ie. the
+branch where the source exists is readonly, then they will follow the
+copyup policy.
+.
+.Bu
+There is an exception for rename(2) when the target exists.
+If the rename target exists, aufs compares the index of the branches
+where the source and the target are existing and selects the higher
+one. If the selected branch is readonly, then aufs follows the copyup
+policy.
+
+.SS Policies for Creating
+.
+.TP
+.B create=tdp | top\-down\-parent
+Selects the highest writable branch where the parent dir exists. If
+the parent dir does not exist on a writable branch, then the internal
+copyup will happen. The policy for this copyup is always \[oq]bottom-up.\[cq]
+This is the default policy.
+.
+.TP
+.B create=rr | round\-robin
+Selects a writable branch in round robin. When you have two writable
+branches and creates 10 new files, 5 files will be created for each
+branch.
+mkdir(2) systemcall is an exception. When you create 10 new directories,
+all are created on the same branch.
+.
+.TP
+.B create=mfs[:second] | most\-free\-space[:second]
+Selects a writable branch which has most free space. In order to keep
+the performance, you can specify the duration (\[oq]second\[cq]) which makes
+aufs hold the index of last selected writable branch until the
+specified seconds expires. The first time you create something in aufs
+after the specified seconds expired, aufs checks the amount of free
+space of all writable branches by internal statfs call
+and the held branch index will be updated.
+The default value is \*[AUFS_MFS_SECOND_DEF] seconds.
+.
+.TP
+.B create=mfsrr:low[:second]
+Selects a writable branch in most-free-space mode first, and then
+round-robin mode. If the selected branch has less free space than the
+specified value \[oq]low\[cq] in bytes, then aufs re-tries in round-robin mode.
+.\" \[oq]G\[cq], \[oq]M\[cq] and \[oq]K\[cq] (case insensitive) can be followed after \[oq]low.\[cq] Or
+Try an arithmetic expansion of shell which is defined by POSIX.
+For example, $((10 * 1024 * 1024)) for 10M.
+You can also specify the duration (\[oq]second\[cq]) which is equivalent to
+the \[oq]mfs\[cq] mode.
+.
+.TP
+.B create=pmfs[:second]
+Selects a writable branch where the parent dir exists, such as tdp
+mode. When the parent dir exists on multiple writable branches, aufs
+selects the one which has most free space, such as mfs mode.
+
+.SS Policies for Copy-Up
+.
+.TP
+.B cpup=tdp | top\-down\-parent
+Equivalent to the same named policy for create.
+This is the default policy.
+.
+.TP
+.B cpup=bup | bottom\-up\-parent
+Selects the writable branch where the parent dir exists and the branch
+is nearest upper one from the copyup-source.
+.
+.TP
+.B cpup=bu | bottom\-up
+Selects the nearest upper writable branch from the copyup-source,
+regardless the existence of the parent dir.
+
+.\" ----------------------------------------------------------------------
+.SH Dentry and Inode Caches
+If you want to clear caches on your system, there are several tricks
+for that. If your system ram is low,
+try \[oq]find /large/dir \-ls > /dev/null\[cq].
+It will read many inodes and dentries and cache them. Then old caches will be
+discarded.
+But when you have large ram or you do not have such large
+directory, it is not effective.
+
+If you want to discard cache within a certain filesystem,
+try \[oq]mount \-o remount /your/mntpnt\[cq]. Some filesystem may return an error of
+EINVAL or something, but VFS discards the unused dentry/inode caches on the
+specified filesystem.
+
+.\" ----------------------------------------------------------------------
+.SH Compatible/Incompatible with Unionfs Version 1.x Series
+If you compile aufs with \-DCONFIG_AUFS_COMPAT, dirs= option and =nfsro
+branch permission flag are available. They are interpreted as
+br: option and =ro flags respectively.
+ \[oq]debug\[cq], \[oq]delete\[cq], \[oq]imap\[cq] options are ignored silently. When you
+compile aufs without \-DCONFIG_AUFS_COMPAT, these three options are
+also ignored, but a warning message is issued.
+
+Ignoring \[oq]delete\[cq] option, and to keep filesystem consistency, aufs tries
+writing something to only one branch in a single systemcall. It means
+aufs may copyup even if the copyup-src branch is specified as writable.
+For example, you have two writable branches and a large regular file
+on the lower writable branch. When you issue rename(2) to the file on aufs,
+aufs may copyup it to the upper writable branch.
+If this behaviour is not what you want, then you should rename(2) it
+on the lower branch directly.
+
+And there is a simple shell
+script \[oq]unionctl\[cq] under sample subdirectory, which is compatible with
+unionctl(8) in
+Unionfs Version 1.x series, except \-\-query action.
+This script executes mount(8) with \[oq]remount\[cq] option and uses
+add/del/mod aufs mount options.
+If you are familiar with Unionfs Version 1.x series and want to use unionctl(8), you can
+try this script instead of using mount \-o remount,... directly.
+Aufs does not support ioctl(2) interface.
+This script is highly depending upon mount(8) in
+util\-linux\-2.12p package, and you need to mount /proc to use this script.
+If your mount(8) version differs, you can try modifying this
+script. It is very easy.
+The unionctl script is just for a sample usage of aufs remount
+interface.
+
+Aufs uses the external inode number bitmap and translation table by
+default.
+
+The default branch permission for the first branch is \[oq]rw\[cq], and the
+rest is \[oq]ro.\[cq]
+
+The whiteout is for hiding files on lower branches. Also it is applied
+to stop readdir going lower branches.
+The latter case is called \[oq]opaque directory.\[cq] Any
+whiteout is an empty file, it means whiteout is just an mark.
+In the case of hiding lower files, the name of whiteout is
+\[oq]\*[AUFS_WH_PFX]<filename>.\[cq]
+And in the case of stopping readdir, the name is
+\[oq]\*[AUFS_WH_PFX]\*[AUFS_WH_PFX].opq\[cq] or
+\[oq]\*[AUFS_WH_PFX]__dir_opaque.\[cq] The name depends upon your compile
+configuration
+CONFIG_AUFS_COMPAT.
+.\" All of newly created or renamed directory will be opaque.
+All whiteouts are hardlinked,
+including \[oq]<writable branch top dir>/\*[AUFS_WH_BASE].\[cq]
+
+The hardlink on an ordinary (disk based) filesystem does not
+consume inode resource newly. But in linux tmpfs, the number of free
+inodes will be decremented by link(2). It is recommended to specify
+nr_inodes option to your tmpfs if you meet ENOSPC. Use this option
+after checking by \[oq]df \-i.\[cq]
+
+When you rmdir or rename-to the dir who has a number of whiteouts,
+aufs rename the dir to the temporary whiteouted-name like
+\[oq]\*[AUFS_WH_PFX]<dir>.<random hex>.\[cq] Then remove it after actual operation.
+cf. mount option \[oq]dirwh.\[cq]
+
+.\" ----------------------------------------------------------------------
+.SH Incompatible with an Ordinary Filesystem
+stat(2) returns the inode info from the first existence inode among
+the branches, except the directory link count.
+Aufs computes the directory link count larger than the exact value usually, in
+order to keep UNIX filesystem semantics, or in order to shut find(1) mouth up.
+The size of a directory may be wrong too, but it has to do no harm.
+The timestamp of a directory will not be updated when a file is
+created or removed under it, and it was done on a lower branch.
+
+The test for permission bits has two cases. One is for a directory,
+and the other is for a non-directory. In the case of a directory, aufs
+checks the permission bits of all existing directories. It means you
+need the correct privilege for the directories including the lower
+branches.
+The test for a non-directory is more simple. It checks only the
+topmost inode.
+
+statfs(2) returns the information of the first branch info except
+namelen when \[oq]nosum\[cq] is specified (the default). The namelen is
+decreased by the whiteout prefix length. And the block size may differ
+from st_blksize which is obtained by stat(2).
+
+Remember, seekdir(3) and telldir(3) are not defined in POSIX. They may
+not work as you expect. Try rewinddir(3) or re-open the dir.
+
+The whiteout prefix (\*[AUFS_WH_PFX]) is reserved on all branches. Users should
+not handle the filename begins with this prefix.
+In order to future whiteout, the maxmum filename length is limited by
+the longest value \- \*[AUFS_WH_PFX_LEN]. It may be a violation of POSIX.
+
+If you dislike the difference between the aufs entries in /etc/mtab
+and /proc/mounts, and if you are using mount(8) in util\-linux package,
+then try ./mount.aufs utility. Copy the script to /sbin/mount.aufs.
+This simple utility tries updating
+/etc/mtab. If you do not care about /etc/mtab, you can ignore this
+utility.
+Remember this utility is highly depending upon mount(8) in
+util\-linux\-2.12p package, and you need to mount /proc.
+
+Since aufs uses its own inode and dentry, your system may cache huge
+number of inodes and dentries. It can be as twice as all of the files
+in your union.
+It means that unmounting or remounting readonly at shutdown time may
+take a long time, since mount(2) in VFS tries freeing all of the cache
+on the target filesystem.
+
+When you open a directory, aufs will open several directories
+internally.
+It means you may reach the limit of the number of file descriptor.
+And when the lower directory cannot be opened, aufs will close all the
+opened upper directories and return an error.
+
+The sub-mount under the branch
+of local filesystem
+is ignored.
+For example, if you have mount another filesystem on
+/branch/another/mntpnt, the files under \[oq]mntpnt\[cq] will be ignored by aufs.
+It is recommended to mount the sub-mount under the mounted aufs.
+For example,
+
+.nf
+# sudo mount /dev/sdaXX /ro_branch
+# d=another/mntpnt
+# sudo mount /dev/sdbXX /ro_branch/$d
+# mkdir -p /rw_branch/$d
+# sudo mount -t aufs -o br:/rw_branch:/ro_branch none /aufs
+# sudo mount -t aufs -o br:/rw_branch/${d}:/ro_branch/${d} none /aufs/another/$d
+.fi
+
+There are several characters which are not allowed to use in a branch
+directory path and xino filename. See detail in Branch Syntax and Mount
+Option.
+
+The file-lock which means fcntl(2) with F_SETLK, F_SETLKW or F_GETLK, flock(2)
+and lockf(3), is applied to virtual aufs file only, not to the file on a
+branch. It means you can break the lock by accessing a branch directly.
+TODO: check \[oq]security\[cq] to hook locks, as inotify does.
+
+The I/O to the named pipe or local socket are not handled by aufs, even
+if it exists in aufs. After the reader and the writer established their
+connection if the pipe/socket are copied-up, they keep using the old one
+instead of the copied-up one.
+
+The fsync(2) and fdatasync(2) systemcalls return 0 which means success, even
+if the given file descriptor is not opened for writing.
+I am afraid this behaviour may violate some standards. Checking the
+behaviour of fsync(2) on ext2, aufs decided to return success.
+
+If you want to use disk-quota, you should set it up to your writable
+branch since aufs does not have its own block device.
+
+When your aufs is the root directory of your system, and your system
+tells you some of the filesystem were not unmounted cleanly, try these
+procedure when you shutdown your system.
+.nf
+# mount -no remount,ro /
+# for i in $writable_branches
+# do mount -no remount,ro $i
+# done
+.fi
+If your xino file is on a hard drive, you also need to specify
+\[oq]noxino\[cq] option or \[oq]xino=/your/tmpfs/xino\[cq] at remounting root
+directory.
+
+To rename(2) directory may return EXDEV even if both of src and tgt
+are on the same aufs. When the rename-src dir exists on multiple
+branches and the lower dir has child(ren), aufs has to copyup all his
+children. It can be recursive copyup. Current aufs does not support
+such huge copyup operation at one time in kernel space, instead
+produces a warning and returns EXDEV.
+Generally, mv(1) detects this error and tries mkdir(2) and
+rename(2) or copy/unlink recursively. So the result is harmless.
+If your application which issues rename(2) for a directory does not
+support EXDEV, it will not work on aufs.
+Also this specification is applied to the case when the src directroy
+exists on the lower readonly branch and it has child(ren).
+
+If a sudden accident such like a power failure happens during aufs is
+performing, and regular fsck for branch filesystems is completed after
+the disaster, you need to extra fsck for aufs writable branches. It is
+necessary to check whether the whiteout remains incorrectly or not,
+eg. the real filename and the whiteout for it under the same parent
+directory. If such whiteout remains, aufs cannot handle the file
+correctly.
+To check the consistency from the aufs\[aq] point of view, you can use a
+simple shell script called /sbin/auchk. Its purpose is a fsck tool for
+aufs, and it checks the illegal whiteout, the remained
+pseudo-links and the remained aufs-temp files. If they are found, the
+utility reports you and asks whether to delete or not.
+It is recommended to execute /sbin/auchk for every writable branch
+filesystem before mouting aufs if the system experienced crash.
+
+
+.\" ----------------------------------------------------------------------
+.SH EXAMPLES
+The mount options are interpreted from left to right at remount-time.
+These examples
+shows how the options are handled. (assuming /sbin/mount.aufs was
+installed)
+
+.nf
+# mount -v -t aufs br:/day0:/base none /u
+none on /u type aufs (rw,xino=/day0/.aufs.xino,br:/day0=rw:/base=ro)
+# mount -v -o remount,\\
+	prepend:/day1,\\
+	xino=/day1/xino,\\
+	mod:/day0=ro,\\
+	del:/day0 \\
+	/u
+none on /u type aufs (rw,xino=/day1/xino,br:/day1=rw:/base=ro)
+.fi
+
+.nf
+# mount -t aufs br:/rw none /u
+# mount -o remount,append:/ro /u
+different uid/gid/permission, /ro
+# mount -o remount,del:/ro /u
+# mount -o remount,nowarn_perm,append:/ro /u
+#
+(there is no warning)
+.fi
+
+.\" If you want to expand your filesystem size, aufs may help you by
+.\" adding an writable branch. Since aufs supports multiple writable
+.\" branches, the old writable branch can be being writable, if you want.
+.\" In this example, any modifications to the files under /ro branch will
+.\" be copied-up to /new, but modifications to the files under /rw branch
+.\" will not.
+.\" And the next example shows the modifications to the files under /rw branch
+.\" will be copied-up to /new/a.
+.\"
+.\" Todo: test multiple writable branches policy. cpup=nearest, cpup=exist_parent.
+.\"
+.\" .nf
+.\" # mount -v -t aufs br:/rw:/ro none /u
+.\" none on /u type aufs (rw,xino=/rw/.aufs.xino,br:/rw=rw:/ro=ro)
+.\" # mkfs /new
+.\" # mount -v -o remount,add:1:/new=rw /u
+.\" none on /u type aufs (rw,xino=/rw/.aufs.xino,br:/rw=rw:/new=rw:/ro=ro)
+.\" .fi
+.\"
+.\" .nf
+.\" # mount -v -t aufs br:/rw:/ro none /u
+.\" none on /u type aufs (rw,xino=/rw/.aufs.xino,br:/rw=rw:/ro=ro)
+.\" # mkfs /new
+.\" # mkdir /new/a new/b
+.\" # mount -v -o remount,add:1:/new/b=rw,prepend:/new/a,mod:/rw=ro /u
+.\" none on /u type aufs (rw,xino=/rw/.aufs.xino,br:/new/a=rw:/rw=ro:/new/b=rw:/ro=ro)
+.\" .fi
+
+When you use aufs as root filesystem, it is recommended to consider to
+exclude some directories. For example, /tmp and /var/log are not need
+to stack in many cases. They do not usually need to copyup or to whiteout.
+Also the swapfile on aufs (a regular file, not a block device) is not
+supported.
+In order to exclude the specific dir from aufs, try bind mounting.
+
+And there is a good sample which is for network booted diskless machines. See
+sample/ in detail.
+
+.\" ----------------------------------------------------------------------
+.SH DIAGNOSTICS
+When you add a branch to your union, aufs may warn you about the
+privilege or security of the branch, which is the permission bits,
+owner and group of the top directory of the branch.
+For example, when your upper writable branch has a world writable top
+directory,
+a malicious user can create any files on the writable branch directly,
+like copyup and modify manually. I am afraid it can be a security
+issue.
+
+When you mount or remount your union without \-o ro common mount option
+and without writable branch, aufs will warn you that the first branch
+should be writable.
+
+.\" It is discouraged to set both of \[oq]udba\[cq] and \[oq]noxino\[cq] mount options. In
+.\" this case the inode number under aufs will always be changed and may
+.\" reach the end of inode number which is a maximum of unsigned long. If
+.\" the inode number reaches the end, aufs will return EIO repeatedly.
+
+When you set udba other than inotify and change something on your
+branch filesystem directly, later aufs may detect some mismatches to
+its cache. If it is a critical mismatch, aufs returns EIO.
+
+When an error occurs in aufs, aufs prints the kernel message with
+\[oq]errno.\[cq] The priority of the message (log level) is ERR or WARNING which
+depends upon the message itself.
+You can convert the \[oq]errno\[cq] into the error message by perror(3),
+strerror(3) or something.
+For example, the \[oq]errno\[cq] in the message \[oq]I/O Error, write failed (\-28)\[cq]
+is 28 which means ENOSPC or \[oq]No space left on device.\[cq]
+
+When CONFIG_AUFS_BR_RAMFS is enabled, you can specify ramfs as an aufs
+branch. Since ramfs is simple, it doesn't set the maximum link count
+originally. In aufs, it is very dangerous, particulary for
+whiteouts. Finally aufs sets the maxmimum link count for ramfs. Tha
+value is 32000 which is borrowed from ext2.
+
+
+.\" .SH Current Limitation
+.
+.\" ----------------------------------------------------------------------
+.\" SYNOPSIS
+.\" briefly describes the command or function\[aq]s interface.  For  commands,  this
+.\" shows the syntax of the command and its arguments (including options); bold-
+.\" face is used for as-is text and italics are  used  to  indicate  replaceable
+.\" arguments. Brackets ([]) surround optional arguments, vertical bars (|) sep-
+.\" arate choices, and ellipses (...) can be repeated.  For functions, it  shows
+.\" any required data declarations or #include directives, followed by the func-
+.\" tion declaration.
+.
+.\" DESCRIPTION
+.\" gives an explanation of what the command, function, or format does.  Discuss
+.\" how  it  interacts  with  files  and standard input, and what it produces on
+.\" standard output  or  standard  error.   Omit  internals  and  implementation
+.\" details  unless  they\[aq]re critical for understanding the interface.  Describe
+.\" the usual case; for information on options  use  the  OPTIONS  section.   If
+.\" there  is some kind of input grammar or complex set of subcommands, consider
+.\" describing them in a separate USAGE section (and just place an  overview  in
+.\" the DESCRIPTION section).
+.
+.\" RETURN VALUE
+.\" gives a list of the values the library routine will return to the caller and
+.\" the conditions that cause these values to be returned.
+.
+.\" EXIT STATUS
+.\" lists the possible exit status values or a program and the  conditions  that
+.\" cause these values to be returned.
+.
+.\" USAGE
+.\" describes the grammar of any sublanguage this implements.
+.
+.\" FILES
+.\" lists  the  files the program or function uses, such as configuration files,
+.\" startup files, and files the program directly operates on.   Give  the  full
+.\" pathname  of  these  files,  and  use the installation process to modify the
+.\" directory part to match user preferences.  For many  programs,  the  default
+.\" installation  location is in /usr/local, so your base manual page should use
+.\" /usr/local as the base.
+.
+.\" ENVIRONMENT
+.\" lists all environment variables that affect your program or function and how
+.\" they affect it.
+.
+.\" SECURITY
+.\" discusses security issues and implications.  Warn  about  configurations  or
+.\" environments  that should be avoided, commands that may have security impli-
+.\" cations, and so on, especially if they aren\[aq]t obvious.  Discussing  security
+.\" in  a  separate section isn\[aq]t necessary; if it\[aq]s easier to understand, place
+.\" security information in the other sections (such as the DESCRIPTION or USAGE
+.\" section).  However, please include security information somewhere!
+.
+.\" CONFORMING TO
+.\" describes any standards or conventions this implements.
+.
+.\" NOTES
+.\" provides miscellaneous notes.
+.
+.\" BUGS
+.\" lists  limitations,  known defects or inconveniences, and other questionable
+.\" activities.
+
+.SH COPYRIGHT
+Copyright \(co 2005\-2009 Junjiro R. Okajima
+
+.SH AUTHOR
+Junjiro R. Okajima
+
+.\" SEE ALSO
+.\" lists  related  man  pages in alphabetical order, possibly followed by other
+.\" related pages or documents.  Conventionally this is the last section.
diff --git a/Documentation/filesystems/aufs/design/01intro.txt b/Documentation/filesystems/aufs/design/01intro.txt
new file mode 100644
index 0000000..4955fdc
--- /dev/null
+++ b/Documentation/filesystems/aufs/design/01intro.txt
@@ -0,0 +1,128 @@
+
+# Copyright (C) 2005-2009 Junjiro R. Okajima
+# 
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+Introduction
+----------------------------------------
+
+aufs [ei ju: ef es] | [a u f s]
+1. abbrev. for "advanced multi-layered unification filesystem".
+2. abbrev. for "another unionfs".
+3. abbrev. for "auf das" in German which means "on the" in English.
+   Ex. "Butter aufs Brot"(G) means "butter onto bread"(E).
+   But "Filesystem aufs Filesystem" is hard to understand.
+
+AUFS is a filesystem with features:
+- multi layered stackable unification filesystem, the member directory
+  is called as a branch.
+- branch permission and attribute, 'readonly', 'real-readonly',
+  'readwrite', 'whiteout-able', 'link-able whiteout' and their
+  combination.
+- internal "file copy-on-write".
+- logical deletion, whiteout.
+- dynamic branch manipulation, adding, deleting and changing permission.
+- allow bypassing aufs, user's direct branch access.
+- external inode number translation table and bitmap which maintains the
+  persistent aufs inode number.
+- seekable directory, including NFS readdir.
+- file mapping, mmap and sharing pages.
+- pseudo-link, hardlink over branches.
+- loopback mounted filesystem as a branch.
+- several policies to select one among multiple writable branches.
+- revert a single systemcall when an error occurs in aufs.
+- and more...
+
+
+Multi Layered Stackable Unification Filesystem
+----------------------------------------------------------------------
+Most people already knows what it is.
+It is a filesystem which unifies several directories and provides a
+merged single directory. When users access a file, the access will be
+passed/re-directed/converted (sorry, I am not sure which English word is
+correct) to the real file on the member filesystem. The member
+filesystem is called 'lower filesystem' or 'branch' and has a mode
+'readonly' and 'readwrite.' And the deletion for a file on the lower
+readonly branch is handled by creating 'whiteout' on the upper writable
+branch.
+
+On LKML, there have been discussions about UnionMount (Jan Blunck and
+Bharata B Rao) and Unionfs (Erez Zadok). They took different approaches
+to implement the merged-view.
+The former tries putting it into VFS, and the latter implements as a
+separate filesystem.
+(If I misunderstand about these implementations, please let me know and
+I shall correct it. Because it is a long time ago when I read their
+source files last time).
+UnionMount's approach will be able to small, but may be hard to share
+branches between several UnionMount since the whiteout in it is
+implemented in the inode on branch filesystem and always
+shared. According to Bharata's post, readdir does not seems to be
+finished yet.
+Unionfs has a longer history. When I started implementing a stacking filesystem
+(Aug 2005), it already existed. It has virtual super_block, inode,
+dentry and file objects and they have an array pointing lower same kind
+objects. After contributing many patches for Unionfs, I re-started my
+project AUFS (Jun 2006).
+
+In AUFS, the structure of filesystem resembles to Unionfs, but I
+implemented my own ideas, approaches and enhancements and it became
+totally different one.
+
+
+Several characters/aspects of aufs
+----------------------------------------------------------------------
+
+Aufs has several characters or aspects.
+1. a filesystem, callee of VFS helper
+2. sub-VFS, caller of VFS helper for branches
+3. a virtual filesystem which maintains persistent inode number
+4. reader/writer of files on branches such like an application
+
+1. Caller of VFS Helper
+As an ordinary linux filesystem, aufs is a callee of VFS. For instance,
+unlink(2) from an application reaches sys_unlink() kernel function and
+then vfs_unlink() is called. vfs_unlink() is one of VFS helper and it
+calls filesystem specific unlink operation. Actually aufs implements the
+unlink operation but it behaves like a redirector.
+
+2. Caller of VFS Helper for Branches
+aufs_unlink() passes the unlink request to the branch filesystem as if
+it were called from VFS. So the called unlink operation of the branch
+filesystem acts as usual. As a caller of VFS helper, aufs should handle
+every necessary pre/post operation for the branch filesystem.
+- acquire the lock for the parent dir on a branch
+- lookup in a branch
+- revalidate dentry on a branch
+- mnt_want_write() for a branch
+- vfs_unlink() for a branch
+- mnt_drop_write() for a branch
+- release the lock on a branch
+
+3. Persistent Inode Number
+One of the most important issue for a filesystem is to maintain inode
+numbers. This is particularly important to support exporting a
+filesystem via NFS. Aufs is a virtual filesystem which doesn't have a
+backend block device for its own. But some storage is necessary to
+maintain inode number. It may be a large space and may not suit to keep
+in memory. Aufs rents some space from its first writable branch
+filesystem (by default) and creates file(s) on it. These files are
+created by aufs internally and removed soon (currently) keeping opened.
+Note: Because these files are removed, they are totally gone after
+      unmounting aufs. It means the inode numbers are not persistent
+      across unmount or reboot. I have a plan to make them really
+      persistent which will be important for aufs on NFS server.
+
+4. Read/Write Files Internally (copy-on-write)
+Because a branch can be readonly, when you write a file on it, aufs will
+"copy-up" it to the upper writable branch internally. And then write the
+originally requested thing to the file. Generally kernel doesn't
+open/read/write file actively. In aufs, even a single write may cause a
+internal "file copy". This behaviour is very similar to cp(1) command.
+
+Some people may think it is better to pass such work to user space
+helper, instead of doing in kernel space. Actually I am still thinking
+about it. But currently I have implemented it in kernel space.
diff --git a/Documentation/filesystems/aufs/design/02struct.txt b/Documentation/filesystems/aufs/design/02struct.txt
new file mode 100644
index 0000000..6db666b
--- /dev/null
+++ b/Documentation/filesystems/aufs/design/02struct.txt
@@ -0,0 +1,205 @@
+
+# Copyright (C) 2005-2009 Junjiro R. Okajima
+# 
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+Basic Aufs Internal Structure
+
+Superblock/Inode/Dentry/File Objects
+----------------------------------------------------------------------
+As like an ordinary filesystem, aufs has its own
+superblock/inode/dentry/file objects. All these objects have a
+dynamically allocated array and store the same kind of pointers to the
+lower filesystem, branch.
+For example, when you build a union with one readwrite branch and one
+readonly, mounted /au, /rw and /ro respectively.
+- /au = /rw + /ro
+- /ro/fileA exists but /rw/fileA
+
+Aufs lookup operation finds /ro/fileA and gets dentry for that. These
+pointers are stored in a aufs dentry. The array in aufs dentry will be,
+- [0] = NULL
+- [1] = /ro/fileA
+
+This style of an array is essentially same to the aufs
+superblock/inode/dentry/file objects.
+
+Because aufs supports manipulating branches, ie. add/delete/change
+dynamically, these objects has its own generation. When branches are
+changed, the generation in aufs superblock is incremented. And a
+generation in other object are compared when it is accessed.
+When a generation in other objects are obsoleted, aufs refreshes the
+internal array.
+
+
+Superblock
+----------------------------------------------------------------------
+Additionally aufs superblock has some data for policies to select one
+among multiple writable branches, XIB files, pseudo-links and kobject.
+See below in detail.
+About the policies which supports copy-down a directory, see policy.txt
+too.
+
+
+Branch and XINO(External Inode Number Translation Table)
+----------------------------------------------------------------------
+Every branch has its own xino (external inode number translation table)
+file. The xino file is created and unlinked by aufs internally. When two
+members of a union exist on the same filesystem, they share the single
+xino file.
+The struct of a xino file is simple, just a sequence of aufs inode
+numbers which is indexed by the lower inode number.
+In the above sample, assume the inode number of /ro/fileA is i111 and
+aufs assigns the inode number i999 for fileA. Then aufs writes 999 as
+4(8) bytes at 111 * 4(8) bytes offset in the xino file.
+
+When the inode numbers are not contiguous, the xino file will be sparse
+which has a hole in it and doesn't consume as much disk space as it
+might appear. If your branch filesystem consumes disk space for such
+holes, then you should specify 'xino=' option at mounting aufs.
+
+Also a writable branch has three kinds of "whiteout bases". All these
+are existed when the branch is joined to aufs and the names are
+whiteout-ed doubly, so that users will never see their names in aufs
+hierarchy.
+1. a regular file which will be linked to all whiteouts.
+2. a directory to store a pseudo-link.
+3. a directory to store an "orphan-ed" file temporary.
+
+1. Whiteout Base
+   When you remove a file on a readonly branch, aufs handles it as a
+   logical deletion and creates a whiteout on the upper writable branch
+   as a hardlink of this file in order not to consume inode on the
+   writable branch.
+2. Pseudo-link Dir
+   See below, Pseudo-link.
+3. Step-Parent Dir
+   When "fileC" exists on the lower readonly branch only and it is
+   opened and removed with its parent dir, and then user writes
+   something into it, then aufs copies-up fileC to this
+   directory. Because there is no other dir to store fileC. After
+   creating a file under this dir, the file is unlinked.
+
+Because aufs supports manipulating branches, ie. add/delete/change
+dynamically, a branch has its own id. When the branch order changes, aufs
+finds the new index by searching the branch id.
+
+
+Pseudo-link
+----------------------------------------------------------------------
+Assume "fileA" exists on the lower readonly branch only and it is
+hardlinked to "fileB" on the branch. When you write something to fileA,
+aufs copies-up it to the upper writable branch. Additionally aufs
+creates a hardlink under the Pseudo-link Directory of the writable
+branch. The inode of a pseudo-link is kept in aufs super_block as a
+simple list. If fileB is read after unlinking fileA, aufs returns
+filedata from the pseudo-link instead of the lower readonly
+branch. Because the pseudo-link is based upon the inode, to keep the
+inode number by xino (see above) is important.
+
+All the hardlinks under the Pseudo-link Directory of the writable branch
+should be restored in a proper location later. Aufs provides a utility
+to do this. The userspace helpers executed at remounting and unmounting
+aufs by default.
+
+
+XIB(external inode number bitmap)
+----------------------------------------------------------------------
+Addition to the xino file per a branch, aufs has an external inode number
+bitmap in a superblock object. It is also a file such like a xino file.
+It is a simple bitmap to mark whether the aufs inode number is in-use or
+not.
+To reduce the file I/O, aufs prepares a single memory page to cache xib.
+
+Aufs implements a feature to truncate/refresh both of xino and xib to
+reduce the number of consumed disk blocks for these files.
+
+
+Virtual or Vertical Dir
+----------------------------------------------------------------------
+In order to support multiple layers (branches), aufs readdir operation
+constructs a virtual dir block on memory. For readdir, aufs calls
+vfs_readdir() internally for each dir on branches, merges their entries
+with eliminating the whiteout-ed ones, and sets it to file (dir)
+object. So the file object has its entry list until it is closed. The
+entry list will be updated when the file position is zero and becomes
+old. This decision is made in aufs automatically.
+
+The dynamically allocated memory block for the name of entries has a
+unit of 512 bytes (by default) and stores the names contiguously (no
+padding). Another block for each entry is handled by kmem_cache too.
+During building dir blocks, aufs creates hash list and judging whether
+the entry is whiteouted by its upper branch or already listed.
+
+Some people may call it can be a security hole or invite DoS attack
+since the opened and once readdir-ed dir (file object) holds its entry
+list and becomes a pressure for system memory. But I'd say it is similar
+to files under /proc or /sys. The virtual files in them also holds a
+memory page (generally) while they are opened. When an idea to reduce
+memory for them is introduced, it will be applied to aufs too.
+
+
+Workqueue
+----------------------------------------------------------------------
+Aufs sometimes requires privilege access to a branch. For instance,
+in copy-up/down operation. When a user process is going to make changes
+to a file which exists in the lower readonly branch only, and the mode
+of one of ancestor directories may not be writable by a user
+process. Here aufs copy-up the file with its ancestors and they may
+require privilege to set its owner/group/mode/etc.
+This is a typical case of a application character of aufs (see
+Introduction).
+
+Aufs uses workqueue synchronously for this case. It creates its own
+workqueue. The workqueue is a kernel thread and has privilege. Aufs
+passes the request to call mkdir or write (for example), and wait for
+its completion. This approach solves a problem of a signal handler
+simply.
+If aufs didn't adopt the workqueue and changed the privilege of the
+process, and if the mkdir/write call arises SIGXFSZ or other signal,
+then the user process might gain a privilege or the generated core file
+was owned by a superuser. But I have a plan to switch to a new
+credential approach which will be introduced in linux-2.6.29.
+
+Also aufs uses the system global workqueue ("events" kernel thread) too
+for asynchronous tasks, such like handling inotify, re-creating a
+whiteout base and etc. This is unrelated to a privilege.
+Most of aufs operation tries acquiring a rw_semaphore for aufs
+superblock at the beginning, at the same time waits for the completion
+of all queued asynchronous tasks.
+
+
+Whiteout
+----------------------------------------------------------------------
+The whiteout in aufs is very similar to Unionfs's. That is represented
+by its filename. UnionMount takes an approach of a file mode, but I am
+afraid several utilities (find(1) or something) will have to support it.
+
+Basically the whiteout represents "logical deletion" which stops aufs to
+lookup further, but also it represents "dir is opaque" which also stop
+lookup.
+
+In aufs, rmdir(2) and rename(2) for dir uses whiteout alternatively.
+In order to make several functions in a single systemcall to be
+revertible, aufs adopts an approach to rename a directory to a temporary
+unique whiteouted name.
+For example, in rename(2) dir where the target dir already existed, aufs
+renames the target dir to a temporary unique whiteouted name before the
+actual rename on a branch and then handles other actions (make it opaque,
+update the attributes, etc). If an error happens in these actions, aufs
+simply renames the whiteouted name back and returns an error. If all are
+succeeded, aufs registers a function to remove the whiteouted unique
+temporary name completely and asynchronously to the system global
+workqueue.
+
+
+Copy-up
+----------------------------------------------------------------------
+It is a well-known feature or concept.
+When user modifies a file on a readonly branch, aufs operate "copy-up"
+internally and makes change to the new file on the upper writable branch.
+When the trigger systemcall does not update the timestamps of the parent
+dir, aufs reverts it after copy-up.
diff --git a/Documentation/filesystems/aufs/design/03lookup.txt b/Documentation/filesystems/aufs/design/03lookup.txt
new file mode 100644
index 0000000..36ddac7
--- /dev/null
+++ b/Documentation/filesystems/aufs/design/03lookup.txt
@@ -0,0 +1,95 @@
+
+# Copyright (C) 2005-2009 Junjiro R. Okajima
+# 
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+Lookup in a Branch
+----------------------------------------------------------------------
+Since aufs has a character of sub-VFS (see Introduction), it operates
+lookup for branches as VFS does. It may be a heavy work. Generally
+speaking struct nameidata is a bigger structure and includes many
+information. But almost all lookup operation in aufs is the simplest
+case, ie. lookup only an entry directly connected to its parent. Digging
+down the directory hierarchy is unnecessary.
+
+VFS has a function lookup_one_len() for that use, but it is not usable
+for a branch filesystem which requires struct nameidata. So aufs
+implements a simple lookup wrapper function. When a branch filesystem
+allows NULL as nameidata, it calls lookup_one_len(). Otherwise it builds
+a simplest nameidata and calls lookup_hash().
+Here aufs applies "a principle in NFSD", ie. if the filesystem supports
+NFS-export, then it has to support NULL as a nameidata parameter for
+->create(), ->lookup() and ->d_revalidate(). So the lookup wrapper in
+aufs tests if ->s_export_op in the branch is NULL or not.
+
+When a branch is a remote filesystem, aufs trusts its ->d_revalidate().
+For d_revalidate, aufs implements three levels of revalidate tests. See
+"Revalidate Dentry and UDBA" in detail.
+
+
+Loopback Mount
+----------------------------------------------------------------------
+Basically aufs supports any type of filesystem and block device for a
+branch (actually there are some exceptions). But it is prohibited to add
+a loopback mounted one whose backend file exists in a filesystem which is
+already added to aufs. The reason is to protect aufs from a recursive
+lookup. If it was allowed, the aufs lookup operation might re-enter a
+lookup for the loopback mounted branch in the same context, and will
+cause a deadlock.
+
+
+Revalidate Dentry and UDBA (User's Direct Branch Access)
+----------------------------------------------------------------------
+Generally VFS helpers re-validate a dentry as a part of lookup.
+0. digging down the directory hierarchy.
+1. lock the parent dir by its i_mutex.
+2. lookup the final (child) entry.
+3. revalidate it.
+4. call the actual operation (create, unlink, etc.)
+5. unlock the parent dir
+
+If the filesystem implements its ->d_revalidate() (step 3), then it is
+called. Actually aufs implements it and checks the dentry on a branch is
+still valid.
+But it is not enough. Because aufs has to release the lock for the
+parent dir on a branch at the end of ->lookup() (step 2) and
+->d_revalidate() (step 3) while the i_mutex of the aufs dir is still
+held by VFS.
+If the file on a branch is changed directly, eg. bypassing aufs, after
+aufs released the lock, then the subsequent operation may cause
+something unpleasant result.
+
+This situation is a result of VFS architecture, ->lookup() and
+->d_revalidate() is separated. But I never say it is wrong. It is a good
+design from VFS's point of view. It is just not suitable for sub-VFS
+character in aufs.
+
+Aufs supports such case by three level of revalidation which is
+selectable by user.
+1. Simple Revalidate
+   Addition to the native flow in VFS's, confirm the child-parent
+   relationship on the branch just after locking the parent dir on the
+   branch in the "actual operation" (step 4). When this validation
+   fails, aufs returns EBUSY. ->d_revalidate() (step 3) in aufs still
+   checks the validation of the dentry on branches.
+2. Monitor Changes Internally by Inotify
+   Addition to above, in the "actual operation" (step 4) aufs re-lookup
+   the dentry on the branch, and returns EBUSY if it finds different
+   dentry.
+   Additionally, aufs sets the inotify watch for every dir on branches
+   during it is in cache. When the event is notified, aufs registers a
+   function to kernel 'events' thread by schedule_work(). And the
+   function sets some special status to the cached aufs dentry and inode
+   private data. If they are not cached, then aufs has nothing to
+   do. When the same file is accessed through aufs (step 0-3) later,
+   aufs will detect the status and refresh all necessary data.
+   In this mode, aufs has to ignore the event which is fired by aufs
+   itself.
+3. No Extra Validation
+   This is the simplest test and doesn't add any additional revalidation
+   test, and skip therevalidatin in step 4. It is useful and improves
+   aufs performance when system surely hide the aufs branches from user,
+   by over-mounting something (or another method).
diff --git a/Documentation/filesystems/aufs/design/04branch.txt b/Documentation/filesystems/aufs/design/04branch.txt
new file mode 100644
index 0000000..78432c5
--- /dev/null
+++ b/Documentation/filesystems/aufs/design/04branch.txt
@@ -0,0 +1,67 @@
+
+# Copyright (C) 2005-2009 Junjiro R. Okajima
+# 
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+Branch Manipulation
+
+Since aufs supports dynamic branch manipulation, ie. add/remove a branch
+and changing its permission/attribute, there are a lot of works to do.
+
+
+Add a Branch
+----------------------------------------------------------------------
+o Confirm the adding dir exists outside of aufs, including loopback
+  mount.
+- and other various attributes...
+o Initialize the xino file and whiteout bases if necessary.
+  See struct.txt.
+
+o Check the owner/group/mode of the directory
+  When the owner/group/mode of the adding directory differs from the
+  existing branch, aufs issues a warning because it may impose a
+  security risk.
+  For example, when a upper writable branch has a world writable empty
+  top directory, a malicious user can create any files on the writable
+  branch directly, like copy-up and modify manually. If something like
+  /etc/{passwd,shadow} exists on the lower readonly branch but the upper
+  writable branch, and the writable branch is world-writable, then a
+  malicious guy may create /etc/passwd on the writable branch directly
+  and the infected file will be valid in aufs.
+  I am afraid it can be a security issue, but nothing to do except
+  producing a warning.
+
+
+Delete a Branch
+----------------------------------------------------------------------
+o Confirm the deleting branch is not busy
+  To be general, there is one merit to adopt "remount" interface to
+  manipulate branches. It is to discard caches. At deleting a branch,
+  aufs checks the still cached (and connected) dentries and inodes. If
+  there are any, then they are all in-use. An inode without its
+  corresponding dentry can be alive alone (for example, inotify case).
+
+  For the cached one, aufs checks whether the same named entry exists on
+  other branches.
+  If the cached one is a directory, because aufs provides a merged view
+  to users, as long as one dir is left on any branch aufs can show the
+  dir to users. In this case, the branch can be removed from aufs.
+  Otherwise aufs rejects deleting the branch.
+
+  If any file on the deleting branch is opened by aufs, then aufs
+  rejects deleting.
+
+
+Modify the Permission of a Branch
+----------------------------------------------------------------------
+o Re-initialize or remove the xino file and whiteout bases if necessary.
+  See struct.txt.
+
+o rw --> ro: Confirm the modifying branch is not busy
+  Aufs rejects the request if any of these conditions are true.
+  - a file on the branch is mmap-ed.
+  - a regular file on the branch is opened for write and there is no
+    same named entry on the upper branch.
diff --git a/Documentation/filesystems/aufs/design/05wbr_policy.txt b/Documentation/filesystems/aufs/design/05wbr_policy.txt
new file mode 100644
index 0000000..d9720ca
--- /dev/null
+++ b/Documentation/filesystems/aufs/design/05wbr_policy.txt
@@ -0,0 +1,57 @@
+
+# Copyright (C) 2005-2009 Junjiro R. Okajima
+# 
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+
+Policies to Select One among Multiple Writable Branches
+----------------------------------------------------------------------
+When the number of writable branch is more than one, aufs has to decide
+the target branch for file creation or copy-up. By default, the highest
+writable branch which has the parent (or ancestor) dir of the target
+file is chosen (top-down-parent policy).
+By user's request, aufs implements some other policies to select the
+writable branch, for file creation two policies, round-robin and
+most-free-space policies. For copy-up three policies, top-down-parent,
+bottom-up-parent and bottom-up policies.
+
+As expected, the round-robin policy selects the branch in circular. When
+you have two writable branches and creates 10 new files, 5 files will be
+created for each branch. mkdir(2) systemcall is an exception. When you
+create 10 new directories, all will be created on the same branch.
+And the most-free-space policy selects the one which has most free
+space among the writable branches. The amount of free space will be
+checked by aufs internally, and users can specify its time interval.
+
+The policies for copy-up is more simple,
+top-down-parent is equivalent to the same named on in create policy,
+bottom-up-parent selects the writable branch where the parent dir
+exists and the nearest upper one from the copyup-source,
+bottom-up selects the nearest upper writable branch from the
+copyup-source, regardless the existence of the parent dir.
+
+There are some rules or exceptions to apply these policies.
+- If there is a readonly branch above the policy-selected branch and
+  the parent dir is marked as opaque (a variation of whiteout), or the
+  target (creating) file is whiteout-ed on the upper readonly branch,
+  then the result of the policy is ignored and the target file will be
+  created on the nearest upper writable branch than the readonly branch.
+- If there is a writable branch above the policy-selected branch and
+  the parent dir is marked as opaque or the target file is whiteouted
+  on the branch, then the result of the policy is ignored and the target
+  file will be created on the highest one among the upper writable
+  branches who has diropq or whiteout. In case of whiteout, aufs removes
+  it as usual.
+- link(2) and rename(2) systemcalls are exceptions in every policy.
+  They try selecting the branch where the source exists as possible
+  since copyup a large file will take long time. If it can't be,
+  ie. the branch where the source exists is readonly, then they will
+  follow the copyup policy.
+- There is an exception for rename(2) when the target exists.
+  If the rename target exists, aufs compares the index of the branches
+  where the source and the target exists and selects the higher
+  one. If the selected branch is readonly, then aufs follows the
+  copyup policy.
diff --git a/Documentation/filesystems/aufs/design/06fmode_exec.txt b/Documentation/filesystems/aufs/design/06fmode_exec.txt
new file mode 100644
index 0000000..b172cd1
--- /dev/null
+++ b/Documentation/filesystems/aufs/design/06fmode_exec.txt
@@ -0,0 +1,24 @@
+
+# Copyright (C) 2005-2009 Junjiro R. Okajima
+# 
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+FMODE_EXEC and deny_write()
+----------------------------------------------------------------------
+Generally Unix prevents an executing file from writing its filedata.
+In linux it is implemented by deny_write() and allow_write().
+When a file is executed by exec() family, open_exec() (and sys_uselib())
+they opens the file and calls deny_write(). If the file is aufs's virtual
+one, it has no meaning. The file which deny_write() is really necessary
+is the file on a branch. But the FMODE_EXEC flag is not passed to
+->open() operation. So aufs adopt a dirty trick.
+
+- in order to get FMODE_EXEC, aufs ->lookup() and ->d_revalidate() set
+  nd->intent.open.file->private_data to nd->intent.open.flags temporary.
+- in aufs ->open(), when FMODE_EXEC is set in file->private_data, it
+  calls deny_write() for the file on a branch.
+- when the aufs file is released, allow_write() for the file on a branch
+  is called.
diff --git a/Documentation/filesystems/aufs/design/07mmap.txt b/Documentation/filesystems/aufs/design/07mmap.txt
new file mode 100644
index 0000000..d751c42
--- /dev/null
+++ b/Documentation/filesystems/aufs/design/07mmap.txt
@@ -0,0 +1,44 @@
+
+# Copyright (C) 2005-2009 Junjiro R. Okajima
+# 
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+mmap(2) -- File Memory Mapping
+----------------------------------------------------------------------
+In aufs, the file-mapped pages are shared between the file on a branch
+and the virtual one in aufs by overriding vm_operation, particularly
+->fault().
+
+In aufs_mmap(),
+- get and store vm_ops of the real file on a branch.
+- map the file of aufs by generic_file_mmap() and set aufs's vm
+  operations.
+
+In aufs_fault(),
+- get the file of aufs from the passed vma, sleep if needed.
+- get the real file on a branch from the aufs file.
+- a race may happen. for instance a multithreaded library. so some lock
+  is implemented.
+- call ->fault() in the previously stored vm_ops with setting the
+  real file on a branch to vm_file.
+- restore vm_file and wake_up if someone else got sleep.
+
+When a branch is added to or deleted from aufs, the same-named file may
+unveil and its contents will be replaced by the new one when a process
+read(2) through previously opened file.
+(Some users may not want to refresh the filedata. For such users, I
+have a plan to implement a mount option 'refrof' which decides to
+refresh the opened files or not. See plan.txt too.)
+In this case, an already mapped file will not be updated since the
+contents are a part of a process already and it should not be changed by
+aufs branch manipulation. (Even if MAP_SHARED is specified, currently).
+Of course, in case of the deleting branch has a busy file, it cannot be
+deleted from the union.
+
+In Unionfs, it took an approach which the memory pages mapped to
+filedata are copied from the lower (real) file into the Unionfs's
+virtual one and handles it by address_space operations. Recently Unionfs
+changed it to this approach which aufs adopted since Jul 2006.
diff --git a/Documentation/filesystems/aufs/design/08plan.txt b/Documentation/filesystems/aufs/design/08plan.txt
new file mode 100644
index 0000000..d94bc5b
--- /dev/null
+++ b/Documentation/filesystems/aufs/design/08plan.txt
@@ -0,0 +1,169 @@
+
+# Copyright (C) 2005-2009 Junjiro R. Okajima
+# 
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+Plan
+
+Restoring some features which was implemented in aufs1.
+They were dropped in aufs2 in order to make source files simpler and
+easier to be reviewed.
+
+
+Export Aufs via NFS
+----------------------------------------------------------------------
+Here is an approach I adopt in aufs1.
+- like xino/xib, add a new file 'xigen' which stores aufs inode
+  generation.
+- iget_locked(): initialize aufs inode generation for a new inode, and
+  store it in xigen file.
+- destroy_inode(): increment aufs inode generation and store it in xigen
+  file. it is necessary even if it is not unlinked, because any data of
+  inode may be changed by UDBA.
+- encode_fh(): for a root dir, simply return FILEID_ROOT. otherwise
+  build file handle by
+  + branch id (4 bytes)
+  + superblock generation (4 bytes)
+  + inode number (4 or 8 bytes)
+  + parent dir inode number (4 or 8 bytes)
+  + inode generation (4 bytes))
+  + return value of exportfs_encode_fh() for the parent on a branch (4
+    bytes)
+  + file handle for a branch (by exportfs_encode_fh())
+- fh_to_dentry():
+  + find the index of a branch from its id in handle, and check it is
+    still exist in aufs.
+  + 1st level: get the inode number from handle and search it in cache.
+  + 2nd level: if not found, get the parent inode number from handle and
+    search it in cache. and then open the parent dir, find the matching
+    inode number by vfs_readdir() and get its name, and call
+    lookup_one_len() for the target dentry.
+  + 3rd level: if the parent dir is not cached, call
+    exportfs_decode_fh() for a branch and get the parent on a branch,
+    build a pathname of it, convert it a pathname in aufs, call
+    path_lookup(). now aufs gets a parent dir dentry, then handle it as
+    the 2nd level.
+  + to open the dir, aufs needs struct vfsmount. aufs keeps vfsmount
+    for every branch, but not itself. to get this, (currently) aufs
+    searches in current->nsproxy->mnt_ns list. it may not be a good
+    idea, but I didn't get other approach.
+  + test the generation of the gotten inode.
+- every inode operation: they may get EBUSY due to UDBA. in this case,
+  convert it into ESTALE for NFSD.
+- readdir(): call lockdep_on/off() because filldir in NFSD calls
+  lookup_one_len(), vfs_getattr(), encode_fh() and others.
+
+
+Test Only the Highest One for the Directory Permission (dirperm1 option)
+----------------------------------------------------------------------
+Let's try case study.
+- aufs has two branches, upper readwrite and lower readonly.
+  /au = /rw + /ro
+- "dirA" exists under /ro, but /rw. and its mode is 0700.
+- user invoked "chmod a+rx /au/dirA"
+- then "dirA" becomes world readable?
+
+In this case, /ro/dirA is still 0700 since it exists in readonly branch,
+or it may be a natively readonly filesystem. If aufs respects the lower
+branch, it should not respond readdir request from other users. But user
+allowed it by chmod. Should really aufs rejects showing the entries
+under /ro/dirA?
+
+To be honest, I don't have a best solution for this case. So I
+implemented 'dirperm1' and 'nodirperm1' option in aufs1, and leave it to
+users.
+When dirperm1 is specified, aufs checks only the highest one for the
+directory permission, and shows the entries. Otherwise, as usual, checks
+every dir existing on all branches and rejects the request.
+
+As a side effect, dirperm1 option improves the performance of aufs
+because the number of permission check is reduced.
+
+
+Show Whiteout Mode (shwh)
+----------------------------------------------------------------------
+Generally aufs hides the name of whiteouts. But in some cases, to show
+them is very useful for users. For instance, creating a new middle layer
+(branch) by merging existing layers.
+
+(borrowing aufs1 HOW-TO from a user, Michael Towers)
+When you have three branches,
+- Bottom: 'system', squashfs (underlying base system), read-only
+- Middle: 'mods', squashfs, read-only
+- Top: 'overlay', ram (tmpfs), read-write
+
+The top layer is loaded at boot time and saved at shutdown, to preserve
+the changes made to the system during the session.
+When larger changes have been made, or smaller changes have accumulated,
+the size of the saved top layer data grows. At this point, it would be
+nice to be able to merge the two overlay branches ('mods' and 'overlay')
+and rewrite the 'mods' squashfs, clearing the top layer and thus
+restoring save and load speed.
+
+This merging is simplified by the use of another aufs mount, of just the
+two overlay branches using the 'shwh' option.
+# mount -t aufs -o ro,shwh,br:/livesys/overlay=ro+wh:/livesys/mods=rr+wh \
+	aufs /livesys/merge_union
+
+A merged view of these two branches is then available at
+/livesys/merge_union, and the new feature is that the whiteouts are
+visible!
+Note that in 'shwh' mode the aufs mount must be 'ro', which will disable
+writing to all branches. Also the default mode for all branches is 'ro'.
+It is now possible to save the combined contents of the two overlay
+branches to a new squashfs, e.g.:
+# mksquashfs /livesys/merge_union /path/to/newmods.squash
+
+This new squashfs archive can be stored on the boot device and the
+initramfs will use it to replace the old one at the next boot.
+
+
+Being Another Aufs's Readonly Branch (robr)
+----------------------------------------------------------------------
+Aufs1 allows aufs to be another aufs's readonly branch.
+This feature was developed by a user's request. But it may not be used
+currecnly.
+
+
+Copy-up on Open (coo=)
+----------------------------------------------------------------------
+By default the internal copy-up is executed when it is really necessary.
+It is not done when a file is opened for writing, but when write(2) is
+done. Users who have many (over 100) branches want to know and analyse
+when and what file is copied-up. To insert a new upper branch which
+contains such files only may improve the performance of aufs.
+
+Aufs1 implemented "coo=none | leaf | all" option.
+
+
+Refresh the Opened File (refrof)
+----------------------------------------------------------------------
+This option is implemented in aufs1 but incomplete.
+
+When user reads from a file, he expects to get its latest filedata
+generally. If the file is removed and a new same named file is created,
+the content he gets is unchanged, ie. the unlinked filedata.
+
+Let's try case study again.
+- aufs has two branches.
+  /au = /rw + /ro
+- "fileA" exists under /ro, but /rw.
+- user opened "/au/fileA".
+- he or someone else inserts a branch (/new) between /rw and /ro.
+  /au = /rw + /new + /ro
+- the new branch has "fileA".
+- user reads from the opened "fileA"
+- which filedata should aufs return, from /ro or /new?
+
+Some people says it has to be "from /ro" and it is a semantics of Unix.
+The others say it should be "from /new" because the file is not removed
+and it is equivalent to the case of someone else modifies the file.
+
+Here again I don't have a best and final answer. I got an idea to
+implement 'refrof' and 'norefrof' option. When 'refrof' (REFResh the
+Opened File) is specified (by default), aufs returns the filedata from
+/new.
+Otherwise from /new.
-- 
1.6.1.284.g5dc13

