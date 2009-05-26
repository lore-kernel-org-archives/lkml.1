Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZEZMOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZEZMOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbZEZMNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:13:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:51259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbZEZMNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:13:51 -0400
Date: Tue, 26 May 2009 12:13:12 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Use rb_trees in perf report
Message-ID: <tip-35a50c8a20eea22c141e05c5667ac21c48b8b65d@git.kernel.org>
Git-Commit-ID: 35a50c8a20eea22c141e05c5667ac21c48b8b65d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 12:13:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35a50c8a20eea22c141e05c5667ac21c48b8b65d
Gitweb:     http://git.kernel.org/tip/35a50c8a20eea22c141e05c5667ac21c48b8b65d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 18 May 2009 16:24:49 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 13:52:55 +0200

perf_counter: Use rb_trees in perf report

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile         |    3 +
 Documentation/perf_counter/builtin-report.c |   60 +++--
 Documentation/perf_counter/util/rbtree.c    |  383 +++++++++++++++++++++++++++
 Documentation/perf_counter/util/rbtree.h    |  171 ++++++++++++
 4 files changed, 601 insertions(+), 16 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 6bffa86..412dea1 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -287,6 +287,8 @@ LIB_FILE=libperf.a
 
 LIB_H += ../../include/linux/perf_counter.h
 LIB_H += perf.h
+LIB_H += util/list.h
+LIB_H += util/rbtree.h
 LIB_H += util/levenshtein.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
@@ -306,6 +308,7 @@ LIB_OBJS += util/levenshtein.o
 LIB_OBJS += util/parse-options.o
 LIB_OBJS += util/parse-events.o
 LIB_OBJS += util/path.o
+LIB_OBJS += util/rbtree.o
 LIB_OBJS += util/run-command.o
 LIB_OBJS += util/quote.o
 LIB_OBJS += util/strbuf.o
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index ad2f327..f63057f 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -32,7 +32,8 @@
 #include <linux/types.h>
 
 #include "../../include/linux/perf_counter.h"
-#include "list.h"
+#include "util/list.h"
+#include "util/rbtree.h"
 
 #define SHOW_KERNEL	1
 #define SHOW_USER	2
@@ -106,10 +107,10 @@ static void section__delete(struct section *self)
 }
 
 struct symbol {
-	struct list_head node;
-	uint64_t	 start;
-	uint64_t	 end;
-	char		 name[0];
+	struct rb_node rb_node;
+	uint64_t       start;
+	uint64_t       end;
+	char	       name[0];
 };
 
 static struct symbol *symbol__new(uint64_t start, uint64_t len, const char *name)
@@ -139,7 +140,7 @@ static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 struct dso {
 	struct list_head node;
 	struct list_head sections;
-	struct list_head syms;
+	struct rb_root	 syms;
 	char		 name[0];
 };
 
@@ -150,7 +151,7 @@ static struct dso *dso__new(const char *name)
 	if (self != NULL) {
 		strcpy(self->name, name);
 		INIT_LIST_HEAD(&self->sections);
-		INIT_LIST_HEAD(&self->syms);
+		self->syms = RB_ROOT;
 	}
 
 	return self;
@@ -166,10 +167,14 @@ static void dso__delete_sections(struct dso *self)
 
 static void dso__delete_symbols(struct dso *self)
 {
-	struct symbol *pos, *n;
+	struct symbol *pos;
+	struct rb_node *next = rb_first(&self->syms);
 
-	list_for_each_entry_safe(pos, n, &self->syms, node)
+	while (next) {
+		pos = rb_entry(next, struct symbol, rb_node);
+		next = rb_next(&pos->rb_node);
 		symbol__delete(pos);
+	}
 }
 
 static void dso__delete(struct dso *self)
@@ -181,7 +186,21 @@ static void dso__delete(struct dso *self)
 
 static void dso__insert_symbol(struct dso *self, struct symbol *sym)
 {
-	list_add_tail(&sym->node, &self->syms);
+	struct rb_node **p = &self->syms.rb_node;
+	struct rb_node *parent = NULL;
+	const uint64_t ip = sym->start;
+	struct symbol *s;
+
+	while (*p != NULL) {
+		parent = *p;
+		s = rb_entry(parent, struct symbol, rb_node);
+		if (ip < s->start)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&sym->rb_node, parent, p);
+	rb_insert_color(&sym->rb_node, &self->syms);
 }
 
 static struct symbol *dso__find_symbol(struct dso *self, uint64_t ip)
@@ -189,11 +208,18 @@ static struct symbol *dso__find_symbol(struct dso *self, uint64_t ip)
 	if (self == NULL)
 		return NULL;
 
-	struct symbol *pos;
+	struct rb_node *n = self->syms.rb_node;
 
-	list_for_each_entry(pos, &self->syms, node)
-		if (ip >= pos->start && ip <= pos->end)
-			return pos;
+	while (n) {
+		struct symbol *s = rb_entry(n, struct symbol, rb_node);
+
+		if (ip < s->start)
+			n = n->rb_left;
+		else if (ip > s->end)
+			n = n->rb_right;
+		else
+			return s;
+	}
 
 	return NULL;
 }
@@ -319,11 +345,13 @@ out_close:
 
 static size_t dso__fprintf(struct dso *self, FILE *fp)
 {
-	struct symbol *pos;
 	size_t ret = fprintf(fp, "dso: %s\n", self->name);
 
-	list_for_each_entry(pos, &self->syms, node)
+	struct rb_node *nd;
+	for (nd = rb_first(&self->syms); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
 		ret += symbol__fprintf(pos, fp);
+	}
 
 	return ret;
 }
diff --git a/Documentation/perf_counter/util/rbtree.c b/Documentation/perf_counter/util/rbtree.c
new file mode 100644
index 0000000..b15ba9c
--- /dev/null
+++ b/Documentation/perf_counter/util/rbtree.c
@@ -0,0 +1,383 @@
+/*
+  Red Black Trees
+  (C) 1999  Andrea Arcangeli <andrea@suse.de>
+  (C) 2002  David Woodhouse <dwmw2@infradead.org>
+  
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+  linux/lib/rbtree.c
+*/
+
+#include "rbtree.h"
+
+static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
+{
+	struct rb_node *right = node->rb_right;
+	struct rb_node *parent = rb_parent(node);
+
+	if ((node->rb_right = right->rb_left))
+		rb_set_parent(right->rb_left, node);
+	right->rb_left = node;
+
+	rb_set_parent(right, parent);
+
+	if (parent)
+	{
+		if (node == parent->rb_left)
+			parent->rb_left = right;
+		else
+			parent->rb_right = right;
+	}
+	else
+		root->rb_node = right;
+	rb_set_parent(node, right);
+}
+
+static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
+{
+	struct rb_node *left = node->rb_left;
+	struct rb_node *parent = rb_parent(node);
+
+	if ((node->rb_left = left->rb_right))
+		rb_set_parent(left->rb_right, node);
+	left->rb_right = node;
+
+	rb_set_parent(left, parent);
+
+	if (parent)
+	{
+		if (node == parent->rb_right)
+			parent->rb_right = left;
+		else
+			parent->rb_left = left;
+	}
+	else
+		root->rb_node = left;
+	rb_set_parent(node, left);
+}
+
+void rb_insert_color(struct rb_node *node, struct rb_root *root)
+{
+	struct rb_node *parent, *gparent;
+
+	while ((parent = rb_parent(node)) && rb_is_red(parent))
+	{
+		gparent = rb_parent(parent);
+
+		if (parent == gparent->rb_left)
+		{
+			{
+				register struct rb_node *uncle = gparent->rb_right;
+				if (uncle && rb_is_red(uncle))
+				{
+					rb_set_black(uncle);
+					rb_set_black(parent);
+					rb_set_red(gparent);
+					node = gparent;
+					continue;
+				}
+			}
+
+			if (parent->rb_right == node)
+			{
+				register struct rb_node *tmp;
+				__rb_rotate_left(parent, root);
+				tmp = parent;
+				parent = node;
+				node = tmp;
+			}
+
+			rb_set_black(parent);
+			rb_set_red(gparent);
+			__rb_rotate_right(gparent, root);
+		} else {
+			{
+				register struct rb_node *uncle = gparent->rb_left;
+				if (uncle && rb_is_red(uncle))
+				{
+					rb_set_black(uncle);
+					rb_set_black(parent);
+					rb_set_red(gparent);
+					node = gparent;
+					continue;
+				}
+			}
+
+			if (parent->rb_left == node)
+			{
+				register struct rb_node *tmp;
+				__rb_rotate_right(parent, root);
+				tmp = parent;
+				parent = node;
+				node = tmp;
+			}
+
+			rb_set_black(parent);
+			rb_set_red(gparent);
+			__rb_rotate_left(gparent, root);
+		}
+	}
+
+	rb_set_black(root->rb_node);
+}
+
+static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
+			     struct rb_root *root)
+{
+	struct rb_node *other;
+
+	while ((!node || rb_is_black(node)) && node != root->rb_node)
+	{
+		if (parent->rb_left == node)
+		{
+			other = parent->rb_right;
+			if (rb_is_red(other))
+			{
+				rb_set_black(other);
+				rb_set_red(parent);
+				__rb_rotate_left(parent, root);
+				other = parent->rb_right;
+			}
+			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
+			    (!other->rb_right || rb_is_black(other->rb_right)))
+			{
+				rb_set_red(other);
+				node = parent;
+				parent = rb_parent(node);
+			}
+			else
+			{
+				if (!other->rb_right || rb_is_black(other->rb_right))
+				{
+					rb_set_black(other->rb_left);
+					rb_set_red(other);
+					__rb_rotate_right(other, root);
+					other = parent->rb_right;
+				}
+				rb_set_color(other, rb_color(parent));
+				rb_set_black(parent);
+				rb_set_black(other->rb_right);
+				__rb_rotate_left(parent, root);
+				node = root->rb_node;
+				break;
+			}
+		}
+		else
+		{
+			other = parent->rb_left;
+			if (rb_is_red(other))
+			{
+				rb_set_black(other);
+				rb_set_red(parent);
+				__rb_rotate_right(parent, root);
+				other = parent->rb_left;
+			}
+			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
+			    (!other->rb_right || rb_is_black(other->rb_right)))
+			{
+				rb_set_red(other);
+				node = parent;
+				parent = rb_parent(node);
+			}
+			else
+			{
+				if (!other->rb_left || rb_is_black(other->rb_left))
+				{
+					rb_set_black(other->rb_right);
+					rb_set_red(other);
+					__rb_rotate_left(other, root);
+					other = parent->rb_left;
+				}
+				rb_set_color(other, rb_color(parent));
+				rb_set_black(parent);
+				rb_set_black(other->rb_left);
+				__rb_rotate_right(parent, root);
+				node = root->rb_node;
+				break;
+			}
+		}
+	}
+	if (node)
+		rb_set_black(node);
+}
+
+void rb_erase(struct rb_node *node, struct rb_root *root)
+{
+	struct rb_node *child, *parent;
+	int color;
+
+	if (!node->rb_left)
+		child = node->rb_right;
+	else if (!node->rb_right)
+		child = node->rb_left;
+	else
+	{
+		struct rb_node *old = node, *left;
+
+		node = node->rb_right;
+		while ((left = node->rb_left) != NULL)
+			node = left;
+		child = node->rb_right;
+		parent = rb_parent(node);
+		color = rb_color(node);
+
+		if (child)
+			rb_set_parent(child, parent);
+		if (parent == old) {
+			parent->rb_right = child;
+			parent = node;
+		} else
+			parent->rb_left = child;
+
+		node->rb_parent_color = old->rb_parent_color;
+		node->rb_right = old->rb_right;
+		node->rb_left = old->rb_left;
+
+		if (rb_parent(old))
+		{
+			if (rb_parent(old)->rb_left == old)
+				rb_parent(old)->rb_left = node;
+			else
+				rb_parent(old)->rb_right = node;
+		} else
+			root->rb_node = node;
+
+		rb_set_parent(old->rb_left, node);
+		if (old->rb_right)
+			rb_set_parent(old->rb_right, node);
+		goto color;
+	}
+
+	parent = rb_parent(node);
+	color = rb_color(node);
+
+	if (child)
+		rb_set_parent(child, parent);
+	if (parent)
+	{
+		if (parent->rb_left == node)
+			parent->rb_left = child;
+		else
+			parent->rb_right = child;
+	}
+	else
+		root->rb_node = child;
+
+ color:
+	if (color == RB_BLACK)
+		__rb_erase_color(child, parent, root);
+}
+
+/*
+ * This function returns the first node (in sort order) of the tree.
+ */
+struct rb_node *rb_first(const struct rb_root *root)
+{
+	struct rb_node	*n;
+
+	n = root->rb_node;
+	if (!n)
+		return NULL;
+	while (n->rb_left)
+		n = n->rb_left;
+	return n;
+}
+
+struct rb_node *rb_last(const struct rb_root *root)
+{
+	struct rb_node	*n;
+
+	n = root->rb_node;
+	if (!n)
+		return NULL;
+	while (n->rb_right)
+		n = n->rb_right;
+	return n;
+}
+
+struct rb_node *rb_next(const struct rb_node *node)
+{
+	struct rb_node *parent;
+
+	if (rb_parent(node) == node)
+		return NULL;
+
+	/* If we have a right-hand child, go down and then left as far
+	   as we can. */
+	if (node->rb_right) {
+		node = node->rb_right; 
+		while (node->rb_left)
+			node=node->rb_left;
+		return (struct rb_node *)node;
+	}
+
+	/* No right-hand children.  Everything down and left is
+	   smaller than us, so any 'next' node must be in the general
+	   direction of our parent. Go up the tree; any time the
+	   ancestor is a right-hand child of its parent, keep going
+	   up. First time it's a left-hand child of its parent, said
+	   parent is our 'next' node. */
+	while ((parent = rb_parent(node)) && node == parent->rb_right)
+		node = parent;
+
+	return parent;
+}
+
+struct rb_node *rb_prev(const struct rb_node *node)
+{
+	struct rb_node *parent;
+
+	if (rb_parent(node) == node)
+		return NULL;
+
+	/* If we have a left-hand child, go down and then right as far
+	   as we can. */
+	if (node->rb_left) {
+		node = node->rb_left; 
+		while (node->rb_right)
+			node=node->rb_right;
+		return (struct rb_node *)node;
+	}
+
+	/* No left-hand children. Go up till we find an ancestor which
+	   is a right-hand child of its parent */
+	while ((parent = rb_parent(node)) && node == parent->rb_left)
+		node = parent;
+
+	return parent;
+}
+
+void rb_replace_node(struct rb_node *victim, struct rb_node *new,
+		     struct rb_root *root)
+{
+	struct rb_node *parent = rb_parent(victim);
+
+	/* Set the surrounding nodes to point to the replacement */
+	if (parent) {
+		if (victim == parent->rb_left)
+			parent->rb_left = new;
+		else
+			parent->rb_right = new;
+	} else {
+		root->rb_node = new;
+	}
+	if (victim->rb_left)
+		rb_set_parent(victim->rb_left, new);
+	if (victim->rb_right)
+		rb_set_parent(victim->rb_right, new);
+
+	/* Copy the pointers/colour from the victim to the replacement */
+	*new = *victim;
+}
diff --git a/Documentation/perf_counter/util/rbtree.h b/Documentation/perf_counter/util/rbtree.h
new file mode 100644
index 0000000..6bdc488
--- /dev/null
+++ b/Documentation/perf_counter/util/rbtree.h
@@ -0,0 +1,171 @@
+/*
+  Red Black Trees
+  (C) 1999  Andrea Arcangeli <andrea@suse.de>
+  
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+  linux/include/linux/rbtree.h
+
+  To use rbtrees you'll have to implement your own insert and search cores.
+  This will avoid us to use callbacks and to drop drammatically performances.
+  I know it's not the cleaner way,  but in C (not in C++) to get
+  performances and genericity...
+
+  Some example of insert and search follows here. The search is a plain
+  normal search over an ordered tree. The insert instead must be implemented
+  int two steps: as first thing the code must insert the element in
+  order as a red leaf in the tree, then the support library function
+  rb_insert_color() must be called. Such function will do the
+  not trivial work to rebalance the rbtree if necessary.
+
+-----------------------------------------------------------------------
+static inline struct page * rb_search_page_cache(struct inode * inode,
+						 unsigned long offset)
+{
+	struct rb_node * n = inode->i_rb_page_cache.rb_node;
+	struct page * page;
+
+	while (n)
+	{
+		page = rb_entry(n, struct page, rb_page_cache);
+
+		if (offset < page->offset)
+			n = n->rb_left;
+		else if (offset > page->offset)
+			n = n->rb_right;
+		else
+			return page;
+	}
+	return NULL;
+}
+
+static inline struct page * __rb_insert_page_cache(struct inode * inode,
+						   unsigned long offset,
+						   struct rb_node * node)
+{
+	struct rb_node ** p = &inode->i_rb_page_cache.rb_node;
+	struct rb_node * parent = NULL;
+	struct page * page;
+
+	while (*p)
+	{
+		parent = *p;
+		page = rb_entry(parent, struct page, rb_page_cache);
+
+		if (offset < page->offset)
+			p = &(*p)->rb_left;
+		else if (offset > page->offset)
+			p = &(*p)->rb_right;
+		else
+			return page;
+	}
+
+	rb_link_node(node, parent, p);
+
+	return NULL;
+}
+
+static inline struct page * rb_insert_page_cache(struct inode * inode,
+						 unsigned long offset,
+						 struct rb_node * node)
+{
+	struct page * ret;
+	if ((ret = __rb_insert_page_cache(inode, offset, node)))
+		goto out;
+	rb_insert_color(node, &inode->i_rb_page_cache);
+ out:
+	return ret;
+}
+-----------------------------------------------------------------------
+*/
+
+#ifndef	_LINUX_RBTREE_H
+#define	_LINUX_RBTREE_H
+
+#include <stddef.h>
+
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+struct rb_node
+{
+	unsigned long  rb_parent_color;
+#define	RB_RED		0
+#define	RB_BLACK	1
+	struct rb_node *rb_right;
+	struct rb_node *rb_left;
+} __attribute__((aligned(sizeof(long))));
+    /* The alignment might seem pointless, but allegedly CRIS needs it */
+
+struct rb_root
+{
+	struct rb_node *rb_node;
+};
+
+
+#define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
+#define rb_color(r)   ((r)->rb_parent_color & 1)
+#define rb_is_red(r)   (!rb_color(r))
+#define rb_is_black(r) rb_color(r)
+#define rb_set_red(r)  do { (r)->rb_parent_color &= ~1; } while (0)
+#define rb_set_black(r)  do { (r)->rb_parent_color |= 1; } while (0)
+
+static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
+{
+	rb->rb_parent_color = (rb->rb_parent_color & 3) | (unsigned long)p;
+}
+static inline void rb_set_color(struct rb_node *rb, int color)
+{
+	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
+}
+
+#define RB_ROOT	(struct rb_root) { NULL, }
+#define	rb_entry(ptr, type, member) container_of(ptr, type, member)
+
+#define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
+#define RB_EMPTY_NODE(node)	(rb_parent(node) == node)
+#define RB_CLEAR_NODE(node)	(rb_set_parent(node, node))
+
+extern void rb_insert_color(struct rb_node *, struct rb_root *);
+extern void rb_erase(struct rb_node *, struct rb_root *);
+
+/* Find logical next and previous nodes in a tree */
+extern struct rb_node *rb_next(const struct rb_node *);
+extern struct rb_node *rb_prev(const struct rb_node *);
+extern struct rb_node *rb_first(const struct rb_root *);
+extern struct rb_node *rb_last(const struct rb_root *);
+
+/* Fast replacement of a single node without remove/rebalance/add/rebalance */
+extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
+			    struct rb_root *root);
+
+static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
+				struct rb_node ** rb_link)
+{
+	node->rb_parent_color = (unsigned long )parent;
+	node->rb_left = node->rb_right = NULL;
+
+	*rb_link = node;
+}
+
+#endif	/* _LINUX_RBTREE_H */
