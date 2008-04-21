Return-Path: <linux-kernel-owner+w=401wt.eu-S1762167AbYDURXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167AbYDURXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYDURXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:23:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44787 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYDURXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:23:22 -0400
Date: Mon, 21 Apr 2008 11:23:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: fault in __d_lookup [Was: 2.6.25-mm1]
Message-ID: <20080421172305.GC20637@parisc-linux.org>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <480C50EC.2090803@gmail.com> <20080421090610.GO27459@ZenIV.linux.org.uk> <480C6064.10801@gmail.com> <20080421094515.GR27459@ZenIV.linux.org.uk> <480C6597.1000701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480C6597.1000701@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:59:51AM +0200, Jiri Slaby wrote:
> On 04/21/2008 11:45 AM, Al Viro wrote:
> >Well, if list has such turd in it, you'll certainly hit it every time
> >you walk that list, so 100% reproducible is not surprising.
> >
> >How well is it reproducible from fresh boot?
> 
> Few days with suspend/resume cycles. This one was booted 12 hours ago, one 
> suspend/resume. Will keep an eye on it and keep you informed.

Shall we see if we can catch it earlier?  I have no idea if this will
help ... I haven't even booted it on a testmachine yet ;-)  If I got
something wrong, it'll BUG() pretty early.

diff --git a/include/linux/list.h b/include/linux/list.h
index 75ce2cb..238ca1e 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -724,10 +724,17 @@ static inline int hlist_empty(const struct hlist_head *h)
 	return !h->first;
 }
 
+#ifdef CONFIG_DEBUG_LIST
+extern void hlist_check(struct hlist_node *n);
+#else
+#define hlist_check(n)		do { } while (0)
+#endif
+
 static inline void __hlist_del(struct hlist_node *n)
 {
 	struct hlist_node *next = n->next;
 	struct hlist_node **pprev = n->pprev;
+	hlist_check(n);
 	*pprev = next;
 	if (next)
 		next->pprev = pprev;
@@ -785,6 +792,7 @@ static inline void hlist_replace_rcu(struct hlist_node *old,
 {
 	struct hlist_node *next = old->next;
 
+	hlist_check(old);
 	new->next = next;
 	new->pprev = old->pprev;
 	smp_wmb();
@@ -840,6 +848,7 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
 static inline void hlist_add_before(struct hlist_node *n,
 					struct hlist_node *next)
 {
+	hlist_check(next);
 	n->pprev = next->pprev;
 	n->next = next;
 	next->pprev = &n->next;
@@ -849,6 +858,7 @@ static inline void hlist_add_before(struct hlist_node *n,
 static inline void hlist_add_after(struct hlist_node *n,
 					struct hlist_node *next)
 {
+	hlist_check(next);
 	next->next = n->next;
 	n->next = next;
 	next->pprev = &n->next;
@@ -878,6 +888,7 @@ static inline void hlist_add_after(struct hlist_node *n,
 static inline void hlist_add_before_rcu(struct hlist_node *n,
 					struct hlist_node *next)
 {
+	hlist_check(next);
 	n->pprev = next->pprev;
 	n->next = next;
 	smp_wmb();
@@ -906,6 +917,7 @@ static inline void hlist_add_before_rcu(struct hlist_node *n,
 static inline void hlist_add_after_rcu(struct hlist_node *prev,
 				       struct hlist_node *n)
 {
+	hlist_check(prev);
 	n->next = prev->next;
 	n->pprev = &prev->next;
 	smp_wmb();
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 4350ba9..00b56bf 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -1,5 +1,8 @@
 /*
  * Copyright 2006, Red Hat, Inc., Dave Jones
+ * Copyright 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
  * Released under the General Public License (GPL).
  *
  * This file contains the linked list implementations for
@@ -76,3 +79,18 @@ void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 EXPORT_SYMBOL(list_del);
+
+void hlist_check(struct hlist_node *n)
+{
+	if (unlikely(*n->pprev != n)) {
+		printk(KERN_ERR "hlist corruption. *pprev should be %p, "
+				"but was %p\n", n, *n->pprev);
+		BUG();
+	}
+	if (unlikely(n->next != NULL && n->next->pprev != &n->next)) {
+		printk(KERN_ERR "hlist corruption. n->next->pprev should be"
+				"%p, but was %p\n", &n->next, n->next->pprev);
+		BUG();
+	}
+}
+EXPORT_SYMBOL(hlist_check);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
