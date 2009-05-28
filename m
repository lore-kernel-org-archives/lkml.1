Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbZE1IZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbZE1IZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZE1IZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:25:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45070 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbZE1IZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:25:26 -0400
Date: Thu, 28 May 2009 10:21:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: don't take tasklist to get/set ->last_siginfo
Message-ID: <20090528082113.GA9062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ptrace_getsiginfo/ptrace_setsiginfo to use lock_task_sighand()
without tasklist_lock. Perhaps it makes sense to make a singler helper
with "bool rw" argument.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/ptrace.c~SIGINFO	2009-05-28 10:03:01.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-28 10:06:59.000000000 +0200
@@ -463,37 +463,33 @@ static int ptrace_setoptions
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 {
+	unsigned long flags;
 	int error = -ESRCH;
 
-	read_lock(&tasklist_lock);
-	if (likely(child->sighand != NULL)) {
+	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		spin_lock_irq(&child->sighand->siglock);
 		if (likely(child->last_siginfo != NULL)) {
 			*info = *child->last_siginfo;
 			error = 0;
 		}
-		spin_unlock_irq(&child->sighand->siglock);
+		unlock_task_sighand(child, &flags);
 	}
-	read_unlock(&tasklist_lock);
 	return error;
 }
 
 static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 {
+	unsigned long flags;
 	int error = -ESRCH;
 
-	read_lock(&tasklist_lock);
-	if (likely(child->sighand != NULL)) {
+	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		spin_lock_irq(&child->sighand->siglock);
 		if (likely(child->last_siginfo != NULL)) {
 			*child->last_siginfo = *info;
 			error = 0;
 		}
-		spin_unlock_irq(&child->sighand->siglock);
+		unlock_task_sighand(child, &flags);
 	}
-	read_unlock(&tasklist_lock);
 	return error;
 }
 

