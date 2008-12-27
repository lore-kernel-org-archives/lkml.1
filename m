Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbYL0U5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbYL0U5e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYL0U5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:57:09 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:48736 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbYL0U5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:57:08 -0500
Date: Sat, 27 Dec 2008 21:58:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 2/2] kconfig: improve error messages for bad source statements
Message-ID: <20081227205840.GC16609@uranus.ravnborg.org>
References: <20081227090339.GA6279@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227090339.GA6279@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 31606ff6946f5fc841b9d990c6c5479f54f16835 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 27 Dec 2008 21:51:59 +0100
Subject: [PATCH 2/2] kconfig: improve error messages for bad source statements

We now say where we detect the second source of a file,
and where we detect a recursively source of the same file.
This makes it easier to fix such errors.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/lex.zconf.c_shipped |    7 +++++--
 scripts/kconfig/zconf.l             |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/lex.zconf.c_shipped b/scripts/kconfig/lex.zconf.c_shipped
index 7342ce0..dc3e818 100644
--- a/scripts/kconfig/lex.zconf.c_shipped
+++ b/scripts/kconfig/lex.zconf.c_shipped
@@ -2370,11 +2370,14 @@ void zconf_nextfile(const char *name)
 	current_buf = buf;
 
 	if (file->flags & FILE_BUSY) {
-		printf("recursive scan (%s)?\n", name);
+		printf("%s:%d: do not source '%s' from itself\n",
+		       zconf_curname(), zconf_lineno(), name);
 		exit(1);
 	}
 	if (file->flags & FILE_SCANNED) {
-		printf("file %s already scanned?\n", name);
+		printf("%s:%d: file '%s' is already sourced from '%s'\n",
+		       zconf_curname(), zconf_lineno(), name,
+		       file->parent->name);
 		exit(1);
 	}
 	file->flags |= FILE_BUSY;
diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
index 5164ef7..21ff69c 100644
--- a/scripts/kconfig/zconf.l
+++ b/scripts/kconfig/zconf.l
@@ -314,11 +314,14 @@ void zconf_nextfile(const char *name)
 	current_buf = buf;
 
 	if (file->flags & FILE_BUSY) {
-		printf("recursive scan (%s)?\n", name);
+		printf("%s:%d: do not source '%s' from itself\n",
+		       zconf_curname(), zconf_lineno(), name);
 		exit(1);
 	}
 	if (file->flags & FILE_SCANNED) {
-		printf("file %s already scanned?\n", name);
+		printf("%s:%d: file '%s' is already sourced from '%s'\n",
+		       zconf_curname(), zconf_lineno(), name,
+		       file->parent->name);
 		exit(1);
 	}
 	file->flags |= FILE_BUSY;
-- 
1.6.0.2.GIT

