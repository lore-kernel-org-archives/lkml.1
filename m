Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZHFNKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZHFNKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZHFNKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:10:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbZHFNKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:10:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/5] s390: move keyboard compat ioctls into tty3270 driver
Date: Thu,  6 Aug 2009 15:09:27 +0200
Message-Id: <1249564170-18627-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249564170-18627-1-git-send-email-arnd@arndb.de>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Hc64IRi7LHrEQmQzxiDtmNL4uKH1RROcVHZr
 WQrR0tKG363LJmUwQACfwWCpN9rpbBJtGQPJkjZ8qGP+KFVcdE
 4/J0vznPYoZHjcz/SL8EA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All keyboard ioctls are compatible, so we can simply
move the compat handling into the vt and tty3270 drivers.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/s390/char/tty3270.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 3838567..86b2889 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1731,6 +1731,22 @@ tty3270_ioctl(struct tty_struct *tty, struct file *file,
 	return kbd_ioctl(tp->kbd, file, cmd, arg);
 }
 
+#ifdef CONFIG_COMPAT
+static long
+tty3270_compat_ioctl(struct tty_struct *tty, struct file *file,
+	      unsigned int cmd, unsigned long arg)
+{
+	struct tty3270 *tp;
+
+	tp = tty->driver_data;
+	if (!tp)
+		return -ENODEV;
+	if (tty->flags & (1 << TTY_IO_ERROR))
+		return -EIO;
+	return kbd_ioctl(tp->kbd, file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static const struct tty_operations tty3270_ops = {
 	.open = tty3270_open,
 	.close = tty3270_close,
@@ -1745,6 +1761,9 @@ static const struct tty_operations tty3270_ops = {
 	.hangup = tty3270_hangup,
 	.wait_until_sent = tty3270_wait_until_sent,
 	.ioctl = tty3270_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = tty3270_compat_ioctl,
+#endif
 	.set_termios = tty3270_set_termios
 };
 
-- 
1.6.3.3

