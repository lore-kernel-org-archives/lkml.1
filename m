Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZAMFde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZAMFde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZAMFd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:33:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:62983 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbZAMFdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:33:25 -0500
X-Greylist: delayed 1066 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 00:33:25 EST
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=hrNQ3Wj9m6F4R6NDwd5H+SqPNVBuM90NhxQJ3uXbERl73YFde2vpsJEYtHTJlgnqX
	ud52rP7HBKVRlq3BtKHaA==
Date: Mon, 12 Jan 2009 21:15:17 -0800
From: Mandeep Singh Baines <msb@google.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: [PATCH] softlock: fix false panic which can occur if softlockup_thresh is reduced
Message-ID: <20090113051517.GA27227@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.24.198.77
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At run-time, if softlockup_thresh is changed to a much lower value,
touch_timestamp is likely to be much older than the new softlock_thresh.

This will cause a false softlockup to be detected. If softlockup_panic
is enabled, the system will panic.

The fix is to touch all watchdogs before changing softlockup_thresh.

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 include/linux/sched.h |    3 +++
 kernel/softlockup.c   |    9 +++++++++
 kernel/sysctl.c       |    2 +-
 3 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 55e30d1..cd4a9f6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -295,6 +295,9 @@ extern void sched_show_task(struct task_struct *p);
 extern void softlockup_tick(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
+extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
+				    struct file *filp, void __user *buffer,
+				    size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 extern unsigned long sysctl_hung_task_check_count;
 extern unsigned long sysctl_hung_task_timeout_secs;
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index dc0b3be..2d850e1 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -16,6 +16,7 @@
 #include <linux/lockdep.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/sysctl.h>
 
 #include <asm/irq_regs.h>
 
@@ -88,6 +89,14 @@ void touch_all_softlockup_watchdogs(void)
 }
 EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
 
+int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
+			     struct file *filp, void __user *buffer,
+			     size_t *lenp, loff_t *ppos)
+{
+	touch_all_softlockup_watchdogs();
+	return proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+}
+
 /*
  * This callback runs from the timer interrupt, and checks
  * whether the watchdog thread has hung or not:
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3d56fe7..a3d5828 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -766,7 +766,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &proc_dosoftlockup_thresh,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
-- 
1.5.4.5

