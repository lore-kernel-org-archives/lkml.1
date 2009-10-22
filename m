Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZJVLip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZJVLip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZJVLip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:38:45 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48188 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZJVLin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=m/VEnTdvT2HnF1dhd1C/pjEWJtwkTzKHMtGvOdBrQ8qpfFfACEtbiENCWCjbV1Kzyf
         6o4Zw7Zlr4kahH8nQJW6mrtEKFI6P1B8RNNzBK5hiLF4MTRWds1WnyYttI4ocoz68ZQE
         0nmP938lA9aZtf0+9dY3Sx4/cPUKO9l78VVfY=
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <1256145813.18347.3210.camel@gandalf.stny.rr.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>
	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>
	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>
	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>
	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>
	 <1256141540.18347.3118.camel@gandalf.stny.rr.com>
	 <4ADF38D5.9060100@caviumnetworks.com>
	 <1256143568.18347.3169.camel@gandalf.stny.rr.com>
	 <4ADF3FE0.5090104@caviumnetworks.com>
	 <1256145813.18347.3210.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Thu, 22 Oct 2009 19:38:36 +0800
Message-Id: <1256211516.3852.47.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-10-21 at 13:23 -0400, Steven Rostedt wrote:
> On Wed, 2009-10-21 at 10:07 -0700, David Daney wrote:
> 
> > I have not used -pg, so I don't know for sure, I think all it does is 
> > add the calls to _mcount.  Someone could investigate 
> > -fno-omit-frame-pointer, with that you may be able to use:
> 
> Note, -pg assumes -fno-omit-frame-pointer, since -fomit-frame-pointer
> and -pg are incompatible.

Ralf have told me -pg really works with -fomit-frame-pointer, although
the gcc tool tell us they are not incompatible when we use both of them
together, but when I remove -fno-omit-frame-pointer in
KBUILD_FLAGS(enabled by CONFIG_FRAME_POINTER), it definitely remove the
s8(fp) relative source code(Seems -fomit-frame-pionter is used by
default by gcc), the leaf function becomes this:

function:

80101144 <au1k_wait>:
80101144:       03e00821        move    at,ra
80101148:       0c04271c        jal     80109c70 <_mcount>

No more instruction,

and the non-leaf function becomes,

80126590 <copy_process>:
80126590:       27bdffa0        addiu   sp,sp,-96
80126594:       afbf005c        sw      ra,92(sp)
80126598:       afbe0058        sw      s8,88(sp)
8012659c:       afb70054        sw      s7,84(sp)
801265a0:       afb60050        sw      s6,80(sp)
801265a4:       afb5004c        sw      s5,76(sp)
801265a8:       afb40048        sw      s4,72(sp)
801265ac:       afb30044        sw      s3,68(sp)
801265b0:       afb20040        sw      s2,64(sp)
801265b4:       afb1003c        sw      s1,60(sp)
801265b8:       afb00038        sw      s0,56(sp)
801265bc:       03e00821        move    at,ra
801265c0:       0c04271c        jal     80109c70 <_mcount>

It may save about two instructions for us.
	
	sw	s8, offset(sp)
	move	s8, fp

and also, I have tried to just search "Save" instruction, if I find one,
that should be a non-leaf function, otherwise, it's leaf function, but I
can not prove no "Save" instruction before the leaf function's "move at,
ra", for example:

8010113c:       03e00008        jr      ra
80101140:       00020021        nop

80101144 <au1k_wait>:
80101144:       03e00821        move    at,ra
80101148:       0c04271c        jal     80109c70 <_mcount>

if there is "save" instruction at address 80101140, it will fail.
Although, I met not failure with several tries, but no prove on it! any
ABI protection for this? if YES, this should be a better solution, for
it may works without -fno-omit-frame-pointer and save several
instructions for us.

and BTW, -fomit-frame-pointer does help "a lot" for us to get the stack
address without any big load:

        sp = fp + (code & STACK_OFFSET_MASK);
        ra = *(unsigned long *)sp;

although we can calculate it via the parent_addr, I have got this in:

NESTED(ftrace_graph_caller, PT_SIZE, ra) 
        MCOUNT_SAVE_REGS

        PTR_LA  a0, PT_R1(sp)   /* arg1: &AT -> a0 */
        move    a1, ra          /* arg2: next ip, selfaddr */
        PTR_SUBU a1, MCOUNT_INSN_SIZE
        move    a2, fp          /* arg3: frame pointer */
        jal     prepare_ftrace_return
        nop

        MCOUNT_RESTORE_REGS
        RETURN_BACK
        END(ftrace_graph_caller)

so, parent_addr is the current sp + PT_R1:
	
	sp = sp - PT_SIZE (did in MCOUNT_SAVE_REGS)
	parent_addr = sp + PT_R1

so the fp can be calculated like this:

	fp = parent_addr - PT_R1 + PT_SIZE;

this will take use a little time to calculate it.

ooh, so,  both -fomit-frame-pointer and -fno-omit-frame-pointer work for
us, the left job is that: we need to prove them are really SAFE here.

> > 
> >     move    s8,sp
> > 
> > To identify function prologs, but it would still be ad hoc, as modern 
> > versions of GCC will reorder instructions in the prolog for better 
> > scheduling.
> 
> I'll have to search the ABI documentation about calling _mcount in MIPS.
> There are assumptions with _mcount that are made. It may very well be
> safe to assume that the move s8,sp will always be there before an mcount
> call.
> 

I have read the source code about _mcount in MIPS, no assumption for
using move s8,sp(which should be assumed in -fno-omit-frame-pointer),
that souce code in gcc for MIPS looks like this:

gcc/config/mips/mips.h:

#define FUNCTION_PROFILER(FILE, LABELNO)                   
{                                                                       
  if (TARGET_MIPS16)                                                    
    sorry ("mips16 function profiling");                                
  if (TARGET_LONG_CALLS)                                                
    {                                                                   
      /*  For TARGET_LONG_CALLS use $3 for the address of _mcount.  */  
      if (Pmode == DImode)                                              
        fprintf (FILE, "\tdla\t%s,_mcount\n", reg_names[GP_REG_FIRST +
3]); 
      else                                                              
        fprintf (FILE, "\tla\t%s,_mcount\n", reg_names[GP_REG_FIRST +
3]); 
    }                                                                   
  fprintf (FILE, "\t.set\tnoat\n");                                     
  fprintf (FILE, "\tmove\t%s,%s\t\t# save current return address\n",    
           reg_names[GP_REG_FIRST + 1], reg_names[GP_REG_FIRST + 31]);  
  /* _mcount treats $2 as the static chain register.  */                
  if (cfun->static_chain_decl != NULL)                                  
    fprintf (FILE, "\tmove\t%s,%s\n", reg_names[2],                     
             reg_names[STATIC_CHAIN_REGNUM]);                           
  if (!TARGET_NEWABI)                                                   
    {                                                                   
      fprintf (FILE,                                                    
               "\t%s\t%s,%s,%d\t\t# _mcount pops 2 words from  stack
\n", 
               TARGET_64BIT ? "dsubu" : "subu",                         
               reg_names[STACK_POINTER_REGNUM],                         
               reg_names[STACK_POINTER_REGNUM],                         
               Pmode == DImode ? 16 : 8);                               
    }                                                                   
  if (TARGET_LONG_CALLS)                                                
    fprintf (FILE, "\tjalr\t%s\n", reg_names[GP_REG_FIRST + 3]);        
  else                                                                  
    fprintf (FILE, "\tjal\t_mcount\n");                                 
  fprintf (FILE, "\t.set\tat\n");                                       
  /* _mcount treats $2 as the static chain register.  */                
  if (cfun->static_chain_decl != NULL)                                  
    fprintf (FILE, "\tmove\t%s,%s\n", reg_names[STATIC_CHAIN_REGNUM],   
             reg_names[2]);  
}

The above is a macro, I just removed the "\" for readable, BTW: I got
the -mloong-calls option there!
	
I have tried to hack the gcc source code, and made the ra is pushed into
the smallest address of stack, but it not always be 0(sp), which should
be defined in the relative ABIs, so, I giving up this way. and also, I
tried to save the stack address to ra(or at), but this will make the
leaf function not work, 'Cause it will not save the return address to
the stack, although we can try a trick to distinguish them(stack offset
ranges from 0 to PT_SIZE, but the return address is very big :-)). both
of them will made the implementation deviate from "original" and will
make things "awful".

ooh, I can imaging touching gcc is really not a good idea(Thanks to
Nicholas), so, go back to kernel space as Steven suggested, at last,
made probe_kernel_read() work with tracing_stop()/tracing_start()[Seems
these two functions are need for probe_kernel_read(), will explain it in
another reply to an existing E-mail].

(Here is the gcc part what I have touched, only for FUN, if you hate it,
ignore it.

commit 4c2860a48914ecaa3b69b6eca4721dcf944ce342
Author: Wu Zhangjin <wuzhangjin@gmail.com>
Date:   Tue Oct 20 00:49:37 2009 +0800

    profile: fix function graph tracer of kerenl for MIPS
    
    It's very hard to get the stack address of the return address(ra) in
    MIPS with the old profiling support(only the value of the return
address
    available), so, we need to try to transfer the address to it!
    
    TODO: a new option should be added for kernel own to activate this
    patch.
    
    Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

diff --git a/gcc/config/mips/mips.c b/gcc/config/mips/mips.c
index f153d13..239308d 100644
--- a/gcc/config/mips/mips.c
+++ b/gcc/config/mips/mips.c
@@ -407,6 +407,9 @@ int num_source_filenames;
    written anything yet.  */
 const char *current_function_file = "";
 
+/* the offset of the ra register's stack address */
+int ra_offset_from_sp = -1;
+
 /* A label counter used by PUT_SDB_BLOCK_START and PUT_SDB_BLOCK_END.
*/
 int sdb_label_count;
 
@@ -8898,10 +8901,12 @@ mips_for_each_saved_reg (HOST_WIDE_INT
sp_offset, mips_save_restore_fn fn)
      need a nop in the epilogue if at least one register is reloaded in
      addition to return address.  */
   offset = cfun->machine->frame.gp_sp_offset - sp_offset;
-  for (regno = GP_REG_LAST; regno >= GP_REG_FIRST; regno--)
+  for (regno = GP_REG_FIRST; regno <= GP_REG_LAST; regno++)
     if (BITSET_P (cfun->machine->frame.mask, regno - GP_REG_FIRST))
       {
        mips_save_restore_reg (word_mode, regno, offset, fn);
+       if (crtl->profile)
+         ra_offset_from_sp = (regno == GP_REG_LAST) ? (int)offset : -1;
        offset -= UNITS_PER_WORD;
       }
 
diff --git a/gcc/config/mips/mips.h b/gcc/config/mips/mips.h
index c2533c4..f73bcf2 100644
--- a/gcc/config/mips/mips.h
+++ b/gcc/config/mips/mips.h
@@ -2315,6 +2315,9 @@ typedef struct mips_args {
        fprintf (FILE, "\tla\t%s,_mcount\n", reg_names[GP_REG_FIRST +
3]); \
     }
\
   fprintf (FILE, "\t.set\tnoat\n");
\
+  if (ra_offset_from_sp != -1)
\
+    fprintf (FILE, "\tlui\t%s,%d\t\t\n",
\
+             reg_names[GP_REG_FIRST + 31], ra_offset_from_sp);
\
   fprintf (FILE, "\tmove\t%s,%s\t\t# save current return address\n",
\
           reg_names[GP_REG_FIRST + 1], reg_names[GP_REG_FIRST + 31]);
\
   /* _mcount treats $2 as the static chain register.  */
\
@@ -3437,6 +3440,7 @@ extern const struct mips_cpu_info *mips_tune_info;
 extern const struct mips_rtx_cost_data *mips_cost;
 extern bool mips_base_mips16;
 extern enum mips_code_readable_setting mips_code_readable;
+extern int ra_offset_from_sp;
 #endif
 
 /* Enable querying of DFA units.  */
)

Regards,
	Wu Zhangjin

