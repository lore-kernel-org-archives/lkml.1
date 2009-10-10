Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZJJLwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZJJLwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 07:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZJJLwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 07:52:15 -0400
Received: from flounder.pepperfish.net ([87.237.62.181]:59942 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbZJJLwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 07:52:14 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2009 07:52:14 EDT
From: Vincent Sanders <vince@simtec.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Vincent Sanders <vince@simtec.co.uk>
Subject: [PATCH] Alter the way dependancy file generation is passed to the toolchain.
Date: Sat, 10 Oct 2009 12:51:37 +0100
Message-Id: <1255175497-3386-1-git-send-email-vince@simtec.co.uk>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel currently generates its dependency files using a direct -Wp
switch to bypass the compiler driver and access the preprocessor. This
is unnecessary on any GCC the kernel can be built with. This approach is 
also discouraged in the GCC documentation. A nice side effect of this 
change is that it allows clang/llvm to build the kernel.

Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
---
 Makefile                       |    2 +-
 arch/powerpc/boot/Makefile     |    4 ++--
 arch/um/scripts/Makefile.rules |    4 ++--
 drivers/net/wan/Makefile       |    2 +-
 scripts/Makefile.host          |    4 ++--
 scripts/Makefile.lib           |    6 +++---
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index e50569a..f3d552c 100644
--- a/Makefile
+++ b/Makefile
@@ -1605,7 +1605,7 @@ quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
 cmd_crmodverdir = $(Q)mkdir -p $(MODVERDIR) \
                   $(if $(KBUILD_MODULES),; rm -f $(MODVERDIR)/*)
 
-a_flags = -Wp,-MD,$(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
+a_flags = -MD -MF $(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
 	  $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(KBUILD_CPPFLAGS) \
 	  $(modkern_aflags) $(EXTRA_AFLAGS) $(AFLAGS_$(basetarget).o)
 
diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 7bfc8ad..4e9b06f 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -119,10 +119,10 @@ clean-files := $(zlib) $(zlibheader) $(zliblinuxheader) \
 		empty.c zImage.coff.lds zImage.ps3.lds zImage.lds
 
 quiet_cmd_bootcc = BOOTCC  $@
-      cmd_bootcc = $(CROSS32CC) -Wp,-MD,$(depfile) $(BOOTCFLAGS) -c -o $@ $<
+      cmd_bootcc = $(CROSS32CC) -MD -MF $(depfile) $(BOOTCFLAGS) -c -o $@ $<
 
 quiet_cmd_bootas = BOOTAS  $@
-      cmd_bootas = $(CROSS32CC) -Wp,-MD,$(depfile) $(BOOTAFLAGS) -c -o $@ $<
+      cmd_bootas = $(CROSS32CC) -MD -MF $(depfile) $(BOOTAFLAGS) -c -o $@ $<
 
 quiet_cmd_bootar = BOOTAR  $@
       cmd_bootar = $(CROSS32AR) -cr $@.$$$$ $(filter-out FORCE,$^); mv $@.$$$$ $@
diff --git a/arch/um/scripts/Makefile.rules b/arch/um/scripts/Makefile.rules
index 61107b6..71c0bc3 100644
--- a/arch/um/scripts/Makefile.rules
+++ b/arch/um/scripts/Makefile.rules
@@ -8,7 +8,7 @@ USER_OBJS += $(filter %_user.o,$(obj-y) $(obj-m)  $(USER_SINGLE_OBJS))
 USER_OBJS := $(foreach file,$(USER_OBJS),$(obj)/$(file))
 
 $(USER_OBJS:.o=.%): \
-	c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) $(CFLAGS_$(basetarget).o)
+	c_flags = -MD -MF $(depfile) $(USER_CFLAGS) $(CFLAGS_$(basetarget).o)
 $(USER_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
 	-Dunix -D__unix__ -D__$(SUBARCH)__ $(CF)
 
@@ -17,7 +17,7 @@ $(USER_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
 UNPROFILE_OBJS := $(foreach file,$(UNPROFILE_OBJS),$(obj)/$(file))
 
 $(UNPROFILE_OBJS:.o=.%): \
-	c_flags = -Wp,-MD,$(depfile) $(call unprofile,$(USER_CFLAGS)) $(CFLAGS_$(basetarget).o)
+	c_flags = -MD -MF $(depfile) $(call unprofile,$(USER_CFLAGS)) $(CFLAGS_$(basetarget).o)
 $(UNPROFILE_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
 	-Dunix -D__unix__ -D__$(SUBARCH)__ $(CF)
 
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index 19d14bc..3211b72 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -57,7 +57,7 @@ endif
 
 quiet_cmd_build_wanxlfw = BLD FW  $@
       cmd_build_wanxlfw = \
-	$(CPP) -Wp,-MD,$(depfile) -I$(srctree)/include $< | $(AS68K) -m68360 -o $(obj)/wanxlfw.o; \
+	$(CPP) -MD -MF $(depfile) -I$(srctree)/include $< | $(AS68K) -m68360 -o $(obj)/wanxlfw.o; \
 	$(LD68K) --oformat binary -Ttext 0x1000 $(obj)/wanxlfw.o -o $(obj)/wanxlfw.bin; \
 	hexdump -ve '"\n" 16/1 "0x%02X,"' $(obj)/wanxlfw.bin | sed 's/0x  ,//g;1s/^/static u8 firmware[]={/;$$s/,$$/\n};\n/' >$(obj)/wanxlfw.inc; \
 	rm -f $(obj)/wanxlfw.bin $(obj)/wanxlfw.o
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 1ac414f..d673e19 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -103,8 +103,8 @@ __hostc_flags	= -I$(obj) $(call flags,_hostc_flags)
 __hostcxx_flags	= -I$(obj) $(call flags,_hostcxx_flags)
 endif
 
-hostc_flags    = -Wp,-MD,$(depfile) $(__hostc_flags)
-hostcxx_flags  = -Wp,-MD,$(depfile) $(__hostcxx_flags)
+hostc_flags    = -MD -MF $(depfile) $(__hostc_flags)
+hostcxx_flags  = -MD -MF $(depfile) $(__hostcxx_flags)
 
 #####
 # Compile programs on the host
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 7a77787..5488a9f 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -145,15 +145,15 @@ __a_flags	=                          $(call flags,_a_flags)
 __cpp_flags     =                          $(call flags,_cpp_flags)
 endif
 
-c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
+c_flags        = -MD -MF $(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 $(__c_flags) $(modkern_cflags)                           \
 		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) \
 		  $(debug_flags)
 
-a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
+a_flags        = -MD -MF $(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 $(__a_flags) $(modkern_aflags)
 
-cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
+cpp_flags      = -MD -MF $(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 $(__cpp_flags)
 
 ld_flags       = $(LDFLAGS) $(ldflags-y)
-- 
1.6.0.4

