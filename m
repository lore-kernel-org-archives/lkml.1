Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYEXOLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYEXOLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYEXOLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:11:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33052 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYEXOLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:11:39 -0400
Subject: Re: [PATCH 5/5] remove the extra call to try_to_take_lock
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu, tglx@linutronix.de,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <4837539F.BA47.005A.0@novell.com>
References: <20080520143954.15992.85900.stgit@novell1.haskins.net>
	 <20080520144936.15992.48894.stgit@novell1.haskins.net>
	 <Pine.LNX.4.58.0805232301080.12686@gandalf.stny.rr.com>
	 <4837539F.BA47.005A.0@novell.com>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Sat, 24 May 2008 08:11:28 -0600
Message-Id: <1211638288.9707.12.camel@hermosa.morrealenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 23:30 -0400, Gregory Haskins wrote:
> >>> On Fri, May 23, 2008 at 11:02 PM, in message
> <Pine.LNX.4.58.0805232301080.12686@gandalf.stny.rr.com>, Steven Rostedt
> <rostedt@goodmis.org> wrote: 
> 
> > On Tue, 20 May 2008, Gregory Haskins wrote:
> > 
> >> From: Peter W. Morreale <pmorreale@novell.com>
> >>
> >> Remove the redundant attempt to get the lock.  While it is true that the
> >> exit path with this patch adds an un-necessary xchg (in the event the
> >> lock is granted without further traversal in the loop) experimentation
> >> shows that we almost never encounter this situation.
> >>

I should have made this more descriptive to eliminate the confusion. 

Lock stealing, upon entry to *slowlock(), almost never happens.  By
almost I mean out of ~2+M locks, only 10s of locks were granted from the
original redundant attempt. (From manual instrumentation)  I do not have
exact numbers.

Best,
-PWM
   
> >> Signed-off-by: Peter W. Morreale <pmorreale@novell.com>
> >> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> >> ---
> >>
> >>  kernel/rtmutex.c |    6 ------
> >>  1 files changed, 0 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> >> index ec1f7d4..1da7813 100644
> >> --- a/kernel/rtmutex.c
> >> +++ b/kernel/rtmutex.c
> >> @@ -785,12 +785,6 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
> >>  	spin_lock_irqsave(&lock->wait_lock, flags);
> >>  	init_lists(lock);
> >>
> >> -	/* Try to acquire the lock again: */
> >> -	if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL)) {
> >> -		spin_unlock_irqrestore(&lock->wait_lock, flags);
> >> -		return;
> >> -	}
> >> -
> > 
> > This would suggested that lock stealing doesn't happen. On lock stealing,
> > this is the condition that is triggered and we have a nice quick exit.
> 
> Its not that we are saying it doesn't happen.  Rather, we are saying the overhead of exiting from the second call (and only remaining call after this patch) is not as significant as it would seem on paper (based on empirical data).  In essence, it adds an xchg to the steal-case which is not "great", but....
> 
> ..conversely, if the first test fails, the second test will *always* fail (since the lock->wait_lock is held across both).  This extra overhead actually *does* result in a measurable degradation of performance in our testing.
> 
> Another way to write the patch is to do more of a "do/while" style with the try_to_take is done later in the loop.  You could then retain the fast-path exit in that case.  I actually wrote a patch like that at one point, but I think Peter's here was faster.  I don't recall the reason why that was off the top of my head, but I remember I dropped my patch in favor of his because of the difference.
> 
> Regards,
> -Greg
> 
> > 
> > -- Steve
> > 
> > 
> > 
> >>  	BUG_ON(rt_mutex_owner(lock) == current);
> >>
> >>  	/*
> >>
> 
> 

