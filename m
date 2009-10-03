Return-Path: <linux-kernel-owner+w=401wt.eu-S1750945AbZJCEHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbZJCEHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 00:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZJCEHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 00:07:17 -0400
Received: from dovecot.org ([82.118.211.50]:47683 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZJCEHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 00:07:17 -0400
Subject: [PATCH] proc/pid/cmdline: Handle invalid cmdline change failures
 correctly.
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 03 Oct 2009 00:07:12 -0400
Message-Id: <1254542832.5405.6.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle access_process_vm() failures correctly in /proc/pid/cmdline.
This bug might have leaked kernel memory to userspace.

Signed-off-by: Timo Sirainen <tss@iki.fi>
---
 fs/proc/base.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 837469a..f66cc4c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -252,7 +252,7 @@ struct mm_struct *mm_for_maps(struct task_struct *task)
 
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 {
-	int res = 0;
+	int res = 0, res2;
 	unsigned int len;
 	struct mm_struct *mm = get_task_mm(task);
 	if (!mm)
@@ -277,8 +277,9 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 			len = mm->env_end - mm->env_start;
 			if (len > PAGE_SIZE - res)
 				len = PAGE_SIZE - res;
-			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
-			res = strnlen(buffer, res);
+			res2 = access_process_vm(task, mm->env_start, buffer+res, len, 0);
+			if (res2 > 0)
+				res = strnlen(buffer, res + res2);
 		}
 	}
 out_mm:
-- 
1.6.3.3


