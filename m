Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593Ab0A2RgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0A2RgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171Ab0A2RgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:36:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:31115 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0A2RgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:36:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D7tVKpHcIs84+9U+qe1JX7Nw3siSFgWVnOWj7jiOEVVkEoSI3uLJTaeKgvJj1SI+Fd
         SQhH1w1Cld2hutPVt8ynHwzHE68YGk4UGoGEgNaCAiJBSq1HI9efvrsuf7Cd/vGY+47T
         F0kmQc0sUKEBhXiXWuAC/FaE3cNE71IGOusw0=
Date: Fri, 29 Jan 2010 18:29:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       tglx@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] Add type of locks to lock trace events
Message-ID: <20100129172939.GD5047@nowhere>
References: <1263799219.4283.0.camel@laptop> <1264485404-6410-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1264674113.4283.2086.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264674113.4283.2086.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 11:21:53AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-01-26 at 14:56 +0900, Hitoshi Mitake wrote:
> > # Sorry, I wrote wrong Cc address. Previous mail was rejected by mailer-daemon.
> > # This is second time sending, if you already received this, please discard it...
> > 
> > There's no need to add any member to lockdep_map
> > for adding information of type of locks to lock trace events.
> > 
> > Example of perf trace:
> > |       init-0     [001]   335.078670: lock_acquired: 0xffff8800059d6bd8 &rq->lock kernel/lockdep.c:2973 (0 ns)
> > |       rb_consumer-424   [001]   335.078673: lock_acquire: 0xffff8800059d6bd8 1 &rq->lock kernel/lockdep.c:2973
> > |                                                                            # ^ &rq->lock is spin lock!
> > |       rb_consumer-424   [001]   335.078677: lock_acquire: 0xffff8800bba5e8e8 1 buffer->reader_lock_key kernel/trace/ring_
> > |       rb_consumer-424   [001]   335.078679: lock_acquired: 0xffff8800bba5e8e8 buffer->reader_lock_key kernel/trace/ring_b
> > |       rb_consumer-424   [001]   335.078684: lock_acquire: 0xffff8800059d12e8 1 &q->lock kernel/smp.c:83
> > 
> > Of course, as you told, type of lock dealing with is clear for human.
> > But it is not clear for programs like perf lock.
> > 
> > What I want to do is limiting types of lock focus on.
> > e.g. perf lock prof --type spin,rwlock
> > 
> > How do you think, Peter?
> 
> I still don't see the use for it, surely you're going to be familiar
> with the code if you're looking at lock statistics?



Comparing the avg/max time locks are acquired/waited between same
types of locks is interesting, but doing so between spinlocks and mutexes
is definetly pointless.

spinlocks will always be in the bottom of the report while their measures
should be taken in an utterly different order of magnitude.

Each lock nature should be reported separately. An rwlock won't have
the same behaviour pattern than a spinlock. It may spin less in average
but more in the maximum snapshot, and still that depends on a write_lock
or a read_lock operations.

That said I don't think this is the right approach. We only need this
information when the lock is initialized. That's the same for the
file and line things, especially since these add 1/5 more overhead.
And that's even the same for the name of the lock.

Actually we need a lock_init event that brings:

- lock addr
- lock name
- lock type
- file/line

This can be triggered on spinlock_init(), mutex_init(), etc..
for the dynamic cases and use a synthetize_lock_events()
from perf tools that could work toward events injection
through perf ioctl, for the static cases.
Or/and we could use a debugfs file for that, otherwise only
perf will be able to use the lock events. Or this can be
an event injection from ftrace.

And all other lock events should not be giving anymore the
name, type, or file/line. We should deduce it from the
lock_init events and the lock addr in each lock events.

I think this becomes critical, given the high overhead nature
of lock events and their impact in profiling them.

