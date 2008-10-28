Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbYJ1Czk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbYJ1Czk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 22:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYJ1CzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 22:55:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53821 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbYJ1CzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 22:55:01 -0400
Message-ID: <49067E49.4040304@cn.fujitsu.com>
Date: Tue, 28 Oct 2008 10:51:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracepoint: introduce *_noupdate APIs.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index c5bb39c..63064e9 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -112,6 +112,10 @@ extern int tracepoint_probe_register(const char *name, void *probe);
  */
 extern int tracepoint_probe_unregister(const char *name, void *probe);
 
+extern int tracepoint_probe_register_noupdate(const char *name, void *probe);
+extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe);
+extern void tracepoint_probe_update_all(void);
+
 struct tracepoint_iter {
 	struct module *module;
 	struct tracepoint *tracepoint;
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 76d4571..f81902b 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
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
 
@@ -72,7 +75,7 @@ static inline void *allocate_probes(int count)
 
 static void rcu_free_old_probes(struct rcu_head *head)
 {
-	kfree(container_of(head, struct tp_probes, rcu));
+	kfree(container_of(head, struct tp_probes, u.rcu));
 }
 
 static inline void release_probes(void *old)
@@ -80,7 +83,7 @@ static inline void release_probes(void *old)
 	if (old) {
 		struct tp_probes *tp_probes = container_of(old,
 			struct tp_probes, probes[0]);
-		call_rcu(&tp_probes->rcu, rcu_free_old_probes);
+		call_rcu_sched(&tp_probes->u.rcu, rcu_free_old_probes);
 	}
 }
 
@@ -296,6 +299,23 @@ static void tracepoint_update_probes(void)
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
@@ -306,36 +326,36 @@ static void tracepoint_update_probes(void)
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
@@ -348,31 +368,105 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register);
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


