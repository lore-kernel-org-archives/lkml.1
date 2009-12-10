Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbZLJBQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbZLJBQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZLJBQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:16:15 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:43524 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZLJBQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:16:14 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] modpost: fix asprintf warnings
Date: Wed,  9 Dec 2009 20:16:19 -0500
Message-Id: <1260407779-12517-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.5
In-Reply-To: <20091209155903.GB3247@hack>
References: <20091209155903.GB3247@hack>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On compilers with security warnings enabled by default, we get:

scripts/mod/modpost.c: In function 'get_markers':
scripts/mod/modpost.c:1562: warning: ignoring return value of 'asprintf',
                                     declared with attribute warn_unused_result
scripts/mod/modpost.c: In function 'add_marker':
scripts/mod/modpost.c:1982: warning: ignoring return value of 'asprintf',
                                     declared with attribute warn_unused_result

So check the return value and abort on errors.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- add missing newline pointed out by Américo Wang

 scripts/mod/modpost.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 801a16a..6608ebd 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1559,7 +1559,8 @@ static void get_markers(struct elf_info *info, struct module *mod)
 			const char *name = strings + sym->st_value;
 			const char *fmt = strchr(name, '\0') + 1;
 			char *line = NULL;
-			asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
+			if (asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt) == -1)
+				fatal("asprintf() with %s failed\n", name);
 			NOFAIL(line);
 			mod->markers[n++] = line;
 		}
@@ -1979,7 +1980,8 @@ static void write_dump(const char *fname)
 static void add_marker(struct module *mod, const char *name, const char *fmt)
 {
 	char *line = NULL;
-	asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
+	if (asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt) == -1)
+		fatal("asprintf() with %s failed\n", name);
 	NOFAIL(line);
 
 	mod->markers = NOFAIL(realloc(mod->markers, ((mod->nmarkers + 1) *
-- 
1.6.5.5

