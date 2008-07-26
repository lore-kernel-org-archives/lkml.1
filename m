Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYGZPwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYGZPwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYGZPwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:52:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:6556 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbYGZPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=juBqGsno75SvNZACJ11LPzIGwgf5K8xmF58x/cSu2akjEtM3Uq9R0QzohfQ1+Ck4Zw
         PaJy7LN7ry6P+ugS5A0zC7vevXFwnygSFsMXKhyxjJCv9Rygi0plhskfH8/ayVk+GYxS
         MYblu3Z64zB+T/g0Hq+MmELXUuHHXy4MKafnE=
From: Andrea Righi <righi.andrea@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       balbir@linux.vnet.ibm.com, matt@bluehost.com,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 1/1] task IO accounting: correctly account threads IO statistics
Date: Sat, 26 Jul 2008 17:52:12 +0200
Message-Id: <1217087532-22620-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov points out that we should check that the task is still alive
before we iterate over the threads. This patch includes a fixup for this.

Also simplify do_io_accounting() implementation.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
---
 fs/proc/base.c |   56 ++++++++++++++++++++++----------------------------------
 1 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index a891fe4..346500d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2381,35 +2381,18 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 	u64 rchar, wchar, syscr, syscw;
 	struct task_io_accounting ioac;
 
-	if (!whole) {
-		rchar = task->rchar;
-		wchar = task->wchar;
-		syscr = task->syscr;
-		syscw = task->syscw;
-		memcpy(&ioac, &task->ioac, sizeof(ioac));
-	} else {
-		unsigned long flags;
-		struct task_struct *t = task;
-		rchar = wchar = syscr = syscw = 0;
-		memset(&ioac, 0, sizeof(ioac));
+	rchar = task->rchar;
+	wchar = task->wchar;
+	syscr = task->syscr;
+	syscw = task->syscw;
+	memcpy(&ioac, &task->ioac, sizeof(ioac));
 
-		rcu_read_lock();
-		do {
-			rchar += t->rchar;
-			wchar += t->wchar;
-			syscr += t->syscr;
-			syscw += t->syscw;
-
-			ioac.read_bytes += t->ioac.read_bytes;
-			ioac.write_bytes += t->ioac.write_bytes;
-			ioac.cancelled_write_bytes +=
-					t->ioac.cancelled_write_bytes;
-			t = next_thread(t);
-		} while (t != task);
-		rcu_read_unlock();
+	if (whole) {
+		unsigned long flags;
 
 		if (lock_task_sighand(task, &flags)) {
 			struct signal_struct *sig = task->signal;
+			struct task_struct *t = task;
 
 			rchar += sig->rchar;
 			wchar += sig->wchar;
@@ -2420,11 +2403,20 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 			ioac.write_bytes += sig->ioac.write_bytes;
 			ioac.cancelled_write_bytes +=
 					sig->ioac.cancelled_write_bytes;
-
+			while_each_thread(task, t) {
+				rchar += t->rchar;
+				wchar += t->wchar;
+				syscr += t->syscr;
+				syscw += t->syscw;
+
+				ioac.read_bytes += t->ioac.read_bytes;
+				ioac.write_bytes += t->ioac.write_bytes;
+				ioac.cancelled_write_bytes +=
+					t->ioac.cancelled_write_bytes;
+			}
 			unlock_task_sighand(task, &flags);
 		}
 	}
-
 	return sprintf(buffer,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
@@ -2433,13 +2425,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
-			(unsigned long long)rchar,
-			(unsigned long long)wchar,
-			(unsigned long long)syscr,
-			(unsigned long long)syscw,
-			(unsigned long long)ioac.read_bytes,
-			(unsigned long long)ioac.write_bytes,
-			(unsigned long long)ioac.cancelled_write_bytes);
+			rchar, wchar, syscr, syscw,
+			ioac.read_bytes, ioac.write_bytes,
+			ioac.cancelled_write_bytes);
 }
 
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
-- 
1.5.4.3

