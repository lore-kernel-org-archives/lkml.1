Return-Path: <linux-kernel-owner+w=401wt.eu-S933508AbYF3Vni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbYF3Vni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932958AbYF3VfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:35:03 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51667 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763112AbYF3Ved (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:33 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 20/24] kconfig: set all new symbols automatically
Date: Mon, 30 Jun 2008 23:35:14 +0200
Message-Id: <1214861718-32626-20-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Zippel <zippel@linux-m68k.org>

Add conf_set_all_new_symbols() which set all symbols (which don't have a
value yet) to a specifed value.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/confdata.c |   70 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/kconfig/lkc.h      |    9 +++++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index ee5fe94..0759761 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -812,3 +812,73 @@ void conf_set_changed_callback(void (*fn)(void))
 {
 	conf_changed_callback = fn;
 }
+
+
+void conf_set_all_new_symbols(enum conf_def_mode mode)
+{
+	struct symbol *sym, *csym;
+	struct property *prop;
+	struct expr *e;
+	int i, cnt, def;
+
+	for_all_symbols(i, sym) {
+		if (sym_has_value(sym))
+			continue;
+		switch (sym_get_type(sym)) {
+		case S_BOOLEAN:
+		case S_TRISTATE:
+			switch (mode) {
+			case def_yes:
+				sym->def[S_DEF_USER].tri = yes;
+				break;
+			case def_mod:
+				sym->def[S_DEF_USER].tri = mod;
+				break;
+			case def_no:
+				sym->def[S_DEF_USER].tri = no;
+				break;
+			case def_random:
+				sym->def[S_DEF_USER].tri = (tristate)(rand() % 3);
+				break;
+			default:
+				continue;
+			}
+			if (!sym_is_choice(sym) || mode != def_random)
+				sym->flags |= SYMBOL_DEF_USER;
+			break;
+		default:
+			break;
+		}
+
+	}
+
+	if (modules_sym)
+		sym_calc_value(modules_sym);
+
+	if (mode != def_random)
+		return;
+
+	for_all_symbols(i, csym) {
+		if (sym_has_value(csym) || !sym_is_choice(csym))
+			continue;
+
+		sym_calc_value(csym);
+		prop = sym_get_choice_prop(csym);
+		def = -1;
+		while (1) {
+			cnt = 0;
+			expr_list_for_each_sym(prop->expr, e, sym) {
+				if (sym->visible == no)
+					continue;
+				if (def == cnt++) {
+					csym->def[S_DEF_USER].val = sym;
+					break;
+				}
+			}
+			if (def >= 0 || cnt < 2)
+				break;
+			def = (rand() % cnt) + 1;
+		}
+		csym->flags |= SYMBOL_DEF_USER;
+	}
+}
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 96521cb..4a9af6f 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -42,6 +42,14 @@ extern "C" {
 #define TF_PARAM	0x0002
 #define TF_OPTION	0x0004
 
+enum conf_def_mode {
+	def_default,
+	def_yes,
+	def_mod,
+	def_no,
+	def_random
+};
+
 #define T_OPT_MODULES		1
 #define T_OPT_DEFCONFIG_LIST	2
 #define T_OPT_ENV		3
@@ -69,6 +77,7 @@ const char *conf_get_configname(void);
 char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
+void conf_set_all_new_symbols(enum conf_def_mode mode);
 
 /* kconfig_load.c */
 void kconfig_load(void);
-- 
1.5.6.1.93.gef98

