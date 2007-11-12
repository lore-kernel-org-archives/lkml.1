Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbXKLVAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbXKLVAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXKLU7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:59:04 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39809 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbXKLU65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:58:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] kconfig: add helper to set config symbol from environment variable
Date: Mon, 12 Nov 2007 22:00:33 +0100
Message-Id: <1194901236-22820-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1194901236-22820-9-git-send-email-sam@ravnborg.org>
References: <20071112205451.GA22528@uranus.ravnborg.org>
 <1194901236-22820-1-git-send-email-sam@ravnborg.org>
 <1194901236-22820-2-git-send-email-sam@ravnborg.org>
 <1194901236-22820-3-git-send-email-sam@ravnborg.org>
 <1194901236-22820-4-git-send-email-sam@ravnborg.org>
 <1194901236-22820-5-git-send-email-sam@ravnborg.org>
 <1194901236-22820-6-git-send-email-sam@ravnborg.org>
 <1194901236-22820-7-git-send-email-sam@ravnborg.org>
 <1194901236-22820-8-git-send-email-sam@ravnborg.org>
 <1194901236-22820-9-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add conf_set_env_sym() that can set an already defined symbol
based on the value of an environment variable.

Unknown symbols are silently ignored.
A warning is printed if the value of the environment variable
is unexpected.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/confdata.c  |   27 +++++++++++++++++++++++++++
 scripts/kconfig/lkc_proto.h |    1 +
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index e0f402f..e4fa3f3 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -145,6 +145,33 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 	return 0;
 }
 
+/* Read an environment variable and assign the value to the symbol */
+int conf_set_env_sym(const char *env, const char *symname, int def)
+{
+	struct symbol *sym;
+	char *p;
+	int def_flags;
+
+	p = getenv(env);
+	if (p) {
+		char warning[200];
+		sprintf(warning, "Environment variable (%s = \"%s\")", env, p);
+		conf_filename = warning;
+		def_flags = SYMBOL_DEF << def;
+		if (def == S_DEF_USER) {
+			sym = sym_find(symname);
+			if (!sym)
+				return 1;
+		} else {
+			sym = sym_lookup(symname, 0);
+			if (sym->type == S_UNKNOWN)
+				sym->type = S_OTHER;
+		}
+		conf_set_sym_val(sym, def, def_flags, p);
+	}
+	return 0;
+}
+
 int conf_read_simple(const char *name, int def)
 {
 	FILE *in = NULL;
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 4d09f6d..dca294e 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -1,6 +1,7 @@
 
 /* confdata.c */
 P(conf_parse,void,(const char *name));
+P(conf_set_env_sym,int,(const char *envname, const char *symname, int def));
 P(conf_read,int,(const char *name));
 P(conf_read_simple,int,(const char *name, int));
 P(conf_write,int,(const char *name));
-- 
1.5.3.4.1157.g0e74-dirty

