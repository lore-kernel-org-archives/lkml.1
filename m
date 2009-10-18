Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZJRINw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZJRINw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZJRINv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:13:51 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50924 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZJRILT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:19 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 09/14] kbuild: do not check for include/asm-$ARCH
Date: Sun, 18 Oct 2009 10:15:18 +0200
Message-Id: <1255853723-477-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No architectures uses include/asm-$ARCH now.
So drop check for location of include files

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile           |   11 +++--------
 scripts/headers.sh |    2 --
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index 63dc381..5e71b69 100644
--- a/Makefile
+++ b/Makefile
@@ -1069,11 +1069,6 @@ firmware_install: FORCE
 export INSTALL_HDR_PATH = $(objtree)/usr
 
 hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
-# Find out where the Kbuild file is located to support
-# arch/$(ARCH)/include/asm
-hdr-dir = $(strip                                                         \
-          $(if $(wildcard $(srctree)/arch/$(hdr-arch)/include/asm/Kbuild), \
-               arch/$(hdr-arch)/include/asm, include/asm-$(hdr-arch)))
 
 # If we do an all arch process set dst to asm-$(hdr-arch)
 hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
@@ -1088,10 +1083,10 @@ headers_install_all:
 
 PHONY += headers_install
 headers_install: __headers
-	$(if $(wildcard $(srctree)/$(hdr-dir)/Kbuild),, \
+	$(if $(wildcard $(srctree)/arch/$(hdr-arch)/include/asm/Kbuild),, \
 	$(error Headers not exportable for the $(SRCARCH) architecture))
 	$(Q)$(MAKE) $(hdr-inst)=include
-	$(Q)$(MAKE) $(hdr-inst)=$(hdr-dir) $(hdr-dst)
+	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/asm $(hdr-dst)
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
@@ -1100,7 +1095,7 @@ headers_check_all: headers_install_all
 PHONY += headers_check
 headers_check: headers_install
 	$(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1
-	$(Q)$(MAKE) $(hdr-inst)=$(hdr-dir) $(hdr-dst) HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/asm $(hdr-dst) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
 # Modules
diff --git a/scripts/headers.sh b/scripts/headers.sh
index 0308ecc..1ddcdd3 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -8,8 +8,6 @@ do_command()
 {
 	if [ -f ${srctree}/arch/$2/include/asm/Kbuild ]; then
 		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
-	elif [ -f ${srctree}/include/asm-$2/Kbuild ]; then
-		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
 	else
 		printf "Ignoring arch: %s\n" ${arch}
 	fi
-- 
1.6.2.5

