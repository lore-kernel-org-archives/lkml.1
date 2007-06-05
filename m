Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbXFEP2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbXFEP2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933005AbXFEP22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:28:28 -0400
Received: from ozlabs.org ([203.10.76.45]:37504 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbXFEP20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:28:26 -0400
Subject: [PATCH 4/6] lguest don't signal like crazy, use LHREQ_BREAK command
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1181055483.14054.40.camel@localhost.localdomain>
References: <1181055308.14054.36.camel@localhost.localdomain>
	 <1181055396.14054.38.camel@localhost.localdomain>
	 <1181055483.14054.40.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 01:00:06 +1000
Message-Id: <1181055606.14054.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We currently use a "waker" process: a child of the launcher which
selects() on the incoming file descriptors.  It sends a SIGUSR1 to the
launcher whenever select() returns to kick the launcher out of the
kernel.

This has nasty side-effects: the waker needs to keep sending signals
to avoid the race, so we nice it to try to make sure the launcher runs
soon.  Also the launcher blocks SIGUSR1 when it's not running the
guest, so it doesn't have to deal with other interrupted reads...

It's better to explicitly tell the kernel to break out of the guest,
and this is what we do, with a new LHREQ_BREAK command.  This makes
the launcher return -EAGAIN from reading /dev/lguest, and blocks the
waker until the launcher calls LHREQ_BREAK, avoiding the race.

We also take precautions against simultaneous writes or reads on the
/dev/lguest fd.  As only root can open these file descriptors it's not
much of a problem, but we want to relax that restriction eventually.

The main improvement is in consistency, rather than raw benchmark
results:

Before:
Time for one context switch via pipe: 9265 (4534 - 9495)
Time for one Copy-on-Write fault: 67687 (14898 - 159125)
Time to exec client once: 1102812 (795843 - 1128250)
Time for one fork/exit/wait: 712000 (400625 - 723156)
Time for gettimeofday(): 16681 (16378 - 35835)
Time to send 4 MB from host: 141317343 (140165578 - 141469500)
Time for one int-0x80 syscall: 272 (272 - 575)
Time for one syscall via libc: 275 (274 - 904)
Time for two PTE updates: 16232 (6430 - 16316)
Time to read from disk (256 kB): 16786750 (16597500 - 31493250)
Time for one disk read: 192656 (189312 - 958687)
Time for inter-guest pingpong: 110453 (104492 - 316429)

After:
Time for one context switch via pipe: 4687 (4563 - 4857)
Time for one Copy-on-Write fault: 44523 (11628 - 77855)
Time to exec client once: 814765 (805796 - 829875)
Time for one fork/exit/wait: 405875 (400562 - 434750)
Time for gettimeofday(): 16644 (16203 - 16931)
Time to send 4 MB from host: 136530000 (121522250 - 151629000)
Time for one int-0x80 syscall: 273 (272 - 274)
Time for one syscall via libc: 279 (277 - 279)
Time for two PTE updates: 6439 (6395 - 6528)
Time to read from disk (256 kB): 16787000 (16641250 - 16861250)
Time for one disk read: 192187 (190515 - 193843)
Time for inter-guest pingpong: 111093 (109203 - 136554)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c   |   84 +++++++++++++++++----------------------
 drivers/lguest/core.c           |    7 ++-
 drivers/lguest/lg.h             |    5 ++
 drivers/lguest/lguest_user.c    |   59 +++++++++++++++++++++++----
 include/linux/lguest_launcher.h |    1 
 5 files changed, 101 insertions(+), 55 deletions(-)

===================================================================
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -16,7 +16,6 @@
 #include <fcntl.h>
 #include <stdbool.h>
 #include <errno.h>
-#include <signal.h>
 #include <ctype.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
@@ -47,6 +46,7 @@ static bool verbose;
 static bool verbose;
 #define verbose(args...) \
 	do { if (verbose) printf(args); } while(0)
+static int waker_fd;
 
 struct device_list
 {
@@ -341,15 +341,14 @@ static void set_fd(int fd, struct device
 		devices->max_infd = fd;
 }
 
-/* We send lguest_add signals while input is pending: avoids races. */
-static void wake_parent(int pipefd, struct device_list *devices)
-{
-	nice(19);
-
+/* When input arrives, we tell the kernel to kick lguest out with -EAGAIN. */
+static void wake_parent(int pipefd, int lguest_fd, struct device_list *devices)
+{
 	set_fd(pipefd, devices);
 
 	for (;;) {
 		fd_set rfds = devices->infds;
+		u32 args[] = { LHREQ_BREAK, 1 };
 
 		select(devices->max_infd+1, &rfds, NULL, NULL, NULL);
 		if (FD_ISSET(pipefd, &rfds)) {
@@ -357,25 +356,14 @@ static void wake_parent(int pipefd, stru
 			if (read(pipefd, &ignorefd, sizeof(ignorefd)) == 0)
 				exit(0);
 			FD_CLR(ignorefd, &devices->infds);
-		}
-		kill(getppid(), SIGUSR1);
-	}
-}
-
-/* We don't want signal to kill us, just jerk us out of kernel. */
-static void wakeup(int signo)
-{
-}
-
-static int setup_waker(struct device_list *device_list)
+		} else
+			write(lguest_fd, args, sizeof(args));
+	}
+}
+
+static int setup_waker(int lguest_fd, struct device_list *device_list)
 {
 	int pipefd[2], child;
-	struct sigaction act;
-
-	act.sa_handler = wakeup;
-	sigemptyset(&act.sa_mask);
-	act.sa_flags = 0;
-	sigaction(SIGUSR1, &act, NULL);
 
 	pipe(pipefd);
 	child = fork();
@@ -384,7 +372,7 @@ static int setup_waker(struct device_lis
 
 	if (child == 0) {
 		close(pipefd[1]);
-		wake_parent(pipefd[0], device_list);
+		wake_parent(pipefd[0], lguest_fd, device_list);
 	}
 	close(pipefd[0]);
 
@@ -495,8 +483,13 @@ static bool handle_console_input(int fd,
 		else if (abort->count == 3) {
 			struct timeval now;
 			gettimeofday(&now, NULL);
-			if (now.tv_sec <= abort->start.tv_sec+1)
+			if (now.tv_sec <= abort->start.tv_sec+1) {
+				/* Make sure waker is not blocked in BREAK */
+				u32 args[] = { LHREQ_BREAK, 0 };
+				close(waker_fd);
+				write(fd, args, sizeof(args));
 				exit(2);
+			}
 			abort->count = 0;
 		}
 	} else
@@ -613,7 +606,7 @@ static void handle_output(int fd, unsign
 	warnx("Pending dma %p, key %p", (void *)dma, (void *)key);
 }
 
-static void handle_input(int fd, int childfd, struct device_list *devices)
+static void handle_input(int fd, struct device_list *devices)
 {
 	struct timeval poll = { .tv_sec = 0, .tv_usec = 0 };
 
@@ -628,8 +621,8 @@ static void handle_input(int fd, int chi
 			if (i->handle_input && FD_ISSET(i->fd, &fds)) {
 				if (!i->handle_input(fd, i)) {
 					FD_CLR(i->fd, &devices->infds);
-					/* Tell child to ignore it too... */
-					write(childfd, &i->fd, sizeof(i->fd));
+					/* Tell waker to ignore it too... */
+					write(waker_fd, &i->fd, sizeof(i->fd));
 				}
 			}
 		}
@@ -898,29 +891,28 @@ static void map_device_descriptors(struc
 }
 
 static void __attribute__((noreturn))
-run_guest(int lguest_fd, int waker_fd, struct device_list *device_list)
-{
-	sigset_t sigset;
-
-	sigemptyset(&sigset);
-	sigaddset(&sigset, SIGUSR1);
+run_guest(int lguest_fd, struct device_list *device_list)
+{
 	for (;;) {
+		u32 args[] = { LHREQ_BREAK, 0 };
 		unsigned long arr[2];
 		int readval;
 
-		sigprocmask(SIG_UNBLOCK, &sigset, NULL);
+		/* We read from the /dev/lguest device to run the Guest. */
 		readval = read(lguest_fd, arr, sizeof(arr));
-		sigprocmask(SIG_BLOCK, &sigset, NULL);
-
-		if (readval == sizeof(arr))
+
+		if (readval == sizeof(arr)) {
 			handle_output(lguest_fd, arr[0], arr[1], device_list);
-		else if (errno == ENOENT) {
+			continue;
+		} else if (errno == ENOENT) {
 			char reason[1024] = { 0 };
 			read(lguest_fd, reason, sizeof(reason)-1);
 			errx(1, "%s", reason);
-		} else if (errno != EINTR)
+		} else if (errno != EAGAIN)
 			err(1, "Running guest failed");
-		handle_input(lguest_fd, waker_fd, device_list);
+		handle_input(lguest_fd, device_list);
+		if (write(lguest_fd, args, sizeof(args)) < 0)
+			err(1, "Resetting break");
 	}
 }
 
@@ -943,7 +935,7 @@ int main(int argc, char *argv[])
 int main(int argc, char *argv[])
 {
 	unsigned long mem, pgdir, start, page_offset, initrd_size = 0;
-	int c, lguest_fd, waker_fd;
+	int c, lguest_fd;
 	struct device_list device_list;
 	void *boot = (void *)0;
 	const char *initrd_name = NULL;
@@ -1014,7 +1006,7 @@ int main(int argc, char *argv[])
 	*(int *)(boot + 0x23c) = 1;
 
 	lguest_fd = tell_kernel(pgdir, start, page_offset);
-	waker_fd = setup_waker(&device_list);
-
-	run_guest(lguest_fd, waker_fd, &device_list);
-}
+	waker_fd = setup_waker(lguest_fd, &device_list);
+
+	run_guest(lguest_fd, &device_list);
+}
===================================================================
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -313,7 +313,12 @@ int run_guest(struct lguest *lg, unsigne
 		}
 
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
+
+		/* If Waker set break_out, return to Launcher. */
+		if (lg->break_out)
+			return -EAGAIN;
+
 		maybe_do_interrupt(lg);
 
 		try_to_freeze();
===================================================================
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -16,6 +16,7 @@
 #include <linux/futex.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
+#include <linux/wait.h>
 #include <linux/err.h>
 #include <asm/semaphore.h>
 #include "irq_vectors.h"
@@ -138,6 +139,10 @@ struct lguest
 	u32 esp1;
 	u8 ss1;
 
+	/* Do we need to stop what we're doing and return to userspace? */
+	int break_out;
+	wait_queue_head_t break_wq;
+
 	/* Bitmap of what has changed: see CHANGED_* above. */
 	int changed;
 	struct lguest_pages *last_pages;
===================================================================
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -30,6 +30,30 @@ static long user_get_dma(struct lguest *
 	return udma;
 }
 
+/* To force the Guest to stop running and return to the Launcher, the
+ * Waker sets writes LHREQ_BREAK and the value "1" to /dev/lguest.  The
+ * Launcher then writes LHREQ_BREAK and "0" to release the Waker. */
+static int break_guest_out(struct lguest *lg, const u32 __user *input)
+{
+	unsigned long on;
+
+	/* Fetch whether they're turning break on or off.. */
+	if (get_user(on, input) != 0)
+		return -EFAULT;
+
+	if (on) {
+		lg->break_out = 1;
+		/* Pop it out (may be running on different CPU) */
+		wake_up_process(lg->tsk);
+		/* Wait for them to reset it */
+		return wait_event_interruptible(lg->break_wq, !lg->break_out);
+	} else {
+		lg->break_out = 0;
+		wake_up(&lg->break_wq);
+		return 0;
+	}
+}
+
 /* + irq */
 static int user_send_irq(struct lguest *lg, const u32 __user *input)
 {
@@ -49,6 +73,10 @@ static ssize_t read(struct file *file, c
 
 	if (!lg)
 		return -EINVAL;
+
+	/* If you're not the task which owns the guest, go away. */
+	if (current != lg->tsk)
+		return -EPERM;
 
 	if (lg->dead) {
 		size_t len;
@@ -75,13 +103,20 @@ static int initialize(struct file *file,
 	int err, i;
 	u32 args[4];
 
-	if (file->private_data)
-		return -EBUSY;
-
-	if (copy_from_user(args, input, sizeof(args)) != 0)
-		return -EFAULT;
-
+	/* We grab the Big Lguest lock, which protects the global array
+	 * "lguests" and multiple simultaneous initializations. */
 	mutex_lock(&lguest_lock);
+
+	if (file->private_data) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	if (copy_from_user(args, input, sizeof(args)) != 0) {
+		err = -EFAULT;
+		goto unlock;
+	}
+
 	i = find_free_guest();
 	if (i < 0) {
 		err = -ENOSPC;
@@ -107,10 +142,12 @@ static int initialize(struct file *file,
 	lg->tsk = current;
 	get_task_struct(lg->tsk);
 	lg->mm = get_task_mm(lg->tsk);
+	init_waitqueue_head(&lg->break_wq);
 	lg->last_pages = NULL;
-	mutex_unlock(&lguest_lock);
-
 	file->private_data = lg;
+
+	mutex_unlock(&lguest_lock);
+
 	return sizeof(args);
 
 free_regs:
@@ -136,6 +173,10 @@ static ssize_t write(struct file *file, 
 		return -EINVAL;
 	if (lg && lg->dead)
 		return -ENOENT;
+
+	/* If you're not the task which owns the Guest, you can only break */
+	if (lg && current != lg->tsk && req != LHREQ_BREAK)
+		return -EPERM;
 
 	switch (req) {
 	case LHREQ_INITIALIZE:
@@ -144,6 +185,8 @@ static ssize_t write(struct file *file, 
 		return user_get_dma(lg, (const u32 __user *)input);
 	case LHREQ_IRQ:
 		return user_send_irq(lg, (const u32 __user *)input);
+	case LHREQ_BREAK:
+		return break_guest_out(lg, (const u32 __user *)input);
 	default:
 		return -EINVAL;
 	}
===================================================================
--- a/include/linux/lguest_launcher.h
+++ b/include/linux/lguest_launcher.h
@@ -68,5 +68,6 @@ enum lguest_req
 	LHREQ_INITIALIZE, /* + pfnlimit, pgdir, start, pageoffset */
 	LHREQ_GETDMA, /* + addr (returns &lguest_dma, irq in ->used_len) */
 	LHREQ_IRQ, /* + irq */
+	LHREQ_BREAK, /* + on/off flag (on blocks until someone does off) */
 };
 #endif /* _ASM_LGUEST_USER */


