Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYIRKCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYIRKCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 06:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYIRKB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 06:01:59 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:54284 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYIRKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 06:01:58 -0400
Message-Id: <6.0.0.20.2.20080918185818.04dd5b30@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Thu, 18 Sep 2008 18:59:10 +0900
To: Nick Piggin <nickpiggin@yahoo.com.au>,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       akpm@linux-foundation.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <200809171124.14518.nickpiggin@yahoo.com.au>
References: <84867.22024.qm@web26206.mail.ukl.yahoo.com>
 <200809171124.14518.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At 10:24 08/09/17, Nick Piggin wrote:
>> > >  i was thinking about introducing a file_pos_update() not implemented
>> > > using file_pos_read()/file_pos_write() and taking the seq_lock or
>> > > disabling preemption only one time
>> >
>> > AFAIK, the only way to do an atomic 64 bit store on 32-bit x86 is
>> > "cmpxchg8b" (with lock prefix on SMP). That would be far slower
>> > I'm sure.
>>
>> Maybe it is clear with an example:
>
>I understand and agree.

I modified my patch by introducing file_pos_update().

Comments?

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.27-rc6.org/fs/block_dev.c linux-2.6.27-rc6.fpos/fs/block_dev.c
--- linux-2.6.27-rc6.org/fs/block_dev.c	2008-09-10 10:30:08.000000000 +0900
+++ linux-2.6.27-rc6.fpos/fs/block_dev.c	2008-09-18 18:24:42.000000000 +0900
@@ -225,13 +225,11 @@ static loff_t block_llseek(struct file *
 			offset += size;
 			break;
 		case 1:
-			offset += file->f_pos;
+			offset += file_pos_read(file);
 	}
 	retval = -EINVAL;
 	if (offset >= 0 && offset <= size) {
-		if (offset != file->f_pos) {
-			file->f_pos = offset;
-		}
+		file_pos_update(file, offset);
 		retval = offset;
 	}
 	mutex_unlock(&bd_inode->i_mutex);
diff -Nrup linux-2.6.27-rc6.org/fs/file_table.c linux-2.6.27-rc6.fpos/fs/file_table.c
--- linux-2.6.27-rc6.org/fs/file_table.c	2008-09-10 10:30:08.000000000 +0900
+++ linux-2.6.27-rc6.fpos/fs/file_table.c	2008-09-16 14:18:29.000000000 +0900
@@ -121,6 +121,7 @@ struct file *get_empty_filp(void)
 	tsk = current;
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_long_set(&f->f_count, 1);
+	f_pos_ordered_init(f);
 	rwlock_init(&f->f_owner.lock);
 	f->f_uid = tsk->fsuid;
 	f->f_gid = tsk->fsgid;
diff -Nrup linux-2.6.27-rc6.org/fs/locks.c linux-2.6.27-rc6.fpos/fs/locks.c
--- linux-2.6.27-rc6.org/fs/locks.c	2008-09-10 10:30:08.000000000 +0900
+++ linux-2.6.27-rc6.fpos/fs/locks.c	2008-09-16 18:35:14.000000000 +0900
@@ -317,7 +317,7 @@ static int flock_to_posix_lock(struct fi
 		start = 0;
 		break;
 	case SEEK_CUR:
-		start = filp->f_pos;
+		start = file_pos_read(filp);
 		break;
 	case SEEK_END:
 		start = i_size_read(filp->f_path.dentry->d_inode);
@@ -367,7 +367,7 @@ static int flock64_to_posix_lock(struct 
 		start = 0;
 		break;
 	case SEEK_CUR:
-		start = filp->f_pos;
+		start = file_pos_read(filp);
 		break;
 	case SEEK_END:
 		start = i_size_read(filp->f_path.dentry->d_inode);
diff -Nrup linux-2.6.27-rc6.org/fs/read_write.c linux-2.6.27-rc6.fpos/fs/read_write.c
--- linux-2.6.27-rc6.org/fs/read_write.c	2008-09-10 10:30:08.000000000 +0900
+++ linux-2.6.27-rc6.fpos/fs/read_write.c	2008-09-18 18:27:53.000000000 +0900
@@ -42,15 +42,13 @@ generic_file_llseek_unlocked(struct file
 			offset += inode->i_size;
 			break;
 		case SEEK_CUR:
-			offset += file->f_pos;
+			offset += file_pos_read(file);
 	}
 	retval = -EINVAL;
 	if (offset>=0 && offset<=inode->i_sb->s_maxbytes) {
 		/* Special lock needed here? */
-		if (offset != file->f_pos) {
-			file->f_pos = offset;
+		if (file_pos_update(file, offset))
 			file->f_version = 0;
-		}
 		retval = offset;
 	}
 	return retval;
@@ -83,14 +81,12 @@ loff_t default_llseek(struct file *file,
 			offset += i_size_read(file->f_path.dentry->d_inode);
 			break;
 		case SEEK_CUR:
-			offset += file->f_pos;
+			offset += file_pos_read(file);
 	}
 	retval = -EINVAL;
 	if (offset >= 0) {
-		if (offset != file->f_pos) {
-			file->f_pos = offset;
+		if (file_pos_update(file, offset))
 			file->f_version = 0;
-		}
 		retval = offset;
 	}
 	unlock_kernel();
@@ -324,16 +320,6 @@ ssize_t vfs_write(struct file *file, con
 
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
 asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 {
 	struct file *file;
diff -Nrup linux-2.6.27-rc6.org/include/linux/fs.h linux-2.6.27-rc6.fpos/include/linux/fs.h
--- linux-2.6.27-rc6.org/include/linux/fs.h	2008-09-10 10:30:10.000000000 +0900
+++ linux-2.6.27-rc6.fpos/include/linux/fs.h	2008-09-18 18:29:09.000000000 +0900
@@ -805,6 +805,16 @@ static inline int ra_has_index(struct fi
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
@@ -822,6 +832,9 @@ struct file {
 	unsigned int 		f_flags;
 	mode_t			f_mode;
 	loff_t			f_pos;
+#ifdef __NEED_F_POS_ORDERED
+	seqlock_t		f_pos_seqlock;
+#endif
 	struct fown_struct	f_owner;
 	unsigned int		f_uid, f_gid;
 	struct file_ra_state	f_ra;
@@ -850,6 +863,73 @@ extern spinlock_t files_lock;
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
+/*
+ * file_pos_read/write is atomic by using sequence lock on 32bit arch.
+ */
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
+static inline int file_pos_update(struct file *file, loff_t offset)
+{
+	int ret = 0;
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	write_seqlock(&file->f_pos_seqlock);
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		ret = 1;
+	}
+	write_sequnlock(&file->f_pos_seqlock);
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
+	preempt_disable();
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		ret = 1;
+	}
+	preempt_enable();
+#else
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		ret = 1;
+	}
+#endif
+	return ret;
+}
+
 #ifdef CONFIG_DEBUG_WRITECOUNT
 static inline void file_take_write(struct file *f)
 {

