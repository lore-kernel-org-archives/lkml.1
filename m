Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbZHSDB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbZHSDB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZHSDAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:00:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45448 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZHSDAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:39 -0400
Message-Id: <20090819030040.013591483@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 14/14] kconfig: test if a .config already exists
Content-Disposition: inline; filename=0014-kconfig-test-if-a-.config-already-exists.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If one were to run localmodconfig or localyesconfig without having
a .config already in the file, then the end of the process would give
a warning when it tries to move the old .config to .config.old.

This patch adds a test to check if .config exists and avoid the moves
if it does not.

[ Impact: remove warning after make localmodconfig ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/Makefile |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 12a4d9e..915a39a 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -31,21 +31,31 @@ silentoldconfig: $(obj)/conf
 
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)perl $< $(Kconfig) > .tmp.config
-	$(Q)cmp -s .tmp.config .config ||		\
-		(mv -f .config .config.old.1;		\
-		 mv -f .tmp.config .config;		\
-		 $(obj)/conf -s $(Kconfig);		\
-		 mv -f .config.old.1 .config.old)
+	$(Q)if [ -f .config ]; then 				\
+			cmp -s .tmp.config .config ||		\
+			(mv -f .config .config.old.1;		\
+			 mv -f .tmp.config .config;		\
+			 $(obj)/conf -s $(Kconfig);		\
+			 mv -f .config.old.1 .config.old)	\
+	else							\
+			mv -f .tmp.config .config;		\
+			$(obj)/conf -s $(Kconfig);		\
+	fi
 	$(Q)rm -f .tmp.config
 
 localyesconfig: $(obj)/streamline_config.pl
 	$(Q)perl $< $(Kconfig) > .tmp.config
 	$(Q)sed -i s/=m/=y/ .tmp.config
-	$(Q)cmp -s .tmp.config .config ||		\
-		(mv -f .config .config.old.1;		\
-		 mv -f .tmp.config .config;		\
-		 $(obj)/conf -s $(Kconfig);		\
-		 mv -f .config.old.1 .config.old)
+	$(Q)if [ -f .config ]; then 				\
+			cmp -s .tmp.config .config ||		\
+			(mv -f .config .config.old.1;		\
+			 mv -f .tmp.config .config;		\
+			 $(obj)/conf -s $(Kconfig);		\
+			 mv -f .config.old.1 .config.old)	\
+	else							\
+			mv -f .tmp.config .config;		\
+			$(obj)/conf -s $(Kconfig);		\
+	fi
 	$(Q)rm -f .tmp.config
 
 # Create new linux.pot file
-- 
1.6.3.3

-- 
