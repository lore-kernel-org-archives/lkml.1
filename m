Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYBAOJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYBAOJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYBAOJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:09:24 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42144 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbYBAOJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:09:23 -0500
Date: Fri, 1 Feb 2008 17:12:00 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Alexey Dobriyan <adobriyan@sw.ru>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] compat_sys_nanosleep: fix *rmtp/restarts handling
Message-ID: <20080201141200.GA25656@tv-sign.ru>
References: <20080201133800.GA25626@tv-sign.ru> <20080201134649.GA15872@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201134649.GA15872@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > COMPLETELY UNTESTED.
> 
> FYI, build failure on x86/64:
> 
>  kernel/compat.c: In function 'compat_sys_nanosleep':
>  kernel/compat.c:90: error: 'err' undeclared (first use in this function)
>  kernel/compat.c:90: error: (Each undeclared identifier is reported only once
>  kernel/compat.c:90: error: for each function it appears in.)

Oh, thanks a lot!

Hopefully this was the last bug, updated patch below.


[PATCH 3/5] compat_sys_nanosleep: fix *rmtp/restarts handling

COMPLETELY UNTESTED.

Spotted by Pavel Emelyanov and Alexey Dobriyan.

compat_sys_nanosleep() implicitly uses hrtimer_nanosleep_restart(), this can't
work. Make a suitable compat_nanosleep_restart() helper.

Also, set ->addr_limit = KERNEL_DS before doing hrtimer_nanosleep(), this func
was changed by the previous patch and now takes the "__user *" parameter.

Thanks to Ingo Molnar for fixing the bug in this patch.

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
+		if (ret == -ERESTART_RESTARTBLOCK) {
+			struct restart_block *restart
+				= &current_thread_info()->restart_block;
+
+			restart->fn = compat_nanosleep_restart;
+			restart->arg1 = (unsigned long)rmtp;
+		}
 	}
 
 	return ret;

