Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbZD3DUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbZD3DUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 23:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbZD3DTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 23:19:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35471 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbZD3DTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 23:19:47 -0400
Message-Id: <20090430031946.013598425@goodmis.org>
References: <20090430030821.523327994@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Apr 2009 23:08:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/3] kconfig: make localmodconfig to run streamline_config.pl
Content-Disposition: inline; filename=0002-kconfig-make-localmodconfig-to-run-streamline_confi.patch
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

[ Impact: simplify running streamline_config.pl ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/Makefile |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index fa8c2dd..4b289ad 100644
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
 	@echo  '  silentoldconfig - Same as oldconfig, but quietly'
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  defconfig	  - New config with default answer to all options'
-- 
1.6.2.1

-- 
