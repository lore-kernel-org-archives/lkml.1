Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407Ab0BZQuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:50:08 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:27945 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965360Ab0BZQuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:50:05 -0500
X-Spam-Processed: digidescorp.com, Fri, 26 Feb 2010 10:50:04 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16730ac33d=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] microblaze: Support FRAME_POINTER for better backtrace
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
In-Reply-To: <4B878106.1090007@monstr.eu>
References: <1267128809-22749-1-git-send-email-steve@digidescorp.com>
	 <4B878106.1090007@monstr.eu>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Fri, 26 Feb 2010 10:49:58 -0600
Message-Id: <1267202998.3124.75.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

On Fri, 2010-02-26 at 09:06 +0100, Michal Simek wrote:

> Firstly I was surprise that you create any frame pointer solution but
> 1. It is not frame pointer because Microblaze not use it

Can you explain this in different words? I'm not following you. 
The code compiles differently in these two cases:

  ifdef CONFIG_FRAME_POINTER
  KBUILD_CFLAGS   += -fno-omit-frame-pointer -fno-optimize-sibling-calls
  else
  KBUILD_CFLAGS   += -fomit-frame-pointer
  endif

Empirically speaking, the former causes the compiler to use r19 to hold
the frame pointer. The latter allows the compiler to use r19 for other
purposes. 

> 2. it is just one optimization which could help but IMHO not. Your patch 
> expects that every stack frame size has 7/8 (doesn't matter right now) 
> items but that's not correct expectation. (Do objdump from vmlinux and 
> look at cpu_idle, prom_add_property and others) - that's why I think 
> that your patch won't work.

The patch expects only that frames involved in a backtrace are _at
least_ 8 words deep and that the frame pointer is always the 8th word of
the frame (index 7).

In my build, cpu_idle() begins like this:

 4b8:   3021ffd8        addik   r1, r1, -40
 4bc:   fa61001c        swi     r19, r1, 28
 4c0:   f9e10000        swi     r15, r1, 0

...which is a frame of 40 bytes, and a frame pointer stored 7 words into
the frame. prom_add_property() has a frame of 48 bytes and a frame
pointer stored 7 words in. 

Now, disable_hlt() has a runt frame of only 8 bytes when compiled with
-fno-omit-frame-pointer. But it is a leaf function and should never show
up in a backtrace, at least in a noMMU kernel. For MMU I suppose it's
possible for a leaf function to oops. I don't know the implications of
that.

Although the examples you cite don't prove your point, in looking more
closely, I see that there _are_ non-leaf functions where the frame
pointer is being placed elsewhere, for example do_one_initcall():

20000064:       3021ffc0        addik   r1, r1, -64
20000068:       fa61002c        swi     r19, r1, 44

This of course is a killer. I wonder if this is something that could be
changed in the Microblaze gcc someday.

> 3. The next question is, if we can expect that every function record has 
> at least 7/8 items. If yes than look at my function below.
> 4. One more thing is that function still use kernel_text_address() which 
> is silly because we are still not sure if the address there is correct 
> or not. It is just checking and if we are using, it is just mean that 
> there is any expectation which is not correct.

It may be that the function can be improved further; that's beyond the
scope of what I was trying to accomplish.

> > ---
> > diff -uprN a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
> > --- a/arch/microblaze/Kconfig.debug	2010-02-25 13:52:30.000000000 -0600
> > +++ b/arch/microblaze/Kconfig.debug	2010-02-25 13:52:49.000000000 -0600
> > @@ -26,4 +26,11 @@ config DEBUG_BOOTMEM
> >  	depends on DEBUG_KERNEL
> >  	bool "Debug BOOTMEM initialization"
> >  
> > +config FRAME_POINTER
> > +	bool "Use frame pointers"
> > +	default n
> > +	help
> > +	  If you say N here, the resulting kernel will be slightly smaller and
> > +	  faster. However, stack dumps will be much harder to interpret.
> > +
> 
> depends on !MMU
> 
> >  endmenu
> > diff -uprN a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
> > --- a/arch/microblaze/kernel/traps.c	2010-02-25 13:50:00.000000000 -0600
> > +++ b/arch/microblaze/kernel/traps.c	2010-02-25 13:51:11.000000000 -0600
> > @@ -8,6 +8,7 @@
> >   * for more details.
> >   */
> >  
> > +#include <generated/autoconf.h>
> 
> why? I don't think that this is necessary.

Otherwise CONFIG_FRAME_POINTER is always undefined.

> 
> >  #include <linux/kernel.h>
> >  #include <linux/kallsyms.h>
> >  #include <linux/module.h>
> > @@ -44,7 +45,7 @@ void show_trace(struct task_struct *task
> >  	printk(KERN_NOTICE "\n");
> >  #endif
> >  	while (!kstack_end(stack)) {
> > -		addr = *stack++;
> > +		addr = *stack;
> >  		/*
> >  		 * If the address is either in the text segment of the
> >  		 * kernel, or in the region which contains vmalloc'ed
> > @@ -55,6 +56,13 @@ void show_trace(struct task_struct *task
> >  		 */
> >  		if (kernel_text_address(addr))
> >  			print_ip_sym(addr);
> > +
> > +#if defined(CONFIG_FRAME_POINTER)
> > +		/* Fetch the caller's frame pointer */
> > +		stack = (unsigned long *) stack[7];
> 
> If is calculation correct then some comments, why you use number 7, will 
> be necessary.
> 
> > +#else
> > +		stack++;
> > +#endif
> >  	}
> >  	printk(KERN_NOTICE "\n");
> >  
> > 
> 
> Look at this code which should be better than yours.
> 
>    		if (kernel_text_address(addr)) {
>    			print_ip_sym(addr);
> 			/* Fetch the caller's frame pointer */
> 			stack = (unsigned long *) stack[7];
> 		}

There would need to be an 'else' here. Also, once the code goes off the
frame pointer rail, it should stay off.

> 		stack++;
> 

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



