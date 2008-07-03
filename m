Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYGCQr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYGCQr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYGCQr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:47:26 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47895 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbYGCQrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:47:23 -0400
Message-Id: <20080703161102.721606976@polymtl.ca>
References: <20080703160526.637679319@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jul 2008 12:05:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [RFC patch 1/3] Kernel Tracepoints
Content-Disposition: inline; filename=tracepoints.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  3 Jul 2008 16:11:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.

Allows complete typing verification. No format string required.

TODO : Documentation/tracepoint.txt

Changelog :
- Use #name ":" #proto as string to identify the tracepoint in the
  tracepoint table. This will make sure not type mismatch happens due to
  connexion of a probe with the wrong type to a tracepoint declared with
  the same name in a different header.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
---
 include/asm-generic/vmlinux.lds.h |    6 
 include/linux/module.h            |   17 +
 include/linux/tracepoint.h        |  139 ++++++++++
 init/Kconfig                      |   16 +
 kernel/Makefile                   |    1 
 kernel/module.c                   |   66 ++++-
 kernel/tracepoint.c               |  498 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 741 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2008-07-03 11:47:15.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2008-07-03 11:49:54.000000000 -0400
@@ -782,12 +782,28 @@ config PROFILING
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.
 
+config TRACEPOINTS
+	bool "Activate tracepoints"
+	default y
+	help
+	  Place an empty function call at each tracepoint site. Can be
+	  dynamically changed for a probe function.
+
 config MARKERS
 	bool "Activate markers"
 	help
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
+config TRACEPROBES
+	tristate "Compile generic tracing probes"
+	depends on MARKERS
+	default y
+	help
+	  Compile generic tracing probes, which connect to the tracepoints when
+	  loaded and format the information collected by the tracepoints with
+	  the Markers.
+
 source "arch/Kconfig"
 
 config PROC_PAGE_MONITOR
Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2008-07-03 11:47:15.000000000 -0400
+++ linux-2.6-lttng/kernel/Makefile	2008-07-03 11:49:54.000000000 -0400
@@ -68,6 +68,7 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
+obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/tracepoint.h	2008-07-03 11:49:54.000000000 -0400
@@ -0,0 +1,139 @@
+#ifndef _LINUX_TRACEPOINT_H
+#define _LINUX_TRACEPOINT_H
+
+/*
+ * Kernel Tracepoint API.
+ *
+ * See Documentation/tracepoint.txt.
+ *
+ * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * Heavily inspired from the Linux Kernel Markers.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <linux/types.h>
+
+struct module;
+struct tracepoint;
+
+struct tracepoint_probe_closure {
+	void *func;			/* Callback */
+	void *probe_private;		/* Private probe data */
+};
+
+struct tracepoint {
+	const char *name;		/* Tracepoint name */
+	int state;			/* State. */
+	struct tracepoint_probe_closure *multi;	/* Closures */
+} __attribute__((aligned(8)));
+
+
+#define TPPROTO(args...)	args
+#define TPARGS(args...)		args
+
+#ifdef CONFIG_TRACEPOINTS
+
+/*
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug.
+ * Make sure the alignment of the structure in the __tracepoints section will
+ * not add unwanted padding between the beginning of the section and the
+ * structure. Force alignment to the same alignment as the section start.
+ */
+#define DEFINE_TRACE(name, proto, args)					\
+	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
+	{								\
+		int i;							\
+		struct tracepoint_probe_closure *multi;			\
+		preempt_disable();					\
+		multi = tp->multi;					\
+		smp_read_barrier_depends();				\
+		if (multi) {						\
+			for (i = 0; multi[i].func; i++) {		\
+				((void(*)(void *private_data, proto))	\
+				(multi[i].func))(multi[i].probe_private, args);\
+			}						\
+		}							\
+		preempt_enable();					\
+	}								\
+	static inline void trace_##name(proto)				\
+	{								\
+		static const char __tpstrtab_##name[]			\
+		__attribute__((section("__tracepoints_strings")))	\
+		= #name ":" #proto;					\
+		static struct tracepoint __tracepoint_##name		\
+		__attribute__((section("__tracepoints"), aligned(8))) =	\
+		{ __tpstrtab_##name, 0, NULL };				\
+		if (unlikely(__tracepoint_##name.state))		\
+			_do_trace_##name(&__tracepoint_##name, args);	\
+	}								\
+	static inline int register_trace_##name(			\
+		void (*probe)(void *private_data, proto),		\
+		void *private_data)					\
+	{								\
+		return tracepoint_probe_register(#name ":" #proto,	\
+			(void *)probe, private_data);			\
+	}								\
+	static inline void unregister_trace_##name(			\
+		void (*probe)(void *private_data, proto),		\
+		void *private_data)					\
+	{								\
+		tracepoint_probe_unregister(#name ":" #proto,		\
+			(void *)probe, private_data);			\
+	}
+
+extern void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end);
+
+#else /* !CONFIG_TRACEPOINTS */
+#define DEFINE_TRACE(name, proto, args)			\
+	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
+	{ }								\
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline int register_trace_##name(			\
+		void (*probe)(void *private_data, proto),		\
+		void *private_data)					\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline void unregister_trace_##name(			\
+		void (*probe)(void *private_data, proto),		\
+		void *private_data)					\
+	{ }
+
+static inline void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end)
+{ }
+#endif /* CONFIG_TRACEPOINTS */
+
+/*
+ * Connect a probe to a tracepoint.
+ * Internal API, should not be used directly.
+ */
+extern int tracepoint_probe_register(const char *name,
+	void *probe, void *probe_private);
+
+/*
+ * Disconnect a probe from a tracepoint.
+ * Internal API, should not be used directly.
+ */
+extern int tracepoint_probe_unregister(const char *name,
+	void *probe, void *probe_private);
+
+struct tracepoint_iter {
+	struct module *module;
+	struct tracepoint *tracepoint;
+};
+
+extern void tracepoint_iter_start(struct tracepoint_iter *iter);
+extern void tracepoint_iter_next(struct tracepoint_iter *iter);
+extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
+extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
+extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
+	struct tracepoint *begin, struct tracepoint *end);
+
+#endif
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2008-07-03 11:47:15.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2008-07-03 11:49:54.000000000 -0400
@@ -52,7 +52,10 @@
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
-	VMLINUX_SYMBOL(__stop___markers) = .;
+	VMLINUX_SYMBOL(__stop___markers) = .;				\
+	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
+	*(__tracepoints)						\
+	VMLINUX_SYMBOL(__stop___tracepoints) = .;
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
@@ -61,6 +64,7 @@
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
+		*(__tracepoints_strings)/* Tracepoints: strings */	\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
Index: linux-2.6-lttng/kernel/tracepoint.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/tracepoint.c	2008-07-03 11:54:30.000000000 -0400
@@ -0,0 +1,498 @@
+/*
+ * Copyright (C) 2007 Mathieu Desnoyers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <linux/jhash.h>
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/tracepoint.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/immediate.h>
+
+extern struct tracepoint __start___tracepoints[];
+extern struct tracepoint __stop___tracepoints[];
+
+/* Set to 1 to enable tracepoint debug output */
+static const int tracepoint_debug;
+
+/*
+ * tracepoints_mutex nests inside module_mutex. Tracepoints mutex protects the
+ * builtin and module tracepoints and the hash table.
+ */
+static DEFINE_MUTEX(tracepoints_mutex);
+
+/*
+ * Tracepoint hash table, containing the active tracepoints.
+ * Protected by tracepoints_mutex.
+ */
+#define TRACEPOINT_HASH_BITS 6
+#define TRACEPOINT_TABLE_SIZE (1 << TRACEPOINT_HASH_BITS)
+
+/*
+ * Note about RCU :
+ * It is used to make sure every handler has finished using its private data
+ * between two consecutive operation (add or remove) on a given tracepoint.  It
+ * is also used to delay the free of multiple probes array until a quiescent
+ * state is reached.
+ * tracepoint entries modifications are protected by the tracepoints_mutex.
+ */
+struct tracepoint_entry {
+	struct hlist_node hlist;
+	struct tracepoint_probe_closure *multi;
+	int refcount;	/* Number of times armed. 0 if disarmed. */
+	struct rcu_head rcu;
+	void *oldptr;
+	unsigned char rcu_pending:1;
+	char name[0];
+};
+
+static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
+
+static void free_old_closure(struct rcu_head *head)
+{
+	struct tracepoint_entry *entry = container_of(head,
+		struct tracepoint_entry, rcu);
+	kfree(entry->oldptr);
+	/* Make sure we free the data before setting the pending flag to 0 */
+	smp_wmb();
+	entry->rcu_pending = 0;
+}
+
+static void debug_print_probes(struct tracepoint_entry *entry)
+{
+	int i;
+
+	if (!tracepoint_debug)
+		return;
+
+	for (i = 0; entry->multi[i].func; i++)
+		printk(KERN_DEBUG "Multi probe %d : %p %p\n", i,
+			entry->multi[i].func,
+			entry->multi[i].probe_private);
+}
+
+static struct tracepoint_probe_closure *
+tracepoint_entry_add_probe(struct tracepoint_entry *entry,
+		void *probe, void *probe_private)
+{
+	int nr_probes = 0;
+	struct tracepoint_probe_closure *old, *new;
+
+	WARN_ON(!probe);
+
+	debug_print_probes(entry);
+	old = entry->multi;
+	if (old) {
+		/* (N -> N+1), (N != 0, 1) probes */
+		for (nr_probes = 0; old[nr_probes].func; nr_probes++)
+			if (old[nr_probes].func == probe
+					&& old[nr_probes].probe_private
+						== probe_private)
+				return ERR_PTR(-EBUSY);
+	}
+	/* + 2 : one for new probe, one for NULL func */
+	new = kzalloc((nr_probes + 2) * sizeof(struct tracepoint_probe_closure),
+			GFP_KERNEL);
+	if (new == NULL)
+		return ERR_PTR(-ENOMEM);
+	if (old)
+		memcpy(new, old,
+			nr_probes * sizeof(struct tracepoint_probe_closure));
+	new[nr_probes].func = probe;
+	new[nr_probes].probe_private = probe_private;
+	entry->refcount = nr_probes + 1;
+	entry->multi = new;
+	debug_print_probes(entry);
+	return old;
+}
+
+static struct tracepoint_probe_closure *
+tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
+		void *probe, void *probe_private)
+{
+	int nr_probes = 0, nr_del = 0, i;
+	struct tracepoint_probe_closure *old, *new;
+
+	old = entry->multi;
+
+	debug_print_probes(entry);
+	/* (N -> M), (N > 1, M >= 0) probes */
+	for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
+		if ((!probe || old[nr_probes].func == probe)
+				&& old[nr_probes].probe_private
+					== probe_private)
+			nr_del++;
+	}
+
+	if (nr_probes - nr_del == 0) {
+		/* N -> 0, (N > 1) */
+		entry->multi = NULL;
+		entry->refcount = 0;
+		debug_print_probes(entry);
+		return old;
+	} else {
+		int j = 0;
+		/* N -> M, (N > 1, M > 0) */
+		/* + 1 for NULL */
+		new = kzalloc((nr_probes - nr_del + 1)
+			* sizeof(struct tracepoint_probe_closure), GFP_KERNEL);
+		if (new == NULL)
+			return ERR_PTR(-ENOMEM);
+		for (i = 0; old[i].func; i++)
+			if ((probe && old[i].func != probe) ||
+					old[i].probe_private != probe_private)
+				new[j++] = old[i];
+		entry->refcount = nr_probes - nr_del;
+		entry->multi = new;
+	}
+	debug_print_probes(entry);
+	return old;
+}
+
+/*
+ * Get tracepoint if the tracepoint is present in the tracepoint hash table.
+ * Must be called with tracepoints_mutex held.
+ * Returns NULL if not present.
+ */
+static struct tracepoint_entry *get_tracepoint(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct tracepoint_entry *e;
+	u32 hash = jhash(name, strlen(name), 0);
+
+	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name))
+			return e;
+	}
+	return NULL;
+}
+
+/*
+ * Add the tracepoint to the tracepoint hash table. Must be called with
+ * tracepoints_mutex held.
+ */
+static struct tracepoint_entry *add_tracepoint(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct tracepoint_entry *e;
+	size_t name_len = strlen(name) + 1;
+	u32 hash = jhash(name, name_len-1, 0);
+
+	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name)) {
+			printk(KERN_NOTICE
+				"tracepoint %s busy\n", name);
+			return ERR_PTR(-EBUSY);	/* Already there */
+		}
+	}
+	/*
+	 * Using kmalloc here to allocate a variable length element. Could
+	 * cause some memory fragmentation if overused.
+	 */
+	e = kmalloc(sizeof(struct tracepoint_entry) + name_len, GFP_KERNEL);
+	if (!e)
+		return ERR_PTR(-ENOMEM);
+	memcpy(&e->name[0], name, name_len);
+	e->multi = NULL;
+	e->refcount = 0;
+	e->rcu_pending = 0;
+	hlist_add_head(&e->hlist, head);
+	return e;
+}
+
+/*
+ * Remove the tracepoint from the tracepoint hash table. Must be called with
+ * mutex_lock held.
+ */
+static int remove_tracepoint(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct tracepoint_entry *e;
+	int found = 0;
+	size_t len = strlen(name) + 1;
+	u32 hash = jhash(name, len-1, 0);
+
+	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name)) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found)
+		return -ENOENT;
+	if (e->refcount)
+		return -EBUSY;
+	hlist_del(&e->hlist);
+	/* Make sure the call_rcu has been executed */
+	if (e->rcu_pending)
+		rcu_barrier();
+	kfree(e);
+	return 0;
+}
+
+/*
+ * Sets the probe callback corresponding to one tracepoint.
+ */
+static void set_tracepoint(struct tracepoint_entry **entry,
+	struct tracepoint *elem, int active)
+{
+	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
+
+	smp_wmb();
+	/*
+	 * We also make sure that the new probe callbacks array is consistent
+	 * before setting a pointer to it.
+	 */
+	rcu_assign_pointer(elem->multi, (*entry)->multi);
+	elem->state = active;
+}
+
+/*
+ * Disable a tracepoint and its probe callback.
+ * Note: only waiting an RCU period after setting elem->call to the empty
+ * function insures that the original callback is not used anymore. This insured
+ * by preempt_disable around the call site.
+ */
+static void disable_tracepoint(struct tracepoint *elem)
+{
+	elem->state = 0;
+}
+
+/**
+ * tracepoint_update_probe_range - Update a probe range
+ * @begin: beginning of the range
+ * @end: end of the range
+ *
+ * Updates the probe callback corresponding to a range of tracepoints.
+ */
+void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end)
+{
+	struct tracepoint *iter;
+	struct tracepoint_entry *mark_entry;
+
+	mutex_lock(&tracepoints_mutex);
+	for (iter = begin; iter < end; iter++) {
+		mark_entry = get_tracepoint(iter->name);
+		if (mark_entry) {
+			set_tracepoint(&mark_entry, iter,
+					!!mark_entry->refcount);
+		} else {
+			disable_tracepoint(iter);
+		}
+	}
+	mutex_unlock(&tracepoints_mutex);
+}
+
+/*
+ * Update probes, removing the faulty probes.
+ */
+static void tracepoint_update_probes(void)
+{
+	/* Core kernel tracepoints */
+	tracepoint_update_probe_range(__start___tracepoints,
+		__stop___tracepoints);
+	/* tracepoints in modules. */
+	module_update_tracepoints();
+	/* Update immediate values */
+	core_imv_update();
+	module_imv_update();
+}
+
+/**
+ * tracepoint_probe_register -  Connect a probe to a tracepoint
+ * @name: tracepoint name
+ * @probe: probe handler
+ * @probe_private: probe private data
+ *
+ * private data must be a valid allocated memory address, or NULL.
+ * Returns 0 if ok, error value on error.
+ * The probe address must at least be aligned on the architecture pointer size.
+ */
+int tracepoint_probe_register(const char *name,
+			void *probe, void *probe_private)
+{
+	struct tracepoint_entry *entry;
+	int ret = 0;
+	struct tracepoint_probe_closure *old;
+
+	mutex_lock(&tracepoints_mutex);
+	entry = get_tracepoint(name);
+	if (!entry) {
+		entry = add_tracepoint(name);
+		if (IS_ERR(entry)) {
+			ret = PTR_ERR(entry);
+			goto end;
+		}
+	}
+	/*
+	 * If we detect that a call_rcu is pending for this tracepoint,
+	 * make sure it's executed now.
+	 */
+	if (entry->rcu_pending)
+		rcu_barrier();
+	old = tracepoint_entry_add_probe(entry, probe, probe_private);
+	if (IS_ERR(old)) {
+		ret = PTR_ERR(old);
+		goto end;
+	}
+	mutex_unlock(&tracepoints_mutex);
+	tracepoint_update_probes();		/* may update entry */
+	mutex_lock(&tracepoints_mutex);
+	entry = get_tracepoint(name);
+	WARN_ON(!entry);
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
+	call_rcu(&entry->rcu, free_old_closure);
+end:
+	mutex_unlock(&tracepoints_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tracepoint_probe_register);
+
+/**
+ * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
+ * @name: tracepoint name
+ * @probe: probe function pointer
+ * @probe_private: probe private data
+ *
+ * Returns the private data given to tracepoint_probe_register, or an ERR_PTR().
+ * We do not need to call a synchronize_sched to make sure the probes have
+ * finished running before doing a module unload, because the module unload
+ * itself uses stop_machine(), which insures that every preempt disabled section
+ * have finished.
+ */
+int tracepoint_probe_unregister(const char *name,
+	void *probe, void *probe_private)
+{
+	struct tracepoint_entry *entry;
+	struct tracepoint_probe_closure *old;
+	int ret = -ENOENT;
+
+	mutex_lock(&tracepoints_mutex);
+	entry = get_tracepoint(name);
+	if (!entry)
+		goto end;
+	if (entry->rcu_pending)
+		rcu_barrier();
+	old = tracepoint_entry_remove_probe(entry, probe, probe_private);
+	mutex_unlock(&tracepoints_mutex);
+	tracepoint_update_probes();		/* may update entry */
+	mutex_lock(&tracepoints_mutex);
+	entry = get_tracepoint(name);
+	if (!entry)
+		goto end;
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
+	call_rcu(&entry->rcu, free_old_closure);
+	remove_tracepoint(name);	/* Ignore busy error message */
+	ret = 0;
+end:
+	mutex_unlock(&tracepoints_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tracepoint_probe_unregister);
+
+/**
+ * tracepoint_get_iter_range - Get a next tracepoint iterator given a range.
+ * @tracepoint: current tracepoints (in), next tracepoint (out)
+ * @begin: beginning of the range
+ * @end: end of the range
+ *
+ * Returns whether a next tracepoint has been found (1) or not (0).
+ * Will return the first tracepoint in the range if the input tracepoint is
+ * NULL.
+ */
+int tracepoint_get_iter_range(struct tracepoint **tracepoint,
+	struct tracepoint *begin, struct tracepoint *end)
+{
+	if (!*tracepoint && begin != end) {
+		*tracepoint = begin;
+		return 1;
+	}
+	if (*tracepoint >= begin && *tracepoint < end)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tracepoint_get_iter_range);
+
+static void tracepoint_get_iter(struct tracepoint_iter *iter)
+{
+	int found = 0;
+
+	/* Core kernel tracepoints */
+	if (!iter->module) {
+		found = tracepoint_get_iter_range(&iter->tracepoint,
+				__start___tracepoints, __stop___tracepoints);
+		if (found)
+			goto end;
+	}
+	/* tracepoints in modules. */
+	found = module_get_iter_tracepoints(iter);
+end:
+	if (!found)
+		tracepoint_iter_reset(iter);
+}
+
+void tracepoint_iter_start(struct tracepoint_iter *iter)
+{
+	tracepoint_get_iter(iter);
+}
+EXPORT_SYMBOL_GPL(tracepoint_iter_start);
+
+void tracepoint_iter_next(struct tracepoint_iter *iter)
+{
+	iter->tracepoint++;
+	/*
+	 * iter->tracepoint may be invalid because we blindly incremented it.
+	 * Make sure it is valid by marshalling on the tracepoints, getting the
+	 * tracepoints from following modules if necessary.
+	 */
+	tracepoint_get_iter(iter);
+}
+EXPORT_SYMBOL_GPL(tracepoint_iter_next);
+
+void tracepoint_iter_stop(struct tracepoint_iter *iter)
+{
+}
+EXPORT_SYMBOL_GPL(tracepoint_iter_stop);
+
+void tracepoint_iter_reset(struct tracepoint_iter *iter)
+{
+	iter->module = NULL;
+	iter->tracepoint = NULL;
+}
+EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2008-07-03 11:49:54.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2008-07-03 11:54:01.000000000 -0400
@@ -46,6 +46,7 @@
 #include <asm/cacheflush.h>
 #include <linux/license.h>
 #include <asm/sections.h>
+#include <linux/tracepoint.h>
 
 #if 0
 #define DEBUGP printk
@@ -1770,6 +1771,8 @@ static struct module *load_module(void _
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int tracepointsindex;
+	unsigned int tracepointsstringsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2049,6 +2052,9 @@ static struct module *load_module(void _
 	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
  	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
 					"__markers_strings");
+	tracepointsindex = find_sec(hdr, sechdrs, secstrings, "__tracepoints");
+	tracepointsstringsindex = find_sec(hdr, sechdrs, secstrings,
+					"__tracepoints_strings");
 
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -2076,6 +2082,12 @@ static struct module *load_module(void _
 	mod->num_markers =
 		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif
+#ifdef CONFIG_TRACEPOINTS
+	mod->tracepoints = (void *)sechdrs[tracepointsindex].sh_addr;
+	mod->num_tracepoints =
+		sechdrs[tracepointsindex].sh_size / sizeof(*mod->tracepoints);
+#endif
+
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2094,11 +2106,16 @@ static struct module *load_module(void _
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
+	if (!(mod->taints & TAINT_FORCED_MODULE)) {
 #ifdef CONFIG_MARKERS
-	if (!(mod->taints & TAINT_FORCED_MODULE))
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
+#ifdef CONFIG_TRACEPOINTS
+		tracepoint_update_probe_range(mod->tracepoints,
+			mod->tracepoints + mod->num_tracepoints);
+#endif
+	}
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -2646,3 +2663,50 @@ void module_update_markers(void)
 	mutex_unlock(&module_mutex);
 }
 #endif
+
+#ifdef CONFIG_TRACEPOINTS
+void module_update_tracepoints(void)
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list)
+		if (!mod->taints)
+			tracepoint_update_probe_range(mod->tracepoints,
+				mod->tracepoints + mod->num_tracepoints);
+	mutex_unlock(&module_mutex);
+}
+
+/*
+ * Returns 0 if current not found.
+ * Returns 1 if current found.
+ */
+int module_get_iter_tracepoints(struct tracepoint_iter *iter)
+{
+	struct module *iter_mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(iter_mod, &modules, list) {
+		if (!iter_mod->taints) {
+			/*
+			 * Sorted module list
+			 */
+			if (iter_mod < iter->module)
+				continue;
+			else if (iter_mod > iter->module)
+				iter->tracepoint = NULL;
+			found = tracepoint_get_iter_range(&iter->tracepoint,
+				iter_mod->tracepoints,
+				iter_mod->tracepoints
+					+ iter_mod->num_tracepoints);
+			if (found) {
+				iter->module = iter_mod;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+#endif
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2008-07-03 11:47:15.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2008-07-03 11:49:54.000000000 -0400
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/marker.h>
+#include <linux/tracepoint.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -342,6 +343,10 @@ struct module
 	struct marker *markers;
 	unsigned int num_markers;
 #endif
+#ifdef CONFIG_TRACEPOINTS
+	struct tracepoint *tracepoints;
+	unsigned int num_tracepoints;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
@@ -450,6 +455,9 @@ extern void print_modules(void);
 
 extern void module_update_markers(void);
 
+extern void module_update_tracepoints(void);
+extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -554,6 +562,15 @@ static inline void module_update_markers
 {
 }
 
+static inline void module_update_tracepoints(void)
+{
+}
+
+static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MODULES */
 
 struct device_driver;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
