Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZB0UgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZB0UgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbZB0Uei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:34:38 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43720 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbZB0Uef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:34:35 -0500
Subject: [RFC][PATCH 2/8] breakout fdinfo sprintf() into its own function
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 27 Feb 2009 12:34:26 -0800
References: <20090227203425.F3B51176@kernel>
In-Reply-To: <20090227203425.F3B51176@kernel>
Message-Id: <20090227203426.9F73083F@kernel>
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

diff -puN fs/proc/base.c~breakout-fdinfo fs/proc/base.c
--- linux-2.6.git/fs/proc/base.c~breakout-fdinfo	2009-02-27 12:07:37.000000000 -0800
+++ linux-2.6.git-dave/fs/proc/base.c	2009-02-27 12:07:37.000000000 -0800
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
+	p += snprintf(info+p, max-p, "pos:\t%lli\n", (long long) file->f_pos);
+	p += snprintf(info+p, max-p, "flags:\t0%o\n", file->f_flags);
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
