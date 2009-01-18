Return-Path: <linux-kernel-owner+w=401wt.eu-S934369AbZARRTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934369AbZARRTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761394AbZARRTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:19:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60582 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760946AbZARRTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:19:32 -0500
Date: Sun, 18 Jan 2009 18:17:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: arve@android.com, gregkh@suse.de, jrm8005@gmail.com, rlove@google.com,
       swetland@google.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] android: task_get_unused_fd_flags: fix the wrong usage of
	tsk->signal
Message-ID: <20090118171720.GA18374@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile tested.

task_struct->signal is not protected by RCU, the code is bogus.
Change the code to take ->siglock to pin ->signal.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- CUR/drivers/staging/android/binder.c~ANDROID	2009-01-12 23:07:43.000000000 +0100
+++ CUR/drivers/staging/android/binder.c	2009-01-18 18:06:12.000000000 +0100
@@ -319,6 +319,7 @@ int task_get_unused_fd_flags(struct task
 	int fd, error;
 	struct fdtable *fdt;
 	unsigned long rlim_cur;
+	unsigned long irqs;
 
 	if (files == NULL)
 		return -ESRCH;
@@ -335,12 +336,11 @@ repeat:
 	 * N.B. For clone tasks sharing a files structure, this test
 	 * will limit the total number of files that can be opened.
 	 */
-	rcu_read_lock();
-	if (tsk->signal)
+	rlim_cur = 0;
+	if (lock_task_sighand(tsk, &irqs)) {
 		rlim_cur = tsk->signal->rlim[RLIMIT_NOFILE].rlim_cur;
-	else
-		rlim_cur = 0;
-	rcu_read_unlock();
+		unlock_task_sighand(tsk, &irqs);
+	}
 	if (fd >= rlim_cur)
 		goto out;
 

