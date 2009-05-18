Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbZERQSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbZERQSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZERQOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:14:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbZERQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:29 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 15/32] union-mount: Documentation
Date: Mon, 18 May 2009 18:09:11 +0200
Message-Id: <1242662968-11684-16-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple documentation about union mounting in general and this
implementation in specific.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 Documentation/filesystems/union-mounts.txt |  187 ++++++++++++++++++++++++++++
 1 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt

diff --git a/Documentation/filesystems/union-mounts.txt b/Documentation/filesystems/union-mounts.txt
new file mode 100644
index 0000000..15bb9d5
--- /dev/null
+++ b/Documentation/filesystems/union-mounts.txt
@@ -0,0 +1,187 @@
+VFS based Union Mounts
+----------------------
+
+ 1. What are "Union Mounts"
+ 2. The Union Stack
+ 3. Whiteouts, Opaque Directories, and Fallthrus
+ 4. Copy-up
+ 5. Directory Reading
+ 6. Known Problems
+ 7. References
+
+-------------------------------------------------------------------------------
+
+1. What are "Union Mounts"
+==========================
+
+Please note: this is NOT about UnionFS and it is NOT derived work!
+
+Traditionally the mount operation is opaque, which means that the content of
+the mount point, the directory where the file system is mounted on, is hidden
+by the content of the mounted file system's root directory until the file
+system is unmounted again. Unlike the traditional UNIX mount mechanism, that
+hides the contents of the mount point, a union mount presents a view as if
+both filesystems are merged together. Although only the topmost layer of the
+mount stack can be altered, it appears as if transparent file system mounts
+allow any file to be created, modified or deleted.
+
+Most people know the concepts and features of union mounts from other
+operating systems like Sun's Translucent Filesystem, Plan9 or BSD. For an
+in-depth review of union mounts and other unioning file systems, see:
+
+http://lwn.net/Articles/324291/
+http://lwn.net/Articles/325369/
+http://lwn.net/Articles/327738/
+
+Here are the key features of this implementation:
+- completely VFS based
+- does not change the namespace stacking
+- directory listings have duplicate entries removed in the kernel
+- writable unions: only the topmost file system layer may be writable
+- writable unions: new whiteout filetype handled inside the kernel
+
+-------------------------------------------------------------------------------
+
+2. The Union Stack
+==================
+
+The mounted file systems are organized in the "file system hierarchy" (tree of
+vfsmount structures), which keeps track about the stacking of file systems
+upon each other. The per-directory view on the file system hierarchy is called
+"mount stack" and reflects the order of file systems, which are mounted on a
+specific directory.
+
+Union mounts present a single unified view of the contents of two or more file
+systems as if they are merged together. Since the information which file
+system objects are part of a unified view is not directly available from the
+file system hierarchy there is a need for a new structure. The file system
+objects, which are part of a unified view are ordered in a so-called "union
+stack". Only directories can be part of a unified view.
+
+The link between two layers of the union stack is maintained using the
+union_mount structure (#include <linux/union.h>):
+
+struct union_mount {
+       atomic_t u_count;               /* reference count */
+       struct mutex u_mutex;
+       struct list_head u_unions;      /* list head for d_unions */
+       struct hlist_node u_hash;       /* list head for searching */
+       struct hlist_node u_rhash;      /* list head for reverse searching */
+
+       struct path u_this;             /* this is me */
+       struct path u_next;             /* this is what I overlay */
+};
+
+The union_mount structure holds a reference (dget,mntget) to the next lower
+layer of the union stack. Since a dentry can be part of multiple unions
+(e.g. with bind mounts) they are tied together via the d_unions field of the
+dentry structure.
+
+All union_mount structures are cached in two hash tables, one for lookups of
+the next lower layer of the union stack and one for reverse lookups of the
+next upper layer of the union stack. The reverse lookup is necessary to
+resolve CWD relative path lookups. For calculation of the hash value, the
+(dentry,vfsmount) pair is used. The u_this field is used for the hash table
+which is used in forward lookups and the u_next field for the reverse lookups.
+
+During every new mount (or mount propagation), a new union_mount structure is
+allocated. A reference to the mountpoint's vfsmount and dentry is taken and
+stored in the u_next field.  In almost the same manner an union_mount
+structure is created during the first time lookup of a directory within a
+union mount point. In this case the lookup proceeds to all lower layers of the
+union. Therefore the complete union stack is constructed during lookups.
+
+The union_mount structures of a dentry are destroyed when the dentry itself is
+destroyed. Therefore the dentry cache is indirectly driving the union_mount
+cache like this is done for inodes too. Please note that lower layer
+union_mount structures are kept in memory until the topmost dentry is
+destroyed.
+
+-------------------------------------------------------------------------------
+
+3. Whiteouts, Opaque Directories, and Fallthrus
+===========================================================
+
+The whiteout filetype isn't new. It has been there for quite some time now
+but Linux's VFS hasn't used it yet. With the availability of union mount code
+inside the VFS the whiteout filetype is getting important to support writable
+union mounts. For read-only union mounts, support for whiteouts or
+copy-on-open is not necessary.
+
+The whiteout filetype has the same function as negative dentries: they
+describe a filename which isn't there. The creation of whiteouts needs
+lowlevel filesystem support. At the time of writing this, there is whiteout
+support for tmpfs, ext2 and ext3 available. The VFS is extended to make the
+whiteout handling transparent to all its users. The whiteouts are not
+visible to user-space.
+
+What happens when we create a directory that was previously whited-out? We
+don't want the directory entries from underlying filesystems to suddenly appear
+in the newly created directory.  So we mark the directory opaque (the file
+system must support storage of the opaque flag).
+
+Fallthrus are directory entries that override the opaque flag on a directory
+for that specific directory entry name (the lookup "falls through" to the next
+layer of the union mount).  Fallthrus are mainly useful for implementing
+readdir().
+
+-------------------------------------------------------------------------------
+
+4. Copy-up
+===========
+
+Any write to an object on any layer other than the topmost triggers a copy-up
+of the object to the topmost file system. For regular files, the copy-up
+happens when it is opened in writable mode.
+
+Directories are copied up on open, regardless of intent to write, to simplify
+copy-up of any object located below it in the namespace. Otherwise we have to
+walk the entire pathname to create intermediate directories whenever we do a
+copy-up. This is the same approach as BSD union mounts and uses a negigible
+amount of disk space.  Note that the actual directory entries themselves are
+not copied-up from the lower levels until (a) the directory is written to, or
+(b) the first readdir() of the directory (more on that later).
+
+Rename across different levels of the union is implemented as a copy-up
+operation for regular files. Rename of directories simply returns EXDEV, the
+same as if we tried to rename across different mounts. Most applications have
+to handle this case anyway. Some applications do not expect EXDEV on
+rename operations within the same directory, but these applications will also
+be broken with bind mounts.
+
+-------------------------------------------------------------------------------
+
+5. Directory Reading
+====================
+
+readdir() is somewhat difficult to implement in a unioning file system. We must
+eliminate duplicates, apply whiteouts, and start up readdir() where we left
+off, given a single f_pos value. Our solution is to copy up all the directory
+entries to the topmost directory the first time readdir() is called on a
+directory. During this copy-up, we skip duplicates and entries covered by
+whiteouts, and then create fallthru entries for each remaining visible dentry.
+Then we mark the whole directory opaque. From then on, we just use the topmost
+file system's normal readdir() operation.
+
+-------------------------------------------------------------------------------
+
+6. Known Problems
+=================
+
+- copyup() for other filetypes that reg and dir (e.g. for chown() on devices)
+- symlinks are untested
+
+-------------------------------------------------------------------------------
+
+7. References
+=============
+
+[1] http://marc.info/?l=linux-fsdevel&m=96035682927821&w=2
+[2] http://marc.info/?l=linux-fsdevel&m=117681527820133&w=2
+[3] http://marc.info/?l=linux-fsdevel&m=117913503200362&w=2
+[4] http://marc.info/?l=linux-fsdevel&m=118231827024394&w=2
+
+Authors:
+Jan Blunck <jblunck@suse.de>
+Bharata B Rao <bharata@linux.vnet.ibm.com>
+Valerie Aurora <vaurora@redhat.com>
-- 
1.6.1.3

