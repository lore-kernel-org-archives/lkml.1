Return-Path: <linux-kernel-owner+w=401wt.eu-S937131AbZDIWml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937131AbZDIWml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761961AbZDIWmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:42:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761466AbZDIWma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:42:30 -0400
Date: Thu, 9 Apr 2009 15:39:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Message-Id: <20090409153921.04b6384c.akpm@linux-foundation.org>
In-Reply-To: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Apr 2009 01:50:31 +0900
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> The rtc_update_irq() might be called with irqs enabled, if a interrupt
> handler was registered without IRQF_DISABLED.

Why?  What are the consequences of not merging the patch?  Is it a
bugfix?  If so, what are the user-visible effects of the bug?

See, I need to decide if this patch is needed in 2.6.30 (and earlier),
but the changelog doesn't include enough info to make that decision.

> Use spin_lock_irqsave/spin_unlock_irqrestore instead of
> spin_lock/spin_unlock.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
>  drivers/rtc/interface.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> index 4348c4b..a8641f7 100644
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -376,14 +376,16 @@ EXPORT_SYMBOL_GPL(rtc_update_irq_enable);
>  void rtc_update_irq(struct rtc_device *rtc,
>  		unsigned long num, unsigned long events)
>  {
> -	spin_lock(&rtc->irq_lock);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtc->irq_lock, flags);
>  	rtc->irq_data = (rtc->irq_data + (num << 8)) | events;
> -	spin_unlock(&rtc->irq_lock);
> +	spin_unlock_irqrestore(&rtc->irq_lock, flags);
>  
> -	spin_lock(&rtc->irq_task_lock);
> +	spin_lock_irqsave(&rtc->irq_task_lock, flags);
>  	if (rtc->irq_task)
>  		rtc->irq_task->func(rtc->irq_task->private_data);
> -	spin_unlock(&rtc->irq_task_lock);
> +	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
>  
>  	wake_up_interruptible(&rtc->irq_queue);
>  	kill_fasync(&rtc->async_queue, SIGIO, POLL_IN);

