Return-Path: <linux-kernel-owner+w=401wt.eu-S933335AbZKXUMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335AbZKXUMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933131AbZKXUMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:12:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119AbZKXUM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:12:29 -0500
Date: Tue, 24 Nov 2009 21:01:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: [RFC,PATCH 08/14] tracehooks: kill some PT_PTRACED checks
Message-ID: <20091124200156.GA5793@redhat.com>
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

--- V1/include/linux/tracehook.h~8_TRACEHOOK_KILL_PTRACED_CHECKS	2009-11-24 19:52:10.000000000 +0100
+++ V1/include/linux/tracehook.h	2009-11-24 20:29:07.000000000 +0100
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

