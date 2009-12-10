Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbZLJN62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbZLJN62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbZLJN6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:58:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246AbZLJN6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:58:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/7] NOMMU: Provide per-task stack usage through /proc for
	NOMMU
To: vapier.adi@gmail.com, lethal@linux-sh.org, jie.zhang@analog.com,
       stefani@seibold.net, gerg@snapgear.com
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Dec 2009 13:58:01 +0000
Message-ID: <20091210135801.6325.15166.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk>
References: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to get the per-task stack usage through /proc on a NOMMU
system.  The MMU-mode routine can't be used because walk_page_range() doesn't
work on NOMMU.

It can be tested to show the stack usages of non-kernel-thread processes:

	# grep "Stack usage:" /proc/*/status | grep -v "0 kB"
	/proc/1/status:Stack usage:     2 kB
	/proc/57/status:Stack usage:    3 kB
	/proc/58/status:Stack usage:    1 kB
	/proc/59/status:Stack usage:    3 kB
	/proc/60/status:Stack usage:    5 kB
	/proc/self/status:Stack usage:  1 kB

I've only tested it with ELF-FDPIC, though it should work with FLAT too.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
---

 fs/proc/array.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)


diff --git a/fs/proc/array.c b/fs/proc/array.c
index 4badde1..c67251e 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -387,8 +387,7 @@ static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
 	return ss.usage;
 }
 
-static inline void task_show_stack_usage(struct seq_file *m,
-						struct task_struct *task)
+static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
 {
 	struct vm_area_struct	*vma;
 	struct mm_struct	*mm = get_task_mm(task);
@@ -404,9 +403,24 @@ static inline void task_show_stack_usage(struct seq_file *m,
 		mmput(mm);
 	}
 }
-#else
+#else /* CONFIG_MMU */
+/*
+ * Calculate the size of a NOMMU process's stack
+ */
 static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
 {
+	unsigned long sp, base, usage;
+
+	base = task->stack_start;
+	sp = KSTK_ESP(task);
+
+#ifdef CONFIG_STACK_GROWSUP
+	usage = sp - base;
+#else
+	usage = base - sp;
+#endif
+
+	seq_printf(m, "Stack usage:\t%lu kB\n", (usage + 1023) >> 10);
 }
 #endif		/* CONFIG_MMU */
 

