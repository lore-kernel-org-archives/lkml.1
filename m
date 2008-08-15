Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYHODBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYHODBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYHODAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:00:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYHODAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:00:49 -0400
Message-Id: <20080815030047.548192730@goodmis.org>
References: <20080815024716.480118113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Aug 2008 22:47:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com,
       rusty@rustcorp.com.au
Subject: [PATCH 3/3] ftrace: remove old pointers to mcount
Content-Disposition: inline; filename=ftrace-release-mcount-recs-by-addr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a mcount pointer is recorded into a table, it is used to add or
remove calls to mcount (replacing them with nops). If the code is removed
via removing a module, the pointers still exist.  At modifying the code
a check is always made to make sure the code being replaced is the code
expected. In-other-words, the code being replaced is compared to what
it is expected to be before being replaced.

There is a very small chance that the code being replaced just happens
to look like code that calls mcount (very small since the call to mcount
is relative). To remove this chance, this patch adds ftrace_release to
allow module unloading to remove the pointers to mcount within the module.

Another change for init calls is made to not trace calls marked with
__init. The tracing can not be started until after init is done anyway.

[
  Rusty, I decided to remove the if statement for you ;-)
]

CC: rusty@rustcorp.com.au
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    2 ++
 include/linux/init.h   |    2 +-
 kernel/module.c        |   12 ++++++++----
 kernel/trace/ftrace.c  |   32 ++++++++++++++++++++++++++++++--
 4 files changed, 41 insertions(+), 7 deletions(-)

Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-08-14 22:42:59.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-08-14 22:43:33.000000000 -0400
@@ -144,10 +144,12 @@ ftrace_special(unsigned long arg1, unsig
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 extern void ftrace_init(void);
 extern void ftrace_init_module(unsigned long *start, unsigned long *end);
+extern void ftrace_release(void *start, unsigned long size);
 #else
 static inline void ftrace_init(void) { }
 static inline void
 ftrace_init_module(unsigned long *start, unsigned long *end) { }
+static inline void ftrace_release(void *start, unsigned long size) { }
 #endif
 
 #endif /* _LINUX_FTRACE_H */
Index: linux-tip.git/kernel/module.c
===================================================================
--- linux-tip.git.orig/kernel/module.c	2008-08-14 22:42:59.000000000 -0400
+++ linux-tip.git/kernel/module.c	2008-08-14 22:43:33.000000000 -0400
@@ -1432,6 +1432,9 @@ static void free_module(struct module *m
 	/* Module unload stuff */
 	module_unload_free(mod);
 
+	/* release any pointers to mcount in this module */
+	ftrace_release(mod->module_core, mod->core_size);
+
 	/* This may be NULL, but that's OK */
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
@@ -1840,6 +1843,7 @@ static struct module *load_module(void _
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
+	void *mseg;
 	struct exception_table_entry *extable;
 	mm_segment_t old_fs;
 
@@ -2191,10 +2195,9 @@ static struct module *load_module(void _
 #endif
 	}
 
-	if (mcountindex) {
-		void *mseg = (void *)sechdrs[mcountindex].sh_addr;
-		ftrace_init_module(mseg, mseg + sechdrs[mcountindex].sh_size);
-	}
+	/* sechdrs[0].sh_size is always zero */
+	mseg = (void *)sechdrs[mcountindex].sh_addr;
+	ftrace_init_module(mseg, mseg + sechdrs[mcountindex].sh_size);
 
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
@@ -2265,6 +2268,7 @@ static struct module *load_module(void _
  cleanup:
 	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
+	ftrace_release(mod->module_core, mod->core_size);
  free_unload:
 	module_unload_free(mod);
 	module_free(mod, mod->module_init);
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-08-14 22:43:03.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-08-14 22:43:33.000000000 -0400
@@ -294,13 +294,37 @@ static inline void ftrace_del_hash(struc
 
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
-	/* no locking, only called from kstop_machine */
-
 	rec->ip = (unsigned long)ftrace_free_records;
 	ftrace_free_records = rec;
 	rec->flags |= FTRACE_FL_FREE;
 }
 
+void ftrace_release(void *start, unsigned long size)
+{
+	struct dyn_ftrace *rec;
+	struct ftrace_page *pg;
+	unsigned long s = (unsigned long)start;
+	unsigned long e = s + size;
+	int i;
+
+	if (!start)
+		return;
+
+	/* No interrupt should call this */
+	spin_lock(&ftrace_lock);
+
+	for (pg = ftrace_pages_start; pg; pg = pg->next) {
+		for (i = 0; i < pg->index; i++) {
+			rec = &pg->records[i];
+
+			if ((rec->ip >= s) && (rec->ip < e))
+				ftrace_free_rec(rec);
+		}
+	}
+	spin_unlock(&ftrace_lock);
+
+}
+
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
 {
 	struct dyn_ftrace *rec;
@@ -1534,7 +1558,9 @@ static int ftrace_convert_nops(unsigned 
 	p = start;
 	while (p < end) {
 		addr = ftrace_call_adjust(*p++);
+		spin_lock(&ftrace_lock);
 		ftrace_record_ip(addr);
+		spin_unlock(&ftrace_lock);
 		ftrace_shutdown_replenish();
 	}
 
@@ -1548,6 +1574,8 @@ static int ftrace_convert_nops(unsigned 
 
 void ftrace_init_module(unsigned long *start, unsigned long *end)
 {
+	if (start == end)
+		return;
 	ftrace_convert_nops(start, end);
 }
 
Index: linux-tip.git/include/linux/init.h
===================================================================
--- linux-tip.git.orig/include/linux/init.h	2008-08-14 22:42:59.000000000 -0400
+++ linux-tip.git/include/linux/init.h	2008-08-14 22:43:33.000000000 -0400
@@ -40,7 +40,7 @@
 
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
-#define __init		__section(.init.text) __cold
+#define __init		__section(.init.text) __cold notrace
 #define __initdata	__section(.init.data)
 #define __initconst	__section(.init.rodata)
 #define __exitdata	__section(.exit.data)

-- 
