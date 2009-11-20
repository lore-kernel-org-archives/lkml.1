Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZKTPvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZKTPvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZKTPv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:51:29 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:51179 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbZKTPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:51:03 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: linux-kernel@vger.kernel.org, lrodriguez@atheros.com
Cc: sam@ravnborg.org, greg@kroah.com, akpm@linux-foundation.org,
       mcgrof@gmail.com, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 4/4] kconfig: streamline_config.pl: let users specify the list of desired modules
Date: Fri, 20 Nov 2009 15:50:54 +0000
Message-Id: <1258732254-15573-5-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258732254-15573-4-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1258732254-15573-1-git-send-email-alan-jenkins@tuffmail.co.uk>
 <1258732254-15573-2-git-send-email-alan-jenkins@tuffmail.co.uk>
 <1258732254-15573-3-git-send-email-alan-jenkins@tuffmail.co.uk>
 <1258732254-15573-4-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows "make localmodconfig MODULES_LIST=lsmod.out",
where "lsmod.out" may have been created on a different system.

You can also use this with a manually editted file which
simply lists the desired modules.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 README                               |    8 ++++++++
 scripts/kconfig/Makefile             |    3 ++-
 scripts/kconfig/streamline_config.pl |   17 ++++++++++++++---
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/README b/README
index 737838f..9481dd5 100644
--- a/README
+++ b/README
@@ -175,6 +175,14 @@ CONFIGURING the kernel:
 			   Like above, but avoids cluttering the screen
 			   with questions already answered.
 			   Additionally updates the dependencies.
+
+	"make localmodconfig"
+			   Minimize your existing ./.config file, based
+			   on the kernel modules currently loaded on your
+			   system.  You can also specify the list of
+			   modules manually by appending an option
+			   "MODULES_LIST=lsmod.out".
+
 	"make defconfig"   Create a ./.config file by using the default
 			   symbol values from either arch/$ARCH/defconfig
 			   or arch/$ARCH/configs/${PLATFORM}_defconfig,
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 6d69c7c..6a1e41d 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -30,7 +30,7 @@ silentoldconfig: $(obj)/conf
 	$< -s $(Kconfig)
 
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
-	$(Q)perl $< $(Kconfig) > .tmp.config
+	$(Q)perl $< $(Kconfig) $(MODULES_LIST) > .tmp.config
 	$(Q)if [ -f .config ]; then 				\
 			cmp -s .tmp.config .config ||		\
 			(mv -f .config .config.old.1;		\
@@ -114,6 +114,7 @@ help:
 	@echo  '  gconfig	  - Update current config utilising a GTK based front-end'
 	@echo  '  oldconfig	  - Update current config utilising a provided .config as base'
 	@echo  '  localmodconfig  - Update current config disabling modules not loaded'
+	@echo  '                    (or modules not listed in the file MODULES_LIST)'
 	@echo  '  localyesconfig  - Update current config converting local mods to core'
 	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
 	@echo  '  randconfig	  - New config with random answer to all options'
diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index f5b44c1..9fde7fd 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -40,7 +40,7 @@ use warnings;
 #
 #    cd /usr/src/linux-2.6.10
 #    cp /boot/config-2.6.10-1-686-smp .config
-#    ~/bin/streamline_config > config_strip
+#    ~/bin/streamline_config arch/x86/Kconfig > config_strip
 #    mv .config config_sav
 #    mv config_strip .config
 #    make oldconfig
@@ -122,9 +122,15 @@ my %objects;
 my $var;
 my $cont = 0;
 
+if ($#ARGV < 0 || $#ARGV > 1) {
+    die "usage: streamline_config.pl <Kconfig> [<modules.list>]"
+}
+
 # Get the top level Kconfig file (passed in)
 my $kconfig = $ARGV[0];
 
+my $modules_list = $ARGV[1];
+
 # prevent recursion
 my %read_kconfigs;
 
@@ -251,8 +257,13 @@ foreach my $makefile (@makefiles) {
 
 my %modules;
 
-# see what modules are loaded on this system
-open(LIN,"/sbin/lsmod|") || die "Cant lsmod";
+# see what modules are loaded
+if ($modules_list) {
+    open(LIN,$modules_list) || die "Can't open $modules_list";
+} else {
+    open(LIN,"/sbin/lsmod|") || die "Can't lsmod";
+}
+
 while (<LIN>) {
 	next if (/^Module/);  # Skip the first line.
 	if (/^(\S+)/) {
-- 
1.6.3.3

