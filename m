Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbYCGKiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbYCGKiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYCGKiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:38:17 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:40459 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbYCGKiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:38:17 -0500
Date: Fri, 7 Mar 2008 13:37:20 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: send_sig_info: don't take tasklist_lock
Message-ID: <20080307103720.GA9501@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment in send_sig_info() is wrong, tasklist_lock can't help.

The caller must ensure the task can't go away, otherwise ->sighand can be NULL
even before we take the lock.

p->sighand could be changed by exec(), but I can't imagine how it is possible
to prevent exit(), but not exec().

Since the things seem to work, I assume all callers are correct. However,
drm_vbl_send_signals() looks broken. block_all_signals() which is solely used
by drm is definitely broken.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~3_SSI_NO_TASKLIST	2008-03-07 12:20:34.000000000 +0300
+++ 25/kernel/signal.c	2008-03-07 13:06:17.000000000 +0300
@@ -1138,8 +1138,7 @@ static int kill_something_info(int sig, 
  */
 
 /*
- * These two are the most common entry points.  They send a signal
- * just to the specific thread.
+ * The caller must ensure the task can't exit.
  */
 int
 send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
@@ -1154,17 +1153,9 @@ send_sig_info(int sig, struct siginfo *i
 	if (!valid_signal(sig))
 		return -EINVAL;
 
-	/*
-	 * We need the tasklist lock even for the specific
-	 * thread case (when we don't need to follow the group
-	 * lists) in order to avoid races with "p->sighand"
-	 * going away or changing from under us.
-	 */
-	read_lock(&tasklist_lock);  
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 	ret = specific_send_sig_info(sig, info, p);
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	read_unlock(&tasklist_lock);
 	return ret;
 }
 

