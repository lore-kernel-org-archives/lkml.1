Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbYGOMch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbYGOMch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYGOMca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:32:30 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:62445 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756218AbYGOMca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:32:30 -0400
Date: Tue, 15 Jul 2008 13:32:28 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: sasa sasa <sasak.1983@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Set_up irq problem while using gpio
Message-ID: <20080715123228.GG24620@fluff.org.uk>
References: <aecf5e530807142304m60ef0cb2pe1c3592ae1abc7eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aecf5e530807142304m60ef0cb2pe1c3592ae1abc7eb@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:34:23AM +0530, sasa sasa wrote:
> Hi,
> 
> I have query that the below patch has to applied on irq/manage.c file or not.
> --- kernel_old/irq/manage.c 2008-02-07 22:11:14.000000000 +0530
> +++ kernel_new/irq/manage.c 2008-02-07 22:19:14.000000000 +0530
> @@ -349,8 +349,14 @@
>         /* Setup the type (level, edge polarity) if configured: */
>         if (new->flags & IRQF_TRIGGER_MASK) {
>             if (desc->chip && desc->chip->set_type)
> -               desc->chip->set_type(irq,
> -                       new->flags & IRQF_TRIGGER_MASK);
> +           {
> +               if((desc->chip->set_type(irq,
> +                       new->flags & IRQF_TRIGGER_MASK)))
> +               {
> +                   spin_unlock_irqrestore(&desc->lock, flags);
> +                   return -ESPIPE;
> +               }
> +           }

this is difficult to read, a better way would be to

	ret = desc->chip->set_type(irq, new->flags & IRQF_TRIGGER_MASK)
	if (ret) {
		spin_unlock_irqrestore(&desc->lock, flags);
		return ret;
	}


If set_type() is meant to return an error, this should have been done
from the start, instead of being ignored.

tbh, the code could be further cleaned up by holding 
the (new->flags & IRQF_TRIGGER_MASK in a variable such as new_trigger
which would stop the problem of wrapping lines...

> The reason is that in case of gpio pins used as interrupt pin but that
> pin has already been ocuupied in other mode (like alternate function
> mode or in software mode) by other device. In that case, some error
> mechanism must be there, if we are requesting that gpio pin as
> interrupt through request_irq function.

Hmm, I thought (when implementing the s3c24xx irq support) that
requesting the IRQ should change the pin mode appropriately.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
