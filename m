Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbYCGVwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbYCGVwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYCGVwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:52:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYCGVwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:52:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: do_tkill: don't use tasklist_lock
In-Reply-To: Oleg Nesterov's message of  Saturday, 8 March 2008 00:32:17 +0300 <20080307213217.GA2584@tv-sign.ru>
References: <20080307095813.GA8894@tv-sign.ru>
	<20080307193159.1AFF127010F@magilla.localdomain>
	<20080307201346.GA107@tv-sign.ru>
	<20080307211955.A876226F990@magilla.localdomain>
	<20080307213217.GA2584@tv-sign.ru>
X-Zippy-Says: If I am elected no one will ever have to do their laundry again!
Message-Id: <20080307215134.6E6BC26F990@magilla.localdomain>
Date: Fri,  7 Mar 2008 13:51:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is the big problem with exec that I've cited before.  It can even
> > happen with group-wide signals that should be fatal, but avoided the
> > __group_complete_signal special fatal case.  (e.g. the thread racing with
> > the exec thread just now unblocked the signal and dequeued it.)  IIRC it
> > was the biggest reason we wanted to revisit the whole MT exec plan.
> 
> Oh. Could you clarify? Afaics, currently exec() can't miss the fatal group
> signal?

It's a while since I thought hard about the exec stuff.  Just now I was
thinking of one particular scenario.  Perhaps it can't really happen.
Here it is:

Threads A and B both block SIGTERM.  An outside process sends SIGTERM,
so it is queued in shared_pending but noone wakes.

A starts an exec.		

B unblocks SIGTERM.  
B enters get_signal_to_deliver, locks, dequeues SIGTERM, unlocks.
Now B is e.g. just before "current->flags |= PF_SIGNALED;".

A locks.  No group-exit is in yet progress.  
A does zap_other_threads, and unlocks.

B enters do_group_exit.  A group-exit is in progress, so it just exits.
SIGTERM is lost.

So I think it really can happen.  Anyway, this is just one example.
It's not so hard to think of ways to address this one (though it gets
nontrivial quick with the coredump case).  But for me it is just an
example of why we still need to step back and think over the whole
exec picture.  

As I said, let's not conflate all that with this thread about a
relatively conservative cleanup.  We can discuss that separately.
(But I think it might need to wait for a breather and time for
other dust to settle.)


Thanks,
Roland
