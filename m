Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbXCaHix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbXCaHix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 03:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXCaHix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 03:38:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39441 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbXCaHiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 03:38:52 -0400
Date: Sat, 31 Mar 2007 09:39:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kconfig: factor out code in conf_spilt_config
Message-ID: <20070331073935.GA11383@uranus.ravnborg.org>
References: <460BA292.76E4.0078.0@novell.com> <20070331064228.GA11023@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331064228.GA11023@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From e9fcc3bf8d1c71df1ae650d5291c5d4b15d71656 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@neptun.ravnborg.org>
Date: Sat, 31 Mar 2007 09:15:12 +0200
Subject: [PATCH] kconfig: factor out code in conf_spilt_config

This patch simply factor out code and
do not introduce any functional changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/confdata.c |   75 ++++++++++++++++++++++++--------------------
 1 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 664fe29..ff6b39b 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -533,13 +533,48 @@ int conf_write(const char *name)
 	return 0;
 }
 
+/* Touch the file specified (adding .h to the name) */
+static int touch_file(const char *file)
+{
+	struct stat sb;
+	int fd;
+	char *d;
+	char name[128];
+
+	strcpy(name, file);
+	strcat(name, ".h");
+
+	/* Open existing file */
+	fd = open(name, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+	if (fd == -1) {
+		if (errno != ENOENT)
+			return 1;
+		/*
+		 * Create directory components,
+		 * unless they exist already.
+		 */
+		d = name;
+		while ((d = strchr(d, '/'))) {
+			*d = 0;
+			if (stat(name, &sb) && mkdir(name, 0755))
+				return 1;
+			*d++ = '/';
+		}
+		/* Directories created, now create file. */
+		fd = open(name, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+		if (fd == -1)
+			return 1;
+	}
+	close(fd);
+	return 0;
+}
+
 int conf_split_config(void)
 {
 	char *name, path[128];
 	char *s, *d, c;
 	struct symbol *sym;
-	struct stat sb;
-	int res, i, fd;
+	int res, i;
 
 	name = getenv("KCONFIG_AUTOCONFIG");
 	if (!name)
@@ -601,45 +636,17 @@ int conf_split_config(void)
 		 *	different from 'no').
 		 */
 
-		/* Replace all '_' and append ".h" */
+		/* Replace all '_' with '/' */
 		s = sym->name;
 		d = path;
 		while ((c = *s++)) {
 			c = tolower(c);
 			*d++ = (c == '_') ? '/' : c;
 		}
-		strcpy(d, ".h");
-
-		/* Assume directory path already exists. */
-		fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
-		if (fd == -1) {
-			if (errno != ENOENT) {
-				res = 1;
-				break;
-			}
-			/*
-			 * Create directory components,
-			 * unless they exist already.
-			 */
-			d = path;
-			while ((d = strchr(d, '/'))) {
-				*d = 0;
-				if (stat(path, &sb) && mkdir(path, 0755)) {
-					res = 1;
-					goto out;
-				}
-				*d++ = '/';
-			}
-			/* Try it again. */
-			fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
-			if (fd == -1) {
-				res = 1;
-				break;
-			}
-		}
-		close(fd);
+		*d = '\0';
+		if (touch_file(path))
+			return 1;
 	}
-out:
 	if (chdir("../.."))
 		return 1;
 
-- 
1.5.1.rc3.gaa453

