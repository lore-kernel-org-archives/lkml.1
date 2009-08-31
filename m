Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZHaPpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZHaPpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZHaPpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:45:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZHaPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:45:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Date: Mon, 31 Aug 2009 17:44:52 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-6-generic; KDE/4.3.0; x86_64; ; )
Cc: Stefani Seibold <stefani@seibold.net>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1251563892.13287.11.camel@wall-e> <1251659144.20987.18.camel@wall-e> <20090831063334.GB7821@x200.localdomain>
In-Reply-To: <20090831063334.GB7821@x200.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908311744.52972.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DEdcQeuYEiAoPg/FqoZgyawmy0qQfwRD3Lj5
 L/kOymfCflptDg7wcsbYEKary/PkylrrJUnZqsjQlKEA+aEekq
 BQ+AQ8lxMWT6OWhfObQqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 August 2009, Alexey Dobriyan wrote:
> Out-of-tree argument means almost nothing.
> 
> ...
>
> You'd better start converting to struct file_operations::write now.

Maybe a purely mechanical conversion to file_operations would be a nice first
step, just so we can remove read_proc and write_proc? Taking scsi_proc.c
as an example, this should be really straightforward and lets us get
rid of the write_proc and read_proc callbacks from proc_dir_entry without
having to rewrite all the remaining drivers that use it.

Obviously, someone who understands the specific driver code better should
then clean up the code by converting to seq_file operations or something
else that is appropriate there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/scsi_proc.c |   27 ++++++++++++++++++++++-----
 fs/proc/generic.c        |   16 ++++++----------
 include/linux/proc_fs.h  |   11 +++++++++++
 3 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 77fbddb..f2a48a1 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -136,6 +136,26 @@ void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
 	mutex_unlock(&global_host_template_mutex);
 }
 
+static ssize_t scsi_proc_read(struct file *file, char __user *buf,
+			size_t count, loff_t *off)
+{
+	return __proc_file_read(&proc_scsi_read, buf, count, off,
+			PDE(file->f_path.dentry->d_inode)->data);
+}
+
+static ssize_t scsi_proc_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	return proc_scsi_write_proc(file, buf, count,
+			PDE(file->f_path.dentry->d_inode)->data);
+}
+
+static const struct file_operations scsi_proc_fops = {
+	.owner = THIS_MODULE,
+	.read = scsi_proc_read,
+	.write = scsi_proc_write,
+	.llseek = generic_file_llseek,
+};
 
 /**
  * scsi_proc_host_add - Add entry for this host to appropriate /proc dir
@@ -151,16 +170,14 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 		return;
 
 	sprintf(name,"%d", shost->host_no);
-	p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
-			sht->proc_dir, proc_scsi_read, shost);
+	p = proc_create_data(name, S_IFREG | S_IRUGO | S_IWUSR,
+			sht->proc_dir, &scsi_proc_fops, shost);
 	if (!p) {
 		printk(KERN_ERR "%s: Failed to register host %d in"
 		       "%s\n", __func__, shost->host_no,
 		       sht->proc_name);
 		return;
-	} 
-
-	p->write_proc = proc_scsi_write_proc;
+	}
 }
 
 /**
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index fa678ab..ccf3949 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -36,17 +36,14 @@ static int proc_match(int len, const char *name, struct proc_dir_entry *de)
 /* buffer size is one page but our output routines use some slack for overruns */
 #define PROC_BLOCK_SIZE	(PAGE_SIZE - 1024)
 
-static ssize_t
-__proc_file_read(struct file *file, char __user *buf, size_t nbytes,
-	       loff_t *ppos)
+ssize_t __proc_file_read(read_proc_t read_proc, char __user *buf,
+			size_t nbytes, loff_t *ppos, void *data)
 {
-	struct inode * inode = file->f_path.dentry->d_inode;
 	char 	*page;
 	ssize_t	retval=0;
 	int	eof=0;
 	ssize_t	n, count;
 	char	*start;
-	struct proc_dir_entry * dp;
 	unsigned long long pos;
 
 	/*
@@ -60,7 +57,6 @@ __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 	if (nbytes > MAX_NON_LFS - pos)
 		nbytes = MAX_NON_LFS - pos;
 
-	dp = PDE(inode);
 	if (!(page = (char*) __get_free_page(GFP_TEMPORARY)))
 		return -ENOMEM;
 
@@ -68,7 +64,7 @@ __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 		count = min_t(size_t, PROC_BLOCK_SIZE, nbytes);
 
 		start = NULL;
-		if (dp->read_proc) {
+		if (read_proc) {
 			/*
 			 * How to be a proc read function
 			 * ------------------------------
@@ -116,8 +112,8 @@ __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 			 *    requested offset advanced by the number of bytes
 			 *    absorbed.
 			 */
-			n = dp->read_proc(page, &start, *ppos,
-					  count, &eof, dp->data);
+			n = read_proc(page, &start, *ppos,
+					  count, &eof, data);
 		} else
 			break;
 
@@ -197,7 +193,7 @@ proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 	pde->pde_users++;
 	spin_unlock(&pde->pde_unload_lock);
 
-	rv = __proc_file_read(file, buf, nbytes, ppos);
+	rv = __proc_file_read(pde->read_proc, buf, nbytes, ppos, pde->data);
 
 	pde_users_dec(pde);
 	return rv;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index e6e77d3..949a382 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -103,6 +103,10 @@ struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
 				struct proc_dir_entry *parent,
 				const struct file_operations *proc_fops,
 				void *data);
+/* do not use in new code */
+ssize_t __proc_file_read(read_proc_t read_proc, char __user *buf,
+                        size_t nbytes, loff_t *ppos, void *data);
+
 extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
 
 struct pid_namespace;
@@ -195,6 +199,13 @@ static inline struct proc_dir_entry *proc_create_data(const char *name,
 }
 #define remove_proc_entry(name, parent) do {} while (0)
 
+static inline ssize_t __proc_file_read(read_proc_t read_proc,
+			char __user *buf, size_t nbytes, loff_t *ppos,
+			void *data)
+{
+	return 0;
+}
+
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) {return NULL;}
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
