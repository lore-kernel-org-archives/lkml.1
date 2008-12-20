Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYLTObx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYLTObx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYLTOaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41285 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYLTOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:07 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 02/26] kbuild: expand -I in KBUILD_CPPFLAGS
Date: Sat, 20 Dec 2008 15:31:13 +0100
Message-Id: <1229783497-19550-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild failed to expand include flags in KBUILD_CPPFLAGS
resulting in code like this in arch Makefiles:

ifeq ($(KBUILD_SRC),)
KBUILD_CPPFLAGS += -Iinclude/foo
else
KBUILD_CPPFLAGS += -I$(srctree)/include/foo
endif

Move use of LINUXINCLUDE into Makefile.lib to allow
us to expand -I directives of KBUILD_CPPFLAGS so
we can avoid the above code.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile             |    4 ++--
 scripts/Makefile.lib |   15 +++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 9a49960..3075586 100644
--- a/Makefile
+++ b/Makefile
@@ -336,7 +336,7 @@ LINUXINCLUDE    := -Iinclude \
                    -I$(srctree)/arch/$(hdr-arch)/include               \
                    -include include/linux/autoconf.h
 
-KBUILD_CPPFLAGS := -D__KERNEL__ $(LINUXINCLUDE)
+KBUILD_CPPFLAGS := -D__KERNEL__
 
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
@@ -1638,7 +1638,7 @@ cmd_crmodverdir = $(Q)mkdir -p $(MODVERDIR) \
                   $(if $(KBUILD_MODULES),; rm -f $(MODVERDIR)/*)
 
 a_flags = -Wp,-MD,$(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
-	  $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
+	  $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(KBUILD_CPPFLAGS) \
 	  $(modkern_aflags) $(EXTRA_AFLAGS) $(AFLAGS_$(basetarget).o)
 
 quiet_cmd_as_o_S = AS      $@
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index b4ca38a..e063657 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -104,9 +104,11 @@ else
 debug_flags =
 endif
 
-orig_c_flags   = $(KBUILD_CFLAGS) $(ccflags-y) $(CFLAGS_$(basetarget).o)
+orig_c_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS)                     \
+                 $(ccflags-y) $(CFLAGS_$(basetarget).o)
 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(orig_c_flags))
-_a_flags       = $(KBUILD_AFLAGS) $(asflags-y) $(AFLAGS_$(basetarget).o)
+_a_flags       = $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS)                     \
+                 $(asflags-y) $(AFLAGS_$(basetarget).o)
 _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
 
 # If building the kernel in a separate objtree expand all occurrences
@@ -127,15 +129,16 @@ __a_flags	=                          $(call flags,_a_flags)
 __cpp_flags     =                          $(call flags,_cpp_flags)
 endif
 
-c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
-		 $(__c_flags) $(modkern_cflags) \
+c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
+		 $(__c_flags) $(modkern_cflags)                           \
 		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) \
 		  $(debug_flags)
 
-a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
+a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 $(__a_flags) $(modkern_aflags)
 
-cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(__cpp_flags)
+cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
+		 $(__cpp_flags)
 
 ld_flags       = $(LDFLAGS) $(ldflags-y)
 
-- 
1.6.0.2.GIT

