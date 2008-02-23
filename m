Return-Path: <linux-kernel-owner+w=401wt.eu-S936476AbYBWAqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936476AbYBWAqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935314AbYBWAfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:35:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:55648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935308AbYBWAfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:35:33 -0500
Date: Fri, 22 Feb 2008 16:31:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@tv-sign.ru>, Alexey Dobriyan <adobriyan@sw.ru>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 26/38] hrtimer: fix *rmtp/restarts handling in
	compat_sys_nanosleep()
Message-ID: <20080223003111.GA7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hrtimer-fix-rmtp-restarts-handling-in-compat_sys_nanosleep.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Oleg Nesterov <oleg@tv-sign.ru>

commit 416529374b4793ba2d2e97e736d108a2e0f3ef07

Spotted by Pavel Emelyanov and Alexey Dobriyan.

compat_sys_nanosleep() implicitly uses hrtimer_nanosleep_restart(), this can't
work. Make a suitable compat_nanosleep_restart() helper.

Introduced by commit c70878b4e0b6cf8d2f1e46319e48e821ef4a8aba
hrtimer: hook compat_sys_nanosleep up to high res timer code

Also, set ->addr_limit = KERNEL_DS before doing hrtimer_nanosleep(), this func
was changed by the previous patch and now takes the "__user *" parameter.

Thanks to Ingo Molnar for fixing the bug in this patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Pavel Emelyanov <xemul@sw.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Toyo Abe <toyoa@mvista.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/compat.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -40,10 +40,36 @@ int put_compat_timespec(const struct tim
 			__put_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
 
+static long compat_nanosleep_restart(struct restart_block *restart)
+{
+	struct compat_timespec __user *rmtp;
+	struct timespec rmt;
+	mm_segment_t oldfs;
+	long ret;
+
+	rmtp = (struct compat_timespec __user *)(restart->arg1);
+	restart->arg1 = (unsigned long)&rmt;
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	ret = hrtimer_nanosleep_restart(restart);
+	set_fs(oldfs);
+
+	if (ret) {
+		restart->fn = compat_nanosleep_restart;
+		restart->arg1 = (unsigned long)rmtp;
+
+		if (rmtp && put_compat_timespec(&rmt, rmtp))
+			return -EFAULT;
+	}
+
+	return ret;
+}
+
 asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
 				     struct compat_timespec __user *rmtp)
 {
 	struct timespec tu, rmt;
+	mm_segment_t oldfs;
 	long ret;
 
 	if (get_compat_timespec(&tu, rqtp))
@@ -52,11 +78,21 @@ asmlinkage long compat_sys_nanosleep(str
 	if (!timespec_valid(&tu))
 		return -EINVAL;
 
-	ret = hrtimer_nanosleep(&tu, rmtp ? &rmt : NULL, HRTIMER_MODE_REL,
-				CLOCK_MONOTONIC);
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	ret = hrtimer_nanosleep(&tu,
+				rmtp ? (struct timespec __user *)&rmt : NULL,
+				HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	set_fs(oldfs);
+
+	if (ret) {
+		struct restart_block *restart
+			= &current_thread_info()->restart_block;
+
+		restart->fn = compat_nanosleep_restart;
+		restart->arg1 = (unsigned long)rmtp;
 
-	if (ret && rmtp) {
-		if (put_compat_timespec(&rmt, rmtp))
+		if (rmtp && put_compat_timespec(&rmt, rmtp))
 			return -EFAULT;
 	}
 

-- 
