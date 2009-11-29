Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZK2VKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZK2VKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZK2VKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:10:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:59847 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZK2VKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:10:13 -0500
Date: Sun, 29 Nov 2009 21:09:41 GMT
From: tip-bot for Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, avi@redhat.com, mingo@elte.hu
In-Reply-To: <1259505288-16559-1-git-send-email-avi@redhat.com>
References: <1259505288-16559-1-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/entry] core: Fix user return notifier on fork()
Message-ID: <tip-8e7cac79808b62f242069a6ac88d364d35621371@git.kernel.org>
Git-Commit-ID: 8e7cac79808b62f242069a6ac88d364d35621371
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e7cac79808b62f242069a6ac88d364d35621371
Gitweb:     http://git.kernel.org/tip/8e7cac79808b62f242069a6ac88d364d35621371
Author:     Avi Kivity <avi@redhat.com>
AuthorDate: Sun, 29 Nov 2009 16:34:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 29 Nov 2009 22:03:04 +0100

core: Fix user return notifier on fork()

fork() clones all thread_info flags, including
TIF_USER_RETURN_NOTIFY; if the new task is first scheduled on a cpu
which doesn't have user return notifiers set, this causes user
return notifiers to trigger without any way of clearing itself.

This is easy to trigger with a forky workload on the host in
parallel with kvm, resulting in a cpu in an endless loop on the
verge of returning to userspace.

Fix by dropping the TIF_USER_RETURN_NOTIFY immediately after fork.

Signed-off-by: Avi Kivity <avi@redhat.com>
LKML-Reference: <1259505288-16559-1-git-send-email-avi@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/user-return-notifier.h |    7 +++++++
 kernel/fork.c                        |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/user-return-notifier.h b/include/linux/user-return-notifier.h
index b6ac056..9c4a445 100644
--- a/include/linux/user-return-notifier.h
+++ b/include/linux/user-return-notifier.h
@@ -26,6 +26,11 @@ static inline void propagate_user_return_notify(struct task_struct *prev,
 
 void fire_user_return_notifiers(void);
 
+static inline void clear_user_return_notifier(struct task_struct *p)
+{
+	clear_tsk_thread_flag(p, TIF_USER_RETURN_NOTIFY);
+}
+
 #else
 
 struct user_return_notifier {};
@@ -37,6 +42,8 @@ static inline void propagate_user_return_notify(struct task_struct *prev,
 
 static inline void fire_user_return_notifiers(void) {}
 
+static inline void clear_user_return_notifier(struct task_struct *p) {}
+
 #endif
 
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 266c6af..1b7512d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -64,6 +64,7 @@
 #include <linux/magic.h>
 #include <linux/perf_event.h>
 #include <linux/posix-timers.h>
+#include <linux/user-return-notifier.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -249,6 +250,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 		goto out;
 
 	setup_thread_stack(tsk, orig);
+	clear_user_return_notifier(tsk);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
