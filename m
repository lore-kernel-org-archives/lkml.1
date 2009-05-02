Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZEBAtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZEBAtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 20:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZEBAs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 20:48:58 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32981 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbZEBAs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 20:48:57 -0400
Date: Fri, 1 May 2009 20:48:53 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>
Subject: Re: [PATCH v2 0/6] macros for section name cleanup
In-Reply-To: <20090501213118.GA28126@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0905011916530.10966@vinegar-pot.mit.edu>
References: <1241121253-32341-1-git-send-email-tabbott@mit.edu> <20090501213118.GA28126@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Sam Ravnborg wrote:

> This is the way I want to go where we have more complete
> definitions in the shared file and we try to keep the arch
> linker scripts to the arch specifc stuff.

I like the general look of this.  Indeed, I was planning to work on 
something like this as a follow-on to the linker script cleanup work I've 
done so far.

Some comments on the details are below.

> +#define PAGE_ALIGNED_DATA(page_align)                                \
> +     . = ALIGN((page_align));                                        \
> +     *(.data.page_aligned)

Why does this need an argument?  You should be able to just align to 
PAGE_SIZE.

Also, I'm not sure what you're trying to do with the double parentheses 
here (it also appears inconsistently in several other places in this 
patch).

> +/* use 0 as page_align if page_aligned data is not used */ 
> +#define RW_DATA(page_align, readmostly_align, cache_align)           \
> +     . = ALIGN(PAGE_SIZE);                                           \
> +     .data : AT(ADDR(.data) - LOAD_OFFSET) {                         \
> +             DATA_DATA                                               \
> +             CONSTRUCTORS                                            \
> +             NOSAVE_DATA                                             \
> +             PAGE_ALIGNED_DATA(page_align)                           \
> +             READMOSTLY_DATA((readmostly_align))                     \
> +             CACHELINE_ALIGNED_DATA((cache_align))                   \
> +     }

I think there are several architectures that have some other stuff in 
their .data output section (e.g. powerpc, frv, ia64), so we won't be able 
to use this on all architectures.  

Perhaps we want an intermediate macro between DATA_DATA and RW_DATA that 
is just the contents of .data here that those architectuere can use?

> +#define INITDATA(initsetup_align)					\
> +	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {		\
> +		INIT_DATA						\
> +		. = ALIGN(initsetup_align);				\
> +               VMLINUX_SYMBOL(__setup_start) = .;                    \
> +               *(.init.setup)                                        \
[...]
> +#define INITDATA(initdata_align)					\
> +	. = ALIGN((initdata_align));					\
> +	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {		\
> +		INIT_DATA						\
> +	}

You define two different macros called INITDATA; I'm not sure what the 
intention is here.

> +#define INIT_TASK                                                    \
> +     *(.data.init_task)
> +             
> +#define INIT_TASK_DATA(align)                                                
> +     . = ALIGN((align));                                             \
> +     .data.init_task : {                                             \
> +             INIT_TASK                                               \
> +     }
> +

You mentioned elsewhere you thought .data.init_task needs to be its own 
output section rather than part of the .data output section; why is that?  
There are several architectures on which it is part of the .data output 
section (e.g. sh, um, avr32).

Also, I think it is possible that INIT_TASK_DATA could just align to 
THREAD_SIZE rather than taking an argument.  While working on my patches 
for this I noticed there were only a couple of architectures where the 
alignment wasn't THREAD_SIZE (or a value equal to THREAD_SIZE was used).  
One exception was parisc, where the aligment is 16384 and THREAD_SIZE is 
always at least that but could be bigger in some configs where PAGE_SIZE 
is bigger.  I'm not sure whether this one exception is a bug.

	-Tim Abbott
