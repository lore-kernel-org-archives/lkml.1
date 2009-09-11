Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZIKUCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZIKUCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbZIKUAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:00:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65103 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbZIKUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:00:30 -0400
Message-Id: <20090911200032.864010772@goodmis.org>
References: <20090911195849.451244684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:58:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dick Streefland <dick@streefland.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 02/15] kconfig: make localmodconfig to run streamline_config.pl
Content-Disposition: inline; filename=0002-kconfig-make-localmodconfig-to-run-streamline_config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Running the streamline_config.pl script manually can still be confusing
for some users. This patch adds the localmodconfig option. This will
automatically run streamline_config.pl on the current .config and
then run "make silentoldconfig" to fix any wholes that might have been
created.

 $ make localmodconfig

This will remove any module configurations in .config that are not needed
to compile the modules that are loaded.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/Makefile |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 5ddf8be..e4d8394 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -2,7 +2,8 @@
 # Kernel configuration targets
 # These targets are used from top-level makefile
 
-PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
+PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config \
+	localmodconfig
 
 ifdef KBUILD_KCONFIG
 Kconfig := $(KBUILD_KCONFIG)
@@ -28,6 +29,15 @@ oldconfig: $(obj)/conf
 silentoldconfig: $(obj)/conf
 	$< -s $(Kconfig)
 
+localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
+	$(Q)perl $< $(Kconfig) > .tmp.config
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
@@ -83,6 +93,7 @@ help:
 	@echo  '  xconfig	  - Update current config utilising a QT based front-end'
 	@echo  '  gconfig	  - Update current config utilising a GTK based front-end'
 	@echo  '  oldconfig	  - Update current config utilising a provided .config as base'
+	@echo  '  localmodconfig  - Update current config disabling modules not loaded'
 	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  defconfig	  - New config with default answer to all options'
-- 
1.6.3.3

-- 
