Return-Path: <linux-kernel-owner+w=401wt.eu-S932147AbZICQzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbZICQzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbZICQzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:55:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:37119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbZICQzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:55:41 -0400
Date: Thu, 3 Sep 2009 16:55:03 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter: Fix output-sharing error path
Message-ID: <tip-dc86cabe4b242446ea9aa8492c727e1220817898@git.kernel.org>
Git-Commit-ID: dc86cabe4b242446ea9aa8492c727e1220817898
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 16:55:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc86cabe4b242446ea9aa8492c727e1220817898
Gitweb:     http://git.kernel.org/tip/dc86cabe4b242446ea9aa8492c727e1220817898
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 3 Sep 2009 18:03:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Sep 2009 18:46:23 +0200

perf_counter: Fix output-sharing error path

We forget to release the fd in the PERF_FLAG_FD_OUTPUT
error path.

Reorganize the error flow here to be a clean fall-through
logic.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0aa609f..e0d91fd 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4316,15 +4316,15 @@ SYSCALL_DEFINE5(perf_counter_open,
 	struct file *group_file = NULL;
 	int fput_needed = 0;
 	int fput_needed2 = 0;
-	int ret;
+	int err;
 
 	/* for future expandability... */
 	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
 		return -EINVAL;
 
-	ret = perf_copy_attr(attr_uptr, &attr);
-	if (ret)
-		return ret;
+	err = perf_copy_attr(attr_uptr, &attr);
+	if (err)
+		return err;
 
 	if (!attr.exclude_kernel) {
 		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
@@ -4348,7 +4348,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	 */
 	group_leader = NULL;
 	if (group_fd != -1 && !(flags & PERF_FLAG_FD_NO_GROUP)) {
-		ret = -EINVAL;
+		err = -EINVAL;
 		group_file = fget_light(group_fd, &fput_needed);
 		if (!group_file)
 			goto err_put_context;
@@ -4377,22 +4377,22 @@ SYSCALL_DEFINE5(perf_counter_open,
 
 	counter = perf_counter_alloc(&attr, cpu, ctx, group_leader,
 				     NULL, GFP_KERNEL);
-	ret = PTR_ERR(counter);
+	err = PTR_ERR(counter);
 	if (IS_ERR(counter))
 		goto err_put_context;
 
-	ret = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
-	if (ret < 0)
+	err = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
+	if (err < 0)
 		goto err_free_put_context;
 
-	counter_file = fget_light(ret, &fput_needed2);
+	counter_file = fget_light(err, &fput_needed2);
 	if (!counter_file)
 		goto err_free_put_context;
 
 	if (flags & PERF_FLAG_FD_OUTPUT) {
-		ret = perf_counter_set_output(counter, group_fd);
-		if (ret)
-			goto err_free_put_context;
+		err = perf_counter_set_output(counter, group_fd);
+		if (err)
+			goto err_fput_free_put_context;
 	}
 
 	counter->filp = counter_file;
@@ -4408,20 +4408,20 @@ SYSCALL_DEFINE5(perf_counter_open,
 	list_add_tail(&counter->owner_entry, &current->perf_counter_list);
 	mutex_unlock(&current->perf_counter_mutex);
 
+err_fput_free_put_context:
 	fput_light(counter_file, fput_needed2);
 
-out_fput:
-	fput_light(group_file, fput_needed);
-
-	return ret;
-
 err_free_put_context:
-	kfree(counter);
+	if (err < 0)
+		kfree(counter);
 
 err_put_context:
-	put_ctx(ctx);
+	if (err < 0)
+		put_ctx(ctx);
+
+	fput_light(group_file, fput_needed);
 
-	goto out_fput;
+	return err;
 }
 
 /*
