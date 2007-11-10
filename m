Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbXKJUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbXKJUmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXKJUlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:41:51 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33961 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbXKJUlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:41:49 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kconfig: factor out code in confdata.c
Date: Sat, 10 Nov 2007 21:43:25 +0100
Message-Id: <11947274093185-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <20071110204038.GA13140@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce no functional changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/confdata.c |  119 +++++++++++++++++++++++--------------------
 1 files changed, 64 insertions(+), 55 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index b2913e9..e0f402f 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -83,6 +83,68 @@ char *conf_get_default_confname(void)
 	return name;
 }
 
+static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
+{
+	char *p2;
+
+	switch (sym->type) {
+	case S_TRISTATE:
+		if (p[0] == 'm') {
+			sym->def[def].tri = mod;
+			sym->flags |= def_flags;
+			break;
+		}
+	case S_BOOLEAN:
+		if (p[0] == 'y') {
+			sym->def[def].tri = yes;
+			sym->flags |= def_flags;
+			break;
+		}
+		if (p[0] == 'n') {
+			sym->def[def].tri = no;
+			sym->flags |= def_flags;
+			break;
+		}
+		conf_warning("symbol value '%s' invalid for %s", p, sym->name);
+		break;
+	case S_OTHER:
+		if (*p != '"') {
+			for (p2 = p; *p2 && !isspace(*p2); p2++)
+				;
+			sym->type = S_STRING;
+			goto done;
+		}
+	case S_STRING:
+		if (*p++ != '"')
+			break;
+		for (p2 = p; (p2 = strpbrk(p2, "\"\\")); p2++) {
+			if (*p2 == '"') {
+				*p2 = 0;
+				break;
+			}
+			memmove(p2, p2 + 1, strlen(p2));
+		}
+		if (!p2) {
+			conf_warning("invalid string found");
+			return 1;
+		}
+	case S_INT:
+	case S_HEX:
+	done:
+		if (sym_string_valid(sym, p)) {
+			sym->def[def].val = strdup(p);
+			sym->flags |= def_flags;
+		} else {
+			conf_warning("symbol value '%s' invalid for %s", p, sym->name);
+			return 1;
+		}
+		break;
+	default:
+		;
+	}
+	return 0;
+}
+
 int conf_read_simple(const char *name, int def)
 {
 	FILE *in = NULL;
@@ -213,61 +275,8 @@ load:
 				conf_warning("trying to reassign symbol %s", sym->name);
 				break;
 			}
-			switch (sym->type) {
-			case S_TRISTATE:
-				if (p[0] == 'm') {
-					sym->def[def].tri = mod;
-					sym->flags |= def_flags;
-					break;
-				}
-			case S_BOOLEAN:
-				if (p[0] == 'y') {
-					sym->def[def].tri = yes;
-					sym->flags |= def_flags;
-					break;
-				}
-				if (p[0] == 'n') {
-					sym->def[def].tri = no;
-					sym->flags |= def_flags;
-					break;
-				}
-				conf_warning("symbol value '%s' invalid for %s", p, sym->name);
-				break;
-			case S_OTHER:
-				if (*p != '"') {
-					for (p2 = p; *p2 && !isspace(*p2); p2++)
-						;
-					sym->type = S_STRING;
-					goto done;
-				}
-			case S_STRING:
-				if (*p++ != '"')
-					break;
-				for (p2 = p; (p2 = strpbrk(p2, "\"\\")); p2++) {
-					if (*p2 == '"') {
-						*p2 = 0;
-						break;
-					}
-					memmove(p2, p2 + 1, strlen(p2));
-				}
-				if (!p2) {
-					conf_warning("invalid string found");
-					continue;
-				}
-			case S_INT:
-			case S_HEX:
-			done:
-				if (sym_string_valid(sym, p)) {
-					sym->def[def].val = strdup(p);
-					sym->flags |= def_flags;
-				} else {
-					conf_warning("symbol value '%s' invalid for %s", p, sym->name);
-					continue;
-				}
-				break;
-			default:
-				;
-			}
+			if (conf_set_sym_val(sym, def, def_flags, p))
+				continue;
 			break;
 		case '\r':
 		case '\n':
-- 
1.5.3.4.1157.g0e74-dirty

