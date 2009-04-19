Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbZDSNoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbZDSNoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbZDSNlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:41:32 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53353 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927AbZDSNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:41:22 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH 10/10] kconfig: do not hardcode "include/config/auto.conf" filename
Date: Sun, 19 Apr 2009 15:41:27 +0200
Message-Id: <1240148487-27584-11-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.rc1.24.g467d50
In-Reply-To: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
References: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX19sNJK8WGy+kcP9AqJzV6/ySRPsu1HZ8aZhXoi+
	c63HhcPxWlqfU7NkJtT4YxXAk+8Bf4CI/e0kByETH872qgfw8x
	h7wWUe2FRVlMEmo6P57w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of KCONFIG_AUTOCONFIG, the filename written as a Make target
into "include/config/auto.conf.cmd" was always the default one.

Of course this doesn't make it work for the Kernel kbuild system, since
there the filename is hardcoded at several places in the Makefiles.

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
---
 scripts/kconfig/confdata.c |   20 ++++++++++++--------
 scripts/kconfig/lkc.h      |    1 +
 scripts/kconfig/util.c     |    6 +++---
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 273d738..a04da34 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -41,6 +41,13 @@ const char *conf_get_configname(void)
 	return name ? name : ".config";
 }
 
+const char *conf_get_autoconfig_name(void)
+{
+	char *name = getenv("KCONFIG_AUTOCONFIG");
+
+	return name ? name : "include/config/auto.conf";
+}
+
 static char *conf_expand_value(const char *in)
 {
 	struct symbol *sym;
@@ -555,15 +562,14 @@ int conf_write(const char *name)
 
 int conf_split_config(void)
 {
-	char *name, path[128];
+	const char *name;
+	char path[128];
 	char *s, *d, c;
 	struct symbol *sym;
 	struct stat sb;
 	int res, i, fd;
 
-	name = getenv("KCONFIG_AUTOCONFIG");
-	if (!name)
-		name = "include/config/auto.conf";
+	name = conf_get_autoconfig_name();
 	conf_read_simple(name, S_DEF_AUTO);
 
 	if (chdir("include/config"))
@@ -670,7 +676,7 @@ int conf_write_autoconf(void)
 {
 	struct symbol *sym;
 	const char *str;
-	char *name;
+	const char *name;
 	FILE *out, *out_h;
 	time_t now;
 	int i, l;
@@ -773,9 +779,7 @@ int conf_write_autoconf(void)
 		name = "include/linux/autoconf.h";
 	if (rename(".tmpconfig.h", name))
 		return 1;
-	name = getenv("KCONFIG_AUTOCONFIG");
-	if (!name)
-		name = "include/config/auto.conf";
+	name = conf_get_autoconfig_name();
 	/*
 	 * This must be the last step, kbuild has a dependency on auto.conf
 	 * and this marks the successful completion of the previous steps.
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 4a9af6f..f379b0b 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -74,6 +74,7 @@ char *zconf_curname(void);
 
 /* confdata.c */
 const char *conf_get_configname(void);
+const char *conf_get_autoconfig_name(void);
 char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index 3cc9f93..b6b2a46 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -46,8 +46,8 @@ int file_write_dep(const char *name)
 		else
 			fprintf(out, "\t%s\n", file->name);
 	}
-	fprintf(out, "\ninclude/config/auto.conf: \\\n"
-		     "\t$(deps_config)\n\n");
+	fprintf(out, "\n%s: \\\n"
+		     "\t$(deps_config)\n\n", conf_get_autoconfig_name());
 
 	expr_list_for_each_sym(sym_env_list, e, sym) {
 		struct property *prop;
@@ -61,7 +61,7 @@ int file_write_dep(const char *name)
 		if (!value)
 			value = "";
 		fprintf(out, "ifneq \"$(%s)\" \"%s\"\n", env_sym->name, value);
-		fprintf(out, "include/config/auto.conf: FORCE\n");
+		fprintf(out, "%s: FORCE\n", conf_get_autoconfig_name());
 		fprintf(out, "endif\n");
 	}
 
-- 
1.6.3.rc1.24.g467d50

