Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZLRBT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZLRBT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZLRBRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:17:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbZLRBR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:17:29 -0500
Date: Fri, 18 Dec 2009 02:11:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: [PATCH 1/7] tracehooks: kill some PT_PTRACED checks
Message-ID: <20091218011120.GA29538@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation for utrace-ptrace.

task_ptrace() != 0 if and only if PT_PTRACED bit is set, kill
some PT_PTRACED checks in tracehook.h to ensure the result is
the same with or without utrace which doesn't set PT_PTRACED.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/tracehook.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- V1/include/linux/tracehook.h~1_TRACEHOOK_KILL_PTRACED_CHECKS	2009-12-18 00:20:50.000000000 +0100
+++ V1/include/linux/tracehook.h	2009-12-18 00:38:09.000000000 +0100
@@ -156,7 +156,7 @@ static inline int tracehook_unsafe_exec(
 {
 	int unsafe = 0;
 	int ptrace = task_ptrace(task);
-	if (ptrace & PT_PTRACED) {
+	if (ptrace) {
 		if (ptrace & PT_PTRACE_CAP)
 			unsafe |= LSM_UNSAFE_PTRACE_CAP;
 		else
@@ -178,7 +178,7 @@ static inline int tracehook_unsafe_exec(
  */
 static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
 {
-	if (task_ptrace(tsk) & PT_PTRACED)
+	if (task_ptrace(tsk))
 		return rcu_dereference(tsk->parent);
 	return NULL;
 }
@@ -492,7 +492,7 @@ static inline int tracehook_get_signal(s
  */
 static inline int tracehook_notify_jctl(int notify, int why)
 {
-	return notify ?: (current->ptrace & PT_PTRACED) ? why : 0;
+	return notify ?: task_ptrace(current) ? why : 0;
 }
 
 /**

