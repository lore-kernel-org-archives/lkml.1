Return-Path: <linux-kernel-owner+w=401wt.eu-S932377AbXIBS1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbXIBS1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 14:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXIBS1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 14:27:43 -0400
Received: from ns.suse.de ([195.135.220.2]:46062 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbXIBS1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 14:27:42 -0400
Date: Sun, 2 Sep 2007 20:27:38 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Paul McKenney <paulmck@us.ibm.com>
Subject: [rfc][patch] dynamic data structure switching
Message-ID: <20070902182738.GA13145@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my "data structure switch" algorithm that can convert one data
structure into another, with just a single unlikely branch in fastpaths
and no locking or atomic operations (the branch is only triggered when
the data structure is in the process of being converted). A pointer
indirection is generally also needed when converting a global data
structure.

I posted this algorithm a while back and converted the dcache hash to
be dynamically resized at runtime[*], and David Miller started on a
patch to make one of the networking hashes dynamic too.

[*] The algorithm need not only convert between two different sized
    hashes, but that's just the most obvious and useful thing to do.
    It _could_ convert between a hash and a tree or something crazy
    like that too :)

Anyway, the problem with this is that I hadn't found a really nice
way to abstract this functionality and package it in a nice API. It
is almost small enough that open-coding it would be reasonable...
but it would be much nicer to be able to abstract it.

Anyway, here is the algorithm nicely packaged behind a really crappy
API :P I think the idea might be useful enough not to lose it, so
I'm posting this WIP just as a request for comments. 

The algorithm implementation is basically optimal, but the API means
that it requires and extra function call and indirect function call
to work, which probably makes it unusable for important implementations.
(C preprocessor magic to avoid the indirect function calls and allow
some level of templating while retaining the types might be the way
to do it).

Dumb pidhash conversion also provided to help people tinker.


Index: linux-2.6/lib/dyndata.c
===================================================================
--- /dev/null
+++ linux-2.6/lib/dyndata.c
@@ -0,0 +1,80 @@
+#include <linux/dyndata.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/seqlock.h>
+
+void dyn_data_init(struct dyn_data *dd, void *cur_data)
+{
+	dd->cur = cur_data;
+	dd->old = NULL;
+	seqcount_init(&dd->resize_seq);
+	mutex_init(&dd->resize_mutex);
+}
+
+/*
+ * Slowpath lookup. There is a resize in progress and we weren't able to
+ * find the item we wanted in dyn_data_lookup: run the full race-free
+ * lookup protocol.
+ */
+static noinline void *dyn_data_lookup_slow(struct dyn_data *dd, dd_lookup_fn fn, void *arg)
+{
+	void *ret;
+	void *cur, *old;
+	unsigned seq;
+
+	cur = dd->cur;
+	old = dd->old;
+
+	do {
+		seq = read_seqcount_begin(&dd->resize_seq);
+		ret = fn(cur, arg);
+		if (ret)
+			return ret;
+		if (!old)
+			return NULL;
+
+		ret = fn(old, arg);
+		if (ret)
+			return ret;
+	} while (read_seqcount_retry(&dd->resize_seq, seq));
+
+	return NULL;
+}
+
+void *dyn_data_lookup(struct dyn_data *dd, dd_lookup_fn fn, void *arg)
+{
+	void *ret;
+
+	rcu_read_lock();
+	if (likely(!dd->old))
+		ret = fn(dd->cur, arg);
+	else
+		ret = dyn_data_lookup_slow(dd, fn, arg);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+void *dyn_data_replace(struct dyn_data *dd, dd_transfer_fn fn, void *new)
+{
+	int xfer_done;
+	void *old;
+
+	BUG_ON(!mutex_is_locked(&dd->resize_mutex));
+	old = dd->cur;
+	BUG_ON(dd->old);
+	dd->old = old;
+	synchronize_rcu();
+	rcu_assign_pointer(dd->cur, new);
+	synchronize_rcu();
+	do {
+		write_seqcount_begin(&dd->resize_seq);
+		xfer_done = fn(old, new);
+		write_seqcount_end(&dd->resize_seq);
+	} while (!xfer_done);
+	dd->old = NULL;
+	synchronize_rcu();
+
+
+	return old;
+}
Index: linux-2.6/include/linux/dyndata.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/dyndata.h
@@ -0,0 +1,94 @@
+#ifndef __DYNDATA_H__
+#define __DYNDATA_H__
+
+/*
+ * Dynamic data structure algorithm
+ *
+ * We have a given data structure that we are operating on, this is pointed
+ * to by 'cur', or current, data structure. There is also an 'old' data
+ * structure pointer, which is NULL unless cur is in the process of being
+ * replaced.
+ *
+ * When we wish to replace the cur data structure with another, we perform the
+ * following (numbered) steps (letters are not steps but are relevant info):
+ *
+ * 1. Set 'old' to the value of cur (was NULL). That is, the current data
+ *   structure becomes the old one.
+ *
+ * a. If a data structure lookup for the current data structure is negative, old
+ *   must be loaded, and if it is non-NULL, then that data structure should be
+ *   searched too. This must happen under rcu_read_lock().
+ *
+ * 2. synchronize_rcu(), so all lookups after that point will find old to be
+ *   non-NULL (by property a).
+ *
+ * 3. Set cur to the new data structure. This structure will be initially
+ *   empty, but property a will ensure that lookups will find old and hence
+ *   find the items that were in the old data structure.
+ *
+ * 4. synchronize_rcu(), so all lookups after that point will also find new
+ *   to be non-NULL.
+ *
+ * b. All data structure insertions must insert new items into the current
+ *   table. This property ensures that old will not get more items.
+ *
+ * c. If duplicate items cannot be tolerated, insertion must search for a
+ *   pre-existing item (ie. do a lookup which may search the old and the
+ *   new data structures), before inserting one, if a duplicate could be
+ *   possible.
+ *
+ * 4. Transfer items from the old data structure to the new one. Property
+ *   b ensures that old will eventually become empty.
+ *
+ * 5. When transferring items, it will often be required to delete the
+ *   item from the old data structure before inserting it into the new
+ *   one. This opens a window for a possible race where lookup would not
+ *   find the item. If transient false negatives cannot be tolerated,
+ *   this race must be covered somehow. Fortunately, it only needs to
+ *   be considered when the lookup finds old to be non-NULL, and lookups
+ *   are usually idempotent and side-effect free, so a simple seqcount
+ *   in the lookup slowpath is used here to cover the race.
+ *
+ * 6. After the old data structure is emptied, set the old pointer to NULL.
+ *   There is nothing in the data structure, so there is no reason for
+ *   lookups to see the old data structure.
+ *
+ * 7. synchronize_rcu() again, to ensure that no lookups will have loaded
+ *   the non-NULL value of old.
+ *
+ * 8. The caller is now free to deallocate the old data structure.
+ *
+ * Note: while synchronize_rcu() is used here, call_rcu could be used instead
+ * in some situations.
+ *
+ * Note2: memory barriers are not needed in the read-side (AFAIKS) with this
+ * implementation.  Not even rcu_dereference when loading the potentially
+ * changing cur and old pointers: the write-side has gone through a
+ * synchronize_rcu() before making new data visible, which means the read-side
+ * must have gone through a quiescent state which is a full barrier.
+ */
+
+
+#include <linux/mutex.h>
+#include <linux/seqlock.h>
+
+struct dyn_data {
+	void *cur;
+	void *old;
+	seqcount_t resize_seq;
+	struct mutex resize_mutex;
+};
+
+typedef void *(dd_lookup_fn)(void *dstruct, void *arg);
+typedef int (dd_transfer_fn)(void *old_ds, void *new_ds);
+
+void dyn_data_init(struct dyn_data *dd, void *cur_data);
+void *dyn_data_lookup(struct dyn_data *dd, dd_lookup_fn fn, void *arg);
+void *dyn_data_replace(struct dyn_data *dd, dd_transfer_fn fn, void *new);
+
+static inline void *dyn_data_current_dstruct(struct dyn_data *dd)
+{
+	return dd->cur;
+}
+
+#endif
Index: linux-2.6/lib/Makefile
===================================================================
--- linux-2.6.orig/lib/Makefile
+++ linux-2.6/lib/Makefile
@@ -10,7 +10,7 @@ lib-y := ctype.o string.o vsprintf.o kas
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
-lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
+lib-y	+= kobject.o kref.o kobject_uevent.o klist.o dyndata.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o
