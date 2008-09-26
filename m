Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYIZPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYIZPCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYIZPCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:02:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbYIZPCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:02:09 -0400
Date: Fri, 26 Sep 2008 08:01:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anirban Sinha <kernel@anirban.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH]: add a new wait_event_interruptible_timeout_modify
 helper
In-Reply-To: <A1326102-87D8-44AE-856F-A7E49D9E5538@anirban.org>
Message-ID: <alpine.LFD.1.10.0809260752350.3265@nehalem.linux-foundation.org>
References: <A1326102-87D8-44AE-856F-A7E49D9E5538@anirban.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Anirban Sinha wrote:
> +
> +/**
> + * wait_event_interruptible_timeout_modify - sleep until a condition gets true or a timeout elapses.
> + * @wq: the waitqueue to wait on
> + * @condition: a C expression for the event to wait for
> + * @timeout: timeout, in jiffies
> + *
> + * The process is put to sleep (TASK_INTERRUPTIBLE) until the
> + * @condition evaluates to true or a signal is received.
> + * The @condition is checked each time the waitqueue @wq is woken up.
> + *
> + * wake_up() has to be called after changing any variable that could
> + * change the result of the wait condition.
> + *
> + * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
> + * was interrupted by a signal, and the remaining jiffies otherwise
> + * if the condition evaluated to true before the timeout elapsed.
> + * It also modifies the @timeout value so that if the sleep is interrupted
> + * by a signal, the caller can call this helper again with the updated
> + * timeout.

Grr.

I'd _much_ rather just have a

	wait_event_interruptible_until(wr, condition, abs_timeout)

where the timeout is just given as an end value, and the user can just 
pre-calculate it once and the return code handling is simpler (either 
"success" or "EINTR").

Giving an absolute value also means that there is no rounding creep or 
anything like that in a loop, which otherwise happens very easily (even 
if we wouldn't normally really care).

And quite frankly, people can do that themselves even without a helper 
function, with simply

	unsigned long end = jiffies + timeout;
	...

	rc = wait_event_interruptible_timeout(wq, event, end - jiffies);
	if (rc < 0)
		goto out;

and now you always know the end-point, and 'end - jiffies' is always the 
remaining timeout.

		Linus
