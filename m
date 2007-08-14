Return-Path: <linux-kernel-owner+w=401wt.eu-S938444AbXHNFhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938444AbXHNFhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934359AbXHNFgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:36:37 -0400
Received: from www.osadl.org ([213.239.205.134]:38065 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936507AbXHNFgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:36:35 -0400
Subject: Re: [PATCH] hres_timers_resume must block interrupts
From: Thomas Gleixner <tglx@linutronix.de>
To: Joe Korty <joe.korty@ccur.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070813232626.GA24938@tsunami.ccur.com>
References: <20070813232626.GA24938@tsunami.ccur.com>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 07:36:30 +0200
Message-Id: <1187069790.12828.131.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 19:26 -0400, Joe Korty wrote:
> Retrigger_next_event() must be called with interrupts disabled.
> 
> All internal (to hrtimer.c) uses of retrigger_next_event() are correct.
> But the version exported to other files, hres_timers_resume(), does not
> do the IRQ blocking, nor does the (single) external caller of it.
> 
> Rather than require that users of hres_timers_resume() do the IRQ blocking,
> this patch makes the blocking part of the hres_timers_resume() functionality.

Ack.

> (Also remove the meaningless WARN_ON_ONCE() call in hres_timers_resume)

It's not that meaningless. It catched a resume order problem some time
ago.

	tglx

> Signed-off-by: Joe Korty (joe.korty@ccur.com)
> 
> Index: 2.6.23-rc3/kernel/hrtimer.c
> ===================================================================
> --- 2.6.23-rc3.orig/kernel/hrtimer.c	2007-08-13 18:30:09.000000000 -0400
> +++ 2.6.23-rc3/kernel/hrtimer.c	2007-08-13 18:38:48.000000000 -0400
> @@ -463,10 +463,11 @@
>   */
>  void hres_timers_resume(void)
>  {
> -	WARN_ON_ONCE(num_online_cpus() > 1);
> +	unsigned long flags;
>  
> -	/* Retrigger the CPU local events: */
> +	local_irq_save(flags);
>  	retrigger_next_event(NULL);
> +	local_irq_restore(flags);
>  }
>  
>  /*
> 

