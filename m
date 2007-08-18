Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbXHRQJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbXHRQJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 12:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbXHRQJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 12:09:12 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:39215 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755840AbXHRQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 12:09:10 -0400
Date: Sat, 18 Aug 2007 12:09:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rddunlap@osdl.org>,
       Martin Bligh <mbligh@google.com>, Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: [PATCH] Fix f_version type: should be u64 instead of unsigned long
Message-ID: <20070818160906.GA22844@Krystal>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca> <20070815033945.GA13134@mail.ustc.edu.cn> <20070815041845.GJ21089@ftp.linux.org.uk> <20070815063741.GB5175@mail.ustc.edu.cn> <20070815065301.GK21089@ftp.linux.org.uk> <20070815084625.GA18892@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070815084625.GA18892@mail.ustc.edu.cn>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:04:14 up 19 days, 16:23,  3 users,  load average: 2.00, 1.44, 1.19
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix f_version type: should be u64 instead of long

There is a type inconsistency between struct inode i_version and struct file
f_version.

fs.h:

struct inode
  u64                     i_version;

and

struct file
  unsigned long           f_version;

Users do:

fs/ext3/dir.c:

if (filp->f_version != inode->i_version) {

So why isn't f_version a u64 ? It becomes a problem if versions gets
higher than 2^32 and we are on an architecture where longs are 32 bits.

This patch changes the f_version type to u64, and updates the users accordingly.

It applies to 2.6.23-rc2-mm2.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Martin Bligh <mbligh@google.com>
CC: Randy Dunlap <rddunlap@osdl.org>
CC: Al Viro <viro@ftp.linux.org.uk>
---
 fs/ext3/dir.c            |    2 +-
 fs/ext4/dir.c            |    2 +-
 fs/ocfs2/dir.c           |    2 +-
 fs/proc/base.c           |    4 ++--
 include/linux/fs.h       |    2 +-
 include/linux/seq_file.h |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/include/linux/fs.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/fs.h	2007-08-18 11:05:10.000000000 -0400
+++ linux-2.6-lttng/include/linux/fs.h	2007-08-18 11:05:56.000000000 -0400
@@ -799,7 +799,7 @@ struct file {
 	unsigned int		f_uid, f_gid;
 	struct file_ra_state	f_ra;
 
-	unsigned long		f_version;
+	u64			f_version;
 #ifdef CONFIG_SECURITY
 	void			*f_security;
 #endif
Index: linux-2.6-lttng/fs/ext3/dir.c
===================================================================
--- linux-2.6-lttng.orig/fs/ext3/dir.c	2007-08-18 11:08:25.000000000 -0400
+++ linux-2.6-lttng/fs/ext3/dir.c	2007-08-18 11:08:32.000000000 -0400
@@ -210,7 +210,7 @@ revalidate:
 				 * not the directory has been modified
 				 * during the copy operation.
 				 */
-				unsigned long version = filp->f_version;
+				u64 version = filp->f_version;
 
 				error = filldir(dirent, de->name,
 						de->name_len,
Index: linux-2.6-lttng/fs/ext4/dir.c
===================================================================
--- linux-2.6-lttng.orig/fs/ext4/dir.c	2007-08-18 11:08:47.000000000 -0400
+++ linux-2.6-lttng/fs/ext4/dir.c	2007-08-18 11:08:53.000000000 -0400
@@ -210,7 +210,7 @@ revalidate:
 				 * not the directory has been modified
 				 * during the copy operation.
 				 */
-				unsigned long version = filp->f_version;
+				u64 version = filp->f_version;
 
 				error = filldir(dirent, de->name,
 						de->name_len,
Index: linux-2.6-lttng/fs/ocfs2/dir.c
===================================================================
--- linux-2.6-lttng.orig/fs/ocfs2/dir.c	2007-08-18 11:09:23.000000000 -0400
+++ linux-2.6-lttng/fs/ocfs2/dir.c	2007-08-18 11:09:30.000000000 -0400
@@ -183,7 +183,7 @@ revalidate:
 				 * not the directory has been modified
 				 * during the copy operation.
 				 */
-				unsigned long version = filp->f_version;
+				u64 version = filp->f_version;
 				unsigned char d_type = DT_UNKNOWN;
 
 				if (de->file_type < OCFS2_FT_MAX)
Index: linux-2.6-lttng/fs/proc/base.c
===================================================================
--- linux-2.6-lttng.orig/fs/proc/base.c	2007-08-18 11:11:21.000000000 -0400
+++ linux-2.6-lttng/fs/proc/base.c	2007-08-18 11:11:39.000000000 -0400
@@ -2570,7 +2570,7 @@ static int proc_task_readdir(struct file
 	/* f_version caches the tgid value that the last readdir call couldn't
 	 * return. lseek aka telldir automagically resets f_version to 0.
 	 */
-	tid = filp->f_version;
+	tid = (int)filp->f_version;
 	filp->f_version = 0;
 	for (task = first_tid(leader, tid, pos - 2);
 	     task;
@@ -2579,7 +2579,7 @@ static int proc_task_readdir(struct file
 		if (proc_task_fill_cache(filp, dirent, filldir, task, tid) < 0) {
 			/* returning this tgid failed, save it as the first
 			 * pid for the next readir call */
-			filp->f_version = tid;
+			filp->f_version = (u64)tid;
 			put_task_struct(task);
 			break;
 		}
Index: linux-2.6-lttng/include/linux/seq_file.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/seq_file.h	2007-08-18 11:12:39.000000000 -0400
+++ linux-2.6-lttng/include/linux/seq_file.h	2007-08-18 11:12:50.000000000 -0400
@@ -18,7 +18,7 @@ struct seq_file {
 	size_t from;
 	size_t count;
 	loff_t index;
-	loff_t version;
+	u64 version;
 	struct mutex lock;
 	const struct seq_operations *op;
 	void *private;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
