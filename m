Return-Path: <linux-kernel-owner+w=401wt.eu-S933776AbYBONvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbYBONvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbYBONu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:50:58 -0500
Received: from ag-out-0708.google.com ([72.14.246.242]:26948 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761049AbYBONu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=T8d8/OSB4z/0LypMWtLtk1xxCdKCaZKVeCrDqW2k2eIfYns+uYznQYvyHVpLq0/tqX5aL3+M0uUdjRgWZQ3ZZAZKuWW2L29S8eJQN2Rq2j6rdDTyg1mT36y7OMA7YS96Px//SGJQMlbifX4ojguua7pUZYdui/epcro928GIGE0=
Date: Fri, 15 Feb 2008 21:46:31 +0800 (CST)
Message-Id: <20080215.214631.169269331.xiyou.wangcong@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, tglx@linutronix.de
Subject: [Patch] Fix shadowed variables in kernel/posix-cpu-timers.c
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix sparse warnings like this:
kernel/posix-cpu-timers.c:1090:25: warning: symbol 't' shadows an earlier one
kernel/posix-cpu-timers.c:1058:21: originally declared here

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>

---
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 2eae91f..ae5c6c1 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1087,45 +1087,45 @@ static void check_process_timers(struct task_struct *tsk,
 	maxfire = 20;
 	prof_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
+		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(ptime, t->expires.cpu)) {
-			prof_expires = t->expires.cpu;
+		if (!--maxfire || cputime_lt(ptime, tl->expires.cpu)) {
+			prof_expires = tl->expires.cpu;
 			break;
 		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
+		tl->firing = 1;
+		list_move_tail(&tl->entry, firing);
 	}
 
 	++timers;
 	maxfire = 20;
 	virt_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
+		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(utime, t->expires.cpu)) {
-			virt_expires = t->expires.cpu;
+		if (!--maxfire || cputime_lt(utime, tl->expires.cpu)) {
+			virt_expires = tl->expires.cpu;
 			break;
 		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
+		tl->firing = 1;
+		list_move_tail(&tl->entry, firing);
 	}
 
 	++timers;
 	maxfire = 20;
 	sched_expires = 0;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
+		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || sum_sched_runtime < t->expires.sched) {
-			sched_expires = t->expires.sched;
+		if (!--maxfire || sum_sched_runtime < tl->expires.sched) {
+			sched_expires = tl->expires.sched;
 			break;
 		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
+		tl->firing = 1;
+		list_move_tail(&tl->entry, firing);
 	}
 
 	/*
