Return-Path: <linux-kernel-owner+w=401wt.eu-S1751073AbZKGGqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbZKGGqC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 01:46:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZKGGqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 01:46:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:45544 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751141AbZKGGps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 01:45:48 -0500
X-Authenticated: #154622
X-Provags-ID: V01U2FsdGVkX1/HZNdU/1vHLAmzTiVG0Frus9A7llmrP6reDhvwKW
	zUzmsNtenGumCN
From: Bernhard Kaindl <bernhard.kaindl@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Bernhard Kaindl <bernhard.kaindl@gmx.net>, linux-kbuild@vger.kernel.org
Subject: [PATCH 4/4] make config / oldconfig: allow editing of remarks for config symbols
Date: Sat,  7 Nov 2009 07:45:40 +0100
Message-Id: <1b9925ee778bcecbf7e2ae22fc9cef505b4c9e61.1256767265.git.aragorn@Anduril.ringwar.org>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <57715d006f612817fa5bc38146560ecd84605a05.1256767265.git.aragorn@Anduril.ringwar.org>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
 <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
 <617c40ae9e206b4f246998fe075644c752bc0bc3.1256767265.git.aragorn@Anduril.ringwar.org>
 <57715d006f612817fa5bc38146560ecd84605a05.1256767265.git.aragorn@Anduril.ringwar.org>
In-Reply-To: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In conf_sym(), which is used for ask for all bool/tristate symbols,
print sym->remark (if one exists) befor prompting for the option and
analogous to help (triggered by an input beginning with '?'), when the
user enters a line starting with '<', allow the user to enter a remark
or update it.

This extension does not cover the configuration of string, integer or
choice values. I leave this open for follow-up submission in case there
is interest in the config symbol remarks in general and in really
supporting these also fully in make config, oldconfig and (possibly)
silbings.

Signed-off-by: Bernhard Kaindl <bernhard.kaindl@gmx.net>

PS:
make gconfig could also be considered for extension, but it does
apparently does not have a great deal of string editing UI yet,
so adding remarks to it would require finding a way to edit string
symbols in it first.
---
 scripts/kconfig/conf.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 9960d1c..dc60a1d 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -158,8 +158,11 @@ static int conf_sym(struct menu *menu)
 	struct symbol *sym = menu->sym;
 	int type;
 	tristate oldval, newval;
+	char *p;
 
 	while (1) {
+		if (sym->remark)
+			printf("Remark: %s\n", sym->remark);
 		printf("%*s%s ", indent - 1, "", _(menu->prompt->text));
 		if (sym->name)
 			printf("(%s) ", sym->name);
@@ -214,6 +217,8 @@ static int conf_sym(struct menu *menu)
 			break;
 		case '?':
 			goto help;
+		case '<':
+			goto remark;
 		default:
 			continue;
 		}
@@ -221,6 +226,20 @@ static int conf_sym(struct menu *menu)
 			return 0;
 help:
 		print_help(menu);
+		continue;
+remark:
+		if (sym->remark)
+			printf("Current Remark: %s\n", sym->remark);
+		printf("    New remark: ");
+		fgets(line, sizeof(line), stdin);
+
+		if ((p = strchr(line, '\n')))
+			*p = '\0';            /* no \n in remark */
+		if (line[0]) {
+			if (sym->remark)
+				free(sym->remark);
+			sym->remark = strdup(line);
+		}
 	}
 }
 
-- 
1.6.0.4

