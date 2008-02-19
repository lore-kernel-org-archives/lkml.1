Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbYBSLw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbYBSLw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYBSLwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:52:19 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:53527 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYBSLwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:52:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=VLy97GyHEigLO+oeHJu5Bc4aqrf5vkr+Y4mETB0PA60PSMymadUrFQSGHiicXxZNriJRfpANzLgOLrzmZ5TpuhhbGpGeFodnyt/F46DTjTMX6H/6D1brZvaykfNoFoTJNTiestASOi8a7n/JLaCELb5rOUm+j/K/Annw0uzvotk=
Message-ID: <47BAC2A9.3070706@gmail.com>
Date: Tue, 19 Feb 2008 12:51:05 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: paulmck@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Split list.h and move rcu-protected lists into rculist.h
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

This patch moves rcu-protected lists from list.h into a new header
file rculist.h.

This is done because list are a very used primitive structure all over
the kernel and it's currently impossible to include other header files
in this list.h without creating some circular dependencies.

For example, list.h implements rcu-protected list and uses
rcu_dereference() without including rcupdate.h. It actually compiles
because users of rcu_dereference() are macros. Others RCU functions
could be used too but aren't probably because of this.

Therefore this patch creates rculist.h which includes rcupdates
without to many changes/troubles.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

  Andrew

 The patchset has been rebased on your v2.6.25-rc2-mm1 tag. It compiles
 the 'allmodconfig' fine now.

 Please consider,

		Franck

 arch/ia64/sn/kernel/irq.c                       |    1 +
 crypto/async_tx/async_tx.c                      |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs.c       |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs_mcast.c |    3 +-
 drivers/net/macvlan.c                           |    2 +-
 include/linux/dcache.h                          |    1 +
 include/linux/list.h                            |  385 ----------------------
 include/linux/rculist.h                         |  396 +++++++++++++++++++++++
 kernel/pid.c                                    |    1 +
 lib/textsearch.c                                |    1 +
 net/802/psnap.c                                 |    1 +
 net/8021q/vlan.c                                |    1 +
 net/bridge/br_fdb.c                             |    1 +
 net/bridge/br_stp.c                             |    1 +
 net/netlabel/netlabel_domainhash.c              |    3 +-
 15 files changed, 409 insertions(+), 390 deletions(-)
 create mode 100644 include/linux/rculist.h

diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 53351c3..96c31b4 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -11,6 +11,7 @@
 #include <linux/irq.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/intr.h>
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 6975616..be08624 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -23,6 +23,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
+#include <linux/rculist.h>
 #include <linux/kernel.h>
 #include <linux/async_tx.h>
 
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 32d8f88..83be1ed 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -35,6 +35,7 @@
 #include <rdma/ib_user_verbs.h>
 #include <linux/io.h>
 #include <linux/utsname.h>
+#include <linux/rculist.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c b/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
index 9e5abf9..d73e322 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
@@ -31,8 +31,7 @@
  * SOFTWARE.
  */
 
-#include <linux/list.h>
-#include <linux/rcupdate.h>
+#include <linux/rculist.h>
 
 #include "ipath_verbs.h"
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index f651a81..f363f8d 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -20,7 +20,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 795de50..d8121d2 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -5,6 +5,7 @@
 
 #include <asm/atomic.h>
 #include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
diff --git a/include/linux/list.h b/include/linux/list.h
index 75ce2cb..2d870fc 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -87,65 +87,6 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
 }
 
 /*
- * Insert a new entry between two known consecutive entries.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_add_rcu(struct list_head * new,
-		struct list_head * prev, struct list_head * next)
-{
-	new->next = next;
-	new->prev = prev;
-	smp_wmb();
-	next->prev = new;
-	prev->next = new;
-}
-
-/**
- * list_add_rcu - add a new entry to rcu-protected list
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_add_rcu()
- * or list_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- */
-static inline void list_add_rcu(struct list_head *new, struct list_head *head)
-{
-	__list_add_rcu(new, head, head->next);
-}
-
-/**
- * list_add_tail_rcu - add a new entry to rcu-protected list
- * @new: new entry to be added
- * @head: list head to add it before
- *
- * Insert a new entry before the specified head.
- * This is useful for implementing queues.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_add_tail_rcu()
- * or list_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- */
-static inline void list_add_tail_rcu(struct list_head *new,
-					struct list_head *head)
-{
-	__list_add_rcu(new, head->prev, head);
-}
-
-/*
  * Delete a list entry by making the prev/next entries
  * point to each other.
  *
@@ -176,36 +117,6 @@ extern void list_del(struct list_head *entry);
 #endif
 
 /**
- * list_del_rcu - deletes entry from list without re-initialization
- * @entry: the element to delete from the list.
- *
- * Note: list_empty() on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_del_rcu()
- * or list_add_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- *
- * Note that the caller is not permitted to immediately free
- * the newly deleted entry.  Instead, either synchronize_rcu()
- * or call_rcu() must be used to defer freeing until an RCU
- * grace period has elapsed.
- */
-static inline void list_del_rcu(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	entry->prev = LIST_POISON2;
-}
-
-/**
  * list_replace - replace old entry by new one
  * @old : the element to be replaced
  * @new : the new element to insert
@@ -229,25 +140,6 @@ static inline void list_replace_init(struct list_head *old,
 }
 
 /**
- * list_replace_rcu - replace old entry by new one
- * @old : the element to be replaced
- * @new : the new element to insert
- *
- * The @old entry will be replaced with the @new entry atomically.
- * Note: @old should not be empty.
- */
-static inline void list_replace_rcu(struct list_head *old,
-				struct list_head *new)
-{
-	new->next = old->next;
-	new->prev = old->prev;
-	smp_wmb();
-	new->next->prev = new;
-	new->prev->next = new;
-	old->prev = LIST_POISON2;
-}
-
-/**
  * list_del_init - deletes entry from list and reinitialize it.
  * @entry: the element to delete from the list.
  */
@@ -361,62 +253,6 @@ static inline void list_splice_init(struct list_head *list,
 }
 
 /**
- * list_splice_init_rcu - splice an RCU-protected list into an existing list.
- * @list:	the RCU-protected list to splice
- * @head:	the place in the list to splice the first list into
- * @sync:	function to sync: synchronize_rcu(), synchronize_sched(), ...
- *
- * @head can be RCU-read traversed concurrently with this function.
- *
- * Note that this function blocks.
- *
- * Important note: the caller must take whatever action is necessary to
- *	prevent any other updates to @head.  In principle, it is possible
- *	to modify the list as soon as sync() begins execution.
- *	If this sort of thing becomes necessary, an alternative version
- *	based on call_rcu() could be created.  But only if -really-
- *	needed -- there is no shortage of RCU API members.
- */
-static inline void list_splice_init_rcu(struct list_head *list,
-					struct list_head *head,
-					void (*sync)(void))
-{
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
-
-	if (list_empty(head))
-		return;
-
-	/* "first" and "last" tracking list, so initialize it. */
-
-	INIT_LIST_HEAD(list);
-
-	/*
-	 * At this point, the list body still points to the source list.
-	 * Wait for any readers to finish using the list before splicing
-	 * the list body into the new list.  Any new readers will see
-	 * an empty list.
-	 */
-
-	sync();
-
-	/*
-	 * Readers are finished with the source list, so perform splice.
-	 * The order is important if the new list is global and accessible
-	 * to concurrent RCU readers.  Note that RCU readers are not
-	 * permitted to traverse the prev pointers without excluding
-	 * this function.
-	 */
-
-	last->next = at;
-	smp_wmb();
-	head->next = first;
-	first->prev = head;
-	at->prev = last;
-}
-
-/**
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.
@@ -621,75 +457,6 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	     &pos->member != (head); 					\
 	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
 
-/**
- * list_for_each_rcu	-	iterate over an rcu-protected list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_rcu(pos, head) \
-	for (pos = (head)->next; \
-		prefetch(rcu_dereference(pos)->next), pos != (head); \
-        	pos = pos->next)
-
-#define __list_for_each_rcu(pos, head) \
-	for (pos = (head)->next; \
-		rcu_dereference(pos) != (head); \
-        	pos = pos->next)
-
-/**
- * list_for_each_safe_rcu
- * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- *
- * Iterate over an rcu-protected list, safe against removal of list entry.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_safe_rcu(pos, n, head) \
-	for (pos = (head)->next; \
-		n = rcu_dereference(pos)->next, pos != (head); \
-		pos = n)
-
-/**
- * list_for_each_entry_rcu	-	iterate over rcu list of given type
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry((head)->next, typeof(*pos), member); \
-		prefetch(rcu_dereference(pos)->member.next), \
-			&pos->member != (head); \
-		pos = list_entry(pos->member.next, typeof(*pos), member))
-
-
-/**
- * list_for_each_continue_rcu
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * Iterate over an rcu-protected list, continuing after current point.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = (pos)->next; \
-		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
-        	(pos) = (pos)->next)
-
 /*
  * Double linked lists with a single pointer list head.
  * Mostly useful for hash tables where the two pointer list head is
@@ -740,31 +507,6 @@ static inline void hlist_del(struct hlist_node *n)
 	n->pprev = LIST_POISON2;
 }
 
-/**
- * hlist_del_rcu - deletes entry from hash list without re-initialization
- * @n: the element to delete from the hash list.
- *
- * Note: list_unhashed() on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the hash list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry().
- */
-static inline void hlist_del_rcu(struct hlist_node *n)
-{
-	__hlist_del(n);
-	n->pprev = LIST_POISON2;
-}
-
 static inline void hlist_del_init(struct hlist_node *n)
 {
 	if (!hlist_unhashed(n)) {
@@ -773,27 +515,6 @@ static inline void hlist_del_init(struct hlist_node *n)
 	}
 }
 
-/**
- * hlist_replace_rcu - replace old entry by new one
- * @old : the element to be replaced
- * @new : the new element to insert
- *
- * The @old entry will be replaced with the @new entry atomically.
- */
-static inline void hlist_replace_rcu(struct hlist_node *old,
-					struct hlist_node *new)
-{
-	struct hlist_node *next = old->next;
-
-	new->next = next;
-	new->pprev = old->pprev;
-	smp_wmb();
-	if (next)
-		new->next->pprev = &new->next;
-	*new->pprev = new;
-	old->pprev = LIST_POISON2;
-}
-
 static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 {
 	struct hlist_node *first = h->first;
@@ -804,38 +525,6 @@ static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 	n->pprev = &h->first;
 }
 
-
-/**
- * hlist_add_head_rcu
- * @n: the element to add to the hash list.
- * @h: the list to add to.
- *
- * Description:
- * Adds the specified element to the specified hlist,
- * while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.  Regardless of the type of CPU, the
- * list-traversal primitive must be guarded by rcu_read_lock().
- */
-static inline void hlist_add_head_rcu(struct hlist_node *n,
-					struct hlist_head *h)
-{
-	struct hlist_node *first = h->first;
-	n->next = first;
-	n->pprev = &h->first;
-	smp_wmb();
-	if (first)
-		first->pprev = &n->next;
-	h->first = n;
-}
-
 /* next must be != NULL */
 static inline void hlist_add_before(struct hlist_node *n,
 					struct hlist_node *next)
@@ -857,63 +546,6 @@ static inline void hlist_add_after(struct hlist_node *n,
 		next->next->pprev  = &next->next;
 }
 
-/**
- * hlist_add_before_rcu
- * @n: the new element to add to the hash list.
- * @next: the existing element to add the new element before.
- *
- * Description:
- * Adds the specified element to the specified hlist
- * before the specified node while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.
- */
-static inline void hlist_add_before_rcu(struct hlist_node *n,
-					struct hlist_node *next)
-{
-	n->pprev = next->pprev;
-	n->next = next;
-	smp_wmb();
-	next->pprev = &n->next;
-	*(n->pprev) = n;
-}
-
-/**
- * hlist_add_after_rcu
- * @prev: the existing element to add the new element after.
- * @n: the new element to add to the hash list.
- *
- * Description:
- * Adds the specified element to the specified hlist
- * after the specified node while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.
- */
-static inline void hlist_add_after_rcu(struct hlist_node *prev,
-				       struct hlist_node *n)
-{
-	n->next = prev->next;
-	n->pprev = &prev->next;
-	smp_wmb();
-	prev->next = n;
-	if (n->next)
-		n->next->pprev = &n->next;
-}
-
 #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
 
 #define hlist_for_each(pos, head) \
@@ -974,23 +606,6 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = n)
 
-/**
- * hlist_for_each_entry_rcu - iterate over rcu list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as hlist_add_head_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = (head)->first;					 \
-	     rcu_dereference(pos) && ({ prefetch(pos->next); 1;}) &&	 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
 #else
 #warning "don't include kernel headers in userspace"
 #endif /* __KERNEL__ */
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
new file mode 100644
index 0000000..aa9b3eb
--- /dev/null
+++ b/include/linux/rculist.h
@@ -0,0 +1,396 @@
+#ifndef _LINUX_RCULIST_H
+#define _LINUX_RCULIST_H
+
+#ifdef __KERNEL__
+
+/*
+ * RCU-protected list version
+ */
+#include <linux/list.h>
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add_rcu(struct list_head *new,
+		struct list_head *prev, struct list_head *next)
+{
+	new->next = next;
+	new->prev = prev;
+	smp_wmb();
+	next->prev = new;
+	prev->next = new;
+}
+
+/**
+ * list_add_rcu - add a new entry to rcu-protected list
+ * @new: new entry to be added
+ * @head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+static inline void list_add_rcu(struct list_head *new, struct list_head *head)
+{
+	__list_add_rcu(new, head, head->next);
+}
+
+/**
+ * list_add_tail_rcu - add a new entry to rcu-protected list
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_tail_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+static inline void list_add_tail_rcu(struct list_head *new,
+					struct list_head *head)
+{
+	__list_add_rcu(new, head->prev, head);
+}
+
+/**
+ * list_del_rcu - deletes entry from list without re-initialization
+ * @entry: the element to delete from the list.
+ *
+ * Note: list_empty() on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, it means that we can not poison the forward
+ * pointers that may still be used for walking the list.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_del_rcu()
+ * or list_add_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ *
+ * Note that the caller is not permitted to immediately free
+ * the newly deleted entry.  Instead, either synchronize_rcu()
+ * or call_rcu() must be used to defer freeing until an RCU
+ * grace period has elapsed.
+ */
+static inline void list_del_rcu(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->prev = LIST_POISON2;
+}
+
+/**
+ * list_replace_rcu - replace old entry by new one
+ * @old : the element to be replaced
+ * @new : the new element to insert
+ *
+ * The @old entry will be replaced with the @new entry atomically.
+ * Note: @old should not be empty.
+ */
+static inline void list_replace_rcu(struct list_head *old,
+				struct list_head *new)
+{
+	new->next = old->next;
+	new->prev = old->prev;
+	smp_wmb();
+	new->next->prev = new;
+	new->prev->next = new;
+	old->prev = LIST_POISON2;
+}
+
+/**
+ * list_splice_init_rcu - splice an RCU-protected list into an existing list.
+ * @list:	the RCU-protected list to splice
+ * @head:	the place in the list to splice the first list into
+ * @sync:	function to sync: synchronize_rcu(), synchronize_sched(), ...
+ *
+ * @head can be RCU-read traversed concurrently with this function.
+ *
+ * Note that this function blocks.
+ *
+ * Important note: the caller must take whatever action is necessary to
+ *	prevent any other updates to @head.  In principle, it is possible
+ *	to modify the list as soon as sync() begins execution.
+ *	If this sort of thing becomes necessary, an alternative version
+ *	based on call_rcu() could be created.  But only if -really-
+ *	needed -- there is no shortage of RCU API members.
+ */
+static inline void list_splice_init_rcu(struct list_head *list,
+					struct list_head *head,
+					void (*sync)(void))
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *at = head->next;
+
+	if (list_empty(head))
+		return;
+
+	/* "first" and "last" tracking list, so initialize it. */
+
+	INIT_LIST_HEAD(list);
+
+	/*
+	 * At this point, the list body still points to the source list.
+	 * Wait for any readers to finish using the list before splicing
+	 * the list body into the new list.  Any new readers will see
+	 * an empty list.
+	 */
+
+	sync();
+
+	/*
+	 * Readers are finished with the source list, so perform splice.
+	 * The order is important if the new list is global and accessible
+	 * to concurrent RCU readers.  Note that RCU readers are not
+	 * permitted to traverse the prev pointers without excluding
+	 * this function.
+	 */
+
+	last->next = at;
+	smp_wmb();
+	head->next = first;
+	first->prev = head;
+	at->prev = last;
+}
+
+/**
+ * list_for_each_rcu	-	iterate over an rcu-protected list
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_rcu(pos, head) \
+	for (pos = (head)->next; \
+		prefetch(rcu_dereference(pos)->next), pos != (head); \
+		pos = pos->next)
+
+#define __list_for_each_rcu(pos, head) \
+	for (pos = (head)->next; \
+		rcu_dereference(pos) != (head); \
+		pos = pos->next)
+
+/**
+ * list_for_each_safe_rcu
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ *
+ * Iterate over an rcu-protected list, safe against removal of list entry.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_safe_rcu(pos, n, head) \
+	for (pos = (head)->next; \
+		n = rcu_dereference(pos)->next, pos != (head); \
+		pos = n)
+
+/**
+ * list_for_each_entry_rcu	-	iterate over rcu list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_entry_rcu(pos, head, member) \
+	for (pos = list_entry((head)->next, typeof(*pos), member); \
+		prefetch(rcu_dereference(pos)->member.next), \
+			&pos->member != (head); \
+		pos = list_entry(pos->member.next, typeof(*pos), member))
+
+
+/**
+ * list_for_each_continue_rcu
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ *
+ * Iterate over an rcu-protected list, continuing after current point.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_continue_rcu(pos, head) \
+	for ((pos) = (pos)->next; \
+		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
+		(pos) = (pos)->next)
+
+/**
+ * hlist_del_rcu - deletes entry from hash list without re-initialization
+ * @n: the element to delete from the hash list.
+ *
+ * Note: list_unhashed() on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, it means that we can not poison the forward
+ * pointers that may still be used for walking the hash list.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry().
+ */
+static inline void hlist_del_rcu(struct hlist_node *n)
+{
+	__hlist_del(n);
+	n->pprev = LIST_POISON2;
+}
+
+/**
+ * hlist_replace_rcu - replace old entry by new one
+ * @old : the element to be replaced
+ * @new : the new element to insert
+ *
+ * The @old entry will be replaced with the @new entry atomically.
+ */
+static inline void hlist_replace_rcu(struct hlist_node *old,
+					struct hlist_node *new)
+{
+	struct hlist_node *next = old->next;
+
+	new->next = next;
+	new->pprev = old->pprev;
+	smp_wmb();
+	if (next)
+		new->next->pprev = &new->next;
+	*new->pprev = new;
+	old->pprev = LIST_POISON2;
+}
+
+/**
+ * hlist_add_head_rcu
+ * @n: the element to add to the hash list.
+ * @h: the list to add to.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist,
+ * while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_add_head_rcu(struct hlist_node *n,
+					struct hlist_head *h)
+{
+	struct hlist_node *first = h->first;
+	n->next = first;
+	n->pprev = &h->first;
+	smp_wmb();
+	if (first)
+		first->pprev = &n->next;
+	h->first = n;
+}
+
+/**
+ * hlist_add_before_rcu
+ * @n: the new element to add to the hash list.
+ * @next: the existing element to add the new element before.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist
+ * before the specified node while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.
+ */
+static inline void hlist_add_before_rcu(struct hlist_node *n,
+					struct hlist_node *next)
+{
+	n->pprev = next->pprev;
+	n->next = next;
+	smp_wmb();
+	next->pprev = &n->next;
+	*(n->pprev) = n;
+}
+
+/**
+ * hlist_add_after_rcu
+ * @prev: the existing element to add the new element after.
+ * @n: the new element to add to the hash list.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist
+ * after the specified node while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.
+ */
+static inline void hlist_add_after_rcu(struct hlist_node *prev,
+				       struct hlist_node *n)
+{
+	n->next = prev->next;
+	n->pprev = &prev->next;
+	smp_wmb();
+	prev->next = n;
+	if (n->next)
+		n->next->pprev = &n->next;
+}
+
+/**
+ * hlist_for_each_entry_rcu - iterate over rcu list of given type
+ * @tpos:	the type * to use as a loop cursor.
+ * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_node within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as hlist_add_head_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
+	for (pos = (head)->first;					 \
+	     rcu_dereference(pos) && ({ prefetch(pos->next); 1; }) &&	 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
+	     pos = pos->next)
+
+#endif	/* __KERNEL__ */
+#endif
diff --git a/kernel/pid.c b/kernel/pid.c
index 4776915..d62e3f7 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <linux/bootmem.h>
 #include <linux/hash.h>
 #include <linux/pid_namespace.h>
diff --git a/lib/textsearch.c b/lib/textsearch.c
index be8bda3..a3e500a 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -97,6 +97,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/err.h>
 #include <linux/textsearch.h>
diff --git a/net/802/psnap.c b/net/802/psnap.c
index 31128cb..ea46439 100644
--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/in.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 
 static LIST_HEAD(snap_list);
 static DEFINE_SPINLOCK(snap_lock);
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index dbc81b9..db8956e 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -27,6 +27,7 @@
 #include <linux/mm.h>
 #include <linux/in.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <net/p8022.h>
 #include <net/arp.h>
 #include <linux/rtnetlink.h>
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index bc40377..55d8723 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -15,6 +15,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/times.h>
 #include <linux/netdevice.h>
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index e38034a..9e96ffc 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -13,6 +13,7 @@
  *	2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
+#include <linux/rculist.h>
 
 #include "br_private.h"
 #include "br_private_stp.h"
diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index fd46231..fbd1a3d 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -30,8 +30,7 @@
  */
 
 #include <linux/types.h>
-#include <linux/rcupdate.h>
-#include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
-- 
1.5.4


