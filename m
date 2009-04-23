Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZDWUiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZDWUiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZDWUiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:38:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49211 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbZDWUiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:38:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0904231004120.3101@localhost.localdomain>
References: <alpine.LFD.2.00.0904231004120.3101@localhost.localdomain> <20090422175753.GA14236@elte.hu> <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait() and co. imply a memory barrier
Date: Thu, 23 Apr 2009 21:35:45 +0100
Message-ID: <22170.1240518945@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I think we _have_ to imply a smp_wmb() in the wakup semantics, because 
> otherwise sleepers can't do anything sane (no amount of barriers on the 
> sleeping side will help). IOW, there basically has to be an implied write 
> barrier between the thing that causes an event to become true, and the 
> thing that turns 'task->state' back to RUNNING.

Well, Ingo's point is it could be left up to the caller of wake_up() to supply
the barrier:

	*my_variable = 1234;
	smp_wmb();
	wake_up(&my_queue);

or:

	spin_lock(&my_lock);
	*my_variable = 1234;
	wake_up(&my_queue);
	spin_unlock(&my_lock);

on the condition that the sleeper also gets the lock.

Also, he points out that wake_up() and co. may not insert useful memory barrier
at all, for three reasons:

 (1) If there's no-one to wake up, then certain wake functions will return
     immediately.

 (2) If there's no-one to wake up, then other wake functions will only impose
     LOCK and UNLOCK barriers.

 (3) If someone supplies a special awakener instead of default_wake_function(),
     then they can bypass try_to_wake_up() and whatever barrier that implies.

     Though as far as I can see, if you want to wake someone up, you *have* to
     go through try_to_wake_up().

What I'd like to say is that wake_up() and friends _will_ interpose at least a
write barrier _if_ they wake anything up (which is more or less what you said
above).  If they don't wake anything up, then there's no need for a memory
barrier between the assignment to my_variable and the non-existent alterations
to the state of the task not being awoken.

David
