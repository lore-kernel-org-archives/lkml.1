Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZJ1FBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZJ1FBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbZJ1FBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:01:48 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:58276 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZJ1FBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=VwvlWvwsTSuE0ACdzLfP66JxlmpbMyFfLCn8wuEc05e1C+MAqu7nVUrvneGJAKBlwG
         RW4hYesrCT5D4hkSM+wtNq3u/QYXozvVnWl6oofVBvEGngQtEAiAanhyQFHTm7MyHL01
         F1q+Pvr2EnZRD8sd9nghYTz20XgdOORF0yJ8c=
Date: Wed, 28 Oct 2009 13:01:38 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/8] tracing: recordmcount.pl Amend the documentation
	according to the implementation
Message-ID: <20091028050138.GA30758@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091028045532.GA30036@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028045532.GA30036@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f36a6cc55928300cc2f31f4b442f9bc21be2b059 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 11:31:27 +0800
Subject: [PATCH] tracing: recordmcount.pl Amend the documentation according to the implementation

In documentation, we says we will use the first function in a section as a
reference. Actually, the algorithm is: choose the first global function we
meet as a reference. If there is none, choose the first local one. So let the
documentation consistent to the code.

Also add several clarifications.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 scripts/recordmcount.pl |   84 +++++++++++++++++++++++++++-------------------
 1 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 090d300..9e7ceca 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -6,73 +6,89 @@
 #                   all the offsets to the calls to mcount.
 #
 #
-# What we want to end up with is a section in vmlinux called
-# __mcount_loc that contains a list of pointers to all the
-# call sites in the kernel that call mcount. Later on boot up, the kernel
-# will read this list, save the locations and turn them into nops.
-# When tracing or profiling is later enabled, these locations will then
-# be converted back to pointers to some function.
+# What we want to end up with this is that each object file will have a 
+# section called __mcount_loc that will hold the list of pointers to mcount
+# callers. After final linking, the vmlinux will have within .init.data the 
+# list of all callers to mcount between __start_mcount_loc and __stop_mcount_loc.
+# Later on boot up, the kernel will read this list, save the locations and turn
+# them into nops. When tracing or profiling is later enabled, these locations 
+# will then be converted back to pointers to some function.
 #
 # This is no easy feat. This script is called just after the original
 # object is compiled and before it is linked.
 #
-# The references to the call sites are offsets from the section of text
-# that the call site is in. Hence, all functions in a section that
-# has a call site to mcount, will have the offset from the beginning of
-# the section and not the beginning of the function.
+# When parse this object file using 'objdump', the references to the call 
+# sites are offsets from the section that the call site is in. Hence, all 
+# functions in a section that has a call site to mcount, will have the 
+# offset from the beginning of the section and not the beginning of the 
+# function.
 #
-# The trick is to find a way to record the beginning of the section.
-# The way we do this is to look at the first function in the section
-# which will also be the location of that section after final link.
+# But where this section will reside finally in vmlinx is undetermined at 
+# this point. So we can't use this kind of offsets to record the final
+# address of this call site.
+#
+# The trick is to change the call offset referring the start of a section to
+# referring a function symbol in this section. During the link step, 'ld' will
+# compute the final address according to the information we record.
+# 
 # e.g.
 #
 #  .section ".sched.text", "ax"
-#  .globl my_func
-#  my_func:
 #        [...]
-#        call mcount  (offset: 0x5)
+#  func1:
+#        [...]
+#        call mcount  (offset: 0x10)
+#        [...]
+#        ret
+#  .globl fun2
+#  func2:             (offset: 0x20)
+#        [...]
 #        [...]
 #        ret
-#  other_func:
+#  func3:
 #        [...]
-#        call mcount (offset: 0x1b)
+#        call mcount (offset: 0x30)
 #        [...]
 #
 # Both relocation offsets for the mcounts in the above example will be
-# offset from .sched.text. If we make another file called tmp.s with:
+# offset from .sched.text. If we choose global symbol func2 as a reference and
+# make another file called tmp.s with the new offsets:
 #
 #  .section __mcount_loc
-#  .quad  my_func + 0x5
-#  .quad  my_func + 0x1b
+#  .quad  func2 - 0x10
+#  .quad  func2 + 0x10
 #
-# We can then compile this tmp.s into tmp.o, and link it to the original
+# We can then compile this tmp.s into tmp.o, and link it back to the original
 # object.
 #
-# But this gets hard if my_func is not globl (a static function).
-# In such a case we have:
+# In our algorithm, we will choose the first global function we meet in this 
+# section as the reference. But this gets hard if there is no global functions 
+# in this section. In such a case we have to select a local one. E.g. func1:
 #
 #  .section ".sched.text", "ax"
-#  my_func:
+#  func1:
 #        [...]
-#        call mcount  (offset: 0x5)
+#        call mcount  (offset: 0x10)
 #        [...]
 #        ret
-#  other_func:
+#  func2:
 #        [...]
-#        call mcount (offset: 0x1b)
+#        call mcount (offset: 0x20)
 #        [...]
+#  .section "other.section"
 #
 # If we make the tmp.s the same as above, when we link together with
-# the original object, we will end up with two symbols for my_func:
+# the original object, we will end up with two symbols for func1:
 # one local, one global.  After final compile, we will end up with
-# an undefined reference to my_func.
+# an undefined reference to func1 or a wrong reference to another global
+# func1 in other files.
 #
 # Since local objects can reference local variables, we need to find
 # a way to make tmp.o reference the local objects of the original object
-# file after it is linked together. To do this, we convert the my_func
+# file after it is linked together. To do this, we convert func1
 # into a global symbol before linking tmp.o. Then after we link tmp.o
-# we will only have a single symbol for my_func that is global.
-# We can convert my_func back into a local symbol and we are done.
+# we will only have a single symbol for func1 that is global.
+# We can convert func1 back into a local symbol and we are done.
 #
 # Here are the steps we take:
 #
@@ -86,10 +102,8 @@
 # 6) Link together this new object with the list object.
 # 7) Convert the local functions back to local symbols and rename
 #    the result as the original object.
-#    End.
 # 8) Link the object with the list object.
 # 9) Move the result back to the original object.
-#    End.
 #
 
 use strict;
-- 
1.6.0.4

