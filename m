Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbZKPA1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbZKPA1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZKPA1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:27:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZKPA1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:27:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jeff Dike <jdike@addtoit.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 01/12] arch/um: handle compat_ioctl in tty line driver
Date: Mon, 16 Nov 2009 00:26:56 +0000
Message-Id: <1258331227-1694-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18HXJjPTSdgi6QFfRVYqyE1iRVqirIrgsSBzGN
 vx/3a6q0x0be/0UvZdgIvX2SJHkE5Q5DTiegoU8D4OKpIlp2cp
 fO8GplXvEGnBEro/pgYVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pushes the handling of VT specific ioctls down to the
UML specific drivers so we can remove it from the common
compat_ioctl.c file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: user-mode-linux-user@lists.sourceforge.net
---
 arch/um/drivers/line.c          |    6 ++++++
 arch/um/drivers/ssl.c           |    1 +
 arch/um/drivers/stdio_console.c |    1 +
 arch/um/include/shared/line.h   |    2 ++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index cf8a97f..e819d9b 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -315,6 +315,12 @@ int line_ioctl(struct tty_struct *tty, struct file * file,
 	return ret;
 }
 
+long line_compat_ioctl(struct tty_struct *tty, struct file * file,
+	       unsigned int cmd, unsigned long arg)
+{
+	return line_ioctl(tty, file, cmd, arg);
+}
+
 void line_throttle(struct tty_struct *tty)
 {
 	struct line *line = tty->driver_data;
diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index f1786e6..eccf14a 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -137,6 +137,7 @@ static const struct tty_operations ssl_ops = {
 	.flush_chars 		= line_flush_chars,
 	.set_termios 		= line_set_termios,
 	.ioctl 	 		= line_ioctl,
+	.compat_ioctl 	 	= line_compat_ioctl,
 	.throttle 		= line_throttle,
 	.unthrottle 		= line_unthrottle,
 #if 0
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index 49266f6..2cb1f04 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -120,6 +120,7 @@ static const struct tty_operations console_ops = {
 	.flush_chars 		= line_flush_chars,
 	.set_termios 		= line_set_termios,
 	.ioctl 	 		= line_ioctl,
+	.compat_ioctl 	 	= line_compat_ioctl,
 	.throttle 		= line_throttle,
 	.unthrottle 		= line_unthrottle,
 };
diff --git a/arch/um/include/shared/line.h b/arch/um/include/shared/line.h
index 311a0d3..6ef62e4 100644
--- a/arch/um/include/shared/line.h
+++ b/arch/um/include/shared/line.h
@@ -79,6 +79,8 @@ extern void line_flush_chars(struct tty_struct *tty);
 extern int line_write_room(struct tty_struct *tty);
 extern int line_ioctl(struct tty_struct *tty, struct file * file,
 		      unsigned int cmd, unsigned long arg);
+extern long line_compat_ioctl(struct tty_struct *tty, struct file * file,
+		      unsigned int cmd, unsigned long arg);
 extern void line_throttle(struct tty_struct *tty);
 extern void line_unthrottle(struct tty_struct *tty);
 
-- 
1.6.3.3

