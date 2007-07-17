Return-Path: <linux-kernel-owner+w=401wt.eu-S934001AbXGQORl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbXGQORl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbXGQOIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35926 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbXGQOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:51 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 20/33] kbuild: remove hardcoded _logo names from modpost
Date: Tue, 17 Jul 2007 16:08:49 +0200
Message-Id: <11846813444171-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813443187-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 1921c43..015c6b0 100644
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
1.5.0.6

