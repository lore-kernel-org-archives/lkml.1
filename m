Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYLTOeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYLTOeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYLTOaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:30 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56422 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYLTOaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:12 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 23/26] kbuild: simplify use of genksyms
Date: Sat, 20 Dec 2008 15:31:34 +0100
Message-Id: <1229783497-19550-23-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid duplicating long list of options in two places

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.build |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d21f0ea..c1da14b 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -151,17 +151,17 @@ cmd_cc_i_c       = $(CPP) $(c_flags)   -o $@ $<
 $(obj)/%.i: $(src)/%.c FORCE
 	$(call if_changed_dep,cc_i_c)
 
+cmd_gensymtypes =                                                           \
+    $(CPP) -D__GENKSYMS__ $(c_flags) $< |                                   \
+    $(GENKSYMS) -T $@ -a $(ARCH)                                            \
+     $(if $(KBUILD_PRESERVE),-p)                                            \
+     $(if $(1),-r $(firstword $(wildcard $(@:.symtypes=.symref) /dev/null)))
+
 quiet_cmd_cc_symtypes_c = SYM $(quiet_modtag) $@
-cmd_cc_symtypes_c	   = \
-		set -e;							\
-		$(CPP) -D__GENKSYMS__ $(c_flags) $<			\
-		| $(GENKSYMS) -T $@					\
-			      -r $(firstword $(wildcard			\
-				     $(@:.symtypes=.symref) /dev/null))	\
-			      $(if $(KBUILD_PRESERVE),-p)		\
-			      -a $(ARCH)				\
-		  >/dev/null;						\
-		test -s $@ || rm -f $@
+cmd_cc_symtypes_c =                                                         \
+    set -e;                                                                 \
+    $(call cmd_gensymtypes, true) >/dev/null;                               \
+    test -s $@ || rm -f $@
 
 $(obj)/%.symtypes : $(src)/%.c FORCE
 	$(call cmd,cc_symtypes_c)
@@ -191,14 +191,8 @@ else
 cmd_cc_o_c = $(CC) $(c_flags) -c -o $(@D)/.tmp_$(@F) $<
 cmd_modversions =							\
 	if $(OBJDUMP) -h $(@D)/.tmp_$(@F) | grep -q __ksymtab; then	\
-		$(CPP) -D__GENKSYMS__ $(c_flags) $<			\
-		| $(GENKSYMS) $(if $(KBUILD_SYMTYPES),			\
-			           -T $(@:.o=.symtypes))		\
-			      -r $(firstword $(wildcard			\
-				     $(@:.o=.symref) /dev/null))	\
-			      $(if $(KBUILD_PRESERVE),-p)		\
-			      -a $(ARCH)				\
-		> $(@D)/.tmp_$(@F:.o=.ver);				\
+		$(call cmd_gensymtypes, $(KBUILD_SYMTYPES))		\
+		    > $(@D)/.tmp_$(@F:.o=.ver);				\
 									\
 		$(LD) $(LDFLAGS) -r -o $@ $(@D)/.tmp_$(@F) 		\
 			-T $(@D)/.tmp_$(@F:.o=.ver);			\
-- 
1.6.0.2.GIT

