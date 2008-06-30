Return-Path: <linux-kernel-owner+w=401wt.eu-S932902AbYF3Veq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbYF3Veq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763073AbYF3Ved
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:33 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51648 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760284AbYF3Vec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:32 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 01/24] kbuild: refactor headers_* targets in Makefile
Date: Mon, 30 Jun 2008 23:34:55 +0200
Message-Id: <1214861718-32626-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Use lower case for local variables
o Add a helper target for common targets
o Use $(hdr-inst)= ... to make Make invocations simpler
o Add -rR to make invocations

In total this adds more lines than it removes but the
benefit is better readability

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 Makefile |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index 6aff5f4..c65fe4f 100644
--- a/Makefile
+++ b/Makefile
@@ -996,36 +996,43 @@ depend dep:
 
 # ---------------------------------------------------------------------------
 # Kernel headers
-INSTALL_HDR_PATH=$(objtree)/usr
-export INSTALL_HDR_PATH
 
-HDRFILTER=generic i386 x86_64
-HDRARCHES=$(filter-out $(HDRFILTER),$(patsubst $(srctree)/include/asm-%/Kbuild,%,$(wildcard $(srctree)/include/asm-*/Kbuild)))
+#Default location for installed headers
+export INSTALL_HDR_PATH = $(objtree)/usr
 
-PHONY += headers_install_all
-headers_install_all: include/linux/version.h scripts_basic FORCE
+hdr-filter := generic um ppc
+hdr-archs  := $(filter-out $(hdr-filter),                           \
+                  $(patsubst $(srctree)/include/asm-%/Kbuild,%,     \
+                      $(wildcard $(srctree)/include/asm-*/Kbuild)))
+hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
+
+PHONY += __headers
+__headers: include/linux/version.h scripts_basic FORCE
 	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
-	$(Q)for arch in $(HDRARCHES); do \
-	 $(MAKE) ARCH=$$arch -f $(srctree)/scripts/Makefile.headersinst obj=include BIASMDIR=-bi-$$arch ;\
+
+PHONY += headers_install_all
+headers_install_all: __headers
+	$(Q)for arch in $(hdr-archs); do \
+	 $(MAKE) ARCH=$$arch $(hdr-inst)=include BIASMDIR=-bi-$$arch ;\
 	 done
 
 PHONY += headers_install
-headers_install: include/linux/version.h scripts_basic FORCE
-	@if [ ! -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
+headers_install: __headers
+	$(Q)if [ ! -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
 	  echo '*** Error: Headers not exportable for this architecture ($(SRCARCH))'; \
-	  exit 1 ; fi
-	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst ARCH=$(SRCARCH) obj=include
+	  exit 1 ; \
+	fi
+	$(Q)$(MAKE) $(hdr-inst)=include ARCH=$(SRCARCH)
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
-	$(Q)for arch in $(HDRARCHES); do \
-	 $(MAKE) ARCH=$$arch -f $(srctree)/scripts/Makefile.headersinst obj=include BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
+	$(Q)for arch in $(hdr-archs); do \
+	 $(MAKE) ARCH=$$arch $(hdr-inst)=include BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
 	 done
 
 PHONY += headers_check
 headers_check: headers_install
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst ARCH=$(SRCARCH) obj=include HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=include ARCH=$(SRCARCH) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
 # Modules
-- 
1.5.6.1.93.gef98

