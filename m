Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZHZRs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZHZRs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZHZRs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:48:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZHZRs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:48:58 -0400
Date: Wed, 26 Aug 2009 13:48:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
In-Reply-To: <20090826164624.GA21456@Krystal>
Message-ID: <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com>
References: <20090825102215.GC26801@elte.hu> <1251196359.7538.1133.camel@twins> <20090825103907.GB28287@elte.hu> <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins> <4A94D3A8.1090902@cn.fujitsu.com> <1251269207.7538.1217.camel@twins>
 <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch solves the problem that Li originally reported. If something 
registers a trace point belonging to a module, then it ups the ref count 
of the module. This prevents a process from registering a probe to a 
tracepoint belonging to a module and then having the module disappear.

Doing the example with perf in Li's original post, now errors on the 
rmmod, with "ERROR: Module trace_events_sample is in use".

Mathieu, can I have your acked-by on this?

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 0341f2e..055275b 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -109,8 +109,9 @@ struct tracepoint {
 #define EXPORT_TRACEPOINT_SYMBOL(name)					\
 	EXPORT_SYMBOL(__tracepoint_##name)
 
-extern void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end);
+extern void tracepoint_update_probe_range(struct module *,
+					  struct tracepoint *begin,
+					  struct tracepoint *end);
 
 #else /* !CONFIG_TRACEPOINTS */
 #define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
diff --git a/kernel/module.c b/kernel/module.c
index b182143..a8e69fa 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2974,7 +2974,7 @@ void module_update_tracepoints(void)
 	mutex_lock(&module_mutex);
 	list_for_each_entry(mod, &modules, list)
 		if (!mod->taints)
-			tracepoint_update_probe_range(mod->tracepoints,
+			tracepoint_update_probe_range(mod, mod->tracepoints,
 				mod->tracepoints + mod->num_tracepoints);
 	mutex_unlock(&module_mutex);
 }
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 06f165a..089e6f9 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -54,6 +54,7 @@ static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
  */
 struct tracepoint_entry {
 	struct hlist_node hlist;
+	struct module *mod;
 	void **funcs;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
 	char name[0];
@@ -221,6 +222,7 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
 	memcpy(&e->name[0], name, name_len);
 	e->funcs = NULL;
 	e->refcount = 0;
+	e->mod = NULL;	/* Will be assigned in tracepoint_update_probe_range */
 	hlist_add_head(&e->hlist, head);
 	return e;
 }
@@ -231,6 +233,8 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
  */
 static inline void remove_tracepoint(struct tracepoint_entry *e)
 {
+	if (e->mod)
+		module_put(e->mod);
 	hlist_del(&e->hlist);
 	kfree(e);
 }
@@ -274,7 +278,8 @@ static void disable_tracepoint(struct tracepoint *elem)
  * Updates the probe callback corresponding to a range of tracepoints.
  */
 void
-tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
+tracepoint_update_probe_range(struct module *mod,
+			      struct tracepoint *begin, struct tracepoint *end)
 {
 	struct tracepoint *iter;
 	struct tracepoint_entry *mark_entry;
@@ -286,9 +291,15 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
 	for (iter = begin; iter < end; iter++) {
 		mark_entry = get_tracepoint(iter->name);
 		if (mark_entry) {
+			if (mod && !mark_entry->mod) {
+				if (!try_module_get(mod))
+					goto disable;
+				mark_entry->mod = mod;
+			}
 			set_tracepoint(&mark_entry, iter,
 					!!mark_entry->refcount);
 		} else {
+ disable:
 			disable_tracepoint(iter);
 		}
 	}
@@ -301,7 +312,7 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
 static void tracepoint_update_probes(void)
 {
 	/* Core kernel tracepoints */
-	tracepoint_update_probe_range(__start___tracepoints,
+	tracepoint_update_probe_range(NULL, __start___tracepoints,
 		__stop___tracepoints);
 	/* tracepoints in modules. */
 	module_update_tracepoints();
@@ -556,7 +567,7 @@ int tracepoint_module_notify(struct notifier_block *self,
 	switch (val) {
 	case MODULE_STATE_COMING:
 	case MODULE_STATE_GOING:
-		tracepoint_update_probe_range(mod->tracepoints,
+		tracepoint_update_probe_range(mod, mod->tracepoints,
 			mod->tracepoints + mod->num_tracepoints);
 		break;
 	}


