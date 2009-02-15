Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZBOSWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZBOSWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZBOSUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:20:43 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:48305 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbZBOSUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:20:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fjUM3kJE2jj//FDNll/Z6FT76Ka9c9CZLnaC07ZSS1OeV0YIdiel0b7MrnTmv1aBTe
         mlXecrx4sbT6+zhrhFUz5uLOfnQykBfaSa8Hx2gaZTr+uv8dgRcaHbo1SAxL5PQ2MMTj
         XevIMC5jf9mMDzlCx//J0tR5iY5G2dv2+BYSM=
From: Andreas Robinson <andr345@gmail.com>
To: sam@ravnborg.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/6] scripts: new module preprocessor for static linking
Date: Sun, 15 Feb 2009 19:20:27 +0100
Message-Id: <1234722028-8110-6-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1234722028-8110-1-git-send-email-andr345@gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script strips unneeded sections, resolves duplicate
symbols and concatenates multiple modules into a single
object file suitable for linking with vmlinux.

Problem: Debug symbols must be stripped or else objcopy
won't remove any sections.
---
 scripts/ld_extmodules.sh |  149 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 149 insertions(+), 0 deletions(-)
 create mode 100755 scripts/ld_extmodules.sh

diff --git a/scripts/ld_extmodules.sh b/scripts/ld_extmodules.sh
new file mode 100755
index 0000000..6049bfd
--- /dev/null
+++ b/scripts/ld_extmodules.sh
@@ -0,0 +1,149 @@
+#!/bin/sh
+# Copyright (C) 2009 Andreas Robinson <andr345@gmail.com>
+#
+# Released under the terms of the GNU GPL v2 or later.
+
+# Usage ###############################
+
+if [ "$#" -ne "2" ]
+then
+
+cat << EOF
+
+Prepare and link a set of modules for static linking with the kernel.
+
+Usage: `basename $0` <modules.lst> <output.o>
+
+<modules.lst> List of modules to link, in insertion order.
+              This is a plain text file with one pathname per line.
+<output.o>    Output object file.
+              You can use modinfo or "readelf -p .modinfo" to read
+              the table of contents.
+
+If the target architecture differs from your host, you must set the
+CROSS_COMPILE environment variable. It is used as a prefix for the
+binutil commands.
+
+EOF
+
+exit 1
+fi
+
+#CROSS_COMPILE=
+LD=${CROSS_COMPILE}ld
+NM=${CROSS_COMPILE}nm
+STRIP=${CROSS_COMPILE}strip
+OBJCOPY=${CROSS_COMPILE}objcopy
+OBJDUMP=${CROSS_COMPILE}objdump
+READELF=${CROSS_COMPILE}readelf
+
+# Helper functions ####################
+
+# Simple "modinfo -F". No need to depend on module-init-tools.
+# $1 = module
+# $2 = field name.
+my_modinfo()
+{
+	${READELF} $1 -p .modinfo | grep -o "$2=.*" | sed s/"$2="//g
+}
+
+# Returns true if module $1 has a GPL compatible license.
+# If a module has more than one license tag, (some do),
+# this function will only look at the first one.
+is_gpl_compatible()
+{
+	license=`my_modinfo $1 license | head -n 1`
+	[ "$license" = "GPL" ] ||
+		[ "$license" = "GPL v2" ] ||
+		[ "$license" = "GPL and additional rights" ] ||
+		[ "$license" = "Dual BSD/GPL" ] ||
+		[ "$license" = "Dual MIT/GPL" ] ||
+		[ "$license" = "Dual MPL/GPL" ]
+}
+
+# Returns true if ELF-file $1 has a section named $2 .
+have_section()
+{
+	[ "`${OBJDUMP} -h $1 | grep -o $2`" != "" ]
+}
+
+# Main ################################
+
+rm -f .tmp_mod* $2
+
+cat $1 | while read module;
+do
+	# Cull unhandled files
+
+	if [ ! -f "$module" ]
+	then
+		echo Skipped: $module - file not found.
+		continue
+	fi
+
+	if ! have_section $module .gnu.linkonce.this_module
+	then
+		echo Skipped: $module - not a kernel module.
+		continue
+	fi
+
+	if ! is_gpl_compatible $module
+	then
+		echo Skipped: $module - not GPL compatible.
+		continue
+	fi
+
+	if ! have_section $module .mod_initcall.init
+	then
+		echo "Warning: `basename $module` has no " \
+			".mod_initcall.init section."
+		echo "         The kernel will not call this " \
+			"module's init function."
+	fi
+
+	# Add to table of contents. (module pathname and srcversion.)
+	printf "module=$module `my_modinfo $module srcversion`\0" \
+		>> .tmp_mod_toc.txt
+
+	# Prepare module for linking with the kernel
+
+	${NM} $module 2> /dev/null | \
+		grep -o "__mod_.*_device_table" > .tmp_mod_devtbl
+
+	${LD} -r --defsym __this_module=0 $module -o .tmp_mod1.o
+
+	${OBJCOPY} --strip-debug                                \
+		--remove-section .gnu.linkonce.this_module      \
+		--remove-section .modinfo                       \
+		--localize-symbol init_module                   \
+		--localize-symbol cleanup_module                \
+		--localize-symbol __this_module                 \
+		.tmp_mod1.o
+
+	if [ ! -f .tmp_mod1.o ]
+	then
+		echo Skipped: $module - objcopy failed.
+		continue
+	fi
+
+	if [ -s .tmp_mod_devtbl ]
+	then
+		${OBJCOPY} --strip-symbols .tmp_mod_devtbl .tmp_mod1.o
+	fi
+
+	# Merge modules into one file.
+
+	if [ ! -f $2 ]; then
+		mv .tmp_mod1.o $2
+	else
+		${LD} -r $2 .tmp_mod1.o -o .tmp_mod2.o
+		mv .tmp_mod2.o $2
+	fi
+
+	echo Merged: $module
+done
+
+# Insert table of contents
+
+${OBJCOPY} --add-section .modinfo=.tmp_mod_toc.txt $2
+
-- 
1.5.6.3

