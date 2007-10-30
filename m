Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbXJ3UqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbXJ3UqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXJ3Upw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:45:52 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:39100 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754175AbXJ3Upv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:45:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPM0J0dMQWvU/2dsb2JhbACBWo5Z
Date: Tue, 30 Oct 2007 16:40:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
Message-ID: <20071030204043.GA13547@Krystal>
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net> <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org> <20071030172442.GA4477@Krystal> <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org> <20071030185639.GA9077@Krystal> <alpine.LFD.0.999.0710301214300.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.0.999.0710301214300.30120@woody.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:33:53 up 92 days, 19:52,  4 users,  load average: 1.44, 1.99, 1.55
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Tue, 30 Oct 2007, Mathieu Desnoyers wrote:
> > 
> > The key idea for collapsing profiling, markup and tracing was that
> > marking up the code is required for both profiling and tracing. It's
> > only the code that is called from that markup site that differs.
> 
> What code is actually shared? 
> 

vmstat "counter increments" and blktrace instrumentation, profile.c
"profile_hits" calls could be all expressed as "generic markup", and
then used for profiling and tracing. But that would imply the creation
of a markup management that would permit it without hurting performance.

> Regardless, an internal implementation issue is *not* a good basis for a 
> user-visible interface. 
> 

If we have to put it that way, code markup can be itself seen as a
user-visible interface. The marker name, if a particular analysis
depends on it, will have to keep its name unchanged. The same applies to
the arguments passed to it. Therefore, even though the scheduler code
changed a lot over the past 10 years, its context switch marker could always
be expressed as 

  trace_mark(kernel_sched_schedule,
         "prev_pid %d next_pid %d prev_state %ld",
         prev->pid, next->pid, prev->state);

Where kernel_sched_schedule and the format string field names are kept
unchanged. Only its location and the name of the variables it touches
could have to be modified to follow the kernel tree.


> > Ok, so maybe we should keep "markup", "tracing" and "profiling"
> > separately and see how things evolve.
> 
> I think so. At least conceptually - ie it might be fine to share a Kconfig 
> file, but there probably shouldn't be some forced shared choice about it.
> 
> > With SMP systems becoming cheap commodity hardware, each and every
> > developer increasingly face thorny race problems, both in user-space
> > apps and in the kernel, which may involve hypervisor-kernel-userspace
> > interaction.
> 
> Well, the thing is, most of the time, those app developers will not be
> doing kernel-level markers. But they may well be doing profiling. 
> 
> Speaking as an application developer myself (git), I care deeply about 
> good profiling info, and I love Oprofile. But even though I'm a kernel 
> person too, I'd not want to do kprobes. It's just not relevant to me as a 
> user-land developer.
> 
> (I might want to extend on strace, but if so, I'd do it generically, not 
> as a "probe". For example, I'd love to see the page faults, but I think 
> they really *are* "system calls", so I think it would make more sense to 
> extend on the ptrace interface than to have any kprobes thing)
> 

Since I am not a kprobe user myself, so I understand you completely. :)
What users expect when they try to fix that kind of issue, when oprofile
and gdb are not sufficient, is to start a data collection mechanism that
will tell them what is going in their system at large, without requiring
them to write kernel code.

However, that involves marking up key kernel code that will call into a
tracer to extract that information. Other projects has done this in
different ways.. SystemTAP, for instance, does it out of tree by keeping
a separate list of address where kprobes must be installed. It does the
job on a distribution kernel maintainer perspective (Redhat), since they
freeze to a particular kernel version and update this list every time it
breaks, but will always be a source of frustration for vanilla kernel
users and kernel developers. I think the best way to follow the code flow
is to add markup in the code itself: it would follow the kernel HEAD and
let each subsystem maintainer identify the key instrumentation sites of
their subsystem.

It's important to state that if anyone want to have his own marker set
in a separate patchset, he can do so. I currently have my own set of
markers to trace the most important kernel sites required to analyze and
show a trace of the Linux kernel in my LTTng kernel tracer. It's derived
from the set found in LTT which did not change much in about 8 years. I
could always submit that for comments to see how subsystem maintainers
will react to the proposed instrumentation.

About extending on ptrace, I am sorry to say that this solution has the
same downsides as kprobes: it is too slow for high performance
applications, especially if turned on system-wide. It will also change
the system behavior so much that it may hide the bugs and performance
issues people are struggling to find. Ptrace is very good at what it
does: looking inside _one_ application and tracing its system calls and
signals, but the approach finds its limits when we are trying to look at
the interactions between multiple applications and the kernel more
globally.


> > > So I actually think that the current Kconfig.instrumentation should be 
> > > *removed*. Rather than adding more groupings based on that 
> > > fundamentally flawed premise of false commonality.
> > 
> > Should it come with a re-duplication of it's content into each 
> > architecture, which was the case previously ? The oprofile and kprobes 
> > menu entries were litteraly cut and pasted from one architecture to 
> > another. Should we put its content in init/Kconfig then ?
> 
> I don't think it's a good idea to go back to making it per-architecture, 
> although that extensive "depends on <list-of-archiectures-here>" might 
> indicate that there certainly is room for cleanup there.
> 
> And I don't think it's wrong keeping it in kernel/Kconfig.xyz per se, I 
> just think it's wrong to (a) lump the code together when it really doesn't 
> necessarily need to and (b) show it to users as some kind of choice that 
> is tied together (whether it then has common code or not).
> 
> On the per-architecture side, I do think it would be better to *not* have 
> internal architecture knowledge in a generic file, and as such a line like
> 
> 	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
> 
> really shouldn't exist in a file like kernel/Kconfig.instrumentation.
> 
> It would be much better to do
> 
> 	depends on ARCH_SUPPORTS_KPROBES
> 
> in that generic file, and then architectures that do support it would just 
> have a
> 
> 	bool ARCH_SUPPORTS_KPROBES
> 		default y

Absolutely. Let's do it.

> 
> in *their* architecture files. That would seem to be much more logical, 
> and is readable both for arch maintainers *and* for people who have no 
> clue - and don't care - about which architecture is supposed to support 
> which interface...
> 

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
