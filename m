Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbYJ3X1C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbYJ3X1C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:27:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYJ3X0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:26:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbYJ3X0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:26:52 -0400
Date: Fri, 31 Oct 2008 00:26:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracepoint: introduce *_noupdate APIs.
Message-ID: <20081030232638.GA12778@elte.hu>
References: <49067E49.4040304@cn.fujitsu.com> <20081030053457.GB27381@Krystal> <20081030053949.GC27381@Krystal> <20081030231419.GA1985@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081030231419.GA1985@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> (Note, i had to resolve conflicts, hopefully i got the end result 
> right. Please double-check tip/master.)

hm, it didnt work out. Below are the merged up commits against 
tip/master, but they cause this build failure:

 kernel/tracepoint.c: In function ‘tracepoint_probe_unregister’:
 kernel/tracepoint.c:380: error: label ‘end’ used but not defined

could you please resend against tip/master:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo

-------------->
commit 57bc8ea87d534303374932191273bdd3f3c37d09
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Tue Oct 28 10:51:53 2008 +0800

    tracepoint: introduce *_noupdate APIs.
    
    Impact: add new tracepoint APIs to allow the batched registration of probes
    
    new APIs separate tracepoint_probe_register(),
    tracepoint_probe_unregister() into 2 steps. The first step of them
    is just update tracepoint_entry, not connect or disconnect.
    
    this patch introduces tracepoint_probe_update_all() for update all.
    
    these APIs are very useful for registering lots of probes
    but just updating once. Another very important thing is that
    *_noupdate APIs do not require module_mutex.
    
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

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
index 4159c2a..c39bdbc 100644
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
 
@@ -299,6 +302,23 @@ static void tracepoint_update_probes(void)
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
@@ -309,36 +329,36 @@ static void tracepoint_update_probes(void)
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
@@ -351,36 +371,110 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register);
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
 	if (!old) {
 		printk(KERN_WARNING "Warning: Trying to unregister a probe"
 				    "that doesn't exist\n");
 		goto end;
 	}
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

commit bbec237d365b96ed6f5f372f1b090af374609059
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Tue Oct 28 10:51:49 2008 +0800

    tracepoint: simplification for tracepoints using RCU
    
    Impact: simplify implementation
    
    Now, unused memory is handled by struct tp_probes.
    
    old code use these three field to handle unused memory.
    struct tracepoint_entry {
    	...
    	struct rcu_head rcu;
    	void *oldptr;
    	unsigned char rcu_pending:1;
    	...
    };
    
    in this way, unused memory is handled by struct tracepoint_entry.
    it bring reenter bug(it was fixed) and tracepoint.c is filled
    full of ".*rcu.*" code statements. this patch removes all these.
    
    and:
      rcu_barrier_sched() is removed.
      Do not need regain tracepoints_mutex after tracepoint_update_probes()
      several little cleanup.
    
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index af8c856..4159c2a 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -43,6 +43,7 @@ static DEFINE_MUTEX(tracepoints_mutex);
  */
 #define TRACEPOINT_HASH_BITS 6
 #define TRACEPOINT_TABLE_SIZE (1 << TRACEPOINT_HASH_BITS)
+static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
 
 /*
  * Note about RCU :
@@ -54,40 +55,40 @@ struct tracepoint_entry {
 	struct hlist_node hlist;
 	void **funcs;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
-	struct rcu_head rcu;
-	void *oldptr;
-	unsigned char rcu_pending:1;
 	char name[0];
 };
 
-static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
+struct tp_probes {
+	struct rcu_head rcu;
+	void *probes[0];
+};
 
-static void free_old_closure(struct rcu_head *head)
+static inline void *allocate_probes(int count)
 {
-	struct tracepoint_entry *entry = container_of(head,
-		struct tracepoint_entry, rcu);
-	kfree(entry->oldptr);
-	/* Make sure we free the data before setting the pending flag to 0 */
-	smp_wmb();
-	entry->rcu_pending = 0;
+	struct tp_probes *p  = kmalloc(count * sizeof(void *)
+			+ sizeof(struct tp_probes), GFP_KERNEL);
+	return p == NULL ? NULL : p->probes;
 }
 
-static void tracepoint_entry_free_old(struct tracepoint_entry *entry, void *old)
+static void rcu_free_old_probes(struct rcu_head *head)
 {
-	if (!old)
-		return;
-	entry->oldptr = old;
-	entry->rcu_pending = 1;
-	/* write rcu_pending before calling the RCU callback */
-	smp_wmb();
-	call_rcu_sched(&entry->rcu, free_old_closure);
+	kfree(container_of(head, struct tp_probes, rcu));
+}
+
+static inline void release_probes(void *old)
+{
+	if (old) {
+		struct tp_probes *tp_probes = container_of(old,
+			struct tp_probes, probes[0]);
+		call_rcu(&tp_probes->rcu, rcu_free_old_probes);
+	}
 }
 
 static void debug_print_probes(struct tracepoint_entry *entry)
 {
 	int i;
 
-	if (!tracepoint_debug)
+	if (!tracepoint_debug || !entry->funcs)
 		return;
 
 	for (i = 0; entry->funcs[i]; i++)
@@ -111,12 +112,13 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
 				return ERR_PTR(-EEXIST);
 	}
 	/* + 2 : one for new probe, one for NULL func */
-	new = kzalloc((nr_probes + 2) * sizeof(void *), GFP_KERNEL);
+	new = allocate_probes(nr_probes + 2);
 	if (new == NULL)
 		return ERR_PTR(-ENOMEM);
 	if (old)
 		memcpy(new, old, nr_probes * sizeof(void *));
 	new[nr_probes] = probe;
+	new[nr_probes + 1] = NULL;
 	entry->refcount = nr_probes + 1;
 	entry->funcs = new;
 	debug_print_probes(entry);
@@ -151,13 +153,13 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
 		int j = 0;
 		/* N -> M, (N > 1, M > 0) */
 		/* + 1 for NULL */
-		new = kzalloc((nr_probes - nr_del + 1)
-			* sizeof(void *), GFP_KERNEL);
+		new = allocate_probes(nr_probes - nr_del + 1);
 		if (new == NULL)
 			return ERR_PTR(-ENOMEM);
 		for (i = 0; old[i]; i++)
 			if ((probe && old[i] != probe))
 				new[j++] = old[i];
+		new[nr_probes - nr_del] = NULL;
 		entry->refcount = nr_probes - nr_del;
 		entry->funcs = new;
 	}
@@ -215,7 +217,6 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
 	memcpy(&e->name[0], name, name_len);
 	e->funcs = NULL;
 	e->refcount = 0;
-	e->rcu_pending = 0;
 	hlist_add_head(&e->hlist, head);
 	return e;
 }
@@ -224,32 +225,10 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
  * Remove the tracepoint from the tracepoint hash table. Must be called with
  * mutex_lock held.
  */
-static int remove_tracepoint(const char *name)
+static inline void remove_tracepoint(struct tracepoint_entry *e)
 {
-	struct hlist_head *head;
-	struct hlist_node *node;
-	struct tracepoint_entry *e;
-	int found = 0;
-	size_t len = strlen(name) + 1;
-	u32 hash = jhash(name, len-1, 0);
-
-	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
-		if (!strcmp(name, e->name)) {
-			found = 1;
-			break;
-		}
-	}
-	if (!found)
-		return -ENOENT;
-	if (e->refcount)
-		return -EBUSY;
 	hlist_del(&e->hlist);
-	/* Make sure the call_rcu_sched has been executed */
-	if (e->rcu_pending)
-		rcu_barrier_sched();
 	kfree(e);
-	return 0;
 }
 
 /*
@@ -343,25 +322,17 @@ int tracepoint_probe_register(const char *name, void *probe)
 			goto end;
 		}
 	}
-	/*
-	 * If we detect that a call_rcu_sched is pending for this tracepoint,
-	 * make sure it's executed now.
-	 */
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
 	old = tracepoint_entry_add_probe(entry, probe);
 	if (IS_ERR(old)) {
+		if (!entry->refcount)
+			remove_tracepoint(entry);
 		ret = PTR_ERR(old);
 		goto end;
 	}
 	mutex_unlock(&tracepoints_mutex);
 	tracepoint_update_probes();		/* may update entry */
-	mutex_lock(&tracepoints_mutex);
-	entry = get_tracepoint(name);
-	WARN_ON(!entry);
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
-	tracepoint_entry_free_old(entry, old);
+	release_probes(old);
+	return 0;
 end:
 	mutex_unlock(&tracepoints_mutex);
 	return ret;
@@ -388,25 +359,22 @@ int tracepoint_probe_unregister(const char *name, void *probe)
 	entry = get_tracepoint(name);
 	if (!entry)
 		goto end;
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
 	old = tracepoint_entry_remove_probe(entry, probe);
 	if (!old) {
 		printk(KERN_WARNING "Warning: Trying to unregister a probe"
 				    "that doesn't exist\n");
 		goto end;
 	}
+	if (IS_ERR(old)) {
+		ret = PTR_ERR(old);
+		goto end;
+	}
+	if (!entry->refcount)
+		remove_tracepoint(entry);
 	mutex_unlock(&tracepoints_mutex);
 	tracepoint_update_probes();		/* may update entry */
-	mutex_lock(&tracepoints_mutex);
-	entry = get_tracepoint(name);
-	if (!entry)
-		goto end;
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
-	tracepoint_entry_free_old(entry, old);
-	remove_tracepoint(name);	/* Ignore busy error message */
-	ret = 0;
+	release_probes(old);
+	return 0;
 end:
 	mutex_unlock(&tracepoints_mutex);
 	return ret;
