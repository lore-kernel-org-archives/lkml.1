Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYHFJXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYHFJXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYHFJXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:23:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:53331 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYHFJXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:23:05 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 05:23:04 EDT
X-IronPort-AV: E=Sophos;i="4.31,314,1215403200"; 
   d="scan'208";a="14799803"
Message-ID: <48996B0E.5000009@citrix.com>
Date: Wed, 06 Aug 2008 10:12:46 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Spinlock recursion in hvc_poll
References: <48973E59.1000904@citrix.com> <48987DD8.8080009@citrix.com> <48989727.8090804@goop.org> <200808052253.10285.borntraeger@de.ibm.com>
In-Reply-To: <200808052253.10285.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2008 09:13:19.0847 (UTC) FILETIME=[AB2ADF70:01C8F7A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Dienstag, 5. August 2008 schrieb Jeremy Fitzhardinge:
>> Alex Nixon wrote:
>>>>> Well I say fixed - it just means I can proceed to a spinlock recursion
>>>>> BUG() 2 secs into the boot process
> 
> Ok, this is a guess, I dont fully understand the backtrace.
> 
> request_irq tries to call the handler if the IRQ is shared. The irq handler 
> calls hvc_poll and hvc_kill which might take the same spinlock. 
> Can you test it this patch fixes the problem?

The patch appears to fix things.

- Alex

> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  drivers/char/hvc_console.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/char/hvc_console.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/hvc_console.c
> +++ linux-2.6/drivers/char/hvc_console.c
> @@ -322,10 +322,11 @@ static int hvc_open(struct tty_struct *t
>  
>  	hp->tty = tty;
>  
> +	spin_unlock_irqrestore(&hp->lock, flags);
> +
>  	if (hp->ops->notifier_add)
>  		rc = hp->ops->notifier_add(hp, hp->data);
>  
> -	spin_unlock_irqrestore(&hp->lock, flags);
>  
>  
>  	/*
> 

