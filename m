Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbZE2PHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbZE2PHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760211AbZE2PHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:07:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760296AbZE2PHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:07:19 -0400
Date: Fri, 29 May 2009 11:07:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Wu Zhangjin <wuzhangjin@gmail.com>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v1 2/5] mips dynamic function tracer support
In-Reply-To: <1243579000.12679.24.camel@falcon>
Message-ID: <alpine.DEB.2.00.0905291100110.31247@gandalf.stny.rr.com>
References: <cover.1243543471.git.wuzj@lemote.com>  <de2cff602f0b0251ea1878ff83e059437973b6fd.1243543471.git.wuzj@lemote.com>  <alpine.DEB.2.00.0905282116290.11238@gandalf.stny.rr.com> <1243579000.12679.24.camel@falcon>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 May 2009, Wu Zhangjin wrote:
> On Thu, 2009-05-28 at 21:24 -0400, Steven Rostedt wrote:
> > On Fri, 29 May 2009, wuzhangjin@gmail.com wrote:
> > > From: Wu Zhangjin <wuzj@lemote.com>
> > 
> > Hmm, this is basically exactly the same as x86's version. I wounder if we 
> > should make a helper function in generic code to let archs use it. We can 
> > put the do_ftrace_mod_code into kernel/trace/ftrace.c and have weak 
> > functions for the ftrace_mod_code. If the arch needs this to handle NMIs, 
> > then it can use it. This code was tricky to write, and I would hate to 
> > have it duplicated in every arch.
> > 
> 
> so, when will you put do_ftrace_mod_code into kernel/trace/ftrace.c? 
> i just checked the powerpc version, seems something different, so, we
> should handle it carefully and tune the relative arch-dependent parts? 

I did not cover NMIs for PowerPC. I probably should. I'll let this go in 
first and then we can think about how to consolidate the archs after we 
see what is similar.

> 
> > > +
> > > +static unsigned char *ftrace_nop_replace(void)
> > > +{
> > > +    return (unsigned char *) &ftrace_nop;
> > > +}
> > > +
> > > +static int
> > > +ftrace_modify_code(unsigned long ip, unsigned char *old_code,
> > > +		   unsigned char *new_code)
> > > +{
> > > +    unsigned char replaced[MCOUNT_INSN_SIZE];
> > > +
> > > +    /*
> > > +     * Note: Due to modules and __init, code can
> > > +     *  disappear and change, we need to protect against faulting
> > > +     *  as well as code changing. We do this by using the
> > > +     *  probe_kernel_* functions.
> > 
> > hehe, this is an old comment. We don't touch __init sections anymore. I 
> > need to remove it from the x86 file.
> > 
> 
> Removed, this is the same in powerpc version.

That's because I wrote the PPC version with the old code as well. I just 
waited to post it. But I never updated the comments there either. I'll 
have to write a clean up patch. But no need to copy an incorrect comment 
again ;-)

> 
> > > +     *
> > > +     * No real locking needed, this code is run through
> > > +     * kstop_machine, or before SMP starts.
> > > +     */
> > > +
> > > +    /* read the text we want to modify */
> > > +    if (probe_kernel_read(replaced, (void *) ip, MCOUNT_INSN_SIZE))
> > > +		return -EFAULT;
> > > +
> > > +    /* Make sure it is what we expect it to be */
> > > +    if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
> > > +		return -EINVAL;
> > > +
> > > +    /* replace the text with the new text */
> > > +    if (do_ftrace_mod_code(ip, new_code))
> > > +		return -EPERM;
> > > +
> > > +    return 0;
> > > +}
> > > +
> > > +int ftrace_make_nop(struct module *mod,
> > > +		    struct dyn_ftrace *rec, unsigned long addr)
> > > +{
> > > +    unsigned char *new, *old;
> > > +
> > > +    old = ftrace_call_replace(JAL, addr);
> > > +    new = ftrace_nop_replace();
> > > +
> > > +    return ftrace_modify_code(rec->ip, old, new);
> > > +}
> > > +
> > > +int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
> > > +{
> > > +    unsigned char *new, *old;
> > > +
> > > +    old = ftrace_nop_replace();
> > > +    new = ftrace_call_replace(JAL, addr);
> > > +
> > > +    return ftrace_modify_code(rec->ip, old, new);
> > > +}
> > > +
> > > +int ftrace_update_ftrace_func(ftrace_func_t func)
> > > +{
> > > +    unsigned long ip = (unsigned long) (&ftrace_call);
> > > +    unsigned char old[MCOUNT_INSN_SIZE], *new;
> > > +    int ret;
> > > +
> > > +    memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
> > > +    new = ftrace_call_replace(JAL, (unsigned long) func);
> > > +    ret = ftrace_modify_code(ip, old, new);
> > > +
> > > +    return ret;
> > > +}
> > > +
> > > +int __init ftrace_dyn_arch_init(void *data)
> > > +{
> > > +    /* The return code is retured via data */
> > > +    *(unsigned long *) data = 0;
> > 
> > egad, I need to clean that up too. I should return the true error code 
> > with ret. That is legacy from the first version of the dynamic ftrace 
> > code.
> 
> > This review is showing all the flaws of my own work ;-)
> > 
> 
> Yeap, most of it is copied from your original x86 version.
> 
> there are really lots of duplications among different arch-specific
> versions, need to cleanup carefully, and should we write something like
> a helper document for people developing arch-specific version?

We could, but so far it seems that pretty much every arch that has 
ported ftrace did fine with just looking at the code. I tried to keep the 
comments in x86 good enough for other arch maintainers to understand what 
was going on.

Probably after mips is ported, I'll do some clean ups to consolidat the 
archs and fix some design flaws. I'll need to get Acked-by from the 
maintainer of each arch I touch.

> 
> > > +
> > > +    return 0;
> > > +}
> > > +#endif				/* CONFIG_DYNAMIC_FTRACE */
> > > diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
> > > index 268724e..ce8a0ba 100644
> > > --- a/arch/mips/kernel/mcount.S
> > > +++ b/arch/mips/kernel/mcount.S
> > > @@ -67,6 +67,35 @@
> > >  	move ra, $1
> > >  	.endm
> > >  
> > > +#ifdef CONFIG_DYNAMIC_FTRACE
> > > +
> > > +LEAF(_mcount)
> > > +	RESTORE_SP_FOR_32BIT
> > > + 	RETURN_BACK
> > > + 	END(_mcount)
> > > +
> > > +NESTED(ftrace_caller, PT_SIZE, ra)
> > > +	RESTORE_SP_FOR_32BIT
> > > +	lw	t0, function_trace_stop
> > > +	bnez	t0, ftrace_stub
> > > +	nop
> > > +
> > > +	MCOUNT_SAVE_REGS
> > > +
> > > +	MCOUNT_SET_ARGS
> > > +	.globl ftrace_call
> > > +ftrace_call:
> > > +	jal	ftrace_stub
> > > +	nop
> > > +
> > > +	MCOUNT_RESTORE_REGS
> > > +	.globl ftrace_stub
> > > +ftrace_stub:
> > > +	RETURN_BACK
> > > +	END(ftrace_caller)
> > > +
> > > +#else	/* ! CONFIG_DYNAMIC_FTRACE */
> > > +
> > >  NESTED(_mcount, PT_SIZE, ra)
> > >  	RESTORE_SP_FOR_32BIT
> > >  	PTR_L	t0, function_trace_stop
> > > @@ -94,5 +123,7 @@ ftrace_stub:
> > >  	RETURN_BACK
> > >  	END(_mcount)
> > >  
> > > +#endif	/* ! CONFIG_DYNAMIC_FTRACE */
> > > +
> > >  	.set at
> > >  	.set reorder
> > > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > > index 5c4b7a4..548d575 100644
> > > --- a/scripts/Makefile.build
> > > +++ b/scripts/Makefile.build
> > > @@ -207,6 +207,7 @@ endif
> > >  
> > >  ifdef CONFIG_FTRACE_MCOUNT_RECORD
> > >  cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> > > +	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
> > >  	"$(if $(CONFIG_64BIT),64,32)" \
> > >  	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> > >  	"$(if $(part-of-module),1,0)" "$(@)";
> > 
> > This big/little endian addition, I would like in its own patch.
> > 
> 
> okay, will split it out later.

Thanks.

> 
> > > diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> > > index 409596e..e963948 100755
> > > --- a/scripts/recordmcount.pl
> > > +++ b/scripts/recordmcount.pl
> > > @@ -100,13 +100,13 @@ $P =~ s@.*/@@g;
> > >  
> > >  my $V = '0.1';
> > >  
> > > -if ($#ARGV < 7) {
> > > -	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
> > > +if ($#ARGV < 8) {
> > > +	print "usage: $P arch endian bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
> > >  	print "version: $V\n";
> > >  	exit(1);
> > >  }
> > >  
> > > -my ($arch, $bits, $objdump, $objcopy, $cc,
> > > +my ($arch, $endian, $bits, $objdump, $objcopy, $cc,
> > >      $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
> > >  
> > >  # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
> > > @@ -213,6 +213,26 @@ if ($arch eq "x86_64") {
> > >      if ($is_module eq "0") {
> > >          $cc .= " -mconstant-gp";
> > >      }
> > > +
> > > +} elsif ($arch eq "mips") {
> > > +	$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
> > > +	$objdump .= " -Melf-trad".$endian."mips ";
> > > +
> > > +	if ($endian eq "big") {
> > > +		$endian = " -EB ";
> > > +		$ld .= " -melf".$bits."btsmip";
> > > +	} else {
> > > +		$endian = " -EL ";
> > > +		$ld .= " -melf".$bits."ltsmip";
> > > +	}
> > > +
> > > +	$cc .= " -mno-abicalls -fno-pic -mabi=" . $bits . $endian;
> > > +    $ld .= $endian;
> > > +
> > > +    if ($bits == 64) {
> > > +		$type = ".dword";
> > > +    }
> > 
> > The mips addition to the recordmcount.pl is OK to keep with this patch.
> > 
> > > +
> > >  } else {
> > >      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
> > >  }
> > > @@ -441,12 +461,12 @@ if ($#converts >= 0) {
> > >      #
> > >      # Step 5: set up each local function as a global
> > >      #
> > > -    `$objcopy $globallist $inputfile $globalobj`;
> > > +    `$objcopy $globallist $inputfile $globalobj 2>&1 >/dev/null`;
> > 
> > Are these spitting out errors?
> > 
> 
> no errors, but some warnings.
> 
> seems some files not have _mcount(ooh, I did this patch about two months
> ago, so not remember the _real_ reason now), so there will some
> complaint about "No such file ...", this fix just make it not complain
> again.


There's a part in the script that exits early if no mcount callers were 
found. There might be an error here. I prefer not to hide warnings because 
we may be hiding bugs.

-- Steve

