Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXCAPEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXCAPEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965160AbXCAPEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:04:51 -0500
Received: from p02c11o142.mxlogic.net ([208.65.145.65]:52055 "EHLO
	p02c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965158AbXCAPEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:04:50 -0500
X-Greylist: delayed 960 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 10:04:49 EST
Subject: Re: wait_for_completion_timeout problem ???
From: Eli Cohen <eli@mellanox.co.il>
Reply-To: eli@mellanox.co.il
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0703010628u253a62cfi56cec22a1ee79d5f@mail.gmail.com>
References: <1172755932.5175.37.camel@mtls03>
	 <b647ffbd0703010628u253a62cfi56cec22a1ee79d5f@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Mellanox Technologies
Date: Thu, 01 Mar 2007 16:49:34 +0200
Message-Id: <1172760574.5175.42.camel@mtls03>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
X-OriginalArrivalTime: 01 Mar 2007 14:52:01.0156 (UTC) FILETIME=[2B278C40:01C75C11]
X-Spam: [F=0.0100000000; S=0.010(2007010901)]
X-MAIL-FROM: <eli@mellanox.co.il>
X-SOURCE-IP: [63.251.237.3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 15:28 +0100, Dmitry Adamushko wrote:
> Hi,
> 
> >
> > I have a problem with using this function. I am referring to
> > drivers/infiniband/hw/mthca/mthca_cmd.c line 394. For convenience I
> > quote from this code:
> >
> >         init_completion(&context->done);
> >
> >         err = mthca_cmd_post(dev, in_param,
> >                              out_param ? *out_param : 0,
> >                              in_modifier, op_modifier,
> >                              op, context->token, 1);
> >         if (err)
> >                 goto out;
> >
> >         if (!wait_for_completion_timeout(&context->done, timeout)) {
> >                 err = -EBUSY;
> >                 goto out;
> >         }
> >
> > timeout is 10 * HZ. Sometimes this function returns 0 which signifies
> > timeout. However I can see that the interrupt handler called
> > complete(&context->done)
> > around 200 usec after calling wait_for_completion_timout(). When the
> > function returns I can see that context->done.done equals 1 which
> > confirms that complete was indeed called.
> 
> The sequence of events can be as follows:
> 
> a caller gets blocked in wait_for_completion_timeout() on
> schedule_timeout() which literally means:
> 
>    i ) will be unblocked (scheduled back) after "timeout" has expired;
> 
>    ii) will be unblocked by someone calling wake_up_*(&x->wait);
> 
> (wait_for_completion_timeout() inserted our caller into "x->wait" wait queue)
> 
> in both cases schedule_timeout() will do
> 
> ...
>         schedule(); <------------------ here we get CPU back
>         del_singleshot_timer_sync(&timer);
>         timeout = expire - jiffies;
> 
>  out:
>         return timeout < 0 ? 0 : timeout;
> 
> "expire" is when (+latency) we were expected to be woken up by a
> timeer -> timeout.
> 
> Now the point is that our waiter could have been "waken up" (become
> "ready" from the point of view of the scheduler) earlier but it was
> just "scheduled" (got CPU back) later than "expire" so that's why the
> return value is 0 (timeout < 0 ==> return 0).
> 
> IOW, schedule_timeout() indicates whether a process has been scheduled
> back /earlier than timeout/ (so return value >0) or /later/ (0).
> 
> It doesn't indicate why the process has been woked up ( i.e. (i) or
> (ii) above ).
> 
> In you case it became /runnable/ because of complete() but it got
> scheuled later than /timeout/.
> 
> And wait_for_completion_timeout() takes it as a /timeout condition/.
> 
> So either all the users of wait_for_completion_timeout() should
> additionally check for x->done after they got scheduled
There is only one process waiting on the completion object.
> 
> or
> 
> wait_for_completion_timeout() should return something different that
> encodes the fact /event happened/ and not just /event happened _and_ a
> caller has got scheduled back earlier than timeout.
That possibility crossed my mind but I ruled it out since the the
timeout is 10 sec while completion arrived less then 4 msec after
calling wait_for_completion_timeout(). So it appears to me unlikely that
it will the task will be in the run list but will not get CPU time for
nearly 10 seconds. I will give it a try though. I will increase timeout
to 20 sec.

> 
> 
> 
> >
> > Thanks
> > Eli
> 
