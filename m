Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZCEQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZCEQjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZCEQjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:07 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56589 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbZCEQjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:05 -0500
Subject: [RFC][PATCH 02/11] breakout fdinfo sprintf() into its own function
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:38:59 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163859.584741AF@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'll be adding to this in a moment and it is in a bad place
to do that cleanly now.

Also, increase the buffer size.  Most /proc files can
output up to a page, so use the same here.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/base.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN fs/proc/base.c~breakout-fdinfo-sprintf fs/proc/base.c
--- linux-2.6.git/fs/proc/base.c~breakout-fdinfo-sprintf	2009-03-05 08:37:00.000000000 -0800
+++ linux-2.6.git-dave/fs/proc/base.c	2009-03-05 08:37:00.000000000 -0800
@@ -1632,7 +1632,18 @@ out:
 	return ~0U;
 }
 
-#define PROC_FDINFO_MAX 64
+#define PROC_FDINFO_MAX PAGE_SIZE
+
+static void proc_fd_write_info(struct file *file, char *info)
+{
+	int max = PROC_FDINFO_MAX;
+	int p = 0;
+	if (!info)
+		return;
+
+	p += scnprintf(info+p, max-p, "pos:\t%lli\n", (long long) file->f_pos);
+	p += scnprintf(info+p, max-p, "flags:\t0%o\n", file->f_flags);
+}
 
 static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 {
@@ -1657,12 +1668,7 @@ static int proc_fd_info(struct inode *in
 				*path = file->f_path;
 				path_get(&file->f_path);
 			}
-			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long) file->f_pos,
-					 file->f_flags);
+			proc_fd_write_info(file, info);
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
@@ -1870,10 +1876,11 @@ static int proc_readfd(struct file *filp
 static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
 				      size_t len, loff_t *ppos)
 {
-	char tmp[PROC_FDINFO_MAX];
+	char *tmp = kmalloc(PROC_FDINFO_MAX, GFP_KERNEL);
 	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, tmp);
 	if (!err)
 		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
+	kfree(tmp);
 	return err;
 }
 
_
