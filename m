Return-Path: <linux-kernel-owner+w=401wt.eu-S1762814AbXIUXnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762814AbXIUXnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbXIUXnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:43:42 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:1498 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbXIUXnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:43:41 -0400
X-Greylist: delayed 2044 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2007 19:43:41 EDT
Date: Fri, 21 Sep 2007 18:09:02 -0500 (CDT)
Subject: [PATCH Kbuild] Call only one make with all targets for O=
From: Milton Miller <miltonm@bga.com>
To: Sam Ravnborg <sam@ravnborg.org>,
       Kai Germaschewski <kai@germaschewski.name>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Message-Id: <kbuild-8-00.miltonm@bga.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the invocations of make in the output directory Makefile and the
main Makefile for seperate object trees to pass all goals to one $(MAKE)
via a new phony target "sub-make" and the existing target _all.

When compiling with seperate object directories, a seperate make is called
in the context of another directory (from the output directory the main
Makefile is called, the Makefile is then restarted with current directory
set to the object tree).  Before this patch, when multiple make command
goals are specified, each target results in a seperate make invocation.
With make -j, these invocations may run in parallel, resulting in multiple
commands running in the same directory clobbering each others results.

I did not try to address make -j for mixed dot-config and no-dot-config
targets.  Because the order does matter, a solution was not obvious.
Perhaps a simple check for MAKEFLAGS having -j and refusing to run would
be approprate.

Signed-off-by: Milton Miller <miltonm@bga.com>
---
I chose @: as the phony command after the sub-make target does all the
work; is there a better alternative?  It looks like :; is used for
Makefile.

Index: kernel/Makefile
===================================================================
--- kernel.orig/Makefile	2007-09-19 01:55:45.000000000 -0500
+++ kernel/Makefile	2007-09-19 02:01:16.000000000 -0500
@@ -116,12 +116,16 @@ KBUILD_OUTPUT := $(shell cd $(KBUILD_OUT
 $(if $(KBUILD_OUTPUT),, \
      $(error output directory "$(saved-output)" does not exist))
 
-PHONY += $(MAKECMDGOALS)
+PHONY += $(MAKECMDGOALS) sub-make
 
-$(filter-out _all,$(MAKECMDGOALS)) _all:
+$(filter-out _all sub-make,$(MAKECMDGOALS)) _all: sub-make
+	@:
+
+sub-make: FORCE
 	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
 	KBUILD_SRC=$(CURDIR) \
-	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile $@
+	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
+	$(filter-out _all sub-make,$(MAKECMDGOALS))
 
 # Leave processing to above invocation of make
 skip-makefile := 1
Index: kernel/scripts/mkmakefile
===================================================================
--- kernel.orig/scripts/mkmakefile	2007-09-19 01:55:45.000000000 -0500
+++ kernel/scripts/mkmakefile	2007-09-19 02:01:53.000000000 -0500
@@ -26,11 +26,13 @@ MAKEFLAGS += --no-print-directory
 
 .PHONY: all \$(MAKECMDGOALS)
 
+all	:= \$(filter-out all Makefile,\$(MAKECMDGOALS))
+
 all:
-	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT)
+	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) \$(all)
 
 Makefile:;
 
-\$(filter-out all Makefile,\$(MAKECMDGOALS)) %/:
-	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) \$@
+\$(all) %/: all
+	@:
 EOF
