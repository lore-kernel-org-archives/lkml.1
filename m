Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab0BPRWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:22:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39237 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0BPRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:22:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i4GmCS6Bi3q8wfXgW1bm2l8RdfPBoVpRo63HHbIjLrM1kuZ/mqezWquTer2IrU+spH
         dGynsQRp8LW8jbzn/gEQcr7K7XyMcDDbzkBajnEPcKjzGM+jhlMEZsbXCudLkkHrLXM/
         aFvoLMGhA0IYzvVwN/vmgY9+XtPUXO4IVpCmQ=
Date: Tue, 16 Feb 2010 09:22:33 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: serio - re-add thaw (and add freeze)
Message-ID: <20100216172233.GA14229@core.coreip.homeip.net>
References: <4B69C7AA.7000904@tuffmail.co.uk>
 <20100203191112.GC30600@core.coreip.homeip.net>
 <4B6A9FD7.5040207@tuffmail.co.uk>
 <9b2b86521002160848q3e75d02aqe432376de2a5b732@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86521002160848q3e75d02aqe432376de2a5b732@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 04:48:30PM +0000, Alan Jenkins wrote:
> On 2/4/10, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
> > Dmitry Torokhov wrote:
> >> On Wed, Feb 03, 2010 at 06:59:54PM +0000, Alan Jenkins wrote:
> >>
> >>> 633aae2 "Input: i8042 - switch to using dev_pm_ops"
> >>> removed handling for PMSG_THAW, causing obscure breakage.
> >>>
> >>> It can break if you press keys during hibernation,
> >>> which causes subsequent keypresses to be lost -
> >>> so you can't cancel s2disk by pressing backspace -
> >>> and then just before system poweroff you get
> >>> "psmouse.c: Failed to deactivate mouse".
> >>>
> >>> So let's add the thaw handler back.
> >>>
> >>> Also set the freeze handler.  It looks like PMSG_FREEZE
> >>> didn't do anything in the past, but I think that must
> >>> have been an oversight.
> >>>
> >>
> >> We do not need to do anything special at freeze time that is why there
> >> wasn't freeze handler. And so thaw should be pretty much noop as well.
> 
> Ok, so I did some more mindless fiddling.  It seems that all it needs
> is to call the interrupt handler at thaw time.
> 

Yep, this makes more sense. If you happen to press the key(s) while
interrupts are off the keyboard controller becomes "jammed". Your sign
off please?

> Regards
> Alan
> 
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index d84a36e..b54aee7 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -1161,9 +1161,17 @@ static int i8042_pm_restore(struct device *dev)
>  	return 0;
>  }
> 
> +static int i8042_pm_thaw(struct device *dev)
> +{
> +	i8042_interrupt(0, NULL);
> +
> +	return 0;
> +}
> +
>  static const struct dev_pm_ops i8042_pm_ops = {
>  	.suspend	= i8042_pm_reset,
>  	.resume		= i8042_pm_restore,
> +	.thaw		= i8042_pm_thaw,
>  	.poweroff	= i8042_pm_reset,
>  	.restore	= i8042_pm_restore,
>  };

-- 
Dmitry
