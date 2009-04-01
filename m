Return-Path: <linux-kernel-owner+w=401wt.eu-S934116AbZDATns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbZDATns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934001AbZDATnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:43:22 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:54949 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934041AbZDATnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:43:21 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kbuild@vger.kernel.org
Subject: [PATCH 3/5] deb-pkg: pass Debian maintainer script parameters to packaging hook scripts
Date: Wed, 1 Apr 2009 21:43:17 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <200904012133.37387.elendil@planet.nl>
In-Reply-To: <200904012133.37387.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904012143.18562.elendil@planet.nl>
X-OriginalArrivalTime: 01 Apr 2009 19:43:18.0814 (UTC) FILETIME=[1B6C03E0:01C9B302]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Debian packaging scripts created by the deb-pkg target do not pass
on the standard Debian maintainer script parameters to hook scripts,
which means that those scripts cannot tell whether they are being called
during e.g. install vs. upgrade, or removal vs. purge of the package.

As there are several variantions in how hook scripts are called from
kernel packages, we pass the parameters in the environment variable
DEB_MAINT_PARAMS rather than as extra arguments.

Bump version of builddep script to 1.3.

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 5b1517d..c9a4dcd 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -1,6 +1,6 @@
 #!/bin/sh
 #
-# builddeb 1.2
+# builddeb 1.3
 # Copyright 2003 Wichert Akkerman <wichert@wiggy.net>
 #
 # Simple script to generate a deb package for a Linux kernel. All the
@@ -63,7 +63,11 @@ for script in postinst postrm preinst prerm ; do
 
 set -e
 
-test -d /etc/kernel/$script.d && run-parts --arg="$version" /etc/kernel/$script.d
+# Pass maintainer script parameters to hook scripts
+export DEB_MAINT_PARAMS="\$@"
+
+test -d $debhookdir/$script.d && \\
+	run-parts --arg="$version" /etc/kernel/$script.d
 exit 0
 EOF
 	chmod 755 "$tmpdir/DEBIAN/$script"
