Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbZGRJup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbZGRJup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZGRJuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:50:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:42221 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbZGRJun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:50:43 -0400
Date: Sat, 18 Jul 2009 09:50:03 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090716104817.273972048@samba.org>
References: <20090716104817.273972048@samba.org>
Subject: [tip:perfcounters/urgent] perf_counter: Make sure we dont leak kernel memory to userspace
Message-ID: <tip-413ee3b48ab582ffea33e7e140c7a2c5ea657e9a@git.kernel.org>
Git-Commit-ID: 413ee3b48ab582ffea33e7e140c7a2c5ea657e9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 09:50:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  413ee3b48ab582ffea33e7e140c7a2c5ea657e9a
Gitweb:     http://git.kernel.org/tip/413ee3b48ab582ffea33e7e140c7a2c5ea657e9a
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Thu, 16 Jul 2009 15:15:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 11:21:29 +0200

perf_counter: Make sure we dont leak kernel memory to userspace

There are a few places we are leaking tiny amounts of kernel
memory to userspace. This happens when writing out strings
because we always align the end to 64 bits.

To avoid this we should always use an appropriately sized
temporary buffer and ensure it is zeroed.

Since d_path assembles the string from the end of the buffer
backwards, we need to add 64 bits after the buffer to allow for
alignment.

We also need to copy arch_vma_name to the temporary buffer,
because if we use it directly we may end up copying to
userspace a number of bytes after the end of the string
constant.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090716104817.273972048@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c6c38fb..f7a8ab9 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2968,8 +2968,10 @@ static void perf_counter_comm_event(struct perf_comm_event *comm_event)
 	struct perf_cpu_context *cpuctx;
 	struct perf_counter_context *ctx;
 	unsigned int size;
-	char *comm = comm_event->task->comm;
+	char comm[TASK_COMM_LEN];
 
+	memset(comm, 0, sizeof(comm));
+	strncpy(comm, comm_event->task->comm, sizeof(comm));
 	size = ALIGN(strlen(comm)+1, sizeof(u64));
 
 	comm_event->comm = comm;
@@ -3088,8 +3090,15 @@ static void perf_counter_mmap_event(struct perf_mmap_event *mmap_event)
 	char *buf = NULL;
 	const char *name;
 
+	memset(tmp, 0, sizeof(tmp));
+
 	if (file) {
-		buf = kzalloc(PATH_MAX, GFP_KERNEL);
+		/*
+		 * d_path works from the end of the buffer backwards, so we
+		 * need to add enough zero bytes after the string to handle
+		 * the 64bit alignment we do later.
+		 */
+		buf = kzalloc(PATH_MAX + sizeof(u64), GFP_KERNEL);
 		if (!buf) {
 			name = strncpy(tmp, "//enomem", sizeof(tmp));
 			goto got_name;
@@ -3100,9 +3109,11 @@ static void perf_counter_mmap_event(struct perf_mmap_event *mmap_event)
 			goto got_name;
 		}
 	} else {
-		name = arch_vma_name(mmap_event->vma);
-		if (name)
+		if (arch_vma_name(mmap_event->vma)) {
+			name = strncpy(tmp, arch_vma_name(mmap_event->vma),
+				       sizeof(tmp));
 			goto got_name;
+		}
 
 		if (!vma->vm_mm) {
 			name = strncpy(tmp, "[vdso]", sizeof(tmp));
