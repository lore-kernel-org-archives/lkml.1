Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbYDBSI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbYDBSI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbYDBSIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:08:19 -0400
Received: from rtr.ca ([76.10.145.34]:1328 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078AbYDBSIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:08:18 -0400
Message-ID: <47F3CB91.1@rtr.ca>
Date: Wed, 02 Apr 2008 14:08:17 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, pavel@suse.cz, oliver@neukum.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@suse.cz,
       gregkh@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
References: <Pine.LNX.4.44L0.0804021244230.5042-100000@iolanthe.rowland.org> <47F3C3C0.5080705@rtr.ca>
In-Reply-To: <47F3C3C0.5080705@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Alan Stern wrote:
>> On Wed, 2 Apr 2008, Mark Lord wrote:
>>
>>> Yup, that does indeed cure it.
>>> Here's a patch, in case you didn't already generate one:
>>>
>>> Signed-off-by: Mark Lord <mlord@pobox.com>
>>>
>>> --- rc8/drivers/usb/host/ehci-hcd.c    2008-03-11 11:18:40.000000000 
>>> -0400
>>> +++ linux/drivers/usb/host/ehci-hcd.c    2008-04-02 
>>> 12:16:40.000000000 -0400
>>> @@ -289,9 +289,7 @@
>>>       * (a) SMP races against real IAA firing and retriggering, and
>>>       * (b) clean HC shutdown, when IAA watchdog was pending.
>>>       */
>>> -    if (ehci->reclaim
>>> -            && !timer_pending(&ehci->iaa_watchdog)
>>> -            && HC_IS_RUNNING(ehci_to_hcd(ehci)->state)) {
>>> +    if (ehci->reclaim && !timer_pending(&ehci->iaa_watchdog)) {
>>>          u32 cmd, status;
>>>  
>>>          /* If we get here, IAA is *REALLY* late.  It's barely
>>
>> Okay, I'm puzzled.  How could this make any difference?  
>> ehci_bus_suspend() calls end_unlink_async() anyway, whenever reclaim 
>> is set.
>>
>> Is the real problem that it does so before calling ehci_work() instead 
>> of after calling ehci_halt()?
>>
>> Mark, if you want to experiment some more, try reverting your patch 
>> above and moving:
> ..
> 
> Here's what I did, and yes, this also works.  Pick one.
> 
> This patch, suggested by Alan Stern, fixes the hung USB issues
> on my notebook from suspend/resume cycles.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> 
> --- rc8/drivers/usb/host/ehci-hub.c    2008-03-11 11:18:40.000000000 -0400
> +++ linux/drivers/usb/host/ehci-hub.c    2008-04-02 13:28:50.000000000 
> -0400
> @@ -135,8 +135,6 @@
>         hcd->state = HC_STATE_QUIESCING;
>     }
>     ehci->command = ehci_readl(ehci, &ehci->regs->command);
> -    if (ehci->reclaim)
> -        end_unlink_async(ehci);
>     ehci_work(ehci);
> 
>     /* Unlike other USB host controller types, EHCI doesn't have
> @@ -180,6 +178,9 @@
>     ehci_halt (ehci);
>     hcd->state = HC_STATE_SUSPENDED;
> 
> +    if (ehci->reclaim)
> +        end_unlink_async(ehci);
> +
>     /* allow remote wakeup */
>     mask = INTR_MASK;
>     if (!device_may_wakeup(&hcd->self.root_hub->dev))
..

Either patch is stable here, and have survived reboots and suspend/resumes,
with and without the 2.2Kohm resistor to drain residual USB voltage.

Which one should Andrew/Linus take?

-ml
