Return-Path: <linux-kernel-owner+w=401wt.eu-S1764954AbYDYR74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764954AbYDYR74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764581AbYDYR5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:14 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53124 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764776AbYDYR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:01 -0400
Date: Fri, 25 Apr 2008 13:56:08 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/19] UML - Random driver fixes
Message-ID: <20080425175607.GA11178@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The random driver would essentially hang if the host's /dev/random
returned -EAGAIN.  There was a test of need_resched followed by a
schedule inside the loop, but that didn't help and it's the wrong way
to work anyway.

The right way is to ask for an interrupt when there is input available
from the host and handle it then rather than polling.

Now, when the host's /dev/random returns -EAGAIN, the driver asks for
a wakeup when there's randomness available again and sleeps.  The
interrupt routine just wakes up whatever processes are sleeping on
host_read_wait.

There is an atomic_t, host_sleep_count, which counts the number of
processes waiting for randomness.  When this reaches zero, the
interrupt is disabled.

An added complication is that async I/O notification was only recently
added to /dev/random (by me), so essentially all hosts will lack it.
So, we use the sigio workaround here, which is to have a separate
thread poll on the descriptor and send an interrupt when there is
input on it.  This mechanism is activated when a process gets -EAGAIN
(activating this multiple times is harmless, if a bit wasteful) and
deactivated by the last process still waiting.

The module name was changed from "random" to "hw_random" in order for
udev to recognize it.

The sigio workaround needed some changes.  sigio_broken was added for
cases when we know that async notification doesn't work.  This is now
called from maybe_sigio_broken, which deals with pts devices.

While I was in sigio.c, I unvolatiled a variable, sticking a barrier()
in instead.  I moved the definition of barrier to process.h and
cleaned that up while I was there.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/random.c  |   41 +++++++++++++++++++++++++++++++++++++----
 arch/um/include/os.h      |    1 +
 arch/um/include/process.h |   20 ++++++--------------
 arch/um/os-Linux/sigio.c  |   35 +++++++++++++++++++++--------------
 arch/um/os-Linux/signal.c |    1 +
 include/asm-um/irq.h      |    3 ++-
 6 files changed, 68 insertions(+), 33 deletions(-)

Index: linux-2.6-git/arch/um/drivers/random.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/random.c	2008-04-25 11:22:26.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/random.c	2008-04-25 11:28:25.000000000 -0400
@@ -8,16 +8,18 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/interrupt.h>
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <asm/uaccess.h>
+#include "irq_kern.h"
 #include "os.h"
 
 /*
  * core module and version information
  */
 #define RNG_VERSION "1.0.0"
-#define RNG_MODULE_NAME "random"
+#define RNG_MODULE_NAME "hw_random"
 
 #define RNG_MISCDEV_MINOR		183 /* official */
 
@@ -26,6 +28,7 @@
  * protects against a module being loaded twice at the same time.
  */
 static int random_fd = -1;
+static DECLARE_WAIT_QUEUE_HEAD(host_read_wait);
 
 static int rng_dev_open (struct inode *inode, struct file *filp)
 {
@@ -38,6 +41,8 @@ static int rng_dev_open (struct inode *i
 	return 0;
 }
 
+static atomic_t host_sleep_count = ATOMIC_INIT(0);
+
 static ssize_t rng_dev_read (struct file *filp, char __user *buf, size_t size,
                              loff_t * offp)
 {
@@ -60,11 +65,26 @@ static ssize_t rng_dev_read (struct file
                         }
                 }
                 else if(n == -EAGAIN){
+			DECLARE_WAITQUEUE(wait, current);
+
                         if (filp->f_flags & O_NONBLOCK)
                                 return ret ? : -EAGAIN;
 
-                        if(need_resched())
-                                schedule_timeout_interruptible(1);
+			atomic_inc(&host_sleep_count);
+			reactivate_fd(random_fd, RANDOM_IRQ);
+			add_sigio_fd(random_fd);
+
+			add_wait_queue(&host_read_wait, &wait);
+			set_task_state(current, TASK_INTERRUPTIBLE);
+
+			schedule();
+			set_task_state(current, TASK_RUNNING);
+			remove_wait_queue(&host_read_wait, &wait);
+
+			if (atomic_dec_and_test(&host_sleep_count)) {
+				ignore_sigio_fd(random_fd);
+				deactivate_fd(random_fd, RANDOM_IRQ);
+			}
                 }
                 else return n;
 		if (signal_pending (current))
@@ -86,6 +106,13 @@ static struct miscdevice rng_miscdev = {
 	&rng_chrdev_ops,
 };
 
+static irqreturn_t random_interrupt(int irq, void *data)
+{
+	wake_up(&host_read_wait);
+
+	return IRQ_HANDLED;
+}
+
 /*
  * rng_init - initialize RNG module
  */
@@ -99,10 +126,14 @@ static int __init rng_init (void)
 
         random_fd = err;
 
-        err = os_set_fd_block(random_fd, 0);
+	err = um_request_irq(RANDOM_IRQ, random_fd, IRQ_READ, random_interrupt,
+			     IRQF_DISABLED | IRQF_SAMPLE_RANDOM, "random",
+			     NULL);
         if(err)
 		goto err_out_cleanup_hw;
 
+	sigio_broken(random_fd, 1);
+
 	err = misc_register (&rng_miscdev);
 	if (err) {
 		printk (KERN_ERR RNG_MODULE_NAME ": misc device register failed\n");
@@ -113,6 +144,7 @@ static int __init rng_init (void)
         return err;
 
  err_out_cleanup_hw:
+	os_close_file(random_fd);
         random_fd = -1;
         goto out;
 }
@@ -122,6 +154,7 @@ static int __init rng_init (void)
  */
 static void __exit rng_cleanup (void)
 {
+	os_close_file(random_fd);
 	misc_deregister (&rng_miscdev);
 }
 
Index: linux-2.6-git/arch/um/os-Linux/sigio.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/sigio.c	2008-04-25 11:22:26.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/sigio.c	2008-04-25 11:30:18.000000000 -0400
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Copyright (C) 2002 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -15,6 +15,7 @@
 #include "kern_util.h"
 #include "init.h"
 #include "os.h"
+#include "process.h"
 #include "sigio.h"
 #include "um_malloc.h"
 #include "user.h"
@@ -338,20 +339,10 @@ out_close1:
 	close(l_write_sigio_fds[1]);
 }
 
-/* Changed during early boot */
-static int pty_output_sigio = 0;
-static int pty_close_sigio = 0;
-
-void maybe_sigio_broken(int fd, int read)
+void sigio_broken(int fd, int read)
 {
 	int err;
 
-	if (!isatty(fd))
-		return;
-
-	if ((read || pty_output_sigio) && (!read || pty_close_sigio))
-		return;
-
 	write_sigio_workaround();
 
 	sigio_lock();
@@ -370,6 +361,21 @@ out:
 	sigio_unlock();
 }
 
+/* Changed during early boot */
+static int pty_output_sigio;
+static int pty_close_sigio;
+
+void maybe_sigio_broken(int fd, int read)
+{
+	if (!isatty(fd))
+		return;
+
+	if ((read || pty_output_sigio) && (!read || pty_close_sigio))
+		return;
+
+	sigio_broken(fd, read);
+}
+
 static void sigio_cleanup(void)
 {
 	if (write_sigio_pid == -1)
@@ -383,7 +389,7 @@ static void sigio_cleanup(void)
 __uml_exitcall(sigio_cleanup);
 
 /* Used as a flag during SIGIO testing early in boot */
-static volatile int got_sigio = 0;
+static int got_sigio;
 
 static void __init handler(int sig)
 {
@@ -498,7 +504,8 @@ static void tty_output(int master, int s
 	if (errno != EAGAIN)
 		printk(UM_KERN_ERR "tty_output : write failed, errno = %d\n",
 		       errno);
-	while (((n = read(slave, buf, sizeof(buf))) > 0) && !got_sigio)
+	while (((n = read(slave, buf, sizeof(buf))) > 0) &&
+	       !({ barrier(); got_sigio; }))
 		;
 
 	if (got_sigio) {
Index: linux-2.6-git/include/asm-um/irq.h
===================================================================
--- linux-2.6-git.orig/include/asm-um/irq.h	2008-04-25 11:22:26.000000000 -0400
+++ linux-2.6-git/include/asm-um/irq.h	2008-04-25 11:28:25.000000000 -0400
@@ -15,8 +15,9 @@
 #define SIGIO_WRITE_IRQ 	11
 #define TELNETD_IRQ 		12
 #define XTERM_IRQ 		13
+#define RANDOM_IRQ 		14
 
-#define LAST_IRQ XTERM_IRQ
+#define LAST_IRQ RANDOM_IRQ
 #define NR_IRQS (LAST_IRQ + 1)
 
 #endif
Index: linux-2.6-git/arch/um/include/os.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/os.h	2008-04-25 11:22:26.000000000 -0400
+++ linux-2.6-git/arch/um/include/os.h	2008-04-25 11:28:25.000000000 -0400
@@ -290,6 +290,7 @@ extern void os_set_ioignore(void);
 extern int add_sigio_fd(int fd);
 extern int ignore_sigio_fd(int fd);
 extern void maybe_sigio_broken(int fd, int read);
+extern void sigio_broken(int fd, int read);
 
 /* sys-x86_64/prctl.c */
 extern int os_arch_prctl(int pid, int code, unsigned long *addr);
Index: linux-2.6-git/arch/um/include/process.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/process.h	2008-04-25 11:22:26.000000000 -0400
+++ linux-2.6-git/arch/um/include/process.h	2008-04-25 11:28:25.000000000 -0400
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -8,18 +8,10 @@
 
 #include <signal.h>
 
-extern void sig_handler(int sig, struct sigcontext sc);
-extern void alarm_handler(int sig, struct sigcontext sc);
+/* Copied from linux/compiler-gcc.h since we can't include it directly */
+#define barrier() __asm__ __volatile__("": : :"memory")
 
-#endif
+extern void sig_handler(int sig, struct sigcontext *sc);
+extern void alarm_handler(int sig, struct sigcontext *sc);
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
+#endif
Index: linux-2.6-git/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/signal.c	2008-04-25 11:22:26.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/signal.c	2008-04-25 11:28:25.000000000 -0400
@@ -12,6 +12,7 @@
 #include "as-layout.h"
 #include "kern_util.h"
 #include "os.h"
+#include "process.h"
 #include "sysdep/barrier.h"
 #include "sysdep/sigcontext.h"
 #include "user.h"
