Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYEOBjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYEOBjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYEOBhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:37:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYEOBhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:37:07 -0400
Message-Id: <20080515013705.027387767@goodmis.org>
References: <20080515013028.056366414@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 May 2008 21:30:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       pq@iki.fi, proski@gnu.org, sandmann@redhat.com, a.p.zijlstra@chello.nl,
       linux-kbuild@vger.kernel.org, zippel@linux-m68k.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/4] kbuild: Create new CFLAGS_REMOVE_(basename).o option
Content-Disposition: inline; filename=kbuild-add-cflags-remove.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have a way to add special CFLAGS to code, but we do not have a 
way to remove them if needed.

With the case of ftrace, some files should simply not be profiled. Adding
the -pg flag to these files is simply a waste, and adding "notrace" to each
and every function is ugly.

Currently we put in "Makefile turd" [1] to stop the compiler from adding -pg
to certain files. This was clumsy and awkward.

This patch now adds the revese of CFLAGS_(basename).o with
CFLAGS_REMOVE_(basename).o.  This allows developers to prevent certain
CFLAGS from being used to compile files. For example, we can now do

CFLAGS_REMOVE_string.o = -pg

to remove the -pg option from the string.o file in the lib directory.

Note: a space delimited list of options may be added to the REMOVE macro.

[1] - what David Miller called the workaronud to remove -pg

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/Makefile.lib |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-sched-devel.git/scripts/Makefile.lib
===================================================================
--- linux-sched-devel.git.orig/scripts/Makefile.lib	2008-05-14 18:12:22.000000000 -0700
+++ linux-sched-devel.git/scripts/Makefile.lib	2008-05-14 18:12:26.000000000 -0700
@@ -96,7 +96,8 @@ basename_flags = -D"KBUILD_BASENAME=KBUI
 modname_flags  = $(if $(filter 1,$(words $(modname))),\
                  -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")
 
-_c_flags       = $(KBUILD_CFLAGS) $(ccflags-y) $(CFLAGS_$(basetarget).o)
+orig_c_flags   = $(KBUILD_CFLAGS) $(ccflags-y) $(CFLAGS_$(basetarget).o)
+_c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(orig_c_flags))
 _a_flags       = $(KBUILD_AFLAGS) $(asflags-y) $(AFLAGS_$(basetarget).o)
 _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
 

-- 
