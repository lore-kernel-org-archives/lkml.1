Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZFYEqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZFYEqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZFYEqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:46:25 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45770 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZFYEqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:46:23 -0400
Message-Id: <6.0.0.20.2.20090625115833.05a9ce10@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Thu, 25 Jun 2009 13:41:10 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [RESEND][PATCH] lseek: remove i_mutex
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Following patch removes i_mutex from generic_file_llseek.
I think the reason of protecting lseek with i_mutex is just
touching i_size (and f_pos) atomically.
So i_mutex is no longer needed here by introducing i_size_read 
to read i_size.
I also made f_pos access atomic here without i_mutex regarding
former i_mutex holders by introducing file_pos_read/file_pos_write
that use seqlock to preserve atomicity.

Following patch removes i_mutex from generic_file_llseek, and deletes 
generic_file_llseek_nolock totally.

Currently there is i_mutex contention not only around lseek, but also fsync or write.
So,  I think we can mitigate i_mutex contention between fsync, lseek and write by
removing i_mutex. For example, PostgreSQL (DBMS software) can obtain benefit 
from this patch. When checkpoint of DBMS started, lseek and write contend with i_mutex 
and throughput drops. But with this patch this performance drop can mitigate because of the
reduction of i_mutex contention. 

I did some test to measure i_mutex contention.
This test do:
	1. make an 128MB file.
	2. fork 100 processes. repeat 1000000 times lseeking and reading randomly on 
		each process to this file.
	3, gauge seconds between start and end of this test.

The result was:

	-2.6.31-rc1
	# time ./lseek_test
	182 sec

	real    3m2.751s
	user    0m13.273s
	sys     46m26.764s

	-2.6.31-rc1-patched
	# time ./lseek_test
	8 sec

	real    0m9.026s
	user    0m12.680s
	sys     2m0.643s 

Hardware environment:
CPU　2.4GHz(Quad Core) *4
Memory 64GB

Following is the test program "lseek_test.c".

#include <stdio.h>
#include <sched.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
#define NUM 100
#define LEN 4096
#define LOOP 32*1024

int num;

void catch_SIGCHLD(int signo)
{
	pid_t child_pid = 0;
	do {
		int child_ret;
		child_pid = waitpid(-1, &child_ret, WNOHANG);
		if (child_pid > 0)
			num++;
	} while (child_pid > 0);
}
main()
{
        int  i, pid;
	char buf[LEN];
	unsigned long offset, filesize;
	time_t t1, t2;
	struct sigaction act;
	memset(buf, 0, LEN);
	memset(&act, 0, sizeof(act));
	act.sa_handler = catch_SIGCHLD;
	act.sa_flags = SA_NOCLDSTOP|SA_RESTART;
	sigemptyset(&act.sa_mask);
	sigaction(SIGCHLD, &act, NULL);	

	filesize = LEN * LOOP;
	int fd = open("targetfile1",O_RDWR|O_CREAT);	

	/* create a 128MB file */
	for(i = 0; i < LOOP; i++)
		write(fd, buf, LEN);
	fsync(fd);
	close(fd);
	
	time(&t1);	
	for (i = 0; i < NUM; i++) {	
		pid = fork();
		if(pid == 0){
		/* child */
			int fd = open("targetfile1", O_RDWR);	
			int j;
			for (j = 0; j < 1000000; j++) {
				offset = (random() % filesize);
				lseek(fd, offset, SEEK_SET);
				read(fd, buf, 10);
			}
			close(fd);
			exit(0);
		}
	}
	while(num < NUM)
		sleep(1);
	time(&t2);	
	printf("%d sec\n",t2-t1);
}



Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.31-rc1.org/fs/cifs/cifsfs.c linux-2.6.31-rc1/fs/cifs/cifsfs.c
--- linux-2.6.31-rc1.org/fs/cifs/cifsfs.c	2009-06-25 10:22:44.000000000 +0900
+++ linux-2.6.31-rc1/fs/cifs/cifsfs.c	2009-06-25 10:30:27.000000000 +0900
@@ -641,7 +641,7 @@ static loff_t cifs_llseek(struct file *f
 		if (retval < 0)
 			return (loff_t)retval;
 	}
-	return generic_file_llseek_unlocked(file, offset, origin);
+	return generic_file_llseek(file, offset, origin);
 }
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
diff -Nrup linux-2.6.31-rc1.org/fs/file_table.c linux-2.6.31-rc1/fs/file_table.c
--- linux-2.6.31-rc1.org/fs/file_table.c	2009-06-25 10:22:44.000000000 +0900
+++ linux-2.6.31-rc1/fs/file_table.c	2009-06-25 10:31:12.000000000 +0900
@@ -126,6 +126,7 @@ struct file *get_empty_filp(void)
 
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_long_set(&f->f_count, 1);
+	f_pos_ordered_init(f);
 	rwlock_init(&f->f_owner.lock);
 	f->f_cred = get_cred(cred);
 	spin_lock_init(&f->f_lock);
diff -Nrup linux-2.6.31-rc1.org/fs/gfs2/file.c linux-2.6.31-rc1/fs/gfs2/file.c
--- linux-2.6.31-rc1.org/fs/gfs2/file.c	2009-06-25 10:22:44.000000000 +0900
+++ linux-2.6.31-rc1/fs/gfs2/file.c	2009-06-25 10:32:25.000000000 +0900
@@ -62,11 +62,11 @@ static loff_t gfs2_llseek(struct file *f
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
 					   &i_gh);
 		if (!error) {
-			error = generic_file_llseek_unlocked(file, offset, origin);
+			error = generic_file_llseek(file, offset, origin);
 			gfs2_glock_dq_uninit(&i_gh);
 		}
 	} else
-		error = generic_file_llseek_unlocked(file, offset, origin);
+		error = generic_file_llseek(file, offset, origin);
 
 	return error;
 }
diff -Nrup linux-2.6.31-rc1.org/fs/ncpfs/file.c linux-2.6.31-rc1/fs/ncpfs/file.c
--- linux-2.6.31-rc1.org/fs/ncpfs/file.c	2009-06-10 12:05:27.000000000 +0900
+++ linux-2.6.31-rc1/fs/ncpfs/file.c	2009-06-25 10:32:55.000000000 +0900
@@ -286,7 +286,7 @@ static loff_t ncp_remote_llseek(struct f
 {
 	loff_t ret;
 	lock_kernel();
-	ret = generic_file_llseek_unlocked(file, offset, origin);
+	ret = generic_file_llseek(file, offset, origin);
 	unlock_kernel();
 	return ret;
 }
diff -Nrup linux-2.6.31-rc1.org/fs/nfs/file.c linux-2.6.31-rc1/fs/nfs/file.c
--- linux-2.6.31-rc1.org/fs/nfs/file.c	2009-06-25 10:22:44.000000000 +0900
+++ linux-2.6.31-rc1/fs/nfs/file.c	2009-06-25 10:33:39.000000000 +0900
@@ -192,10 +192,10 @@ static loff_t nfs_file_llseek(struct fil
 			return (loff_t)retval;
 
 		spin_lock(&inode->i_lock);
-		loff = generic_file_llseek_unlocked(filp, offset, origin);
+		loff = generic_file_llseek(filp, offset, origin);
 		spin_unlock(&inode->i_lock);
 	} else
-		loff = generic_file_llseek_unlocked(filp, offset, origin);
+		loff = generic_file_llseek(filp, offset, origin);
 	return loff;
 }
 
diff -Nrup linux-2.6.31-rc1.org/fs/read_write.c linux-2.6.31-rc1/fs/read_write.c
--- linux-2.6.31-rc1.org/fs/read_write.c	2009-06-25 10:22:44.000000000 +0900
+++ linux-2.6.31-rc1/fs/read_write.c	2009-06-25 10:48:08.000000000 +0900
@@ -31,23 +31,61 @@ const struct file_operations generic_ro_
 
 EXPORT_SYMBOL(generic_ro_fops);
 
+static inline loff_t file_pos_read(struct file *file)
+{
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	loff_t pos;
+	unsigned int seq;
+
+	do {
+		seq = read_seqbegin(&file->f_pos_seqlock);
+		pos = file->f_pos;
+	} while (read_seqretry(&file->f_pos_seqlock, seq));
+	return pos;
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
+	loff_t pos;
+
+	preempt_disable();
+	pos = file->f_pos;
+	preempt_enable();
+	return pos;
+#else
+	return file->f_pos;
+#endif
+}
+
+static inline void file_pos_write(struct file *file, loff_t pos)
+{
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	write_seqlock(&file->f_pos_seqlock);
+	file->f_pos = pos;
+	write_sequnlock(&file->f_pos_seqlock);
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
+	preempt_disable();
+	file->f_pos = pos;
+	preempt_enable();
+#else
+	file->f_pos = pos;
+#endif
+}
+
 /**
- * generic_file_llseek_unlocked - lockless generic llseek implementation
+ * generic_file_llseek - generic llseek implementation for regular files
  * @file:	file structure to seek on
  * @offset:	file offset to seek to
  * @origin:	type of seek
  *
- * Updates the file offset to the value specified by @offset and @origin.
- * Locking must be provided by the caller.
+ * This is a generic implemenation of ->llseek useable for all normal local
+ * filesystems.  It just updates the file offset to the value specified by
+ * @offset and @origin.
  */
-loff_t
-generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
+loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct inode *inode = file->f_mapping->host;
 
 	switch (origin) {
 	case SEEK_END:
-		offset += inode->i_size;
+		offset += i_size_read(inode);
 		break;
 	case SEEK_CUR:
 		/*
@@ -57,8 +95,8 @@ generic_file_llseek_unlocked(struct file
 		 * write() or lseek() might have altered it
 		 */
 		if (offset == 0)
-			return file->f_pos;
-		offset += file->f_pos;
+			return file_pos_read(file);
+		offset += file_pos_read(file);
 		break;
 	}
 
@@ -66,35 +104,13 @@ generic_file_llseek_unlocked(struct file
 		return -EINVAL;
 
 	/* Special lock needed here? */
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
+	if (offset != file_pos_read(file)) {
+		file_pos_write(file, offset);
 		file->f_version = 0;
 	}
 
 	return offset;
 }
-EXPORT_SYMBOL(generic_file_llseek_unlocked);
-
-/**
- * generic_file_llseek - generic llseek implementation for regular files
- * @file:	file structure to seek on
- * @offset:	file offset to seek to
- * @origin:	type of seek
- *
- * This is a generic implemenation of ->llseek useable for all normal local
- * filesystems.  It just updates the file offset to the value specified by
- * @offset and @origin under i_mutex.
- */
-loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t rval;
-
-	mutex_lock(&file->f_dentry->d_inode->i_mutex);
-	rval = generic_file_llseek_unlocked(file, offset, origin);
-	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
-
-	return rval;
-}
 EXPORT_SYMBOL(generic_file_llseek);
 
 loff_t no_llseek(struct file *file, loff_t offset, int origin)
@@ -359,16 +375,6 @@ ssize_t vfs_write(struct file *file, con
 
 EXPORT_SYMBOL(vfs_write);
 
-static inline loff_t file_pos_read(struct file *file)
-{
-	return file->f_pos;
-}
-
-static inline void file_pos_write(struct file *file, loff_t pos)
-{
-	file->f_pos = pos;
-}
-
 SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 {
 	struct file *file;
diff -Nrup linux-2.6.31-rc1.org/fs/smbfs/file.c linux-2.6.31-rc1/fs/smbfs/file.c
--- linux-2.6.31-rc1.org/fs/smbfs/file.c	2009-06-10 12:05:27.000000000 +0900
+++ linux-2.6.31-rc1/fs/smbfs/file.c	2009-06-25 10:48:29.000000000 +0900
@@ -426,7 +426,7 @@ static loff_t smb_remote_llseek(struct f
 {
 	loff_t ret;
 	lock_kernel();
-	ret = generic_file_llseek_unlocked(file, offset, origin);
+	ret = generic_file_llseek(file, offset, origin);
 	unlock_kernel();
 	return ret;
 }
diff -Nrup linux-2.6.31-rc1.org/include/linux/fs.h linux-2.6.31-rc1/include/linux/fs.h
--- linux-2.6.31-rc1.org/include/linux/fs.h	2009-06-25 10:22:44.000000000 +0900
+++ linux-2.6.31-rc1/include/linux/fs.h	2009-06-25 10:51:08.000000000 +0900
@@ -902,6 +902,16 @@ static inline int ra_has_index(struct fi
 #define FILE_MNT_WRITE_TAKEN	1
 #define FILE_MNT_WRITE_RELEASED	2
 
+/*
+ * Use sequence lock to get consistent f_pos on 32-bit processors.
+ */
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+#define __NEED_F_POS_ORDERED
+#define f_pos_ordered_init(file) seqlock_init(&file->f_pos_seqlock)
+#else
+#define f_pos_ordered_init(file) do { } while (0)
+#endif
+
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
@@ -920,6 +930,9 @@ struct file {
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
 	loff_t			f_pos;
+#ifdef __NEED_F_POS_ORDERED
+	seqlock_t               f_pos_seqlock;
+#endif
 	struct fown_struct	f_owner;
 	const struct cred	*f_cred;
 	struct file_ra_state	f_ra;
@@ -2219,8 +2232,6 @@ extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
-extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
-			int origin);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 

