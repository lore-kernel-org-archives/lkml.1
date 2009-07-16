Return-Path: <linux-kernel-owner+w=401wt.eu-S933137AbZGPTox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbZGPTox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbZGPTow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:44:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40057 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbZGPTou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:44:50 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] tracing: removing struct module* parameter from ftrace_init_module code path
Date: Thu, 16 Jul 2009 21:44:27 +0200
Message-Id: <1247773468-11594-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1247773468-11594-1-git-send-email-jolsa@redhat.com>
References: <1247773468-11594-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "struct module*" is not being used in the ftrace_init_module code path,
removing it.

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>

---
 arch/x86/kernel/ftrace.c |    3 +--
 include/linux/ftrace.h   |    4 +---
 kernel/trace/ftrace.c    |   25 +++++++++++--------------
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d94e1ea..b5c22fb 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -255,8 +255,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	return 0;
 }
 
-int ftrace_make_nop(struct module *mod,
-		    struct dyn_ftrace *rec, unsigned long addr)
+int ftrace_make_nop(struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned char *new, *old;
 	unsigned long ip = rec->ip;
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index dc3b132..efe0fb3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -184,7 +184,6 @@ static inline int ftrace_disable_ftrace_graph_caller(void) { return 0; }
 
 /**
  * ftrace_make_nop - convert code into nop
- * @mod: module structure if called by module load initialization
  * @rec: the mcount call site record
  * @addr: the address that the call site should be calling
  *
@@ -203,8 +202,7 @@ static inline int ftrace_disable_ftrace_graph_caller(void) { return 0; }
  *  -EPERM  on error writing to the location
  * Any other value will be considered a failure.
  */
-extern int ftrace_make_nop(struct module *mod,
-			   struct dyn_ftrace *rec, unsigned long addr);
+extern int ftrace_make_nop(struct dyn_ftrace *rec, unsigned long addr);
 
 /**
  * ftrace_make_call - convert a nop call site into a call to addr
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1dc08ab..c4dfcff 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1080,7 +1080,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	if (rec->flags & FTRACE_FL_ENABLED)
 		return ftrace_make_call(rec, ftrace_addr);
 	else
-		return ftrace_make_nop(NULL, rec, ftrace_addr);
+		return ftrace_make_nop(rec, ftrace_addr);
 }
 
 static void ftrace_replace_code(int enable)
@@ -1123,14 +1123,14 @@ static void ftrace_replace_code(int enable)
 }
 
 static int
-ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
+ftrace_code_disable(struct dyn_ftrace *rec)
 {
 	unsigned long ip;
 	int ret;
 
 	ip = rec->ip;
 
-	ret = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
+	ret = ftrace_make_nop(rec, MCOUNT_ADDR);
 	if (ret) {
 		ftrace_bug(ret, ip);
 		rec->flags |= FTRACE_FL_FAILED;
@@ -1280,7 +1280,7 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
-static int ftrace_update_code(struct module *mod)
+static int ftrace_update_code(void)
 {
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
@@ -1299,7 +1299,7 @@ static int ftrace_update_code(struct module *mod)
 		p->flags = 0L;
 
 		/* convert record (i.e, patch mcount-call with NOP) */
-		if (ftrace_code_disable(mod, p)) {
+		if (ftrace_code_disable(p)) {
 			p->flags |= FTRACE_FL_CONVERTED;
 			ftrace_update_cnt++;
 		} else
@@ -2751,8 +2751,7 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	return 0;
 }
 
-static int ftrace_convert_nops(struct module *mod,
-			       unsigned long *start,
+static int ftrace_convert_nops(unsigned long *start,
 			       unsigned long *end)
 {
 	unsigned long *p;
@@ -2776,7 +2775,7 @@ static int ftrace_convert_nops(struct module *mod,
 
 	/* disable interrupts to prevent kstop machine */
 	local_irq_save(flags);
-	ftrace_update_code(mod);
+	ftrace_update_code();
 	local_irq_restore(flags);
 	mutex_unlock(&ftrace_lock);
 
@@ -2808,12 +2807,11 @@ void ftrace_release(void *start, void *end)
 	mutex_unlock(&ftrace_lock);
 }
 
-static void ftrace_init_module(struct module *mod,
-			       unsigned long *start, unsigned long *end)
+static void ftrace_init_module(unsigned long *start, unsigned long *end)
 {
 	if (ftrace_disabled || start == end)
 		return;
-	ftrace_convert_nops(mod, start, end);
+	ftrace_convert_nops(start, end);
 }
 
 static int ftrace_module_notify(struct notifier_block *self,
@@ -2823,7 +2821,7 @@ static int ftrace_module_notify(struct notifier_block *self,
 
 	switch (val) {
 	case MODULE_STATE_COMING:
-		ftrace_init_module(mod, mod->ftrace_callsites,
+		ftrace_init_module(mod->ftrace_callsites,
 				   mod->ftrace_callsites +
 				   mod->num_ftrace_callsites);
 		break;
@@ -2876,8 +2874,7 @@ void __init ftrace_init(void)
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
-	ret = ftrace_convert_nops(NULL,
-				  __start_mcount_loc,
+	ret = ftrace_convert_nops(__start_mcount_loc,
 				  __stop_mcount_loc);
 
 	ret = register_module_notifier(&ftrace_module_nb);
-- 
1.6.2.5

