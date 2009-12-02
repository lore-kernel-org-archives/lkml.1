Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZLBKoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZLBKoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZLBKoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:44:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:44911 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbZLBKoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:44:13 -0500
Date: Wed, 2 Dec 2009 10:43:17 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <1259735536-9236-1-git-send-regression-fweisbec@gmail.com>
References: <1259735536-9236-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Keep track of user disabled breakpoints
Message-ID: <tip-1cedae72904b85462082dbcfd5190309ba37f8bd@git.kernel.org>
Git-Commit-ID: 1cedae72904b85462082dbcfd5190309ba37f8bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1cedae72904b85462082dbcfd5190309ba37f8bd
Gitweb:     http://git.kernel.org/tip/1cedae72904b85462082dbcfd5190309ba37f8bd
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 2 Dec 2009 07:32:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 09:59:03 +0100

hw-breakpoints: Keep track of user disabled breakpoints

When we disable a breakpoint through dr7, we unregister it right
away, making us lose track of its corresponding address
register value.

It means that the following sequence would be unsupported:

 - set address in dr0
 - enable it through dr7
 - disable it through dr7
 - enable it through dr7

because we lost the address register value when we disabled the
breakpoint.

Don't unregister the disabled breakpoints but rather disable
them.

Reported-by: "K.Prasad" <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1259735536-9236-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
