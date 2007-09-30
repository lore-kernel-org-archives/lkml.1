Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbXI3TJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbXI3TJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 15:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXI3TJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 15:09:27 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57933 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbXI3TJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 15:09:26 -0400
Date: Sun, 30 Sep 2007 21:10:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: kbuild: introduce ccflags-y, asflags-y and ldflags-y
Message-ID: <20070930191054.GA15876@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have just committed following patch to kbuild.git.
It deprecate use of EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS
in favour of ccflags-y, asflags-y and ldflags-y.

This allow us to use a more kbuild alike syntax like the following:

ccflags-$(CONFIG_WHATEVER_DEBUG) := -DDEBUG

The other kbuild enhancements discussed are put on ice for a 
few days.

I wanted this enhancement to hit the kernel in the merge window
so we had a better opportunity to fix the in-tree users
of the deprecated users of EXTRA_xFLAGS before next merge window.

	Sam

commit 41e63e70c31365aa7c920a93eed2c570163e6eff
Author: Sam Ravnborg <sam@neptun.(none)>
Date:   Sun Sep 30 20:59:57 2007 +0200

    kbuild: introduce ccflags-y, asflags-y and ldflags-y
    
    And deprecate use of EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS
    This patch does not touch any in-tree users - thats next round.
    Lets get this committed first and then fix the users of the
    deprecated variants next.
    
    The rationale behind this change is to introduce support for
    makefile fragments like:
    
    ccflags-$(CONFIG_WHATEVER_DEBUG) := -DDEBUG
    
    As a replacement for the uglier:
    ifeq ($(CONFIG_WHATEVER_DEBUG),y)
    	EXTRA_CFLAGS := -DDEBUG
    endif
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 08fbe6c..f099b81 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -276,40 +276,39 @@ more details, with real examples.
 
 --- 3.7 Compilation flags
 
-    EXTRA_CFLAGS, EXTRA_AFLAGS, EXTRA_LDFLAGS
+    ccflags-y, asflags-y and ldflags-y
+	The three flags listed above applies only to the kbuild makefile
+	where they are assigned. They are used for all the normal
+	cc, as and ld invocation happenign during a recursive build.
+	Note: Flags with the same behaviour were previously named:
+	EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS.
+	They are yet supported but their use are deprecated.
 
-	All the EXTRA_ variables apply only to the kbuild makefile
-	where they are assigned. The EXTRA_ variables apply to all
-	commands executed in the kbuild makefile.
-
-	$(EXTRA_CFLAGS) specifies options for compiling C files with
-	$(CC).
+	ccflags-y specifies options for compiling C files with $(CC).
 
 	Example:
 		# drivers/sound/emu10k1/Makefile
-		EXTRA_CFLAGS += -I$(obj)
-		ifdef DEBUG
-		    EXTRA_CFLAGS += -DEMU10K1_DEBUG
-		endif
+		ccflags-y += -I$(obj)
+		ccflags-$(DEBUG) += -DEMU10K1_DEBUG
 
 
 	This variable is necessary because the top Makefile owns the
 	variable $(KBUILD_CFLAGS) and uses it for compilation flags for the
 	entire tree.
 
-	$(EXTRA_AFLAGS) is a similar string for per-directory options
+	asflags-y is a similar string for per-directory options
 	when compiling assembly language source.
 
 	Example:
 		#arch/x86_64/kernel/Makefile
-		EXTRA_AFLAGS := -traditional
+		asflags-y := -traditional
 
 
-	$(EXTRA_LDFLAGS) is a string for per-directory options to $(LD).
+	ldflags-y is a string for per-directory options to $(LD).
 
 	Example:
 		#arch/m68k/fpsp040/Makefile
-		EXTRA_LDFLAGS := -x
+		ldflags-y := -x
 
     CFLAGS_$@, AFLAGS_$@
 
@@ -495,9 +494,9 @@ more details, with real examples.
 
 	Example:
 		#fs/reiserfs/Makefile
-		EXTRA_CFLAGS := $(call cc-ifversion, -lt, 0402, -O1)
+		ccflags-y := $(call cc-ifversion, -lt, 0402, -O1)
 
-	In this example, EXTRA_CFLAGS will be assigned the value -O1 if the
+	In this example, ccflags-y will be assigned the value -O1 if the
 	$(CC) version is less than 4.2.
 	cc-ifversion takes all the shell operators:
 	-eq, -ne, -lt, -le, -gt, and -ge
@@ -783,7 +782,7 @@ When kbuild executes, the following steps are followed (roughly):
 	Example:
 		#arch/s390/Makefile
 		LDFLAGS         := -m elf_s390
-	Note: EXTRA_LDFLAGS can be used to further customise
+	Note: ldflags-y can be used to further customise
 	the flags used. See chapter 3.7.
 
     LDFLAGS_MODULE	Options for $(LD) when linking modules
@@ -1100,7 +1099,7 @@ When kbuild executes, the following steps are followed (roughly):
 
 	When building the *.lds target, kbuild uses the variables:
 	KBUILD_CPPFLAGS	: Set in top-level Makefile
-	EXTRA_CPPFLAGS	: May be set in the kbuild makefile
+	cppflags-y	: May be set in the kbuild makefile
 	CPPFLAGS_$(@F)  : Target specific flags.
 	                  Note that the full filename is used in this
 	                  assignment.
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 8ef1d61..c56234f 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -22,6 +22,10 @@ EXTRA_AFLAGS   :=
 EXTRA_CFLAGS   :=
 EXTRA_CPPFLAGS :=
 EXTRA_LDFLAGS  :=
+asflags-y  :=
+ccflags-y  :=
+cppflags-y :=
+ldflags-y  :=
 
 # Read .config if it exist, otherwise ignore
 -include include/config/auto.conf
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 95e6e0f..3c5e88b 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -1,3 +1,9 @@
+# Backward compatibility
+asflags-y  += $(EXTRA_AFLAGS)
+ccflags-y  += $(EXTRA_CFLAGS)
+cppflags-y += $(EXTRA_CPPFLAGS)
+ldflags-y  += $(EXTRA_LDFLAGS)
+
 # Figure out what we need to build from the various variables
 # ===========================================================================
 
@@ -84,9 +90,9 @@ basename_flags = -D"KBUILD_BASENAME=KBUILD_STR($(call name-fix,$(basetarget)))"
 modname_flags  = $(if $(filter 1,$(words $(modname))),\
                  -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")
 
-_c_flags       = $(KBUILD_CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$(basetarget).o)
-_a_flags       = $(KBUILD_AFLAGS) $(EXTRA_AFLAGS) $(AFLAGS_$(basetarget).o)
-_cpp_flags     = $(KBUILD_CPPFLAGS) $(EXTRA_CPPFLAGS) $(CPPFLAGS_$(@F))
+_c_flags       = $(KBUILD_CFLAGS) $(ccflags-y) $(CFLAGS_$(basetarget).o)
+_a_flags       = $(KBUILD_AFLAGS) $(asflags-y) $(AFLAGS_$(basetarget).o)
+_cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
 
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
@@ -115,7 +121,7 @@ a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
 
 cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(__cpp_flags)
 
-ld_flags       = $(LDFLAGS) $(EXTRA_LDFLAGS)
+ld_flags       = $(LDFLAGS) $(ldflags-y)
 
 # Finds the multi-part object the current object will be linked into
 modname-multi = $(sort $(foreach m,$(multi-used),\
@@ -145,7 +151,7 @@ $(obj)/%:: $(src)/%_shipped
 # ---------------------------------------------------------------------------
 
 quiet_cmd_ld = LD      $@
-cmd_ld = $(LD) $(LDFLAGS) $(EXTRA_LDFLAGS) $(LDFLAGS_$(@F)) \
+cmd_ld = $(LD) $(LDFLAGS) $(ldflags-y) $(LDFLAGS_$(@F)) \
 	       $(filter-out FORCE,$^) -o $@ 
 
 # Objcopy
diff --git a/scripts/makelst b/scripts/makelst
index 4fc80f2..e658149 100755
--- a/scripts/makelst
+++ b/scripts/makelst
@@ -3,8 +3,8 @@
 # with correct relocations from System.map
 # Requires the following lines in makefile:
 #%.lst: %.c
-#	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$@) -g -c -o $*.o $<
-#	$(srctree)/scripts/makelst $*.o $(objtree)/System.map $(OBJDUMP)
+#	$(CC) $(c_flags) -g -c -o $*.o $< &&
+#	$(srctree)/scripts/makelst $*.o System.map $(OBJDUMP) > $@
 #
 # Copyright (C) 2000 IBM Corporation
 # Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com)

