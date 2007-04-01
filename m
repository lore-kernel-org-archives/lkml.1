Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXDAKpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXDAKpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 06:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932424AbXDAKpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 06:45:10 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60747 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418AbXDAKpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 06:45:08 -0400
Date: Sun, 1 Apr 2007 12:45:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: [PATCH] kbuild: fix dependency generation
Message-ID: <20070401104551.GA7560@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

Commit 2e3646e51b2d6415549b310655df63e7e0d7a080 changed the way
the split config tree is built, but failed to also adjust fixdep
accordingly - if changing a config option from or to m, files
referencing the respective CONFIG_..._MODULE (but not the
corresponding CONFIG_...) didn't get rebuilt.

The problem is that trisate symbol are represent with three
different symbols:
SYMBOL=n => no symbol defined
SYMBOL=y => CONFIG_SYMBOL defined to '1'
SYMBOL=m => CONFIG_SYMBOL_MODULE defined to '1'

But conf_split_config do not distingush between the =y and =m case,
so only the =y case is honoured.
This is fixed in fixdep so when a CONFIG symbol with
_MODULE is found we skip that part and only look
for the CONFIG_SYMBOL version.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

The patch can be pulled from:
ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fix.git
[Contains only this fix]

Included below for reference and for -stable.

This should be applied to both latest -rc and stable.

	Sam


 scripts/basic/fixdep.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 668a11a..24144a2 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -28,9 +28,11 @@
  * the dependency on linux/autoconf.h by a dependency on every config
  * option which is mentioned in any of the listed prequisites.
  *
- * To be exact, split-include populates a tree in include/config/,
- * e.g. include/config/his/driver.h, which contains the #define/#undef
- * for the CONFIG_HIS_DRIVER option.
+ * kconfig populates a tree in include/config/ with an empty file
+ * for each config symbol and when the configuration is updated
+ * the files representing changed config options are touched
+ * which thern let make pick up the changes and the files that uses
+ * the config symbols are rebuild.
  *
  * So if the user changes his CONFIG_HIS_DRIVER option, only the objects
  * which depend on "include/linux/config/his/driver.h" will be rebuilt,
@@ -245,6 +247,8 @@ void parse_config_file(char *map, size_t len)
 		continue;
 
 	found:
+		if (!memcmp(q - 7, "_MODULE", 7))
+			q -= 7;
 		use_config(p+7, q-p-7);
 	}
 }
-- 
1.5.1.rc3.20.gaa453

