Return-Path: <linux-kernel-owner+w=401wt.eu-S939690AbXG3QTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939690AbXG3QTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938520AbXG3QOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:58742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934520AbXG3QOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:10 -0400
Message-Id: <20070730161324.428827014@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:37 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 14/26] union-mount: Documentation
Content-Disposition: inline; filename=um/union-mount-documentation.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple documentation about union mounting in general and this
implementation in specific.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 Documentation/filesystems/union-mounts.txt |  172 +++++++++++++++++++++++++++++
 1 file changed, 172 insertions(+)

--- /dev/null
+++ b/Documentation/filesystems/union-mounts.txt
@@ -0,0 +1,172 @@
+VFS based Union Mounts
+----------------------
+
+ 1. What are "Union Mounts"
+ 2. The Union Stack
+ 3. The White-out Filetype
+ 4. Renaming Unions
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
+operating systems like Sun's Translucent Filesystem, Plan9 or BSD.
+
+Here are the key features of this implementation:
+- completely VFS based
+- does not change the namespace stacking
+- directory listings have duplicate entries removed
+- writable unions: only the topmost file system layer may be writable
+- writable unions: new white-out filetype handled inside the kernel
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
+file system hierachy there is a need for a new structure. The file system
+objects, which are part of a unified view are ordered in a so-called "union
+stack". Only directoties can be part of a unified view.
+
+The link between two layers of the union stack is maintained using the
+union_mount structure (#include <linux/union.h>):
+
+struct union_mount {
+       atomic_t u_count;               /* reference count */
+       struct mutex u_mutex;
+       struct list_head u_unions;      /* list head for d_unions */
+       struct hlist_node u_hash;       /* list head for seaching */
+       struct hlist_node u_rhash;      /* list head for reverse seaching */
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
+3. Writable Unions: The White-out Filetype and Copy-On-Open
+===========================================================
+
+The white-out filetype isn't new. It has been there for quite some time now
+but Linux's VFS hasn't used it yet. With the availability of union mount code
+inside the VFS the white-out filetype is getting important to support writable
+union mounts. For read-only union mounts support neither white-outs nor
+copy-on-open is necessary.
+
+The white-out filetype has the same function as negative dentries: they
+describe a filename which isn't there. The creation of white-outs needs
+lowlevel filesystem support. At the time of writing this, there is white-out
+support for tmpfs, ext2 and ext3 available. The VFS is extended to make the
+white-out handling transparent to all its users. The white-outs are not
+visible by the user-space.
+
+-------------------------------------------------------------------------------
+
+4. Renaming Unions
+==================
+
+Rename on union mounts has been handled in a lazy way: it returned -EXDEV.
+This works well for dirctories but not for regular files. Even a kernel build
+doesn't handle rename errors appropriate. Therefore when renaming regular
+files from a lower layer of the union stack it is copied to the topmost
+layer. If the file already resides on the topmost layer, the traditional
+rename method is used.
+
+-------------------------------------------------------------------------------
+
+5. Directory Reading
+====================
+
+As mentioned, union mounts represent a single view of multiple directories as
+if they are merged together. This is achieved by reading the contents of every
+directory on the union stack and by merging the result. When the directory
+listing is read via readdir() or getdents() system call, the union stack is
+traversed from the topmost layer of the union stack to the lowermost.
+
+Likewise with regular files, directories are seekable and the position of the
+following read is marked by the file position filp->f_pos. When reading from
+multiple directories, it is possible that the file position exceeds the inode
+size of the first directory. Therefore the file position is rearranged to
+select the correct directory in the union stack. This is done by substractiong
+the inode size if the file position exceeds it and selecting the next member
+of the union stack next.
+
+This worked well with filesystems like ext2 that used flat file directories.
+The directory entry offsets are arranged linear and are always smaller than
+the inode size of the directory. Modern filesystems have implemented
+directories differently and just return special cookies as directory entry
+offsets which are unrelated to the position in the directory or the inode
+size.
+
+-------------------------------------------------------------------------------
+
+6. Known Problems
+=================
+
+- currently it doesn't support seeking/readdir when d_off > i_size is possible
+- readdir() is a file operation
+- copyup() for other filetypes that reg and dir (e.g. for chown() on devices)
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

-- 

