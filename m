Return-Path: <linux-kernel-owner+w=401wt.eu-S933210AbYF3Vil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210AbYF3Vil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbYF3Veh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:37 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51650 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762910AbYF3Vec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:32 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 02/24] kbuild: always unifdef files in headers_install*
Date: Mon, 30 Jun 2008 23:34:56 +0200
Message-Id: <1214861718-32626-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
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
1.5.6.1.93.gef98

