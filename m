Return-Path: <linux-kernel-owner+w=401wt.eu-S1751241AbZKGGp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbZKGGp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 01:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZKGGps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 01:45:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:45113 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751081AbZKGGpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 01:45:46 -0500
X-Authenticated: #154622
X-Provags-ID: V01U2FsdGVkX1/LTxIcleLLK9YhgjPvA26sjFHX5IIVsuOAHOkEMd
	ryCuj7FC+KrrhA
From: Bernhard Kaindl <bernhard.kaindl@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Bernhard Kaindl <bernhard.kaindl@gmx.net>, linux-kbuild@vger.kernel.org
Subject: [PATCH 1/4] Support loading and saving custom remarks for config symbols
Date: Sat,  7 Nov 2009 07:45:37 +0100
Message-Id: <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
In-Reply-To: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the infrastructure to load and save remarks for config symbols
to the kconfig library functions conf_read() and conf_write()

This
 - adds sym->remark
 - extends conf_read() to call conf_read_remarks()
 - adds conf_read_remarks() which:
   -> reads remarks from a file and
   -> stores them in sym->remark
 - extends conf_write() to save each sym->remark so that
   conf_read_remarks() will be able to reread them

To not keep any additional file when no remarks exist, and to stay completely
out of the way when this feature is not used, conf_write() does not keep
empty remarks files, so anyone not using this code will see no changes.

The filename of the remarks file is derived from the used config file
name and path by appending "-remarks" to the config file name. So the
default remarks file would be ".config-remarks".

This code supports one-line remarks without newlines. The changes to
the tools (menuconfig, xconfig, config) also only support one-line
remarks as they use the existing UI functions for editing strings.

Signed-off-by: Bernhard Kaindl <bernhard.kaindl@gmx.net>
---
 scripts/kconfig/confdata.c |   45 +++++++++++++++++++++++++++++++++++++++++--
 scripts/kconfig/expr.h     |    1 +
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 797a741..eee2b60 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -152,6 +152,30 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 	return 0;
 }
 
+/**
+ * Read remarks from -remarks file:
+ */
+void conf_read_remarks(const char *remfile)
+{
+	FILE *in;
+	char line[1024], *p, *p2;
+	struct symbol *sym;
+
+	sprintf(line, "%s-remarks", remfile ? remfile : conf_get_configname());
+	if (!(in = zconf_fopen(line)))
+		return;
+	while (fgets(line, sizeof(line), in)) {
+		if (!(p = strchr(line, ' '))) /* ' ' is our delimiter        */
+			continue;	      /* skip lines without one      */
+		*p++ = '\0';		      /* put a \0 there, advance     */
+		if ((p2 = strchr(p, '\n')))   /* look for \n after remark    */
+			*p2 = '\0';	      /* remove it, no \n in remarks */
+		if ((sym = sym_find(line)))   /* find the matching sym       */
+			sym->remark = strdup(p); /* and register the remark  */
+	}
+	fclose(in);
+}
+
 int conf_read_simple(const char *name, int def)
 {
 	FILE *in = NULL;
@@ -393,16 +417,18 @@ int conf_read(const char *name)
 
 	sym_add_change_count(conf_warnings || conf_unsaved);
 
+	conf_read_remarks(name);
 	return 0;
 }
 
 int conf_write(const char *name)
 {
-	FILE *out;
+	FILE *out, *rem;
+	struct stat sb;
 	struct symbol *sym;
 	struct menu *menu;
 	const char *basename;
-	char dirname[128], tmpname[128], newname[128];
+	char dirname[128], tmpname[128], newname[128], tmprem[128], newrem[128];
 	int type, l;
 	const char *str;
 	time_t now;
@@ -432,15 +458,19 @@ int conf_write(const char *name)
 		basename = conf_get_configname();
 
 	sprintf(newname, "%s%s", dirname, basename);
+	sprintf(newrem, "%s%s-remarks", dirname, basename);
 	env = getenv("KCONFIG_OVERWRITECONFIG");
 	if (!env || !*env) {
 		sprintf(tmpname, "%s.tmpconfig.%d", dirname, (int)getpid());
 		out = fopen(tmpname, "w");
+		sprintf(tmprem, "%s.tmpconfig-remarks.%d", dirname, (int)getpid());
+		rem = fopen(tmprem, "w");
 	} else {
 		*tmpname = 0;
 		out = fopen(newname, "w");
+		rem = fopen(newrem, "w");
 	}
-	if (!out)
+	if (!out || !rem)
 		return 1;
 
 	sym = sym_lookup("KERNELVERSION", 0);
@@ -528,6 +558,8 @@ int conf_write(const char *name)
 		}
 
 	next:
+		if (sym && sym->remark)
+			fprintf(rem, "%s %s\n", sym->name, sym->remark);
 		if (menu->list) {
 			menu = menu->list;
 			continue;
@@ -542,6 +574,7 @@ int conf_write(const char *name)
 		}
 	}
 	fclose(out);
+	fclose(rem);
 
 	if (*tmpname) {
 		strcat(dirname, basename);
@@ -549,7 +582,13 @@ int conf_write(const char *name)
 		rename(newname, dirname);
 		if (rename(tmpname, newname))
 			return 1;
+		sprintf(dirname, "%s.old", newrem);
+		rename(newrem, dirname);
+		if (rename(tmprem, newrem)) 
+			conf_warning("moving %s to %s failed!", tmprem, newrem);
 	}
+	if (!stat(newrem, &sb) && !sb.st_size)
+		unlink(newrem);
 
 	printf(_("#\n"
 		 "# configuration written to %s\n"
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 6408fef..217e8cb 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -77,6 +77,7 @@ enum {
 struct symbol {
 	struct symbol *next;
 	char *name;
+	char *remark;
 	enum symbol_type type;
 	struct symbol_value curr;
 	struct symbol_value def[S_DEF_COUNT];
-- 
1.6.0.4

