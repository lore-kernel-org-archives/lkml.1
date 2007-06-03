Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbXFCUvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbXFCUvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbXFCUsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:48:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34730 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264AbXFCUsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:48:35 -0400
Date: Sun, 3 Jun 2007 22:49:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 19/19] kbuild: whitelist references from variables named _timer to .init.text
Message-ID: <20070603204936.GT9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 19/19] kbuild: whitelist references from variables named _timer to .init.text
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 3 Jun 2007 22:19:24 +0200

arm uses a lot of ops structures named *_timer that has legitimite
references to .init.text.
So let's add this variable to the list of variables that may reference
.init.text without causing any warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 96078bb..51921aa 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -609,7 +609,7 @@ static int strrcmp(const char *s, const char *sub)
  *   the pattern is identified by:
  *   tosec   = .init.text | .exit.text | .init.data
  *   fromsec = .data
- *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console
+ *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console, *_timer
  *
  * Pattern 3:
  *   Whitelist all refereces from .text.head to .init.data
@@ -634,6 +634,7 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	const char *pat2sym[] = {
 		"driver",
 		"_template", /* scsi uses *_template a lot */
+		"_timer",    /* arm uses ops structures named _timer a lot */
 		"_sht",      /* scsi also used *_sht to some extent */
 		"_ops",
 		"_probe",
@@ -1149,6 +1150,10 @@ static int init_section_ref_ok(const char *name)
 	for (s = namelist2; *s; s++)
 		if (strncmp(*s, name, strlen(*s)) == 0)
 			return 1;
+
+	/* If section name ends with ".init" we allow references
+	 * as is the case with .initcallN.init, .early_param.init, .taglist.init etc
+	 */
 	if (strrcmp(name, ".init") == 0)
 		return 1;
 	return 0;
-- 
1.5.1.rc3.1544.g8a923

----- End forwarded message -----
