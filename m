Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZGARO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZGARO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZGAROV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:14:21 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:35780 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZGAROU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M0BK4VBYoIHkmvfJ4Ev+lo/ObZdvt2wBAfFCEKDIc4OonPkqh6hmJtE+QaVxKSOGSp
         WpCbxT9FD1IXLAhm07fYBKcsxMTGsA+Rwl0Uq1ivAUBcRmbXT7xKIECBtUz3SHMPVHb3
         Pmj6eI7m28DzPTXC8c7zkBTFuMmXYuCeRAwbk=
Date: Wed, 1 Jul 2009 19:14:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/3] perfcounter: callchain symbol resolving and fixes
Message-ID: <20090701171419.GA6264@nowhere>
References: <1246419315-9968-1-git-send-email-fweisbec@gmail.com> <20090701081814.GA25593@elte.hu> <20090701163324.GD5097@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701163324.GD5097@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 06:33:25PM +0200, Frederic Weisbecker wrote:
> On Wed, Jul 01, 2009 at 10:18:14AM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Hi,
> > > 
> > > This patchset provides the symbol resolving for callchains.
> > > Example:
> > > 
> > > perf report -s sym -c
> > > 
> > > 5.40%  [k] __d_lookup
> > >              3.60%
> > >                 __d_lookup
> > >                 perf_callchain
> > >                 perf_counter_overflow
> > >                 intel_pmu_handle_irq
> > >                 perf_counter_nmi_handler
> > >                 notifier_call_chain
> > >                 atomic_notifier_call_chain
> > >                 notify_die
> > >                 do_nmi
> > >                 nmi
> > >                 do_lookup
> > >                 __link_path_walk
> > >                 path_walk
> > >                 do_path_lookup
> > >                 user_path_at
> > >                 vfs_fstatat
> > >                 vfs_lstat
> > >                 sys_newlstat
> > >                 system_call_fastpath
> > >                 __lxstat
> > >                 0x406fb1
> > 
> > nice!
> > 
> > > Sorry about the third patch, it's a kind of all-in-one monolithic 
> > > thing which gathers various fixes. I should have granulate it...
> > 
> > No problem, it's good enough - it's all about the same topic.
> > 
> > > 
> > > Still in my plans:
> > > 
> > > - profit we have a tree to display a better graph hierarchy
> > > - let the user provide a limit for hit percentage, depth, number of
> > >   backtraces, etc...
> > > - better output
> > > - colors
> > > 
> > > And another one:
> > > 
> > > - remove the perfcounter internal nmi call frame (ie: every nmi frame)
> > >   so that we drop this header from each callchain:
> > > 
> > >                 perf_callchain
> > >                 perf_counter_overflow
> > >                 intel_pmu_handle_irq
> > >                 perf_counter_nmi_handler
> > >                 notifier_call_chain
> > >                 atomic_notifier_call_chain
> > >                 notify_die
> > >                 do_nmi
> > >                 nmi
> > 
> > Sounds good. I suspect this latter one is the most important one 
> > because right now the backtrace output screen real estate is 
> > dominated by the repetitive nmi entries, making it hard to interpret 
> > the result 'at a glance'.
> > 
> > I think we should skip those NMI entries right in the kernel - that 
> > will also make call-chain event records quite a bit smaller, by 
> > about 72 bytes per call-chain record.
> > 
> > We can do the skipping by using this backtrace-generator callback in 
> > arch/x86/kernel/cpu/perf_counter.c:
> > 
> >  static int backtrace_stack(void *data, char *name)
> >  {
> >          /* Process all stacks: */
> >          return 0;
> >  }
> > 
> > The 'name' parameter passed in signals the type of stack frame we 
> > are processing. If you look into arch/x86/kernel/dumpstack_64.c, it 
> > can be one of these strings:
> > 
> >         static char ids[][8] = {
> >                 [DEBUG_STACK - 1] = "#DB",
> >                 [NMI_STACK - 1] = "NMI",
> >                 [DOUBLEFAULT_STACK - 1] = "#DF",
> >                 [STACKFAULT_STACK - 1] = "#SS",
> >                 [MCE_STACK - 1] = "#MC",
> > 
> > A quick check to see whether this concept works would be expose the 
> > ids array and do:
> > 
> >  static int PER_CPU(int, is_nmi_frame);
> > 
> >  static int backtrace_stack(void *data, char *name)
> >  {
> > 	if (name == x86_stack_ids[NMI_STACK-1])
> 
> 
> IIRC, gcc manages to factorize the string table in the elf
> format right?
> So that a simple == should indeed work here.


Actually, the strings mapped to stack ids are
not const pointers so they won't go the string table I guess.
Anyway "NMI" is never passed as a plain string so it should work
fine.



> 
> Because if you look at dumpstack_64.c, the calls to ->stack()
> use plain const string for some of them:
> 
> ops->stack(data, "IRQ")
> 
> But "NMI" is always passed by its real address in the ids so
> that should work without problem here.
> 
> (I just feared about using strcmp is such a fastpath).
> 
> 
> 
> > 		per_cpu(is_nmi_frame, raw_processor_id()) = 1;
> > 	else
> > 		per_cpu(is_nmi_frame, raw_processor_id()) = 0;
> > 
> >         /* Process all stacks: */
> >         return 0;
> >  }
> > 
> > and to add something like this to backtrace_address():
> > 
> > 	if (per_cpu(is_nmi_frame, raw_processor_id())
> > 		return;
> > 
> > 	Ingo
> 
> 
> Heh, looks like I'll almost only have to copy-paste this mail :)
> 
> Another solution would be to handle an IGNORE return value
> from dump_trace() instead of always terminate the trace when
> ->stack() < 0
> 
> Would it be useful for other kind of uses?
> For now I just asssume ignoring a stack is not a known pattern
> so I'll just implement your solution.
> 
> Thanks.
> 

