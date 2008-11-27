Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYK0AJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYK0AJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYK0AJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:09:07 -0500
Received: from www.tglx.de ([62.245.132.106]:54613 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbYK0AJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:09:06 -0500
Date: Thu, 27 Nov 2008 01:08:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <johnstul@us.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Enforce valid shift values in clocksource_register()
In-Reply-To: <1227743196.18967.36.camel@jstultz-laptop>
Message-ID: <alpine.LFD.2.00.0811270105270.3325@localhost.localdomain>
References: <1227743196.18967.36.camel@jstultz-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, John Stultz wrote:

> Thomas noted that some of the timekeeping core assumes 
> clocksource shift values will be less then 32. However, 
> we do nothing to enforce such limits.
> 
> This patch prints a warning if a clocksource with an invalid
> shift value is attempted to be registered, and will refuse to
> register the clocksource
> 
> I could not find any clocksources that use 32 or higher for a 
> shift value, so this should be only a preventive warning for
> future clocksource writers.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 9ed2eec..4a3bb13 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -318,7 +318,7 @@ static int clocksource_enqueue(struct clocksource *c)
>   * clocksource_register - Used to install new clocksources
>   * @t:		clocksource to be registered
>   *
> - * Returns -EBUSY if registration fails, zero otherwise.
> + * Returns -EBUSY or -EINVAL if registration fails, zero otherwise.
>   */
>  int clocksource_register(struct clocksource *c)
>  {
> @@ -327,7 +327,14 @@ int clocksource_register(struct clocksource *c)
>  
>  	/* save mult_orig on registration */
>  	c->mult_orig = c->mult;
> -
> +	if (c->shift >= 32) {
> +		printk(KERN_WARNING "===============================\n");
> +		printk(KERN_WARNING "WARNING: Cannot register %s clocksource\n",
> +					c->name);
> +		printk(KERN_WARNING "The shift value must be less then 32\n");
> +		printk(KERN_WARNING "===============================\n");
> +		return -EINVAL;

Just setting the shift value to 31 along with a WARN_ON() should be
enough. We don't need to kill the clocksource in that case, as this
can be nasty when it happens in the early boot code where we dont have
any output.

Thanks,

	tglx
