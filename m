Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbXFNU2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbXFNU2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbXFNU1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:27:19 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34108 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbXFNU1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:27:18 -0400
Date: Thu, 14 Jun 2007 16:26:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/5] UML - handle errors on opening host side of consoles
Message-ID: <20070614202649.GA9635@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the host side of a console can't be opened, this will now produce
visible error messages.

enable_chan now returns a status and this is passed up to con_open and
ssl_open, which will complain if anything went wrong.

The default host device for the serial line driver is now a pts device
rather than a pty device since lots of hosts have LEGACY_PTYS
disabled.  This had always been failing on such hosts, but silently.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/defconfig               |    2 +-
 arch/um/drivers/chan_kern.c     |   23 +++++++++++++++++++----
 arch/um/drivers/line.c          |    5 ++++-
 arch/um/drivers/ssl.c           |    8 +++++++-
 arch/um/drivers/stdio_console.c |    7 ++++++-
 arch/um/include/chan_kern.h     |    2 +-
 6 files changed, 38 insertions(+), 9 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/chan_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/chan_kern.c	2007-06-14 15:40:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/chan_kern.c	2007-06-14 16:00:23.000000000 -0400
@@ -203,22 +203,37 @@ void chan_enable_winch(struct list_head 
 	}
 }
 
-void enable_chan(struct line *line)
+int enable_chan(struct line *line)
 {
 	struct list_head *ele;
 	struct chan *chan;
+	int err;
 
 	list_for_each(ele, &line->chan_list){
 		chan = list_entry(ele, struct chan, list);
-		if(open_one_chan(chan))
+		err = open_one_chan(chan);
+		if (err) {
+			if (chan->primary)
+				goto out_close;
+
 			continue;
+		}
 
 		if(chan->enabled)
 			continue;
-		line_setup_irq(chan->fd, chan->input, chan->output, line,
-			       chan);
+		err = line_setup_irq(chan->fd, chan->input, chan->output, line,
+				     chan);
+		if (err)
+			goto out_close;
+
 		chan->enabled = 1;
 	}
+
+	return 0;
+
+ out_close:
+	close_chan(&line->chan_list, 0);
+	return err;
 }
 
 /* Items are added in IRQ context, when free_irq can't be called, and
Index: linux-2.6.21-mm/arch/um/drivers/line.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/line.c	2007-06-14 15:40:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/line.c	2007-06-14 16:00:23.000000000 -0400
@@ -454,7 +454,10 @@ int line_open(struct line *lines, struct
 	tty->driver_data = line;
 	line->tty = tty;
 
-	enable_chan(line);
+	err = enable_chan(line);
+	if (err)
+		return err;
+
 	INIT_DELAYED_WORK(&line->task, line_timer_cb);
 
 	if(!line->sigio){
Index: linux-2.6.21-mm/arch/um/drivers/ssl.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ssl.c	2007-06-14 15:40:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ssl.c	2007-06-14 16:00:23.000000000 -0400
@@ -97,7 +97,13 @@ static int ssl_remove(int n, char **erro
 
 static int ssl_open(struct tty_struct *tty, struct file *filp)
 {
-	return line_open(serial_lines, tty);
+	int err = line_open(serial_lines, tty);
+
+	if (err)
+		printk(KERN_ERR "Failed to open serial line %d, err = %d\n",
+		       tty->index, err);
+
+	return err;
 }
 
 #if 0
Index: linux-2.6.21-mm/arch/um/drivers/stdio_console.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/stdio_console.c	2007-06-14 15:40:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/stdio_console.c	2007-06-14 16:00:23.000000000 -0400
@@ -99,7 +99,12 @@ static int con_remove(int n, char **erro
 
 static int con_open(struct tty_struct *tty, struct file *filp)
 {
-	return line_open(vts, tty);
+	int err = line_open(vts, tty);
+	if (err)
+		printk(KERN_ERR "Failed to open console %d, err = %d\n",
+		       tty->index, err);
+
+	return err;
 }
 
 /* Set in an initcall, checked in an exitcall */
Index: linux-2.6.21-mm/arch/um/include/chan_kern.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/chan_kern.h	2007-06-14 15:40:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/chan_kern.h	2007-06-14 16:00:23.000000000 -0400
@@ -40,7 +40,7 @@ extern int console_open_chan(struct line
 extern void deactivate_chan(struct list_head *chans, int irq);
 extern void reactivate_chan(struct list_head *chans, int irq);
 extern void chan_enable_winch(struct list_head *chans, struct tty_struct *tty);
-extern void enable_chan(struct line *line);
+extern int enable_chan(struct line *line);
 extern void close_chan(struct list_head *chans, int delay_free_irq);
 extern int chan_window_size(struct list_head *chans, 
 			     unsigned short *rows_out, 
Index: linux-2.6.21-mm/arch/um/defconfig
===================================================================
--- linux-2.6.21-mm.orig/arch/um/defconfig	2007-06-14 15:40:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/defconfig	2007-06-14 16:00:23.000000000 -0400
@@ -189,7 +189,7 @@ CONFIG_XTERM_CHAN=y
 # CONFIG_NOCONFIG_CHAN is not set
 CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
 CONFIG_CON_CHAN="xterm"
-CONFIG_SSL_CHAN="pty"
+CONFIG_SSL_CHAN="pts"
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
