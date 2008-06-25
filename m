Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYFYX5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYFYX5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYFYX50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:57:26 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:39503 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbYFYX5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:57:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiYFAB9yYkhMQWVt/2dsb2JhbACBW7Fk
Date: Wed, 25 Jun 2008 19:52:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: [RFC PATCH] Kernel Tracepoints
Message-ID: <20080625235214.GA14249@Krystal>
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48612879.5090809@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:49:38 up 21 days,  4:30,  3 users,  load average: 1.76, 1.58,
	1.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

** note : this patch is submitted for early review. It applies after my
current unreleased 2.6.26-rc8 LTTng patchset. Comments are welcome.

Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.

Allows complete typing verification. No format string required.

TODO : Documentation/tracepoint.txt

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    4 
 include/linux/module.h            |   17 +
 include/linux/tracepoint.h        |  154 +++++++++++
 init/Kconfig                      |    7 
 kernel/Makefile                   |    1 
 kernel/module.c                   |   71 +++++
 kernel/tracepoint.c               |  495 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 748 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc7-lttng/init/Kconfig
===================================================================
--- linux-2.6.26-rc7-lttng.orig/init/Kconfig	2008-06-25 18:11:05.000000000 -0400
+++ linux-2.6.26-rc7-lttng/init/Kconfig	2008-06-25 19:01:50.000000000 -0400
@@ -782,6 +782,13 @@
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
Index: linux-2.6.26-rc7-lttng/kernel/Makefile
===================================================================
--- linux-2.6.26-rc7-lttng.orig/kernel/Makefile	2008-06-25 18:11:04.000000000 -0400
+++ linux-2.6.26-rc7-lttng/kernel/Makefile	2008-06-25 19:01:50.000000000 -0400
@@ -69,6 +69,7 @@
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(USE_IMMEDIATE) += immediate.o
 obj-$(CONFIG_MARKERS) += marker.o
+obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
Index: linux-2.6.26-rc7-lttng/include/linux/tracepoint.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc7-lttng/include/linux/tracepoint.h	2008-06-25 19:04:17.000000000 -0400
@@ -0,0 +1,154 @@
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
+#include <linux/immediate.h>
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
+	DEFINE_IMV(char, state);	/* Immediate value state. */
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
+ * Make sure the alignment of the structure in the __markers section will
+ * not add unwanted padding between the beginning of the section and the
+ * structure. Force alignment to the same alignment as the section start.
+ *
+ * The "generic" argument controls which marker enabling mechanism must be used.
+ * If generic is true, a variable read is used.
+ * If generic is false, immediate values are used.
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
+	static inline void __trace_##name(int generic, proto)		\
+	{								\
+		static const char __tpstrtab_##name[]			\
+		__attribute__((section("__tracepoints_strings")))	\
+		= #name;						\
+		static struct tracepoint __tracepoint_##name		\
+		__attribute__((section("__tracepoints"), aligned(8))) =	\
+		{ __tpstrtab_##name, 0, NULL };				\
+		if (!generic) {						\
+			if (unlikely(imv_cond(__tracepoint_##name.state))) { \
+				imv_cond_end();				\
+				_do_trace_##name(&__tracepoint_##name, args); \
+			} else						\
+				imv_cond_end();				\
+		} else {						\
+			if (unlikely(_imv_read(__tracepoint_##name.state))) \
+				_do_trace_##name(&__tracepoint_##name, args); \
+		}							\
+	}								\
+	static inline void trace_##name(proto)				\
+	{								\
+		__trace_##name(0, args);				\
+	}								\
+	static inline void _trace_##name(proto)				\
+	{								\
+		__trace_##name(1, args);				\
+	}								\
+	static inline int register_trace_##name(			\
+		void (*probe)(void *private_data, proto),		\
+		void *private_data)					\
+	{								\
+		return tracepoint_probe_register(#name, (void *)probe,	\
+			private_data);					\
+	}								\
+	static inline void unregister_trace_##name(			\
+		void (*probe)(void *private_data, proto),		\
+		void *private_data)					\
+	{								\
+		tracepoint_probe_unregister(#name, (void *)probe,	\
+			private_data);					\
+	}
+
+extern void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end);
+
+#else /* !CONFIG_TRACEPOINTS */
+#define DEFINE_TRACE(name, proto, args)			\
+	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
+	{ }								\
+	static inline void __trace_##name(int generic, proto)		\
+	{ }								\
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline void _trace_##name(proto)				\
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
Index: linux-2.6.26-rc7-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.26-rc7-lttng.orig/include/asm-generic/vmlinux.lds.h	2008-06-25 18:11:04.000000000 -0400
+++ linux-2.6.26-rc7-lttng/include/asm-generic/vmlinux.lds.h	2008-06-25 18:11:05.000000000 -0400
@@ -53,6 +53,9 @@
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
 	VMLINUX_SYMBOL(__stop___markers) = .;				\
+	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
+	*(__tracepoints)						\
+	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
 	VMLINUX_SYMBOL(__start___imv) = .;				\
 	*(__imv)		/* Immediate values: pointers */ 	\
 	VMLINUX_SYMBOL(__stop___imv) = .;
@@ -68,6 +71,7 @@
 		*(__imv_cond_end) /* Immediate condition end pointers */\
 		VMLINUX_SYMBOL(__stop___imv_cond_end) = .;		\
 		*(__markers_strings)	/* Markers: strings */		\
+		*(__tracepoints_strings)/* Tracepoints: strings */	\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
Index: linux-2.6.26-rc7-lttng/kernel/tracepoint.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc7-lttng/kernel/tracepoint.c	2008-06-25 18:11:05.000000000 -0400
@@ -0,0 +1,495 @@
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
+	elem->state__imv = active;
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
+	elem->state__imv = 0;
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
+ * Will return the first tracepoint in the range if the input tracepoint is NULL.
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
Index: linux-2.6.26-rc7-lttng/kernel/module.c
===================================================================
--- linux-2.6.26-rc7-lttng.orig/kernel/module.c	2008-06-25 18:11:05.000000000 -0400
+++ linux-2.6.26-rc7-lttng/kernel/module.c	2008-06-25 18:11:05.000000000 -0400
@@ -48,6 +48,7 @@
 #include <linux/license.h>
 #include <asm/sections.h>
 #include <linux/marker.h>
+#include <linux/tracepoint.h>
 
 #if 0
 #define DEBUGP printk
@@ -1791,6 +1792,8 @@
 	unsigned int immediatecondendindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int tracepointsindex;
+	unsigned int tracepointsstringsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2083,6 +2086,9 @@
 	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
  	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
 					"__markers_strings");
+	tracepointsindex = find_sec(hdr, sechdrs, secstrings, "__tracepoints");
+ 	tracepointsstringsindex = find_sec(hdr, sechdrs, secstrings,
+					"__tracepoints_strings");
 
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -2110,6 +2116,12 @@
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
@@ -2133,8 +2145,16 @@
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
+#ifdef CONFIG_TRACEPOINTS
+		tracepoint_update_probe_range(mod->tracepoints,
+			mod->tracepoints + mod->num_tracepoints);
+#endif
+
 #ifdef USE_IMMEDIATE
-		/* Immediate values must be updated after markers */
+		/*
+		 * Immediate values must be updated after markers and
+		 * tracepoints.
+		 */
 		imv_update_range(mod->immediate,
 			mod->immediate + mod->num_immediate);
 #endif
@@ -2746,6 +2766,55 @@
 }
 #endif
 
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
+
+
+
 #ifdef USE_IMMEDIATE
 /**
  * _module_imv_update - update all immediate values in the kernel
Index: linux-2.6.26-rc7-lttng/include/linux/module.h
===================================================================
--- linux-2.6.26-rc7-lttng.orig/include/linux/module.h	2008-06-25 18:11:05.000000000 -0400
+++ linux-2.6.26-rc7-lttng/include/linux/module.h	2008-06-25 18:11:05.000000000 -0400
@@ -17,6 +17,7 @@
 #include <linux/moduleparam.h>
 #include <linux/immediate.h>
 #include <linux/marker.h>
+#include <linux/tracepoint.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -349,6 +350,10 @@
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
@@ -459,6 +464,9 @@
 extern void module_update_markers(void);
 extern int module_get_iter_markers(struct marker_iter *iter);
 
+extern void module_update_tracepoints(void);
+extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -568,6 +576,15 @@
 	return 0;
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
 
 #if defined(CONFIG_MODULES) && defined(USE_IMMEDIATE)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
