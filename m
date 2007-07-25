Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbXGYVOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbXGYVOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXGYVOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:14:40 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57978 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbXGYVOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:14:39 -0400
Date: Wed, 25 Jul 2007 23:15:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: i386 section mismatch warnings
Message-ID: <20070725211550.GB29705@uranus.ravnborg.org>
References: <46A5536E.6010606@garzik.org> <20070724014512.GO21668@ftp.linux.org.uk> <46A5AEE0.1070202@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A5AEE0.1070202@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 09:48:48AM +0200, Gabriel C wrote:
> Al Viro wrote:
> > On Mon, Jul 23, 2007 at 09:18:38PM -0400, Jeff Garzik wrote:
> >> make allmodconfig on i386:
> >>
> >> WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to 
> > 
> > Ignore.  vmlinux.o ones are interesting; so are ones in modules.
> > vmlinux ones are either duplicates of vmlinux.o or false positives.
> 
> allyesconfig has a lot Section mismatch warnings , are these false positive too ?
> 
> 
> http://lkml.org/lkml/2007/7/22/312

Fixed in latest kbuild.git. See the following two patches.

	Sam

>From 2f5ee619045d923de9137b6a263a99cc2428391a Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 25 Jul 2007 21:46:40 +0200
Subject: [PATCH 6/8] kbuild: rearrange a few function in modpost

This is a preparational patch that just move
two functions and add one (for now unused) function.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   80 +++++++++++++++++++++++++++++-------------------
 1 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 87e3ee5..c903a16 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -586,6 +586,54 @@ static int strrcmp(const char *s, const char *sub)
         return memcmp(s + slen - sublen, sub, sublen);
 }
 
+/*
+ * Functions used only during module init is marked __init and is stored in
+ * a .init.text section. Likewise data is marked __initdata and stored in
+ * a .init.data section.
+ * If this section is one of these sections return 1
+ * See include/linux/init.h for the details
+ */
+static int init_section(const char *name)
+{
+	if (strcmp(name, ".init") == 0)
+		return 1;
+	if (strncmp(name, ".init.", strlen(".init.")) == 0)
+		return 1;
+	return 0;
+}
+
+/*
+ * Functions used only during module exit is marked __exit and is stored in
+ * a .exit.text section. Likewise data is marked __exitdata and stored in
+ * a .exit.data section.
+ * If this section is one of these sections return 1
+ * See include/linux/init.h for the details
+ **/
+static int exit_section(const char *name)
+{
+	if (strcmp(name, ".exit.text") == 0)
+		return 1;
+	if (strcmp(name, ".exit.data") == 0)
+		return 1;
+	return 0;
+
+}
+
+/*
+ * Data sections are named like this:
+ * .data | .data.rel | .data.rel.*
+ * Return 1 if the specified section is a data section
+ */
+static int data_section(const char *name)
+{
+	if ((strcmp(name, ".data") == 0) ||
+	    (strcmp(name, ".data.rel") == 0) ||
+	    (strncmp(name, ".data.rel.", strlen(".data.rel.")) == 0))
+		return 1;
+	else
+		return 0;
+}
+
 /**
  * Whitelist to allow certain references to pass with no warning.
  *
@@ -1108,21 +1156,6 @@ static int initexit_section_ref_ok(const char *name)
 	return 0;
 }
 
-/**
- * Functions used only during module init is marked __init and is stored in
- * a .init.text section. Likewise data is marked __initdata and stored in
- * a .init.data section.
- * If this section is one of these sections return 1
- * See include/linux/init.h for the details
- **/
-static int init_section(const char *name)
-{
-	if (strcmp(name, ".init") == 0)
-		return 1;
-	if (strncmp(name, ".init.", strlen(".init.")) == 0)
-		return 1;
-	return 0;
-}
 
 /*
  * Identify sections from which references to a .init section is OK.
@@ -1180,23 +1213,6 @@ static int init_section_ref_ok(const char *name)
 }
 
 /*
- * Functions used only during module exit is marked __exit and is stored in
- * a .exit.text section. Likewise data is marked __exitdata and stored in
- * a .exit.data section.
- * If this section is one of these sections return 1
- * See include/linux/init.h for the details
- **/
-static int exit_section(const char *name)
-{
-	if (strcmp(name, ".exit.text") == 0)
-		return 1;
-	if (strcmp(name, ".exit.data") == 0)
-		return 1;
-	return 0;
-
-}
-
-/*
  * Identify sections from which references to a .exit section is OK.
  */
 static int exit_section_ref_ok(const char *name)
-- 
1.5.1.rc3.g84b7-dirty

>From 83cda2bb37cb8476cd84659d9698ab48553be974 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 25 Jul 2007 21:52:31 +0200
Subject: [PATCH 7/8] kbuild: be more foregiving on init section naming

In the whitelist function of modpost now use the same
check to identify init_section as in other places of modpost.
This has the effect that we now recognize sections named
.init.text.19 as init sections and we no longer warn
when we see these.

At the same time make surrounding code readable by dropping
use of temporary flags.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   36 ++++++++++--------------------------
 1 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c903a16..3db4edc 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -658,8 +658,8 @@ static int data_section(const char *name)
  *   These functions may often be marked __init and we do not want to
  *   warn here.
  *   the pattern is identified by:
- *   tosec   = .init.text | .exit.text | .init.data
- *   fromsec = .data | .data.rel | .data.rel.*
+ *   tosec   = init or exit section
+ *   fromsec = data section
  *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console, *_timer
  *
  * Pattern 3:
@@ -680,7 +680,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
 			    const char *refsymname)
 {
-	int f1 = 1, f2 = 1;
 	const char **s;
 	const char *pat2sym[] = {
 		"driver",
@@ -707,31 +706,16 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		return 1;
 
 	/* Check for pattern 1 */
-	if (strcmp(tosec, ".init.data") != 0)
-		f1 = 0;
-	if (strncmp(fromsec, ".data", strlen(".data")) != 0)
-		f1 = 0;
-	if (strncmp(atsym, "__param", strlen("__param")) != 0)
-		f1 = 0;
-
-	if (f1)
-		return f1;
+	if ((strcmp(tosec, ".init.data") == 0) &&
+	    (strncmp(fromsec, ".data", strlen(".data")) == 0) &&
+	    (strncmp(atsym, "__param", strlen("__param")) == 0))
+		return 1;
 
 	/* Check for pattern 2 */
-	if ((strcmp(tosec, ".init.text") != 0) &&
-	    (strcmp(tosec, ".exit.text") != 0) &&
-	    (strcmp(tosec, ".init.data") != 0))
-		f2 = 0;
-	if ((strcmp(fromsec, ".data") != 0) &&
-	    (strcmp(fromsec, ".data.rel") != 0) &&
-	    (strncmp(fromsec, ".data.rel.", strlen(".data.rel.")) != 0))
-		f2 = 0;
-
-	for (s = pat2sym; *s; s++)
-		if (strrcmp(atsym, *s) == 0)
-			f1 = 1;
-	if (f1 && f2)
-		return 1;
+	if ((init_section(tosec) || exit_section(tosec)) && data_section(fromsec))
+		for (s = pat2sym; *s; s++)
+			if (strrcmp(atsym, *s) == 0)
+				return 1;
 
 	/* Check for pattern 3 */
 	if ((strcmp(fromsec, ".text.head") == 0) &&
-- 
1.5.1.rc3.g84b7-dirty

