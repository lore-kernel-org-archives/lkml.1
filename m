Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYLaC6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYLaC6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 21:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYLaC5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:57:53 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3780 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbYLaC5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:57:51 -0500
Date: Wed, 31 Dec 2008 03:55:00 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] kconfig: print all locations when we see a recursive
 dependency
In-Reply-To: <1230558803-7168-6-git-send-email-sam@ravnborg.org>
Message-ID: <Pine.LNX.4.64.0812310346430.17013@localhost.localdomain>
References: <20081229134402.GA7069@uranus.ravnborg.org>
 <1230558803-7168-6-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 29 Dec 2008, Sam Ravnborg wrote:

> It is nessesary to know all locations when trying to track
> a recursive dependency. So print out all locations for each symbol.

The problem is that this is little more than a better grep, although 
kconfig knows exactly what went wrong, but this info is scattered all over 
the stack.
We could either return more info to print more than just the symbol or 
maintain more info while traversing the tree. The patch below does the 
latter. The patch could use some small cleanups, so it's not final yet.

bye, Roman

---
 scripts/kconfig/symbol.c |  139 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 124 insertions(+), 15 deletions(-)

Index: linux-2.6-git/scripts/kconfig/symbol.c
===================================================================
--- linux-2.6-git.orig/scripts/kconfig/symbol.c	2008-12-31 03:42:05.000000000 +0100
+++ linux-2.6-git/scripts/kconfig/symbol.c	2008-12-31 03:43:34.000000000 +0100
@@ -760,6 +760,107 @@ struct symbol **sym_re_search(const char
 }
 
 
+static struct dep_stack {
+	struct dep_stack *prev, *next;
+	struct symbol *sym;
+	struct property *prop;
+	struct expr *expr;
+} *check_top;
+
+static void dep_stack_insert(struct dep_stack *stack, struct symbol *sym)
+{
+	memset(stack, 0, sizeof(*stack));
+	if (check_top)
+		check_top->next = stack;
+	stack->prev = check_top;
+	stack->sym = sym;
+	check_top = stack;
+}
+
+static void dep_stack_remove(void)
+{
+	check_top = check_top->prev;
+	if (check_top)
+		check_top->next = NULL;
+}
+
+static void sym_check_print_recursive(struct symbol *last_sym)
+{
+	struct dep_stack *stack;
+	struct symbol *sym, *next_sym;
+	struct menu *menu = NULL;
+	struct property *prop;
+	struct dep_stack cv_stack;
+
+	zconfnerrs++;
+	if (sym_is_choice_value(last_sym)) {
+		dep_stack_insert(&cv_stack, last_sym);
+		last_sym = prop_get_symbol(sym_get_choice_prop(last_sym));
+	}
+
+	for (stack = check_top; stack; stack = stack->prev)
+		if (stack->sym == last_sym)
+			break;
+	if (!stack) {
+		fprintf(stderr, "unexpected recursive dependency error\n");
+		return;
+	}
+
+	for (; stack; stack = stack->next) {
+		sym = stack->sym;
+		next_sym = stack->next ? stack->next->sym : last_sym;
+		prop = stack->prop;
+		if (sym_is_choice(sym) || sym_is_choice_value(sym)) {
+			for (prop = sym->prop; prop; prop = prop->next) {
+				menu = prop->menu;
+				if (prop->menu)
+					break;
+			}
+		} else if (!prop) {
+			for (prop = next_sym->prop; prop; prop = prop->next) {
+				if (prop->type != P_SELECT)
+					continue;
+				if (prop->expr->left.sym == sym)
+					break;
+			}
+		}
+		if (stack->sym == last_sym)
+			fprintf(stderr, "%s:%d:error: recursive dependency detected!\n",
+				prop->file->name, prop->lineno);
+		if (stack->expr) {
+			fprintf(stderr, "%s:%d:\tsymbol %s %s value contains %s\n",
+				prop->file->name, prop->lineno,
+				sym->name ? sym->name : "<choice>",
+				prop_get_type_name(prop->type),
+				next_sym->name ? next_sym->name : "<choice>");
+		} else if (stack->prop) {
+			fprintf(stderr, "%s:%d:\tsymbol %s %s depends on %s\n",
+				prop->file->name, prop->lineno,
+				sym->name ? sym->name : "<choice>",
+				prop_get_type_name(prop->type),
+				next_sym->name ? next_sym->name : "<choice>");
+		} else if (sym_is_choice(sym)) {
+			fprintf(stderr, "%s:%d:\tchoice %s contains symbol %s\n",
+				menu->file->name, menu->lineno,
+				sym->name ? sym->name : "<choice>",
+				next_sym->name ? next_sym->name : "<choice>");
+		} else if (sym_is_choice_value(sym)) {
+			fprintf(stderr, "%s:%d:\tsymbol %s is part of choice %s\n",
+				menu->file->name, menu->lineno,
+				sym->name ? sym->name : "<choice>",
+				next_sym->name ? next_sym->name : "<choice>");
+		} else {
+			fprintf(stderr, "%s:%d:\tsymbol %s is selected by %s\n",
+				prop->file->name, prop->lineno,
+				sym->name ? sym->name : "<choice>",
+				next_sym->name ? next_sym->name : "<choice>");
+		}
+	}
+
+	if (check_top == &cv_stack)
+		dep_stack_remove();
+}
+
 static struct symbol *sym_check_expr_deps(struct expr *e)
 {
 	struct symbol *sym;
@@ -795,24 +896,33 @@ static struct symbol *sym_check_sym_deps
 {
 	struct symbol *sym2;
 	struct property *prop;
+	struct dep_stack stack;
+
+	dep_stack_insert(&stack, sym);
 
 	sym2 = sym_check_expr_deps(sym->rev_dep.expr);
 	if (sym2)
-		return sym2;
+		goto out;
 
 	for (prop = sym->prop; prop; prop = prop->next) {
 		if (prop->type == P_CHOICE || prop->type == P_SELECT)
 			continue;
+		stack.prop = prop;
 		sym2 = sym_check_expr_deps(prop->visible.expr);
 		if (sym2)
 			break;
 		if (prop->type != P_DEFAULT || sym_is_choice(sym))
 			continue;
+		stack.expr = prop->expr;
 		sym2 = sym_check_expr_deps(prop->expr);
 		if (sym2)
 			break;
+		stack.expr = NULL;
 	}
 
+out:
+	dep_stack_remove();
+
 	return sym2;
 }
 
@@ -821,6 +931,9 @@ static struct symbol *sym_check_choice_d
 	struct symbol *sym, *sym2;
 	struct property *prop;
 	struct expr *e;
+	struct dep_stack stack;
+
+	dep_stack_insert(&stack, choice);
 
 	prop = sym_get_choice_prop(choice);
 	expr_list_for_each_sym(prop->expr, e, sym)
@@ -834,10 +947,8 @@ static struct symbol *sym_check_choice_d
 
 	expr_list_for_each_sym(prop->expr, e, sym) {
 		sym2 = sym_check_sym_deps(sym);
-		if (sym2) {
-			fprintf(stderr, " -> %s", sym->name);
+		if (sym2)
 			break;
-		}
 	}
 out:
 	expr_list_for_each_sym(prop->expr, e, sym)
@@ -847,6 +958,8 @@ out:
 	    prop_get_symbol(sym_get_choice_prop(sym2)) == choice)
 		sym2 = choice;
 
+	dep_stack_remove();
+
 	return sym2;
 }
 
@@ -856,18 +969,20 @@ struct symbol *sym_check_deps(struct sym
 	struct property *prop;
 
 	if (sym->flags & SYMBOL_CHECK) {
-		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
-		        sym->prop->file->name, sym->prop->lineno,
-			sym->name ? sym->name : "<choice>");
+		sym_check_print_recursive(sym);
 		return sym;
 	}
 	if (sym->flags & SYMBOL_CHECKED)
 		return NULL;
 
 	if (sym_is_choice_value(sym)) {
+		struct dep_stack stack;
+
 		/* for choice groups start the check with main choice symbol */
+		dep_stack_insert(&stack, sym);
 		prop = sym_get_choice_prop(sym);
 		sym2 = sym_check_deps(prop_get_symbol(prop));
+		dep_stack_remove();
 	} else if (sym_is_choice(sym)) {
 		sym2 = sym_check_choice_deps(sym);
 	} else {
@@ -876,14 +991,8 @@ struct symbol *sym_check_deps(struct sym
 		sym->flags &= ~SYMBOL_CHECK;
 	}
 
-	if (sym2) {
-		fprintf(stderr, " -> %s", sym->name ? sym->name : "<choice>");
-		if (sym2 == sym) {
-			fprintf(stderr, "\n");
-			zconfnerrs++;
-			sym2 = NULL;
-		}
-	}
+	if (sym2 && sym2 == sym)
+		sym2 = NULL;
 
 	return sym2;
 }
