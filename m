Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbYAQVoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbYAQVoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbYAQVlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:39 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44776 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbYAQVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:36 -0500
Date: Thu, 17 Jan 2008 16:40:40 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Karol Swietlicki <magotari@gmail.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/20] UML - DEBUG_SHIRQ fixes
Message-ID: <20080117214040.GA6712@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple more DEBUG_SHIRQ fixes.

The previous mconsole blocking fix exposed the lack of O_NONBLOCK on
the mconsole socket.

Also, winch_interrupt started crashing because it is called at irq
free time and it tries to dereference tty->driver_data, which has
already been set to NULL.

I added some error cleanup in mconsole_init while I was there.

Cc: "Karol Swietlicki" <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/line.c          |    8 +++++---
 arch/um/drivers/mconsole_kern.c |    8 +++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6.22/arch/um/drivers/line.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/line.c	2007-12-14 11:28:06.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/line.c	2007-12-14 12:47:43.000000000 -0500
@@ -774,9 +774,11 @@ static irqreturn_t winch_interrupt(int i
 	tty = winch->tty;
 	if (tty != NULL) {
 		line = tty->driver_data;
-		chan_window_size(&line->chan_list, &tty->winsize.ws_row,
-				 &tty->winsize.ws_col);
-		kill_pgrp(tty->pgrp, SIGWINCH, 1);
+		if (line != NULL) {
+			chan_window_size(&line->chan_list, &tty->winsize.ws_row,
+					 &tty->winsize.ws_col);
+			kill_pgrp(tty->pgrp, SIGWINCH, 1);
+		}
 	}
  out:
 	if (winch->fd != -1)
Index: linux-2.6.22/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/mconsole_kern.c	2007-12-14 11:28:06.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/mconsole_kern.c	2007-12-14 12:53:49.000000000 -0500
@@ -792,6 +792,8 @@ static int __init mconsole_init(void)
 		printk(KERN_ERR "Failed to initialize management console\n");
 		return 1;
 	}
+	if (os_set_fd_block(sock, 0))
+		goto out;
 
 	register_reboot_notifier(&reboot_notifier);
 
@@ -800,7 +802,7 @@ static int __init mconsole_init(void)
 			     "mconsole", (void *)sock);
 	if (err) {
 		printk(KERN_ERR "Failed to get IRQ for management console\n");
-		return 1;
+		goto out;
 	}
 
 	if (notify_socket != NULL) {
@@ -816,6 +818,10 @@ static int __init mconsole_init(void)
 	printk(KERN_INFO "mconsole (version %d) initialized on %s\n",
 	       MCONSOLE_VERSION, mconsole_socket_name);
 	return 0;
+
+ out:
+	os_close_file(sock);
+	return 1;
 }
 
 __initcall(mconsole_init);
