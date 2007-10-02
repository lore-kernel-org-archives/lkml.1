Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbXJBSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbXJBSM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXJBSMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:12:48 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:61016 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXJBSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:12:46 -0400
Date: Tue, 2 Oct 2007 14:12:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zach Brown <zach.brown@oracle.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, mingo@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [HACK] convert i_alloc_sem for direct_io.c craziness!
In-Reply-To: <AE007B59-E6EB-4E4F-BAC4-7D49D61D1932@oracle.com>
Message-ID: <Pine.LNX.4.58.0710021407200.7829@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0709241700290.13164@gandalf.stny.rr.com>
 <20071001195256.GB7718@mami.zabbo.net> <1191271156.5574.9.camel@lappy>
 <AE007B59-E6EB-4E4F-BAC4-7D49D61D1932@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Zach!

Thanks for the responses.

--
On Tue, 2 Oct 2007, Zach Brown wrote:
>
> On Oct 1, 2007, at 1:39 PM, Peter Zijlstra wrote:
>
> >
> > On Mon, 2007-10-01 at 12:52 -0700, Zach Brown wrote:
> >
> >> Do you have any suggestions for locking constructs that RT would
> >> prefer?
> >
> > Basically, anything that maps to a simple mutex. Anything more complex
> > gets real messy real quick.
>
> I'm worried that the aio+dio implementation of concurrent pending IOs
> just doesn't map well to PI.
>
> Would a hack with a mutex and counts help at all?  It seems like it
> would still have the same problem.  The count increments don't
> transfer ownership to the count decrements and the wake up.
>
> io submission from tasks:
> 	down(&inode->i_mutex);
> 	atomic_inc(&inode->in_flight);
> 	up(&inode->i_mutex);
>
> io completion from interrupts:
> 	if(atomic_dec_and_test(&inode->in_flight))
> 		wake_up(&inode->waiting);
>
> file allocation in tasks:
> 	down(&inode->i_mutex);
> 	wait_event(inode->waiting, atomic_read(&inode->in_flight) == 0);
> 	up(&inode->i_mutex);
>
> (yeah, yeah, starvation -- it's just a demonstration)

This looks more like a completion. Actually, completions don't have PI
either, but they are usually OK.

>
> In any case, this seems like it's not a very high priority now that
> RT has Steven's work-around.  If it does become a priority can you
> guys let linux-fsdevel know?

Actually, it may still be a high priority. We have one BUG currently that
seems to trigger starvation. But we don't know yet if it's a bug in the
test or in the FS code yet.  I don't know the full details yet, but we do
have someone currently looking at it. These tests are what found this
issue in the first place.

When more info becomes available, I will definitely CC the linux-fsdevel
list. Thanks for letting me know about it. (I usually get confused by all
the different lists that are out there).

-- Steve

