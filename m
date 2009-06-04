Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZFDWk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZFDWk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 18:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZFDWkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 18:40:51 -0400
Received: from vena.lwn.net ([206.168.112.25]:57428 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbZFDWkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 18:40:51 -0400
Date: Thu, 4 Jun 2009 16:40:51 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH, RFC] Document the debugfs API
Message-ID: <20090604164051.2c6350cc@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As promised, here's the updated debugfs document.  If nobody screams,
I'll feed it up through my docs tree once the merge window opens.

jon

--
    Document the debugfs API
    
    This is an updated document covering the internal API for the debugfs
    filesystem.  Thanks to Shen Feng for suggesting that I put this text here
    and noting that the old LWN version was rather out of date.
    
    Reported-by: Shen Feng <shen@cn.fujitsu.com>
    Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/Documentation/filesystems/debugfs.txt b/Documentation/filesystems/debugfs.txt
new file mode 100644
index 0000000..692965b
--- /dev/null
+++ b/Documentation/filesystems/debugfs.txt
@@ -0,0 +1,162 @@
+Copyright 2009 Jonathan Corbet <corbet@lwn.net>
+
+Debugfs exists as a simple way for kernel developers to make information
+available to user space.  Unlike /proc, which is only meant for information
+about a process, or sysfs, which has strict one-value-per-file rules,
+debugfs has no rules at all.  Developers can put any information they want
+there.  The debugfs filesystem is also intended to not serve as a stable
+ABI to user space; in theory, there are no stability constraints placed on
+files exported there.  The real world is not always so simple, though [1];
+even debugfs interfaces are best designed with the idea that they will need
+to be maintained forever.
+
+Debugfs is typically mounted with a command like:
+
+    mount -t debugfs none /sys/kernel/debug
+
+(Or an equivalent /etc/fstab line).  There is occasional dissent on the
+mailing lists regarding the proper mount location for debugfs, and some
+documentation refers to mount points like /debug instead.  For now,
+user-space code which uses debugfs files will be more portable if it finds
+the debugfs mount point in /proc/mounts.
+
+Note that the debugfs API is exported GPL-only to modules.
+
+Code using debugfs should include <linux/debugfs.h>.  Then, the first order
+of business will be to create at least one directory to hold a set of
+debugfs files:
+
+    struct dentry *debugfs_create_dir(const char *name, struct dentry *parent);
+
+This call, if successful, will make a directory called name underneath the
+indicated parent directory.  If parent is NULL, the directory will be
+created in the debugfs root.  On success, the return value is a struct
+dentry pointer which can be used to create files in the directory (and to
+clean it up at the end).  A NULL return value indicates that something went
+wrong.  If ERR_PTR(-ENODEV) is returned, that is an indication that the
+kernel has been built without debugfs support and none of the functions
+described below will work.
+
+The most general way to create a file within a debugfs directory is with:
+
+    struct dentry *debugfs_create_file(const char *name, mode_t mode,
+				       struct dentry *parent, void *data,
+				       const struct file_operations *fops);
+
+Here, name is the name of the file to create, mode describes the access
+permissions the file should have, parent indicates the directory which
+should hold the file, data will be stored in the i_private field of the
+resulting inode structure, and fops is a set of file operations which
+implement the file's behavior.  At a minimum, the read() and/or write()
+operations should be provided; others can be included as needed.  Again,
+the return value will be a dentry pointer to the created file, NULL for
+error, or ERR_PTR(-ENODEV) if debugfs support is missing.
+
+In a number of cases, the creation of a set of file operations is not
+actually necessary; the debugfs code provides a number of helper functions
+for simple situations.  Files containing a single integer value can be
+created with any of:
+
+    struct dentry *debugfs_create_u8(const char *name, mode_t mode,
+				     struct dentry *parent, u8 *value);
+    struct dentry *debugfs_create_u16(const char *name, mode_t mode,
+				      struct dentry *parent, u16 *value);
+    struct dentry *debugfs_create_u32(const char *name, mode_t mode,
+				      struct dentry *parent, u32 *value);
+    struct dentry *debugfs_create_u64(const char *name, mode_t mode,
+				      struct dentry *parent, u64 *value);
+
+These files support both reading and writing the given value; if a specific
+file should not be written to, simply set the mode bits accordingly.  The
+values in these files are in decimal; if hexadecimal is more appropriate,
+the following functions can be used instead:
+
+    struct dentry *debugfs_create_x8(const char *name, mode_t mode,
+				     struct dentry *parent, u8 *value);
+    struct dentry *debugfs_create_x16(const char *name, mode_t mode,
+				      struct dentry *parent, u16 *value);
+    struct dentry *debugfs_create_x32(const char *name, mode_t mode,
+				      struct dentry *parent, u32 *value);
+
+Note that there is no debugfs_create_x64().
+
+These functions are useful as long as the developer knows the size of the
+value to be exported.  Some types can have different widths on different
+architectures, though, complicating the situation somewhat.  There is a
+function meant to help out in one special case:
+
+    struct dentry *debugfs_create_size_t(const char *name, mode_t mode,
+				         struct dentry *parent, 
+					 size_t *value);
+
+As might be expected, this function will create a debugfs file to represent
+a variable of type size_t.
+
+Boolean values can be placed in debugfs with:
+
+    struct dentry *debugfs_create_bool(const char *name, mode_t mode,
+				       struct dentry *parent, u32 *value);
+
+A read on the resulting file will yield either Y (for non-zero values) or
+N, followed by a newline.  If written to, it will accept either upper- or
+lower-case values, or 1 or 0.  Any other input will be silently ignored.
+
+Finally, a block of arbitrary binary data can be exported with:
+
+    struct debugfs_blob_wrapper {
+	void *data;
+	unsigned long size;
+    };
+
+    struct dentry *debugfs_create_blob(const char *name, mode_t mode,
+				       struct dentry *parent,
+				       struct debugfs_blob_wrapper *blob);
+
+A read of this file will return the data pointed to by the
+debugfs_blob_wrapper structure.  Some drivers use "blobs" as a simple way
+to return several lines of (static) formatted text output.  This function
+can be used to export binary information, but there does not appear to be
+any code which does so in the mainline.  Note that all files created with
+debugfs_create_blob() are read-only.
+
+There are a couple of other directory-oriented helper functions:
+
+    struct dentry *debugfs_rename(struct dentry *old_dir, 
+    				  struct dentry *old_dentry,
+		                  struct dentry *new_dir, 
+				  const char *new_name);
+
+    struct dentry *debugfs_create_symlink(const char *name, 
+                                          struct dentry *parent,
+				      	  const char *target);
+
+A call to debugfs_rename() will give a new name to an existing debugfs
+file, possibly in a different directory.  The new_name must not exist prior
+to the call; the return value is old_dentry with updated information.
+Symbolic links can be created with debugfs_create_symlink().
+
+There is one important thing that all debugfs users must take into account:
+there is no automatic cleanup of any directories created in debugfs.  If a
+module is unloaded without explicitly removing debugfs entries, the result
+will be a lot of stale pointers and no end of highly antisocial behavior.
+So all debugfs users - at least those which can be built as modules - must
+be prepared to remove all files and directories they create there.  A file
+can be removed with:
+
+    void debugfs_remove(struct dentry *dentry);
+
+The dentry value can be NULL, in which case nothing will be removed.
+
+Once upon a time, debugfs users were required to remember the dentry
+pointer for every debugfs file they created so that all files could be
+cleaned up.  We live in more civilized times now, though, and debugfs users
+can call:
+
+    void debugfs_remove_recursive(struct dentry *dentry);
+
+If this function is passed a pointer for the dentry corresponding to the
+top-level directory, the entire hierarchy below that directory will be
+removed.
+
+Notes:
+	[1] http://lwn.net/Articles/309298/
