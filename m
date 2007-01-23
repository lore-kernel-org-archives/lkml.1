Return-Path: <linux-kernel-owner+w=401wt.eu-S964830AbXAWOmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830AbXAWOmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965147AbXAWOmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:42:35 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:33872 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830AbXAWOmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:42:33 -0500
Message-id: <24033136563168416529@wsc.cz>
In-reply-to: <444432691808225221@wsc.cz>
Subject: [PATCH 2/3] Char: mxser_new, lock count and flags
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <osv@javad.com>
Date: Tue, 23 Jan 2007 15:42:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_new, lock count and flags

Both open count and INITIALIZED flag should be changed under lock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <osv@javad.com>

---
commit 76b3ee2d5737395df62553cec1b8193252476147
tree dfc50c164ddde6b73a954f694dfdcb98ed921629
parent f49b6914c3113f930a31ff7b8f811744f2d8f339
author Jiri Slaby <jirislaby@gmail.com> Sat, 20 Jan 2007 17:18:24 +0059
committer Jiri Slaby <jirislaby@gmail.com> Sat, 20 Jan 2007 17:18:24 +0059

 drivers/char/mxser_new.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 1c8e00c..d52ecff 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -853,9 +853,9 @@ static int mxser_startup(struct mxser_port *info)
 	 * and set the speed of the serial port
 	 */
 	mxser_change_speed(info, NULL);
+	info->flags |= ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&info->slock, flags);
 
-	info->flags |= ASYNC_INITIALIZED;
 	return 0;
 }
 
@@ -925,6 +925,7 @@ static void mxser_shutdown(struct mxser_port *info)
 static int mxser_open(struct tty_struct *tty, struct file *filp)
 {
 	struct mxser_port *info;
+	unsigned long flags;
 	int retval, line;
 
 	line = tty->index;
@@ -941,7 +942,9 @@ static int mxser_open(struct tty_struct *tty, struct file *filp)
 	/*
 	 * Start up serial port
 	 */
+	spin_lock_irqsave(&info->slock, flags);
 	info->count++;
+	spin_unlock_irqrestore(&info->slock, flags);
 	retval = mxser_startup(info);
 	if (retval)
 		return retval;
