Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZHZOBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZHZOBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbZHZOBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:01:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbZHZOBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:01:13 -0400
Date: Wed, 26 Aug 2009 09:58:54 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, lethal@linux-sh.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: [PATCH 2/4] Add NR_syscalls for x86_64
Message-ID: <20090826135854.GA2658@redhat.com>
References: <cover.1251146512.git.jbaron@redhat.com> <233dfaa6fadd5aa2fa7ac8511ed9ab98a5f2619c.1251146513.git.jbaron@redhat.com> <20090824221447.GA5124@nowhere> <alpine.DEB.2.00.0908241843450.32241@gandalf.stny.rr.com> <20090825134005.GB2656@redhat.com> <20090825184734.GE2656@redhat.com> <alpine.DEB.2.00.0908252223310.28127@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.0908252223310.28127@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 10:25:52PM -0400, Steven Rostedt wrote:
> On Tue, 25 Aug 2009, Jason Baron wrote:
> 
> > On Tue, Aug 25, 2009 at 09:40:05AM -0400, Jason Baron wrote:
> > > 
> > > right, for x86_64, unistd.h is included to generate __NR_syscall_max
> > > which is then used for NR_syscalls. So I did initially try it there, but
> > > there were dependency problems. I'll see what I can come up with...
> > > 
> > > thanks,
> > > 
> > > -Jason
> > 
> > ok, since unistd_64.h is used to generate offsets.c, which eventually
> > generates, asm/asm-offsets.h, which defines, __NR_syscall_max, we can't
> > just put #define of NR_syscalls in unistd_64.h. However, it seems the
> 
> Why not? A define is not a problem until it is used. Is something in 
> asm-offsets.c using NR_syscalls?
> 
> > only point in time that unistd_64.h can not depend upon __NR_syscall_max,
> > is before asm/asm-offsets.h is defined. Thus, the patch below passes in
> > a '-DCREATE_OFFSETS' during the creation of asm/asm-offsets.h, so that
> > we do not include it before it exists. The patch is hacky but works.
> > thoughts?
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> > 
> >  Kbuild                           |    2 +-
> >  arch/x86/include/asm/unistd_64.h |    6 ++++++
> >  scripts/Makefile.build           |    4 ++++
> >  3 files changed, 11 insertions(+), 1 deletions(-)
> > 
> > 
> > diff --git a/Kbuild b/Kbuild
> > index f056b4f..5f43d4d 100644
> > --- a/Kbuild
> > +++ b/Kbuild
> > @@ -78,7 +78,7 @@ endef
> >  arch/$(SRCARCH)/kernel/asm-offsets.s: arch/$(SRCARCH)/kernel/asm-offsets.c \
> >                                        $(obj)/$(bounds-file) FORCE
> >  	$(Q)mkdir -p $(dir $@)
> > -	$(call if_changed_dep,cc_s_c)
> > +	$(call if_changed_dep,cc_s_c_define_offset)
> >  
> >  $(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
> >  	$(call cmd,offsets)
> > diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
> > index 900e161..70c0c3d 100644
> > --- a/arch/x86/include/asm/unistd_64.h
> > +++ b/arch/x86/include/asm/unistd_64.h
> > @@ -688,6 +688,12 @@ __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
> >  #endif	/* __NO_STUBS */
> >  
> >  #ifdef __KERNEL__
> > +
> > +#ifndef CREATE_OFFSETS
> > +#include <asm/asm-offsets.h>
> > +#define NR_syscalls (__NR_syscall_max + 1)
> > +#endif
> > +
> >  /*
> >   * "Conditional" syscalls
> >   *
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index 5c4b7a4..4177858 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -145,6 +145,10 @@ $(multi-objs-y:.o=.lst) : modname = $(modname-multi)
> >  quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
> >  cmd_cc_s_c       = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
> >  
> > +quiet_cmd_cc_s_c_define_offset = CC $(quiet_modtag)  $@
> > +cmd_cc_s_c_define_offset       = $(CC) $(c_flags) -DCREATE_OFFSETS \
> > +					-fverbose-asm -S -o $@ $<
> > +
> >  $(obj)/%.s: $(src)/%.c FORCE
> >  	$(call if_changed_dep,cc_s_c)
> 
> 
> Ug, yuck yuck yuck. Sometimes "it works" is not good enough ;-)
> 
> How about just adding in asm/unistd.h
> 
>  #ifdef __KERNEL__
>  # ifdef CONFIG_X86_32
>  #  include "unistd_32.h"
>  # else
>  #  include "unistd_64.h"
> +#  define NR_syscalls (__NR_syscall_max + 1)
>  # endif
>  #else
>  # ifdef __i386__
>  #  include "unistd_32.h"
>  # else
>  #  include "unistd_64.h"
>  # endif
>  #endif
> 
> And if this is a problem because asm-offset_64.c includes asm/unistd.h, 
> then make it just include unistd_64.h.
> 
> Or am I missing something?
> 
> -- Steve
> 
> 

ok, so using the above patch gives me:

  CC      arch/x86/kernel/ftrace.o
arch/x86/kernel/ftrace.c: In function ‘syscall_nr_to_meta’:
arch/x86/kernel/ftrace.c:497:35: error: ‘__NR_syscall_max’ undeclared
(first use in this function)
arch/x86/kernel/ftrace.c:497:35: error: (Each undeclared identifier is
reported only once
arch/x86/kernel/ftrace.c:497:35: error: for each function it appears
in.)
arch/x86/kernel/ftrace.c: In function ‘syscall_name_to_nr’:
arch/x86/kernel/ftrace.c:510:19: error: ‘__NR_syscall_max’ undeclared
(first use in this function)
arch/x86/kernel/ftrace.c: In function ‘arch_init_ftrace_syscalls’:
arch/x86/kernel/ftrace.c:536:7: error: ‘__NR_syscall_max’ undeclared
(first use in this function)
make[2]: *** [arch/x86/kernel/ftrace.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2


That is the the first time, I encounter a 'NR_syscalls' usage, we error, b/c
unistd.h does not include 'asm/asm-offsets.h'. If I add an #include of
'asm/asm-offsets.h' to ftrace.c the compile is fine. But the point of
this was to the 'NR_syscalls' definition just from the unistd.h file...
I'll see if I can come up with a simpler patch.

thanks,

-Jason

