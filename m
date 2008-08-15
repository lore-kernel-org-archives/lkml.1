Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbYHOPZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbYHOPZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbYHOPZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:25:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbYHOPZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:25:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:mime-version:content-type:
	content-transfer-encoding:content-disposition;
	b=InBgQX6yLEXxNrA0t3yx67nPKcTJ+CmvEPSzODUvdeNV4z4N9p4BDWhphkdRdUuMw
	rvPJ+oJKCRaYxSqezPyBg==
Message-ID: <b040c32a0808150825r717353b3kf33de2e239caa26d@mail.gmail.com>
Date: Fri, 15 Aug 2008 08:25:09 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [patch] fix setpriority(PRIO_PGRP) thread iterator breakage.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When user calls sys_setpriority(PRIO_PGRP ...) on a NPTL style multi-LWP
process, only the task leader of the process is affected, all other sibling
LWP threads didn't receive the setting. The problem was that the iterator
used in sys_setpriority() only iteartes over one task for each process,
ignoring all other sibling thread.

Introduce a new macro do_each_pid_thread / while_each_pid_thread to walk
each thread of a process.  Convert 4 call sites in {set/get}priority and
ioprio_{set/get}.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/include/linux/pid.h b/include/linux/pid.h
index c21c7e8..6bea2be 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -163,4 +163,13 @@ pid_t pid_vnr(struct pid *pid);
 			}						\
 	} while (0)

+#define do_each_pid_thread(pid, type, task)				\
+	do_each_pid_task(pid, type, task) {				\
+		struct task_struct *tg___ = task;			\
+		do {
+
+#define while_each_pid_thread(pid, type, task)				\
+		} while_each_thread(tg___, task);			\
+		task = tg___;						\
+	} while_each_pid_task(pid, type, task)
 #endif /* _LINUX_PID_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 14e9728..fc58623 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -169,9 +169,9 @@ asmlinkage long sys_setpriority
 				pgrp = find_vpid(who);
 			else
 				pgrp = task_pgrp(current);
-			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
+			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				error = set_one_prio(p, niceval, error);
-			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
+			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
 			user = current->user;
@@ -229,11 +229,11 @@ asmlinkage long sys_getpriority
 				pgrp = find_vpid(who);
 			else
 				pgrp = task_pgrp(current);
-			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
+			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				niceval = 20 - task_nice(p);
 				if (niceval > retval)
 					retval = niceval;
-			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
+			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
 			user = current->user;
diff --git a/fs/ioprio.c b/fs/ioprio.c
index c4a1c3c..da3cc46 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -115,11 +115,11 @@ asmlinkage long sys_ioprio_set
 				pgrp = task_pgrp(current);
 			else
 				pgrp = find_vpid(who);
-			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
+			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
 					break;
-			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
+			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
@@ -204,7 +204,7 @@ asmlinkage long sys_ioprio_get
 				pgrp = task_pgrp(current);
 			else
 				pgrp = find_vpid(who);
-			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
+			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
 					continue;
@@ -212,7 +212,7 @@ asmlinkage long sys_ioprio_get
 					ret = tmpio;
 				else
 					ret = ioprio_best(ret, tmpio);
-			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
+			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
