Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313Ab0AURbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0AURbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346Ab0AURbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:31:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0AURbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:31:44 -0500
X-Authority-Analysis: v=1.0 c=1 a=LvvgB44tUwgA:10 a=7U3hwN5JcxgA:10 a=Inz39NyLQJO6Pg41jRYA:9 a=lJmB3rpkmu89hkJB8C8A:7 a=i5e5PbsV7znP5mbP0sGcOwBAgRUA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Julia Lawall <julia@diku.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <Pine.LNX.4.64.1001211145480.13529@ask.diku.dk>
References: <1263932978.31321.53.camel@gandalf.stny.rr.com>
	 <Pine.LNX.4.64.1001192155490.28583@ask.diku.dk>
	 <1263935333.4561.26.camel@frodo>
	 <Pine.LNX.4.64.1001211145480.13529@ask.diku.dk>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 12:31:34 -0500
Message-ID: <1264095094.31321.283.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:47 +0100, Julia Lawall wrote:
> What about something like the following (drivers/macintosh/adb.c):
> 
>         add_wait_queue(&state->wait_queue, &wait);
>         current->state = TASK_INTERRUPTIBLE;
> 
> 	for (;;) {
> 	        req = state->completed;
>                 if (req != NULL)
>                         state->completed = req->next;
>                 else if (atomic_read(&state->n_pending) == 0)
>                         ret = -EIO;
> 		if (req != NULL || ret != 0)
> 			break;
> 
>                 if (file->f_flags & O_NONBLOCK) {
>                         ret = -EAGAIN;
>                         break;
> 		}
>                 if (signal_pending(current)) {
>                         ret = -ERESTARTSYS;
>                         break;
>                 }
>                 spin_unlock_irqrestore(&state->lock, flags);
>                 schedule();
>         	spin_lock_irqsave(&state->lock, flags);
>         }
> 
>         current->state = TASK_RUNNING;
>         remove_wait_queue(&state->wait_queue, &wait);
> 
> There is a call to schedule eventually after the first current->state 
> assignment, but it is not right after.

I looked at this code in a bit more detail. Seems that it does not need
the set_current_state(), because all activities between the state of the
task and the variables being checked (state->n_pending, et al) are under
the state->lock.

But there should be a comment stating that above the assignment of
current->state. Something like:

	/*
	 * No need for the set_current_state() memory barrier since
	 * all checks between state and wakeups are done under the
	 * state->lock.
	 */
	current->state = TASK_INTERRUPTIBLE;


But I'd rather have the author of this code write that.

-- Steve




