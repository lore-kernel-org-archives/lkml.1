Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYJaAhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYJaAhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 20:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbYJaAhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 20:37:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57599 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbYJaAhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 20:37:16 -0400
Message-Id: <20081031002756.602176990@polymtl.ca>
References: <20081031002659.740180716@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 30 Oct 2008 20:27:01 -0400
From: mathieu.desnoyers@polymtl.ca
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/2] tracepoint: introduce *_noupdate APIs. (v2)
Content-Disposition: inline; filename=tracepoint-introduce-noupdate-apis.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 31 Oct 2008 00:36:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new APIs separate tracepoint_probe_register(),
tracepoint_probe_unregister() into 2 steps. The first step of them
is just update tracepoint_entry, not connect or disconnect.

this patch introduce tracepoint_probe_update_all() for update all.

these APIs are very useful for registering a lots of probes
but just update once only. and a very important thing is that
*_noupdate APIs do not require module_mutex.

Mathieu Desnoyers : Refreshed for -tip.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
---
 include/linux/tracepoint.h |    4 +
 kernel/tracepoint.c        |  170 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 136 insertions(+), 38 deletions(-)

Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h	2008-10-30 20:12:05.000000000 -0400
+++ linux-2.6-lttng/include/linux/tracepoint.h	2008-10-30 20:18:16.000000000 -0400
@@ -112,6 +112,10 @@ extern int tracepoint_probe_register(con
  */
 extern int tracepoint_probe_unregister(const char *name, void *probe);
 
+extern int tracepoint_probe_register_noupdate(const char *name, void *probe);
+extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe);
+extern void tracepoint_probe_update_all(void);
+
 struct tracepoint_iter {
 	struct module *module;
 	struct tracepoint *tracepoint;
Index: linux-2.6-lttng/kernel/tracepoint.c
===================================================================
--- linux-2.6-lttng.orig/kernel/tracepoint.c	2008-10-30 20:17:25.000000000 -0400
+++ linux-2.6-lttng/kernel/tracepoint.c	2008-10-30 20:18:16.000000000 -0400
@@ -59,7 +59,10 @@ struct tracepoint_entry {
 };
 
 struct tp_probes {
-	struct rcu_head rcu;
+	union {
+		struct rcu_head rcu;
+		struct list_head list;
+	} u;
 	void *probes[0];
 };
 
@@ -72,7 +75,7 @@ static inline void *allocate_probes(int 
 
 static void rcu_free_old_probes(struct rcu_head *head)
 {
-	kfree(container_of(head, struct tp_probes, rcu));
+	kfree(container_of(head, struct tp_probes, u.rcu));
 }
 
 static inline void release_probes(void *old)
@@ -80,7 +83,7 @@ static inline void release_probes(void *
 	if (old) {
 		struct tp_probes *tp_probes = container_of(old,
 			struct tp_probes, probes[0]);
-		call_rcu(&tp_probes->rcu, rcu_free_old_probes);
+		call_rcu_sched(&tp_probes->u.rcu, rcu_free_old_probes);
 	}
 }
 
@@ -299,6 +302,23 @@ static void tracepoint_update_probes(voi
 	module_update_tracepoints();
 }
 
+static void *tracepoint_add_probe(const char *name, void *probe)
+{
+	struct tracepoint_entry *entry;
+	void *old;
+
+	entry = get_tracepoint(name);
+	if (!entry) {
+		entry = add_tracepoint(name);
+		if (IS_ERR(entry))
+			return entry;
+	}
+	old = tracepoint_entry_add_probe(entry, probe);
+	if (IS_ERR(old) && !entry->refcount)
+		remove_tracepoint(entry);
+	return old;
+}
+
 /**
  * tracepoint_probe_register -  Connect a probe to a tracepoint
  * @name: tracepoint name
@@ -309,36 +329,36 @@ static void tracepoint_update_probes(voi
  */
 int tracepoint_probe_register(const char *name, void *probe)
 {
-	struct tracepoint_entry *entry;
-	int ret = 0;
 	void *old;
 
 	mutex_lock(&tracepoints_mutex);
-	entry = get_tracepoint(name);
-	if (!entry) {
-		entry = add_tracepoint(name);
-		if (IS_ERR(entry)) {
-			ret = PTR_ERR(entry);
-			goto end;
-		}
-	}
-	old = tracepoint_entry_add_probe(entry, probe);
-	if (IS_ERR(old)) {
-		if (!entry->refcount)
-			remove_tracepoint(entry);
-		ret = PTR_ERR(old);
-		goto end;
-	}
+	old = tracepoint_add_probe(name, probe);
 	mutex_unlock(&tracepoints_mutex);
+	if (IS_ERR(old))
+		return PTR_ERR(old);
+
 	tracepoint_update_probes();		/* may update entry */
 	release_probes(old);
 	return 0;
-end:
-	mutex_unlock(&tracepoints_mutex);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_register);
 
+static void *tracepoint_remove_probe(const char *name, void *probe)
+{
+	struct tracepoint_entry *entry;
+	void *old;
+
+	entry = get_tracepoint(name);
+	if (!entry)
+		return ERR_PTR(-ENOENT);
+	old = tracepoint_entry_remove_probe(entry, probe);
+	if (IS_ERR(old))
+		return old;
+	if (!entry->refcount)
+		remove_tracepoint(entry);
+	return old;
+}
+
 /**
  * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
  * @name: tracepoint name
@@ -351,31 +371,105 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_regis
  */
 int tracepoint_probe_unregister(const char *name, void *probe)
 {
-	struct tracepoint_entry *entry;
 	void *old;
-	int ret = -ENOENT;
 
 	mutex_lock(&tracepoints_mutex);
-	entry = get_tracepoint(name);
-	if (!entry)
-		goto end;
-	old = tracepoint_entry_remove_probe(entry, probe);
-	if (IS_ERR(old)) {
-		ret = PTR_ERR(old);
-		goto end;
-	}
-	if (!entry->refcount)
-		remove_tracepoint(entry);
+	old = tracepoint_remove_probe(name, probe);
 	mutex_unlock(&tracepoints_mutex);
+	if (IS_ERR(old))
+		return PTR_ERR(old);
+
 	tracepoint_update_probes();		/* may update entry */
 	release_probes(old);
 	return 0;
-end:
-	mutex_unlock(&tracepoints_mutex);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_unregister);
 
+static LIST_HEAD(old_probes);
+static int need_update;
+
+static void tracepoint_add_old_probes(void *old)
+{
+	need_update = 1;
+	if (old) {
+		struct tp_probes *tp_probes = container_of(old,
+			struct tp_probes, probes[0]);
+		list_add(&tp_probes->u.list, &old_probes);
+	}
+}
+
+/**
+ * tracepoint_probe_register_noupdate -  register a probe but not connect
+ * @name: tracepoint name
+ * @probe: probe handler
+ *
+ * caller must call tracepoint_probe_update_all()
+ */
+int tracepoint_probe_register_noupdate(const char *name, void *probe)
+{
+	void *old;
+
+	mutex_lock(&tracepoints_mutex);
+	old = tracepoint_add_probe(name, probe);
+	if (IS_ERR(old)) {
+		mutex_unlock(&tracepoints_mutex);
+		return PTR_ERR(old);
+	}
+	tracepoint_add_old_probes(old);
+	mutex_unlock(&tracepoints_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tracepoint_probe_register_noupdate);
+
+/**
+ * tracepoint_probe_unregister_noupdate -  remove a probe but not disconnect
+ * @name: tracepoint name
+ * @probe: probe function pointer
+ *
+ * caller must call tracepoint_probe_update_all()
+ */
+int tracepoint_probe_unregister_noupdate(const char *name, void *probe)
+{
+	void *old;
+
+	mutex_lock(&tracepoints_mutex);
+	old = tracepoint_remove_probe(name, probe);
+	if (IS_ERR(old)) {
+		mutex_unlock(&tracepoints_mutex);
+		return PTR_ERR(old);
+	}
+	tracepoint_add_old_probes(old);
+	mutex_unlock(&tracepoints_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tracepoint_probe_unregister_noupdate);
+
+/**
+ * tracepoint_probe_update_all -  update tracepoints
+ */
+void tracepoint_probe_update_all(void)
+{
+	LIST_HEAD(release_probes);
+	struct tp_probes *pos, *next;
+
+	mutex_lock(&tracepoints_mutex);
+	if (!need_update) {
+		mutex_unlock(&tracepoints_mutex);
+		return;
+	}
+	if (!list_empty(&old_probes))
+		list_replace_init(&old_probes, &release_probes);
+	need_update = 0;
+	mutex_unlock(&tracepoints_mutex);
+
+	tracepoint_update_probes();
+	list_for_each_entry_safe(pos, next, &release_probes, u.list) {
+		list_del(&pos->u.list);
+		call_rcu_sched(&pos->u.rcu, rcu_free_old_probes);
+	}
+}
+EXPORT_SYMBOL_GPL(tracepoint_probe_update_all);
+
 /**
  * tracepoint_get_iter_range - Get a next tracepoint iterator given a range.
  * @tracepoint: current tracepoints (in), next tracepoint (out)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
