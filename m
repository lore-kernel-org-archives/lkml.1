Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZHZQ3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZHZQ3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZHZQ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:29:14 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:61927 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZHZQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hfPO0ns2wENd9gt4wnrGOf0IFbdj28btoYOgcLVZo8XUrCS1MVwxkP7G1cciFpuja+
         bg8knVdPRog8UKcG07YjDPxXglIzV+hOpjuTtQPQxbq/dBf3rMfFWX/4sup8qio3IXR0
         1YidLmmsIU+Q9D08Zi5RBbdMrPtsAekI66AZc=
Date: Wed, 26 Aug 2009 18:29:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, lethal@linux-sh.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: [PATCH 2/4] Add NR_syscalls for x86_64
Message-ID: <20090826162859.GB6759@nowhere>
References: <233dfaa6fadd5aa2fa7ac8511ed9ab98a5f2619c.1251146513.git.jbaron@redhat.com> <20090824221447.GA5124@nowhere> <alpine.DEB.2.00.0908241843450.32241@gandalf.stny.rr.com> <20090825134005.GB2656@redhat.com> <20090825184734.GE2656@redhat.com> <alpine.DEB.2.00.0908252223310.28127@gandalf.stny.rr.com> <20090826135854.GA2658@redhat.com> <alpine.DEB.2.00.0908261038250.23885@gandalf.stny.rr.com> <20090826160910.GB2658@redhat.com> <alpine.DEB.2.00.0908261220490.24316@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908261220490.24316@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 12:21:36PM -0400, Steven Rostedt wrote:
> 
> On Wed, 26 Aug 2009, Jason Baron wrote:
> 
> > On Wed, Aug 26, 2009 at 10:39:26AM -0400, Steven Rostedt wrote:
> > > On Wed, 26 Aug 2009, Jason Baron wrote:
> > > > > > diff --git a/Kbuild b/Kbuild
> > > > > > index f056b4f..5f43d4d 100644
> > > > > > --- a/Kbuild
> > > > > > +++ b/Kbuild
> > > > > > @@ -78,7 +78,7 @@ endef
> > > > > >  arch/$(SRCARCH)/kernel/asm-offsets.s: arch/$(SRCARCH)/kernel/asm-offsets.c \
> > > > > >                                        $(obj)/$(bounds-file) FORCE
> > > > > >  	$(Q)mkdir -p $(dir $@)
> > > > > > -	$(call if_changed_dep,cc_s_c)
> > > > > > +	$(call if_changed_dep,cc_s_c_define_offset)
> > > > > >  
> > > > > >  $(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
> > > > > >  	$(call cmd,offsets)
> > > > > > diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
> > > > > > index 900e161..70c0c3d 100644
> > > > > > --- a/arch/x86/include/asm/unistd_64.h
> > > > > > +++ b/arch/x86/include/asm/unistd_64.h
> > > > > > @@ -688,6 +688,12 @@ __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
> > > > > >  #endif	/* __NO_STUBS */
> > > > > >  
> > > > > >  #ifdef __KERNEL__
> > > > > > +
> > > > > > +#ifndef CREATE_OFFSETS
> > > > > > +#include <asm/asm-offsets.h>
> > > > > > +#define NR_syscalls (__NR_syscall_max + 1)
> > > > > > +#endif
> > > > > > +
> > > > > >  /*
> > > > > >   * "Conditional" syscalls
> > > > > >   *
> > > > > > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > > > > > index 5c4b7a4..4177858 100644
> > > > > > --- a/scripts/Makefile.build
> > > > > > +++ b/scripts/Makefile.build
> > > > > > @@ -145,6 +145,10 @@ $(multi-objs-y:.o=.lst) : modname = $(modname-multi)
> > > > > >  quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
> > > > > >  cmd_cc_s_c       = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
> > > > > >  
> > > > > > +quiet_cmd_cc_s_c_define_offset = CC $(quiet_modtag)  $@
> > > > > > +cmd_cc_s_c_define_offset       = $(CC) $(c_flags) -DCREATE_OFFSETS \
> > > > > > +					-fverbose-asm -S -o $@ $<
> > > > > > +
> > > > > >  $(obj)/%.s: $(src)/%.c FORCE
> > > > > >  	$(call if_changed_dep,cc_s_c)
> > > > > 
> > > > > 
> > > > > Ug, yuck yuck yuck. Sometimes "it works" is not good enough ;-)
> > > > > 
> > > > > How about just adding in asm/unistd.h
> > > > > 
> > > > >  #ifdef __KERNEL__
> > > > >  # ifdef CONFIG_X86_32
> > > > >  #  include "unistd_32.h"
> > > > >  # else
> > > > >  #  include "unistd_64.h"
> > > > > +#  define NR_syscalls (__NR_syscall_max + 1)
> > > > >  # endif
> > > > >  #else
> > > > >  # ifdef __i386__
> > > > >  #  include "unistd_32.h"
> > > > >  # else
> > > > >  #  include "unistd_64.h"
> > > > >  # endif
> > > > >  #endif
> > > > > 
> > > > > And if this is a problem because asm-offset_64.c includes asm/unistd.h, 
> > > > > then make it just include unistd_64.h.
> > > > > 
> > > > > Or am I missing something?
> > > > > 
> > > > > -- Steve
> > > > > 
> > > > > 
> > > > 
> > > > ok, so using the above patch gives me:
> > > > 
> > > >   CC      arch/x86/kernel/ftrace.o
> > > > arch/x86/kernel/ftrace.c: In function ?syscall_nr_to_meta?:
> > > > arch/x86/kernel/ftrace.c:497:35: error: ?__NR_syscall_max? undeclared
> > > > (first use in this function)
> > > > arch/x86/kernel/ftrace.c:497:35: error: (Each undeclared identifier is
> > > > reported only once
> > > > arch/x86/kernel/ftrace.c:497:35: error: for each function it appears
> > > > in.)
> > > > arch/x86/kernel/ftrace.c: In function ?syscall_name_to_nr?:
> > > > arch/x86/kernel/ftrace.c:510:19: error: ?__NR_syscall_max? undeclared
> > > > (first use in this function)
> > > > arch/x86/kernel/ftrace.c: In function ?arch_init_ftrace_syscalls?:
> > > > arch/x86/kernel/ftrace.c:536:7: error: ?__NR_syscall_max? undeclared
> > > > (first use in this function)
> > > > make[2]: *** [arch/x86/kernel/ftrace.o] Error 1
> > > > make[1]: *** [arch/x86/kernel] Error 2
> > > > make: *** [arch/x86] Error 2
> > > > 
> > > > 
> > > > That is the the first time, I encounter a 'NR_syscalls' usage, we error, b/c
> > > > unistd.h does not include 'asm/asm-offsets.h'. If I add an #include of
> > > > 'asm/asm-offsets.h' to ftrace.c the compile is fine. But the point of
> > > > this was to the 'NR_syscalls' definition just from the unistd.h file...
> > > > I'll see if I can come up with a simpler patch.
> > > 
> > > Then add the asm/asm-offests.h to the x86_64 define in unistd.h and have 
> > > the asm-offset_64.c only include the unistd_64.h file. Would that work?
> > > 
> > > -- Steve
> > > 
> > 
> > doesn't quite work, b/c the top of asm-offsets_64.c has a bunch of
> > includes, such as:  <linux/sched.h>, which in turn include unistd.h at
> > a point in time where asm/asm-offests.h does not exist.
> > 
> > However, a much simpler version of the previous patch I posted does do
> > the trick, below. I hope this version is more palatable?
> > 
> > thanks,
> > 
> > -Jason
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
> > index 900e161..b9f3c60 100644
> > --- a/arch/x86/include/asm/unistd_64.h
> > +++ b/arch/x86/include/asm/unistd_64.h
> > @@ -688,6 +688,12 @@ __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
> >  #endif	/* __NO_STUBS */
> >  
> >  #ifdef __KERNEL__
> > +
> > +#ifndef COMPILE_OFFSETS
> > +#include <asm/asm-offsets.h>
> > +#define NR_syscalls (__NR_syscall_max + 1)
> > +#endif
> > +
> >  /*
> >   * "Conditional" syscalls
> >   *
> > diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
> > index 898ecc4..4a6aeed 100644
> > --- a/arch/x86/kernel/asm-offsets_64.c
> > +++ b/arch/x86/kernel/asm-offsets_64.c
> > @@ -3,6 +3,7 @@
> >   * This code generates raw asm output which is post-processed to extract
> >   * and format the required data.
> >   */
> > +#define COMPILE_OFFSETS
> >  
> >  #include <linux/crypto.h>
> >  #include <linux/sched.h> 
> 
> This is MUCH more acceptable.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>


Great, I'm applying the whole series then,
Thanks!

 
> Thanks!
> 
> -- Steve
> 

