Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXJRTZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXJRTZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbXJRTZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:25:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43802 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757317AbXJRTZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:25:05 -0400
Date: Thu, 18 Oct 2007 21:26:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: linux-kernel@vger.kernel.org, Armin Kuster <akuster@mvista.com>,
       protasnb@gmail.com, nafallo@magicalforest.se
Subject: Re: [PATCH] kbuild: Disable depmod in cross-compile kernel build
Message-ID: <20071018192600.GA22658@uranus.ravnborg.org>
References: <20071018180157.GA11408@plexity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018180157.GA11408@plexity.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 11:01:57AM -0700, Deepak Saxena wrote:
> 
> When building embedded systems in a cross-compile environment and
> populating a target's file system image, we don't want to run the 
> depmod on the host as we may be building for a completely different
> architecture. Since there's no such thing as a cross-depmod, we
> just disable running depmod in the cross-compile case and we just
> run depmod on the target at bootup.
> 
> Signed-off-by: Armin Kuster <akuster@mvista.com>
> Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

The root problem is depmod that should understand more targets.
But testing for CROSS_COMPILE is not good enough - we should
test is host target and buildtarget differs.

I took a look at it and came up with the attached patch.
This btw solves:
http://bugzilla.kernel.org/show_bug.cgi?id=3881


	Sam

diff --git a/Makefile b/Makefile
index e8ace82..784903a 100644
--- a/Makefile
+++ b/Makefile
@@ -1030,19 +1030,12 @@ _modinst_:
 	fi
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
-# If System.map exists, run depmod.  This deliberately does not have a
-# dependency on System.map since that would run the dependency tree on
-# vmlinux.  This depmod is only for convenience to give the initial
+# This depmod is only for convenience to give the initial
 # boot a modules.dep even before / is mounted read-write.  However the
 # boot script depmod is the master version.
-ifeq "$(strip $(INSTALL_MOD_PATH))" ""
-depmod_opts	:=
-else
-depmod_opts	:= -b $(INSTALL_MOD_PATH) -r
-endif
 PHONY += _modinst_post
 _modinst_post: _modinst_
-	if [ -r System.map -a -x $(DEPMOD) ]; then $(DEPMOD) -ae -F System.map $(depmod_opts) $(KERNELRELEASE); fi
+	$(call cmd,depmod)
 
 else # CONFIG_MODULES
 
@@ -1259,15 +1252,6 @@ _emodinst_:
 	$(Q)mkdir -p $(MODLIB)/$(install-dir)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
-# Run depmod only is we have System.map and depmod is executable
-quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
-      cmd_depmod = if [ -r System.map -a -x $(DEPMOD) ]; then \
-                      $(DEPMOD) -ae -F System.map             \
-                      $(if $(strip $(INSTALL_MOD_PATH)),      \
-		      -b $(INSTALL_MOD_PATH) -r)              \
-		      $(KERNELRELEASE);                       \
-                   fi
-
 PHONY += _emodinst_post
 _emodinst_post: _emodinst_
 	$(call cmd,depmod)
@@ -1516,6 +1500,16 @@ quiet_cmd_rmdirs = $(if $(wildcard $(rm-dirs)),CLEAN   $(wildcard $(rm-dirs)))
 quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files)))
       cmd_rmfiles = rm -f $(rm-files)
 
+# Run depmod only is we have System.map and depmod is executable
+# and we build for the host arch
+quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
+      cmd_depmod = \
+	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" == "$(ARCH)" ]; then \
+		$(DEPMOD) -ae -F System.map                                     \
+		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) -r)   \
+		$(KERNELRELEASE);                                               \
+	fi
+
 
 a_flags = -Wp,-MD,$(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
 	  $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
