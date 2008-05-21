Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbYEUDXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbYEUDXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYEUDXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:23:17 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:43924 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYEUDXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:23:13 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 01/39] aufs documents
Date: Wed, 21 May 2008 12:22:31 +0900
Message-Id: <1211340189-11813-2-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs documents

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/filesystems/aufs/Design |  311 +++++++++++++++++++++++++++++++++
 Documentation/filesystems/aufs/README |  152 ++++++++++++++++
 2 files changed, 463 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/aufs/Design
 create mode 100644 Documentation/filesystems/aufs/README

diff --git a/Documentation/filesystems/aufs/Design b/Documentation/filesystems/aufs/Design
new file mode 100644
index 0000000..d6276dd
--- /dev/null
+++ b/Documentation/filesystems/aufs/Design
@@ -0,0 +1,311 @@
+
+This file is equivalent to the past mail messages, titled
+"AUFS: merging/stacking several filesystems"
+which were posted to linux-fsdevel ML in Apr 2008.
+
+Junjiro Okajima
+
+----------------------------------------------------------------------
+
+Hello fs-developers,
+
+I am developing a stackable unification filesystem which unifies several
+directories and provides a merged single directory.
+I guess most people already knows what it is. When users access a file,
+the access will be passed/re-directed/converted (sorry, I am not sure
+which English word is correct) to the real file on the member
+filesystem. The member filesystem is called 'lower filesytstem' or
+'branch' and has a mode 'readonly' and 'readwrite.' And the file
+deletion is handled as 'whiteout' on the upper writable branch.
+
+On this ML, there have been discussions about UnionMount (Jan Blunck
+and Bharata B Rao) and Unionfs (Erez Zadok). They took different
+approaches to implement the merged-view.
+The former tries putting it into VFS, and the latter implements as a
+separate filesystem.
+(If I misunderstand about these implementations, please let me know and
+I shall correct it. Because it is a long time ago when I read their
+source files last time.)
+UnionMount's approach will be able to small, but may be hard to share
+branches between several UnionMount since the whiteout in it is
+implemented in the inode on branch filesystem and always
+shared. According to Bharata's recent post, readdir does not seems to
+be finished yet.
+Unionfs has a longer history. When I got the idea of stacking
+filesystem (Aug 2005), it already existed. It has virtual super_block,
+inode, dentry and file objects and they have an array pointing lower
+same kind objects. After contributing many patches for Unionfs, I
+re-started my project AUFS (Jun 2006).
+
+In AUFS, the structure of filesystem is simlilar to Unionfs, but I
+implemented my own ideas, approaches and enhancements in it.
+Here are some of them and the intention of this post is to get some
+initial feedback about its design.
+You can see the actual details, documents, CVS logs, and how people
+are using it from
+<http://aufs.sf.net>.
+
+Kindly review and let me know your comments.
+
+
+o file mapping -- mmap and sharing pages
+----------------------------------------------------------------------
+In AUFS, the file-mapped pages are shared between the lower file and
+the AUFS's virtual one by overriding vm_operation, particularly
+->fault().
+
+In aufs_mmap(),
+- get and store vm_ops of the lower file.
+- map the file of aufs by generic_file_mmap() and set aufs's vm operations.
+
+In aufs_fault(),
+- a race can happen. for instance a multithreaded library.
+- get the file of aufs from the passed vma, sleep if needed.
+- get the lower file from the aufs file.
+- call ->fault() in the previously stored vm_ops with setting the
+  lower file to vm_file.
+- restore vm_file and wake_up if someone else got sleep.
+
+When a member filesystem is added to or deleted from the stack (often
+called union), the same-named file may unveil and its contents will be
+replaced by the new one when a process read(2) through previously
+opened file.
+(Some users may not want to refresh the filedata. For such users, I
+have a plan to implement a mount option 'refrof' which decides to
+refresh the opened files or not.)
+In this case, an already mapped file will not be updated since the
+contents are a part of a process and it should not be changed by AUFS
+branch management. Of course, in case of the deleting branch has a
+busy file, it cannot be deleted from the union.
+
+In UnionMount, it won't be matter since it doesn't have its own inode
+and file object.
+In Unionfs, the memory pages mapped to filedata are copied from
+the lower (real) file into the Unionfs's virtual one and handles it by
+address_space operations. Recently Unionfs changed it to the one I
+suggested in last December which AUFS took (since Jul 2006).
+
+
+o external inode number table and bitmap (XINO/XIB)
+----------------------------------------------------------------------
+Because aufs has its own virtual inode, it has to manage the inode
+number. Generally iunique() is used for this purpose, but when a user
+execute chmod/chown -R to a large directory or rmdir to a dir who has
+child, a problem may arise. Because chmod/chown -R checks the
+inode number, it may be changed/re-assigned silently/internally and
+the command will return an error. In rmdir, dentry_unhash() is called
+and its child dentry/inode is unhashed. It means the inode number for
+the child will be changed/re-assigned when then will be accessed again.
+
+To keep the inode number unchanged, aufs has an external inode number
+table and bitmap (which are called 'xino' and 'xib') per a branch
+filesystem. The table is a regular file which is created on the first
+writable branch automatically be default. When several branches exist
+on the same (real) filesystem, those files will be shared.
+If xino/xib is unnecessary for user, he can specify 'noxino' mount
+option and disable it.
+Aufs shows the size of these files via sysfs.
+
+Currently these xino/xib are created and deleted at the aufs mount
+time (the files are still opened), but I have a request from users who
+are using aufs on NFS server and exporting. So I will implement an
+option not to delete xino/xib files and re-use it after NFS server
+reboot.
+
+In UnionMount, it won't be matter since it doesn't have its own inode.
+In Unionfs, they took iunique() approach and still have above
+problem. But they already started Unionfs-ODF branch which has another
+mounted filesystem and delegate the inode number management to it. The
+ODF approach has some overhead since it requires to create/remove
+files/dirs on another filesystem.
+
+
+o cache coherency or user's direct access to branch filesystems
+  (UDBA) -- inotify
+----------------------------------------------------------------------
+Users may create/delete/change files on branch, bypassing aufs, at
+anytime (user's direct access, UDBA). Because aufs has its own inode
+and file objects and they are cached in a generic way, it has to
+maintain the inode attribute and the directory listing.
+
+In order to implement this, aufs has three levels of detect-test. The
+most strict test is using inotify(CONFIG_INOTIFY) feature. When a user
+specifies this test level, aufs will set inotify-watch to all the
+branch dir in cache. When an aufs dir inode object is created and
+cached, it will refer the real dirs on branches, and aufs sets
+inotify-watch to them and will be notified when UDBA occurs. The watch
+will be cleared when the aufs dir inode is purged from the system
+inode cache.
+When UDBA occurs, aufs registers a function to 'events' thread by
+schedule_work(), and the function sets some special status to the
+cached aufs inode private data. When the same file is accessed through
+aufs, aufs will detect the status and refresh all necessary data.
+
+The other two levels of test don't use inotify. The most simple test
+level checks nothing. It is for readonly filesystems such as
+cdrom (Even if the most strict test is specified, aufs doesn't set
+inotify to such filesystems). The middle level (default) is
+checking/comparing inode attributes in d_revalidate(). It means this
+test level may not be effective for a negative dentry.
+In most cases, I guess the default level is enough and users can execute
+'mount -o remount /aufs' to discard the unused caches. But if a user
+really want to reflect the UDBA soon, the highest test option will help
+him/her.
+
+
+o hardlink over branches, pseudo-link
+----------------------------------------------------------------------
+When a file on a lower readonly branch is hard-linked (fileA and
+fileB) and a user modifies fileA, aufs will copy-up it to the upper
+writable branch and make the originally requested change to fileA on
+the upper branch. On the writable branch, fileA is not hardlinked. It
+means fileB on the lower branch still have the old contents.
+
+To address this problem, aufs introduced a 'pseudo-link' (plink) which
+is a logical hardlink over branches. It maintains the simple inode list
+on memory and checks the accessed inode is in the list.
+Finally fileB is handled as if it existed on the writable branch, by
+referencing fileA's inode on the writable branch as fileB's inode.
+
+Additionally, to support the case of fileA on the writable branch is
+deleted, aufs creates another hardlink on the writable branch which
+exists under a special directory to hide it from users.
+
+At remount/umount time, /sbin/{mount,umount}.aufs script checks the
+pseudo-linked inode list in aufs, re-produces all real hardlinks on
+the writable branch, and flushes the list on memory (But these script
+has a potential race problem).
+
+
+o readdir -- virtual dir block on memory (VDIR)
+----------------------------------------------------------------------
+This is an approach I posted a few months ago replying UnionMount's
+post. It constructs a virtual dir block on memory. For readdir, aufs
+calls vfs_readdir() internally for each lower dirs, merges their
+entries with eliminating the whiteout-ed ones, and gives it the the
+file (dir) object. So the file object has its entry list until it is
+closed. The entry list will be updated when the file position is zero
+and becomes old. This decision is made in aufs automatically.
+
+It may consume rather large memory and cpu cycles. To reduce the number
+of memory allocations, the implementation became rather tricky .
+
+Some people may call it can be a security hole or DoS attack since the
+opened and once readdir-ed dir (file object) holds its entry list and
+becomes a pressure for system memory. But I'd say it is similar to
+files under /proc or /sys. The virtual files on procfs and sysfs also
+holds a memory page (generally) while they are opened. When an idea to
+reduce memory for them is introduced, it will be applied to aufs too.
+
+
+o policies for selecting one among multiple writable branches,
+  parent-dir, round-robin and most-free-space
+----------------------------------------------------------------------
+When the number of writable branch is more than one, aufs has to decide
+the target branch for file creation or copy-up. By default, the highest
+writable branch which has the parent (or ancestor) dir of the target
+file is chosen (top-down-parent policy).
+By user's request, aufs has some other policies to select the writable
+branch, round-robin and most-free-space policies for file creation, and
+top-down-parent, bottom-up-parent and bottom-up policies for copy-up.
+
+As expected, the round-robin policy selects in circular. When you have
+two writable branches and creates 10 new files, 5 files will be
+created for each branch. mkdir(2) systemcall is an exception. When you
+create 10 new directories, all are created on the same branch.
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
+  then the policy will be ignored and the target file will be created
+  on the nearest upper writable branch than the readonly branch.
+- If there is a writable branch above the policy-selected branch and
+  the parent dir is marked as opaque or the target file is whiteouted
+  on the branch, then the policy will be ignored and the target file
+  will be created on the highest one among the upper writable branches
+  who has diropq or whiteout. In case of whiteout, aufs removes it as
+  usual.
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
+
+
+o revert everything after an error on a branch in a single systemcall,
+  and remove/rename dir -- temporary name and EXDEV
+----------------------------------------------------------------------
+Since aufs handles several filesystems internally, it is important to
+revert everything after an error happend on a branch internally, and
+returns the expected error of systemcall.
+To do this, aufs selects only one target writable branch for
+create/remove operations and didn't change other
+branches. Additionally aufs has to pay attention the order of internal
+operaion to make it revertible at any point. The general rule is here.
+
+For creation,
+- lock the real dir on the target branch
+- lookup a whiteout for the target
+- actual creation of the target
+- unlink the whiteout for it, if exists
+- d_instantiate()
+- unlock the real dir
+
+For removal,
+- lock the real dir on the target branch
+- create a whiteout for the target, if needed
+- actual removal of the target, if it exists on the target branch
+- unlock the real dir
+
+Generally rename(2) can handle the destination dir which already
+exists, and aufs_rename() basically calls vfs_rename() on the writable
+branch. When an empty dst-dir exists on the lower branch(es), aufs has
+to make the renamed dir opaque (which is a variation of whiteout and
+called 'diropq') by creating a special 'diropq' file under the renamed
+dir.
+If aufs cannot create the 'diropq' file, aufs cannot revert the
+previous vfs_rename().
+
+To address this problem, aufs renames the existing dst-dir to the
+temporary new whiteout-ed name before the actual vfs_rename(). After
+all operations succeeded, aufs_rename() passes the temporary name to
+another kernel thread and returns.
+The kernel thread removes the temporary name later.
+If aufs cannot create the 'diropq' file, it tries vfs_rename() the
+src-dir to its old name, and the temporary name to the old dst-dir name.
+
+This approach is implemented in aufs_rmdir() too (except the branch is
+NFS), and very effective when the target dir has many whiteouts since
+aufs has to unlink the child whiteouts before calling vfs_rmdir().
+It may take long time and user has to wait for the completion of
+_logically_ empty dir is removed.
+With this approach, user don't need to wait so long time.
+But the number of child whiteout is not so much, nobody likes this
+overhead. So aufs has an option which specifies the threshold of the
+number of child whiteouts.
+
+In rename(2), when the target dir has its child on several branches,
+aufs_rename() returns -EXDEV, since it may cause many/long internal
+copy-up. Generally mv(1) supports this case and retries create/copy
+for each children.
+
+
+# Local variables: ;
+# mode: text;
+# End: ;
diff --git a/Documentation/filesystems/aufs/README b/Documentation/filesystems/aufs/README
new file mode 100644
index 0000000..2cd2184
--- /dev/null
+++ b/Documentation/filesystems/aufs/README
@@ -0,0 +1,152 @@
+
+Aufs -- Another Unionfs
+Junjiro Okajima
+2008/05/21
+http://aufs.sf.net
+
+
+Introduction
+----------------------------------------
+In the early days, aufs was entirely re-designed and re-implemented
+Unionfs Version 1.x series. After many original ideas, approaches,
+improvements and implementations, it becomes totally different from
+Unionfs while keeping the basic features.
+Recently, Unionfs Version 2.x series begin taking some of same
+approaches to aufs's.
+Unionfs is being developed by Professor Erez Zadok at Stony Brook
+University and his team.
+If you don't know Unionfs, I recommend you becoming familiar with it
+before using aufs. Some terminology in aufs follows Unionfs's.
+
+Bug reports (including my broken English), suggestions, comments
+and donations are always welcome. Your bug report may help other users,
+including future users. Especially the bug report which doesn't follow
+unix/linux filesystem's semantics is important.
+
+
+Features
+----------------------------------------
+- unite several directories into a single virtual filesystem. The member
+  directory is called as a branch.
+- you can specify the permission flags to the branch, which are 'readonly',
+  'readwrite' and 'whiteout-able.'
+- by upper writable branch, internal copyup and whiteout, files/dirs on
+  readonly branch are modifiable logically.
+- dynamic branch manipulation, add, del.
+- etc... see Unionfs in detail.
+
+Also there are many enhancements in aufs, such as:
+- keep inode number by external inode number table
+- keep the timestamps of file/dir in internal copyup operation
+- seekable directory, supporting NFS readdir.
+- support mmap(2) including /proc/PID/exe symlink, without page-copy
+- whiteout is hardlinked in order to reduce the consumption of inodes
+  on branch
+- do not copyup, nor create a whiteout when it is unnecessary
+- revert a single systemcall when an error occurs in aufs
+- remount interface instead of ioctl
+- maintain /etc/mtab by an external shell script, /sbin/mount.aufs.
+- loopback mounted filesystem as a branch
+- kernel thread for removing the dir who has a plenty of whiteouts
+- support copyup sparse file (a file which has a 'hole' in it)
+- default permission flags for branches
+- selectable permission flags for ro branch, whether whiteout can
+  exist or not
+- export via NFS.
+- support <sysfs>/fs/aufs.
+- support multiple writable branches, some policies to select one
+  among multiple writable branches.
+- a new semantics for link(2) and rename(2) to support multiple
+  writable branches.
+- a delegation of the internal branch access to support task I/O
+  accounting, which also supports Linux Security Modules (LSM) mainly
+  for Suse AppArmor.
+- nested mount, i.e. aufs as readonly no-whiteout branch of another aufs.
+- copyup-on-open or copyup-on-write
+- show-whiteout mode
+- no glibc changes are required.
+- and more... see aufs manual in detail
+
+Aufs is in still development stage, especially:
+- pseudo hardlink (hardlink over branches)
+- allow a direct access manually to a file on branch, e.g. bypassing aufs.
+  including NFS or remote filesystem branch.
+- refine xino and revalidate
+- pseudo-link in NFS-exporting
+
+(current work)
+- reorder the branch index without del/re-add.
+- permanent xino files
+
+(next work)
+- an option for refreshing the opened files after add/del branches
+- 'move' policy for copy-up between two writable branches, after
+  checking free space.
+- ioctl to manipulate file between branches.
+- and documentation
+
+(just an idea)
+- remount option copy/move between two branches. (unnecessary?)
+- O_DIRECT (unnecessary?)
+- light version, without branch manipulation. (unnecessary?)
+- SMP, because I don't have such machine. But several users reported
+  aufs is working fine on SMP machines.
+- copyup in userspace
+- inotify in userspace
+- xattr, acl
+
+
+Usage
+----------------------------------------
+	$ cd Documentation/filesystems/aufs
+	$ man -l ./aufs.5
+	$ make aulchown
+	# install -m 500 -p mount.aufs umount.aufs auplink aulchown /sbin (recommended)
+	# echo FLUSH=ALL > /etc/default/auplink (recommended)
+
+	$ mkdir /tmp/rw /tmp/aufs
+	# mount -t aufs -o dirs=/tmp/rw:${HOME}=ro none /tmp/aufs
+
+Here is another example.
+
+	# mount -t aufs -o br:/tmp/rw:${HOME}=ro none /tmp/aufs
+	or
+	# mount -t aufs -o br:/tmp/rw none /tmp/aufs
+	# mount -o remount,append:${HOME}=ro /tmp/aufs
+
+If you disable CONFIG_AUFS_COMPAT in your configuration, you can remove the
+default branch permission '=ro' since '=rw' is set to the first branch
+only by default.
+
+	# mount -t aufs -o br:/tmp/rw:${HOME} none /tmp/aufs
+
+Then, you can see whole tree of your home dir through /tmp/aufs. If
+you modify a file under /tmp/aufs, the one on your home directory is
+not affected, instead the same named file will be newly created under
+/tmp/rw. And all of your modification to the file will be applied to
+the one under /tmp/rw. This is called the file based Copy on Write
+(COW) method.
+Aufs mount options are described in the generated aufs.5 manual file.
+
+Additionally, there are some sample usages of aufs which are a
+diskless system with network booting, and LiveCD over NFS.
+See http://aufs.sf.net in detail.
+
+
+Acknowledgements
+----------------------------------------
+Thanks to everyone who have tried and are using aufs, especially who
+have reported a bug or any feedback.
+
+Tomas Matejicek(slax.org) made a donation (much more than once).
+Dai Itasaka made a donation (2007/8).
+Chuck Smith made a donation (2008/4).
+
+Thank you very much.
+Donations are always, including future donations, very important and
+helpful for me to keep on developing aufs.
+
+
+# Local variables: ;
+# mode: text;
+# End: ;
-- 
1.5.5.1.308.g1fbb5.dirty

