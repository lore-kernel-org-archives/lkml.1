Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXC2J0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXC2J0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXC2J0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:26:46 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:41367
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317AbXC2J0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:26:45 -0400
Message-Id: <460BA292.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 29 Mar 2007 10:27:14 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix dependency generation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2e3646e51b2d6415549b310655df63e7e0d7a080 changed the way
the split config tree is built, but failed to also adjust fixdep
accordingly - if changing a config option from or to m, files
referencing the respective CONFIG_..._MODULE (but not the
corresponding CONFIG_...) didn't get rebuilt.

Once at it, also eliminate false dependencies due to use of
...CONFIG_... identifiers.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.21-rc5/scripts/basic/fixdep.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-fixdep-mod/scripts/basic/fixdep.c	2007-03-29 11:11:10.000000000 +0200
@@ -29,8 +29,7 @@
  * option which is mentioned in any of the listed prequisites.
  *
  * To be exact, split-include populates a tree in include/config/,
- * e.g. include/config/his/driver.h, which contains the #define/#undef
- * for the CONFIG_HIS_DRIVER option.
+ * e.g. include/config/his/driver.h, consiting of empty files.
  *
  * So if the user changes his CONFIG_HIS_DRIVER option, only the objects
  * which depend on "include/linux/config/his/driver.h" will be rebuilt,
@@ -223,7 +222,7 @@ void use_config(char *m, int slen)
 void parse_config_file(char *map, size_t len)
 {
 	int *end = (int *) (map + len);
-	/* start at +1, so that p can never be < map */
+	/* start at +1, so that p can never be <= map */
 	int *m   = (int *) map + 1;
 	char *p, *q;
 
@@ -235,6 +234,8 @@ void parse_config_file(char *map, size_t
 		continue;
 	conf:
 		if (p > map + len - 7)
+			break;
+		if (isalnum(p[-1]) || p[-1] == '_')
 			continue;
 		if (memcmp(p, "CONFIG_", 7))
 			continue;
@@ -245,6 +246,8 @@ void parse_config_file(char *map, size_t
 		continue;
 
 	found:
+		if (!memcmp(q - 7, "_MODULE", 7))
+			q -= 7;
 		use_config(p+7, q-p-7);
 	}
 }


