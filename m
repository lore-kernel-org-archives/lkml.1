Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbXFCUuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbXFCUuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXFCUsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:48:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53524 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbXFCUsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:48:22 -0400
Date: Sun, 3 Jun 2007 22:49:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 18/19] kbuild: remove hardcoded _logo names from modpost
Message-ID: <20070603204923.GS9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 18/19] kbuild: remove hardcoded _logo names from modpost
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 3 Jun 2007 00:47:53 +0200

Replaced this with a __init_refok marker
in front of fb_find_logo().

I think that the __initdata marker for the logo's are
wrong but I have not justified this so I did not remove it.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 drivers/video/logo/logo.c |    7 +++++--
 scripts/mod/modpost.c     |   14 --------------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/video/logo/logo.c b/drivers/video/logo/logo.c
index 80c0361..2b0f799 100644
--- a/drivers/video/logo/logo.c
+++ b/drivers/video/logo/logo.c
@@ -34,8 +34,11 @@ extern const struct linux_logo logo_superh_vga16;
 extern const struct linux_logo logo_superh_clut224;
 extern const struct linux_logo logo_m32r_clut224;
 
-
-const struct linux_logo *fb_find_logo(int depth)
+/* logo's are marked __initdata. Use __init_refok to tell
+ * modpost that it is intended that this function uses data
+ * marked __initdata.
+ */
+const struct linux_logo * __init_refok fb_find_logo(int depth)
 {
 	const struct linux_logo *logo = NULL;
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f0474a9..96078bb 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -624,14 +624,6 @@ static int strrcmp(const char *s, const char *sub)
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
  *
- * Pattern 5:
- *  Logos used in drivers/video/logo reside in __initdata but the
- *  funtion that references them are EXPORT_SYMBOL() so cannot be
- *  marker __init. So we whitelist them here.
- *  The pattern is:
- *  tosec      = .init.data
- *  fromsec    = .text*
- *  refsymname = logo_
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -698,12 +690,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		if (strcmp(refsymname, *s) == 0)
 			return 1;
 
-	/* Check for pattern 5 */
-	if ((strcmp(tosec, ".init.data") == 0) &&
-	    (strncmp(fromsec, ".text", strlen(".text")) == 0) &&
-	    (strncmp(refsymname, "logo_", strlen("logo_")) == 0))
-		return 1;
-
 	return 0;
 }
 
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
