Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZHYTET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZHYTET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZHYTES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:04:18 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:41081 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755662AbZHYTEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:04:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAAfSk0pMROOX/2dsb2JhbACBU9dQhBoF
Date: Tue, 25 Aug 2009 15:04:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, lethal@linux-sh.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, peterz@infradead.org, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com, jistone@redhat.com,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 2/4] Add NR_syscalls for x86_64
Message-ID: <20090825190415.GB8474@Krystal>
References: <cover.1251146512.git.jbaron@redhat.com> <233dfaa6fadd5aa2fa7ac8511ed9ab98a5f2619c.1251146513.git.jbaron@redhat.com> <20090824221447.GA5124@nowhere> <alpine.DEB.2.00.0908241843450.32241@gandalf.stny.rr.com> <20090825134005.GB2656@redhat.com> <20090825184734.GE2656@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090825184734.GE2656@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:56:12 up 7 days,  5:45,  2 users,  load average: 0.81, 0.44,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Tue, Aug 25, 2009 at 09:40:05AM -0400, Jason Baron wrote:
> > > > On Mon, Aug 24, 2009 at 05:40:18PM -0400, Jason Baron wrote:
> > > > > Add a dynamic definition of NR_syscalls for x86_64. This is used in the 
> > > > > syscall events tracing code.
> > > > > 
> > > > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > > > 
> > > > > ---
> > > > >  include/linux/ftrace.h |    5 +++++
> > > > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > > > > index dc3b132..3bd94ee 100644
> > > > > --- a/include/linux/ftrace.h
> > > > > +++ b/include/linux/ftrace.h
> > > > > @@ -14,6 +14,11 @@
> > > > >  
> > > > >  #include <asm/ftrace.h>
> > > > >  
> > > > > +#ifdef CONFIG_X86_64
> > > > > +#include <asm/asm-offsets.h>
> > > > > +#define NR_syscalls (__NR_syscall_max + 1)
> > > > > +#endif
> > > > > +
> > > > 
> > > > 
> > > > I'd rather see this in arch/x86/include/unistd_64.h, since
> > > > NR_syscalls seems to be the defined in unistd.h in all archs.
> > > > 
> > > > That also makes a unified way to retrieve this number for
> > > > other users.
> > > > 
> > > 
> > > Yes, NR_syscalls should be included there.
> > > 
> > > -- Steve
> > 
> > right, for x86_64, unistd.h is included to generate __NR_syscall_max
> > which is then used for NR_syscalls. So I did initially try it there, but
> > there were dependency problems. I'll see what I can come up with...
> > 
> > thanks,
> > 
> > -Jason
> 
> ok, since unistd_64.h is used to generate offsets.c, which eventually
> generates, asm/asm-offsets.h, which defines, __NR_syscall_max, we can't
> just put #define of NR_syscalls in unistd_64.h. However, it seems the
> only point in time that unistd_64.h can not depend upon __NR_syscall_max,
> is before asm/asm-offsets.h is defined. Thus, the patch below passes in
> a '-DCREATE_OFFSETS' during the creation of asm/asm-offsets.h, so that
> we do not include it before it exists. The patch is hacky but works.
> thoughts?

Ugh! My eyes hurt!

What you are doing here is to basically put back the hardcoded
NR_syscalls rather that using the build infrastructure already in place.

If my memory serves me well, unistd_64.h generates __NR_syscall_max
automatically by being included multiples times. Can we generalize this
and make the information generated available in an automaticaly
generated header instead ? It is saved in ams-offsets.h currently as
"__NR_syscall_max". We could also save it somewhere else meant to be
included by C code.

Mathieu

> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
> 
>  Kbuild                           |    2 +-
>  arch/x86/include/asm/unistd_64.h |    6 ++++++
>  scripts/Makefile.build           |    4 ++++
>  3 files changed, 11 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/Kbuild b/Kbuild
> index f056b4f..5f43d4d 100644
> --- a/Kbuild
> +++ b/Kbuild
> @@ -78,7 +78,7 @@ endef
>  arch/$(SRCARCH)/kernel/asm-offsets.s: arch/$(SRCARCH)/kernel/asm-offsets.c \
>                                        $(obj)/$(bounds-file) FORCE
>  	$(Q)mkdir -p $(dir $@)
> -	$(call if_changed_dep,cc_s_c)
> +	$(call if_changed_dep,cc_s_c_define_offset)
>  
>  $(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
>  	$(call cmd,offsets)
> diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
> index 900e161..70c0c3d 100644
> --- a/arch/x86/include/asm/unistd_64.h
> +++ b/arch/x86/include/asm/unistd_64.h
> @@ -688,6 +688,12 @@ __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
>  #endif	/* __NO_STUBS */
>  
>  #ifdef __KERNEL__
> +
> +#ifndef CREATE_OFFSETS
> +#include <asm/asm-offsets.h>
> +#define NR_syscalls (__NR_syscall_max + 1)
> +#endif
> +
>  /*
>   * "Conditional" syscalls
>   *
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 5c4b7a4..4177858 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -145,6 +145,10 @@ $(multi-objs-y:.o=.lst) : modname = $(modname-multi)
>  quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
>  cmd_cc_s_c       = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
>  
> +quiet_cmd_cc_s_c_define_offset = CC $(quiet_modtag)  $@
> +cmd_cc_s_c_define_offset       = $(CC) $(c_flags) -DCREATE_OFFSETS \
> +					-fverbose-asm -S -o $@ $<
> +
>  $(obj)/%.s: $(src)/%.c FORCE
>  	$(call if_changed_dep,cc_s_c)
>  
> 
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
