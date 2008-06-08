Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYFHUJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYFHUJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbYFHUHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:07:18 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39605 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbYFHUG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:06:57 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 2/6] kbuild: always unifdef files in headers_install*
Date: Sun,  8 Jun 2008 22:07:34 +0200
Message-Id: <1212955658-32168-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080608094730.GA30098@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unifdef utility is fast enough to warrant that we always
run the scripts through unifdef.

This patch runs all headers listed with header-y and unifdef-y
through unifdef.
Next step is to drop unifdef-y in all Kbuild files and
that can now be done in smaller steps.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>
---
 scripts/Makefile.headersinst |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 53dae3e..22b17af 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -50,25 +50,22 @@ ifeq ($(obj)$(ALTARCH),include/asm-$(ARCH)$(BIASMDIR))
      _dst := include/asm
 endif
 
-header-y	:= $(sort $(header-y))
-unifdef-y	:= $(sort $(unifdef-y))
+header-y	:= $(sort $(header-y) $(unifdef-y))
 subdir-y	:= $(patsubst %/,%,$(filter %/, $(header-y)))
 header-y	:= $(filter-out %/, $(header-y))
-header-y	:= $(filter-out $(unifdef-y),$(header-y))
 
 # stamp files for header checks
-check-y		:= $(patsubst %,.check.%,$(header-y) $(unifdef-y) $(objhdr-y))
+check-y		:= $(patsubst %,.check.%,$(header-y) $(objhdr-y))
 
 # Work out what needs to be removed
 oldheaders	:= $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,%,$(wildcard $(INSTALL_HDR_PATH)/$(_dst)/*.h))
-unwanted	:= $(filter-out $(header-y) $(unifdef-y) $(objhdr-y),$(oldheaders))
+unwanted	:= $(filter-out $(header-y) $(objhdr-y),$(oldheaders))
 
 oldcheckstamps	:= $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,%,$(wildcard $(INSTALL_HDR_PATH)/$(_dst)/.check.*.h))
 unwanted	+= $(filter-out $(check-y),$(oldcheckstamps))
 
 # Prefix them all with full paths to $(INSTALL_HDR_PATH)
 header-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(header-y))
-unifdef-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(unifdef-y))
 objhdr-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(objhdr-y))
 check-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(check-y))
 
@@ -88,10 +85,6 @@ quiet_cmd_o_hdr_install   = INSTALL $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
       cmd_o_hdr_install   = cp $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(objtree)/$(obj)/%,$@) \
 			    $(INSTALL_HDR_PATH)/$(_dst)
 
-quiet_cmd_headers_install = INSTALL $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_headers_install = $(HDRSED) $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(srctree)/$(obj)/%,$@)	\
-			    > $@
-
 quiet_cmd_unifdef	  = UNIFDEF $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
       cmd_unifdef	  = $(UNIFDEF) $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(srctree)/$(obj)/%,$@) \
 				   | $(HDRSED) > $@ || :
@@ -151,10 +144,10 @@ include /dev/null $(wildcard $(check-y))
 
 else
 # Rules for installing headers
-__headersinst: $(subdir-y) $(header-y) $(unifdef-y) $(altarch-y) $(objhdr-y)
+__headersinst: $(subdir-y) $(header-y) $(altarch-y) $(objhdr-y)
 	@true
 
-$(objhdr-y) $(subdir-y) $(header-y) $(unifdef-y): | $(INSTALL_HDR_PATH)/$(_dst) $(unwanted)
+$(objhdr-y) $(subdir-y) $(header-y): | $(INSTALL_HDR_PATH)/$(_dst) $(unwanted)
 
 $(INSTALL_HDR_PATH)/$(_dst):
 	$(call cmd,mkdir)
@@ -164,18 +157,16 @@ $(unwanted):
 	$(call cmd,remove)
 
 ifdef GENASM
-$(objhdr-y) $(header-y) $(unifdef-y): $(KBUILDFILES)
+$(objhdr-y) $(header-y): $(KBUILDFILES)
 	$(call cmd,gen)
 
 else
-$(objhdr-y) :		$(INSTALL_HDR_PATH)/$(_dst)/%.h: $(objtree)/$(obj)/%.h $(KBUILDFILES)
+$(objhdr-y): $(INSTALL_HDR_PATH)/$(_dst)/%.h: $(objtree)/$(obj)/%.h $(KBUILDFILES)
 	$(call cmd,o_hdr_install)
 
-$(header-y) :		$(INSTALL_HDR_PATH)/$(_dst)/%.h: $(srctree)/$(obj)/%.h $(KBUILDFILES)
-	$(call cmd,headers_install)
-
-$(unifdef-y) :		$(INSTALL_HDR_PATH)/$(_dst)/%.h: $(srctree)/$(obj)/%.h $(KBUILDFILES)
+$(header-y): $(INSTALL_HDR_PATH)/$(_dst)/%.h: $(srctree)/$(obj)/%.h $(KBUILDFILES)
 	$(call cmd,unifdef)
+
 endif
 endif
 
@@ -184,7 +175,7 @@ hdrinst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
 .PHONY: altarch-dir
 # All the files in the normal arch dir must be created first, since we test
 # for their existence.
-altarch-dir: $(subdir-y) $(header-y) $(unifdef-y) $(objhdr-y)
+altarch-dir: $(subdir-y) $(header-y) $(objhdr-y)
 	$(Q)$(MAKE) $(hdrinst)=include/asm-$(ALTARCH) dst=include/asm-$(ALTARCH)
 	$(Q)$(MAKE) $(hdrinst)=include/asm dst=include/asm$(BIASMDIR)
 
-- 
1.5.4.1.143.ge7e51

