Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZI1O4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZI1O4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZI1O4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:56:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbZI1O4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:56:48 -0400
Date: Mon, 28 Sep 2009 07:55:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not
 used
In-Reply-To: <20090928151628.62955233@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0909280743310.3349@localhost.localdomain>
References: <20090928135332.4300.56046.stgit@warthog.procyon.org.uk> <20090928151628.62955233@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Sep 2009, Alan Cox wrote:

> On Mon, 28 Sep 2009 14:53:32 +0100
> David Howells <dhowells@redhat.com> wrote:
> > 
> > Possibly legacy_pty_init() should be passing this to tty_set_operations()
> > rather than pty_ops.
> 
> It should indeed, otherwise the BSD pty locking ioctl fails.

Hmm. The pty_ops_bsd thing is missing the .install handler. And looking at 
it, I'm not immediately seeing the difference between the pty_install 
handler and the pty_unix98_install one. There's some differences in 
termios initialization, and there is that 

	driver->other->ttys[idx] = o_tty;
	driver->ttys[idx] = tty

thing, but it's not entirely clear to me why the legacy pty's don't use 
the 'lookup()' logic instead (like the unix98 ones). Oh well.

Does anybody want to test this patch?

And is there any situation where this can be actually noticed? You 
obviously need to have an old distro that actually uses the old static pty 
setup.

		Linus

---
 drivers/char/pty.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 53761ce..7f93ca2 100644
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
@@ -342,6 +329,7 @@ static int legacy_count = CONFIG_LEGACY_PTY_COUNT;
 module_param(legacy_count, int, 0);
 
 static const struct tty_operations pty_ops_bsd = {
+	.install = pty_install,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -383,7 +371,7 @@ static void __init legacy_pty_init(void)
 	pty_driver->init_termios.c_ospeed = 38400;
 	pty_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW;
 	pty_driver->other = pty_slave_driver;
-	tty_set_operations(pty_driver, &pty_ops);
+	tty_set_operations(pty_driver, &pty_ops_bsd);
 
 	pty_slave_driver->owner = THIS_MODULE;
 	pty_slave_driver->driver_name = "pty_slave";
@@ -399,7 +387,7 @@ static void __init legacy_pty_init(void)
 	pty_slave_driver->flags = TTY_DRIVER_RESET_TERMIOS |
 					TTY_DRIVER_REAL_RAW;
 	pty_slave_driver->other = pty_driver;
-	tty_set_operations(pty_slave_driver, &pty_ops);
+	tty_set_operations(pty_slave_driver, &pty_ops_bsd);
 
 	if (tty_register_driver(pty_driver))
 		panic("Couldn't register pty driver");
