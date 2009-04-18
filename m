Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZDRMuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZDRMuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 08:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZDRMt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 08:49:56 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36807 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbZDRMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 08:49:54 -0400
Date: Sat, 18 Apr 2009 14:51:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: kbuild - introduce support for subdir-ccflags-y
Message-ID: <20090418125159.GA23008@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch introduce support for setting options
to gcc that has effect for current directory and all
subdirectories.


The typical use cases are an architecture or a subsystem that
decide to cover all files with -Werror.
Today alpha, mips and sparc uses -Werror in almost all their
Makefile - with subdir-ccflag-y it is now simpler to do so
as only the top-level directories needs to be covered.

Likewise if we decide to cover a full subsystem such
as net/ with -Werror this is done by adding a single
line to net/Makefile.

The feature is added because the x86 guys are planning
to (conditionally) cover all of arch/x86/ with -Werrror
and adding this statement in each single Makefile
was *the wrong way* to do so.

	Sam

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index d4b0567..d76cfd8 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -316,6 +316,16 @@ more details, with real examples.
 		#arch/m68k/fpsp040/Makefile
 		ldflags-y := -x
 
+    subdir-ccflags-y, subdir-asflags-y
+	The two flags listed above are similar to ccflags-y and as-falgs-y.
+	The difference is that the subdir- variants has effect for the kbuild
+	file where tey are present and all subdirectories.
+	Options specified using subdir-* are added to the commandline before
+	the options specified using the non-subdir variants.
+
+	Example:
+		subdir-ccflags-y := -Werror
+
     CFLAGS_$@, AFLAGS_$@
 
 	CFLAGS_$@ and AFLAGS_$@ only apply to commands in current
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 39a9642..5c4b7a4 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -27,6 +27,9 @@ ccflags-y  :=
 cppflags-y :=
 ldflags-y  :=
 
+subdir-asflags-y :=
+subdir-ccflags-y :=
+
 # Read auto.conf if it exists, otherwise ignore
 -include include/config/auto.conf
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 9796195..cba61ca 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -4,6 +4,11 @@ ccflags-y  += $(EXTRA_CFLAGS)
 cppflags-y += $(EXTRA_CPPFLAGS)
 ldflags-y  += $(EXTRA_LDFLAGS)
 
+#
+# flags that take effect in sub directories
+export KBUILD_SUBDIR_ASFLAGS := $(KBUILD_SUBDIR_ASFLAGS) $(subdir-asflags-y)
+export KBUILD_SUBDIR_CCFLAGS := $(KBUILD_SUBDIR_CCFLAGS) $(subdir-ccflags-y)
+
 # Figure out what we need to build from the various variables
 # ===========================================================================
 
@@ -104,10 +109,10 @@ else
 debug_flags =
 endif
 
-orig_c_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS)                     \
+orig_c_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(KBUILD_SUBDIR_CCFLAGS) \
                  $(ccflags-y) $(CFLAGS_$(basetarget).o)
 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(orig_c_flags))
-_a_flags       = $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS)                     \
+_a_flags       = $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS) $(KBUILD_SUBDIR_ASFLAGS) \
                  $(asflags-y) $(AFLAGS_$(basetarget).o)
 _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
 
