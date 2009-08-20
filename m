Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZHTKuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZHTKuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZHTKuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:50:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbZHTKuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:50:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] Allow the 'cut here' oops line to be displayed before
	calling BUG()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 20 Aug 2009 11:49:56 +0100
Message-ID: <20090820104956.29972.92662.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the 'cut here' oops line to be displayed before calling BUG() as useful
information is often displayed before BUG() is called.  Also use this to limit
recursive oopsing.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/bug.h   |    8 ++++++++
 include/linux/sched.h |    9 +++++++++
 lib/bug.c             |   31 +++++++++++++++++++++++++++++--
 3 files changed, 46 insertions(+), 2 deletions(-)


diff --git a/include/linux/bug.h b/include/linux/bug.h
index d276b55..290309f 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -26,6 +26,8 @@ enum bug_trap_type report_bug(unsigned long bug_addr, struct pt_regs *regs);
 /* These are defined by the architecture */
 int is_valid_bugaddr(unsigned long addr);
 
+extern bool cut_here(void);
+
 #else	/* !CONFIG_GENERIC_BUG */
 
 static inline enum bug_trap_type report_bug(unsigned long bug_addr,
@@ -34,5 +36,11 @@ static inline enum bug_trap_type report_bug(unsigned long bug_addr,
 	return BUG_TRAP_TYPE_BUG;
 }
 
+static inline bool cut_here(void)
+{
+	return true;
+}
+
 #endif	/* CONFIG_GENERIC_BUG */
+
 #endif	/* _LINUX_BUG_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f1ea4a..f4b9782 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1199,6 +1199,9 @@ struct task_struct {
 	 */
 	unsigned char fpu_counter;
 	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
+
+	unsigned char oopsing;		/* oopsing state */
+
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
@@ -1700,6 +1703,12 @@ extern cputime_t task_gtime(struct task_struct *p);
 #define PF_FREEZER_NOSIG 0x80000000	/* Freezer won't send signals to it */
 
 /*
+ * current->oopsing flags
+ */
+#define OOPS_CUT_HERE	0x01		/* set if the "cut here" message is displayed */
+#define OOPS_REPORTED	0x02		/* recursion limiter */
+
+/*
  * Only the _current_ task can read/write to tsk->flags, but other
  * tasks can access tsk->flags in readonly mode for example
  * with tsk_used_math (like during threaded core dumping).
diff --git a/lib/bug.c b/lib/bug.c
index 300e41a..2d0ed45 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -125,6 +125,31 @@ const struct bug_entry *find_bug(unsigned long bugaddr)
 	return module_find_bug(bugaddr);
 }
 
+/**
+ * cut_here - Begin BUG() output
+ *
+ * Begin the outputting of a BUG() report with a 'cut here' line.  This ensures
+ * we produce at most one 'cut here' line per process.  This allows us to
+ * extend a BUG() report with extra information in front of it.
+ *
+ * We return true if the caller is free to go ahead and report their oops.
+ *
+ * We return false if we've detected a recursive oops - in which case the
+ * caller should take care, and possibly not do anything other than call BUG(),
+ * lest they cause further recursion.  This is particularly true of things that
+ * might go wrong in the exit path.
+ */
+bool cut_here(void)
+{
+	if (!(current->oopsing & OOPS_CUT_HERE)) {
+		current->oopsing |= OOPS_CUT_HERE;
+		printk(KERN_EMERG "------------[ cut here ]------------\n");
+	}
+
+	return !(current->oopsing & OOPS_REPORTED);
+}
+EXPORT_SYMBOL(cut_here);
+
 enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
 	const struct bug_entry *bug;
@@ -134,9 +159,9 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 	if (!is_valid_bugaddr(bugaddr))
 		return BUG_TRAP_TYPE_NONE;
 
-	bug = find_bug(bugaddr);
+	cut_here();
 
-	printk(KERN_EMERG "------------[ cut here ]------------\n");
+	bug = find_bug(bugaddr);
 
 	file = NULL;
 	line = 0;
@@ -169,6 +194,8 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 		return BUG_TRAP_TYPE_WARN;
 	}
 
+	current->oopsing |= OOPS_REPORTED;
+
 	if (file)
 		printk(KERN_CRIT "kernel BUG at %s:%u!\n",
 		       file, line);

