Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbZEBV7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbZEBV7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 17:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZEBV7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 17:59:24 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37708 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZEBV7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 17:59:23 -0400
Date: Sun, 3 May 2009 00:01:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>
Subject: Re: [PATCH v2 0/6] macros for section name cleanup
Message-ID: <20090502220132.GA4130@uranus.ravnborg.org>
References: <1241121253-32341-1-git-send-email-tabbott@mit.edu> <20090501213118.GA28126@uranus.ravnborg.org> <alpine.DEB.1.10.0905011916530.10966@vinegar-pot.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905011916530.10966@vinegar-pot.mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 08:48:53PM -0400, Tim Abbott wrote:
> On Fri, 1 May 2009, Sam Ravnborg wrote:
> 
> > This is the way I want to go where we have more complete
> > definitions in the shared file and we try to keep the arch
> > linker scripts to the arch specifc stuff.
> 
> I like the general look of this.  Indeed, I was planning to work on 
> something like this as a follow-on to the linker script cleanup work I've 
> done so far.

Keep in mind that my primary goal here is to clean up the linker scripts.
Support for -ffunction-sections is only a spin-off of that.
This is why I try to take a broader look at it.

> 
> Some comments on the details are below.
> 
> > +#define PAGE_ALIGNED_DATA(page_align)                                \
> > +     . = ALIGN((page_align));                                        \
> > +     *(.data.page_aligned)
> 
> Why does this need an argument?  You should be able to just align to 
> PAGE_SIZE.
Only a few archs supports .data.page_aligned so those that does not
pass a 0 as alignmnet thus they do not waste any memory.

> 
> Also, I'm not sure what you're trying to do with the double parentheses 
> here (it also appears inconsistently in several other places in this 
> patch).
Old habbit - dropped now.

> 
> > +/* use 0 as page_align if page_aligned data is not used */ 
> > +#define RW_DATA(page_align, readmostly_align, cache_align)           \
> > +     . = ALIGN(PAGE_SIZE);                                           \
> > +     .data : AT(ADDR(.data) - LOAD_OFFSET) {                         \
> > +             DATA_DATA                                               \
> > +             CONSTRUCTORS                                            \
> > +             NOSAVE_DATA                                             \
> > +             PAGE_ALIGNED_DATA(page_align)                           \
> > +             READMOSTLY_DATA((readmostly_align))                     \
> > +             CACHELINE_ALIGNED_DATA((cache_align))                   \
> > +     }
> 
> I think there are several architectures that have some other stuff in 
> their .data output section (e.g. powerpc, frv, ia64), so we won't be able 
> to use this on all architectures.
We have at least two situations to deal with:
1) archs that define more in .data
   They can either define another output section named '.data'
   or they can name it differently.

frv should be able to do:

	RW_DATA(...)

	.data : {
		*(.data.*)
		EXIT_DATA
	}

ld allow us to define identical named output sections
and it will append to the first when it encounter the
name for the second time.

2) archs that do something special.
x86 is an example with has:

        .data : AT(ADDR(.data) - LOAD_OFFSET) {
                DATA_DATA
        } :data

        .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
                *(.data.nosave)
        } :data.init2

See that it add the data section to two different PHDRS.
In this case they cannot use RW_DATA and need to fall
back to the individual defines. 
  
> 
> Perhaps we want an intermediate macro between DATA_DATA and RW_DATA that 
> is just the contents of .data here that those architectuere can use?
> 
> > +#define INITDATA(initsetup_align)					\
> > +	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {		\
> > +		INIT_DATA						\
> > +		. = ALIGN(initsetup_align);				\
> > +               VMLINUX_SYMBOL(__setup_start) = .;                    \
> > +               *(.init.setup)                                        \
> [...]
> > +#define INITDATA(initdata_align)					\
> > +	. = ALIGN((initdata_align));					\
> > +	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {		\
> > +		INIT_DATA						\
> > +	}
> 
> You define two different macros called INITDATA; I'm not sure what the 
> intention is here.
Bug - fixed.

> 
> > +#define INIT_TASK                                                    \
> > +     *(.data.init_task)
> > +             
> > +#define INIT_TASK_DATA(align)                                                
> > +     . = ALIGN((align));                                             \
> > +     .data.init_task : {                                             \
> > +             INIT_TASK                                               \
> > +     }
> > +
> 
> You mentioned elsewhere you thought .data.init_task needs to be its own 
> output section rather than part of the .data output section; why is that? 
> There are several architectures on which it is part of the .data output 
> section (e.g. sh, um, avr32).

I had noticed it was not part of the .data output section in some cases.
But it occur to me not to make any big difference now I have loked
closer so I have moved it inside RW_DATA() for now.

> 
> Also, I think it is possible that INIT_TASK_DATA could just align to 
> THREAD_SIZE rather than taking an argument.  While working on my patches 
> for this I noticed there were only a couple of architectures where the 
> alignment wasn't THREAD_SIZE (or a value equal to THREAD_SIZE was used).  
> One exception was parisc, where the aligment is 16384 and THREAD_SIZE is 
> always at least that but could be bigger in some configs where PAGE_SIZE 
> is bigger.  I'm not sure whether this one exception is a bug.
That triggered some discussions - I will read and see the conclusions.

	Sam
