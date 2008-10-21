Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYJUU65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYJUU65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYJUU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:58:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbYJUU6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:58:49 -0400
Date: Tue, 21 Oct 2008 13:58:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] freezer_cg: use thaw_process() in unfreeze_cgroup()
Message-Id: <20081021135813.e77d3015.akpm@linux-foundation.org>
In-Reply-To: <48FD81B8.5030103@fr.ibm.com>
References: <48FD26F5.1070809@cn.fujitsu.com>
	<48FD273F.3040505@cn.fujitsu.com>
	<48FD2784.30906@cn.fujitsu.com>
	<48FD81B8.5030103@fr.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 09:16:08 +0200
Cedric Le Goater <clg@fr.ibm.com> wrote:

> Li Zefan wrote:
> > Don't duplicate the implementation of thaw_process().
> 
> looks OK but you should remove  __thaw_process() which is unused 
> now.

It's called by thaw_process().

But that's the only callsite, I believe, so...

--- a/include/linux/freezer.h~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
+++ a/include/linux/freezer.h
@@ -44,11 +44,6 @@ static inline bool should_send_signal(st
 	return !(p->flags & PF_FREEZER_NOSIG);
 }
 
-/*
- * Wake up a frozen process
- */
-extern int __thaw_process(struct task_struct *p);
-
 /* Takes and releases task alloc lock using task_lock() */
 extern int thaw_process(struct task_struct *p);
 
diff -puN kernel/freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix kernel/freezer.c
--- a/kernel/freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
+++ a/kernel/freezer.c
@@ -121,16 +121,7 @@ void cancel_freezing(struct task_struct 
 	}
 }
 
-/*
- * Wake up a frozen process
- *
- * task_lock() is needed to prevent the race with refrigerator() which may
- * occur if the freezing of tasks fails.  Namely, without the lock, if the
- * freezing of tasks failed, thaw_tasks() might have run before a task in
- * refrigerator() could call frozen_process(), in which case the task would be
- * frozen and no one would thaw it.
- */
-int __thaw_process(struct task_struct *p)
+static int __thaw_process(struct task_struct *p)
 {
 	if (frozen(p)) {
 		p->flags &= ~PF_FROZEN;
@@ -140,6 +131,15 @@ int __thaw_process(struct task_struct *p
 	return 0;
 }
 
+/*
+ * Wake up a frozen process
+ *
+ * task_lock() is needed to prevent the race with refrigerator() which may
+ * occur if the freezing of tasks fails.  Namely, without the lock, if the
+ * freezing of tasks failed, thaw_tasks() might have run before a task in
+ * refrigerator() could call frozen_process(), in which case the task would be
+ * frozen and no one would thaw it.
+ */
 int thaw_process(struct task_struct *p)
 {
 	task_lock(p);
_

