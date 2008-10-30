Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYJ3U7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYJ3U7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYJ3U67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:58:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40120 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYJ3U66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:58:58 -0400
Date: Thu, 30 Oct 2008 16:58:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, srostedt@redhat.com
Subject: Re: [PATCH 1/2] ftrace: nmi safe code modification
In-Reply-To: <20081030133228.824e3f69.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810301645100.21031@gandalf.stny.rr.com>
References: <20081030200831.467420488@goodmis.org> <20081030201127.820600693@goodmis.org> <20081030133228.824e3f69.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Andrew Morton wrote:
> 
> > +#ifndef __ASSEMBLY__
> > +#define ftrace_nmi_enter()	do { } while (0)
> > +#define ftrace_nmi_exit()	do { } while (0)
> > +#endif
> > ...
> > +#ifndef __ASSEMBLY__
> > +#define ftrace_nmi_enter()	do { } while (0)
> > +#define ftrace_nmi_exit()	do { } while (0)
> > +#endif
> 
> These could all be written in C.  If there's a reson to write them in
> cpp then the `#ifndef __ASSEMBLY__' isn't really needed.

I could do the C macro, and you are right, I did not need the __ASSEMBLY__ 
part. I guess that was me just being over-protective :-/

Which would you prefer?  Changing to C or removing the __ASSEMBLY__?

> 
> > +#endif
> > +
> >  #ifdef CONFIG_MCOUNT
> >  #define MCOUNT_ADDR		((long)(_mcount))
> >  #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
> > Index: linux-tip.git/arch/x86/include/asm/ftrace.h
> > ===================================================================
> > --- linux-tip.git.orig/arch/x86/include/asm/ftrace.h	2008-10-30 10:26:28.000000000 -0400
> > +++ linux-tip.git/arch/x86/include/asm/ftrace.h	2008-10-30 13:16:22.000000000 -0400
> > @@ -17,6 +17,21 @@ static inline unsigned long ftrace_call_
> >  	 */
> >  	return addr - 1;
> >  }
> > +
> > +#ifdef CONFIG_DYNAMIC_FTRACE
> > +extern void ftrace_nmi_enter(void);
> > +extern void ftrace_nmi_exit(void);
> > +#else
> > +#define ftrace_nmi_enter()	do { } while (0)
> > +#define ftrace_nmi_exit()	do { } while (0)
> 
> Either this one misses the `#ifndef __ASSEMBLY__' ...
> 
> > +#endif
> > +#endif
> > +
> > +#else /* CONFIG_FUNCTION_TRACER */
> > +
> > +#ifndef __ASSEMBLY__
> > +#define ftrace_nmi_enter()	do { } while (0)
> > +#define ftrace_nmi_exit()	do { } while (0)
> >  #endif
> 
> or this one didn't need it.

Wrong in both cases (If we ignore the fact that MACROS do not need the 
__ASSEMBLY__) ;-)

Notice the two #endif in a row? Here's the full code:

#ifdef CONFIG_FUNCTION_TRACER
#define MCOUNT_ADDR             ((long)(mcount))
#define MCOUNT_INSN_SIZE        5 /* sizeof mcount call */

#ifndef __ASSEMBLY__
extern void mcount(void);

static inline unsigned long ftrace_call_adjust(unsigned long addr)
{
        /*
         * call mcount is "e8 <4 byte offset>"
         * The addr points to the 4 byte offset and the caller of this
         * function wants the pointer to e8. Simply subtract one.
         */
        return addr - 1;
}

#ifdef CONFIG_DYNAMIC_FTRACE
extern void ftrace_nmi_enter(void);
extern void ftrace_nmi_exit(void);
#else
#define ftrace_nmi_enter()      do { } while (0)
#define ftrace_nmi_exit()       do { } while (0)
#endif
#endif

#else /* CONFIG_FUNCTION_TRACER */

#ifndef __ASSEMBLY__
#define ftrace_nmi_enter()      do { } while (0)
#define ftrace_nmi_exit()       do { } while (0)
#endif

#endif /* CONFIG_FUNCTION_TRACER */


I guess I could add a comment /* __ASSEMBLY__ */ on that second endif.

> 
> >  
> >  #endif /* CONFIG_FUNCTION_TRACER */
> > Index: linux-tip.git/arch/x86/kernel/ftrace.c
> > ===================================================================
> > --- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-10-30 10:27:07.000000000 -0400
> > +++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-10-30 16:06:42.000000000 -0400
> > @@ -56,6 +56,111 @@ unsigned char *ftrace_call_replace(unsig
> >  	return calc.code;
> >  }
> >  
> > +/*
> > + * Modifying code must take extra care. On an SMP machine, if
> > + * the code being modified is also being executed on another CPU
> > + * that CPU will have undefined results and possibly take a GPF.
> > + * We use kstop_machine to stop other CPUS from exectuing code.
> > + * But this does not stop NMIs from happening. We still need
> > + * to protect against that. We separate out the modification of
> > + * the code to take care of this.
> > + *
> > + * Two buffers are added: An IP buffer and a "code" buffer.
> > + *
> > + * 1) Put in the instruction pointer into the IP buffer
> 
> s/in //

OK.

> 
> > + *    and the new code into the "code" buffer.
> > + * 2) Set a flag that says we are modifying code
> > + * 3) Wait for any running NMIs to finish.
> > + * 4) Write the code
> > + * 5) clear the flag.
> > + * 6) Wait for any running NMIs to finish.
> > + *
> > + * If an NMI is executed, the first thing it does is to call
> > + * "ftrace_nmi_enter". This will check if the flag is set to write
> > + * and if it is, it will write what is in the IP and "code" buffers.
> > + *
> > + * The trick is, it does not matter if everyone is writing the same
> > + * content to the code location. Also, if a CPU is executing code
> > + * it is OK to write to that code location if the contents being written
> > + * are the same as what exists.
> > + */
> > +
> > +static atomic_t in_nmi;
> 
> Should formally have an ATONIC_INIT.  If we're going to formalise the
> "all zeroes is OK for atomic_t's" rule then we can leave this as-is.

This is a bad habit of mine :-/  I would like to formalize the "all zeroes 
is OK for atomic_t's" rule, but I'm not in that position to do so.

> 
> > +static int mod_code_status;
> > +static int mod_code_write;
> > +static void *mod_code_ip;
> > +static void *mod_code_newcode;
> 
> Some comments decribing the global state would be nice.

Hmm, I thought I commented enough about this in the above comments. But
I guess it would not hurt to add more.

> 
> > +static void ftrace_mod_code(void)
> > +{
> > +	/*
> > +	 * Yes, more than one CPU process can be writing to mod_code_status.
> > +	 *    (and the code itself)
> > +	 * But if one were to fail, then they all should, and if one were
> > +	 * to succeed, then they all should.
> > +	 */
> > +	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
> > +					     MCOUNT_INSN_SIZE);
> > +
> > +}
> > +
> > +void ftrace_nmi_enter(void)
> > +{
> > +	atomic_inc(&in_nmi);
> > +	/* Must have in_nmi seen before reading write flag */
> > +	smp_mb();
> > +	if (mod_code_write)
> > +		ftrace_mod_code();
> > +}
> > +
> > +void ftrace_nmi_exit(void)
> > +{
> > +	/* Finish all executions before clearing in_nmi */
> > +	smp_wmb();
> > +	atomic_dec(&in_nmi);
> > +}
> > +
> > +static void wait_for_nmi(void)
> > +{
> > +	while (atomic_read(&in_nmi))
> > +		cpu_relax();
> > +}
> > +
> > +static int
> > +do_ftrace_mod_code(unsigned long ip, void *new_code)
> > +{
> > +	mod_code_ip = (void *)ip;
> > +	mod_code_newcode = new_code;
> > +
> > +	/* The buffers need to be visible before we let NMIs write them */
> > +	smp_wmb();
> > +
> > +	mod_code_write = 1;
> > +
> > +	/* Make sure write bit is visible before we wait on NMIs */
> > +	smp_mb();
> > +
> > +	wait_for_nmi();
> > +
> > +	/* Make sure all running NMIs have finished before we write the code */
> > +	smp_mb();
> > +
> > +	ftrace_mod_code();
> > +
> > +	/* Make sure the write happens before clearing the bit */
> > +	smp_wmb();
> > +
> > +	mod_code_write = 0;
> > +
> > +	/* make sure NMIs see the cleared bit */
> > +	smp_mb();
> > +
> > +	wait_for_nmi();
> > +
> > +	return mod_code_status;
> > +}
> 
> I guess the weakness here is that the code will only allow a single
> contiguous hunk of text to be modified.  One could envisage situations
> where two or more separate areas of memory need to be modified
> atomically/together.
> 
> I guess we can cross that bridge when we fall off it.

Well the current code (luckily) does not need that. As Ingo has stated,
the simpler this code is the better. There's just too much that can
go wrong if this code is defective.

> 
> > --- linux-tip.git.orig/include/linux/hardirq.h	2008-10-30 10:27:07.000000000 -0400
> > +++ linux-tip.git/include/linux/hardirq.h	2008-10-30 10:27:09.000000000 -0400
> > @@ -5,6 +5,7 @@
> >  #include <linux/smp_lock.h>
> >  #include <linux/lockdep.h>
> >  #include <asm/hardirq.h>
> > +#include <asm/ftrace.h>
> >  #include <asm/system.h>
> >  
> >  /*
> > @@ -161,7 +162,17 @@ extern void irq_enter(void);
> >   */
> >  extern void irq_exit(void);
> >  
> > -#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
> > -#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
> > +#define nmi_enter()				\
> > +	do {					\
> > +		ftrace_nmi_enter();		\
> > +		lockdep_off();			\
> > +		__irq_enter();			\
> > +	} while (0)
> > +#define nmi_exit()				\
> > +	do {					\
> > +		__irq_exit();			\
> > +		lockdep_on();			\
> > +		ftrace_nmi_exit();		\
> > +	} while (0)
> >  
> 
> <wonders if these needed to be written in cpp>

A clean up patch can follow this. I would not do it here, because it 
follows the style of the irq_enter and irq_exit macros just above this 
code.

I do not see why this could not be converted to a static inline, but
that should be a separate patch that udpates both this and the 
irq_enter/exit macros together.

-- Steve

