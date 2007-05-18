Return-Path: <linux-kernel-owner+w=401wt.eu-S1762850AbXERGxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762850AbXERGxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbXERGxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:53:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60904 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbXERGxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:53:30 -0400
Date: Fri, 18 May 2007 08:54:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH 07/14] init/main: use __init_refok to fix section mismatch
Message-ID: <20070518065427.GG12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2f92cdcf9de22b1a18885919b323793f89a6ff94 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 17 May 2007 20:43:54 +0200
Subject: [PATCH 07/14] init/main: use __init_refok to fix section mismatch

Kill a special case in modpost by introducing the
__init_refok marker.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 init/main.c           |    2 +-
 scripts/mod/modpost.c |   14 --------------
 2 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/init/main.c b/init/main.c
index 1940fa7..eb8bdba 100644
--- a/init/main.c
+++ b/init/main.c
@@ -423,7 +423,7 @@ static void __init setup_command_line(char *command_line)
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */
 
-static void noinline rest_init(void)
+static void noinline __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f4d9edf..ec056cf 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -626,14 +626,6 @@ static int strrcmp(const char *s, const char *sub)
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
  *
- * Pattern 6:
- *   During the early init phase we have references from .init.text to
- *   .text we have an intended section mismatch - do not warn about it.
- *   See kernel_init() in init/main.c
- *   tosec   = .init.text
- *   fromsec = .text
- *   atsym = kernel_init
- *
  * Pattern 7:
  *  Logos used in drivers/video/logo reside in __initdata but the
  *  funtion that references them are EXPORT_SYMBOL() so cannot be
@@ -738,12 +730,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		if (strcmp(refsymname, *s) == 0)
 			return 1;
 
-	/* Check for pattern 6 */
-	if ((strcmp(tosec, ".init.text") == 0) &&
-	    (strcmp(fromsec, ".text") == 0) &&
-	    (strcmp(refsymname, "kernel_init") == 0))
-		return 1;
-
 	/* Check for pattern 7 */
 	if ((strcmp(tosec, ".init.data") == 0) &&
 	    (strncmp(fromsec, ".text", strlen(".text")) == 0) &&
-- 
1.5.1.rc3.20.gaa453

