Return-Path: <linux-kernel-owner+w=401wt.eu-S932576AbZJ3QTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbZJ3QTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932534AbZJ3QTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:19:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:58166 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbZJ3QTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:19:08 -0400
Date: Fri, 30 Oct 2009 16:18:46 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, lihong.hi@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20091028050138.GA30758@uhli>
References: <20091028050138.GA30758@uhli>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Amend documentation in recordmcount.pl to reflect implementation
Message-ID: <tip-d49f6aa76d24c60a52530474cb662e8ad9f09471@git.kernel.org>
Git-Commit-ID: d49f6aa76d24c60a52530474cb662e8ad9f09471
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d49f6aa76d24c60a52530474cb662e8ad9f09471
Gitweb:     http://git.kernel.org/tip/d49f6aa76d24c60a52530474cb662e8ad9f09471
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Wed, 28 Oct 2009 13:01:38 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 29 Oct 2009 15:11:40 -0400

tracing: Amend documentation in recordmcount.pl to reflect implementation

The documentation currently says we will use the first function in a section
as a reference. The actual algorithm is: choose the first global function we
meet as a reference. If there is none, choose the first local one.
Change the documentation to be consistent with the code.

Also add several other clarifications.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091028050138.GA30758@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |   84 +++++++++++++++++++++++++++-------------------
 1 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index bfb8b2c..a569be7 100755
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
+#
+# But where this section will reside finally in vmlinx is undetermined at
+# this point. So we can't use this kind of offsets to record the final
+# address of this call site.
+#
+# The trick is to change the call offset referring the start of a section to
+# referring a function symbol in this section. During the link step, 'ld' will
+# compute the final address according to the information we record.
 #
-# The trick is to find a way to record the beginning of the section.
-# The way we do this is to look at the first function in the section
-# which will also be the location of that section after final link.
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
