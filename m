Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbXKAPkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbXKAPkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbXKAPjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:39:54 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:34512 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026AbXKAPjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:39:53 -0400
Subject: Re: [patch 1/4] spinlock: lockbreak cleanup
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, riel <riel@redhat.com>
In-Reply-To: <20071101142932.GB2648@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de>
	 <20071101140241.GB26879@wotan.suse.de> <1193925965.27652.284.camel@twins>
	 <20071101142932.GB2648@wotan.suse.de>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 01 Nov 2007 11:39:59 -0400
Message-Id: <1193931599.5300.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 15:29 +0100, Nick Piggin wrote:
> On Thu, Nov 01, 2007 at 03:06:05PM +0100, Peter Zijlstra wrote:
> > On Thu, 2007-11-01 at 15:02 +0100, Nick Piggin wrote:
> > 
> > > Rename need_lockbreak to spin_needbreak, make it use spin_is_contended to
> > > decouple it from the spinlock implementation, and make it typesafe (rwlocks
> > > do not have any need_lockbreak sites -- why do they even get bloated up
> > > with that break_lock then?).
> > 
> > IIRC Lee has a few patches floating about that do introduce lockbreak
> > stuff for rwlocks.
> 
> Well that would be a good reason to introduce a break_lock for them,
> but previously not so much... we have rwlocks in some slightly space
> critical structures (vmas, inodes, etc).
> 
> I guess it was done to make the "template" hacks eaiser. I don't really
> find that in good taste, especially for important core infrastructure.
> Anyway.

Actually, what I had/have is a cond_resched_rwlock() that I needed to
convert the i_mmap_lock() to rw for testing reclaim scalability.  [I've
seen a large system running an Oracle OLTP load hang spitting "cpu soft
lockup" messages with all cpus spinning on a i_mmap_lock spin lock.]
One of the i_mmap_lock paths uses cond_resched_lock() for spin locks.
To do a straight forward conversion [and maybe that isn't the right
approach], I created the cond_resched_rwlock() function by generalizing
the cond_sched_lock() code and creating both spin and rw lock wrappers.
I took advantage of the fact that, currently, need_lockbreak() is a
macro and that both spin and rw locks have/had the break_lock member.
Typesafe functions would probably be preferrable, if we want to keep
break_lock for rw spin locks.

Here's the most recent posting:

	http://marc.info/?l=linux-mm&m=118980356306014&w=4

See the changes to sched.[ch].  Should apply to 23-mm1 with offsets and
minor fixup in fs/inode.c.

Lee



