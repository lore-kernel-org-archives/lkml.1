Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031810Ab0B1LGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 06:06:24 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47316 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031783Ab0B1LGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 06:06:22 -0500
From: Florian Westphal <fw@strlen.de>
To: linux-kernel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       x86@kernel.org
Subject: [RFC PATCH] x86, fs: add sys_compat_write for net/socket.c
Date: Sun, 28 Feb 2010 12:04:48 +0100
Message-Id: <1267355088-28421-1-git-send-email-fw@strlen.de>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some configurations, e.g. x86_64 with 32bit userspace, netlink/xfrm
misinterprets messages from userspace due to different structure
layout (u64 has different alignment requirements on x86 vs. x86_64).

As long as messages are sent via sendmsg(), this can be handled via
net/compat.c; it will set the CMSG_MSG_COMPAT flag in struct msghdr
for compat tasks.

Unfortunately, some programs (e.g. pluto ike daemon), send netlink data
to the kernel using write().

First patch tried to work around this by setting CMSG_MSG_COMPAT
depending on is_compat_task() in net/socket.c, but there were concerns,
e.g. the kernel doing socket writes in response to a user event (which
then might set MSG_COMPAT flag erronously).

Thus, introduce f_ops->compat_aio_write and compat_sys_write to treat
writes on sockets specially.

This only wires up compat_sys_write for x86/x86_64 -- at the moment this
is only required to parse xfrm netlink messages, which happen to only
need special treatment in case of COMPAT_FOR_U64_ALIGNMENT=y.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-fsdevel@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 arch/x86/ia32/ia32entry.S        |    2 +-
 arch/x86/include/asm/unistd_64.h |    1 +
 fs/compat.c                      |   60 +++++++++++++++++++++++++++++++++++++-
 fs/read_write.c                  |    9 ------
 include/linux/compat.h           |    3 ++
 include/linux/fs.h               |   13 ++++++++
 net/socket.c                     |   26 ++++++++++++++++-
 7 files changed, 102 insertions(+), 12 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 53147ad..fc6e74d 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -508,7 +508,7 @@ ia32_sys_call_table:
 	.quad sys_exit
 	.quad stub32_fork
 	.quad sys_read
-	.quad sys_write
+	.quad compat_sys_write
 	.quad compat_sys_open		/* 5 */
 	.quad sys_close
 	.quad sys32_waitpid
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 4843f7b..96ddb48 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -687,6 +687,7 @@ __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_TIME
+#define __ARCH_WANT_COMPAT_SYS_WRITE
 #endif	/* __NO_STUBS */
 
 #ifdef __KERNEL__
diff --git a/fs/compat.c b/fs/compat.c
index 00d90c2..e3ab72d 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1070,6 +1070,62 @@ out:
 }
 #endif /* ! __ARCH_OMIT_COMPAT_SYS_GETDENTS64 */
 
+#ifdef __ARCH_WANT_COMPAT_SYS_WRITE
+static ssize_t compat_vfs_write(struct file *file, const char __user *buf,
+			size_t count, loff_t *pos)
+{
+	ssize_t ret;
+
+	if (!file->f_op)
+		return -EINVAL;
+
+	if (likely(!file->f_op->compat_aio_write) || file->f_op->write)
+		return vfs_write(file, buf, count, pos);
+
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (unlikely(!access_ok(VERIFY_READ, buf, count)))
+		return -EFAULT;
+
+	ret = rw_verify_area(WRITE, file, pos, count);
+	if (ret >= 0) {
+		struct iovec iov;
+		iov_fn_t fnv = file->f_op->compat_aio_write;
+
+		count = ret;
+		iov.iov_base = (void __user *)buf;
+		iov.iov_len = count;
+
+		ret = do_sync_readv_writev(file, &iov, 1, count, pos, fnv);
+		if (ret > 0) {
+			fsnotify_modify(file->f_path.dentry);
+			add_wchar(current, ret);
+		}
+		inc_syscw(current);
+	}
+	return ret;
+}
+
+asmlinkage ssize_t
+compat_sys_write(unsigned long fd, const char __user *buf, size_t count)
+{
+	struct file *file;
+	ssize_t ret = -EBADF;
+	int fput_needed;
+
+	file = fget_light(fd, &fput_needed);
+	if (file) {
+		loff_t pos = file_pos_read(file);
+		ret = compat_vfs_write(file, buf, count, &pos);
+		file_pos_write(file, pos);
+		fput_light(file, fput_needed);
+	}
+
+	return ret;
+}
+#endif /* __ARCH_WANT_COMPAT_SYS_WRITE */
+
 static ssize_t compat_do_readv_writev(int type, struct file *file,
 			       const struct compat_iovec __user *uvector,
 			       unsigned long nr_segs, loff_t *pos)
@@ -1155,7 +1211,9 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 		fnv = file->f_op->aio_read;
 	} else {
 		fn = (io_fn_t)file->f_op->write;
-		fnv = file->f_op->aio_write;
+		fnv = file->f_op->compat_aio_write;
+		if (likely(!fnv))
+			fnv = file->f_op->aio_write;
 	}
 
 	if (fnv)
diff --git a/fs/read_write.c b/fs/read_write.c
index b7f4a1f..543567f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -359,15 +359,6 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 
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
 
 SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 {
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ef68119..2a9338c 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -231,6 +231,9 @@ asmlinkage long compat_sys_keyctl(u32 option,
 			      u32 arg2, u32 arg3, u32 arg4, u32 arg5);
 asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u32);
 
+asmlinkage ssize_t compat_sys_write(unsigned long fd, const char __user *uptr,
+				size_t len);
+
 asmlinkage ssize_t compat_sys_readv(unsigned long fd,
 		const struct compat_iovec __user *vec, unsigned long vlen);
 asmlinkage ssize_t compat_sys_writev(unsigned long fd,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ebb1cd5..e2061d7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -952,6 +952,16 @@ extern spinlock_t files_lock;
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
+static inline loff_t file_pos_read(struct file *file)
+{
+	return file->f_pos;
+}
+
+static inline void file_pos_write(struct file *file, loff_t pos)
+{
+	file->f_pos = pos;
+}
+
 #ifdef CONFIG_DEBUG_WRITECOUNT
 static inline void file_take_write(struct file *f)
 {
@@ -1484,6 +1494,9 @@ struct file_operations {
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	ssize_t (*aio_read) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
+#ifdef CONFIG_COMPAT
+	ssize_t (*compat_aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
+#endif
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
diff --git a/net/socket.c b/net/socket.c
index 769c386..cf18728 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -117,6 +117,8 @@ static long sock_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long compat_sock_ioctl(struct file *file,
 			      unsigned int cmd, unsigned long arg);
+static ssize_t compat_sock_aio_write(struct kiocb *iocb, const struct iovec *iov,
+				     unsigned long nr_segs, loff_t pos);
 #endif
 static int sock_fasync(int fd, struct file *filp, int on);
 static ssize_t sock_sendpage(struct file *file, struct page *page,
@@ -138,6 +140,7 @@ static const struct file_operations socket_file_ops = {
 	.poll =		sock_poll,
 	.unlocked_ioctl = sock_ioctl,
 #ifdef CONFIG_COMPAT
+	.compat_aio_write = compat_sock_aio_write,
 	.compat_ioctl = compat_sock_ioctl,
 #endif
 	.mmap =		sock_mmap,
@@ -836,7 +839,9 @@ static ssize_t do_sock_write(struct msghdr *msg, struct kiocb *iocb,
 	msg->msg_controllen = 0;
 	msg->msg_iov = (struct iovec *)iov;
 	msg->msg_iovlen = nr_segs;
-	msg->msg_flags = (file->f_flags & O_NONBLOCK) ? MSG_DONTWAIT : 0;
+
+	if (file->f_flags & O_NONBLOCK)
+		msg->msg_flags |= MSG_DONTWAIT;
 	if (sock->type == SOCK_SEQPACKET)
 		msg->msg_flags |= MSG_EOR;
 
@@ -855,8 +860,27 @@ static ssize_t sock_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (!x)
 		return -ENOMEM;
 
+	x->async_msg.msg_flags = 0;
+	return do_sock_write(&x->async_msg, iocb, iocb->ki_filp, iov, nr_segs);
+}
+
+#ifdef CONFIG_COMPAT
+static ssize_t compat_sock_aio_write(struct kiocb *iocb, const struct iovec *iov,
+			  unsigned long nr_segs, loff_t pos)
+{
+	struct sock_iocb siocb, *x;
+
+	if (pos != 0)
+		return -ESPIPE;
+
+	x = alloc_sock_iocb(iocb, &siocb);
+	if (!x)
+		return -ENOMEM;
+
+	x->async_msg.msg_flags = MSG_CMSG_COMPAT;
 	return do_sock_write(&x->async_msg, iocb, iocb->ki_filp, iov, nr_segs);
 }
+#endif
 
 /*
  * Atomic setting of ioctl hooks to avoid race
-- 
1.6.4.4

