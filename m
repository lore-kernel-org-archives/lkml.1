Return-Path: <linux-kernel-owner+w=401wt.eu-S1751513AbZKDGJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbZKDGJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZKDGJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:09:32 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36646 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbZKDGJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:09:31 -0500
Date: Tue, 3 Nov 2009 22:09:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ian Campbell <Ian.Campbell@citrix.com>,
       Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
Message-ID: <20091104060933.GB6830@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com> <20091103160734.GA21362@elte.hu> <alpine.DEB.1.10.0911031324380.32136@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911031324380.32136@V090114053VZO-1>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 01:34:32PM -0500, Christoph Lameter wrote:
> On Tue, 3 Nov 2009, Ingo Molnar wrote:
> 
> > Sidenote: percpu areas currently are kept allocated on x86.
> 
> They must be kept allocated for all possible cpus. Arch code cannot decide
> to not allocate per cpu areas.
> 
> Search for "for_each_possible_cpu" in the source tree if you want more
> detail.

Here are a few in my area:

kernel/rcutorture.c srcu_torture_stats 523 for_each_possible_cpu(cpu) {
kernel/rcutorture.c rcu_torture_printk 800 for_each_possible_cpu(cpu) {
kernel/rcutorture.c rcu_torture_init 1127 for_each_possible_cpu(cpu) {
kernel/rcutree.c RCU_DATA_PTR_INIT 1518 for_each_possible_cpu(i) { \
kernel/rcutree_trace.c PRINT_RCU_DATA 73 for_each_possible_cpu(_p_r_d_i) \
kernel/rcutree_trace.c print_rcu_pendings 237 for_each_possible_cpu(cpu) {
kernel/srcu.c srcu_readers_active_idx 64 for_each_possible_cpu(cpu)

> > That might change in the future though, especially with virtual systems
> > where the possible range of CPUs can be very high - without us
> > necessarily wanting to pay the percpu area allocation price for it. I.e.
> > dynamic deallocation of percpu areas is something that could happen in
> > the future.
> 
> Could be good but would not be as easy as you may think since core code
> assumes that possible cpus have per cpu areas configured. There will be
> the need for additional notifiers and more complex locking if we want to
> have percpu areas for online cpus only. Per cpu areas are permanent at
> this point which is a good existence guarantee that avoids all sorts of
> complex scenarios.

Indeed.

I will pick on the last one.  I would need to track all the srcu_struct
structures.  Each such structure would need an additional counter.
In the CPU_DYING notifier, SRCU would need to traverse all srcu_struct
structures, zeroing the dying CPU's count and adding the old value
to the additional counter.  This is safe because CPU_DYING happens in
stop_machine_run() context.

Then srcu_readers_active_idx() would need to initialize "sum" to the
additional counter rather than to zero.

Not all -that- bad, and similar strategies could likely be put in place
for the other six offenders in RCU.

Another class of problems would be from code that did not actually access
an offline CPU's per-CPU variables, but instead implicitly expected the
values to remain across an offline-online event pair.  The various
rcu_data per-CPU structures would need some fixups when the CPU came
back online.

One way to approach this would be have two types of per-CPU variable,
one type with current semantics, and another type that can go away
when the corresponding CPU goes offline.  This latter type probably
needs to be set back to the initial values when the corresponding
CPU comes back online.

Of course, given an "easy way out", one might expect most people to
opt for the old-style per-CPU variables.  On the other hand, how
much work do we want to do to save (say) four bytes?

> > Nice one. I'm wondering why it was not discovered for such a long time.
> 
> Cpu hotplug is rarely used (what you listed are rare and unusual cases)
> and therefore online cpus == possible cpus == present cpus.

Though it is not unusual for "possible cpus" to be quite a bit larger
than "online cpus"...

							Thanx, Paul
