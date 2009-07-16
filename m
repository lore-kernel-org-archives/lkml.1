Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZGPK52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZGPK52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZGPK5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:57:11 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58106 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbZGPKyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:54:39 -0400
Message-Id: <20090716104817.273972048@samba.org>
References: <20090716104247.536695580@samba.org>
User-Agent: quilt/0.46-1
Date: Thu, 16 Jul 2009 20:42:48 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/5] perf_counter: Make sure we dont leak kernel memory to userspace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few places we are leaking tiny amounts of kernel memory
to userspace. This happens when writing out strings because we always align
the end to 64 bits.

To avoid this we should always use an appropriately sized temporary buffer
and ensure it is zeroed.

Since d_path assembles the string from the end of the buffer backwards, we
need to add 64 bits after the buffer to allow for alignment.

We also need to copy arch_vma_name to the temporary buffer, because if we use
it directly we may end up copying to userspace a number of bytes after the end
of the string constant.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/kernel/perf_counter.c
===================================================================
--- linux.trees.git.orig/kernel/perf_counter.c	2009-07-16 19:44:23.000000000 +1000
+++ linux.trees.git/kernel/perf_counter.c	2009-07-16 20:25:37.000000000 +1000
@@ -2969,8 +2969,10 @@
 	struct perf_cpu_context *cpuctx;
 	struct perf_counter_context *ctx;
 	unsigned int size;
-	char *comm = comm_event->task->comm;
+	char comm[TASK_COMM_LEN];
 
+	memset(comm, 0, sizeof(comm));
+	strncpy(comm, comm_event->task->comm, sizeof(comm));
 	size = ALIGN(strlen(comm)+1, sizeof(u64));
 
 	comm_event->comm = comm;
@@ -3089,8 +3091,15 @@
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
@@ -3101,9 +3110,11 @@
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

-- 

