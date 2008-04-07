Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYDGHNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYDGHNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 03:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYDGHNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 03:13:34 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:45480
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYDGHNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 03:13:34 -0400
Date: Mon, 7 Apr 2008 09:13:30 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/10] emm: notifier logic
Message-ID: <20080407071330.GH9309@duo.random>
References: <20080404223048.374852899@sgi.com> <20080404223131.469710551@sgi.com> <20080405005759.GH14784@duo.random> <Pine.LNX.4.64.0804062246030.18148@schroedinger.engr.sgi.com> <20080407060602.GE9309@duo.random> <Pine.LNX.4.64.0804062314080.18728@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804062314080.18728@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2008 at 11:20:08PM -0700, Christoph Lameter wrote:
> On Mon, 7 Apr 2008, Andrea Arcangeli wrote:
> 
> > > > My mm_lock solution makes all rcu serialization an unnecessary
> > > > overhead so you should remove it like I already did in #v11. If it
> > > > wasn't the case, then mm_lock wouldn't be a definitive fix for the
> > > > race.
> > > 
> > > There still could be junk in the cache of one cpu. If you just read the 
> > > new pointer but use the earlier content pointed to then you have a 
> > > problem.
> > 
> > There can't be junk, spinlocks provides semantics of proper memory
> > barriers, just like rcu, so it's entirely superflous.
> > 
> > There could be junk only if any of the mmu_notifier_* methods would be
> > invoked _outside_ the i_mmap_lock and _outside_ the anon_vma and
> > outside the mmap_sem, that is never the case of course.
> 
> So we use other locks to perform serialization on the list chains? 
> Basically the list chains are protected by either mmap_sem or an rmap 
> lock? We need to document that.

I thought it was obvious, if it wasn't the case how could mm_lock fix
any range_begin/range_end race? Also to document it you've just to
remove _rcu, the only confusion could arise from reading your patch,
mine couldn't raise any doubt that rcu isn't needed and regular
spinlocks/semaphores are serializing all methods.

> In that case we could also add an unregister function.

Indeed, but it still can't run after mm_users == 0. So for unregister
to work one has to boost the mm_users first. exit_mmap doesn't take
any lock when destroying the mm because it assumes nobody is messing
with the mm at that time. So that requirement doesn't change, but now one
can unregister before mm_users is dropped to 0.

Also I wonder if I should make a new version of the mm_lock/unlock so
that they will guarantee SIGKILL handling in O(N) anywhere inside
mm_lock or mm_unlock, where N is the number of vmas, that will either
require a VM_MM_LOCK_I/VM_MM_LOCK_A bitflag, or a vmalloc of two
bitflag arrays inside the mmap_sem critical section returned by
mm_lock as a cookie and passed as param to mm_unlock. The SIGKILL
check is mostly worthless in spin_lock context (especially on UP or
low-smp) but given the later patches switches all relevant VM locks to
mutexes (this should happen under a config option to avoid hurting
server performance), it might be worth it. That will require
mmu_notifier_register to return both -EINTR and -ENOMEM if using the
vmalloc trick to avoid registering two more vm_flags
bitflags. Alternatively we can have mm_lock fail with -EPERM if there
aren't enough capabilities and the number of vmas is bigger than a
certain number. This is more or less like the requirement to attach
during startup. This is preferable IMHO because it's effective even
without preempt-rt and in turn with all locks being spinlocks for
maximum performance, so I'll likely release #v12 with this change. In
any case the mmu_notifier_register will need to return error (an
unregister as well for that matter). But those are very minor issues,
#v11 can go in -mm now to ensure mmu notifiers will be shipped with 2.6.26rc. 
