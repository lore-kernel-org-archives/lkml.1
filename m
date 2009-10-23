Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbZJWWuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbZJWWuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 18:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZJWWuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 18:50:17 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18911 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZJWWuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 18:50:15 -0400
Message-ID: <4AE232AD.4050308@caviumnetworks.com>
Date: Fri, 23 Oct 2009 15:48:13 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: rdsandiford@googlemail.com, GCC Patches <gcc-patches@gcc.gnu.org>
CC: wuzhangjin@gmail.com, Adam Nemet <anemet@caviumnetworks.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] MIPS: Add option to pass return address location to _mcount.
  Was: [PATCH -v4 4/9] tracing: add static function tracer support for MIPS
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>	<2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>	<3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>	<ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>	<1256138686.18347.3039.camel@gandalf.stny.rr.com>	<1256233679.23653.7.camel@falcon>	<4AE0A5BE.8000601@caviumnetworks.com> <87y6n36plp.fsf@firetop.home>
In-Reply-To: <87y6n36plp.fsf@firetop.home>
Content-Type: multipart/mixed;
 boundary="------------010609000602030709030909"
X-OriginalArrivalTime: 23 Oct 2009 22:48:15.0164 (UTC) FILETIME=[E80B67C0:01CA5432]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010609000602030709030909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Richard Sandiford wrote:
> David Daney <ddaney@caviumnetworks.com> writes:
>> Wu Zhangjin wrote:
>>> On Wed, 2009-10-21 at 11:24 -0400, Steven Rostedt wrote:
>> [...]
>>>>> +
>>>>> +NESTED(_mcount, PT_SIZE, ra)
>>>>> +	RESTORE_SP_FOR_32BIT
>>>>> +	PTR_LA	t0, ftrace_stub
>>>>> +	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */
>>>> Is t0 and t1 safe for mcount to use? Remember, mcount does not follow
>>>> the dynamics of C function ABI.
>>> So, perhaps we can use the saved registers(a0,a1...) instead.
>>>
>> a0..a7 may not always be saved.
>>
>> You can use at, v0, v1 and all the temporary registers.  Note that for 
>> the 64-bit ABIs sometimes the names t0-t4 shadow a4-a7.  So for a 64-bit 
>> kernel, you can use: $1, $2, $3, $12, $13, $14, $15, $24, $25, noting 
>> that at == $1 and contains the callers ra.  For a 32-bit kernel you can 
>> add $8, $9, $10, and $11
>>
>> This whole thing seems a little fragile.
>>
>> I think it might be a good idea to get input from Richard Sandiford, 
>> and/or Adam Nemet about this approach (so I add them to the CC).
>>
>> This e-mail thread starts here:
>>
>> http://www.linux-mips.org/archives/linux-mips/2009-10/msg00286.html
>>
>> and here:
>>
>> http://www.linux-mips.org/archives/linux-mips/2009-10/msg00290.html
> 
> I'm not sure that the "search for a save of RA" thing is really a good idea.
> The last version of that seemed to be "assume that any register stores
> will be in a block that immediately precedes the move into RA", but even
> if that's true now, it might not be in future.  And as Wu Zhangjin says,
> it doesn't cope with long calls, where the target address is loaded
> into a temporary register before the call.
> 
> FWIW, I'd certainly be happy to make GCC pass an additional parameter
> to _mcount.  The parameter could give the address of the return slot,
> or null for leaf functions.  In almost all cases[*], there would be
> no overhead, since the move would go in the delay slot of the call.
> 
> [*] Meaning when the frame is <=32k. ;)  I'm guessing you never
>     get anywhere near that, and if you did, the scan thing wouldn't
>     work anyway.
> 
> The new behaviour could be controlled by a command-line option,
> which would also give linux a cheap way of checking whether the
> feature is available.
> 

How about this patch, I think it does what you suggest.

When we pass -pg -mmcount-raloc, the address of the return address 
relative to sp is passed in $12 to _mcount.  If the return address is 
not saved, $12 will be zero.  I think this will work as registers are 
never saved with an offset of zero.  $12 is a temporary register that is 
not part of the ABI.

$12 is also used by libffi closure support, but I think its use there 
will not interfere with _mcount.

It is very lightly tested, I would bootstrap and regression test with 
some new test cases if it were deemed acceptable.

2009-10-23  David Daney  <ddaney@caviumnetworks.com>

	* doc/invoke.texi (mmcount-raloc): Document new command line option.
	* config/mips/mips.opt (config/mips/mips.opt): New option.
	* config/mips/mips-protos.h (mips_function_profiler): Declare new
	function.
	* config/mips/mips.c (struct mips_frame_info): Add ra_fp_offset member.
	(mips_for_each_saved_gpr_and_fpr): Set ra_fp_offset.
	(mips_raloc_in_delay_slot_p): New function.
	(mips_function_profiler): Moved from FUNCTION_PROFILER, and rewritten.
	* config/mips/mips.h (FUNCTION_PROFILER): Body of macro moved to
	mips_function_profiler.


--------------010609000602030709030909
Content-Type: text/plain;
 name="mcount.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mcount.patch"

Index: gcc/doc/invoke.texi
===================================================================
--- gcc/doc/invoke.texi	(revision 153502)
+++ gcc/doc/invoke.texi	(working copy)
@@ -709,7 +709,7 @@ Objective-C and Objective-C++ Dialects}.
 -mbranch-cost=@var{num}  -mbranch-likely  -mno-branch-likely @gol
 -mfp-exceptions -mno-fp-exceptions @gol
 -mvr4130-align -mno-vr4130-align -msynci -mno-synci @gol
--mrelax-pic-calls -mno-relax-pic-calls}
+-mrelax-pic-calls -mno-relax-pic-calls -mmcount-raloc}
 
 @emph{MMIX Options}
 @gccoptlist{-mlibfuncs  -mno-libfuncs  -mepsilon  -mno-epsilon  -mabi=gnu @gol
@@ -14192,6 +14192,20 @@ an assembler and a linker that supports 
 directive and @code{-mexplicit-relocs} is in effect.  With
 @code{-mno-explicit-relocs}, this optimization can be performed by the
 assembler and the linker alone without help from the compiler.
+
+@item -mmcount-raloc
+@itemx -mno-mcount-raloc
+@opindex mmcount-raloc
+@opindex mno-mcount-raloc
+Emit (do not emit) code to pass the offset (from the stack pointer) of
+the return address save location to @code{_mcount}.  The default is
+@option{-mno-mcount-raloc}.
+
+@option{-mmcount-raloc} can be used in conjunction with @option{-pg}
+and a specially coded @code{_mcount} function to record function exit
+by replacing the return address on the stack with a pointer to the
+function exit profiling function.
+
 @end table
 
 @node MMIX Options
Index: gcc/config/mips/mips.opt
===================================================================
--- gcc/config/mips/mips.opt	(revision 153502)
+++ gcc/config/mips/mips.opt	(working copy)
@@ -208,6 +208,10 @@ mlong64
 Target Report RejectNegative Mask(LONG64)
 Use a 64-bit long type
 
+mmcount-raloc
+Target Report Var(TARGET_RALOC)
+Pass the offset from sp of the ra save location to _mcount in $12
+
 mmemcpy
 Target Report Mask(MEMCPY)
 Don't optimize block moves
Index: gcc/config/mips/mips-protos.h
===================================================================
--- gcc/config/mips/mips-protos.h	(revision 153502)
+++ gcc/config/mips/mips-protos.h	(working copy)
@@ -344,5 +344,6 @@ extern bool mips_eh_uses (unsigned int);
 extern bool mips_epilogue_uses (unsigned int);
 extern void mips_final_prescan_insn (rtx, rtx *, int);
 extern int mips_trampoline_code_size (void);
+extern void mips_function_profiler (FILE *);
 
 #endif /* ! GCC_MIPS_PROTOS_H */
Index: gcc/config/mips/mips.c
===================================================================
--- gcc/config/mips/mips.c	(revision 153502)
+++ gcc/config/mips/mips.c	(working copy)
@@ -319,6 +319,9 @@ struct GTY(())  mips_frame_info {
   HOST_WIDE_INT acc_sp_offset;
   HOST_WIDE_INT cop0_sp_offset;
 
+  /* Similar, but the value passed to _mcount.  */
+  HOST_WIDE_INT ra_fp_offset;
+
   /* The offset of arg_pointer_rtx from the bottom of the frame.  */
   HOST_WIDE_INT arg_pointer_offset;
 
@@ -9616,6 +9619,9 @@ mips_for_each_saved_gpr_and_fpr (HOST_WI
   for (regno = GP_REG_LAST; regno >= GP_REG_FIRST; regno--)
     if (BITSET_P (cfun->machine->frame.mask, regno - GP_REG_FIRST))
       {
+	/* Record the ra offset for use by mips_function_profiler.  */
+	if (regno == RETURN_ADDR_REGNUM)
+	  cfun->machine->frame.ra_fp_offset = offset + sp_offset;
 	mips_save_restore_reg (word_mode, regno, offset, fn);
 	offset -= UNITS_PER_WORD;
       }
@@ -16088,6 +16094,86 @@ mips_trampoline_init (rtx m_tramp, tree 
   emit_insn (gen_add3_insn (end_addr, addr, GEN_INT (TRAMPOLINE_SIZE)));
   emit_insn (gen_clear_cache (addr, end_addr));
 }
+
+/* Return true if the loading of $12 can be done in the jal/jalr delay
+   slot.  We can do this only if the jal will expand to a single
+   instruction and only a single instruction is required to load the
+   value to $12.  */
+
+static bool mips_raloc_in_delay_slot_p(void)
+{
+  return (SMALL_OPERAND_UNSIGNED(cfun->machine->frame.ra_fp_offset)
+	  && !TARGET_USE_GOT);
+}
+
+/* Implement FUNCTION_PROFILER.  */
+
+void mips_function_profiler (FILE *file)
+{
+  int emit_small_ra_offset;
+
+  emit_small_ra_offset = 0;
+
+  if (TARGET_MIPS16)
+    sorry ("mips16 function profiling");
+  if (TARGET_LONG_CALLS)
+    {
+      /*  For TARGET_LONG_CALLS use $3 for the address of _mcount.  */
+      if (Pmode == DImode)
+	fprintf (file, "\tdla\t%s,_mcount\n", reg_names[3]);
+      else
+	fprintf (file, "\tla\t%s,_mcount\n", reg_names[3]);
+    }
+  if (TARGET_RALOC)
+    {
+      /* If TARGET_RALOC load $12 with the offset of the ra save
+	 location.  */
+      if (mips_raloc_in_delay_slot_p())
+	emit_small_ra_offset = 1;
+      else
+	{
+	  if (Pmode == DImode)
+	    fprintf (file, "\tdli\t%s,%d\t\t# offset of ra\n", reg_names[12],
+		     cfun->machine->frame.ra_fp_offset);
+	  else
+	    fprintf (file, "\tli\t%s,%d\t\t# offset of ra\n", reg_names[12],
+		     cfun->machine->frame.ra_fp_offset);
+	}
+    }
+  mips_push_asm_switch (&mips_noat);
+  fprintf (file, "\tmove\t%s,%s\t\t# save current return address\n",
+	   reg_names[AT_REGNUM], reg_names[RETURN_ADDR_REGNUM]);
+  /* _mcount treats $2 as the static chain register.  */
+  if (cfun->static_chain_decl != NULL)
+    fprintf (file, "\tmove\t%s,%s\n", reg_names[2],
+	     reg_names[STATIC_CHAIN_REGNUM]);
+  if (!TARGET_NEWABI)
+    {
+      fprintf (file,
+	       "\t%s\t%s,%s,%d\t\t# _mcount pops 2 words from  stack\n",
+	       TARGET_64BIT ? "dsubu" : "subu",
+	       reg_names[STACK_POINTER_REGNUM],
+	       reg_names[STACK_POINTER_REGNUM],
+	       Pmode == DImode ? 16 : 8);
+    }
+  if (emit_small_ra_offset)
+    mips_push_asm_switch (&mips_noreorder);
+  if (TARGET_LONG_CALLS)
+    fprintf (file, "\tjalr\t%s\n", reg_names[3]);
+  else
+    fprintf (file, "\tjal\t_mcount\n");
+  if (emit_small_ra_offset)
+    {
+      fprintf (file, "\tori\t%s,%s,%d\t\t# offset of ra\n",
+	       reg_names[12], reg_names[0], cfun->machine->frame.ra_fp_offset);
+      mips_pop_asm_switch (&mips_noreorder);
+    }
+  mips_pop_asm_switch (&mips_noat);
+  /* _mcount treats $2 as the static chain register.  */
+  if (cfun->static_chain_decl != NULL)
+    fprintf (file, "\tmove\t%s,%s\n", reg_names[STATIC_CHAIN_REGNUM],
+	     reg_names[2]);
+}
 
 /* Initialize the GCC target structure.  */
 #undef TARGET_ASM_ALIGNED_HI_OP
Index: gcc/config/mips/mips.h
===================================================================
--- gcc/config/mips/mips.h	(revision 153502)
+++ gcc/config/mips/mips.h	(working copy)
@@ -2372,44 +2372,7 @@ typedef struct mips_args {
 /* Output assembler code to FILE to increment profiler label # LABELNO
    for profiling a function entry.  */
 
-#define FUNCTION_PROFILER(FILE, LABELNO)				\
-{									\
-  if (TARGET_MIPS16)							\
-    sorry ("mips16 function profiling");				\
-  if (TARGET_LONG_CALLS)						\
-    {									\
-      /*  For TARGET_LONG_CALLS use $3 for the address of _mcount.  */	\
-      if (Pmode == DImode)						\
-	fprintf (FILE, "\tdla\t%s,_mcount\n", reg_names[GP_REG_FIRST + 3]); \
-      else								\
-	fprintf (FILE, "\tla\t%s,_mcount\n", reg_names[GP_REG_FIRST + 3]); \
-    }									\
-  mips_push_asm_switch (&mips_noat);					\
-  fprintf (FILE, "\tmove\t%s,%s\t\t# save current return address\n",	\
-	   reg_names[AT_REGNUM], reg_names[RETURN_ADDR_REGNUM]);	\
-  /* _mcount treats $2 as the static chain register.  */		\
-  if (cfun->static_chain_decl != NULL)					\
-    fprintf (FILE, "\tmove\t%s,%s\n", reg_names[2],			\
-	     reg_names[STATIC_CHAIN_REGNUM]);				\
-  if (!TARGET_NEWABI)							\
-    {									\
-      fprintf (FILE,							\
-	       "\t%s\t%s,%s,%d\t\t# _mcount pops 2 words from  stack\n", \
-	       TARGET_64BIT ? "dsubu" : "subu",				\
-	       reg_names[STACK_POINTER_REGNUM],				\
-	       reg_names[STACK_POINTER_REGNUM],				\
-	       Pmode == DImode ? 16 : 8);				\
-    }									\
-  if (TARGET_LONG_CALLS)						\
-    fprintf (FILE, "\tjalr\t%s\n", reg_names[GP_REG_FIRST + 3]);	\
-  else									\
-    fprintf (FILE, "\tjal\t_mcount\n");					\
-  mips_pop_asm_switch (&mips_noat);					\
-  /* _mcount treats $2 as the static chain register.  */		\
-  if (cfun->static_chain_decl != NULL)					\
-    fprintf (FILE, "\tmove\t%s,%s\n", reg_names[STATIC_CHAIN_REGNUM],	\
-	     reg_names[2]);						\
-}
+#define FUNCTION_PROFILER(FILE, LABELNO) mips_function_profiler ((FILE))
 
 /* The profiler preserves all interesting registers, including $31.  */
 #define MIPS_SAVE_REG_FOR_PROFILING_P(REGNO) false

--------------010609000602030709030909--
