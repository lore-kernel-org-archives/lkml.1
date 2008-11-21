Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYKUXvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYKUXvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 18:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbYKUXuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 18:50:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:24031 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbYKUXuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 18:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=rOw95AynUt4a3nH1MvCIERwyxtTvgAP4nzwOMGp5g29h4s+9+rdw1v5PM46JakxDrR
         JmvZaEUYnZ6ntSN9X4sL2nu3yj6vz/xS7OrJJVGlnOPrPHayosoBhu0LPR2YZtKy0cZm
         sHSyLf2cx0hkWbO3I16Je6GtlO2ToKGzHHmy0=
Date: Sat, 22 Nov 2008 00:51:59 +0100
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [RFC][PATCH] sysrq-j: emergency shell
Message-ID: <20081121235159.GA15861@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 57adfe62983db316fceba1b64258fd3d8830bcd8 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 22 Nov 2008 00:25:57 +0100
Subject: [PATCH] sysrq-j: emergency shell

This patch adds support for "SysRq-j", which invokes an emergency
root shell in the current console.

Please don't bite my head off for abusing the file API; documentation
was rather sparse! (Corrections are welcome, though.)

It seems that keyboard input will go to the shell only half of the
time; the other half goes to whatever program was running there in
the first place. I tried to kill the other users of the TTY using
TIOCSCTTY, but it seems not to have worked. Any ideas?

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 init/main.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index 7e117a2..edd5274 100644
--- a/init/main.c
+++ b/init/main.c
@@ -63,6 +63,8 @@
 #include <linux/signal.h>
 #include <linux/idr.h>
 #include <linux/ftrace.h>
+#include <linux/sysrq.h>
+#include <linux/file.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -833,6 +835,106 @@ static int noinline init_post(void)
 	panic("No init found.  Try passing init= option to kernel.");
 }
 
+static int sysrq_sh_thread(void *unused)
+{
+	static char *const argv[] = {"sh", NULL};
+	static char *const envp[] = {"HOME=/", "TERM=linux", NULL};
+
+	struct file *console;
+	int i;
+	int ret;
+
+	for (i = 0; i < 3; ++i) {
+		ret = get_unused_fd();
+		if (ret < 0)
+			goto put_fds;
+		if (ret != i) {
+			put_unused_fd(ret);
+			ret = -EBADF;
+			goto put_fds;
+		}
+	}
+
+	console = filp_open("/dev/console", O_RDWR | O_NOCTTY, 0);
+	if (IS_ERR(console)) {
+		ret = PTR_ERR(console);
+		goto put_fds;
+	}
+
+	get_file(console);
+	get_file(console);
+	get_file(console);
+	fd_install(0, console);
+	fd_install(1, console);
+	fd_install(2, console);
+
+	/* Become session leader */
+	ret = sys_setsid();
+	if (ret < 0)
+		goto put_filp;
+
+	/* Exclusive mode; no others are allowed to open() this tty */
+	ret = sys_ioctl(0, TIOCEXCL, 0);
+	if (ret < 0)
+		goto put_filp;
+
+	/* Steal the tty from whoever */
+	ret = sys_ioctl(0, TIOCSCTTY, 1);
+	if (ret < 0)
+		goto put_filp;
+
+	/* Flush pending input */
+	ret = sys_ioctl(0, TCFLSH, TCIFLUSH);
+	if (ret < 0)
+		goto put_filp;
+
+	/* If execve() returns, something went wrong. */
+	ret = kernel_execve("/bin/sh", argv, envp);
+
+put_filp:
+	fput(console);
+
+put_fds:
+	while (--i >= 0)
+		put_unused_fd(i);
+
+	printk(KERN_ERR "Couldn't start shell: %d\n", ret);
+	return ret;
+}
+
+static void sysrq_sh_work_func(struct work_struct *work)
+{
+	int err;
+
+	err = kernel_thread(sysrq_sh_thread, NULL, CLONE_FS | CLONE_SIGHAND);
+	if (err < 0)
+		printk(KERN_ERR "Couldn't start kernel thread (%d)\n", err);
+}
+
+static DECLARE_WORK(sysrq_sh_work, &sysrq_sh_work_func);
+
+static void sysrq_sh_handle(int key, struct tty_struct *tty)
+{
+	schedule_work(&sysrq_sh_work);
+}
+
+static struct sysrq_key_op sysrq_sh_op = {
+	.handler = sysrq_sh_handle,
+	.help_msg = "shell(j)",
+	.action_msg = "Emergency shell",
+};
+
+static void sysrq_sh_init(void)
+{
+	int err;
+
+	err = register_sysrq_key('j', &sysrq_sh_op);
+	if (err < 0) {
+		printk(KERN_ERR "Couldn't register SysRq-j (emergency shell) "
+			"handler. (%d)\n", err);
+	}
+}
+
 static int __init kernel_init(void * unused)
 {
 	lock_kernel();
@@ -877,6 +979,8 @@ static int __init kernel_init(void * unused)
 		prepare_namespace();
 	}
 
+	sysrq_sh_init();
+
 	/*
 	 * Ok, we have completed the initial bootup, and
 	 * we're essentially up and running. Get rid of the
-- 
1.5.6.5

