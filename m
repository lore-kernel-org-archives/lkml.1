Return-Path: <linux-kernel-owner+w=401wt.eu-S932308Ab0A1UE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0A1UE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171Ab0A1UE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:04:27 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:59344 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0A1UE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:04:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X7ZEyTwY9pwZDcBuQvD2O9rYuzigcaxJZy+NdICwJPARhktJHEPwmqmPS8pC9HzL5L
         5tGOn3IQ/B7rGc+UvF5Yfp1mzU0fwx9cD+o7i/BUvyDnPLoLQIwdw0iLu6E+Pt2vvSDp
         kqXWeBqAwoFDG5tFnsmiik1ULheqbPaia4M+4=
Date: Thu, 28 Jan 2010 21:04:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] x86,hw_breakpoint,kgdb: kgdb to use
	hw_breakpointAPI
Message-ID: <20100128200418.GC18683@nowhere>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-2-git-send-email-jason.wessel@windriver.com> <20100128171050.GA18683@nowhere> <4B61CD14.7000901@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61CD14.7000901@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 11:44:52AM -0600, Jason Wessel wrote:
> Frederic Weisbecker wrote:
> > Good simplification, but that doesn't appear related to kgdb,
> > this should be done in a separate patch, for the perf/core tree.
> >
> >   
> 
> Specifically this is required so that kgdb can modify the state of dr7
> by installing and removing breakpoints.  Without this change, on return
> from the callback the dr7 was not correct.
> 
> As far as I know, only kgdb was altering the dr registers during a call
> back..



Ok. Well not sure how/where it needs to modify dr7 directly.


 
> > hw_breakpoint_restore() is used by KVM only, for now.
> > The cpu var cpu_debugreg[] contains values that
> > are only saved when KVM switches to a guest, then
> > this function is called when KVM switches back to the
> > host. I bet this is not the function you need.
> > In fact, I don't know what you intended to do there.
> >
> >   
> 
> I was looking to restore the proper contents of the debug registers when
> resuming the general kernel execution.
> 
> As far as I could tell it looked like the right function because
> arch_install_breakpoint() uses the per_cpu vars.  If there is a save
> function that I need to call first that is a different issue.
> 
> IE:
>     __get_cpu_var(cpu_debugreg[i]) = info->address;
> 
> 
> I admit I did not test running a kvm instance, so I don't know what kind
> of conflict there would be here.  I went and further looked at the kvm
> code, and they call the function for the same reason kgdb does.  They
> want the original system values back on resuming normal kernel
> execution.  KVM can modify dr7 or other regs directly on entry for its
> guest execution.  Kgdb does the same sort of thing so as to prevent the
> debugger from interrupting itself.



You mean kgdb needs to disable dr7 while handling a breakpoint to
avoid recursion? In this case this is something already done
from the x86 breakpoint handler.


 
> > Would be nice to have bptype set to the generic flags
> > we have already in linux/hw_breakpoint.h:
> >
> > enum {
> > 	HW_BREAKPOINT_R = 1,
> > 	HW_BREAKPOINT_W = 2,
> > 	HW_BREAKPOINT_X = 4,
> > };
> >
> >
> >   
> 
> These numbers have to get translated somewhere from the GDB version
> which it handed off via the gdb serial protocol.  They could be
> translated in the gdb stub, but for now they are in the arch specific
> stub.  Or you can choose to use the same numbering scheme as gdb for the
> breakpoint types and the values could be used directly.



Ah ok. Well, translating gdb <-> generic values will make you
move this code from x86 to core at least.

 
> > Same here, see arch_build_bp_info().
> > Actually, arch_validate_hwbkpt_settings() would do all
> > that for you. May require few changes though to adapt.
> >
> > Actually, I don't understand why you encumber with this
> > breakinfo thing. Why not just keeping a per cpu array
> > of perf events? You have everything you need inside:
> > the generic breakpoint attributes in the attrs and
> > the arch info in the hw_perf_event struct inside.
> >   
> 
> I think the break info thing will go away via a refactor.  For now I was
> really looking to make it work.   There was no way to tell at the time
> what values were safe to use in attr struct provided by perf.  I would
> have further preferred to be able to use the simple -1 cpu in the bp
> type and let perf do all the work, but there is no way to allocate a
> perf hw wide break like this at the moment.



Ok.


 
> Realize that what is here is well tested, and aimed to first correct the
> regression.


Sure.

 
> >> +		} else if (recieved_hw_brk[raw_smp_processor_id()] == 1) {
> >> +			recieved_hw_brk[raw_smp_processor_id()] = 0;
> >> +			return NOTIFY_STOP;
> >> +		} else if (dr6_p && (*dr6_p & DR_TRAP_BITS) == 0) {
> >> +			return NOTIFY_DONE;
> >> +		}
> >>     
> >
> >
> >
> > So this is the debug handler, right?
> >
> >
> >   
> 
> This ugly bit is all because the patch I had for returning something
> from the event call back was tossed.
> 
> Because perf does not honor the return code from a call back there is no
> way to dismiss an event in the die notifier.  The forces the debug
> handler to do very nasty tricks so as not to handle the same event twice.



Right, we'll need to fix that later from perf, I think.


 
> >>  
> >> +static void kgdb_hw_bp(struct perf_event *bp, int nmi,
> >> +		       struct perf_sample_data *data,
> >> +		       struct pt_regs *regs)
> >> +{
> >> +	struct die_args args;
> >> +	int cpu = raw_smp_processor_id();
> >> +
> >> +	args.trapnr = 0;
> >> +	args.signr = 5;
> >> +	args.err = 0;
> >> +	args.regs = regs;
> >> +	args.str = "debug";
> >> +	recieved_hw_brk[cpu] = 0;
> >> +	if (__kgdb_notify(&args, DIE_DEBUG) == NOTIFY_STOP)
> >> +		recieved_hw_brk[cpu] = 1;
> >> +	else
> >> +		recieved_hw_brk[cpu] = 0;
> >> +}
> >>     
> >
> >
> >
> > And this looks like the perf event handler.
> >
> > I'm confused by the logic here. We have the x86 breakpoint
> > handler which calls perf_bp_event which in turn will call
> > the above. The above calls __kgdb_notify(), but it will
> > also be called later as it is a debug notifier.
> >
> >
> >   
> 
> Perf was eating my events if I had no call back.  If you know a way
> around this let me know.


The problem is not the perf callback. What I did not understand
was the use of __kgdb_notify() from the callback, while it is
still called after as a debug notifier.



> > And then you release these, ok. We should find a proper
> > way for that later, but for now it should work.
> >
> >   
> 
> Previously, I was unable to convince anyone that the kernel debugger
> needed to be able to do this.  I had an API change to perf for it, but
> it was dismissed along with the notify return value on the call back. 
> This is merely a work around to correct the regression.


We'll need to sanitize that after the regression fix.

