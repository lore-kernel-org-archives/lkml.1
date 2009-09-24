Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZIXLff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZIXLff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZIXLfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:35:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZIXLfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:35:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/4] NOMMU: Make it possible to get the per-task stack usage
	through /proc for NOMMU
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Mike Frysinger <vapier@gentoo.org>, Paul Mundt <lethal@linux-sh.org>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Date: Thu, 24 Sep 2009 12:33:42 +0100
Message-ID: <20090924113342.6031.82407.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090924113332.6031.11718.stgit@warthog.procyon.org.uk>
References: <20090924113332.6031.11718.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to get the per-task stack usage through /proc on a NOMMU
system.  This is required because walk_page_range() doesn't work on NOMMU.

	# grep "Stack usage:" /proc/*/status
	/proc/1/status:Stack usage:	2 kB
	/proc/56/status:Stack usage:	2 kB
	/proc/57/status:Stack usage:	1 kB
	/proc/58/status:Stack usage:	2 kB
	/proc/59/status:Stack usage:	5 kB
	/proc/self/status:Stack usage:	1 kB

I've only tested it with ELF-FDPIC, though it should work with FLAT too.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
---

 fs/proc/array.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)


diff --git a/fs/proc/array.c b/fs/proc/array.c
index 0c6bc60..4b8f9e5 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -328,6 +328,7 @@ struct stack_stats {
 	unsigned long	usage;
 };
 
+#ifdef CONFIG_MMU
 static int stack_usage_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
@@ -403,6 +404,35 @@ static inline void task_show_stack_usage(struct seq_file *m,
 	}
 }
 
+#else /* CONFIG_MMU */
+
+/*
+ * Calculate the size of a NOMMU process's stack
+ */
+static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
+{
+	struct mm_struct *mm = get_task_mm(task);
+	unsigned long sp, base, limit, size;
+
+	if (mm) {
+		down_read(&mm->mmap_sem);
+
+		/* we assume the stack grows down towards the brk point */
+		sp = KSTK_ESP(task);
+		base = roundup(mm->arg_start, sizeof(long));
+		limit = mm->context.end_brk;
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+
+		if (limit <= sp && sp <= base)
+			size = base - sp;
+		else
+			size = base - limit;
+		seq_printf(m, "Stack usage:\t%lu kB\n", (size + 1023) >> 10);
+	}
+}
+#endif /* CONFIG_MMU */
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {

