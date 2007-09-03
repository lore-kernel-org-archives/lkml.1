Return-Path: <linux-kernel-owner+w=401wt.eu-S934438AbXICCjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438AbXICCjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932879AbXICC2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:28:15 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57941 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815AbXICC2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:28:10 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 12/32] Unionfs: documentation updates
Date: Sun,  2 Sep 2007 22:20:35 -0400
Message-Id: <1188786057364-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Details of cache-coherency implementation (as per OLS'07 talk).
Also explain new incgen support via remount, not ioctl.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/concepts.txt |  106 ++++++++++++++++++++++++
 Documentation/filesystems/unionfs/issues.txt   |   53 ++++--------
 Documentation/filesystems/unionfs/usage.txt    |   11 ++-
 3 files changed, 134 insertions(+), 36 deletions(-)

diff --git a/Documentation/filesystems/unionfs/concepts.txt b/Documentation/filesystems/unionfs/concepts.txt
index 83d45b9..74b5bdc 100644
--- a/Documentation/filesystems/unionfs/concepts.txt
+++ b/Documentation/filesystems/unionfs/concepts.txt
@@ -4,6 +4,7 @@ Unionfs 2.0 CONCEPTS:
 This file describes the concepts needed by a namespace unification file
 system.
 
+
 Branch Priority:
 ================
 
@@ -72,4 +73,109 @@ that lookup and readdir return this newer "version" of the file rather than
 the original (see duplicate elimination).
 
 
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
+truncate inode pages (see fs/Unionfs/dentry.c:purge_inode_data).  This is to
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
+
 For more information, see <http://unionfs.filesystems.org/>.
diff --git a/Documentation/filesystems/unionfs/issues.txt b/Documentation/filesystems/unionfs/issues.txt
index c634604..c3a0aef 100644
--- a/Documentation/filesystems/unionfs/issues.txt
+++ b/Documentation/filesystems/unionfs/issues.txt
@@ -1,39 +1,24 @@
-KNOWN Unionfs 2.0 ISSUES:
+KNOWN Unionfs 2.1 ISSUES:
 =========================
 
-1. The NFS server returns -EACCES for read-only exports, instead of -EROFS.
-   This means we can't reliably detect a read-only NFS export.
-
-2. Modifying a Unionfs branch directly, while the union is mounted, is
-   currently unsupported, because it could cause a cache incoherency between
-   the union layer and the lower file systems (for that reason, Unionfs
-   currently prohibits using branches which overlap with each other, even
-   partially).  We have tested Unionfs under such conditions, and fixed any
-   bugs we found (Unionfs comes with an extensive regression test suite).
-   However, it may still be possible that changes made to lower branches
-   directly could cause cache incoherency which, in the worst case, may case
-   an oops.
-
-   Unionfs 2.0 has a temporary workaround for this.  You can force Unionfs
-   to increase the superblock generation number, and hence purge all cached
-   Unionfs objects, which would then  be re-gotten from the lower branches.
-   This should ensure cache consistency.  To increase the generation number,
-   executed the command:
-
-	mount -t unionfs -o remount,incgen none MOUNTPOINT
-
-   Note that the older way of incrementing the generation number using an
-   ioctl, is no longer supported in Unionfs 2.0.  Ioctls in general are not
-   encouraged.  Plus, an ioctl is per-file concept, whereas the generation
-   number is a per-file-system concept.  Worse, such an ioctl requires an
-   open file, which then has to be invalidated by the very nature of the
-   generation number increase (read: the old generation increase ioctl was
-   pretty racy).
-
-3. Unionfs should not use lookup_one_len() on the underlying f/s as it
-   confuses NFS.  Currently, unionfs_lookup() passes lookup intents to the
+1. Unionfs should not use lookup_one_len() on the underlying f/s as it
+   confuses NFSv4.  Currently, unionfs_lookup() passes lookup intents to the
    lower file-system, this eliminates part of the problem.  The remaining
-   calls to lookup_one_len may need to be changed to pass an intent.
-
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
+   to see how to make it aware of stackable file systems.  In the mean time,
+   if you get any warnings from Lockdep, you can safely ignore them (or feel
+   free to report them to the Unionfs maintainers, just to be sure).
 
 For more information, see <http://unionfs.filesystems.org/>.
diff --git a/Documentation/filesystems/unionfs/usage.txt b/Documentation/filesystems/unionfs/usage.txt
index 1c7554b..2316670 100644
--- a/Documentation/filesystems/unionfs/usage.txt
+++ b/Documentation/filesystems/unionfs/usage.txt
@@ -44,7 +44,7 @@ To upgrade a union from read-only to read-write:
 
 To delete a branch /foo, regardless where it is in the current union:
 
-# mount -t unionfs -o del=/foo none MOUNTPOINT
+# mount -t unionfs -o remount,del=/foo none MOUNTPOINT
 
 To insert (add) a branch /foo before /bar:
 
@@ -67,7 +67,7 @@ To append a branch to the very end (new lowest-priority branch):
 To append a branch to the very end (new lowest-priority branch), in
 read-only mode:
 
-# mount -t unionfs -o remount,add=:/foo:ro none MOUNTPOINT
+# mount -t unionfs -o remount,add=:/foo=ro none MOUNTPOINT
 
 Finally, to change the mode of one existing branch, say /foo, from read-only
 to read-write, and change /bar from read-write to read-only:
@@ -86,5 +86,12 @@ command:
 
 # mount -t unionfs -o remount,incgen none MOUNTPOINT
 
+Note that the older way of incrementing the generation number using an
+ioctl, is no longer supported in Unionfs 2.0.  Ioctls in general are not
+encouraged.  Plus, an ioctl is per-file concept, whereas the generation
+number is a per-file-system concept.  Worse, such an ioctl requires an open
+file, which then has to be invalidated by the very nature of the generation
+number increase (read: the old generation increase ioctl was pretty racy).
+
 
 For more information, see <http://unionfs.filesystems.org/>.
-- 
1.5.2.2.238.g7cbf2f2

