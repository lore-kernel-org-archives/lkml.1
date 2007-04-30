Return-Path: <linux-kernel-owner+w=401wt.eu-S1423183AbXD3JIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423183AbXD3JIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423182AbXD3JIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:08:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51750 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423173AbXD3JIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:08:43 -0400
Date: Mon, 30 Apr 2007 10:08:40 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: utrace comments
Message-ID: <20070430090840.GB31397@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430040213.BF9901801A4@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 09:02:13PM -0700, Roland McGrath wrote:
> I'm sorry I've taken so long to reply to your review comments.
> I won't dwell on that, and just dive into the discussion.
> 
> > --- linux-2.6/include/asm-i386/thread_info.h.utrace-ptrace-compat
> > +++ linux-2.6/include/asm-i386/thread_info.h
> > @@ -135,13 +135,13 @@ static inline struct thread_info *curren
> >  #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
> >  #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
> >  #define TIF_IRET		5	/* return with iret */
> > -#define TIF_SYSCALL_EMU		6	/* syscall emulation active */
> >  #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
> >  #define TIF_SECCOMP		8	/* secure computing */
> >  #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
> >  #define TIF_MEMDIE		16
> >  #define TIF_DEBUG		17	/* uses debug registers */
> >  #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
> > +#define TIF_FORCED_TF		19	/* true if TF in eflags artificially */
> > 
> > 	I think it would make a lot of sense if you simply reused the
> > 	existing flag number instead of leaving a hole.
> 
> You mean renumber 7,8,9 down to 6,7,8?  I guess there's no reason not to
> do that, I was just not changing values I didn't need to.  AFAIK the
> only thing that matters about these value is the bits < 16 that there
> and the bits >= 16 likewise, for _TIF_ALLWORK_MASK to work right.

No need to renumber.  You remove TIF_SYSCALL_EMU which is six,
so the newly added TIF_FORCED_TF could reuse that bit.

> > +/***
> > + *** These are the exported entry points for tracing engines to use.
> > + ***/
> > 
> > 	This is not a standard comment format.  It should be:
> 
> Ok.  The intention was to clearly set off those declarations from others.
> It appears the thing other linux/*.h files do for this is:
> 
> /**************************************************************************
>  * These are the exported entry points for tracing engines to use.
>  **************************************************************************/

Not really that much.  Prefered would be just a normal comment which
would stick out if the actual comments were kerneldoc in the source files.

> > 	Please don't put such long comments in headerfiles.  They should be
> > 	part of the kerneldoc comments near the actual function body so
> > 	we can extract them and autogenerate real documentation for it.
> > 	A big thanks for the huge amount of comments, btw - they're just
> > 	in the wrong place ;-)
> 
> Ok.  The kerneldoc stuff is new and strange to me, and I've never
> personally experienced its benefical features.  But I've read
> Documentation/kernel-doc-nano-HOWTO.txt now and I will try to convert all
> my documentary comments to that style.

Thanks.  If you need some help ping me or Randy.

> 
> >  	Please try consolidate all the compat code in a single #ifdef block,
> > 	preferably at the end of the file.
> 
> I did it this way to put each compat_foo near foo so it makes sense in
> context, and it's easy to remember to update it in parallel if you change
> foo.  Is it really better to move them all to an undifferentiated cluster
> at the end?

That's the normal approach.  If it's big enough it might even make
sense to give it a file of it's own to have the compat code totally
separate.  But IIRC there wasn't a whole lot of compat code in utrace.

> > 	Please don't do this kind of conditional mess.  It leads to really
> > 	ugly code like this (later in the patch):
> > 
> > #ifdef ARCH_HAS_SINGLE_STEP
> > 	if (! ARCH_HAS_SINGLE_STEP)
> > #endif
> > 		WARN_ON(flags & UTRACE_ACTION_SINGLESTEP);
> > #ifdef ARCH_HAS_BLOCK_STEP
> > 	if (! ARCH_HAS_BLOCK_STEP)
> > #endif
> > 		WARN_ON(flags & UTRACE_ACTION_BLOCKSTEP);
> > 
> > 	Instead make it a
> > 
> > 		arch_has_single_step()
> > 
> > 	which must be defined by every architecture as a boolean value, with
> > 	fixes like that the code above will become a lot more readable:
> > 
> > 	WARN_ON(!arch_has_single_step() && (flags & UTRACE_ACTION_SINGLESTEP));
> > 	WARN_ON(!arch_has_block_step() && (flags & UTRACE_ACTION_BLOCKSTEP));
> 
> I agree it's come out ugly.  The reason I complicated it was an attempt
> to make the answer testable in #if when it's constant at compile time.
> My thinking is there will be situations where you want to avoid building
> in some useless dead code and just "if (0)" is not sufficient.  But
> primarily I was thinking of avoiding building extra fancy code in lieu
> of single-step on machines/configurations where single-step is always
> available, and the current #if's don't help with that.  How about if an
> asm-arch/tracehook.h either declares arch_has_single_step or else it
> #define's one of two things and in a single place I'll add:
> 
> 	#ifdef ARCH_ALWAYS_HAS_SINGLE_STEP
> 	#define arch_has_single_step()	1
> 	#elif defined ARCH_NEVER_HAS_SINGLE_STEP
> 	#define arch_has_single_step()	0
> 	#endif

Current gcc (since 3.<something>) can optimize away code under if-branches
that are determinable at compile time, so having each architecture
define a (possible trivial) arch_has_single_step() should be fine.

Btw, is there a fundamental reason why an architecture would not support
single-stepping except for a transition period of porting, i.e. are there
real hardware limitation in any of our ports?

> > 	The coding style here is wrong .  The else should be on the line
> > 	of the closing brace.  
> 
> I can ordinarily ignore syntax, but this is an abomination in the sight
> of the Lord and always will be.  Fortunately, it's far from being 100%
> consistently used in the kernel already.  People are welcome to change
> the code after I submit it, but I just can't make myself write it that
> way, sorry.

It's used pretty consistant in core code not written by you, which
looks similarly horrible.  Please try to fit a consistant style.

> 
> [wrt utrace_regset_copy*]
> > 	This function is far too large to inline it.  Please move it out
> > 	of line.
> 
> The reason these functions are inlines is that some of their arguments
> are always constants, so they get inlined into not a whole lot more than
> the inlined memcpy.  Having these interfaces makes it a whole lot easier
> to write the machine regset code, which needs pretty simple code, but
> with constant arithmetic that's easy to louse up doing it by hand.  As
> real functions they would just be more code that always had some runtime
> arithmetic and tests it didn't need.

Needs comments in the code explaining it.

> > 	if ((tsk->utrace_flags & UTRACE_EVENT_SIGNAL_ALL) &&
> > 	    (tsk->utrace_flags & (UTRACE_ACTION_SINGLESTEP |
> > 	                          UTRACE_ACTION_BLOCKSTEP)))
> > 
> > 	Also I'm not sure why you're doing this kind of test,
> > 	as you could do a
> > 
> > 	if (current->utrace_flags & (UTRACE_EVENT_SIGNAL_ALL|
> > 			UTRACE_ACTION_SINGLESTEP|UTRACE_ACTION_BLOCKSTEP))
> 
> No, that's not equivalent.  UTRACE_EVENT_SIGNAL_ALL is not just one bit,
> but a mask of several bits.  

> > +#define REPORT(callback, ...) do { \
> > +	u32 ret = (*rcu_dereference(engine->ops)->callback) \
> > +		(engine, tsk, ##__VA_ARGS__); \
> > +	action = update_action(tsk, utrace, engine, ret); \
> > +	} while (0)
> > 
> > 	I don not think these kinds of macros are a very good idea.
> > 	Just opencode the two lines of code instead of a single
> > 	macro.
> 
> I don't agree that duplicating intricate boilerplate code is a good
> idea.  I will see if I can formulate macros more similar to those common
> in the kernel that don't increase error-prone manual duplication much.

It's just a few uses and expands to two lines of code, so avoiding
the macro probably is a good idea.

> > +const struct utrace_regset_view utrace_ppc32_view = {
> > +	.name = "ppc", .e_machine = EM_PPC,
> > +	.regsets = ppc32_regsets,
> > +	.n = sizeof ppc32_regsets / sizeof ppc32_regsets[0],
> > +};
> > +EXPORT_SYMBOL_GPL(utrace_ppc32_view);
> > +#endif
> > 
> > 	Who would be using this from modular code?
> > 	I see this is for all views, but I'd rather move the
> > 	accessor out of line than exporting all them if we
> > 	really have legitimate modular users.
> 
> utrace_native_view is expected to be the only user of the *_view symbols.
> I inlined it because on single-arch platforms it's just a constant return
> and I didn't want to add another useless call frame.  I admit this is undue
> microoptimization.  Perhaps utrace_native_view should just be non-inlined
> and exported.

Yeah, the latter probably makes sense.

