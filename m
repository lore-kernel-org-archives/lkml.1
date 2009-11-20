Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbZKTJ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbZKTJ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZKTJ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:57:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42163 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZKTJ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:56:58 -0500
To: rostedt@goodmis.org
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: [PATCH] gcc mcount-nofp was Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	<tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	<20091119072040.GA23579@elte.hu>
	<alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
	<1258653562.22249.682.camel@gandalf.stny.rr.com>
	<84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
	<alpine.LFD.2.00.0911191026420.2793@localhost.localdomain>
	<20091119184716.GA25458@elte.hu>
	<1258657614.22249.824.camel@gandalf.stny.rr.com>
Date: Fri, 20 Nov 2009 10:57:02 +0100
In-Reply-To: <1258657614.22249.824.camel@gandalf.stny.rr.com> (Steven Rostedt's message of "Thu, 19 Nov 2009 14:06:54 -0500")
Message-ID: <87iqd54iz5.fsf_-_@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
>
> And frame pointers do add a little overhead as well. Too bad the mcount
> ABI wasn't something like this:
>
>
> 	<function>:
> 		call	mcount
> 		[...]
>
> This way, the function address for mcount would have been (%esp) and the
> parent address would be 4(%esp). Mcount would work without frame
> pointers and this whole mess would also become moot.

I did a patch to do this in x86 gcc some time ago. The motivation
was indeed the frame pointer overhead on Atom with tracing.

Unfortunately it also requires glibc changes (I did those too). For
compatibility and catching mistakes the new function was called
__mcount_nofp.

I haven't tried it with current gcc and last time I missed the 
gcc feature merge window with this.

But perhaps you find it useful. Of course it would need more
kernel changes to probe for the new option and handle it.

Here's the old patch. I haven't retested it with a current
gcc version, but I think it still applies at least.

If there's interest I can polish it up and submit formally.

-Andi


Index: gcc/doc/tm.texi
===================================================================
--- gcc/doc/tm.texi	(revision 149140)
+++ gcc/doc/tm.texi	(working copy)
@@ -1884,6 +1884,12 @@
 of words in each data entry.
 @end defmac
 
+@defmac TARGET_FUNCTION_PROFILE
+Define if the target has a custom function_profiler function.
+The target should not set this macro, it is implicitely set from 
+the PROFILE_BEFORE_PROLOGUE macro.
+@end defmac
+
 @node Registers
 @section Register Usage
 @cindex register usage
Index: gcc/doc/invoke.texi
===================================================================
--- gcc/doc/invoke.texi	(revision 149140)
+++ gcc/doc/invoke.texi	(working copy)
@@ -593,7 +593,7 @@
 -momit-leaf-frame-pointer  -mno-red-zone -mno-tls-direct-seg-refs @gol
 -mcmodel=@var{code-model} -mabi=@var{name} @gol
 -m32  -m64 -mlarge-data-threshold=@var{num} @gol
--mfused-madd -mno-fused-madd -msse2avx}
+-mfused-madd -mno-fused-madd -msse2avx -mmcount-nofp}
 
 @emph{IA-64 Options}
 @gccoptlist{-mbig-endian  -mlittle-endian  -mgnu-as  -mgnu-ld  -mno-pic @gol
@@ -11749,6 +11749,11 @@
 @opindex msse2avx
 Specify that the assembler should encode SSE instructions with VEX
 prefix.  The option @option{-mavx} turns this on by default.
+
+@item -mmcount-nofp
+Don't force the frame counter with @option{-pg} function profiling.
+Instead call a new @code{__mcount_nofp} function before a stack 
+frame is set up.
 @end table
 
 These @samp{-m} switches are supported in addition to the above
Index: gcc/target.h
===================================================================
--- gcc/target.h	(revision 149140)
+++ gcc/target.h	(working copy)
@@ -1132,6 +1132,9 @@
    */
   bool arm_eabi_unwinder;
 
+  /* True when the function profiler code is outputted before the prologue. */
+  bool profile_before_prologue;
+
   /* Leave the boolean fields at the end.  */
 };
 
Index: gcc/final.c
===================================================================
--- gcc/final.c	(revision 149140)
+++ gcc/final.c	(working copy)
@@ -1520,10 +1520,8 @@
 
   /* The Sun386i and perhaps other machines don't work right
      if the profiling code comes after the prologue.  */
-#ifdef PROFILE_BEFORE_PROLOGUE
-  if (crtl->profile)
+  if (targetm.profile_before_prologue && crtl->profile)
     profile_function (file);
-#endif /* PROFILE_BEFORE_PROLOGUE */
 
 #if defined (DWARF2_UNWIND_INFO) && defined (HAVE_prologue)
   if (dwarf2out_do_frame ())
@@ -1565,10 +1563,8 @@
 static void
 profile_after_prologue (FILE *file ATTRIBUTE_UNUSED)
 {
-#ifndef PROFILE_BEFORE_PROLOGUE
-  if (crtl->profile)
+  if (!targetm.profile_before_prologue && crtl->profile)
     profile_function (file);
-#endif /* not PROFILE_BEFORE_PROLOGUE */
 }
 
 static void
Index: gcc/gcc.c
===================================================================
--- gcc/gcc.c	(revision 149140)
+++ gcc/gcc.c	(working copy)
@@ -797,6 +797,12 @@
 # define SYSROOT_HEADERS_SUFFIX_SPEC ""
 #endif
 
+/* Target can override this to allow -pg/-fomit-frame-pointer together */
+#ifndef TARGET_PG_OPTION_SPEC
+#define TARGET_PG_OPTION_SPEC \
+"%{pg:%{fomit-frame-pointer:%e-pg and -fomit-frame-pointer are incompatible}}"
+#endif
+
 static const char *asm_debug;
 static const char *cpp_spec = CPP_SPEC;
 static const char *cc1_spec = CC1_SPEC;
@@ -866,8 +872,8 @@
 
 /* NB: This is shared amongst all front-ends, except for Ada.  */
 static const char *cc1_options =
-"%{pg:%{fomit-frame-pointer:%e-pg and -fomit-frame-pointer are incompatible}}\
- %1 %{!Q:-quiet} -dumpbase %B %{d*} %{m*} %{a*}\
+ TARGET_PG_OPTION_SPEC
+" %1 %{!Q:-quiet} -dumpbase %B %{d*} %{m*} %{a*}\
  %{fcompare-debug-second:%:compare-debug-auxbase-opt(%b)} \
  %{!fcompare-debug-second:%{c|S:%{o*:-auxbase-strip %*}%{!o*:-auxbase %b}}}%{!c:%{!S:-auxbase %b}} \
  %{g*} %{O*} %{W*&pedantic*} %{w} %{std*&ansi&trigraphs}\
Index: gcc/target-def.h
===================================================================
--- gcc/target-def.h	(revision 149140)
+++ gcc/target-def.h	(working copy)
@@ -841,6 +841,12 @@
     TARGET_OPTION_CAN_INLINE_P,			\
   }
 
+#ifdef PROFILE_BEFORE_PROLOGUE
+#define TARGET_FUNCTION_PROFILE true
+#else
+#define TARGET_FUNCTION_PROFILE false
+#endif
+
 /* The whole shebang.  */
 #define TARGET_INITIALIZER			\
 {						\
@@ -960,7 +966,8 @@
   TARGET_HANDLE_PRAGMA_REDEFINE_EXTNAME,	\
   TARGET_HANDLE_PRAGMA_EXTERN_PREFIX,		\
   TARGET_RELAXED_ORDERING,			\
-  TARGET_ARM_EABI_UNWINDER			\
+  TARGET_ARM_EABI_UNWINDER,			\
+  TARGET_FUNCTION_PROFILE			\
 }
 
 #define TARGET_HANDLE_C_OPTION default_handle_c_option
Index: gcc/config/i386/i386.h
===================================================================
--- gcc/config/i386/i386.h	(revision 149140)
+++ gcc/config/i386/i386.h	(working copy)
@@ -2528,6 +2528,9 @@
 #undef TARG_COND_NOT_TAKEN_BRANCH_COST
 #define TARG_COND_NOT_TAKEN_BRANCH_COST ix86_cost->cond_not_taken_branch_cost
 
+/* Allow -pg with -fomit-frame-pointer */
+#define TARGET_PG_OPTION_SPEC ""
+
 /*
 Local variables:
 version-control: t
Index: gcc/config/i386/i386.opt
===================================================================
--- gcc/config/i386/i386.opt	(revision 149140)
+++ gcc/config/i386/i386.opt	(working copy)
@@ -358,3 +358,7 @@
 msse2avx
 Target Report Var(ix86_sse2avx)
 Encode SSE instructions with VEX prefix
+
+mmcount-nofp
+Target Report Var(ix86_mcount_nofp)
+Support function profiling without frame pointer
Index: gcc/config/i386/i386.c
===================================================================
--- gcc/config/i386/i386.c	(revision 149140)
+++ gcc/config/i386/i386.c	(working copy)
@@ -3413,6 +3413,9 @@
     target_flags |= MASK_CLD & ~target_flags_explicit;
 #endif
 
+  if (flag_omit_frame_pointer && profile_flag && ix86_mcount_nofp)
+    targetm.profile_before_prologue = true;
+
   /* Save the initial options in case the user does function specific options */
   if (main_args_p)
     target_option_default_node = target_option_current_node
@@ -7442,7 +7445,7 @@
 	  || ix86_current_function_calls_tls_descriptor))
     return true;
 
-  if (crtl->profile)
+  if (crtl->profile && targetm.profile_before_prologue && !ix86_mcount_nofp)
     return true;
 
   return false;
@@ -27364,6 +27367,11 @@
 void
 x86_function_profiler (FILE *file, int labelno ATTRIBUTE_UNUSED)
 {
+  const char *name = MCOUNT_NAME;
+
+  if (targetm.profile_before_prologue && ix86_mcount_nofp)
+    name = "__mcount_nofp";
+
   if (TARGET_64BIT)
     {
 #ifndef NO_PROFILE_COUNTERS
@@ -27371,9 +27379,9 @@
 #endif
 
       if (DEFAULT_ABI == SYSV_ABI && flag_pic)
-	fprintf (file, "\tcall\t*%s@GOTPCREL(%%rip)\n", MCOUNT_NAME);
+	fprintf (file, "\tcall\t*%s@GOTPCREL(%%rip)\n", name);
       else
-	fprintf (file, "\tcall\t%s\n", MCOUNT_NAME);
+	fprintf (file, "\tcall\t%s\n", name);
     }
   else if (flag_pic)
     {
@@ -27381,7 +27389,7 @@
       fprintf (file, "\tleal\t%sP%d@GOTOFF(%%ebx),%%%s\n",
 	       LPREFIX, labelno, PROFILE_COUNT_REGISTER);
 #endif
-      fprintf (file, "\tcall\t*%s@GOT(%%ebx)\n", MCOUNT_NAME);
+      fprintf (file, "\tcall\t*%s@GOT(%%ebx)\n", name);
     }
   else
     {
@@ -27389,7 +27397,7 @@
       fprintf (file, "\tmovl\t$%sP%d,%%%s\n", LPREFIX, labelno,
 	       PROFILE_COUNT_REGISTER);
 #endif
-      fprintf (file, "\tcall\t%s\n", MCOUNT_NAME);
+      fprintf (file, "\tcall\t%s\n", name);
     }
 }
 

-- 
ak@linux.intel.com -- Speaking for myself only.
