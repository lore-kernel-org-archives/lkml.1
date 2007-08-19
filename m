Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbXHSMuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbXHSMuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 08:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXHSMua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 08:50:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:24799 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbXHSMu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 08:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=tPjVWCzW9EpP2uiopvN4Y/RXzNi/YQOD4e4+GxVB0XX71/hpaYUF1BRjA/JoPqXs3FXWGTZD+T4P/f+7THxoBvLClefuTAjWtE7QUUJPtz9Pu4QDRVeK6lxHuo2Tr+7zY6hkC3rCDz0xgpiVKNPKktpG2khb7CLgrO+dCl+IDt8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] allow send/recv(MSG_DONTWAIT) on non-sockets (was Re: O_NONBLOCK is broken)
Date: Sun, 19 Aug 2007 13:50:21 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200708141241.44021.vda.linux@googlemail.com> <20070814133319.1a8a4871@the-village.bc.nu>
In-Reply-To: <20070814133319.1a8a4871@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NyDyGFq1go5BVpI"
Message-Id: <200708191350.21776.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_NyDyGFq1go5BVpI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 14 August 2007 13:33, Alan Cox wrote:
> > b) Make recv(fd, buf, size, flags) and send(fd, buf, size, flags);
> >    work with non-socket fds too, for flags==0 or flags==MSG_DONTWAIT.
> >    (it's ok to fail with "socket op on non-socket fd" for other values
> >    of flags)
>
> I think that makes a lot of sense, and to be honest other MSG_ flags make
> useful sense and have meaningful semantics that might be helpful
> elsewhere if ever coded that way.

Yes, that's my feeling too.

> If you want to do this the first job is going to be to sort out the way
> non-block is propogated to device driver read/write handlers. At the
> moment they all check filp->f_flags

...which happens in ~250 files. I'd rather not touch that much
of code, if possible.

Attached patch detects send/recv(fd, buf, size, MSG_DONTWAIT) on
non-sockets and turns them into non-blocking write/read.
Since filp->f_flags appear to be read and modified without any locking,
I cannot modify it without potentially affecting other processes
accessing the same file through shared struct file.

Therefore I simply make a temporary copy of struct file, set
O_NONBLOCK in it and pass it to vfs_read/write.
Is this heresy? ;) I see only one spinlock in struct file:

#ifdef CONFIG_EPOLL
        spinlock_t              f_ep_lock;
#endif /* #ifdef CONFIG_EPOLL */

Do I need to take it?

Also attached is ndelaytest.c which can be used to test that
send(MSG_DONTWAIT) indeed is failing with EAGAIN if write would block
and that other processes never see O_NONBLOCK set.

Comments?
--
vda

--Boundary-00=_NyDyGFq1go5BVpI
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="nonblock_linux-2.6.22-rc6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="nonblock_linux-2.6.22-rc6.patch"

--- linux-2.6.22-rc6.src/fs/read_write.c	Fri Jun 15 19:30:05 2007
+++ linux-2.6.22-rc6_ndelay/fs/read_write.c	Sun Aug 19 10:43:24 2007
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
+#include <linux/socket.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
@@ -351,6 +352,36 @@
 static inline void file_pos_write(struct file *file, loff_t pos)
 {
 	file->f_pos = pos;
+}
+
+/* Helper for send/recv on non-sockets */
+ssize_t rw_with_flags(struct file *file, int fput_needed, void __user *buf, size_t count, unsigned flags)
+{
+	int err;
+	loff_t pos;
+	struct file *file_copy;
+
+	file_copy = file;
+	if (flags & MSG_DONTWAIT) {
+		/* We make copy even if O_NONBLOCK is already set. */
+		/* We don't want it to change under our feet. */
+		file_copy = kmalloc(sizeof(*file_copy), GFP_KERNEL);
+		memcpy(file_copy, file, sizeof(*file_copy));
+		file_copy->f_flags |= O_NONBLOCK;
+	}
+
+	pos = file_pos_read(file);
+	if (flags & MSG_OOB) /* MSG_OOB is reused to mean 'write' */
+		err = vfs_write(file_copy, buf, count, &pos);
+	else
+		err = vfs_read(file_copy, buf, count, &pos);
+	file_pos_write(file, pos);
+
+	if (flags & MSG_DONTWAIT) {
+		kfree(file_copy);
+	}
+	fput_light(file, fput_needed);
+	return err;
 }
 
 asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
--- linux-2.6.22-rc6.src/include/linux/fs.h	Wed Jun 27 21:24:18 2007
+++ linux-2.6.22-rc6_ndelay/include/linux/fs.h	Sun Aug 19 10:32:20 2007
@@ -1154,6 +1154,9 @@
 extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 
+extern ssize_t rw_with_flags(struct file *, int, void __user *, size_t,
+		unsigned);
+
 /*
  * NOTE: write_inode, delete_inode, clear_inode, put_inode can be called
  * without the big kernel lock held in all filesystems.
--- linux-2.6.22-rc6.src/net/socket.c	Fri Jun 15 19:30:08 2007
+++ linux-2.6.22-rc6_ndelay/net/socket.c	Sun Aug 19 11:34:07 2007
@@ -1585,8 +1585,17 @@
 		goto out;
 
 	sock = sock_from_file(sock_file, &err);
-	if (!sock)
-		goto out_put;
+	if (!sock) {
+		if (addr)
+			goto out_put;
+		if (flags & ~MSG_DONTWAIT)
+			goto out_put;
+		/* it's not a socket, but we support a special case:
+		 * send(fd, buf, count, MSG_DONTWAIT)
+		 * (MSG_OOB is reused to mean 'write') */
+		return rw_with_flags(sock_file, fput_needed, buff, len, flags | MSG_OOB);
+	}
+
 	iov.iov_base = buff;
 	iov.iov_len = len;
 	msg.msg_name = NULL;
@@ -1646,8 +1655,15 @@
 		goto out;
 
 	sock = sock_from_file(sock_file, &err);
-	if (!sock)
-		goto out_put;
+	if (!sock) {
+		if (addr)
+			goto out_put;
+		if (flags & ~MSG_DONTWAIT)
+			goto out_put;
+		/* it's not a socket, but we support a special case:
+		 * recv(fd, ubuf, size, MSG_DONTWAIT) */
+		return rw_with_flags(sock_file, fput_needed, ubuf, size, flags);
+	}
 
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;

--Boundary-00=_NyDyGFq1go5BVpI
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="ndelaytest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ndelaytest.c"

#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <signal.h>

#define SECONDS 10

#define STR "."
//#define STR "123456789 123456789 123456789 123456789 "

/* To see send() resulting in EAGAIN:
 * strace -ff -o log ndelaytest | while sleep 11; do break; done
 * log.$PID:
 * send(1, "123456789 123456789 123456789 12"..., 40, MSG_DONTWAIT)
 *                = -1 EAGAIN (Resource temporarily unavailable)
 */

int main()
{
	pid_t pid;
	time_t t;
	int fl;

	puts("starting");
	t = time(0);

	pid = fork();
	if (pid == 0) {
		/* child */
		while ((time(0) - t) < SECONDS-1) {
#if 0 
			/* Uncomment this part and simply run the executable
			 * to see race detection code in action */
#define OP "write"
			fcntl(1, F_SETFL, fcntl(1, F_GETFL) | O_NONBLOCK);
			fl = write(1, STR, sizeof(STR) - 1);
			fcntl(1, F_SETFL, fcntl(1, F_GETFL) & ~O_NONBLOCK);
#else
			/* This part tests whether send(MSG_DONTWAIT)
			 * is racy or not */
#define OP "send"
			fl = send(1, STR, sizeof(STR) - 1, MSG_DONTWAIT);
#endif
			if (fl < 0) {
				perror(OP);
				kill(getppid(), SIGKILL);
				return 1;
			}
		}
		return 0;
	}

	while ((time(0) - t) < SECONDS) {
		fl = fcntl(1, F_GETFL);
		if (fl & O_NONBLOCK) {
			fprintf(stderr, "NONBLOCK:1\n");
			kill(pid, SIGKILL);
			fcntl(1, F_SETFL, fl & ~O_NONBLOCK);
			return 1;
		}
	}
	fprintf(stderr, "NONBLOCK:0\n");
	return 0;
}

--Boundary-00=_NyDyGFq1go5BVpI--
