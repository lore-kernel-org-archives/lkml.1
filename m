Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYEFC4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYEFC4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYEFC4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:56:06 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:42503 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752611AbYEFC4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:56:05 -0400
Date: Tue, 6 May 2008 04:55:55 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kconfig: introduce K= support
In-Reply-To: <20080504185918.GB23063@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0805060438220.30555@scrub.home>
References: <20080502204729.GA6534@uranus.ravnborg.org>
 <20080504185737.GA23063@uranus.ravnborg.org> <20080504185918.GB23063@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 4 May 2008, Sam Ravnborg wrote:

Below is patch which adds a library function to set the default values in 
a much simpler way.
The behaviour is slightly different, now it's closer to generating a 
.config with all possible symbols set to some value and using that to 
generate the final config. It has the advantage of not being as dependend 
on the order of the symbols, e.g. with allmodconfig this sets a few more 
symbols to 'm'.

> +# An arch may use KBUILD_DEFCONFIG to specify defconfig file
> +# fallback to arch/$ARCH/defconfig
> +defconfig-file := $(if $(KBUILD_DEFCONFIG),            \
> +        arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG),   \
> +        arch/$(SRCARCH)/defconfig)
> +defconfig-file := $(strip $(defconfig-file))

init/Kconfig has a DEFCONFIG_LIST which is intended to be used for this.

> +	if (ac < 2) {
> +		usage();
> +		exit(1);
> +	}
> +	if (strcmp(av[1], "allnoconfig") == 0)
> +		default_value = set_no;
> +	else if (strcmp(av[1], "allyesconfig") == 0)
> +		default_value = set_yes;
> +	else if (strcmp(av[1], "allmodconfig") == 0)
> +		default_value = set_mod;
> +	else if (strcmp(av[1], "alldefconfig") == 0)
> +		default_value = set_default;
> +	else if (strcmp(av[1], "randconfig") == 0) {
> +		default_value = set_random;
> +		srand(time(NULL));
> +	} else {
> +		usage();
> +		exit(1);
> +	}
> +	if (strcmp(av[2], "-b") == 0) {
> +		config_file = av[3];
> +		kconfig_file = av[4];
> +	} else {
> +		kconfig_file = av[2];
> +	}

Even if it has only a single option, please keep using getopt().

bye, Roman


[PATCH] set all new symbols automatically

Add conf_set_all_new_symbols() which set all symbols (which don't have a 
value yet) to a specifed value.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 scripts/kconfig/confdata.c |   72 ++++++++++++++++++++++++++++++++++++++++++++-
 scripts/kconfig/lkc.h      |    9 +++++
 2 files changed, 80 insertions(+), 1 deletion(-)

Index: linux-2.6/scripts/kconfig/confdata.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/confdata.c
+++ linux-2.6/scripts/kconfig/confdata.c
@@ -510,7 +510,7 @@ int conf_write(const char *name)
 			case S_HEX:
 				str = sym_get_string_value(sym);
 				if (str[0] != '0' || (str[1] != 'x' && str[1] != 'X')) {
-					fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
+					fprintf(out, "CONFIG_%s=0x%s\n", sym->name, str);
 					break;
 				}
 			case S_INT:
@@ -812,3 +812,73 @@ void conf_set_changed_callback(void (*fn
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
Index: linux-2.6/scripts/kconfig/lkc.h
===================================================================
--- linux-2.6.orig/scripts/kconfig/lkc.h
+++ linux-2.6/scripts/kconfig/lkc.h
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
