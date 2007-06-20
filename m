Return-Path: <linux-kernel-owner+w=401wt.eu-S1762461AbXFTFop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762461AbXFTFop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 01:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbXFTFog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 01:44:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60650 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006AbXFTFoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 01:44:34 -0400
Date: Wed, 20 Jun 2007 11:21:57 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC PATCH 1/4] Union mount documentation.
Message-ID: <20070620055157.GC4267@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070620055050.GB4267@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620055050.GB4267@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Union mount documentation.

Adds union mount documentation.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 Documentation/union-mounts.txt |  232 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 232 insertions(+)

--- /dev/null
+++ b/Documentation/union-mounts.txt
@@ -0,0 +1,232 @@
+VFS BASED UNION MOUNT
+=====================
+
+1. What is Union Mount ?
+2. Recap
+3. The new approach
+4. Union stack: building and traversal
+5. Union stack: destroying
+6. Directory lising
+7. What works and what doesn't ?
+8. Usage
+9. References
+
+1. What is Union Mount ?
+------------------------
+Union mount allows mounting of two or more filesystems transparently on
+a single mount point. Contents (files or directories) of all the
+filesystems become visible at the mount point after a union mount. If
+there are files with the same name in multiple layers of the union, only
+the topmost files remain visible. Contents of common named directories are
+merged again to present a unified view at the subdirectory level.
+
+In this approach of filesystem namespace unification, the layering or
+stacking information of different components (filesystems) of the union
+mount are maintained at the VFS layer. Hence, this is referred to as VFS
+based union mount.
+
+2. Recap
+--------
+Jan Blunck had developed a version of VFS based union mount in 2003-4.
+This version was cleaned up and ported to later kernels. Early in year
+2007, two iterations of these patches were posted for review (Ref 1, Ref 2).
+But, this approach had a few shortcomings:
+
+- It wasn't designed to work with shared subtree additions to mount.
+- It didn't work well when same filesystem was mounted from different
+  namespaces, as it maintained the union stack at dentry level.
+- It made dget() sleep.
+- The union stack was built using dentries and this was too fragile. This
+  made the code complex and the locking ugly.
+
+3. The new approach
+-------------------
+In this new approach, the way union stack is built and traversed has been
+changed. Instead of dentry-to-dentry links forming the stack between
+different layers, we now have (vfsmount, dentry) pairs as the building
+blocks of the union stack. Since this (vfsmount, dentry) combination is
+unique across all namespaces, we should be able to maintain the union stack
+sanely even if the filesystem is union mounted privately in different
+namespaces or if it appears under different mounts due to various types
+of bind mounts.
+
+4. Union stack: building and traversal
+--------------------------------------
+Union stack needs to be built from two places: during an explicit union
+mount (or mount propagation) and during the lookup of a directory that
+appears in more than one layer of the union.
+
+The link between two layers of union stack is maintained using the
+union_mount structure:
+
+struct union_mount {
+	/* vfsmount and dentry of this layer */
+	struct vfsmount *src_mnt;
+	struct dentry *src_dentry;
+
+	/* vfsmount and dentry of the next lower layer */
+	struct vfsmount *dst_mnt;
+	struct dentry *dst_dentry;
+
+	/*
+	 * This list_head hashes this union_mount based on this layer's
+	 * vfsmount and dentry. This is used to get to the next layer of
+	 * the stack (dst_mnt, dst_dentry) given the (src_mnt, src_dentry)
+	 * and is used for stack traversal.
+	 */
+	struct list_head hash;
+
+	/*
+	 * All union_mounts under a vfsmount(src_mnt) are linked together
+	 * at mnt->mnt_union using this list_head. This is needed to destroy
+	 * all the union_mounts when the mnt goes away.
+	 */
+	struct list_head list;
+};
+
+These union mount structures are stored in a hash table(union_mount_hashtable)
+which uses the same hash as used for mount_hashtable since both of them use
+(vfsmount, dentry) pairs to calculate the hash.
+
+During a new mount (or mount propagation), a new union_mount structure is
+created. A reference to the mountpoint's vfsmount and dentry is taken and
+stored in the union_mount (as dst_mnt, dst_dentry). And this union_mount
+is inserted in the union_mount_hashtable based on the hash generated by
+the mount root's vfsmount and dentry.
+
+Similar method is employed to create a union stack during first time lookup
+of a common named directory within a union mount point. But here, the top
+level directory's vfsmount and dentry are hashed to get to the lower level
+directory's vfsmount and dentry.
+
+The insertion, deletion and lookup of union_mounts in the
+union_mount_hashtable is protected by vfsmount_lock. While traversing the
+stack, we hold this spinlock only briefly during lookup time and release
+it as soon as we get the next union stack member. The top level of the
+stack holds a reference to the next level (via union_mount structure) and
+so on. Therefore, as long as we hold a reference to a union stack member,
+its lower layers can't go away. And since we don't do the complete
+traversal under any lock, it is possible for the stack to change over the
+level from where we started traversing. For eg. when traversing the stack
+downwards, a new filesystem can be mounted on top of it. When this happens,
+the user who had a reference to the old top wouldn't have visibility to
+the new top and would continue as if the new top didn't exist for him.
+I believe this is fine as long as members of the stack don't go away from
+under us(CHECK). And to be sure of this, we need to hold a reference to the
+level from where we start the traversal and should continue to hold it
+till we are done with the traversal.
+
+5. Union stack: destroying
+--------------------------
+In addition to storing the union_mounts in a hash table for quick lookups,
+they are also stored as a list, headed at vsmount->mnt_union. So, all
+union_mounts that occur under a vfsmount (starting from the mountpoint
+followed by the subdir unions) are stored within the vfsmount. During
+umount (specifically, during the last mntput()), this list is traversed
+to destroy all union stacks under this vfsmount.
+
+Hence, all union stacks under a vfsmount continue to exist until the
+vfsmount is unmounted. It may be noted that the union_mount structure
+holds a reference to the current dentry also. Becasue of this, for
+subdir unions, both the top and bottom level dentries become pinned
+till the upper layer filesystem is unmounted. Is this behaviour
+acceptable ? Would this lead to a lot of pinned dentries over a period
+of time ? (CHECK) If we don't do this, the top layer dentry might go
+out of cache, during which time we have no means to release the
+corresponding union_mount and the union_mount becomes stale. Would it
+be necessary and worthwhile to add intelligence to prune_dcache() to
+prune unused union_mounts thereby releasing the dentries ?
+
+As noted above, we hold the refernce to current dentry from union_mount
+but don't get a reference to the corresponding vfsmount. We depend on
+the user of the union stack to hold the reference to the topmost vfsmount
+until he is done with the stack traversal. Not holding a reference to the
+top vfsmount from within union_mount allows us to free all the union_mounts
+from last mntput of the top vfsmount. Is this approach acceptable ?
+
+NOTE: union_mount structures are part of two lists: the hash list for
+quick lookups and a linked list to aid the freeing of these structures
+during unmount.
+
+6. Directory lising
+-------------------
+The merged view of directories is obtained by reading the directory
+entries of all the layers (starting from topmost) and merging the result.
+To aid this, the directory entries are stored in a cache as and when they
+are read and the newly read entries are compared against this for duplicate
+elimination before being passed to user space. This cache is a simple linked
+list at the moment.
+
+If getdents() returns to user space before completely reading the directory,
+the state at which it left reading the union mounted directory is stored
+in the rdstate structure.
+
+struct rdstate {
+	/* vfsmount and dentry of the directory from which we were reading */
+	struct vfsmount *mnt;
+	struct dentry *dentry;
+
+	/* the file offset of directory file at which we stopped reading */
+	loff_t off;
+
+	/* cache of directory entries */
+	struct list_head dirent_cache;
+};
+
+A pointer to this structure is stored in the file structure for the topmost
+directory and initialized during the first readdir()/getdents() of this
+directory. This readdir state information is destroyed during the last
+fput() of the file. For every subsequent readdir()/getdents(), the file
+offset of the directory determined by rdstate->{mnt, dentry} is set to
+the rdstate->off, before continuing with readdir()/getdents() on that
+directory.
+
+Since readdir()/getdents() is issued on the topmost directory for union
+mounted directories, it is possible for the file->f_pos of the topmost
+directory to reach its end while we are still reading the contents of
+the stacked bottom directories. So, file->f_pos is not clearly defined
+for union mounted directories. And because of this lseek doesn't work
+as it works normally for other directories. If this approach of directory
+listing is acceptable, we need to fix the meaning of file offset for
+union mounted directories and accordingly get lseek to behave sanely.
+
+7. What works and what doesn't ?
+-------------------------------
+These work:
+	- mount/umount :)
+	- A simple case of union mount propagation to slave and shared
+	  mounts.
+	- /bin/ls on a union mounted directory.
+
+These don't:
+	- lseek on union mounted directory.
+
+Not tried:
+	- move mounts
+	- pivot_root
+	- Other cases of bind mounts, specifically recursive binds.
+	- etc :(
+
+Not yet implemented:
+	- copyup and whiteout features. So, as of now we can only
+	do a union mount and directory listing on it. Other operations,
+	specifically write to a lower layer file are not supported.
+
+8. Usage
+--------
+To union mount a device /dev/sda1 on a mount point /mnt, we do this:
+
+# mount --union /dev/sda1 /mnt
+
+This results in the union mount getting created at /mnt which will contain
+the merged view of /mnt's original content and the contents of /dev/sda1.
+
+The mount(8) command from util-linux has to be modified to support
+--union option.
+
+9. References
+-------------
+1. http://lkml.org/lkml/2007/4/17/150 - First post of original union mount.
+2. http://lkml.org/lkml/2007/5/14/69 - Next (v1) post of original union mount.
+
+- June 2007
