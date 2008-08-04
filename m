Return-Path: <linux-kernel-owner+w=401wt.eu-S1763841AbYHDVBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763841AbYHDVBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbYHDVAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:00:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758227AbYHDVAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:00:48 -0400
From: Eric Paris <eparis@redhat.com>
To: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: [RFC 1/5] [TALPA] Hooking points and kernel interception
Date: Mon,  4 Aug 2008 17:00:36 -0400
Message-Id: <1217883640-29121-1-git-send-email-eparis@redhat.com>
X-Mailer: git-send-email 1.5.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core of the functionality is to insert hooking points at appropriate
places and pass events for vetting.

Vetting works via three chain of filters. First an interception is
passed to a evaluation chain whose purpose is to decide whether the
access should be allowed or denied. Depending on the outcome either
allow or deny filter chain is run next.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 Documentation/talpa/design.txt          |  266 +++++++++++++++++++++++++++++++
 fs/open.c                               |   10 ++
 include/linux/talpa.h                   |   88 ++++++++++
 security/Kconfig                        |    1 +
 security/Makefile                       |    2 +
 security/talpa/Kconfig                  |    9 +
 security/talpa/Makefile                 |    7 +
 security/talpa/talpa.h                  |   64 ++++++++
 security/talpa/talpa_allow_calls.h      |    5 +
 security/talpa/talpa_deny_calls.h       |    5 +
 security/talpa/talpa_evaluation_calls.h |    6 +
 security/talpa/talpa_interceptor.c      |  116 ++++++++++++++
 12 files changed, 579 insertions(+), 0 deletions(-)

diff --git a/Documentation/talpa/design.txt b/Documentation/talpa/design.txt
new file mode 100644
index 0000000..5df07bf
--- /dev/null
+++ b/Documentation/talpa/design.txt
@@ -0,0 +1,266 @@
+﻿
+Background
+++++++++++
+There is a consensus in the security industry that protecting against malicious
+files (viruses, root kits, spyware, ad-ware, ...) by the way of so-called
+on-access scanning is usable and reasonable approach. Currently the Linux kernel
+does not offer a completely suitable interface to implement such security solutions.
+Present solutions involve overwriting function pointers in the LSM, in filesystem
+operations, in the sycall table, and other fragile hacks.  The purpose of this
+project is to create a fast, clean interface for userspace programs to look for
+malware when files are accessed.  This malware may be ultimately intended for
+this or some other Linux machine or may be malware intended to attack a host
+running a different operating system and is merely in transit across the Linux
+server.  Since there are almost an infinite number of ways in which information
+can enter and exit a server it is not seen as reasonable to move these checks to
+all the applications at the boundary (MTA, NFS, CIFS, SSH, rsync, et al.) to look
+for such malware on at the border.
+
+Speed is of particular interest for those who have it compiled into the kernel
+but have no userspace client.  There must be no measurable performance hit to
+just compiling this into the kernel.
+
+Security vendors, Linux distributors and other interested parties have come together
+on the malware-list mailing list to discuss this problem and see if they can work
+together to propose a solution. During these talks couple of requirement sets were
+posted with the aim of fleshing out common needs as a prerequisite of creating an
+interface prototype.
+
+Collated requirements
++++++++++++++++++++++
+  1. Intercept file opens (exec also) for vetting (block until decision is made) and allow some userspace black magic to make decisions.
+  2. Intercept file closes for scanning post access
+  3. Cache scan results so the same file is not scanned on each and every access
+  4. Ability to flush the cache and cause all files to be re-scanned when accessed
+  5. Define which filesystems are cacheable and which are not
+  6. Scan files directly not relying on path.  Avoid races and problems with namespaces, chroot, containers, etc.
+  7. Report other relevant file, process and user information associated with each interception
+  8. Report file pathnames to userspace (relative to process root, current working directory)
+  9. Mark a processes as exempt from on access scanning
+ 10. Exclude sub-trees from scanning based on filesystem (exclude procfs, sysfs, devfs)
+ 11. Exclude sub-trees from scanning based on filesystem path
+ 12. Include only certain sub-trees from scanning based on filesystem path
+ 13. Register more than one userspace client in which case behavior is restrictive
+
+
+Discussion of requirements
+++++++++++++++++++++++++++
+The initial patch set with NOT meet all of these 'requirements.'  Some will be
+implemented at a later time and some will never be implemented.  Specifics are
+detailed below.  There is no intention to (abu)use the LSM for this purpose.
+The LSM provides complete internal kernel mandatory access controls.  It is not
+intended for userspace scanning and detection.  Users should not be forced to
+choose between an in kernel mandatory access control policy and this additional
+userspace file access.  LSM stacking is NOT as option as has been demonstrated
+repeatedly.
+
+1., 2. Basic interception
+-------------------------
+Core requirement is to intercept access to files and prevent it if malicious
+content is detected.  This is done on open, not on read.  It may be possible
+to do read time checking with minimal performance impact although not currently
+implemented.  This means that the following race is possible
+
+   Process1              Process2
+    - open file RD
+                          - open file WR
+                          - write virus data (1)
+    - read virus data
+
+*note that any open after (1) will get properly vetted.  At this time the
+likelyhood of this being a problem vs the performance impact of scanning on
+read and the increased complexity of the code means this is left out.  This
+should not be a problem for local executables as writes to files opened to be run
+typically return ETXTBSY.
+
+To accomplish that two hooks were inserted, on file open in __dentry_open and in
+filp_close on file close. In both cases the file object in question is passed as a
+parameter for further processing. In case of an open the operation can actually be
+blocked, while closes are always immediately successful and will not cause additional
+blocking.  Results of a close are returned to the kernel asynchronously and may be
+used to cache answers to speed up a future open.
+
+Interception processing is done by way of three chains of filters.  Access requests
+are first send to the "evaluation" chain.  Depending on the results of the evaluation
+the decision is then send to either the allow chain or the deny chain.
+
+There are three basic responses each filter can make - to be indifferent or either
+allow or deny access to the file.  The filter may also allow or deny access to a
+file while not caching that result.
+
+One of the most important filters in the evaluation chain implements an interface
+through which an userspace process can register and receive vetting requests.
+Userspace process opens a misc character device to express its interest and then
+receives binary structures from that device describing basic interception information.
+After file contents have been scanned a vetting response is sent by writing a different
+binary structure back to the device and the intercepted process continues its execution.
+These are not done over network sockets and no endian conversions are done.  The client
+and the kernel must have the same endian configuration.
+
+3., 4. Caching
+---------------
+To avoid scanning unchanged files on every access which would be very bad for
+performance some sort of caching is needed.  Although possible to implement a
+cache in userspace having two context switches required for every open is clearly
+not fast.  We implemented it per inode object as a serial number compared with
+a single global monotonically increasing system serial number.
+
+The cache filter is inserted into the evaluation chain before the userspace
+client filter and if the inode serial number is equal to the system one it allows
+access to the file.
+
+If the file is seen for the first time, has been modified, or for any other reason
+has a serial number less than the system one the cache filter will be 'indifferent'
+and processing of the given vetting request will continue down the evaluation chain.
+When some filter (only Userspace in the first patch set) allows access to a file its
+inode serial number is set to the system global which effectively makes it cached.
+Also, when a write access is gained for a file the serial number will automatically
+be reset as well as when any process actually writes to that file.
+
+Cache flushing is possible by simply increasing the global system serial number.
+
+Both positive and negative vetting results are cached by the means of positive and
+negative serial numbers.
+
+This method of caching has minimal impact on system resources while providing maximal
+effectiveness and simple implementation.
+
+5. Fine-grained caching
+-----------------------
+It is necessary to select which filesystems can be safely cached and which must
+not be. For example it is not a good idea to allow caching of network filesystems
+because their content can be changed invisibly. Disk based and some virtual
+filesystems can be cached safely on the other hand.
+
+This first proposal only partially implements this requirement. Only block device
+backed filesystems will be cached while there is no way to enable caching for
+things like tmpfs. Improving this is left out of the initial prototype.  Although
+there may be additional work to implement caching for certain FS types there is
+no plan to greatly increase the scope of the cache granularity.  There is no
+plan to cache based on the operation or things of that nature.  Caching of
+this nature can be implemented in userspace if the vendor so chooses.  We
+include only a minimal safe cache for performance reasons.
+
+6. Direct access to file content
+--------------------------------
+When an userspace daemon receives a vetting request, it also receives a new RO
+file descriptor which provides direct access to the inode in question. This is
+to enable access to the file regardless of it accessibility from the scanner
+environment (consider process namespaces, chroot's, NFS).  The userspace client
+is responsible for closing this file when it is finished scanning.
+
+7. Other reporting
+------------------
+Along with the fd being installed in the scanning process the process gets a
+binary structure of data including: 
+
++       uint32_t version;
++       uint32_t type;
++       int32_t fd;
++       uint32_t operation;
++       uint32_t flags;
++       uint32_t mode;
++       uint32_t uid;
++       uint32_t gid;
++       uint32_t tgid;
++       uint32_t pid;
+
+8. Path name reporting
+----------------------
+When a malicious content is detected in a file it is important to be able to
+report its location so the user or system administrator can take appropriate actions.
+
+This is implemented in a amazingly simple way which will hopefully avoid the
+controversy of some other solutions. Path name is only needed for reporting purposes
+and it is obtained by reading the symlink of the given file descriptor in /proc.  Its as
+simple as userspace calling:
+
+snprintf(link, sizeof(link), "/proc/self/fd/%d", details.fd);
+ret = readlink(link, buf, sizeof(buf)-1);
+
+9. Process exclusion
+--------------------
+Sometimes it is necessary to exclude certain processes from being intercepted. For
+example it might be a userspace root kit scanner which would not be able to find
+root kits if access to them was blocked by the on-access scanner.
+
+To facilitate that we have created a special file a process can open and register
+itself as excluded. A flag is then put into its kernel structure (task_struct)
+which makes it excluded from scanning.
+
+This implementation is very simple and provides greatest performance. In the proposed
+implementation access to the exclusion device is controlled though permissions on
+the device node which are not sufficient.  An LSM call will need to be made for this
+type or access in a later patch.
+
+10. Filesystem exclusions
+-------------------------
+One pretty important optimization is not to scan things like /proc, /sys or similar.
+Basically all filesystems where user can not store arbitrary, potentially malicious,
+content could and should be excluded from scanning.
+
+This interface prototype implements it as a run-time configurable list of filesystem
+names. Again it is a filter in the evaluation chain which can allow access before
+the request gets routed to the userspace client.
+
+This will not be implemented in the first patch set but should be soon to follow.
+It is done by simply comparing strings between those supplied and the s_type->name
+field in an associated superblock.
+
+11. Path exclusions
+-------------------
+The need for exclusions can be demonstrated with an example of a MySQL server. It's
+data files are frequently modified which means they would need to be constantly
+rescanned which is very bad for performance. Also, it is most often not even
+possible to reasonably scan them. Therefore the best solution is not to scan
+its database store which can simply be implemented by excluding the store subdirectory.
+
+It is a relatively simple implementation which allows run-time configuration of
+a list of sub directories or files to exclude. Exclusion paths are relative to
+each process root. So for example if we want to exclude /var/lib/mysql/ and we
+have a mysql running in a chroot where from the outside that directory actually
+lives in /chroot/mysql/var/lib/mysql, /var/lib/mysql should actually be added
+to the exclusion list.
+
+This is also not included in the initial patch set but will be coming shortly after.
+
+12. Path Inclusions
+-------------------
+
+Path-based inclusions are not implemented due to concerns with hard-linked files
+both inside and outside the included directories.  It is too easy to fall into
+a sense of false security with path inclusions since the pathname is almost
+meaningless.  If a vendor feels this is particularly important for them they
+will have to implement it in userspace by use of a judicious list of exclusion
+filters.
+
+
+13. Multiple client registration with restrictive behavior
+-----------------------------------------------------------
+This is currently not implemented. Multiple clients can register but they will be
+used for (crappy) load balancing only.  Not all will be called for a single interception.
+Only one of the registered clients will process a single interception. Desire here
+is to enable multiple clients servicing interceptions in parallel for performance
+and reliability reasons.
+
+Requirement for serial and restrictive behavior would be slightly more complicated
+to implement because we would want to keep the current behavior as well. Or in other
+words we would need to have groups of multiple clients, where each interception
+would go through one client from each group with the desired restrictive behavior.
+
+This may be left for a future implementation for simplicity reasons but I find it
+unlikely.  If a vendor needs to send requests to multiple scanners they should be
+able to implement that serialization in userspace.  I see no need for an in kernel
+event dispatcher.  Note that the audit system had this same need and has done iti
+as a userspace event dispatcher.  We have also seen in the LSM that restrictive
+access stacking is not as easy as it sounds and has been abandoned.
+
+Closing remarks
+---------------
+Although some may argue some of the filters are not necessary or may better be
+implemented in userspace, we think it is better to have them in kernel primarily
+for performance reasons. Secondly, it is all simple code not introducing much
+baggage or risk into the kernel itself.  The most complex filter and the only
+one with locking ramifications is the userspace client vetting which calls into
+dentry_open() on both open and close operations.  There is no locking around
+caching or process exclusions or other work.
diff --git a/fs/open.c b/fs/open.c
index 07da935..1133005 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/audit.h>
 #include <linux/falloc.h>
+#include <linux/talpa.h>
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -842,6 +843,13 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 		}
 	}
 
+	if (!IS_ERR(f)) {
+		error = talpa_vet_file_open(f, flags);
+		if (error) {
+			fput(f);
+			f = ERR_PTR(error);
+		}
+	}
 	return f;
 
 cleanup_all:
@@ -1082,6 +1090,8 @@ int filp_close(struct file *filp, fl_owner_t id)
 		return 0;
 	}
 
+	talpa_vet_file_close(filp);
+
 	if (filp->f_op && filp->f_op->flush)
 		retval = filp->f_op->flush(filp, id);
 
diff --git a/include/linux/talpa.h b/include/linux/talpa.h
new file mode 100644
index 0000000..4ae05ba
--- /dev/null
+++ b/include/linux/talpa.h
@@ -0,0 +1,88 @@
+/*
+ *  Copyright 2008 Sophos Plc
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef __LINUX_TALPA_H__
+#define __LINUX_TALPA_H__
+
+#ifndef __KERNEL__
+#include <stdint.h>
+#else
+#include <linux/types.h>
+#endif
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/**
+ * enum talpa_operation - type of intercepted operation
+ * @TALPA_OPEN:open of a filesystem object
+ * @TALPA_CLOSE:closing of a filesystem object
+ */
+enum talpa_operation {
+	TALPA_OPEN = 0,
+	TALPA_CLOSE = 1,
+};
+
+#ifdef __cplusplus
+}
+#endif
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+
+#ifdef CONFIG_TALPA
+
+/* Internal interface. */
+
+/**
+ * talpa_vet_file_open - called to vet an open operation
+ * @file:file which is being opened
+ * @flags:flags passed when opening
+ *
+ * This is to be called from the appropriate place in the VFS layer
+ * to catch all filesystem operations which provide access to
+ * file objects.
+ */
+extern int talpa_vet_file_open(struct file *file, int flags);
+
+/**
+ * talpa_vet_file_close - called to vet files on close
+ * @file:file which is being closed
+ *
+ * This is to be called from the appropriate place in the VFS layer
+ * to inspect file content just before they will be closed.
+ */
+extern void talpa_vet_file_close(struct file *file);
+
+#else /* !CONFIG_TALPA*/
+
+static inline int talpa_vet_file_open(struct file *file, int flags)
+{
+	return 0;
+}
+
+static inline void talpa_vet_file_close(struct file *file)
+{
+}
+
+#endif /* !CONFIG_TALPA */
+
+#endif /* __KERNEL__ */
+#endif /* __LINUX_TALPA_H__ */
diff --git a/security/Kconfig b/security/Kconfig
index 5592939..cb32796 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -117,6 +117,7 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
+source security/talpa/Kconfig
 
 endmenu
 
diff --git a/security/Makefile b/security/Makefile
index f654260..2d5d3a8 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -5,6 +5,7 @@
 obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
+subdir-$(CONFIG_TALPA)			+= talpa
 
 # always enable default capabilities
 obj-y		+= commoncap.o
@@ -16,3 +17,4 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+obj-$(CONFIG_TALPA)			+= talpa/built-in.o
diff --git a/security/talpa/Kconfig b/security/talpa/Kconfig
new file mode 100644
index 0000000..0b8449e
--- /dev/null
+++ b/security/talpa/Kconfig
@@ -0,0 +1,9 @@
+config TALPA
+	bool "File content vetting interface"
+	default n
+	help
+	  Talpa is a high-performance filesystem access interception
+          package providing facilities for user-mode daemons/programs
+          to 'vet' filesystem operations before they are executed.
+
+	  If you are unsure how to answer this question, answer Y.
diff --git a/security/talpa/Makefile b/security/talpa/Makefile
new file mode 100644
index 0000000..676fc90
--- /dev/null
+++ b/security/talpa/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for Talpa
+#
+
+obj-$(CONFIG_TALPA) := talpa.o
+
+talpa-y := talpa_interceptor.o
diff --git a/security/talpa/talpa.h b/security/talpa/talpa.h
new file mode 100644
index 0000000..2c4fb6f
--- /dev/null
+++ b/security/talpa/talpa.h
@@ -0,0 +1,64 @@
+/*
+ *  Copyright 2008 Sophos Plc
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef __TALPA_H__
+#define __TALPA_H__
+
+#include <linux/fs.h>
+#include <linux/talpa.h>
+
+/* Talpa filter interface definitions. */
+
+/**
+ * enum talpa_action - filter response
+ * @TALPA_NEXT: do not care or do not know what to do
+ * @TALPA_ALLOW: operation should be allowed
+ * @TALPA_DENY: operation should be denied
+ * @TALPA_TIMEOUT: decision could not be made in a reasonable time
+ * @TALPA_ERROR: decision could not be made due to an error
+ *
+ * Each filters returns it's response from one of these values signalling
+ * it's opinion on the vetting operation in progress.
+ */
+enum talpa_action {
+	TALPA_NEXT = 0,
+	TALPA_ALLOW = 1,
+	TALPA_DENY = 2,
+	TALPA_TIMEOUT = 3,
+	TALPA_ERROR = 4,
+};
+
+/**
+ * struct talpa_file_vetting - object passed to filters for vetting
+ * @operation: type of operation being vetted
+ * @file: file pointer for the vetted object
+ * @flags: as passed to open(2)
+ * @authoritative: set to non-zero when decision has been made based on file content
+ * @code: error code if applicable
+ *
+ * This object is created by the interceptor and passed to all filters
+ * to do the vetting.
+ */
+struct talpa_file_vetting {
+	enum talpa_operation operation;
+	struct file *file;
+	int flags;
+	unsigned int authoritative;
+	int code;
+};
+
+#endif /* __TALPA_H__ */
diff --git a/security/talpa/talpa_allow_calls.h b/security/talpa/talpa_allow_calls.h
new file mode 100644
index 0000000..eb24482
--- /dev/null
+++ b/security/talpa/talpa_allow_calls.h
@@ -0,0 +1,5 @@
+#include "talpa.h"
+
+static inline void talpa_allow_calls(struct talpa_file_vetting *tfv)
+{
+}
diff --git a/security/talpa/talpa_deny_calls.h b/security/talpa/talpa_deny_calls.h
new file mode 100644
index 0000000..011d5c2
--- /dev/null
+++ b/security/talpa/talpa_deny_calls.h
@@ -0,0 +1,5 @@
+#include "talpa.h"
+
+static inline void talpa_deny_calls(struct talpa_file_vetting *tfv)
+{
+}
diff --git a/security/talpa/talpa_evaluation_calls.h b/security/talpa/talpa_evaluation_calls.h
new file mode 100644
index 0000000..367a149
--- /dev/null
+++ b/security/talpa/talpa_evaluation_calls.h
@@ -0,0 +1,6 @@
+#include "talpa.h"
+
+static inline int talpa_evaluation_calls(struct talpa_file_vetting *tfv)
+{
+	return TALPA_NEXT;
+}
diff --git a/security/talpa/talpa_interceptor.c b/security/talpa/talpa_interceptor.c
new file mode 100644
index 0000000..bde8a59
--- /dev/null
+++ b/security/talpa/talpa_interceptor.c
@@ -0,0 +1,116 @@
+/*
+ *  Copyright (C) 2008 Sophos Plc
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/errno.h>
+#include <linux/talpa.h>
+
+#include "talpa_evaluation_calls.h"
+#include "talpa_allow_calls.h"
+#include "talpa_deny_calls.h"
+
+#include "talpa.h"
+
+static struct kmem_cache *tfv_cache; /* Cache for the above structure */
+
+/* Forward declare implementation functions. */
+static int talpa_vet_file(struct file *file, int flags, enum talpa_operation op);
+
+/* Externally visible interface. */
+int talpa_vet_file_open(struct file *file, int flags)
+{
+	return talpa_vet_file(file, flags, TALPA_OPEN);
+}
+
+void talpa_vet_file_close(struct file *file)
+{
+	talpa_vet_file(file, file->f_flags, TALPA_CLOSE);
+}
+
+/* Main work function */
+static int talpa_vet_file(struct file *file, int flags, enum talpa_operation op)
+{
+	struct talpa_file_vetting *tfv = NULL;
+	enum talpa_action action = TALPA_NEXT;
+	int ret = -ENOSYS;
+
+	/* Try to allocate vetting details or block access.
+	   Cache will not be available before initcalls are run so
+	   allow all access until then. */
+	if (unlikely(!tfv_cache))
+		return 0;
+
+	tfv = kmem_cache_zalloc(tfv_cache, GFP_KERNEL);
+	if (!tfv)
+		return -ENOMEM;
+
+	tfv->operation = op;
+	tfv->file = file;
+	tfv->flags = flags;
+
+	action = talpa_evaluation_calls(tfv);
+
+	/* Response can never be authoritative if response was indifferent. */
+	if (action == TALPA_NEXT)
+		tfv->authoritative = 0;
+
+	/* call post-eval function depedning on result */
+	if (action == TALPA_ALLOW || action == TALPA_NEXT)
+		talpa_allow_calls(tfv);
+	else
+		talpa_deny_calls(tfv);
+
+	/* Choose return code depending on the outcome. */
+	switch (action) {
+	case TALPA_ALLOW:
+	case TALPA_NEXT:
+		ret = 0;
+		break;
+	case TALPA_DENY:
+		ret = -EACCES;
+		break;
+	case TALPA_TIMEOUT:
+		ret = -ETIME;
+		break;
+	case TALPA_ERROR:
+		if (tfv->code)
+			ret = tfv->code;
+		else
+			ret = -EACCES;
+		break;
+	}
+
+	/* Free stuff we have (or might have) allocated. */
+	kmem_cache_free(tfv_cache, tfv);
+
+	return ret;
+}
+
+static __init int talpa_interceptor_init(void)
+{
+	/* No point in running with a security subsystem which does
+	   not work so we will panic if cannot allocate the cache here. */
+	tfv_cache = kmem_cache_create("talpa_file_vetting", sizeof(struct talpa_file_vetting),
+					SLAB_PANIC, 0, NULL);
+	return 0;
+}
+__initcall(talpa_interceptor_init);
