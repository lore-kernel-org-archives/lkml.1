Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYL0JYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYL0JYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYL0JXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:23:23 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:50729 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYL0JXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:23:20 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4/4] kconfig: improve readout when we hit recursive dependencies
Date: Sat, 27 Dec 2008 10:24:54 +0100
Message-Id: <1230369894-10510-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081227090339.GA6279@uranus.ravnborg.org>
References: <20081227090339.GA6279@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following sample:
    config TEST1
            bool
            depends on TEST2 && PCI
            select TEST2

    config TEST2
            bool

Will result in the following output:

    Kconfig:1:error: found recursive dependency:
                TEST1
             -> TEST2 (arch/x86/Kconfig:6)
             -> TEST1 (arch/x86/Kconfig:1)

The sample above gave a segmentation fault
which is also fixed by this patch.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/expr.h   |    1 +
 scripts/kconfig/menu.c   |    2 ++
 scripts/kconfig/symbol.c |   11 ++++++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 6408fef..d587895 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -132,6 +132,7 @@ enum prop_type {
 	P_SELECT,   /* select BAR */
 	P_RANGE,    /* range 7..100 (for a symbol) */
 	P_ENV,      /* value from environment variable */
+	P_SYMBOL,   /* where a symbol is defined */
 };
 
 struct property {
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 07ff8d1..aa0e2f2 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -55,6 +55,8 @@ void menu_add_entry(struct symbol *sym)
 	*last_entry_ptr = menu;
 	last_entry_ptr = &menu->next;
 	current_entry = menu;
+	if (sym)
+		 menu_add_prop(P_SYMBOL, NULL, NULL, NULL);
 }
 
 void menu_end_entry(void)
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 18f3e5c..474dae2 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -856,8 +856,9 @@ struct symbol *sym_check_deps(struct symbol *sym)
 	struct property *prop;
 
 	if (sym->flags & SYMBOL_CHECK) {
-		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
-		        sym->prop->file->name, sym->prop->lineno,
+		fprintf(stderr, "%s:%d:error: found recursive dependency:\n",
+		        sym->prop->file->name, sym->prop->lineno);
+		fprintf(stderr, "\t    %s\n",
 			sym->name ? sym->name : "<choice>");
 		return sym;
 	}
@@ -877,7 +878,9 @@ struct symbol *sym_check_deps(struct symbol *sym)
 	}
 
 	if (sym2) {
-		fprintf(stderr, " -> %s", sym->name ? sym->name : "<choice>");
+		fprintf(stderr, "\t -> %s (%s:%d)\n",
+		        sym->name ? sym->name : "<choice>",
+			sym->prop->file->name, sym->prop->lineno);
 		if (sym2 == sym) {
 			fprintf(stderr, "\n");
 			zconfnerrs++;
@@ -937,6 +940,8 @@ const char *prop_get_type_name(enum prop_type type)
 		return "select";
 	case P_RANGE:
 		return "range";
+	case P_SYMBOL:
+		return "symbol";
 	case P_UNKNOWN:
 		break;
 	}
-- 
1.6.0.2.GIT

