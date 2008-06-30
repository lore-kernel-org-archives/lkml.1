Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYF3DJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYF3DJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 23:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYF3DJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 23:09:29 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:24996 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750877AbYF3DJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 23:09:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kJ4+5fi56CoEJrzmIqgor1W/vVrOf4v/k1zhNs/FrQGn2yAAV0HxZWmavmzAL4mCAwtU+r5JCmCIL3Qe0MzfDrmxIQSRNvV6WmVrWs6B6FvHzJT4UYyvz7wodjTb645/oDhqggXZHFvsU6Gd0siq8yfchXAK88GpYFhzPdAYBXw=  ;
X-YMail-OSG: m2nb1hYVM1nHGjHXd_Dychrz7kbgPTtBeeHLHtygfinS9KkSVNV7RzaypSN21w19Q2_Tiejd1XxG4aY7FtPAm1uTg481WWzex4z6rtUfjoBsESQnGzaTVgdovRRzZL.CssM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stefan Becker <Stefan.Becker@nokia.com>
Subject: Re: PATCH: 2.6.26-rc8: Fix IRQF_DISABLED for shared interrupts
Date: Sun, 29 Jun 2008 20:09:26 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       ext Alan Stern <stern@rowland.harvard.edu>
References: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org> <200806281251.21299.david-b@pacbell.net> <4867A2DE.3070509@nokia.com>
In-Reply-To: <4867A2DE.3070509@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806292009.26975.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 June 2008, Stefan Becker wrote:
> The problem is caused by this code in handle_IRQ_event():
> 
>         if (!(action->flags & IRQF_DISABLED))
>                 local_irq_enable_in_hardirq();
> 
>         do {
>                 ret = action->handler(irq, action->dev_id);
>          ...
>                 action = action->next;
>         } while (action);
> 
> For shared interrupts IRQF_DISABLED will only take effect if the first 
> registered handler sets it.

I was suspecting something rude like that ...

By the way, did you notice the oddness of IRQF_SAMPLE_RANDOM there?
For a shared IRQ, I would rather think that if any IRQ was flagged
as "too predictable for use as IRQ randomness" (by not having that
flag set) then the IRQ should never be sampled ... there's some odd
thought (or non-thought) involved in IRQ sharing.


> The attached changes fix the problem for me.

And it looks plausible to me.  Seems like this patch (or a variant)
should be merged for 2.6.26-final, yes?  Disregarding IRQF_DISABLED
has -- as you noted -- significant potential for oopsage.

I suggest you provide a fully cleaned-up version of this patch with
your signed-off-by line and a proper patch description ... do this
ASAP, since RC8 is getting a bit late for patches to merge!


One technical comment:

> --- a/kernel/irq/internals.h
> +++ b/kernel/irq/internals.h
> @@ -2,6 +2,13 @@
>   * IRQ subsystem internal functions and variables:
>   */
>  
> +/*
> + * Internal interrupt flags
> + *
> + * IRQF_DISABLED_CUMULATIVE - one handler in the chain has IRQF_DISABLED
> set + */
> +#define IRQF_DISABLED_CUMULATIVE       0x80000000
> +
>  extern int noirqdebug;
>  
>  /* Set default functions for irq_chip structures: */

I don't think you should need that flag; and if you did, it should be
declared in <linux/irq.h> to prevent anyone else from using that bit
for some other purpose.

Instead, I think you can set IRQF_DISABLED in irq_desc[irq].status
to achieve the same effect.

- Dave

