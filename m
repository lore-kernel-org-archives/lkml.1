Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYEOQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYEOQ0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYEOQ0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:26:05 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39328 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbYEOQ0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:26:04 -0400
Date: Thu, 15 May 2008 20:27:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock-simplify
Message-ID: <20080515162703.GA430@tv-sign.ru>
References: <20080512183235.GB6031@joi> <20080513184736.a385ffe2.akpm@linux-foundation.org> <20080514153933.GA122@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514153933.GA122@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Oleg Nesterov wrote:
>
> The patch looks correct anyway, but perhaps tty_check_change() doesn't need
> ->ctrl_lock at all? We don't dereference tty->pgrp.

IOW, I think the patch below makes sense.

With the previous patch tty->ctrl_lock buys nothing, it only protects the
"task_pgrp(current) == tty->pgrp" check, but tty->pgrp can be changed right
after spin_unlock_irqrestore(tty->ctrl_lock) anyway.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- HL/drivers/char/tty_io.c~TTY	2008-05-15 19:09:35.000000000 +0400
+++ HL/drivers/char/tty_io.c	2008-05-15 19:11:57.000000000 +0400
@@ -1199,27 +1199,21 @@ EXPORT_SYMBOL_GPL(tty_find_polling_drive
  *	If we try to write to, or set the state of, a terminal and we're
  *	not in the foreground, send a SIGTTOU.  If the signal is blocked or
  *	ignored, go ahead and perform the operation.  (POSIX 7.2)
- *
- *	Locking: ctrl_lock
  */
 
 int tty_check_change(struct tty_struct *tty)
 {
-	unsigned long flags;
 	int ret = 0;
 
 	if (current->signal->tty != tty)
 		return 0;
 
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-
 	if (!tty->pgrp) {
 		printk(KERN_WARNING "tty_check_change: tty->pgrp == NULL!\n");
-		goto out_unlock;
+		goto out;
 	}
 	if (task_pgrp(current) == tty->pgrp)
-		goto out_unlock;
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		goto out;
 	if (is_ignored(SIGTTOU))
 		goto out;
 	if (is_current_pgrp_orphaned()) {
@@ -1231,9 +1225,6 @@ int tty_check_change(struct tty_struct *
 	ret = -ERESTARTSYS;
 out:
 	return ret;
-out_unlock:
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-	return ret;
 }
 
 EXPORT_SYMBOL(tty_check_change);

