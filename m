Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659Ab0AJIwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab0AJIwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 03:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417Ab0AJIwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 03:52:08 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:54931 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0AJIwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 03:52:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/1] Char: synclink, fix potential null dereference
Date: Sun, 10 Jan 2010 09:51:58 +0100
Message-Id: <1263113518-6377-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a potential null dereference in mgsl_put_char and
mgsl_write. There is a check for tty being NULL, but it is
dereferenced earlier. Move the dereference after the check.

Also reorder mgsl_paranoia_check so that it makes sense:
* check !tty
* deref tty
* check !info
* deref info

And don't jump to cleanup label in mgsl_write's two cases, return
immediately, since there is an info dereference as well.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/synclink.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 4846b73..30f21bd 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -2019,19 +2019,24 @@ static void mgsl_change_params(struct mgsl_struct *info)
  */
 static int mgsl_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	struct mgsl_struct *info = tty->driver_data;
+	struct mgsl_struct *info;
 	unsigned long flags;
 	int ret = 0;
 
+	if (!tty)
+		return 0;
+
+	info = tty->driver_data;
+
+	if (mgsl_paranoia_check(info, tty->name, "mgsl_put_char"))
+		return 0;
+
 	if (debug_level >= DEBUG_LEVEL_INFO) {
 		printk(KERN_DEBUG "%s(%d):mgsl_put_char(%d) on %s\n",
 			__FILE__, __LINE__, ch, info->device_name);
 	}		
 	
-	if (mgsl_paranoia_check(info, tty->name, "mgsl_put_char"))
-		return 0;
-
-	if (!tty || !info->xmit_buf)
+	if (!info->xmit_buf)
 		return 0;
 
 	spin_lock_irqsave(&info->irq_spinlock, flags);
@@ -2111,17 +2116,22 @@ static int mgsl_write(struct tty_struct * tty,
 		    const unsigned char *buf, int count)
 {
 	int	c, ret = 0;
-	struct mgsl_struct *info = tty->driver_data;
+	struct mgsl_struct *info;
 	unsigned long flags;
 	
+	if (!tty)
+		return 0;
+
+	info = tty->driver_data;
+
+	if (mgsl_paranoia_check(info, tty->name, "mgsl_write"))
+		return 0;
+
 	if ( debug_level >= DEBUG_LEVEL_INFO )
 		printk( "%s(%d):mgsl_write(%s) count=%d\n",
 			__FILE__,__LINE__,info->device_name,count);
-	
-	if (mgsl_paranoia_check(info, tty->name, "mgsl_write"))
-		goto cleanup;
 
-	if (!tty || !info->xmit_buf)
+	if (!info->xmit_buf)
 		goto cleanup;
 
 	if ( info->params.mode == MGSL_MODE_HDLC ||
-- 
1.6.5.7

