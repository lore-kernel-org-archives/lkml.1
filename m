Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZHLLjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZHLLjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZHLLjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:39:45 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42645 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbZHLLjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:39:44 -0400
Subject: [RFC PATCH] kbuild: Do not select symbols with unmet dependencies
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 12 Aug 2009 12:39:40 +0100
Message-ID: <20090812112308.30683.24700.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-11-g9876
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2009 11:39:40.0811 (UTC) FILETIME=[9448E5B0:01CA1B41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "select" statement in Kconfig files allows the enabling of options
even if they have unmet direct dependencies (i.e. "depends on" expands
to "no"). Currently, the "depends on" clauses are used in calculating
the visibility but they do not affect the reverse dependencies in any
way.

The patch introduces additional tracking of the "depends on" statements
and does not allow selecting an option if its direct dependencies are
not met, also printing a warning.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---

This patch is meant to make "select" safer in Kconfig files. The
"depends on", if not true, takes priority over "select".

For example, in -next, the ARM FRAME_POINTER (arch/arm/Kconfig.debug)
depends on !THUMB2_KERNEL because compiling the kernel to the Thumb-2
instruction set and FRAME_POINTER enabled fails. However, there are
several places where this symbol is forced by "select" statements (where
stacktrace support would be enough). Another example is DEBUG_PAGEALLOC
which depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC (=n on ARM) but still
selected.

A safer approach currently may be to only warn but still select the
corresponding symbol.

The patch could probably be improved to also point to the symbols
containing the "select" statements, though I was getting some segfaults
with expr_list_for_each_sym(sym->rev_dep.expr).

Please note that the patch doesn't entirely follow the maximum line
length recommendation as none of the modified files comply with it.

Thank you for you comments.

 scripts/kconfig/expr.h   |    1 +
 scripts/kconfig/menu.c   |    5 +++++
 scripts/kconfig/symbol.c |   17 ++++++++++++++++-
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 6408fef..2381562 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -83,6 +83,7 @@ struct symbol {
 	tristate visible;
 	int flags;
 	struct property *prop;
+	struct expr_value dep;
 	struct expr_value rev_dep;
 };
 
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 07ff8d1..7d32d74 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -385,6 +385,11 @@ void menu_finalize(struct menu *parent)
 				expr_alloc_and(parent->prompt->visible.expr,
 					expr_alloc_symbol(&symbol_mod)));
 	}
+
+	if (sym) {
+		sym->dep.expr = expr_transform(expr_copy(parent->dep));
+		sym->dep.expr = expr_eliminate_dups(sym->dep.expr);
+	}
 }
 
 bool menu_is_visible(struct menu *menu)
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 18f3e5c..af362d0 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -205,6 +205,16 @@ static void sym_calc_visibility(struct symbol *sym)
 	}
 	if (sym_is_choice_value(sym))
 		return;
+	/* defaulting to "yes" if no explicit "depends on" are given */
+	tri = yes;
+	if (sym->dep.expr)
+		tri = expr_calc_value(sym->dep.expr);
+	if (tri == mod)
+		tri = yes;
+	if (sym->dep.tri != tri) {
+		sym->dep.tri = tri;
+		sym_set_changed(sym);
+	}
 	tri = no;
 	if (sym->rev_dep.expr)
 		tri = expr_calc_value(sym->rev_dep.expr);
@@ -321,7 +331,12 @@ void sym_calc_value(struct symbol *sym)
 				}
 			}
 		calc_newval:
-			newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
+			if (sym->dep.tri == no && sym->rev_dep.tri != no)
+				fprintf(stderr, "%s:%d:warning: not selecting symbol with unmet dependencies: %s\n",
+					sym->prop->file->name, sym->prop->lineno,
+					sym->name ? sym->name : "<choice>");
+			else
+				newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
 		}
 		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)
 			newval.tri = yes;

