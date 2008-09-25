Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYIYQjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYIYQjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbYIYQjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:39:15 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:54057 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbYIYQjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:39:14 -0400
Date: Thu, 25 Sep 2008 20:45:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ani Sinha <kernel@anirban.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: wait_event_interruptible_timeout
Message-ID: <20080925164517.GA194@tv-sign.ru>
References: <13c67e2c0809242105t77ca9a6k2faf1e85064967aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13c67e2c0809242105t77ca9a6k2faf1e85064967aa@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Ani Sinha wrote:
>
> I have noticed an issue with wait_event_interruptible_timeout() API
> which I will try to explain below:
>
> wait_event_interruptible_timeout() is supposed to wait until one of
> the following happens:
>
> (a)    Timeout occurs (with no signals or the event of interest
> happening), in which case it returns 0
>
> (b)   The process receives a signal and wakes up prematurely (i.e.,
> before its timeout expired or the event of interest occurred). In this
> case, it returns ?ERESTARTSYS. I will come back to this later.
>
> (c)    Of course, the last obvious way to wake up is that the event of
> interest occurs and it wakes up all (or one) process on the wait
> queue. In that case, it returns the # of jiffies that is left before
> the timeout would have occurred (unslept or balance jiffies).
>
>
> What if I really wanted to sleep for timeout interval and no more?
> That is to say, if I wake up on a signal and I wanted to know how many
> jiffies I did used up while sleeping and how many I am left with (just
> like poll or select does)?

You can read jiffies before and after wait_event_interruptible_timeout().

> That way,  when I retry the API, I can tell
> it to sleep only by the amount of my balance sleeping time.

Something like

	unsigned long now = jiffies;
	ret = wait_event_interruptible_timeout(..., timeout);
	if (ret < 0) {
		next_timeout = now + timeout - jiffies;
		if (next_timeout < 0)
			next_timeout = 0;
	}

We can even add another wait_ helper which treats "timeout" as lvalue
and updates it before return. I dunno.

> Unfortunately, the interface looses this information since it
> overrides the return value with ERESTARTSYS.

Yes you are right, but

> I feel there is a need to
> modify the code in order to correct this behavior.

I'm afraid it would be a pain to modify this API. But please
do not hesitate to make the patch if you think the current API
can be improved. At worst, the patch will be nacked ;)

Oleg.

