Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZJLVIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZJLVIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757692AbZJLVIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:08:42 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:48535 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668AbZJLVIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:08:41 -0400
Date: Mon, 12 Oct 2009 23:08:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when
	building a kernel
Message-ID: <20091012210804.GA4267@merkur.ravnborg.org>
References: <20091003103441.GA10874@elte.hu> <20091004191729.GA20203@merkur.ravnborg.org> <20091009092648.GA18894@elte.hu> <20091011213546.GB2768@merkur.ravnborg.org> <20091012204402.GC17163@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012204402.GC17163@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > The patch in question is reverted in my next push to Linus.
> 
> Thanks! Mind sending the fix/revert here too, so that we can test 
> whether that resolves all the problems?

Here it is.
I intended to send it out before sending pull request to Linus but I forgot.

	Sam

commit 2331d1a6cd3d6e580bc88b9a160066d9e1177fe1
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sun Oct 11 23:22:58 2009 +0200

    kbuild: revert "save ARCH & CROSS_COMPILE ..."
    
    Revert commit 575543347b5baed0ca927cb90ba8807396fe9cc9
    
    It caused following issues:
    
    - On architectures where ARCH= setting is used to select between
      32 and 64 bit this was no longer possible without "make mrproper"
    - If ARCH was changed then kbuild refused to run "make mrproper"
      because ARCH had changed
    - When CROSS_COMPILE was changed people were asked to run "make mrproper"
      but kbuild refused to run "make mrproper" because CROSS_COMPILE changed.
    - Spaces in CROSS_COMPILE was not 'supported'
    - If an non-existing ARCH= was used kbuild could get stuck
    
    Lessons learned:
    . Despite being simple and straghtforward people uses very different
      approaches when building the kernel.
    
    . CROSS_COMPILE is sometimes used for ccache despite cache being
      only a CC frontend so one would have expected CC to be
      used for this purpose.
    
    . And obviously this was not tested widely enough.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Cc: Pavel Machek <pavel@ucw.cz>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>

diff --git a/Makefile b/Makefile
index e50569a..8e5aaee 100644
--- a/Makefile
+++ b/Makefile
@@ -179,46 +179,9 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # Alternatively CROSS_COMPILE can be set in the environment.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
-#
-# To force ARCH and CROSS_COMPILE settings include kernel.* files
-# in the kernel tree - do not patch this file.
 export KBUILD_BUILDHOST := $(SUBARCH)
-
-# Kbuild save the ARCH and CROSS_COMPILE setting in kernel.* files.
-# Restore these settings and check that user did not specify
-# conflicting values.
-
-saved_arch  := $(shell cat include/generated/kernel.arch  2> /dev/null)
-saved_cross := $(shell cat include/generated/kernel.cross 2> /dev/null)
-
-ifneq ($(CROSS_COMPILE),)
-        ifneq ($(saved_cross),)
-                ifneq ($(CROSS_COMPILE),$(saved_cross))
-                        $(error CROSS_COMPILE changed from \
-                                "$(saved_cross)" to \
-                                 to "$(CROSS_COMPILE)". \
-                                 Use "make mrproper" to fix it up)
-                endif
-        endif
-else
-    CROSS_COMPILE := $(saved_cross)
-endif
-
-ifneq ($(ARCH),)
-        ifneq ($(saved_arch),)
-                ifneq ($(saved_arch),$(ARCH))
-                        $(error ARCH changed from \
-                                "$(saved_arch)" to "$(ARCH)". \
-                                 Use "make mrproper" to fix it up)
-                endif
-        endif
-else
-        ifneq ($(saved_arch),)
-                ARCH := $(saved_arch)
-        else
-                ARCH := $(SUBARCH)
-        endif
-endif
+ARCH		?= $(SUBARCH)
+CROSS_COMPILE	?=
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
@@ -483,11 +446,6 @@ ifeq ($(config-targets),1)
 include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG KBUILD_KCONFIG
 
-# save ARCH & CROSS_COMPILE settings
-$(shell mkdir -p include/generated &&                            \
-        echo $(ARCH)          > include/generated/kernel.arch && \
-        echo $(CROSS_COMPILE) > include/generated/kernel.cross)
-
 config: scripts_basic outputmakefile FORCE
 	$(Q)mkdir -p include/linux include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
