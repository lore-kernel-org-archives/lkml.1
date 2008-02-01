Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbYBANgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbYBANgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbYBANfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:35:42 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57837 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269AbYBANfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:35:41 -0500
Date: Fri, 1 Feb 2008 16:38:00 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] compat_sys_nanosleep: fix *rmtp/restarts handling
Message-ID: <20080201133800.GA25626@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

COMPLETELY UNTESTED.

Spotted by Pavel Emelyanov and Alexey Dobriyan.

compat_sys_nanosleep() implicitly uses hrtimer_nanosleep_restart(), this can't
work. Make a suitable compat_nanosleep_restart() helper.

Also, set ->addr_limit = KERNEL_DS before doing hrtimer_nanosleep(), this func
was changed by the previous patch and now takes the "__user *" parameter.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/kernel/compat.c~3_COMPAT_NANOSLEEP	2008-02-01 14:27:16.000000000 +0300
+++ MM/kernel/compat.c	2008-02-01 14:50:01.000000000 +0300
@@ -40,10 +40,37 @@ int put_compat_timespec(const struct tim
 			__put_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
 
+static long compat_nanosleep_restart(struct restart_block *restart)
+{
+	long err;
+	mm_segment_t oldfs;
+	struct timespec tu;
+	struct compat_timespec *rmtp = (struct compat_timespec *)(restart->arg1);
+
+	restart->arg1 = (unsigned long)&tu;
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	err = hrtimer_nanosleep_restart(restart);
+	set_fs(oldfs);
+
+	if (err) {
+		if (rmtp && put_compat_timespec(&tu, rmtp))
+			return -EFAULT;
+
+		if (err == -ERESTART_RESTARTBLOCK) {
+			restart->fn = compat_nanosleep_restart;
+			restart->arg1 = (unsigned long)rmtp;
+		}
+	}
+
+	return err;
+}
+
 asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
 				     struct compat_timespec __user *rmtp)
 {
 	struct timespec tu, rmt;
+	mm_segment_t oldfs;
 	long ret;
 
 	if (get_compat_timespec(&tu, rqtp))
@@ -52,12 +79,23 @@ asmlinkage long compat_sys_nanosleep(str
 	if (!timespec_valid(&tu))
 		return -EINVAL;
 
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
 	ret = hrtimer_nanosleep(&tu, rmtp ? &rmt : NULL, HRTIMER_MODE_REL,
 				CLOCK_MONOTONIC);
+	set_fs(oldfs);
 
-	if (ret && rmtp) {
-		if (put_compat_timespec(&rmt, rmtp))
+	if (ret) {
+		if (rmtp && put_compat_timespec(&rmt, rmtp))
 			return -EFAULT;
+
+		if (err == -ERESTART_RESTARTBLOCK) {
+			struct restart_block *restart
+				= &current_thread_info()->restart_block;
+
+			restart->fn = compat_nanosleep_restart;
+			restart->arg1 = (unsigned long)rmtp;
+		}
 	}
 
 	return ret;

