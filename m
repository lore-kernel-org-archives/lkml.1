Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbZJCBX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbZJCBX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 21:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZJCBX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 21:23:28 -0400
Received: from dovecot.org ([82.118.211.50]:57524 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZJCBX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 21:23:28 -0400
Subject: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 02 Oct 2009 17:23:22 -0400
Message-Id: <1254518602.5050.4.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PR_SET_PROCTITLE_AREA updates mm_struct->arg_start and arg_end to the
given pointers, which makes it possible for user space to implement
setproctitle(3) cleanly.


Signed-off-by: Timo Sirainen <tss@iki.fi>
---
 fs/proc/base.c        |    9 ++++++---
 include/linux/prctl.h |    2 ++
 kernel/sys.c          |   10 ++++++++++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 837469a..43ef276 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -267,9 +267,12 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
  
 	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
 
-	// If the nul at the end of args has been overwritten, then
-	// assume application is using setproctitle(3).
-	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
+	if (mm->arg_end != mm->env_start) {
+		// PR_SET_PROCTITLE_AREA used
+		res = strnlen(buffer, res);
+	} else if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
+		// If the nul at the end of args has been overwritten, then
+		// assume application is using old style setproctitle(3).
 		len = strnlen(buffer, res);
 		if (len < res) {
 		    res = len;
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 9311505..c79ccc8 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -90,4 +90,6 @@
 
 #define PR_MCE_KILL	33
 
+#define PR_SET_PROCTITLE_AREA 34	/* Set process title memory area */
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 255475d..c216ae6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1564,6 +1564,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = 0;
 			break;
 
+		case PR_SET_PROCTITLE_AREA: {
+			struct mm_struct *mm = current->mm;
+
+			if (arg2 >= arg3)
+				return -EINVAL;
+
+			mm->arg_start = arg2;
+			mm->arg_end = arg3;
+			return 0;
+		}
 		default:
 			error = -EINVAL;
 			break;
-- 
1.6.3.3


