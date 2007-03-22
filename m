Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbXCVQKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbXCVQKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934011AbXCVQJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:09:41 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53366 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933840AbXCVQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:09:38 -0400
Date: Thu, 22 Mar 2007 12:06:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 2/7 ] UML - Move SIGIO testing to sigio.c
Message-ID: <20070322160641.GA7002@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch narrows the sigio interface.  The boot-time SIGIO testing
used to be in start_up.c, which meant that pty_output_sigio and
pty_close_sigio needed to be global.  By moving that code here, those
can become static and the declarations moved from user_util.h.

os_check_bugs is also here because it only does the SIGIO checking.
If it does more, it'll probably move back to start_up.c.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/user_util.h |    3 
 arch/um/os-Linux/sigio.c    |  145 ++++++++++++++++++++++++++++++++++++++++++++
 arch/um/os-Linux/start_up.c |  145 --------------------------------------------
 3 files changed, 145 insertions(+), 148 deletions(-)

Index: linux-2.6.21-mm/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/start_up.c	2007-03-21 15:22:48.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/start_up.c	2007-03-21 15:24:33.000000000 -0400
@@ -553,148 +553,3 @@ int __init parse_iomem(char *str, int *a
  out:
 	return 1;
 }
-
-
-/* Changed during early boot */
-int pty_output_sigio = 0;
-int pty_close_sigio = 0;
-
-/* Used as a flag during SIGIO testing early in boot */
-static volatile int got_sigio = 0;
-
-static void __init handler(int sig)
-{
-	got_sigio = 1;
-}
-
-struct openpty_arg {
-	int master;
-	int slave;
-	int err;
-};
-
-static void openpty_cb(void *arg)
-{
-	struct openpty_arg *info = arg;
-
-	info->err = 0;
-	if(openpty(&info->master, &info->slave, NULL, NULL, NULL))
-		info->err = -errno;
-}
-
-static int async_pty(int master, int slave)
-{
-	int flags;
-
-	flags = fcntl(master, F_GETFL);
-	if(flags < 0)
-		return -errno;
-
-	if((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
-	   (fcntl(master, F_SETOWN, os_getpid()) < 0))
-		return -errno;
-
-	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
-		return -errno;
-
-	return(0);
-}
-
-static void __init check_one_sigio(void (*proc)(int, int))
-{
-	struct sigaction old, new;
-	struct openpty_arg pty = { .master = -1, .slave = -1 };
-	int master, slave, err;
-
-	initial_thread_cb(openpty_cb, &pty);
-	if(pty.err){
-		printk("openpty failed, errno = %d\n", -pty.err);
-		return;
-	}
-
-	master = pty.master;
-	slave = pty.slave;
-
-	if((master == -1) || (slave == -1)){
-		printk("openpty failed to allocate a pty\n");
-		return;
-	}
-
-	/* Not now, but complain so we now where we failed. */
-	err = raw(master);
-	if (err < 0)
-		panic("check_sigio : __raw failed, errno = %d\n", -err);
-
-	err = async_pty(master, slave);
-	if(err < 0)
-		panic("tty_fds : sigio_async failed, err = %d\n", -err);
-
-	if(sigaction(SIGIO, NULL, &old) < 0)
-		panic("check_sigio : sigaction 1 failed, errno = %d\n", errno);
-	new = old;
-	new.sa_handler = handler;
-	if(sigaction(SIGIO, &new, NULL) < 0)
-		panic("check_sigio : sigaction 2 failed, errno = %d\n", errno);
-
-	got_sigio = 0;
-	(*proc)(master, slave);
-
-	close(master);
-	close(slave);
-
-	if(sigaction(SIGIO, &old, NULL) < 0)
-		panic("check_sigio : sigaction 3 failed, errno = %d\n", errno);
-}
-
-static void tty_output(int master, int slave)
-{
-	int n;
-	char buf[512];
-
-	printk("Checking that host ptys support output SIGIO...");
-
-	memset(buf, 0, sizeof(buf));
-
-	while(os_write_file(master, buf, sizeof(buf)) > 0) ;
-	if(errno != EAGAIN)
-		panic("check_sigio : write failed, errno = %d\n", errno);
-	while(((n = os_read_file(slave, buf, sizeof(buf))) > 0) && !got_sigio) ;
-
-	if(got_sigio){
-		printk("Yes\n");
-		pty_output_sigio = 1;
-	}
-	else if(n == -EAGAIN) printk("No, enabling workaround\n");
-	else panic("check_sigio : read failed, err = %d\n", n);
-}
-
-static void tty_close(int master, int slave)
-{
-	printk("Checking that host ptys support SIGIO on close...");
-
-	close(slave);
-	if(got_sigio){
-		printk("Yes\n");
-		pty_close_sigio = 1;
-	}
-	else printk("No, enabling workaround\n");
-}
-
-void __init check_sigio(void)
-{
-	if((os_access("/dev/ptmx", OS_ACC_R_OK) < 0) &&
-	   (os_access("/dev/ptyp0", OS_ACC_R_OK) < 0)){
-		printk("No pseudo-terminals available - skipping pty SIGIO "
-		       "check\n");
-		return;
-	}
-	check_one_sigio(tty_output);
-	check_one_sigio(tty_close);
-}
-
-void os_check_bugs(void)
-{
-	check_ptrace();
-	check_sigio();
-}
-
Index: linux-2.6.21-mm/arch/um/os-Linux/sigio.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/sigio.c	2007-03-21 15:22:48.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/sigio.c	2007-03-21 16:16:50.000000000 -0400
@@ -8,6 +8,7 @@
 #include <termios.h>
 #include <pty.h>
 #include <signal.h>
+#include <fcntl.h>
 #include <errno.h>
 #include <string.h>
 #include <sched.h>
@@ -20,6 +21,7 @@
 #include "sigio.h"
 #include "os.h"
 #include "um_malloc.h"
+#include "init.h"
 
 /* Protected by sigio_lock(), also used by sigio_cleanup, which is an
  * exitcall.
@@ -320,6 +322,10 @@ out_close1:
 	close(l_write_sigio_fds[1]);
 }
 
+/* Changed during early boot */
+static int pty_output_sigio = 0;
+static int pty_close_sigio = 0;
+
 void maybe_sigio_broken(int fd, int read)
 {
 	int err;
@@ -357,3 +363,142 @@ static void sigio_cleanup(void)
 }
 
 __uml_exitcall(sigio_cleanup);
+
+/* Used as a flag during SIGIO testing early in boot */
+static volatile int got_sigio = 0;
+
+static void __init handler(int sig)
+{
+	got_sigio = 1;
+}
+
+struct openpty_arg {
+	int master;
+	int slave;
+	int err;
+};
+
+static void openpty_cb(void *arg)
+{
+	struct openpty_arg *info = arg;
+
+	info->err = 0;
+	if(openpty(&info->master, &info->slave, NULL, NULL, NULL))
+		info->err = -errno;
+}
+
+static int async_pty(int master, int slave)
+{
+	int flags;
+
+	flags = fcntl(master, F_GETFL);
+	if(flags < 0)
+		return -errno;
+
+	if((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
+	   (fcntl(master, F_SETOWN, os_getpid()) < 0))
+		return -errno;
+
+	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
+		return -errno;
+
+	return(0);
+}
+
+static void __init check_one_sigio(void (*proc)(int, int))
+{
+	struct sigaction old, new;
+	struct openpty_arg pty = { .master = -1, .slave = -1 };
+	int master, slave, err;
+
+	initial_thread_cb(openpty_cb, &pty);
+	if(pty.err){
+		printk("openpty failed, errno = %d\n", -pty.err);
+		return;
+	}
+
+	master = pty.master;
+	slave = pty.slave;
+
+	if((master == -1) || (slave == -1)){
+		printk("openpty failed to allocate a pty\n");
+		return;
+	}
+
+	/* Not now, but complain so we now where we failed. */
+	err = raw(master);
+	if (err < 0)
+		panic("check_sigio : __raw failed, errno = %d\n", -err);
+
+	err = async_pty(master, slave);
+	if(err < 0)
+		panic("tty_fds : sigio_async failed, err = %d\n", -err);
+
+	if(sigaction(SIGIO, NULL, &old) < 0)
+		panic("check_sigio : sigaction 1 failed, errno = %d\n", errno);
+	new = old;
+	new.sa_handler = handler;
+	if(sigaction(SIGIO, &new, NULL) < 0)
+		panic("check_sigio : sigaction 2 failed, errno = %d\n", errno);
+
+	got_sigio = 0;
+	(*proc)(master, slave);
+
+	close(master);
+	close(slave);
+
+	if(sigaction(SIGIO, &old, NULL) < 0)
+		panic("check_sigio : sigaction 3 failed, errno = %d\n", errno);
+}
+
+static void tty_output(int master, int slave)
+{
+	int n;
+	char buf[512];
+
+	printk("Checking that host ptys support output SIGIO...");
+
+	memset(buf, 0, sizeof(buf));
+
+	while(os_write_file(master, buf, sizeof(buf)) > 0) ;
+	if(errno != EAGAIN)
+		panic("check_sigio : write failed, errno = %d\n", errno);
+	while(((n = os_read_file(slave, buf, sizeof(buf))) > 0) && !got_sigio) ;
+
+	if(got_sigio){
+		printk("Yes\n");
+		pty_output_sigio = 1;
+	}
+	else if(n == -EAGAIN) printk("No, enabling workaround\n");
+	else panic("check_sigio : read failed, err = %d\n", n);
+}
+
+static void tty_close(int master, int slave)
+{
+	printk("Checking that host ptys support SIGIO on close...");
+
+	close(slave);
+	if(got_sigio){
+		printk("Yes\n");
+		pty_close_sigio = 1;
+	}
+	else printk("No, enabling workaround\n");
+}
+
+void __init check_sigio(void)
+{
+	if((os_access("/dev/ptmx", OS_ACC_R_OK) < 0) &&
+	   (os_access("/dev/ptyp0", OS_ACC_R_OK) < 0)){
+		printk("No pseudo-terminals available - skipping pty SIGIO "
+		       "check\n");
+		return;
+	}
+	check_one_sigio(tty_output);
+	check_one_sigio(tty_close);
+}
+
+/* Here because it only does the SIGIO testing for now */
+void __init os_check_bugs(void)
+{
+	check_sigio();
+}
Index: linux-2.6.21-mm/arch/um/include/user_util.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/user_util.h	2007-03-21 16:16:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/user_util.h	2007-03-21 16:17:50.000000000 -0400
@@ -51,9 +51,6 @@ extern unsigned long _stext, _etext, _sd
 extern unsigned long _unprotected_end;
 extern unsigned long brk_start;
 
-extern int pty_output_sigio;
-extern int pty_close_sigio;
-
 extern void *add_signal_handler(int sig, void (*handler)(int));
 extern int linux_main(int argc, char **argv);
 extern void set_cmdline(char *cmd);
