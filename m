Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbXJ1Qye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbXJ1Qye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbXJ1Qy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:54:27 -0400
Received: from www.tglx.de ([62.245.132.106]:37617 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJ1Qy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:54:26 -0400
Date: Sun, 28 Oct 2007 17:54:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize i8259 code a bit.
In-Reply-To: <20071028231145.GA9515@linux-mips.org>
Message-ID: <alpine.LFD.0.9999.0710281753000.3186@localhost.localdomain>
References: <20071028231145.GA9515@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Ralf Baechle wrote:

> The timer code always calls the clock_event_device set_net_event and
> set_mode methods with interrupts disabled, so no need to use
> spin_lock_irqsave / spin_unlock_irqrestore for those.

Good point,

Acked-by:Thomas Gleixner <tglx@linutronix.de>


> diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
> index 5d9830d..1b54674 100644
> --- a/arch/mips/kernel/i8253.c
> +++ b/arch/mips/kernel/i8253.c
> @@ -23,9 +23,7 @@ static DEFINE_SPINLOCK(i8253_lock);
>  static void init_pit_timer(enum clock_event_mode mode,
>  			   struct clock_event_device *evt)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&i8253_lock, flags);
> +	spin_lock(&i8253_lock);
>  
>  	switch(mode) {
>  	case CLOCK_EVT_MODE_PERIODIC:
> @@ -54,7 +52,7 @@ static void init_pit_timer(enum clock_event_mode mode,
>  		/* Nothing to do here */
>  		break;
>  	}
> -	spin_unlock_irqrestore(&i8253_lock, flags);
> +	spin_unlock(&i8253_lock);
>  }
>  
>  /*
> @@ -64,12 +62,10 @@ static void init_pit_timer(enum clock_event_mode mode,
>   */
>  static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&i8253_lock, flags);
> +	spin_lock(&i8253_lock);
>  	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
>  	outb(delta >> 8 , PIT_CH0);	/* MSB */
> -	spin_unlock_irqrestore(&i8253_lock, flags);
> +	spin_unlock(&i8253_lock);
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
> index a42c807..5246515 100644
> --- a/arch/x86/kernel/i8253.c
> +++ b/arch/x86/kernel/i8253.c
> @@ -31,9 +31,7 @@ struct clock_event_device *global_clock_event;
>  static void init_pit_timer(enum clock_event_mode mode,
>  			   struct clock_event_device *evt)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&i8253_lock, flags);
> +	spin_lock(&i8253_lock);
>  
>  	switch(mode) {
>  	case CLOCK_EVT_MODE_PERIODIC:
> @@ -62,7 +60,7 @@ static void init_pit_timer(enum clock_event_mode mode,
>  		/* Nothing to do here */
>  		break;
>  	}
> -	spin_unlock_irqrestore(&i8253_lock, flags);
> +	spin_unlock(&i8253_lock);
>  }
>  
>  /*
> @@ -72,12 +70,10 @@ static void init_pit_timer(enum clock_event_mode mode,
>   */
>  static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&i8253_lock, flags);
> +	spin_lock(&i8253_lock);
>  	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
>  	outb(delta >> 8 , PIT_CH0);	/* MSB */
> -	spin_unlock_irqrestore(&i8253_lock, flags);
> +	spin_unlock(&i8253_lock);
>  
>  	return 0;
>  }
> 
