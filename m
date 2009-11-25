Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZKYJit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZKYJit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbZKYJis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:38:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:57781 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758487AbZKYJir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:38:47 -0500
Date: Wed, 25 Nov 2009 10:38:51 +0100
From: Michal Marek <mmarek@suse.cz>
To: Bernhard Kaindl <bernhard.kaindl@gmx.net>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] Support loading and saving custom remarks in .config
Message-ID: <20091125093851.GA14314@sepie.suse.cz>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
 <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
 <4B0C57EA.1030400@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0C57EA.1030400@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make it easier for users to maintain their .config over time, add
support for one-line comments (remarks) attached to config option
assignments. The format is

  # some remark
  CONFIG_FOO=y
  # another remark
  # CONFIG_BAR is not set

If a config option is removed, the respective remark is removed as well.
This patch is based on a previous patch by Bernhard Kaindl.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/confdata.c |   52 +++++++++++++++++++++++++++++++++++++++++++-
 scripts/kconfig/expr.h     |    1 +
 2 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index b55e72f..daa7d78 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -152,13 +152,46 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 	return 0;
 }
 
+static char *extract_remark(const char *line)
+{
+	const char *p;
+	char *res, *p2;
+	static const char *alnum =
+		"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
+		"abcdefghijklmnopqrstuvwxyz"
+		"0123456789_";
+
+
+	if (!line || *line != '#')
+		return NULL;
+	line++;
+	line += strspn(line, " \t");
+	if (!*line || *line == '\n')
+		return NULL;
+	if (strncmp(line, "CONFIG_", sizeof("CONFIG_") - 1) != 0)
+		goto found;
+	p = line + strspn(line, alnum);
+	if (strcmp(p, " is not set\n") == 0)
+		return NULL;
+	/* skip commented out assignments */
+	if (p[1] == '=' && !strchr(p, ' ') && !strchr(p, '\t'))
+		return NULL;
+found:
+	res = strdup(line);
+	p2 = strchr(res, '\n');
+	if (p2)
+		*p2 = '\0';
+	return res;
+}
+
 int conf_read_simple(const char *name, int def)
 {
 	FILE *in = NULL;
 	char line[1024];
 	char *p, *p2;
 	struct symbol *sym;
-	int i, def_flags;
+	char *last_remark;
+	int i, def_flags, last_remark_lineno;
 
 	if (name) {
 		in = zconf_fopen(name);
@@ -195,6 +228,8 @@ load:
 	conf_lineno = 0;
 	conf_warnings = 0;
 	conf_unsaved = 0;
+	last_remark = NULL;
+	last_remark_lineno = 0;
 
 	def_flags = SYMBOL_DEF << def;
 	for_all_symbols(i, sym) {
@@ -215,8 +250,15 @@ load:
 	}
 
 	while (fgets(line, sizeof(line), in)) {
+		char *remark;
 		conf_lineno++;
 		sym = NULL;
+		remark = extract_remark(line);
+		if (remark) {
+			free(last_remark);
+			last_remark = remark;
+			last_remark_lineno = conf_lineno;
+		}
 		switch (line[0]) {
 		case '#':
 			if (memcmp(line + 2, "CONFIG_", 7))
@@ -309,6 +351,12 @@ load:
 			}
 			cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
 		}
+		if (sym && last_remark &&
+				last_remark_lineno == conf_lineno - 1) {
+			sym->remark = last_remark;
+			/* don't free() the string in the next iteration */
+			last_remark = NULL;
+		}
 	}
 	fclose(in);
 
@@ -484,6 +532,8 @@ int conf_write(const char *name)
 				if (modules_sym->curr.tri == no)
 					type = S_BOOLEAN;
 			}
+			if (sym->remark)
+				fprintf(out, "# %s\n", sym->remark);
 			switch (type) {
 			case S_BOOLEAN:
 			case S_TRISTATE:
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
1.6.4.2

