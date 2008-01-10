Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbYAJPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbYAJPCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbYAJPAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:00:37 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56988 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbYAJPAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:00:24 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 01/29] Unionfs: documentation
Date: Thu, 10 Jan 2008 09:59:20 -0500
Message-Id: <1199977189383-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Includes index files, MAINTAINERS, and documentation on general concepts,
usage, issues, and renaming operations.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/00-INDEX             |    2 +
 Documentation/filesystems/unionfs/00-INDEX     |   10 +
 Documentation/filesystems/unionfs/concepts.txt |  213 ++++++++++++++++++++++++
 Documentation/filesystems/unionfs/issues.txt   |   28 +++
 Documentation/filesystems/unionfs/rename.txt   |   31 ++++
 Documentation/filesystems/unionfs/usage.txt    |  134 +++++++++++++++
 MAINTAINERS                                    |    9 +
 7 files changed, 427 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/unionfs/00-INDEX
 create mode 100644 Documentation/filesystems/unionfs/concepts.txt
 create mode 100644 Documentation/filesystems/unionfs/issues.txt
 create mode 100644 Documentation/filesystems/unionfs/rename.txt
 create mode 100644 Documentation/filesystems/unionfs/usage.txt

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 1de155e..b168331 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -96,6 +96,8 @@ udf.txt
 	- info and mount options for the UDF filesystem.
 ufs.txt
 	- info on the ufs filesystem.
+unionfs/
+	- info on the unionfs filesystem
 vfat.txt
 	- info on using the VFAT filesystem used in Windows NT and Windows 95
 vfs.txt
diff --git a/Documentation/filesystems/unionfs/00-INDEX b/Documentation/filesystems/unionfs/00-INDEX
new file mode 100644
index 0000000..96fdf67
--- /dev/null
+++ b/Documentation/filesystems/unionfs/00-INDEX
@@ -0,0 +1,10 @@
+00-INDEX
+	- this file.
+concepts.txt
+	- A brief introduction of concepts.
+issues.txt
+	- A summary of known issues with unionfs.
+rename.txt
+	- Information regarding rename operations.
+usage.txt
+	- Usage information and examples.
diff --git a/Documentation/filesystems/unionfs/concepts.txt b/Documentation/filesystems/unionfs/concepts.txt
new file mode 100644
index 0000000..bed69bd
--- /dev/null
+++ b/Documentation/filesystems/unionfs/concepts.txt
@@ -0,0 +1,213 @@
+Unionfs 2.x CONCEPTS:
+=====================
+
+This file describes the concepts needed by a namespace unification file
+system.
+
+
+Branch Priority:
+================
+
+Each branch is assigned a unique priority - starting from 0 (highest
+priority).  No two branches can have the same priority.
+
+
+Branch Mode:
+============
+
+Each branch is assigned a mode - read-write or read-only. This allows
+directories on media mounted read-write to be used in a read-only manner.
+
+
+Whiteouts:
+==========
+
+A whiteout removes a file name from the namespace. Whiteouts are needed when
+one attempts to remove a file on a read-only branch.
+
+Suppose we have a two-branch union, where branch 0 is read-write and branch
+1 is read-only. And a file 'foo' on branch 1:
+
+./b0/
+./b1/
+./b1/foo
+
+The unified view would simply be:
+
+./union/
+./union/foo
+
+Since 'foo' is stored on a read-only branch, it cannot be removed. A
+whiteout is used to remove the name 'foo' from the unified namespace. Again,
+since branch 1 is read-only, the whiteout cannot be created there. So, we
+try on a higher priority (lower numerically) branch and create the whiteout
+there.
+
+./b0/
+./b0/.wh.foo
+./b1/
+./b1/foo
+
+Later, when Unionfs traverses branches (due to lookup or readdir), it
+eliminate 'foo' from the namespace (as well as the whiteout itself.)
+
+
+Duplicate Elimination:
+======================
+
+It is possible for files on different branches to have the same name.
+Unionfs then has to select which instance of the file to show to the user.
+Given the fact that each branch has a priority associated with it, the
+simplest solution is to take the instance from the highest priority
+(numerically lowest value) and "hide" the others.
+
+
+Copyup:
+=======
+
+When a change is made to the contents of a file's data or meta-data, they
+have to be stored somewhere.  The best way is to create a copy of the
+original file on a branch that is writable, and then redirect the write
+though to this copy.  The copy must be made on a higher priority branch so
+that lookup and readdir return this newer "version" of the file rather than
+the original (see duplicate elimination).
+
+An entire unionfs mount can be read-only or read-write.  If it's read-only,
+then none of the branches will be written to, even if some of the branches
+are physically writeable.  If the unionfs mount is read-write, then the
+leftmost (highest priority) branch must be writeable (for copyup to take
+place); the remaining branches can be any mix of read-write and read-only.
+
+In a writeable mount, unionfs will create new files/dir in the leftmost
+branch.  If one tries to modify a file in a read-only branch/media, unionfs
+will copyup the file to the leftmost branch and modify it there.  If you try
+to modify a file from a writeable branch which is not the leftmost branch,
+then unionfs will modify it in that branch; this is useful if you, say,
+unify differnet packages (e.g., apache, sendmail, ftpd, etc.) and you want
+changes to specific package files to remain logically in the directory where
+they came from.
+
+Cache Coherency:
+================
+
+Unionfs users often want to be able to modify files and directories directly
+on the lower branches, and have those changes be visible at the Unionfs
+level.  This means that data (e.g., pages) and meta-data (dentries, inodes,
+open files, etc.) have to be synchronized between the upper and lower
+layers.  In other words, the newest changes from a layer below have to be
+propagated to the Unionfs layer above.  If the two layers are not in sync, a
+cache incoherency ensues, which could lead to application failures and even
+oopses.  The Linux kernel, however, has a rather limited set of mechanisms
+to ensure this inter-layer cache coherency---so Unionfs has to do most of
+the hard work on its own.
+
+Maintaining Invariants:
+
+The way Unionfs ensures cache coherency is as follows.  At each entry point
+to a Unionfs file system method, we call a utility function to validate the
+primary objects of this method.  Generally, we call unionfs_file_revalidate
+on open files, and __unionfs_d_revalidate_chain on dentries (which also
+validates inodes).  These utility functions check to see whether the upper
+Unionfs object is in sync with any of the lower objects that it represents.
+The checks we perform include whether the Unionfs superblock has a newer
+generation number, or if any of the lower objects mtime's or ctime's are
+newer.  (Note: generation numbers change when branch-management commands are
+issued, so in a way, maintaining cache coherency is also very important for
+branch-management.)  If indeed we determine that any Unionfs object is no
+longer in sync with its lower counterparts, then we rebuild that object
+similarly to how we do so for branch-management.
+
+While rebuilding Unionfs's objects, we also purge any page mappings and
+truncate inode pages (see fs/unionfs/dentry.c:purge_inode_data).  This is to
+ensure that Unionfs will re-get the newer data from the lower branches.  We
+perform this purging only if the Unionfs operation in question is a reading
+operation; if Unionfs is performing a data writing operation (e.g., ->write,
+->commit_write, etc.) then we do NOT flush the lower mappings/pages: this is
+because (1) a self-deadlock could occur and (2) the upper Unionfs pages are
+considered more authoritative anyway, as they are newer and will overwrite
+any lower pages.
+
+Unionfs maintains the following important invariant regarding mtime's,
+ctime's, and atime's: the upper inode object's times are the max() of all of
+the lower ones.  For non-directory objects, there's only one object below,
+so the mapping is simple; for directory objects, there could me multiple
+lower objects and we have to sync up with the newest one of all the lower
+ones.  This invariant is important to maintain, especially for directories
+(besides, we need this to be POSIX compliant).  A union could comprise
+multiple writable branches, each of which could change.  If we don't reflect
+the newest possible mtime/ctime, some applications could fail.  For example,
+NFSv2/v3 exports check for newer directory mtimes on the server to determine
+if the client-side attribute cache should be purged.
+
+To maintain these important invariants, of course, Unionfs carefully
+synchronizes upper and lower times in various places.  For example, if we
+copy-up a file to a top-level branch, the parent directory where the file
+was copied up to will now have a new mtime: so after a successful copy-up,
+we sync up with the new top-level branch's parent directory mtime.
+
+Implementation:
+
+This cache-coherency implementation is efficient because it defers any
+synchronizing between the upper and lower layers until absolutely needed.
+Consider the example a common situation where users perform a lot of lower
+changes, such as untarring a whole package.  While these take place,
+typically the user doesn't access the files via Unionfs; only after the
+lower changes are done, does the user try to access the lower files.  With
+our cache-coherency implementation, the entirety of the changes to the lower
+branches will not result in a single CPU cycle spent at the Unionfs level
+until the user invokes a system call that goes through Unionfs.
+
+We have considered two alternate cache-coherency designs.  (1) Using the
+dentry/inode notify functionality to register interest in finding out about
+any lower changes.  This is a somewhat limited and also a heavy-handed
+approach which could result in many notifications to the Unionfs layer upon
+each small change at the lower layer (imagine a file being modified multiple
+times in rapid succession).  (2) Rewriting the VFS to support explicit
+callbacks from lower objects to upper objects.  We began exploring such an
+implementation, but found it to be very complicated--it would have resulted
+in massive VFS/MM changes which are unlikely to be accepted by the LKML
+community.  We therefore believe that our current cache-coherency design and
+implementation represent the best approach at this time.
+
+Limitations:
+
+Our implementation works in that as long as a user process will have caused
+Unionfs to be called, directly or indirectly, even to just do
+->d_revalidate; then we will have purged the current Unionfs data and the
+process will see the new data.  For example, a process that continually
+re-reads the same file's data will see the NEW data as soon as the lower
+file had changed, upon the next read(2) syscall (even if the file is still
+open!)  However, this doesn't work when the process re-reads the open file's
+data via mmap(2) (unless the user unmaps/closes the file and remaps/reopens
+it).  Once we respond to ->readpage(s), then the kernel maps the page into
+the process's address space and there doesn't appear to be a way to force
+the kernel to invalidate those pages/mappings, and force the process to
+re-issue ->readpage.  If there's a way to invalidate active mappings and
+force a ->readpage, let us know please (invalidate_inode_pages2 doesn't do
+the trick).
+
+Our current Unionfs code has to perform many file-revalidation calls.  It
+would be really nice if the VFS would export an optional file system hook
+->file_revalidate (similarly to dentry->d_revalidate) that will be called
+before each VFS op that has a "struct file" in it.
+
+Certain file systems have micro-second granularity (or better) for inode
+times, and asynchronous actions could cause those times to change with some
+small delay.  In such cases, Unionfs may see a changed inode time that only
+differs by a tiny fraction of a second: such a change may be a false
+positive indication that the lower object has changed, whereas if unionfs
+waits a little longer, that false indication will not be seen.  (These false
+positives are harmless, because they would at most cause unionfs to
+re-validate an object that may need no revalidation, and print a debugging
+message that clutters the console/logs.)  Therefore, to minimize the chances
+of these situations, we delay the detection of changed times by a small
+factor of a few seconds, called UNIONFS_MIN_CC_TIME (which defaults to 3
+seconds, as does NFS).  This means that we will detect the change, only a
+couple of seconds later, if indeed the time change persists in the lower
+file object.  This delayed detection has an added performance benefit: we
+reduce the number of times that unionfs has to revalidate objects, in case
+there's a lot of concurrent activity on both the upper and lower objects,
+for the same file(s).  Lastly, this delayed time attribute detection is
+similar to how NFS clients operate (e.g., acregmin).
+
+For more information, see <http://unionfs.filesystems.org/>.
diff --git a/Documentation/filesystems/unionfs/issues.txt b/Documentation/filesystems/unionfs/issues.txt
new file mode 100644
index 0000000..f4b7e7e
--- /dev/null
+++ b/Documentation/filesystems/unionfs/issues.txt
@@ -0,0 +1,28 @@
+KNOWN Unionfs 2.x ISSUES:
+=========================
+
+1. Unionfs should not use lookup_one_len() on the underlying f/s as it
+   confuses NFSv4.  Currently, unionfs_lookup() passes lookup intents to the
+   lower file-system, this eliminates part of the problem.  The remaining
+   calls to lookup_one_len may need to be changed to pass an intent.  We are
+   currently introducing VFS changes to fs/namei.c's do_path_lookup() to
+   allow proper file lookup and opening in stackable file systems.
+
+2. Lockdep (a debugging feature) isn't aware of stacking, and so it
+   incorrectly complains about locking problems.  The problem boils down to
+   this: Lockdep considers all objects of a certain type to be in the same
+   class, for example, all inodes.  Lockdep doesn't like to see a lock held
+   on two inodes within the same task, and warns that it could lead to a
+   deadlock.  However, stackable file systems do precisely that: they lock
+   an upper object, and then a lower object, in a strict order to avoid
+   locking problems; in addition, Unionfs, as a fan-out file system, may
+   have to lock several lower inodes.  We are currently looking into Lockdep
+   to see how to make it aware of stackable file systems.  For now, we
+   temporarily disable lockdep when calling vfs methods on lower objects,
+   but only for those places where lockdep complained.  While this solution
+   may seem unclean, it is not without precedent: other places in the kernel
+   also do similar temporary disabling, of course after carefully having
+   checked that it is the right thing to do.  Anyway, you get any warnings
+   from Lockdep, please report them to the Unionfs maintainers.
+
+For more information, see <http://unionfs.filesystems.org/>.
diff --git a/Documentation/filesystems/unionfs/rename.txt b/Documentation/filesystems/unionfs/rename.txt
new file mode 100644
index 0000000..e20bb82
--- /dev/null
+++ b/Documentation/filesystems/unionfs/rename.txt
@@ -0,0 +1,31 @@
+Rename is a complex beast. The following table shows which rename(2) operations
+should succeed and which should fail.
+
+o: success
+E: error (either unionfs or vfs)
+X: EXDEV
+
+none = file does not exist
+file = file is a file
+dir  = file is a empty directory
+child= file is a non-empty directory
+wh   = file is a directory containing only whiteouts; this makes it logically
+		empty
+
+                      none    file    dir     child   wh
+file                  o       o       E       E       E
+dir                   o       E       o       E       o
+child                 X       E       X       E       X
+wh                    o       E       o       E       o
+
+
+Renaming directories:
+=====================
+
+Whenever a empty (either physically or logically) directory is being renamed,
+the following sequence of events should take place:
+
+1) Remove whiteouts from both source and destination directory
+2) Rename source to destination
+3) Make destination opaque to prevent anything under it from showing up
+
diff --git a/Documentation/filesystems/unionfs/usage.txt b/Documentation/filesystems/unionfs/usage.txt
new file mode 100644
index 0000000..1adde69
--- /dev/null
+++ b/Documentation/filesystems/unionfs/usage.txt
@@ -0,0 +1,134 @@
+Unionfs is a stackable unification file system, which can appear to merge
+the contents of several directories (branches), while keeping their physical
+content separate.  Unionfs is useful for unified source tree management,
+merged contents of split CD-ROM, merged separate software package
+directories, data grids, and more.  Unionfs allows any mix of read-only and
+read-write branches, as well as insertion and deletion of branches anywhere
+in the fan-out.  To maintain Unix semantics, Unionfs handles elimination of
+duplicates, partial-error conditions, and more.
+
+GENERAL SYNTAX
+==============
+
+# mount -t unionfs -o <OPTIONS>,<BRANCH-OPTIONS> none MOUNTPOINT
+
+OPTIONS can be any legal combination of:
+
+- ro		# mount file system read-only
+- rw		# mount file system read-write
+- remount	# remount the file system (see Branch Management below)
+- incgen	# increment generation no. (see Cache Consistency below)
+
+BRANCH-OPTIONS can be either (1) a list of branches given to the "dirs="
+option, or (2) a list of individual branch manipulation commands, combined
+with the "remount" option, and is further described in the "Branch
+Management" section below.
+
+The syntax for the "dirs=" mount option is:
+
+	dirs=branch[=ro|=rw][:...]
+
+The "dirs=" option takes a colon-delimited list of directories to compose
+the union, with an optional branch mode for each of those directories.
+Directories that come earlier (specified first, on the left) in the list
+have a higher precedence than those which come later.  Additionally,
+read-only or read-write permissions of the branch can be specified by
+appending =ro or =rw (default) to each directory.  See the Copyup section in
+concepts.txt, for a description of Unionfs's behavior when mixing read-only
+and read-write branches and mounts.
+
+Syntax:
+
+	dirs=/branch1[=ro|=rw]:/branch2[=ro|=rw]:...:/branchN[=ro|=rw]
+
+Example:
+
+	dirs=/writable_branch=rw:/read-only_branch=ro
+
+
+BRANCH MANAGEMENT
+=================
+
+Once you mount your union for the first time, using the "dirs=" option, you
+can then change the union's overall mode or reconfigure the branches, using
+the remount option, as follows.
+
+To downgrade a union from read-write to read-only:
+
+# mount -t unionfs -o remount,ro none MOUNTPOINT
+
+To upgrade a union from read-only to read-write:
+
+# mount -t unionfs -o remount,rw none MOUNTPOINT
+
+To delete a branch /foo, regardless where it is in the current union:
+
+# mount -t unionfs -o remount,del=/foo none MOUNTPOINT
+
+To insert (add) a branch /foo before /bar:
+
+# mount -t unionfs -o remount,add=/bar:/foo none MOUNTPOINT
+
+To insert (add) a branch /foo (with the "rw" mode flag) before /bar:
+
+# mount -t unionfs -o remount,add=/bar:/foo=rw none MOUNTPOINT
+
+To insert (add) a branch /foo (in "rw" mode) at the very beginning (i.e., a
+new highest-priority branch), you can use the above syntax, or use a short
+hand version as follows:
+
+# mount -t unionfs -o remount,add=/foo none MOUNTPOINT
+
+To append a branch to the very end (new lowest-priority branch):
+
+# mount -t unionfs -o remount,add=:/foo none MOUNTPOINT
+
+To append a branch to the very end (new lowest-priority branch), in
+read-only mode:
+
+# mount -t unionfs -o remount,add=:/foo=ro none MOUNTPOINT
+
+Finally, to change the mode of one existing branch, say /foo, from read-only
+to read-write, and change /bar from read-write to read-only:
+
+# mount -t unionfs -o remount,mode=/foo=rw,mode=/bar=ro none MOUNTPOINT
+
+Note: in Unionfs 2.x, you cannot set the leftmost branch to readonly because
+then Unionfs won't have any writable place for copyups to take place.
+Moreover, the VFS can get confused when it tries to modify something in a
+file system mounted read-write, but isn't permitted to write to it.
+Instead, you should set the whole union as readonly, as described above.
+If, however, you must set the leftmost branch as readonly, perhaps so you
+can get a snapshot of it at a point in time, then you should insert a new
+writable top-level branch, and mark the one you want as readonly.  This can
+be accomplished as follows, assuming that /foo is your current leftmost
+branch:
+
+# mount -t tmpfs -o size=NNN /new
+# mount -t unionfs -o remount,add=/new,mode=/foo=ro none MOUNTPOINT
+<do what you want safely in /foo>
+# mount -t unionfs -o remount,del=/new,mode=/foo=rw none MOUNTPOINT
+<check if there's anything in /new you want to preserve>
+# umount /new
+
+CACHE CONSISTENCY
+=================
+
+If you modify any file on any of the lower branches directly, while there is
+a Unionfs 2.x mounted above any of those branches, you should tell Unionfs
+to purge its caches and re-get the objects.  To do that, you have to
+increment the generation number of the superblock using the following
+command:
+
+# mount -t unionfs -o remount,incgen none MOUNTPOINT
+
+Note that the older way of incrementing the generation number using an
+ioctl, is no longer supported in Unionfs 2.0 and newer.  Ioctls in general
+are not encouraged.  Plus, an ioctl is per-file concept, whereas the
+generation number is a per-file-system concept.  Worse, such an ioctl
+requires an open file, which then has to be invalidated by the very nature
+of the generation number increase (read: the old generation increase ioctl
+was pretty racy).
+
+
+For more information, see <http://unionfs.filesystems.org/>.
diff --git a/MAINTAINERS b/MAINTAINERS
index b4f611c..d68b687 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3804,6 +3804,15 @@ L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
 
+UNIONFS
+P:	Erez Zadok
+M:	ezk@cs.sunysb.edu
+P:	Josef "Jeff" Sipek
+M:	jsipek@cs.sunysb.edu
+L:	unionfs@filesystems.org
+W:	http://unionfs.filesystems.org
+S:	Maintained
+
 USB ACM DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
-- 
1.5.2.2

