Return-Path: <linux-kernel-owner+w=401wt.eu-S1764252AbYCGDk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764252AbYCGDk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 22:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbYCGDkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 22:40:11 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40994 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756839AbYCGDkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 22:40:08 -0500
Date: Thu, 6 Mar 2008 21:40:03 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maxk@qualcomm.com, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080306214003.aba81840.pj@sgi.com>
In-Reply-To: <1204816885.6241.265.camel@lappy>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
	<20080229190223.GA17820@elte.hu>
	<47C87084.3090208@qualcomm.com>
	<1204318980.6243.133.camel@lappy>
	<47C8771C.1070001@qualcomm.com>
	<1204545445.11412.6.camel@twins>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<1204568316.8514.18.camel@twins>
	<20080304013534.4e51ae48.pj@sgi.com>
	<1204628762.6241.46.camel@lappy>
	<47CDA885.3000103@qualcomm.com>
	<20080304191159.a02be58b.pj@sgi.com>
	<1204706272.6241.79.camel@lappy>
	<20080306074729.6233e537.pj@sgi.com>
	<1204816885.6241.265.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helpful reply, Peter.  Thanks.

Peter, replying to pj, wrote:
> On Thu, 2008-03-06 at 07:47 -0600, Paul Jackson wrote:
> > ... In your example,
> > the 'tasks' file in /cgroup/irqs is probably empty, right?
> 
> Likely; if for instance you'd want some unbound kernel threads to join
> in that overlapping set, then perhaps that name would be badly chosen.

Ok.  So, as you note below, discussing cgroups:
> ... yes, cgroups are perhaps awkward because they group tasks whereas
> the current problem is grouping IRQs.

Essentially, cpusets are like cgroups in this regard.  They group
tasks.  They just happen to be grouping tasks to associate them
with sets of CPUs (and Memory Nodes), which seems relevant somehow
to the present need, to group irqs to associate them with sets of
CPUs.



> Perhaps we're talking about something else here; how bad would it be to
> require:
> 
> for irq in `cat /cgroup/boot/irqs` ; do echo $irq > /cgroup/irqs; done

I haven't gotten my head around what such a script would do yet,
but you are correct in suspecting that we could add a script like
this easily enough in future releases, if that was useful.

I can change init scripts, for each kernel version, much easier than I
can ask the big batch scheduler providers to change their application
code (user level system code) to deal with incompatible changes.


> Certainly providing a new script in the new
> version certified for a new distro isn't too much work?

Correct - that's quite easy, from my perspective.

> > What in tarnation are you trying to do, that's painful or impossible
> > to do, with what we have now?
> 
> Assign a map of cpus where irqs will default into, and a way to
> explicitly move them out of it.

Can you spell out how or why /proc/irq/N/smp_affinity doesn't
provide what you need here?

My guess is that it's fairly obvious why /proc/irq/N/smp_affinity is
not well suited for this.  It requires poking lots of settings, one
at a time, which is cumbersome and racey from user space, difficult
to keep in sync with any other changes in placement of RT or other
jobs, and it requires root permissions, without any finer granularity
practical.


> Because we're mapping them [irqs] onto CPUs, cpusets came to mind.
> 
> The thing we 'need', is to provide named groups of irqs and for each
> such a group specify a cpu mask that is appropriate.
> 
> Grouping them makes sense in that we want to make a functional division.
> Some IRQs serve a system as a whole, others serve a subset. Typical
> subsets could be a RT process space bounded to a cpu/mem domain.
> 
> Other usable subsets could be limiting the IRQs of node local network
> and IO cards to the cpu/mem domain that runs the application that uses
> them.
> 
> So we group irqs like:
> 
>   system_on_nodes_1_2_and_3 (default)
>   big_io_app_on_nodes_2_and_3
>   rt_app_on_node_4
> 
> Where, again, you see a strong similarity to the cpu/mem divisions
> already made by cpusets.


Cool -- I'm glad now I asked (rather impatiently) what we needed.

That's a helpful reply.

Could we:
 1) name some sets of IRQs
 2) for each cpuset, specify which named IRQ set applied to it
 3) prioritize these sets of IRQs (linear order), so that
    for any given CPU, if it were in multiple cpusets
    specifying conflicting IRQ sets, we could select the
    IRQ set to apply to that CPU.

Given the reliance in (2) of cpusets on these IRQ set names, this
still needs to be part of cpusets.

But rather than (ab)use cpusets to directly accomplish (1), how
about adding some files to the root cpuset to define IRQ sets,
with names such as (for example):

	irqs.0.system
	irqs.1.big_io_apps
	irqs.2.rt

That is, more generally, add one or more "irqs.N.name" files to
the top cpuset, where N is a distinct natural number and "name"
a user space specified name (except that perhaps the first one,
the 'irqs.0.system', with its name 'system' or perhaps it should
be 'boot', is pre-ordained during system boot.)

Each of these 'irqs.N.name' files would contain a newline separated
list of irq numbers.

Also add, per item (2) above, to each cpuset, one more file, containing
a single line, naming one of these irq.* files to be found in the
root cpuset.  Let me call this new per-cpuset file 'irqs'.

The number N in the name "irqs.N.name" would order these sets of irqs.

If in this example a cpuset's "irqs" file specified 'rt', that would
take priority (for the CPUs in that cpusets 'cpus' file) over the
other two irqs.N.* files above, because the '2' in "irqs.2.rt" is
bigger than the other irqs.N numbers.

For each CPU, we'd find the largest N such that some cpuset (1) had
that CPU in its 'cpus'mask, and that cpusets 'irqs' file named the
corresponding irqs.N.name file, and then we'd use the irqs listed in
that irqs.N.name file on that CPU.

The default value of the top (root) cpusets 'irqs' file at boot
would be 'system' (or 'boot').  The default value for any cpusets
created thereafter would be inherited from the cpusets parent.

These 'irqs.N.name' files would be the first instance of allowing
user created files in cpuset directories.  That will require some
changes to the cpuset or cgroup code; I don't know how much.

If one of these 'irqs.N.name' files were removed, then any cpuset
that had been using it (had that 'name' in its 'irqs' file) would
have to be reverted, I suppose to its parents 'irqs' setting.

An application (any job with permission to write its own cpusets
files) could control which named set of irqs it wanted to use,
by writing the 'irqs' file in its cpuset.  But system permissions
(such as root) would be probably be required to specify which irqs
were listed in each /dev/cpuset/irqs.N.* file (unless some admin
script decided to change the permissions on those files at runtime,
of course.)

Does that make any sense?  What have I missed?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
