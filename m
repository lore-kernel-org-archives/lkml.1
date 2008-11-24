Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYKXUxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYKXUxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYKXUxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:53:31 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36258 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYKXUxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:53:30 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>, kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/8] kbuild: expand -I in KBUILD_CPPFLAGS
Date: Mon, 24 Nov 2008 21:54:48 +0100
Message-Id: <1227560095-32597-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.GIT
In-Reply-To: <20081124205150.GA32497@uranus.ravnborg.org>
References: <20081124205150.GA32497@uranus.ravnborg.org>
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
 Makefile             |    2 +-
 scripts/Makefile.lib |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 7b1f238..54720a5 100644
--- a/Makefile
+++ b/Makefile
@@ -336,7 +336,7 @@ LINUXINCLUDE    := -Iinclude \
                    -I$(srctree)/arch/$(hdr-arch)/include               \
                    -include include/linux/autoconf.h
 
-KBUILD_CPPFLAGS := -D__KERNEL__ $(LINUXINCLUDE)
+KBUILD_CPPFLAGS :=
 
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index b4ca38a..b8a67ec 100644
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
@@ -127,15 +129,18 @@ __a_flags	=                          $(call flags,_a_flags)
 __cpp_flags     =                          $(call flags,_cpp_flags)
 endif
 
-c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
+c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS)                    \
+		 -D__KERNEL__ $(LINUXINCLUDE)                            \
 		 $(__c_flags) $(modkern_cflags) \
 		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) \
 		  $(debug_flags)
 
-a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
+a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS)                    \
+		 -D__KERNEL__ $(LINUXINCLUDE)                            \
 		 $(__a_flags) $(modkern_aflags)
 
-cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(__cpp_flags)
+cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS)                    \
+		 -D__KERNEL__ $(LINUXINCLUDE) $(__cpp_flags)
 
 ld_flags       = $(LDFLAGS) $(ldflags-y)
 
-- 
1.5.6.GIT

