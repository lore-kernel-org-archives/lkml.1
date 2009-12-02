Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbZLBGcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbZLBGcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZLBGcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:32:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47266 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbZLBGcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:32:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fMZOcSWHsX7mHtJ23+uUKYiI5Ul21AE5UXkfw4HwVZsD+9jC4Icn9Ud9ifXUkSq9L1
         96sNGb0nF26OF+nvJ2rfdFiMaDhOEOnhK2a7pck1acSmGV7Q8IUBKhPWYSd9QDaPZE39
         1yfq1mANe9eDIYxhTaVv9aXxtbfQwQcxBaQJc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [PATCH] hw-breakpoints: Keep track of user disabled breakpoints
Date: Wed,  2 Dec 2009 07:32:16 +0100
Message-Id: <1259735536-9236-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we disable a breakpoint through dr7, we unregister it right
away, making us losing track of its corresponding address register
value.

It means that the following sequence would be unsupported:

- set address in dr0
- enable it through dr7
- disable it through dr7
- enable it through dr7

because we lost the address register value when we disabled the
breakpoint.

Don't unregister the disabled breakpoints but rather disable them.

Reported-by: "K.Prasad" <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 2941b32..04d182a 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -595,7 +595,7 @@ static unsigned long ptrace_get_dr7(struct perf_event *bp[])
 
 static struct perf_event *
 ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
-			 struct task_struct *tsk)
+			 struct task_struct *tsk, int disabled)
 {
 	int err;
 	int gen_len, gen_type;
@@ -616,7 +616,7 @@ ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
 	attr = bp->attr;
 	attr.bp_len = gen_len;
 	attr.bp_type = gen_type;
-	attr.disabled = 0;
+	attr.disabled = disabled;
 
 	return modify_user_hw_breakpoint(bp, &attr, bp->callback, tsk);
 }
@@ -655,13 +655,21 @@ restore:
 				 */
 				if (!second_pass)
 					continue;
+
 				thread->ptrace_bps[i] = NULL;
-				unregister_hw_breakpoint(bp);
+				bp = ptrace_modify_breakpoint(bp, len, type,
+							      tsk, 1);
+				if (IS_ERR(bp)) {
+					rc = PTR_ERR(bp);
+					thread->ptrace_bps[i] = NULL;
+					break;
+				}
+				thread->ptrace_bps[i] = bp;
 			}
 			continue;
 		}
 
-		bp = ptrace_modify_breakpoint(bp, len, type, tsk);
+		bp = ptrace_modify_breakpoint(bp, len, type, tsk, 0);
 
 		/* Incorrect bp, or we have a bug in bp API */
 		if (IS_ERR(bp)) {
-- 
1.6.2.3

