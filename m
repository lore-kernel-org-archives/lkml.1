Return-Path: <linux-kernel-owner+w=401wt.eu-S933066AbYF3VhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066AbYF3VhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932852AbYF3Vel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48227 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762993AbYF3Vec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:32 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 06/24] kbuild: only one call for include/ in make headers_*
Date: Mon, 30 Jun 2008 23:35:00 +0200
Message-Id: <1214861718-32626-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it to the top-level file to decide if we install/check
the generic headers or the arch specific headers.

This revealed a long standing bug where "make headers_check_all"
relied on the files in asm/ for the current architecture.
So make headers_check_all is now broken by this commit.

In addition:

o add a simpler way to detect if an arch support
  exporting header files.

o add 'set -e;' so we error out early if
  make headers_check_all fails.

o add sparc64 and cris to arch we do not process
  in make headers_*_all because:

    sparc64 - use sparc to export headers
    cris    - is know seriously broken

Includes suggestions from: David Woodhouse
<dwmw2@infradead.org>.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 Makefile                     |   24 +++++++++++++-----------
 include/Kbuild               |    4 ++--
 scripts/Makefile.headersinst |    9 ---------
 3 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/Makefile b/Makefile
index d676c39..2f087df 100644
--- a/Makefile
+++ b/Makefile
@@ -1000,7 +1000,7 @@ depend dep:
 #Default location for installed headers
 export INSTALL_HDR_PATH = $(objtree)/usr
 
-hdr-filter := generic um ppc
+hdr-filter := generic um ppc sparc64 cris
 hdr-archs  := $(filter-out $(hdr-filter),                           \
                   $(patsubst $(srctree)/include/asm-%/Kbuild,%,     \
                       $(wildcard $(srctree)/include/asm-*/Kbuild)))
@@ -1012,29 +1012,31 @@ __headers: include/linux/version.h scripts_basic FORCE
 
 PHONY += headers_install_all
 headers_install_all: __headers
+	$(Q)$(MAKE) $(hdr-inst)=include
 	$(Q)set -e; for arch in $(hdr-archs); do \
-	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
-	         BIASMDIR=-bi-$$arch ;\
+	 $(MAKE) $(hdr-inst)=include/asm-$$arch   \
+	         SRCARCH=$$arch dst=include/asm-$$arch;  \
 	 done
 
 PHONY += headers_install
 headers_install: __headers
-	$(Q)if [ ! -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
-	  echo '*** Error: Headers not exportable for this architecture ($(SRCARCH))'; \
-	  exit 1 ; \
-	fi
-	$(Q)$(MAKE) $(hdr-inst)=include ARCH=$(SRCARCH)
+	$(if $(wildcard $(srctree)/include/asm-$(SRCARCH)/Kbuild),, \
+	$(error Headers not exportable for this architecture ($(SRCARCH))))
+	$(Q)$(MAKE) $(hdr-inst)=include
+	$(Q)$(MAKE) $(hdr-inst)=include/asm-$(SRCARCH) dst=include/asm
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
+	$(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1
 	$(Q)set -e; for arch in $(hdr-archs); do \
-	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
-	         BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
+	 $(MAKE) SRCARCH=$$arch $(hdr-inst)=include/asm-$$arch HDRCHECK=1 ;\
 	 done
 
 PHONY += headers_check
 headers_check: headers_install
-	$(Q)$(MAKE) $(hdr-inst)=include ARCH=$(SRCARCH) HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=include/asm-$(SRCARCH) \
+	            dst=include/asm HDRCHECK=1
 
 # ---------------------------------------------------------------------------
 # Modules
diff --git a/include/Kbuild b/include/Kbuild
index b522887..6ae595c 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -1,8 +1,8 @@
+# Top-level Makefile calls into asm-$(ARCH)
+
 header-y += asm-generic/
 header-y += linux/
 header-y += sound/
 header-y += mtd/
 header-y += rdma/
 header-y += video/
-
-header-y += asm-$(ARCH)/
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 599adc6..599503f 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -28,15 +28,6 @@ include $(kbuild-file)
 
 include scripts/Kbuild.include
 
-# If this is include/asm-$(ARCH) then override $(_dst) so that
-# we install to include/asm directly.
-# Unless $(BIASMDIR) is set, in which case we're probably doing
-# a 'headers_install_all' build and we should keep the -$(ARCH)
-# in the directory name.
-ifeq ($(obj),include/asm-$(ARCH)$(BIASMDIR))
-     _dst := include/asm
-endif
-
 install := $(INSTALL_HDR_PATH)/$(_dst)
 
 header-y	:= $(sort $(header-y) $(unifdef-y))
-- 
1.5.6.1.93.gef98

