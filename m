Return-Path: <linux-kernel-owner+w=401wt.eu-S1764859AbYFHMaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764859AbYFHMaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 08:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761020AbYFHMaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 08:30:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759950AbYFHMaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 08:30:00 -0400
Subject: Re: [PATCH] Speed up "make headers_*"
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1212927265.32207.527.camel@pmac.infradead.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
	 <1212924004.32207.498.camel@pmac.infradead.org>
	 <20080608113028.GE10545@uranus.ravnborg.org>
	 <1212925623.32207.517.camel@pmac.infradead.org>
	 <1212927265.32207.527.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 13:29:56 +0100
Message-Id: <1212928196.32207.530.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-08 at 13:14 +0100, David Woodhouse wrote:
> I have yet to actually remove $(BIARCH) and just override $(dst),
> though.

Done that now, although headers_check_all is still not fixed to cope
with it...

diff --git a/Makefile b/Makefile
index eff8fee..1376c33 100644
--- a/Makefile
+++ b/Makefile
@@ -1012,9 +1012,9 @@ __headers: include/linux/version.h scripts_basic FORCE
 
 PHONY += headers_install_all
 headers_install_all: __headers
+	$(Q)$(MAKE) ARCH= SRCARCH= $(hdr-inst)=include
 	$(Q)set -e; for arch in $(hdr-archs); do \
-	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
-	         BIASMDIR=-bi-$$arch ;\
+	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include/asm-$$arch; \
 	 done
 
 PHONY += headers_install
@@ -1029,7 +1029,7 @@ PHONY += headers_check_all
 headers_check_all: headers_install_all
 	$(Q)set -e; for arch in $(hdr-archs); do \
 	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
-	         BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
+	         HDRCHECK=1 ;\
 	 done
 
 PHONY += headers_check
diff --git a/include/Kbuild b/include/Kbuild
index b522887..9393f7e 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -5,4 +5,6 @@ header-y += mtd/
 header-y += rdma/
 header-y += video/
 
+ifneq ($(ARCH),)
 header-y += asm-$(ARCH)/
+endif
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 80df6f3..e96d18e 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -14,15 +14,6 @@ include $(kbuild-file)
 
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
 install      := $(INSTALL_HDR_PATH)/$(_dst)
 
 header-y     := $(sort $(header-y) $(unifdef-y))
@@ -88,8 +79,12 @@ endif
 # Recursion
 hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
 .PHONY: $(subdirs)
+
+# If the next directory is include/asm-$(ARCH) then override
+# $(_dst) so that we install to include/asm directly.
 $(subdirs):
-	$(Q)$(MAKE) $(hdr-inst)=$(obj)/$@ dst=$(_dst)/$@
+	$(Q)$(MAKE) $(hdr-inst)=$(obj)/$@ \
+		dst=$(patsubst include/asm-$(ARCH),include/asm,$(_dst)/$@)
 
 targets := $(wildcard $(sort $(targets)))
 cmd_files := $(wildcard \

-- 
dwmw2

