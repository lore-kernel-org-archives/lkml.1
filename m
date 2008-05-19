Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbYESIp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYESIp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbYESIpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:45:01 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:30185 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759199AbYESIpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:45:00 -0400
Message-ID: <48313E08.8070904@de.ibm.com>
Date: Mon, 19 May 2008 10:44:56 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH 6/7] kbuild: make source and include paths absolute
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Change all source and include paths to absolute form when
CONFIG_GCOV_PROFILE is enabled.

Example:

  gcc -Idir1 -c a.c -o a.o

will become

  gcc -I/path/to/dir1 -c /path/to/a.c -o a.o

Required by the gcov profiling infrastructure: when compiling with
option -fprofile-arcs, gcc stores file names inside object files.
Relative paths prevent the gcov tool from finding corresponding source
files.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 scripts/Kbuild.include |    7 +++++++
 scripts/Makefile.build |    3 ++-
 scripts/Makefile.lib   |    8 +++++++-
 3 files changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc3/scripts/Makefile.lib
===================================================================
--- linux-2.6.26-rc3.orig/scripts/Makefile.lib
+++ linux-2.6.26-rc3/scripts/Makefile.lib
@@ -126,10 +126,16 @@ __a_flags	=                          $(c
 __cpp_flags     =                          $(call flags,_cpp_flags)
 endif
 
-c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
+___c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
 		 $(__c_flags) $(modkern_cflags) \
 		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags)
 
+ifeq ($(CONFIG_GCOV_PROFILE),)
+c_flags = $(___c_flags)
+else
+c_flags = $(call flags_addpath,___c_flags,$(objtree))
+endif
+
 a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
 		 $(__a_flags) $(modkern_aflags)
 
Index: linux-2.6.26-rc3/scripts/Makefile.build
===================================================================
--- linux-2.6.26-rc3.orig/scripts/Makefile.build
+++ linux-2.6.26-rc3/scripts/Makefile.build
@@ -165,7 +165,8 @@ $(obj)/%.symtypes : $(src)/%.c FORCE
 # (See cmd_cc_o_c + relevant part of rule_cc_o_c)
 
 quiet_cmd_cc_o_c = CC $(quiet_modtag)  $@
-cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<
+cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ \
+		$(if $(CONFIG_GCOV_PROFILE),$(call addpath,$<,$(objtree)),$<)
 
 ifdef CONFIG_MODVERSIONS
 # When module versioning is enabled the following steps are executed
Index: linux-2.6.26-rc3/scripts/Kbuild.include
===================================================================
--- linux-2.6.26-rc3.orig/scripts/Kbuild.include
+++ linux-2.6.26-rc3/scripts/Kbuild.include
@@ -149,6 +149,13 @@ addtree = $(if $(filter-out -I/%,$(1)),$
 # Find all -I options and call addtree
 flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
 
+# Prefix $(1) with $(2)/ if $(1) does not start with /
+addpath = $(if $(filter-out /%,$(1)),$(2)/$(1),$(1))
+
+# Find all -I options and call addpath
+flags_addpath = $(foreach o,$($(1)),\
+		$(if $(filter -I%,$(o)),-I$(call addpath,$(o:-I%=%),$(2)),$(o)))
+
 # echo command.
 # Short version is used, if $(quiet) equals `quiet_', otherwise full one.
 echo-cmd = $(if $($(quiet)cmd_$(1)),\



