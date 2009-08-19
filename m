Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZHSDBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZHSDBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZHSDBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:01:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56654 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZHSDAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:45 -0400
Message-Id: <20090819030036.506868128@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:37 -0400
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
Subject: [PATCH 03/14] kconfig: add make localyesconfig option
Content-Disposition: inline; filename=0003-kconfig-add-make-localyesconfig-option.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This adds the option localyesconfig to make. This is similar to
localmodconfig, but after it removes unnecessary modules it runs

  sed -i s/=m/=y/

on the .config file. It then runs "make silentoldconfig" to fix any
wholes that were created by the conversion of modules to core.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/Makefile |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index e4d8394..12a4d9e 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -3,7 +3,7 @@
 # These targets are used from top-level makefile
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config \
-	localmodconfig
+	localmodconfig localyesconfig
 
 ifdef KBUILD_KCONFIG
 Kconfig := $(KBUILD_KCONFIG)
@@ -38,6 +38,16 @@ localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 		 mv -f .config.old.1 .config.old)
 	$(Q)rm -f .tmp.config
 
+localyesconfig: $(obj)/streamline_config.pl
+	$(Q)perl $< $(Kconfig) > .tmp.config
+	$(Q)sed -i s/=m/=y/ .tmp.config
+	$(Q)cmp -s .tmp.config .config ||		\
+		(mv -f .config .config.old.1;		\
+		 mv -f .tmp.config .config;		\
+		 $(obj)/conf -s $(Kconfig);		\
+		 mv -f .config.old.1 .config.old)
+	$(Q)rm -f .tmp.config
+
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
@@ -94,6 +104,7 @@ help:
 	@echo  '  gconfig	  - Update current config utilising a GTK based front-end'
 	@echo  '  oldconfig	  - Update current config utilising a provided .config as base'
 	@echo  '  localmodconfig  - Update current config disabling modules not loaded'
+	@echo  '  localyesconfig  - Update current config converting local mods to core'
 	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  defconfig	  - New config with default answer to all options'
-- 
1.6.3.3

-- 
