Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbXLFU5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbXLFU5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbXLFU52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:57:28 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53664 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXLFU50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:57:26 -0500
Date: Thu, 6 Dec 2007 21:59:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Altenberg <jan.altenberg@linutronix.de>
Cc: miltonm@bga.com, linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>, tglx@linutronix.de
Subject: Re: kbuild: possible regression?
Message-ID: <20071206205913.GA24611@uranus.ravnborg.org>
References: <1193821430.3839.88.camel@bender.lan> <20071031094306.GB24100@uranus.ravnborg.org> <1194551101.6014.156.camel@bender.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194551101.6014.156.camel@bender.lan>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 08:45:01PM +0100, Jan Altenberg wrote:
> Hi Sam,
> 
> > > commit 0b35786d77ba4037f181982cc8ca20a7a3bf0fd2
> > > Author: Milton Miller <miltonm@bga.com>
> > > Date:   Fri Sep 21 18:09:02 2007 -0500
> > > 
> > >     kbuild: call make once for all targets when O=.. is used
> > >     
> > >     Change the invocations of make in the output directory Makefile and the
> > >     main Makefile for separate object trees to pass all goals to one $(MAKE)
> > >     via a new phony target "sub-make" and the existing target _all.
> > >     
> > >     When compiling with separate object directories, a separate make is called
> > >     in the context of another directory (from the output directory the main
> > >     Makefile is called, the Makefile is then restarted with current directory
> > >     set to the object tree).  Before this patch, when multiple make command
> > >     goals are specified, each target results in a separate make invocation.
> > >     With make -j, these invocations may run in parallel, resulting in multiple
> > >     commands running in the same directory clobbering each others results.
> > >     
> > >     I did not try to address make -j for mixed dot-config and no-dot-config
> > >     targets.  Because the order does matter, a solution was not obvious.
> > >     Perhaps a simple check for MAKEFLAGS having -j and refusing to run would
> > >     be appropriate.
> > >     
> > >     Signed-off-by: Milton Miller <miltonm@bga.com>
> > >     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > > 
> > > So, am I facing a kbuild regression?
> > 
> > Yes - I will try to fix it during the weekend (if Milton does not beat me).
> > Thanks for reporting and bisecting!
> 
> Have you made any progress on this? Let me know, if I can assist with
> testing.

Following seems to fix it with my limited testing.
I did an allnoconfig and then deleted CONFIG_LOGSHIFT from .config.
It failed before and succeeded after.

Please test and report back.

	Sam

diff --git a/Makefile b/Makefile
index 9c9c4bf..7bfac5b 100644
--- a/Makefile
+++ b/Makefile
@@ -108,6 +108,9 @@ endif
 PHONY := _all
 _all:
 
+# Cancel implicit rules on top Makefile.
+$(CURDIR)/Makefile Makefile: ;
+
 ifneq ($(KBUILD_OUTPUT),)
 # Invoke a second make in the output directory, passing relevant variables
 # check that the output directory actually exists
@@ -121,7 +124,7 @@ $(if $(filter-out $(KBUILD_OUTPUT),$(shell /bin/pwd)),, \
 
 PHONY += $(MAKECMDGOALS) sub-make
 
-$(filter-out _all sub-make,$(MAKECMDGOALS)) _all: sub-make
+$(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
 	$(Q)@:
 
 sub-make: FORCE
@@ -293,7 +296,8 @@ export quiet Q KBUILD_VERBOSE
 # Look for make include files relative to root of kernel src
 MAKEFLAGS += --include-dir=$(srctree)
 
-# We need some generic definitions.
+# We need some generic definitions (do not try to remake the file).
+$(srctree)/scripts/Kbuild.include: ;
 include $(srctree)/scripts/Kbuild.include
 
 # Make variables (CC, etc...)
@@ -1567,9 +1571,6 @@ endif	# skip-makefile
 PHONY += FORCE
 FORCE:
 
-# Cancel implicit rules on top Makefile, `-rR' will apply to sub-makes.
-Makefile: ;
-
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
 .PHONY: $(PHONY)
