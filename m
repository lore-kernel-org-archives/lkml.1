Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbXDASko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbXDASko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933860AbXDASko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:40:44 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49486 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933859AbXDASkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:40:43 -0400
Date: Sun, 1 Apr 2007 20:41:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] kbuild: fix dependency generation
Message-ID: <20070401184126.GA10113@uranus.ravnborg.org>
References: <20070401104551.GA7560@uranus.ravnborg.org> <E1HY2Kf-0002QC-O3@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HY2Kf-0002QC-O3@flower>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > + * the files representing changed config options are touched
> > + * which thern let make pick up the changes and the files that uses
>             ^ then?                                               ^ use?
> > + * the config symbols are rebuild.
>                              ^ rebuilt?
> 


Thanks. Updated patch pushed out to:
ssh://git.kernel.org/pub/scm/linux/kernel/git/kbuild-fix.git

and included below.

	Sam

>From 67e61a8ae9794106643b9caadf84730daeace4d0 Mon Sep 17 00:00:00 2001
From: Jan Beulich <jbeulich@novell.com>
Date: Thu, 29 Mar 2007 10:27:14 +0100
Subject: [PATCH] kbuild: fix dependency generation

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
 scripts/basic/fixdep.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 668a11a..6bc7e7c 100644
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
+ * which then let make pick up the changes and the files that use
+ * the config symbols are rebuilt.
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

