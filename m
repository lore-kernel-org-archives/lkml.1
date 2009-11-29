Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZK2OfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZK2OfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 09:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZK2OfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 09:35:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbZK2OfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 09:35:05 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH tip:x86/entry] core: fix user return notifier on fork()
Date: Sun, 29 Nov 2009 16:34:48 +0200
Message-Id: <1259505288-16559-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fork() clones all thread_info flags, including TIF_USER_RETURN_NOTIFY; if the
new task is first scheduled on a cpu which doesn't have user return notifiers
set, this causes user return notifiers to trigger without any way of clearing
itself.

This is easy to trigger with a forky workload on the host in parallel with
kvm, resulting in a cpu in an endless loop on the verge of returning to
userspace.

Fix by dropping the TIF_USER_RETURN_NOTIFY immediately after fork.

Signed-off-by: Avi Kivity <avi@redhat.com>
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
index 166b8c4..7d4a348 100644
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
 
-- 
1.6.5.2

