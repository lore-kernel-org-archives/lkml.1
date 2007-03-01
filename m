Return-Path: <linux-kernel-owner+w=401wt.eu-S965088AbXCAO2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbXCAO2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965094AbXCAO2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:28:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:9507 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965088AbXCAO2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HfCw4w2teAeO3BHXdFqB71qGg7j6h5ULWsel8intuMaLc4LJ0OqZ0xzNqZuGV1KVW570+0F7zlN4dEDHEC1EXP8iKDyzPJb/x7cVL29ze4+GIwlV8HHM7RTbApVMR3ZqHVgePFFAqWtL15N+XyaFzX1+ckayBBa01a4FruFWC5M=
Message-ID: <b647ffbd0703010628u253a62cfi56cec22a1ee79d5f@mail.gmail.com>
Date: Thu, 1 Mar 2007 15:28:40 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: eli@mellanox.co.il
Subject: Re: wait_for_completion_timeout problem ???
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1172755932.5175.37.camel@mtls03>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172755932.5175.37.camel@mtls03>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>
> I have a problem with using this function. I am referring to
> drivers/infiniband/hw/mthca/mthca_cmd.c line 394. For convenience I
> quote from this code:
>
>         init_completion(&context->done);
>
>         err = mthca_cmd_post(dev, in_param,
>                              out_param ? *out_param : 0,
>                              in_modifier, op_modifier,
>                              op, context->token, 1);
>         if (err)
>                 goto out;
>
>         if (!wait_for_completion_timeout(&context->done, timeout)) {
>                 err = -EBUSY;
>                 goto out;
>         }
>
> timeout is 10 * HZ. Sometimes this function returns 0 which signifies
> timeout. However I can see that the interrupt handler called
> complete(&context->done)
> around 200 usec after calling wait_for_completion_timout(). When the
> function returns I can see that context->done.done equals 1 which
> confirms that complete was indeed called.

The sequence of events can be as follows:

a caller gets blocked in wait_for_completion_timeout() on
schedule_timeout() which literally means:

   i ) will be unblocked (scheduled back) after "timeout" has expired;

   ii) will be unblocked by someone calling wake_up_*(&x->wait);

(wait_for_completion_timeout() inserted our caller into "x->wait" wait queue)

in both cases schedule_timeout() will do

...
        schedule(); <------------------ here we get CPU back
        del_singleshot_timer_sync(&timer);
        timeout = expire - jiffies;

 out:
        return timeout < 0 ? 0 : timeout;

"expire" is when (+latency) we were expected to be woken up by a
timeer -> timeout.

Now the point is that our waiter could have been "waken up" (become
"ready" from the point of view of the scheduler) earlier but it was
just "scheduled" (got CPU back) later than "expire" so that's why the
return value is 0 (timeout < 0 ==> return 0).

IOW, schedule_timeout() indicates whether a process has been scheduled
back /earlier than timeout/ (so return value >0) or /later/ (0).

It doesn't indicate why the process has been woked up ( i.e. (i) or
(ii) above ).

In you case it became /runnable/ because of complete() but it got
scheuled later than /timeout/.

And wait_for_completion_timeout() takes it as a /timeout condition/.

So either all the users of wait_for_completion_timeout() should
additionally check for x->done after they got scheduled

or

wait_for_completion_timeout() should return something different that
encodes the fact /event happened/ and not just /event happened _and_ a
caller has got scheduled back earlier than timeout.



>
> Thanks
> Eli

-- 
Best regards,
Dmitry Adamushko
