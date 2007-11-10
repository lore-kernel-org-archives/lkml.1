Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbXKJUnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbXKJUnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbXKJUlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:41:53 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40904 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbXKJUlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:41:50 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Date: Sat, 10 Nov 2007 21:43:26 +0100
Message-Id: <11947274091127-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11947274093185-git-send-email-sam@ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The variable K64BIT can now be used to select the
value of CONFIG_64BIT.

This is for example useful for powerpc to generate
allmodconfig for both bit sizes - like this:
make ARCH=powerpc K64BIT=y
make ARCH=powerpc K64BIT=n

To use this the Kconfig file must use "64BIT" as the
config value to select between 32 and 64 bit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/conf.c      |    1 +
 scripts/kconfig/confdata.c  |   27 +++++++++++++++++++++++++++
 scripts/kconfig/lkc_proto.h |    1 +
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index a38787a..c6bee85 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -591,6 +591,7 @@ int main(int ac, char **av)
 			conf_read_simple(name, S_DEF_USER);
 		else if (!stat("all.config", &tmpstat))
 			conf_read_simple("all.config", S_DEF_USER);
+		conf_set_env_sym("K64BIT", "64BIT", S_DEF_USER);
 		break;
 	default:
 		break;
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index e0f402f..0cb7555 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -145,6 +145,33 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 	return 0;
 }
 
+/* Read an environment variable and assign the vaule to the symbol */
+int conf_set_env_sym(const char *env, const char *symname, int def)
+{
+	struct symbol *sym;
+	char *p;
+	int def_flags;
+
+	p = getenv(env);
+	if (p) {
+		char warning[100];
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

