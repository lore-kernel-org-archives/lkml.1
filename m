Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZKEVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZKEVGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 16:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbZKEVGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 16:06:52 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53644 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974AbZKEVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 16:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k3JQmxlMpGscCMyh3bYEb+cU7V1jPlv2NJVbQKZ7VflPppYcnX9dymIh2FyD0AjKaQ
         WArlVAQNjipLGsOZS5RTscaaIC5xs0VFy9WwvDUvVcHdLe6uITmWvxRekGvLZ6Sf8MHA
         erFlOlkD3uWDQ7+kQQvQTtumbSM6JYH9UUov8=
Date: Thu, 5 Nov 2009 22:06:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091105210652.GF4877@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <20091105153404.GB3229@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105153404.GB3229@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 09:04:04PM +0530, K.Prasad wrote:
> On Tue, Nov 03, 2009 at 08:11:12PM +0100, Frederic Weisbecker wrote:
> [snipped]
> > 
> >  /* Available HW breakpoint length encodings */
> > -#define HW_BREAKPOINT_LEN_1		0x40
> > -#define HW_BREAKPOINT_LEN_2		0x44
> > -#define HW_BREAKPOINT_LEN_4		0x4c
> > -#define HW_BREAKPOINT_LEN_EXECUTE	0x40
> > +#define X86_BREAKPOINT_LEN_1		0x40
> > +#define X86_BREAKPOINT_LEN_2		0x44
> > +#define X86_BREAKPOINT_LEN_4		0x4c
> > +#define X86_BREAKPOINT_LEN_EXECUTE	0x40
> > 
> 
> It had previously been suggested http://lkml.org/lkml/2009/5/28/554
> that users be allowed to specify the lengths in numerals. Despite having
> some divergent views initially, I see that it would help minimise the
> amount of code required to request a breakpoint if numerals (such as 1,
> 2, 4 and 8 for x86_64) are allowed.
> 
> The conversion to encoded values can happen later inside the
> bkpt-specific code.



That's what I did, I've redefined them in linux/hw_breakpoint.h:

#define HW_BREAKPOINT_LEN_1                1
#define HW_BREAKPOINT_LEN_2                2
#define HW_BREAKPOINT_LEN_4                4

And the arch interpret that using its own corresponding values.


 
> > --- a/include/asm-generic/hw_breakpoint.h
> > +++ /dev/null
> 
> Can you split this patch into fine granular ones? It is very difficult
> to review the changes this way.



Sure, I personally don't like either this big monolithic patch, but
it is hard/impossible to split it as we change the whole base of a
subsystem inside.

But this header moving has been done in the v2 and I thought git-format-patch
would detect the rename but the file has probably too much changed.

I'll do another iteration that split up this part.


> > diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
> > new file mode 100644
> > index 0000000..7eba9b9
> > --- /dev/null
> > +++ b/include/linux/hw_breakpoint.h
> 
> Have you clubbed file renaming along with changes inside the file?
> Again, it'd be good to have them in separate patches for easy review.


There have been this rename only. But I'll split up this part.



> > +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> > +extern struct perf_event *
> > +register_user_hw_breakpoint(unsigned long addr,
> > +			    int len,
> > +			    int type,
> > +			    perf_callback_t triggered,
> > +			    struct task_struct *tsk,
> > +			    bool active);
> > +
> 
> I don't understand the benefit behind bringing these parameters into the
> interfaces' prototype. Besides they will make addition of new attributes
> (if needed later) quite cumbersome. Given that these values are
> eventually copied into members of perf_event_attr, I'd suggest that they
> accept a pointer to an instance of the structure.



Yeah, that's a bit intended as a temporary thing. The preffered
way for that would be to pass a pointer to a perf_event_attr
structure.

I plan to do this change incrementally, once we have defined
breakpoints attributes generic enough to support most archs
possibilities.



> > +/* FIXME: only change from the attr, and don't unregister */
> > +extern struct perf_event *
> > +modify_user_hw_breakpoint(struct perf_event *bp,
> > +			  unsigned long addr,
> > +			  int len,
> > +			  int type,
> > +			  perf_callback_t triggered,
> > +			  struct task_struct *tsk,
> > +			  bool active);
> > +
> > +/*
> > + * Kernel breakpoints are not associated with any particular thread.
> > + */
> > +extern struct perf_event *
> > +register_wide_hw_breakpoint_cpu(unsigned long addr,
> > +				int len,
> > +				int type,
> > +				perf_callback_t triggered,
> > +				int cpu,
> 
> Can't it be cpumask_t instead of int cpu? Given that per-cpu breakpoints
> will be implemented, it should be very different to implement them for a
> subset of cpus too.



I can't figure out any usecase where we want to only bind to,
say, cpu 1 and 3 or any kind of such strange combination.

Either we want a wide breakpoint, or we want to profile
a single cpu, but I don't imagine we need a middle case.



> > -static DEFINE_SPINLOCK(hw_breakpoint_lock);
> 
> Wouldn't you want to hold this lock while checking for system-wide
> availability of debug registers (during rollbacks) to avoid contenders
> from checking for the same simultaneously?


If we want to lock such path, we probably more likely want a mutex.
Registering a breakpoint is not a fastpath and also perf does
some sleepable things while creating a counter.

The check to register constraints, which is part of this path,
is itself a mutex.

But we'll probably need something NMI safe in the future so
that it can be used without any problem by kgdb.


 
> <snipped>
> 
> > -int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > +struct perf_event **
> > +register_wide_hw_breakpoint(unsigned long addr,
> > +			    int len,
> > +			    int type,
> > +			    perf_callback_t triggered,
> > +			    bool active)
> >  {
> > -	int rc;
> > +	struct perf_event **cpu_events, **pevent, *bp;
> > +	long err;
> > +	int cpu;
> > +
> > +	cpu_events = alloc_percpu(typeof(*cpu_events));
> > +	if (!cpu_events)
> > +		return ERR_PTR(-ENOMEM);
> > 
> > -	rc = arch_validate_hwbkpt_settings(bp, NULL);
> > -	if (rc)
> > -		return rc;
> > +	for_each_possible_cpu(cpu) {
> > +		pevent = per_cpu_ptr(cpu_events, cpu);
> > +		bp = register_kernel_hw_breakpoint_cpu(addr, len, type,
> > +					triggered, cpu, active);
> > 
> 
> I'm assuming that there'd be an implementation for system-wide
> perf-events (and hence breakpoints) in the forthcoming version(s) of
> this patchset.


If that becomes a necessary feature, then yeah.


> Have you tested these changes from perf-events' user-space command?
> Would you like to re-use the patches from here:
> http://lkml.org/lkml/2009/10/29/304 to test them?


Yeah, I have planned to reuse your patches for the perf subcommand
support :)

