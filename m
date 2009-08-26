Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZHZGxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZHZGxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbZHZGxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:53:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:43414 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbZHZGxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:53:50 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       rusty <rusty@rustcorp.com.au>
In-Reply-To: <1251269207.7538.1217.camel@twins>
References: <20090824092455.GA25267@elte.hu>
	 <1251106058.7538.149.camel@twins> <4A937505.5000209@cn.fujitsu.com>
	 <1251181266.7538.1016.camel@twins> <4A9385AA.508@cn.fujitsu.com>
	 <1251182405.7538.1050.camel@twins> <20090825090558.GC14003@elte.hu>
	 <1251191546.7538.1118.camel@twins> <20090825102215.GC26801@elte.hu>
	 <1251196359.7538.1133.camel@twins>  <20090825103907.GB28287@elte.hu>
	 <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins>
	 <4A94D3A8.1090902@cn.fujitsu.com>  <1251269207.7538.1217.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 08:52:42 +0200
Message-Id: <1251269562.7538.1222.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 08:46 +0200, Peter Zijlstra wrote:

> Aahh, I see the bug, its only ftrace that knows about the module, not
> tracepoints themselves, _that_ needs fixing.

These are the bits I hacked up until I figured out the above bug.

---
 include/linux/ftrace_event.h |    2 +-
 include/linux/module.h       |   18 ++++++++++++++----
 kernel/module.c              |    9 +--------
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index df5b085..d86d60c 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -122,7 +122,7 @@ struct ftrace_event_call {
 	struct list_head	fields;
 	int			filter_active;
 	struct event_filter	*filter;
-	void			*mod;
+	struct module		*mod;
 	void			*data;
 
 	atomic_t		profile_count;
diff --git a/include/linux/module.h b/include/linux/module.h
index 86863cd..09e2b88 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -409,16 +409,26 @@ struct module *__module_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
 
+static inline 
+int __within_module(unsigned long addr, void *start, unsigned long size)
+{
+	return ((void *)addr >= start && (void *)addr < start + size);
+}
+
 static inline int within_module_core(unsigned long addr, struct module *mod)
 {
-	return (unsigned long)mod->module_core <= addr &&
-	       addr < (unsigned long)mod->module_core + mod->core_size;
+	return __within_module(addr, mod->module_core, mod->core_size);
 }
 
 static inline int within_module_init(unsigned long addr, struct module *mod)
 {
-	return (unsigned long)mod->module_init <= addr &&
-	       addr < (unsigned long)mod->module_init + mod->init_size;
+	return __within_module(addr, mod->module_init, mod->init_size);
+}
+
+static inline int within_module_text(unsigned long addr, struct module *mod)
+{
+	return __within_module(addr, mod->module_init, mod->init_text_size) ||
+	       __within_module(addr, mod->core_init, mod->core_text_size);
 }
 
 /* Search for module by name: must hold module_mutex. */
diff --git a/kernel/module.c b/kernel/module.c
index b182143..822adb6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2493,11 +2493,6 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	return 0;
 }
 
-static inline int within(unsigned long addr, void *start, unsigned long size)
-{
-	return ((void *)addr >= start && (void *)addr < start + size);
-}
-
 #ifdef CONFIG_KALLSYMS
 /*
  * This ignores the intensely annoying "mapping symbols" found
@@ -2912,9 +2907,7 @@ struct module *__module_text_address(unsigned long addr)
 {
 	struct module *mod = __module_address(addr);
 	if (mod) {
-		/* Make sure it's within the text section. */
-		if (!within(addr, mod->module_init, mod->init_text_size)
-		    && !within(addr, mod->module_core, mod->core_text_size))
+		if (!within_module_text(addr, mod))
 			mod = NULL;
 	}
 	return mod;

