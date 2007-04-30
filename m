Return-Path: <linux-kernel-owner+w=401wt.eu-S1422954AbXD3ECU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422954AbXD3ECU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 00:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422926AbXD3ECU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 00:02:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422927AbXD3ECR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 00:02:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@lst.de>
X-Fcc: ~/Mail/utrace
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: utrace comments
In-Reply-To: Christoph Hellwig's message of  Monday, 27 November 2006 17:51:38 +0100 <20061127165138.GA2991@lst.de>
Emacs: the prosecution rests its case.
Message-Id: <20070430040213.BF9901801A4@magilla.sf.frob.com>
Date: Sun, 29 Apr 2007 21:02:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry I've taken so long to reply to your review comments.
I won't dwell on that, and just dive into the discussion.

> --- linux-2.6/include/asm-i386/thread_info.h.utrace-ptrace-compat
> +++ linux-2.6/include/asm-i386/thread_info.h
> @@ -135,13 +135,13 @@ static inline struct thread_info *curren
>  #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
>  #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
>  #define TIF_IRET		5	/* return with iret */
> -#define TIF_SYSCALL_EMU		6	/* syscall emulation active */
>  #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
>  #define TIF_SECCOMP		8	/* secure computing */
>  #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
>  #define TIF_MEMDIE		16
>  #define TIF_DEBUG		17	/* uses debug registers */
>  #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
> +#define TIF_FORCED_TF		19	/* true if TF in eflags artificially */
> 
> 	I think it would make a lot of sense if you simply reused the
> 	existing flag number instead of leaving a hole.

You mean renumber 7,8,9 down to 6,7,8?  I guess there's no reason not to
do that, I was just not changing values I didn't need to.  AFAIK the
only thing that matters about these value is the bits < 16 that there
and the bits >= 16 likewise, for _TIF_ALLWORK_MASK to work right.

> +#define utrace_lock(utrace)	spin_lock(&(utrace)->lock)
> +#define utrace_unlock(utrace)	spin_unlock(&(utrace)->lock)
> 
> 	Please don't introduce such obsfucation macros.

I removed them.

> +/***
> + *** These are the exported entry points for tracing engines to use.
> + ***/
> 
> 	This is not a standard comment format.  It should be:

Ok.  The intention was to clearly set off those declarations from others.
It appears the thing other linux/*.h files do for this is:

/**************************************************************************
 * These are the exported entry points for tracing engines to use.
 **************************************************************************/

> 	Please don't put such long comments in headerfiles.  They should be
> 	part of the kerneldoc comments near the actual function body so
> 	we can extract them and autogenerate real documentation for it.
> 	A big thanks for the huge amount of comments, btw - they're just
> 	in the wrong place ;-)

Ok.  The kerneldoc stuff is new and strange to me, and I've never
personally experienced its benefical features.  But I've read
Documentation/kernel-doc-nano-HOWTO.txt now and I will try to convert all
my documentary comments to that style.

>  	Please try consolidate all the compat code in a single #ifdef block,
> 	preferably at the end of the file.

I did it this way to put each compat_foo near foo so it makes sense in
context, and it's easy to remember to update it in parallel if you change
foo.  Is it really better to move them all to an undifferentiated cluster
at the end?

> 	Please don't do this kind of conditional mess.  It leads to really
> 	ugly code like this (later in the patch):
> 
> #ifdef ARCH_HAS_SINGLE_STEP
> 	if (! ARCH_HAS_SINGLE_STEP)
> #endif
> 		WARN_ON(flags & UTRACE_ACTION_SINGLESTEP);
> #ifdef ARCH_HAS_BLOCK_STEP
> 	if (! ARCH_HAS_BLOCK_STEP)
> #endif
> 		WARN_ON(flags & UTRACE_ACTION_BLOCKSTEP);
> 
> 	Instead make it a
> 
> 		arch_has_single_step()
> 
> 	which must be defined by every architecture as a boolean value, with
> 	fixes like that the code above will become a lot more readable:
> 
> 	WARN_ON(!arch_has_single_step() && (flags & UTRACE_ACTION_SINGLESTEP));
> 	WARN_ON(!arch_has_block_step() && (flags & UTRACE_ACTION_BLOCKSTEP));

I agree it's come out ugly.  The reason I complicated it was an attempt
to make the answer testable in #if when it's constant at compile time.
My thinking is there will be situations where you want to avoid building
in some useless dead code and just "if (0)" is not sufficient.  But
primarily I was thinking of avoiding building extra fancy code in lieu
of single-step on machines/configurations where single-step is always
available, and the current #if's don't help with that.  How about if an
asm-arch/tracehook.h either declares arch_has_single_step or else it
#define's one of two things and in a single place I'll add:

	#ifdef ARCH_ALWAYS_HAS_SINGLE_STEP
	#define arch_has_single_step()	1
	#elif defined ARCH_NEVER_HAS_SINGLE_STEP
	#define arch_has_single_step()	0
	#endif

> 	The coding style here is wrong.  The else should be on the line
> 	of the closing brace.  

I can ordinarily ignore syntax, but this is an abomination in the sight
of the Lord and always will be.  Fortunately, it's far from being 100%
consistently used in the kernel already.  People are welcome to change
the code after I submit it, but I just can't make myself write it that
way, sorry.

[wrt utrace_regset_copy*]
> 	This function is far too large to inline it.  Please move it out
> 	of line.

The reason these functions are inlines is that some of their arguments
are always constants, so they get inlined into not a whole lot more than
the inlined memcpy.  Having these interfaces makes it a whole lot easier
to write the machine regset code, which needs pretty simple code, but
with constant arithmetic that's easy to louse up doing it by hand.  As
real functions they would just be more code that always had some runtime
arithmetic and tests it didn't need.

> 	This doesn't follow kernel coding style at all, we always
> 	put the && or || operators at the end of the closing line.

I could swear I've been "corrected" in the opposite direction on this one.
It is not mentioned in Documentation/CodingStyle, and the existing kernel
code is far from consistent on it.  I really don't care which way it is,
but I'd like clear authoritative direction from Linus and Andrew before I
bother with it.

> 	if ((tsk->utrace_flags & UTRACE_EVENT_SIGNAL_ALL) &&
> 	    (tsk->utrace_flags & (UTRACE_ACTION_SINGLESTEP |
> 	                          UTRACE_ACTION_BLOCKSTEP)))
> 
> 	Also I'm not sure why you're doing this kind of test,
> 	as you could do a
> 
> 	if (current->utrace_flags & (UTRACE_EVENT_SIGNAL_ALL|
> 			UTRACE_ACTION_SINGLESTEP|UTRACE_ACTION_BLOCKSTEP))

No, that's not equivalent.  UTRACE_EVENT_SIGNAL_ALL is not just one bit,
but a mask of several bits.  

> +#ifdef CONFIG_PTRACE
> +	INIT_LIST_HEAD(&p->ptracees);
> +#endif
> 
> 	This should be hidden behing a ptrace_init_task macro
> 	that does nothing in the !CONFIG_PTRACE case

I've changed it that way.

> 	Please add a block comment at the top of the file noting the
> 	copyright/license status author and basic desription of the
> 	contents.

I've now done that for all the files I added.

> 	This is written more than messy.  when you use gotos anyway (as
> 	recommended for kernel code), use it throughout to make the
> 	normal path be straight and the error path using gotos, e.g.:

I will use more gotos.

> +#define REPORT(callback, ...) do { \
> +	u32 ret = (*rcu_dereference(engine->ops)->callback) \
> +		(engine, tsk, ##__VA_ARGS__); \
> +	action = update_action(tsk, utrace, engine, ret); \
> +	} while (0)
> 
> 	I don not think these kinds of macros are a very good idea.
> 	Just opencode the two lines of code instead of a single
> 	macro.

I don't agree that duplicating intricate boilerplate code is a good
idea.  I will see if I can formulate macros more similar to those common
in the kernel that don't increase error-prone manual duplication much.

> +// XXX copied from signal.c
[...]
> 	Copying and pasting this kind of stuff is a very bad idea.

I know.

> 	Just put a helper like the following into signal.c and use it from
> 	utrace.c:

I'd rather avoid the gratuitous call for some simple constants.  Instead,
I'd just move the macros to linux/signal.h and clean them up a little.
I hadn't done this just to separate misc cleanup from new stuff.  I'll
send a separate patch to do this, so once that's merged, utrace won't need
anything unclean here.

> 	A really huge NACK for putting #ifdef CONFIG_PTRACE into ptrace.c.
> 	The file should only be compile if CONFIG_PTRACE is set.
> 	sys_ptrace should become a cond_syscall, and ptrace_may_attach
> 	should move into a differnt file and get a more suitable name.

I changed it that way, except that ptrace_may_attach hasn't changed name.
I think it should change name, since it's really used more often for /proc
permissions than for ptrace.  But until the security_ptrace hook changes
name or is replaced with some cleaner hooks, the name makes sense.

> +int getrusage(struct task_struct *, int, struct rusage __user *);
> 
>  	Please never put prototypes like this into .c files.

I was copying existing practice for that function at the time, really just
to avoid comingling unrelated lint patches with my changes.  I've removed
the declaration now that it's in a header file.

> +#ifdef PTRACE_DEBUG
> +	printk("ptrace pid %ld => %p\n", pid, child);
> +#endif
> 
> 	Please don't do this kind of ifdef mess. just use pr_debug
> 	instead.

I changed it that way.

> +const struct utrace_regset_view utrace_ppc32_view = {
> +	.name = "ppc", .e_machine = EM_PPC,
> +	.regsets = ppc32_regsets,
> +	.n = sizeof ppc32_regsets / sizeof ppc32_regsets[0],
> +};
> +EXPORT_SYMBOL_GPL(utrace_ppc32_view);
> +#endif
> 
> 	Who would be using this from modular code?
> 	I see this is for all views, but I'd rather move the
> 	accessor out of line than exporting all them if we
> 	really have legitimate modular users.

utrace_native_view is expected to be the only user of the *_view symbols.
I inlined it because on single-arch platforms it's just a constant return
and I didn't want to add another useless call frame.  I admit this is undue
microoptimization.  Perhaps utrace_native_view should just be non-inlined
and exported.


Thanks,
Roland
