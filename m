Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZI2Qix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZI2Qix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZI2Qix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:38:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbZI2Qiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:38:52 -0400
Date: Tue, 29 Sep 2009 09:38:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not
 used
In-Reply-To: <alpine.LFD.2.01.0909290909280.6996@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909290936430.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909280743310.3349@localhost.localdomain> <20090928135332.4300.56046.stgit@warthog.procyon.org.uk> <20090928151628.62955233@lxorguk.ukuu.org.uk> <395.1254239745@redhat.com>
 <alpine.LFD.2.01.0909290909280.6996@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Sep 2009, Linus Torvalds wrote:

> 
> 
> On Tue, 29 Sep 2009, David Howells wrote:
> > 
> > Is it right to use pty_ops_bsd in _both_ places?  Looking at the code in
> > linux-2.6.0, the BSD ioctl only applies to the master and doesn't apply to the
> > slave.
> 
> Right you are, good catch.

Anyway, here's an updated patch to just fix this part. Whether we need to 
have that crazy locking at all, considering that it was broken for 18 
months, is still an interesting question. But this patch just tries to fix 
the long-time bug.

Comments?

		Linus

---
 drivers/char/pty.c |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 53761ce..dcbbf57 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -261,6 +261,9 @@ done:
 	return 0;
 }
 
+/* Traditional BSD devices */
+#ifdef CONFIG_LEGACY_PTYS
+
 static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct tty_struct *o_tty;
@@ -310,22 +313,6 @@ free_mem_out:
 	return -ENOMEM;
 }
 
-
-static const struct tty_operations pty_ops = {
-	.install = pty_install,
-	.open = pty_open,
-	.close = pty_close,
-	.write = pty_write,
-	.write_room = pty_write_room,
-	.flush_buffer = pty_flush_buffer,
-	.chars_in_buffer = pty_chars_in_buffer,
-	.unthrottle = pty_unthrottle,
-	.set_termios = pty_set_termios,
-	.resize = pty_resize
-};
-
-/* Traditional BSD devices */
-#ifdef CONFIG_LEGACY_PTYS
 static struct tty_driver *pty_driver, *pty_slave_driver;
 
 static int pty_bsd_ioctl(struct tty_struct *tty, struct file *file,
@@ -341,7 +328,12 @@ static int pty_bsd_ioctl(struct tty_struct *tty, struct file *file,
 static int legacy_count = CONFIG_LEGACY_PTY_COUNT;
 module_param(legacy_count, int, 0);
 
-static const struct tty_operations pty_ops_bsd = {
+/*
+ * The master side of a pty can do TIOCSPTLCK and thus
+ * has pty_bsd_ioctl.
+ */
+static const struct tty_operations master_pty_ops_bsd = {
+	.install = pty_install,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -354,6 +346,19 @@ static const struct tty_operations pty_ops_bsd = {
 	.resize = pty_resize
 };
 
+static const struct tty_operations slave_pty_ops_bsd = {
+	.install = pty_install,
+	.open = pty_open,
+	.close = pty_close,
+	.write = pty_write,
+	.write_room = pty_write_room,
+	.flush_buffer = pty_flush_buffer,
+	.chars_in_buffer = pty_chars_in_buffer,
+	.unthrottle = pty_unthrottle,
+	.set_termios = pty_set_termios,
+	.resize = pty_resize
+};
+
 static void __init legacy_pty_init(void)
 {
 	if (legacy_count <= 0)
@@ -383,7 +388,7 @@ static void __init legacy_pty_init(void)
 	pty_driver->init_termios.c_ospeed = 38400;
 	pty_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW;
 	pty_driver->other = pty_slave_driver;
-	tty_set_operations(pty_driver, &pty_ops);
+	tty_set_operations(pty_driver, &master_pty_ops_bsd);
 
 	pty_slave_driver->owner = THIS_MODULE;
 	pty_slave_driver->driver_name = "pty_slave";
@@ -399,7 +404,7 @@ static void __init legacy_pty_init(void)
 	pty_slave_driver->flags = TTY_DRIVER_RESET_TERMIOS |
 					TTY_DRIVER_REAL_RAW;
 	pty_slave_driver->other = pty_driver;
-	tty_set_operations(pty_slave_driver, &pty_ops);
+	tty_set_operations(pty_slave_driver, &slave_pty_ops_bsd);
 
 	if (tty_register_driver(pty_driver))
 		panic("Couldn't register pty driver");
