Return-Path: <linux-kernel-owner+w=401wt.eu-S965834AbZLHTau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965834AbZLHTau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965861AbZLHTap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:30:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43616 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965837AbZLHTao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:30:44 -0500
Date: Tue, 8 Dec 2009 14:30:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <alpine.LFD.2.00.0912081024530.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912081412450.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Linus Torvalds wrote:

> > The whole readers vs. writers thing is a non-sequitur.
> 
> No it's not.
> 
> It's a 100% equivalent problem. It's purely a change of wording. The end 
> result is the same.

Well, of course the end result is the same (ignoring bugs) -- that was 
the point.  It doesn't follow that the two locking mechanisms are 100% 
equivalent.

> And note how even though you sprinkled random memory barriers around, you 
> still got it wrong. 

Yes.  That comes of trying to think at the keyboard.

> It's certainly not smaller. It's not faster. It doesn't have support for 
> lockdep. And it's BUGGY.

Lockdep will choke on the rwsem approach anyway.  It has never been
very good at handling tree-structured locking, especially when there
are non-parent-child interactions.  But never mind.

> Really. Tell me why you want to re-implement an existing lock - badly.

I didn't want to.  The whole exercise was intended to make a point -- 
that rwsems do more than we really need here.

> [ Hint: you need a smp_mb() *before* the atomic_dec() in wait-unlock, so 
>   that anybody else who sees the new value will be guaranteed to have seen 
>   anything else the unlocker did.

Yes.

>   You also need a smp_mb() in the wait_for_lock(), not a smp_rmb(). Can't 
>   allow writes to migrate up either.  'atomic_read()' does not imply any
>   barriers.

No, that's not needed.  Unlike reads, writes can't move in front of
data or control dependencies.  Or so I've been lead to believe...

> That "wait_for_lock()" is equivalent to a 'read_lock()+read_unlock()'.

Not really.  It also corresponds to a 'write_lock()+write_unlock()' (in
the suspend routine).  Are you claiming these two compound operations
are equivalent?

> We 
> _could_ expose such a mechanism for rwsem's too, but why do it? It's 
> actually nicer to use a real read-lock - and do it _around_ the operation, 
> because now the locking also automatically gets things like overlapping 
> suspends and resumes right.
> 
> (Which you'd obviously hope never happens, but it's nice from a conceptual 
> standpoint to know that the locking is robust).

> Take heed. You got it wrong. Admit it. Locking is _hard_. SMP memory 
> ordering is HARD.

Oh, there's no question about that.  I never seriously intended this 
stuff to be adopted.  It was just for discussion.

Alan Stern

