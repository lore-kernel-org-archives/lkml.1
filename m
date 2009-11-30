Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbZK3Hzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbZK3Hzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbZK3Hzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:55:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:32978 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZK3Hzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:55:53 -0500
Date: Mon, 30 Nov 2009 08:55:57 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul McKenney <paulmck@us.ibm.com>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091130075557.GI17484@wotan.suse.de>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911280927180.2561@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 09:30:18AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 23 Nov 2009, Nick Piggin wrote:
> > 
> > Last time this issue came up that I could see, I don't think
> > there were objections to making rwlocks fair, the main
> > difficulty seemed to be that we allow reentrant read locks
> > (so a write lock waiting must not block arbitrary read lockers).
> 
> We have at least one major rwlock user - tasklist_lock or whatever. And 
> that one definitely depends on being able to do 'rwlock()' in an 
> interrupt, without other rwlock'ers having to disable irq's (even if there 
> might be a new writer coming in on another cpu).
> 
> That usage case _might_ be turned into RCU or something similar, in which 
> case I don't think any major rwlock users remain. However, if that's the 
> case, then why should anybody care about fairness any more either?

We do have quite a large number of rwlocks really. If they are so
important as to be rwlocks, then presumably means we can expect
multiple readers in the critical sections. Therefore, we can have
a possibility of livelock. (It isn't so hard, I have a test case
which _totally_ livelocks the write-side of the tasklist lock on a
2 socket opteron, just with several threads calling wait(2)).

I'm just not sure why you don't think the other rwlocks are a problem.
Certainly they are probably not as central and visible or likely to
be a problem as tasklist_lock, but at least for a DoS, couldn't they
be an issue?

But anyway, yes I would be happy to just start with tasklist_lock
for now and if we could keep slowly trying to move away from rwlocks
in other areas, that would be good.

 
> So as far as I can tell, we have only one real user of rwlocks where 
> livelocks might be relevant, but that one real user absolutely _requires_ 
> the unfair behavior.

Yes, although the behaviour required is that it can be recursively
acquired. So we could still have a lock that disallows new non recursive
read acquires when there is a pending write locker.

RCU seems nicer, but tasklist lock locking scares me so I wanted to fix
it the easy way :)

