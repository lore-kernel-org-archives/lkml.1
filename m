Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZHLPzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZHLPzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZHLPzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:55:39 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62794 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924AbZHLPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:55:38 -0400
Subject: Re: [RFC PATCH] kbuild: Do not select symbols with unmet
	dependencies
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1250085624.20332.48.camel@pc1117.cambridge.arm.com>
References: <20090812112308.30683.24700.stgit@pc1117.cambridge.arm.com>
	 <200908121436.58490.arnd@arndb.de>
	 <1250085624.20332.48.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 12 Aug 2009 16:55:22 +0100
Message-Id: <1250092522.20332.74.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2009 15:55:23.0253 (UTC) FILETIME=[4D17C250:01CA1B65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 15:00 +0100, Catalin Marinas wrote:
> I can generate a list with allyesconfig but it looks like it breaks some
> common usage in Linux. For example, the VIDEO_* entries in
> drivers/media/video/Kconfig under the "Encoders/decoders and other
> helper chips" menu automatically inherit a dependency on
> !VIDEO_HELPER_CHIPS_AUTO. This option is enabled to allow other config
> options to select whatever they need. But it would fail with my patch
> because of the direct dependency of the VIDEO_* options on
> !VIDEO_HELPER_CHIPS_AUTO.

It seems that allyesconfig is not the best test since the direct
dependencies tend to be true most of the time. It only showed a problem
with IP_VS_PROTO_AH_ESP which depends on UNDEFINED but is still
selected.

I modified the patch slightly to only consider the "depends on"
statements specific to a config option (without inherited ones) when
validating the "select" statements. This would allow the above menu
usecase without problems.

As for avoiding run-time regressions, the patch should either only warn
but continue as before or fail the kernel building in the config stage
so that the Kconfig files are fixed.

Here's the updated patch:


kbuild: Do not select symbols with unmet dependencies

From: Catalin Marinas <catalin.marinas@arm.com>

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
 scripts/kconfig/expr.h   |    2 ++
 scripts/kconfig/menu.c   |    5 +++++
 scripts/kconfig/symbol.c |   17 ++++++++++++++++-
 3 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 6408fef..c8be420 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -83,6 +83,7 @@ struct symbol {
 	tristate visible;
 	int flags;
 	struct property *prop;
+	struct expr_value dir_dep;
 	struct expr_value rev_dep;
 };
 
@@ -164,6 +165,7 @@ struct menu {
 	struct symbol *sym;
 	struct property *prompt;
 	struct expr *dep;
+	struct expr *dir_dep;
 	unsigned int flags;
 	char *help;
 	struct file *file;
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 07ff8d1..16e713f 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -102,6 +102,7 @@ struct expr *menu_check_dep(struct expr *e)
 void menu_add_dep(struct expr *dep)
 {
 	current_entry->dep = expr_alloc_and(current_entry->dep, menu_check_dep(dep));
+	current_entry->dir_dep = current_entry->dep;
 }
 
 void menu_set_type(int type)
@@ -285,6 +286,10 @@ void menu_finalize(struct menu *parent)
 		for (menu = parent->list; menu; menu = menu->next)
 			menu_finalize(menu);
 	} else if (sym) {
+		/* ignore inherited dependencies for dir_dep */
+		sym->dir_dep.expr = expr_transform(expr_copy(parent->dir_dep));
+		sym->dir_dep.expr = expr_eliminate_dups(sym->dir_dep.expr);
+
 		basedep = parent->prompt ? parent->prompt->visible.expr : NULL;
 		basedep = expr_trans_compare(basedep, E_UNEQUAL, &symbol_no);
 		basedep = expr_eliminate_dups(expr_transform(basedep));
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 18f3e5c..3147d0a 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -205,6 +205,16 @@ static void sym_calc_visibility(struct symbol *sym)
 	}
 	if (sym_is_choice_value(sym))
 		return;
+	/* defaulting to "yes" if no explicit "depends on" are given */
+	tri = yes;
+	if (sym->dir_dep.expr)
+		tri = expr_calc_value(sym->dir_dep.expr);
+	if (tri == mod)
+		tri = yes;
+	if (sym->dir_dep.tri != tri) {
+		sym->dir_dep.tri = tri;
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
+			if (sym->dir_dep.tri == no && sym->rev_dep.tri != no)
+				fprintf(stderr, "warning: not selecting symbol with unmet dependencies: %s\n",
+					sym->name);
+			else
+				newval.tri = EXPR_OR(newval.tri,
+						     sym->rev_dep.tri);
 		}
 		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)
 			newval.tri = yes;


-- 
Catalin

