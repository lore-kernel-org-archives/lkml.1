Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZI1Nyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZI1Nyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZI1Nyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZI1Nyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:54:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not used
To: torvalds@osdl.org, akpm@linux-foundation.org, gregkh@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Mon, 28 Sep 2009 14:53:32 +0100
Message-ID: <20090928135332.4300.56046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove pty_ops_bsd as nothing appears to use it anymore.  It results in the
following warning:

	drivers/char/pty.c:344: warning: unused variable `pty_ops_bsd'

if CONFIG_LEGACY_PTYS=y.

Also remove pty_bsd_ioctl() as that's only referred to by pty_ops_bsd.

Possibly legacy_pty_init() should be passing this to tty_set_operations()
rather than pty_ops.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/pty.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)


diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 53761ce..175f805 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -328,32 +328,9 @@ static const struct tty_operations pty_ops = {
 #ifdef CONFIG_LEGACY_PTYS
 static struct tty_driver *pty_driver, *pty_slave_driver;
 
-static int pty_bsd_ioctl(struct tty_struct *tty, struct file *file,
-			 unsigned int cmd, unsigned long arg)
-{
-	switch (cmd) {
-	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
-		return pty_set_lock(tty, (int __user *) arg);
-	}
-	return -ENOIOCTLCMD;
-}
-
 static int legacy_count = CONFIG_LEGACY_PTY_COUNT;
 module_param(legacy_count, int, 0);
 
-static const struct tty_operations pty_ops_bsd = {
-	.open = pty_open,
-	.close = pty_close,
-	.write = pty_write,
-	.write_room = pty_write_room,
-	.flush_buffer = pty_flush_buffer,
-	.chars_in_buffer = pty_chars_in_buffer,
-	.unthrottle = pty_unthrottle,
-	.set_termios = pty_set_termios,
-	.ioctl = pty_bsd_ioctl,
-	.resize = pty_resize
-};
-
 static void __init legacy_pty_init(void)
 {
 	if (legacy_count <= 0)

