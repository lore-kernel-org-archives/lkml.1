Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbXGXCJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbXGXCJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 22:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbXGXCIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 22:08:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:44085 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbXGXCIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 22:08:55 -0400
Date: Mon, 23 Jul 2007 19:07:37 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <20070720141529.GA218@tv-sign.ru>
Message-ID: <Pine.LNX.4.63.0707231858420.9759@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
 <1184662429.12353.426.camel@chaos> <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
 <1184703427.12353.476.camel@chaos> <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
 <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain>
 <20070718161156.GA761@tv-sign.ru> <Pine.LNX.4.63.0707181203110.3157@localhost.localdomain>
 <20070720141529.GA218@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 24 Jul 2007 02:07:38.0195 (UTC) FILETIME=[6898D230:01C7CD97]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Oleg Nesterov wrote:

> On 07/18, Jeremy Katz wrote:
>>
>> On Wed, 18 Jul 2007, Oleg Nesterov wrote:
>>
>>> Jeremy, I agree with Thomas that your patch should not be right, but it
>>> does make a difference. Perhaps this is just the timing, but who knows.
>>> Could you add some printk's to be sure that lock_timer() actually fails
>>> while it never should?
>>
>> Agreed.
>>
>> Unfortunately, adding any significant output appears to alter the
>> situation to the point where the issue either does not occur, or takes
>> significantly longer to surface.
>
> No, no, I didn't mean any significant output. You changed itimer_delete()
>
> 	>  -       spin_lock_irqsave(&timer->it_lock, flags);
> 	>  +       /* timer already deleted? */
> 	>  +       if (lock_timer(timer->it_id, &flags) == NULL)
> 	>  +               return;
>
> This change should not help, lock_timer() should always succeed here.
> But since it makes a difference, we can make something like
>
> 	if (lock_timer(timer->it_id, &flags) == NULL) {
> 		printk("Impossible! but it happened.\n");
> 		return;
> 	}
>
> The same for posix_timer_fn().

Ahh, of course.  I did try that at some point, and remember seeing at 
least the occasional failure.  This time, taking the spinlock and then 
checking for a valid timer ID, I did not see the locking fail.  I did see 
the attempt to use a freed sigqueue, further suggesting my 'fix' merely 
altered the timing sufficiently to hide the issue.

> I still can't believe we have a double-free problem, this looks imposiible.
> Do you see the
>
> 	"idr_remove called for id=%d which is not allocated.\n"
>
> in syslog?

No.  I also added some accounting with atomic counters, and don't see 
evidence of a second call to release_posix_timer.

> Could you try the patch below? Perhaps we have some wierd problem with
> ->sigq corruption.

Tried, with apparent effect.

To add to the body of data: Turning off hyperthreading in the hardware 
does not resolve the issue.  Limiting the system to one CPU does appear to 
work.


Jeremy
