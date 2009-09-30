Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZI3KL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZI3KL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 06:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZI3KL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 06:11:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47091 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZI3KLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:11:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 30 Sep 2009 19:09:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 1/2] percpu array counter like vmstat
Message-Id: <20090930190943.8f19c48b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090930190417.8823fa44.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090930190417.8823fa44.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for implemening percpu counter of array. Unlike percpu counter,
this one's design is based on vm_stat[], an array counter for zone statistics.
It's an array of percpu counter.

The user can define counter array as
	struct foobar {
		.....
		DEFINE_ARRAY_COUNTER(name, NR_ELEMENTS);
		....
	}
and there will be array of counter, which has NR_ELEMENTS of size.

And, a macro GET_ARC() is provided. Users can read this counter by

	array_counter_read(GET_ARC(&foobar.name), NAME_OF_ELEMENT)

can add a value be
	array_counter_add(GET_ARC(&foobar.name), NAME_OF_ELEMENT, val)

My first purpose for writing this is replacing memcg's private percpu
counter array with this. (Then, memcg can use generic percpu object.)

I placed this counter in the same files of lib/percpu_counter

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/percpu_counter.h |  108 +++++++++++++++++++++++++++++++++++++++++
 lib/percpu_counter.c           |   83 +++++++++++++++++++++++++++++++
 2 files changed, 191 insertions(+)

Index: mmotm-2.6.31-Sep28/include/linux/percpu_counter.h
===================================================================
--- mmotm-2.6.31-Sep28.orig/include/linux/percpu_counter.h
+++ mmotm-2.6.31-Sep28/include/linux/percpu_counter.h
@@ -77,6 +77,67 @@ static inline s64 percpu_counter_read_po
 	return 1;
 }
 
+/*
+ * A counter for implementing counter array as vmstat[]. Usage and behavior
+ * is similar to percpu_counter but good for handle multiple statistics. The
+ * idea is from vmstat[] array implementation. atomic_long_t implies this is
+ * a 32bit counter on 32bit architecture and this is intentional. If you want
+ * 64bit, please use percpu_counter. This will not provide a function like
+ * percpu_counter_sum() function.
+ *
+ * For avoiding unnecessary access, it's recommended to use this via macro.
+ * You can use this counter as following in a struct.
+ *
+ *  struct xxxx {
+ *    ......
+ *   DEFINE_ARRAY_COUTER(coutner, NR_MY_ELEMENTS);
+ *    .....
+ *  };
+ * Then, you can define your array within above struct xxxx.
+ * In many case, address of counter(idx) can be calculated by compiler, easily.
+ *
+ * To access this, GET_ARC() macro is provided. This can be used in
+ * following style.
+ *    array_counter_add(GET_ARC(&object->coutner), idx, num);
+ *    array_counter_read(GET_ARC(&object->counter), idx)
+ */
+
+struct pad_array_counter { /* Don't use this struct directly */
+	s8 batch;
+	s8 *counters;
+#ifdef CONFIG_HOTPLUG_CPU
+	struct list_head list;
+#endif
+	int elements;
+} ____cacheline_aligned_in_smp;
+
+struct array_counter {
+	struct pad_array_counter v;
+	atomic_long_t	counters[0];
+};
+/* For static size definitions */
+
+#define DEFINE_ARRAY_COUNTER(name, elements) \
+	struct {\
+		struct array_counter ac;\
+		long __counters[(elements)];} name;
+
+#define GET_ARC(x)	(&(x)->ac)
+
+#define INIT_ARC(x,s) do {		\
+	memset((x), 0, sizeof(*(x)));	\
+	array_counter_init(&(x)->ac, (s));\
+}
+
+extern int array_counter_init(struct array_counter *ac, int size);
+extern void array_counter_destroy(struct array_counter *ac);
+extern void array_counter_add(struct array_counter *ac, int idx, int val);
+
+static inline long array_counter_read(struct array_counter *ac,int idx)
+{
+	return atomic_long_read(&ac->counters[idx]);
+}
+
 #else
 
 struct percpu_counter {
@@ -129,6 +190,44 @@ static inline s64 percpu_counter_sum(str
 	return percpu_counter_read(fbc);
 }
 
+struct array_counter {
+	int elmements;
+	long counters[0];
+};
+/* For static size definitions (please see CONFIG_SMP case) */
+#define DEFINE_ARRAY_COUNTER(name, elements) \
+	struct {\
+		struct array_counter ac;
+		long __counters[elements];\
+	}name;
+#define GET_ARC(x)	(&(x)->ac)
+#define INIT_ARC(x,s) do {		\
+	memset((x), 0, sizeof(*(x)));	\
+	array_counter_init(&(x)->ac, (s));\
+}
+
+static inline void
+array_counter_init(struct array_counter *ac, int size)
+{
+	ac->elements = size;
+}
+static inline void array_counter_destroy(struct array_counter *ac)
+{
+	/* nothing to do */
+}
+
+static inline
+void array_counter_add(struct array_counter *ac, int idx, int val)
+{
+	ac->counter[idx] += val;
+}
+
+static inline
+void array_coutner_read(struct array_counter *ac, int idx)
+{
+	return ac->counter[idx];
+}
+
 #endif	/* CONFIG_SMP */
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
@@ -146,4 +245,13 @@ static inline void percpu_counter_sub(st
 	percpu_counter_add(fbc, -amount);
 }
 
+static inline void array_counter_inc(struct array_counter *ac, int idx)
+{
+	array_counter_add(ac, idx, 1);
+}
+
+static inline void array_counter_dec(struct array_counter *ac, int idx)
+{
+	array_counter_add(ac, idx, -1);
+}
 #endif /* _LINUX_PERCPU_COUNTER_H */
Index: mmotm-2.6.31-Sep28/lib/percpu_counter.c
===================================================================
--- mmotm-2.6.31-Sep28.orig/lib/percpu_counter.c
+++ mmotm-2.6.31-Sep28/lib/percpu_counter.c
@@ -144,3 +144,86 @@ static int __init percpu_counter_startup
 	return 0;
 }
 module_init(percpu_counter_startup);
+
+
+static LIST_HEAD(array_counters);
+static DEFINE_MUTEX(array_counters_lock);
+
+int array_counter_init(struct array_counter *ac, int size)
+{
+	ac->v.elements = size;
+	ac->v.counters = alloc_percpu(s8);
+	if (!ac->v.counters)
+		return -ENOMEM;
+	ac->v.batch = percpu_counter_batch;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	mutex_lock(&array_counters_lock);
+	list_add(&ac->v.list, &array_counters);
+	mutex_unlock(&array_counters_lock);
+#endif
+	return 0;
+}
+
+void array_counter_destroy(struct array_counter *ac)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	mutex_lock(&array_counters_lock);
+	list_del(&ac->v.list);
+	mutex_unlock(&array_counters_lock);
+#endif
+	free_percpu(&ac->v.counters);
+	ac->v.counters = NULL;
+}
+
+void array_counter_add(struct array_counter *ac, int idx, int val)
+{
+	s8 *pcount;
+	long count;
+	int cpu = get_cpu();
+
+	pcount = per_cpu_ptr(ac->v.counters, cpu);
+	count = pcount[idx] + val;
+	if ((count >= ac->v.batch) || (-count >= ac->v.batch)) {
+		atomic_long_add(count, &ac->counters[idx]);
+		pcount[idx] = 0;
+	} else
+		pcount[idx] = (s8)count;
+	put_cpu();
+}
+
+
+static int __cpuinit array_counter_hotcpu_callback(struct notifier_block *nb,
+					unsigned long action, void *hcpu)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	unsigned int cpu;
+	struct pad_array_counter *pac;
+	int idx;
+	if (action != CPU_DEAD)
+		return NOTIFY_OK;
+
+	cpu = (unsigned long)hcpu;
+	mutex_lock(&percpu_counters_lock);
+	list_for_each_entry(pac, &array_counters, list) {
+		s8 *pcount;
+		struct array_counter *ac;
+
+		ac = container_of(pac, struct array_counter, v);
+		pcount = per_cpu_ptr(pac->counters, cpu);
+		for (idx = 0; idx < pac->elements; idx++){
+			atomic_long_add(pcount[idx], &ac->counters[idx]);
+			pcount[idx] = 0;
+		}
+	}
+	mutex_unlock(&percpu_counters_lock);
+#endif
+	return NOTIFY_OK;
+}
+
+static int __init array_counter_startup(void)
+{
+	hotcpu_notifier(array_counter_hotcpu_callback, 0);
+	return 0;
+}
+module_init(array_counter_startup);

