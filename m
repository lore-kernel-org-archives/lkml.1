Return-Path: <linux-kernel-owner+w=401wt.eu-S1765021AbZLQRV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765021AbZLQRV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764977AbZLQRVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:21:54 -0500
Received: from bitwagon.com ([74.82.39.175]:47029 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764992AbZLQRVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:21:53 -0500
Message-ID: <4B2A689D.2050202@bitwagon.com>
Date: Thu, 17 Dec 2009 09:21:33 -0800
From: John Reiser <jreiser@bitwagon.com>
Organization: -
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>
Subject: tracing: gcc for x86 calling mcount with -fomit-frame-pointer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 and x86_64, current "gcc -pg -fomit-frame-pointer" is not allowed.
This experimental patch against:
   http://mirrors.kernel.org/fedora/releases/12/Fedora/source/SRPMS/gcc-4.4.2-7.fc12.src.rpm
allows such a combination, via the  command line options:
   gcc --profile-before-prolog -fomit-frame-pointer
This turns on profiling (as if -pg), moves the "call mcount" to be the
very first instruction of a profiled routine, and omits the frame pointer
(unless some condition other than profiling requires a frame pointer.)
Placing the "call mcount" first, before any other code, has some advantages.
For instance, a postprocessor easily can modify a CALL whose destination
is known, to skip past the "call mcount" at the entry point.

The current glibc implementation of mcount relies on a frame pointer.
At least one recent change to Linux kernel traceback for tracing also relies
on a frame pointer.  So still there are conflicts, but they are different.

diff --git a/gcc/c-opts.c b/gcc/c-opts.c
index 28bdc31..aa8df9e 100644
--- a/gcc/c-opts.c
+++ b/gcc/c-opts.c
@@ -746,6 +746,10 @@ c_common_handle_option (size_t scode, const char *arg, int value)
       cpp_opts->preprocessed = value;
       break;

+    case OPT_fprofile_before_prolog:
+      flag_profile_before_prolog = value;
+      break;
+
     case OPT_freplace_objc_classes:
       flag_replace_objc_classes = value;
       break;
diff --git a/gcc/c.opt b/gcc/c.opt
index 711710b..63cd8b6 100644
--- a/gcc/c.opt
+++ b/gcc/c.opt
@@ -720,6 +720,10 @@ fpreprocessed
C ObjC C++ ObjC++
Treat the input file as already preprocessed

+fprofile-before-prolog
+C ObjC C++ ObjC++
+Generate  profiling code before the function prolog
+
freplace-objc-classes
ObjC ObjC++
Used in Fix-and-Continue mode to indicate that object files may be swapped in at runtime
diff --git a/gcc/config/i386/i386.c b/gcc/config/i386/i386.c
index c7a36f4..80bac96 100644
--- a/gcc/config/i386/i386.c
+++ b/gcc/config/i386/i386.c
@@ -7496,7 +7496,7 @@ ix86_frame_pointer_required (void)
	  || ix86_current_function_calls_tls_descriptor))
     return 1;

-  if (crtl->profile)
+  if (crtl->profile && !crtl->profile_before_prolog)
     return 1;

   return 0;
diff --git a/gcc/config/i386/linux.h b/gcc/config/i386/linux.h
index 39b8746..11008e8 100644
--- a/gcc/config/i386/linux.h
+++ b/gcc/config/i386/linux.h
@@ -55,7 +55,7 @@ along with GCC; see the file COPYING3.  If not see
    frame, so we cannot allow profiling without a frame pointer.  */

#undef SUBTARGET_FRAME_POINTER_REQUIRED
-#define SUBTARGET_FRAME_POINTER_REQUIRED crtl->profile
+#define SUBTARGET_FRAME_POINTER_REQUIRED (crtl->profile && !crtl->profile_before_prolog)

#undef SIZE_TYPE
#define SIZE_TYPE "unsigned int"
diff --git a/gcc/final.c b/gcc/final.c
index 5d717e1..8479245 100644
--- a/gcc/final.c
+++ b/gcc/final.c
@@ -1512,12 +1512,8 @@ final_start_function (rtx first ATTRIBUTE_UNUSED, FILE *file,
     leaf_renumber_regs (first);
#endif

-  /* The Sun386i and perhaps other machines don't work right
-     if the profiling code comes after the prologue.  */
-#ifdef PROFILE_BEFORE_PROLOGUE
-  if (crtl->profile)
+  if (crtl->profile && crtl->profile_before_prolog)
     profile_function (file);
-#endif /* PROFILE_BEFORE_PROLOGUE */

#if defined (DWARF2_UNWIND_INFO) && defined (HAVE_prologue)
   if (dwarf2out_do_frame ())
@@ -1559,10 +1555,8 @@ final_start_function (rtx first ATTRIBUTE_UNUSED, FILE *file,
static void
profile_after_prologue (FILE *file ATTRIBUTE_UNUSED)
{
-#ifndef PROFILE_BEFORE_PROLOGUE
-  if (crtl->profile)
+  if (crtl->profile && !crtl->profile_before_prolog)
     profile_function (file);
-#endif /* not PROFILE_BEFORE_PROLOGUE */
}

static void
@@ -3897,7 +3891,7 @@ leaf_function_p (void)
   rtx insn;
   rtx link;

-  if (crtl->profile || profile_arc_flag)
+  if ((crtl->profile && !crtl->profile_before_prolog) || profile_arc_flag)
     return 0;

   for (insn = get_insns (); insn; insn = NEXT_INSN (insn))
diff --git a/gcc/flags.h b/gcc/flags.h
index e406bf1..9dbc63f 100644
--- a/gcc/flags.h
+++ b/gcc/flags.h
@@ -189,6 +189,9 @@ extern int flag_permissive;
/* Nonzero if we are compiling code for a shared library, zero for
    executable.  */

+/* Nonzero means generate profiling code before the function prolog. */
+extern int flag_profile_before_prolog;
+
extern int flag_shlib;

/* -dA causes debug information to be produced in
diff --git a/gcc/function.c b/gcc/function.c
index 2eb3d3b..08ed9a0 100644
--- a/gcc/function.c
+++ b/gcc/function.c
@@ -4362,9 +4362,13 @@ expand_function_start (tree subr)
      valid operands of arithmetic insns.  */
   init_recog_no_volatile ();

+  /* flag_profile_before_prolog: also set ->profile as temporary hack
+     to evade conflict between -pg and -fomit-frame-pointer. */
   crtl->profile
-    = (profile_flag
+    = ((profile_flag || flag_profile_before_prolog)
        && ! DECL_NO_INSTRUMENT_FUNCTION_ENTRY_EXIT (subr));
+  crtl->profile_before_prolog
+    = (crtl->profile && flag_profile_before_prolog);

   crtl->limit_stack
     = (stack_limit_rtx != NULL_RTX && ! DECL_NO_LIMIT_STACK (subr));
@@ -5016,13 +5020,11 @@ thread_prologue_and_epilogue_insns (void)
       record_insns (seq, NULL, &prologue_insn_hash);
       emit_note (NOTE_INSN_PROLOGUE_END);
  -#ifndef PROFILE_BEFORE_PROLOGUE
       /* Ensure that instructions are not moved into the prologue when
	 profiling is on.  The call to the profiling routine can be
	 emitted within the live range of a call-clobbered register.  */
-      if (crtl->profile)
+      if (crtl->profile && !crtl->profile_before_prolog)
         emit_insn (gen_blockage ());
-#endif

       seq = get_insns ();
       end_sequence ();
diff --git a/gcc/function.h b/gcc/function.h
index 5658e9e..9c97aeb 100644
--- a/gcc/function.h
+++ b/gcc/function.h
@@ -396,6 +396,9 @@ struct rtl_data GTY(())
   /* Nonzero if profiling code should be generated.  */
   bool profile;

+  /* Nonzero if profiling code should be generated before prolog.  */
+  bool profile_before_prolog;
+
   /* Nonzero if the current function uses the constant pool.  */
   bool uses_const_pool;

diff --git a/gcc/toplev.c b/gcc/toplev.c
index b379f8e..e7300ce 100644
--- a/gcc/toplev.c
+++ b/gcc/toplev.c
@@ -290,6 +290,9 @@ int flag_pedantic_errors = 0;

int flag_permissive = 0;

+/* Nonzero means generate profiling code before the function prolog. */
+int flag_profile_before_prolog = 0;
+
/* -dA causes debug commentary information to be produced in
    the generated assembly code (to make it more readable).  This option
    is generally only of use to those who actually need to read the
@@ -1687,6 +1690,11 @@ process_options (void)
   if (warn_unused_value == -1)
     warn_unused_value = warn_unused;

+#ifdef PROFILE_BEFORE_PROLOG
+  /* Forced on some architectures. */
+  flag_profile_before_prolog = 1;
+#endif
+
   /* Allow the front end to perform consistency checks and do further
      initialization based on the command line options.  This hook also
      sets the original filename if appropriate (e.g. foo.i -> foo.c)

-- 
