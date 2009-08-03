Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbZHCLWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbZHCLWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZHCLWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:22:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58505 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbZHCLWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:22:53 -0400
Date: Mon, 3 Aug 2009 13:22:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
Message-ID: <20090803112220.GA22936@elte.hu>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


( Linus and perfcounters folks Cc:-ed - i'd like to solicite
  suggestions about future oprofile design and subsystem
  maintainance directions. I'd also like to preempt potential
  "Why did you pull this crap???" flames from Linus in the .32
  merge window ;-)

* Robert Richter <robert.richter@amd.com> wrote:

> This patch series introduces performance counter multiplexing for
> oprofile.
>
> The number of hardware counters is limited. The multiplexing
> feature enables OProfile to gather more events than counters are
> provided by the hardware. This is realized by switching between
> events at an user specified time interval.
>
> A new file (/dev/oprofile/time_slice) is added for the user to
> specify the timer interval in ms. If the number of events to
> profile is higher than the number of hardware counters available,
> the patch will schedule a work queue that switches the event
> counter and re-writes the different sets of values into it. The
> switching mechanism needs to be implemented for each architecture
> to support multiplexing. This patch series only implements AMD CPU
> support, but multiplexing can be easily extended for other models
> and architectures.
>
> The patch set includes the initial patch from Jason Yeh and many
> code improvements and reworks on top. It evolved over time and
> documents its development. Thus, for review also the enclosed
> overall diff might be useful.
>
> The patches can be pulled from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git mux
>
> -Robert
>
>
> The following changes since commit 8045a4c293d36c61656a20d581b11f7f0cd7acd5:
>   Robert Richter (1):
>         x86/oprofile: Fix cast of counter value
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git mux
>
> Jason Yeh (1):
>       oprofile: Implement performance counter multiplexing
>
> Robert Richter (25):
>       x86/oprofile: Rework and simplify nmi_cpu_setup()
>       x86/oprofile: Whitespaces changes only
>       x86/oprofile: Fix usage of NUM_CONTROLS/NUM_COUNTERS macros
>       x86/oprofile: Use per_cpu() instead of __get_cpu_var()
>       x86/oprofile: Fix initialization of switch_index
>       oprofile: oprofile_set_timeout(), return with error for invalid args
>       oprofile: Rename variable timeout_jiffies and move to oprofile_files.c
>       oprofile: Remove oprofile_multiplexing_init()
>       oprofile: Grouping multiplexing code in oprof.c
>       oprofile: Introduce op_x86_phys_to_virt()
>       oprofile: Grouping multiplexing code in op_model_amd.c
>       x86/oprofile: Implement multiplexing setup/shutdown functions
>       x86/oprofile: Moving nmi_setup_cpu_mux() in nmi_int.c
>       x86/oprofile: Moving nmi_cpu_save/restore_mpx_registers() in nmi_int.c
>       x86/oprofile: Moving nmi_cpu_switch() in nmi_int.c
>       x86/oprofile: Remove const qualifier from struct op_x86_model_spec
>       x86/oprofile: Remove unused num_virt_controls from struct op_x86_model_spec
>       x86/oprofile: Modify initialization of num_virt_counters
>       x86/oprofile: Add function has_mux() to check multiplexing support
>       x86/oprofile: Enable multiplexing only if the model supports it
>       x86/oprofile: Implement mux_clone()
>       oprofile: Adding switch counter to oprofile statistic variables
>       x86/oprofile: Implement op_x86_virt_to_phys()
>       x86/oprofile: Add counter reservation check for virtual counters
>       x86/oprofile: Small coding style fixes
>
>  arch/Kconfig                      |   12 ++
>  arch/x86/oprofile/nmi_int.c       |  307 +++++++++++++++++++++++++++++--------
>  arch/x86/oprofile/op_counter.h    |    2 +-
>  arch/x86/oprofile/op_model_amd.c  |  127 ++++++++++++----
>  arch/x86/oprofile/op_model_p4.c   |   12 +-
>  arch/x86/oprofile/op_model_ppro.c |   10 +-
>  arch/x86/oprofile/op_x86_model.h  |   16 ++-
>  drivers/oprofile/oprof.c          |   71 +++++++++-
>  drivers/oprofile/oprof.h          |    3 +
>  drivers/oprofile/oprofile_files.c |   46 ++++++
>  drivers/oprofile/oprofile_stats.c |    5 +
>  drivers/oprofile/oprofile_stats.h |    1 +
>  include/linux/oprofile.h          |    3 +
>  13 files changed, 501 insertions(+), 114 deletions(-)

Ok. The oprofile patches have been going upstream via -tip and i've
been pulling and testing/relaying them for upstream for more than a
year with pretty good results.

Now i'm also co-maintaining perfcounters and because it's a full 
oprofile replacement (which aspect Robert seems to disagree with ;-) 
i'd like to make sure it's not seen by Robert as a conflict of 
interest so let me raise the following questions publicly:

This new oprofile multiplexing mechanism really overlaps the PMU 
abstractions that perfcounters already provide, and i disagree with 
this general direction. The code you wrote is clean though so i've 
(reluctantly) pulled it into tip:oprofile and started testing it, 
and will send it Linus-wards in the .32 merge window - unless Linus 
agrees with my general objections against this oprofile direction.

The reason for my disagreement is on the technical and on the policy 
level.

Here's the (rough) support comparison matrix:

                              perfcounters |         oprofile-mux
                       ..........................................
   granularity:        per task or per cpu |              per cpu
                                           .
   switch mechanism:             interrupt |            workqueue
                                           .
   limits:                 soft, unlimited |      hardcoded to 32
                                           .
   arch support:              generic, all |  AMD only, needs per
                        perfcounter arches | cpu and arch changes

The perfcounters multiplexing is visibly more mature and more
capable: more generic, integrated into the scheduler, not hardcoded,
etc.

And the oprofile bits are for x86 (AMD) only, with every oprofile 
architecture having to do similarly invasive changes - so these 500 
lines of changes probably get multipled by a factor of 10 or so in 
the end, years down the line. A lot of work and i think it can and 
should all be avoided.

So there are two technical/policy questions:

Would it be fair to require oprofile to implement a similarly
high-quality counter virtualization as perfcounters? If yes then i
think the end result would be oprofile based on perfcounters: i.e.
this particular oprofile-mux patchset becomes largely moot and we'd
not have to go through the (non-trivial) transition period of
updating every single oprofile driver for multiplexing.

The other question is: do we really want to have a constant
distraction via the overlapping oprofile space? I think a feasible
and sane looking approach would be to:

 - Put oprofile into maintenance mode, fix all bugs that get
   reported/found, perhaps add new hw enablement drivers in the
   existing scheme (if they are submitted) but otherwise dont
   complicate the code any more.

 - Extend PMU and performance instrumentation support via
   perfcounters primarily.

 - Possibly base oprofile user-space on perfcounters syscalls
   (with a fall-back to old oprofile syscalls on older kernels),
   if there's interest from folks who want the oprofile tool-chain,
   allowing the removal of the oprofile kernel code in the long run.

This series of steps seems to be the technically sanest approach to
me, and we are certainly willing to extend perfcounters in any
fashion to allow a fuller replacement for oprofile. (we already
think it's a worthy replacement and more - but we are open to all
enhancements.)

I'd not be against maintaining the code in its current form, but i'm
not sure whether we should extend the core oprofile code itself with
things like the multiplexing code above which is seriously
non-trivial and splits both developer attention and testing efforts.

Linus, Peter, Paul, do you have any preferences? I'm really on two
minds about whether to do this oprofile feature. The overlap of this
patch-set with perfcounters is serious, the induced complexity is
serious and the ongoing maintenance cost is non-trivial.

Since PMU developers is a more or less constant pool of people, 
these policy issues do matter IMO and affect perfcounters as well 
indirectly, not just oprofile. Hardware vendors generally want to 
enable all facilities that are in the kernel, regardless of which 
one we consider to be the best one. So by forcing development of a 
new oprofile driver variant, resources are taken away from 
perfcounters.

It's as if we continued maintaining and developing ipchains after 
iptables was merged upstream. Instead we used compatibility 
mechanisms and phased out ipchains rather gracefully. Robert is 
apparently of the opinion that oprofile needs to be developed 
further - hence these questions.

So on those grounds i'm (mildly) inclined to not do this and suggest 
that we work on achieving the same end result via other means: via 
the perfcounters enabling of oprofile userspace.

But if Linus/Peter/Paul thinks that pulling it was the right 
solution then i'll keep the bits - i wanted to have a public 
discussion of these questions first.

Thanks,

	Ingo
