Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZJ0Gy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZJ0Gy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZJ0Gy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:54:28 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35372 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbZJ0Gy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=hBjwtqp6Hr+AmY8cw2Sf9x7LH9Eb51Y59/p94F/of3CixZ2Tm4kQl37AUcee6LWzPi
         iSnb5tnuUNEfnnaoct+26tNsmTuQL9YtoKHJ/MOzxTY70xW5b3jnUCoIky/wvF++eB19
         fQpcwdXbvSjYCcFEoHyre1R7C3uIZEkG8Y+Lw=
Date: Tue, 27 Oct 2009 14:54:21 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] tracing: recordmcount.pl Amend the documentation
	according to the implementation
Message-ID: <20091027065421.GA22032@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In documentation, we says we will use the first function in a section as a
reference. Actually, the algorithm is: choose the first global function we
meet as a reference. If there is none, choose the first local one. So let the
documentation consistent to the code.

Also add several clarifications.

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 090d300..ac908b3 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -6,73 +6,88 @@
 #                   all the offsets to the calls to mcount.
 #
 #
-# What we want to end up with is a section in vmlinux called
-# __mcount_loc that contains a list of pointers to all the
-# call sites in the kernel that call mcount. Later on boot up, the kernel
-# will read this list, save the locations and turn them into nops.
-# When tracing or profiling is later enabled, these locations will then
-# be converted back to pointers to some function.
+# What we want to end up with this is a data area in .init.data in vmlinux 
+# that contains a list of pointers to all the call sites in the kernel that
+# call mcount. Later on boot up, the kernel will read this list, save the 
+# locations and turn them into nops. When tracing or profiling is later 
+# enabled, these locations will then be converted back to pointers to 
+# some function.
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
+# functions in a section that  has a call site to mcount, will have the 
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
+# The trick is to change the call offset refering the start of a section to
+# refering a function symbol in this section. During the link step, 'ld' will
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
@@ -86,10 +101,8 @@
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

