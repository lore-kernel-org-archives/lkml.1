Return-Path: <linux-kernel-owner+w=401wt.eu-S934233AbZDATpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233AbZDATpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934157AbZDAToS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:44:18 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:58599 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934152AbZDAToQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:44:16 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kbuild@vger.kernel.org
Subject: [PATCH 5b/5] deb-pkg: allow alternative hook scripts directory in .deb packages
Date: Wed, 1 Apr 2009 21:44:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <200904012133.37387.elendil@planet.nl>
In-Reply-To: <200904012133.37387.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904012144.13077.elendil@planet.nl>
X-OriginalArrivalTime: 01 Apr 2009 19:44:13.0689 (UTC) FILETIME=[3C214690:01C9B302]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook scripts in the default directory /etc/kernel are also executed by
official Debian kernel packages as well as kernel packages created using
make-kpkg. Allow to specify the base hook scripts directory in the kernel
configuration (DEB_HOOKDIRS_PATH).

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/init/Kconfig b/init/Kconfig
index 6a5c5fe..3121b01 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -101,6 +101,18 @@ config LOCALVERSION_AUTO
 
 	  which is done within the script "scripts/setlocalversion".)
 
+config DEB_HOOKDIRS_PATH
+	string "location of hook script directories for Debian packages"
+	default "/etc/kernel"
+	help
+	  Path to {pre,post}{inst,rm}.d/ directories containing hook scripts
+	  that are called during installation/removal of a Debian kernel
+          package built using the 'deb-pkg' target.
+
+	  As official Debian kernel packages also execute scripts under
+	  /etc/kernel, it may be desirable to specify an alternative location
+	  for custom built kernels.
+
 config SWAP
 	bool "Support for paging of anonymous memory (swap)"
 	depends on MMU && BLOCK
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index fa4a0a1..5c72945 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -68,6 +68,8 @@ clean-files += $(objtree)/binkernel.spec
 
 # Deb target
 # ---------------------------------------------------------------------------
+export DEB_HOOKDIRS_PATH = $(CONFIG_DEB_HOOKDIRS_PATH)
+
 deb-pkg: FORCE
 	$(MAKE) KBUILD_SRC=
 	$(CONFIG_SHELL) $(srctree)/scripts/package/builddeb
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 1b8820f..d51a18f 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -6,8 +6,8 @@
 # Simple script to generate a deb package for a Linux kernel. All the
 # complexity of what to do with a kernel after it is installed or removed
 # is left to other scripts and packages: they can install scripts in the
-# /etc/kernel/{pre,post}{inst,rm}.d/ directories that will be called on
-# package install and removal.
+# {pre,post}{inst,rm}.d/ directories under CONFIG_DEB_HOOKDIRS_PATH (by
+# default /etc/kernel) that will be called on package install and removal.
 
 set -e
 
@@ -61,8 +61,11 @@ if grep -q '^CONFIG_MODULES=y' .config ; then
 fi
 
 # Install the maintainer scripts
+# Note: hook scripts under /etc/kernel are also executed by official Debian
+# kernel packages, as well as kernel packages built using make-kpkg
+debhookdir=${DEB_HOOKDIRS_PATH:-/etc/kernel}
 for script in postinst postrm preinst prerm ; do
-	mkdir -p "$tmpdir/etc/kernel/$script.d"
+	mkdir -p "$tmpdir$debhookdir/$script.d"
 	cat <<EOF > "$tmpdir/DEBIAN/$script"
 #!/bin/sh
 
@@ -72,7 +75,7 @@ set -e
 export DEB_MAINT_PARAMS="\$@"
 
 test -d $debhookdir/$script.d && \\
-	run-parts --arg="$version" /etc/kernel/$script.d
+	run-parts --arg="$version" $debhookdir/$script.d
 exit 0
 EOF
 	chmod 755 "$tmpdir/DEBIAN/$script"
