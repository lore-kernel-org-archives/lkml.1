Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab0APA6b (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412Ab0APA6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:58:30 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:44616 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab0APA62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:58:28 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263592192.4244.488.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546175.4244.342.camel@laptop>
	 <1263589634.5007.34.camel@localhost.localdomain>
	 <1263592192.4244.488.camel@laptop>
Content-Type: text/plain
Date: Fri, 15 Jan 2010 16:58:23 -0800
Message-Id: <1263603503.5007.134.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2010-01-15 at 22:49 +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 13:07 -0800, Jim Keniston wrote:
> > On Fri, 2010-01-15 at 10:02 +0100, Peter Zijlstra wrote:
> > > On Thu, 2010-01-14 at 11:46 -0800, Jim Keniston wrote:
> > > > 
> > > > +Instruction copies to be single-stepped are stored in a per-process
> > > > +"single-step out of line (XOL) area," which is a little VM area
> > > > +created by Uprobes in each probed process's address space.
> > > 
> > > I think tinkering with the probed process's address space is a no-no.
> > > Have you ran this by the linux mm folks?
> > 
> > Sort of.
> > 
> > Back in 2007 (!), we were getting ready to post uprobes (which was then
> > essentially uprobes+xol+upb) to LKML, pondering XOL alternatives and
> > waiting for utrace to get pulled back into the -mm tree.  (It turned out
> > to be a long wait.)  I emailed Andrew Morton, inquiring about the
> > prospects for utrace and giving him a preview of utrace-based uprobes.
> > He expressed openness to the idea of allocating a piece of the user
> > address space for the XOL area, a la the vdso page.
> > 
> > With advice and review from Dave Hansen, we implemented an XOL page, set
> > up for every process (probed or not) along the same lines as the vdso
> > page.
> > 
> > About that time, Roland McGrath suggested using do_mmap_pgoff() to
> > create a separate vma on demand.  This was the seed of the current
> > implementation.  It had the advantages of being
> > architecture-independent, affecting only probed processes, and allowing
> > the allocation of more XOL slots.  (Uprobes can make do with a fixed
> > number of XOL slots -- allowing one probepoint to steal another's slot
> > -- but it isn't pretty.)
> > 
> > As I recall, Dave preferred the other idea (1 XOL page for every
> > process, probed or not) -- mostly because he didn't like the idea of a
> > new vma popping into existence when the process gets probed -- but was
> > OK with us going ahead with Roland's idea.
> 
> Well, I think its all very gross, I would really like people to try and
> 'emulate' or plain execute those original instructions from kernel
> space.
> 
> As to the privileged instructions, I think qemu/kvm like projects should
> have pretty much all of that covered.

I hear (er, read) you.  Emulation may turn out to be the answer for some
architectures.  But here are some things to keep in mind about the
various approaches:

1. Single-stepping inline is easiest: you need to know very little about
the instruction set you're probing.  But it's inadequate for
multithreaded apps.
2. Single-stepping out of line solves the multithreading issue (as do #3
and #4), but requires more knowledge of the instruction set.  (In
particular, calls, jumps, and returns need special care; as do
rip-relative instructions in x86_64.)  I count 9 architectures that
support kprobes.  I think most of these do SSOL.
3. "Boosted" probes (where an appended jump instruction removes the need
for the single-step trap on many instructions) require even more
knowledge of the instruction set, and like SSOL, require XOL slots.
Right now, as far as I know, x86 is the only architecture with boosted
kprobes.
4. Emulation removes the need for the XOL area, but requires pretty much
total knowledge of the instruction set.  It's also a performance win for
architectures that can't do #3.  I see kvm implemented on 4
architectures (ia64, powerpc, s390, x86).  Coincidentally, those are the
architectures to which uprobes (old uprobes, with ubp and xol bundled
in) has already been ported (though Intel hasn't been maintaining their
ia64 port).  So it sort of comes down to how objectionable the XOL vma
(or page) really is.

Regarding your suggestion about executing the probed instruction in the
kernel, how widely do you think that can be applied: which
architectures?  how much of the instruction set?

> 
> Nor do I think we need utrace at all to make user space probes useful.
> Even stronger, I think the focus on utrace made you get some
> fundamentals wrong. Its not mainly about task state, but like said, its
> about text mappings, which is something utrace knows nothing about.

I think that's a useful insight.  As mentioned, long ago we offered up a
version of uprobes where probes were per-executable rather than
per-process.  The feedback from LKML was, in no uncertain terms, that
they should be per-process, and use access_process_vm().  Of course --
as we then argued -- sometimes you want to probe a process from the very
start, so the SystemTap folks had to invent the task-finder to allow
that.

> 
> That is not to say you cannot build a useful interface from uprobes and
> utrace, but its not at all required or natural.
> 

Thanks again for your advice and ideas.

Jim

