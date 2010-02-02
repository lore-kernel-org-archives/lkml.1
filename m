Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0BBVmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:42:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0BBVmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:42:03 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/4] ftrace/alternatives: Introducing *_text_reserved
	functions
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jason Baron <jbaron@redhat.com>
Date: Tue, 02 Feb 2010 16:49:11 -0500
Message-ID: <20100202214911.4694.16587.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing *_text_reserved functions for checking the text address range
is partially reserved or not. This patch provides checking routines for
x86 smp alternatives and dynamic ftrace. Since both functions modify fixed
pieces of kernel text, they should reserve and protect those from other
dynamic text modifier, like kprobes.

This will also be extended when introducing other subsystems which
modify fixed pieces of kernel text. Dynamic text modifiers should
avoid those.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jason Baron <jbaron@redhat.com>
---

 arch/x86/include/asm/alternative.h |    5 +++++
 arch/x86/kernel/alternative.c      |   16 ++++++++++++++++
 include/linux/ftrace.h             |    6 ++++++
 kernel/trace/ftrace.c              |   15 +++++++++++++++
 4 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 3b5b828..f1e253c 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -65,12 +65,17 @@ extern void alternatives_smp_module_add(struct module *mod, char *name,
 					void *text, void *text_end);
 extern void alternatives_smp_module_del(struct module *mod);
 extern void alternatives_smp_switch(int smp);
+extern int alternatives_text_reserved(void *start, void *end);
 #else
 static inline void alternatives_smp_module_add(struct module *mod, char *name,
 					       void *locks, void *locks_end,
 					       void *text, void *text_end) {}
 static inline void alternatives_smp_module_del(struct module *mod) {}
 static inline void alternatives_smp_switch(int smp) {}
+static inline int alternatives_text_reserved(void *start, void *end)
+{
+	return 0;
+}
 #endif	/* CONFIG_SMP */
 
 /* alternative assembly primitive: */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2589ea4..3832fdc 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -392,6 +392,22 @@ void alternatives_smp_switch(int smp)
 	mutex_unlock(&smp_alt);
 }
 
+/* Return 1 if the address range is reserved for smp-alternatives */
+int alternatives_text_reserved(void *start, void *end)
+{
+	struct smp_alt_module *mod;
+	u8 **ptr;
+
+	list_for_each_entry(mod, &smp_alt_modules, next) {
+		if (mod->text > end || mod->text_end < start)
+			continue;
+		for (ptr = mod->locks; ptr < mod->locks_end; ptr++)
+			if (start <= *ptr && end >= *ptr)
+				return 1;
+	}
+
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_PARAVIRT
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0b4f97d..9d127ef 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -134,6 +134,8 @@ extern void
 unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops);
 extern void unregister_ftrace_function_probe_all(char *glob);
 
+extern int ftrace_text_reserved(void *start, void *end);
+
 enum {
 	FTRACE_FL_FREE		= (1 << 0),
 	FTRACE_FL_FAILED	= (1 << 1),
@@ -250,6 +252,10 @@ static inline int unregister_ftrace_command(char *cmd_name)
 {
 	return -EINVAL;
 }
+static inline int ftrace_text_reserved(void *start, void *end)
+{
+	return 0;
+}
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1e6640f..3d90661 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1025,6 +1025,21 @@ static void ftrace_bug(int failed, unsigned long ip)
 }
 
 
+/* Return 1 if the address range is reserved for ftrace */
+int ftrace_text_reserved(void *start, void *end)
+{
+	struct dyn_ftrace *rec;
+	struct ftrace_page *pg;
+
+	do_for_each_ftrace_rec(pg, rec) {
+		if (rec->ip <= (unsigned long)end &&
+		    rec->ip + MCOUNT_INSN_SIZE > (unsigned long)start)
+			return 1;
+	} while_for_each_ftrace_rec();
+	return 0;
+}
+
+
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
