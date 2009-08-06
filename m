Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZHFNKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZHFNKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZHFNKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:10:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbZHFNKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:10:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 1/5] arch/um: handle compat_ioctl in tty line driver
Date: Thu,  6 Aug 2009 15:09:26 +0200
Message-Id: <1249564170-18627-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249564170-18627-1-git-send-email-arnd@arndb.de>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+IG1yNLZp2lyGXMmymOUr8ehb0RrpMt3lRaSR
 za65AebzPwqJeOqGmiHdqt0sDi/BN0Qad7thUiT89VUui8J/Ia
 D8Ay0MeE+qQ5qPuexFQBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pushes the handling of VT specific ioctls down to the
UML specific drivers so we can remove it from the common
compat_ioctl.c file.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/um/drivers/line.c          |    6 ++++++
 arch/um/drivers/ssl.c           |    1 +
 arch/um/drivers/stdio_console.c |    1 +
 arch/um/include/shared/line.h   |    2 ++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 14a102e..9819a3b 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -314,6 +314,12 @@ int line_ioctl(struct tty_struct *tty, struct file * file,
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

