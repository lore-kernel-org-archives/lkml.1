Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZGAUkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZGAUkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZGAUkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:40:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:44713 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbZGAUkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:40:39 -0400
Date: Wed, 1 Jul 2009 20:39:56 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090701152837.GG15682@ghostprotocols.net>
References: <20090701152837.GG15682@ghostprotocols.net>
Subject: [tip:perfcounters/urgent] perf_counter tools: Share rbtree.with the kernel
Message-ID: <tip-43cbcd8acb4c992cbd22d1ec8a08c0591be5d719@git.kernel.org>
Git-Commit-ID: 43cbcd8acb4c992cbd22d1ec8a08c0591be5d719
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 20:39:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43cbcd8acb4c992cbd22d1ec8a08c0591be5d719
Gitweb:     http://git.kernel.org/tip/43cbcd8acb4c992cbd22d1ec8a08c0591be5d719
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 1 Jul 2009 12:28:37 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 22:37:22 +0200

perf_counter tools: Share rbtree.with the kernel

The tools/perf/util/rbtree.c copy already drifted by three
csets:

 4b324126e0c6c3a5080ca3ec0981e8766ed6f1ee
 4c60117811171d867d4f27f17ea07d7419d45dae
 16c047add3ceaf0ab882e3e094d1ec904d02312d

So remove the copy and use the lib/rbtree.c directly, sharing
the source code while still generating a separate object file,
since tools/perf uses a far more agressive -O6 switch.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090701152837.GG15682@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile                    |    7 +-
 tools/perf/builtin-annotate.c          |    2 +-
 tools/perf/builtin-report.c            |    2 +-
 tools/perf/builtin-top.c               |    2 +-
 tools/perf/util/callchain.h            |    2 +-
 tools/perf/util/include/linux/kernel.h |   21 ++
 tools/perf/util/include/linux/module.h |    6 +
 tools/perf/util/include/linux/rbtree.h |    1 +
 tools/perf/util/rbtree.c               |  383 --------------------------------
 tools/perf/util/rbtree.h               |  171 --------------
 tools/perf/util/strlist.h              |    2 +-
 tools/perf/util/symbol.h               |    2 +-
 12 files changed, 39 insertions(+), 562 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index eddf076..c4f4882 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -223,7 +223,7 @@ SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS =
+BASIC_CFLAGS = -Iutil/include
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -289,10 +289,10 @@ export PERL_PATH
 LIB_FILE=libperf.a
 
 LIB_H += ../../include/linux/perf_counter.h
+LIB_H += ../../include/linux/rbtree.h
 LIB_H += perf.h
 LIB_H += util/types.h
 LIB_H += util/list.h
-LIB_H += util/rbtree.h
 LIB_H += util/levenshtein.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
@@ -691,6 +691,9 @@ builtin-init-db.o: builtin-init-db.c PERF-CFLAGS
 util/config.o: util/config.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+util/rbtree.o: ../../lib/rbtree.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o util/rbtree.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
 perf-%$X: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6cba70d..1960c22 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -12,7 +12,7 @@
 #include "util/color.h"
 #include "util/list.h"
 #include "util/cache.h"
-#include "util/rbtree.h"
+#include <linux/rbtree.h>
 #include "util/symbol.h"
 #include "util/string.h"
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 007363d..0d35e2b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -12,7 +12,7 @@
 #include "util/color.h"
 #include "util/list.h"
 #include "util/cache.h"
-#include "util/rbtree.h"
+#include <linux/rbtree.h>
 #include "util/symbol.h"
 #include "util/string.h"
 #include "util/callchain.h"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5f5e7df..cdc74cf 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -23,7 +23,7 @@
 #include "util/symbol.h"
 #include "util/color.h"
 #include "util/util.h"
-#include "util/rbtree.h"
+#include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 251d99e..0606b8f 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -3,7 +3,7 @@
 
 #include "../perf.h"
 #include "list.h"
-#include "rbtree.h"
+#include <linux/rbtree.h>
 #include "symbol.h"
 
 
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
new file mode 100644
index 0000000..99c1b3d
--- /dev/null
+++ b/tools/perf/util/include/linux/kernel.h
@@ -0,0 +1,21 @@
+#ifndef PERF_LINUX_KERNEL_H_
+#define PERF_LINUX_KERNEL_H_
+
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
+
+#ifndef container_of
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof(((type *)0)->member) * __mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+#endif
+
+#endif
diff --git a/tools/perf/util/include/linux/module.h b/tools/perf/util/include/linux/module.h
new file mode 100644
index 0000000..b43e2dc
--- /dev/null
+++ b/tools/perf/util/include/linux/module.h
@@ -0,0 +1,6 @@
+#ifndef PERF_LINUX_MODULE_H
+#define PERF_LINUX_MODULE_H
+
+#define EXPORT_SYMBOL(name)
+
+#endif
diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
new file mode 100644
index 0000000..7a243a1
--- /dev/null
+++ b/tools/perf/util/include/linux/rbtree.h
@@ -0,0 +1 @@
+#include "../../../../include/linux/rbtree.h"
diff --git a/tools/perf/util/rbtree.c b/tools/perf/util/rbtree.c
deleted file mode 100644
index b15ba9c..0000000
--- a/tools/perf/util/rbtree.c
+++ /dev/null
@@ -1,383 +0,0 @@
-/*
-  Red Black Trees
-  (C) 1999  Andrea Arcangeli <andrea@suse.de>
-  (C) 2002  David Woodhouse <dwmw2@infradead.org>
-  
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-
-  linux/lib/rbtree.c
-*/
-
-#include "rbtree.h"
-
-static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *right = node->rb_right;
-	struct rb_node *parent = rb_parent(node);
-
-	if ((node->rb_right = right->rb_left))
-		rb_set_parent(right->rb_left, node);
-	right->rb_left = node;
-
-	rb_set_parent(right, parent);
-
-	if (parent)
-	{
-		if (node == parent->rb_left)
-			parent->rb_left = right;
-		else
-			parent->rb_right = right;
-	}
-	else
-		root->rb_node = right;
-	rb_set_parent(node, right);
-}
-
-static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *left = node->rb_left;
-	struct rb_node *parent = rb_parent(node);
-
-	if ((node->rb_left = left->rb_right))
-		rb_set_parent(left->rb_right, node);
-	left->rb_right = node;
-
-	rb_set_parent(left, parent);
-
-	if (parent)
-	{
-		if (node == parent->rb_right)
-			parent->rb_right = left;
-		else
-			parent->rb_left = left;
-	}
-	else
-		root->rb_node = left;
-	rb_set_parent(node, left);
-}
-
-void rb_insert_color(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *parent, *gparent;
-
-	while ((parent = rb_parent(node)) && rb_is_red(parent))
-	{
-		gparent = rb_parent(parent);
-
-		if (parent == gparent->rb_left)
-		{
-			{
-				register struct rb_node *uncle = gparent->rb_right;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
-			}
-
-			if (parent->rb_right == node)
-			{
-				register struct rb_node *tmp;
-				__rb_rotate_left(parent, root);
-				tmp = parent;
-				parent = node;
-				node = tmp;
-			}
-
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_right(gparent, root);
-		} else {
-			{
-				register struct rb_node *uncle = gparent->rb_left;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
-			}
-
-			if (parent->rb_left == node)
-			{
-				register struct rb_node *tmp;
-				__rb_rotate_right(parent, root);
-				tmp = parent;
-				parent = node;
-				node = tmp;
-			}
-
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_left(gparent, root);
-		}
-	}
-
-	rb_set_black(root->rb_node);
-}
-
-static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
-			     struct rb_root *root)
-{
-	struct rb_node *other;
-
-	while ((!node || rb_is_black(node)) && node != root->rb_node)
-	{
-		if (parent->rb_left == node)
-		{
-			other = parent->rb_right;
-			if (rb_is_red(other))
-			{
-				rb_set_black(other);
-				rb_set_red(parent);
-				__rb_rotate_left(parent, root);
-				other = parent->rb_right;
-			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
-			}
-			else
-			{
-				if (!other->rb_right || rb_is_black(other->rb_right))
-				{
-					rb_set_black(other->rb_left);
-					rb_set_red(other);
-					__rb_rotate_right(other, root);
-					other = parent->rb_right;
-				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				rb_set_black(other->rb_right);
-				__rb_rotate_left(parent, root);
-				node = root->rb_node;
-				break;
-			}
-		}
-		else
-		{
-			other = parent->rb_left;
-			if (rb_is_red(other))
-			{
-				rb_set_black(other);
-				rb_set_red(parent);
-				__rb_rotate_right(parent, root);
-				other = parent->rb_left;
-			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
-			}
-			else
-			{
-				if (!other->rb_left || rb_is_black(other->rb_left))
-				{
-					rb_set_black(other->rb_right);
-					rb_set_red(other);
-					__rb_rotate_left(other, root);
-					other = parent->rb_left;
-				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				rb_set_black(other->rb_left);
-				__rb_rotate_right(parent, root);
-				node = root->rb_node;
-				break;
-			}
-		}
-	}
-	if (node)
-		rb_set_black(node);
-}
-
-void rb_erase(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *child, *parent;
-	int color;
-
-	if (!node->rb_left)
-		child = node->rb_right;
-	else if (!node->rb_right)
-		child = node->rb_left;
-	else
-	{
-		struct rb_node *old = node, *left;
-
-		node = node->rb_right;
-		while ((left = node->rb_left) != NULL)
-			node = left;
-		child = node->rb_right;
-		parent = rb_parent(node);
-		color = rb_color(node);
-
-		if (child)
-			rb_set_parent(child, parent);
-		if (parent == old) {
-			parent->rb_right = child;
-			parent = node;
-		} else
-			parent->rb_left = child;
-
-		node->rb_parent_color = old->rb_parent_color;
-		node->rb_right = old->rb_right;
-		node->rb_left = old->rb_left;
-
-		if (rb_parent(old))
-		{
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
-			else
-				rb_parent(old)->rb_right = node;
-		} else
-			root->rb_node = node;
-
-		rb_set_parent(old->rb_left, node);
-		if (old->rb_right)
-			rb_set_parent(old->rb_right, node);
-		goto color;
-	}
-
-	parent = rb_parent(node);
-	color = rb_color(node);
-
-	if (child)
-		rb_set_parent(child, parent);
-	if (parent)
-	{
-		if (parent->rb_left == node)
-			parent->rb_left = child;
-		else
-			parent->rb_right = child;
-	}
-	else
-		root->rb_node = child;
-
- color:
-	if (color == RB_BLACK)
-		__rb_erase_color(child, parent, root);
-}
-
-/*
- * This function returns the first node (in sort order) of the tree.
- */
-struct rb_node *rb_first(const struct rb_root *root)
-{
-	struct rb_node	*n;
-
-	n = root->rb_node;
-	if (!n)
-		return NULL;
-	while (n->rb_left)
-		n = n->rb_left;
-	return n;
-}
-
-struct rb_node *rb_last(const struct rb_root *root)
-{
-	struct rb_node	*n;
-
-	n = root->rb_node;
-	if (!n)
-		return NULL;
-	while (n->rb_right)
-		n = n->rb_right;
-	return n;
-}
-
-struct rb_node *rb_next(const struct rb_node *node)
-{
-	struct rb_node *parent;
-
-	if (rb_parent(node) == node)
-		return NULL;
-
-	/* If we have a right-hand child, go down and then left as far
-	   as we can. */
-	if (node->rb_right) {
-		node = node->rb_right; 
-		while (node->rb_left)
-			node=node->rb_left;
-		return (struct rb_node *)node;
-	}
-
-	/* No right-hand children.  Everything down and left is
-	   smaller than us, so any 'next' node must be in the general
-	   direction of our parent. Go up the tree; any time the
-	   ancestor is a right-hand child of its parent, keep going
-	   up. First time it's a left-hand child of its parent, said
-	   parent is our 'next' node. */
-	while ((parent = rb_parent(node)) && node == parent->rb_right)
-		node = parent;
-
-	return parent;
-}
-
-struct rb_node *rb_prev(const struct rb_node *node)
-{
-	struct rb_node *parent;
-
-	if (rb_parent(node) == node)
-		return NULL;
-
-	/* If we have a left-hand child, go down and then right as far
-	   as we can. */
-	if (node->rb_left) {
-		node = node->rb_left; 
-		while (node->rb_right)
-			node=node->rb_right;
-		return (struct rb_node *)node;
-	}
-
-	/* No left-hand children. Go up till we find an ancestor which
-	   is a right-hand child of its parent */
-	while ((parent = rb_parent(node)) && node == parent->rb_left)
-		node = parent;
-
-	return parent;
-}
-
-void rb_replace_node(struct rb_node *victim, struct rb_node *new,
-		     struct rb_root *root)
-{
-	struct rb_node *parent = rb_parent(victim);
-
-	/* Set the surrounding nodes to point to the replacement */
-	if (parent) {
-		if (victim == parent->rb_left)
-			parent->rb_left = new;
-		else
-			parent->rb_right = new;
-	} else {
-		root->rb_node = new;
-	}
-	if (victim->rb_left)
-		rb_set_parent(victim->rb_left, new);
-	if (victim->rb_right)
-		rb_set_parent(victim->rb_right, new);
-
-	/* Copy the pointers/colour from the victim to the replacement */
-	*new = *victim;
-}
diff --git a/tools/perf/util/rbtree.h b/tools/perf/util/rbtree.h
deleted file mode 100644
index 6bdc488..0000000
--- a/tools/perf/util/rbtree.h
+++ /dev/null
@@ -1,171 +0,0 @@
-/*
-  Red Black Trees
-  (C) 1999  Andrea Arcangeli <andrea@suse.de>
-  
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-
-  linux/include/linux/rbtree.h
-
-  To use rbtrees you'll have to implement your own insert and search cores.
-  This will avoid us to use callbacks and to drop drammatically performances.
-  I know it's not the cleaner way,  but in C (not in C++) to get
-  performances and genericity...
-
-  Some example of insert and search follows here. The search is a plain
-  normal search over an ordered tree. The insert instead must be implemented
-  int two steps: as first thing the code must insert the element in
-  order as a red leaf in the tree, then the support library function
-  rb_insert_color() must be called. Such function will do the
-  not trivial work to rebalance the rbtree if necessary.
-
------------------------------------------------------------------------
-static inline struct page * rb_search_page_cache(struct inode * inode,
-						 unsigned long offset)
-{
-	struct rb_node * n = inode->i_rb_page_cache.rb_node;
-	struct page * page;
-
-	while (n)
-	{
-		page = rb_entry(n, struct page, rb_page_cache);
-
-		if (offset < page->offset)
-			n = n->rb_left;
-		else if (offset > page->offset)
-			n = n->rb_right;
-		else
-			return page;
-	}
-	return NULL;
-}
-
-static inline struct page * __rb_insert_page_cache(struct inode * inode,
-						   unsigned long offset,
-						   struct rb_node * node)
-{
-	struct rb_node ** p = &inode->i_rb_page_cache.rb_node;
-	struct rb_node * parent = NULL;
-	struct page * page;
-
-	while (*p)
-	{
-		parent = *p;
-		page = rb_entry(parent, struct page, rb_page_cache);
-
-		if (offset < page->offset)
-			p = &(*p)->rb_left;
-		else if (offset > page->offset)
-			p = &(*p)->rb_right;
-		else
-			return page;
-	}
-
-	rb_link_node(node, parent, p);
-
-	return NULL;
-}
-
-static inline struct page * rb_insert_page_cache(struct inode * inode,
-						 unsigned long offset,
-						 struct rb_node * node)
-{
-	struct page * ret;
-	if ((ret = __rb_insert_page_cache(inode, offset, node)))
-		goto out;
-	rb_insert_color(node, &inode->i_rb_page_cache);
- out:
-	return ret;
-}
------------------------------------------------------------------------
-*/
-
-#ifndef	_LINUX_RBTREE_H
-#define	_LINUX_RBTREE_H
-
-#include <stddef.h>
-
-/**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
-
-struct rb_node
-{
-	unsigned long  rb_parent_color;
-#define	RB_RED		0
-#define	RB_BLACK	1
-	struct rb_node *rb_right;
-	struct rb_node *rb_left;
-} __attribute__((aligned(sizeof(long))));
-    /* The alignment might seem pointless, but allegedly CRIS needs it */
-
-struct rb_root
-{
-	struct rb_node *rb_node;
-};
-
-
-#define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
-#define rb_color(r)   ((r)->rb_parent_color & 1)
-#define rb_is_red(r)   (!rb_color(r))
-#define rb_is_black(r) rb_color(r)
-#define rb_set_red(r)  do { (r)->rb_parent_color &= ~1; } while (0)
-#define rb_set_black(r)  do { (r)->rb_parent_color |= 1; } while (0)
-
-static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
-{
-	rb->rb_parent_color = (rb->rb_parent_color & 3) | (unsigned long)p;
-}
-static inline void rb_set_color(struct rb_node *rb, int color)
-{
-	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
-}
-
-#define RB_ROOT	(struct rb_root) { NULL, }
-#define	rb_entry(ptr, type, member) container_of(ptr, type, member)
-
-#define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
-#define RB_EMPTY_NODE(node)	(rb_parent(node) == node)
-#define RB_CLEAR_NODE(node)	(rb_set_parent(node, node))
-
-extern void rb_insert_color(struct rb_node *, struct rb_root *);
-extern void rb_erase(struct rb_node *, struct rb_root *);
-
-/* Find logical next and previous nodes in a tree */
-extern struct rb_node *rb_next(const struct rb_node *);
-extern struct rb_node *rb_prev(const struct rb_node *);
-extern struct rb_node *rb_first(const struct rb_root *);
-extern struct rb_node *rb_last(const struct rb_root *);
-
-/* Fast replacement of a single node without remove/rebalance/add/rebalance */
-extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
-			    struct rb_root *root);
-
-static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
-				struct rb_node ** rb_link)
-{
-	node->rb_parent_color = (unsigned long )parent;
-	node->rb_left = node->rb_right = NULL;
-
-	*rb_link = node;
-}
-
-#endif	/* _LINUX_RBTREE_H */
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 2fb117f..2fdcfee 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -1,7 +1,7 @@
 #ifndef STRLIST_H_
 #define STRLIST_H_
 
-#include "rbtree.h"
+#include <linux/rbtree.h>
 #include <stdbool.h>
 
 struct str_node {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 2c48ace..3a275db 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 #include "types.h"
 #include "list.h"
-#include "rbtree.h"
+#include <linux/rbtree.h>
 
 struct symbol {
 	struct rb_node	rb_node;
