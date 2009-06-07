Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbZFGOcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbZFGOcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZFGOcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:32:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZFGOcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:32:24 -0400
Date: Sun, 7 Jun 2009 16:32:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] printk: add halt_delay parameter for printk delay
	in halt phase
Message-ID: <20090607143221.GE21340@elte.hu>
References: <a8e1da0906022009q4a6cf385t83c202e79f962b12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0906022009q4a6cf385t83c202e79f962b12@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Young <hidave.darkstar@gmail.com> wrote:

> Add a halt_delay module parameter in printk.c used to read the printk
> messages in halt/poweroff/restart phase, delay each printk messages
> by halt_delay milliseconds. It is useful for debugging if there's no
> other way to dump kernel messages that time.
> 
> The halt_delay max value is 65535, default value is 0, change it by:
> 
> echo xxx > /sys/module/printk/parameters/halt_delay
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
> kernel/printk.c |   16 ++++++++++++++++
> 1 file changed, 16 insertions(+)
> 
> --- linux-2.6.orig/kernel/printk.c	2009-06-03 10:16:55.000000000 +0800
> +++ linux-2.6/kernel/printk.c	2009-06-03 10:32:43.000000000 +0800
> @@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
>  }
>  #endif
> 
> +/* msecs delay after each halt/poweroff/restart phase printk,
> +unsigned short is enough for delay in milliseconds */
> +static unsigned short halt_delay;
> +
> +static inline void halt_delay_msec(void)
> +{
> +	if (unlikely(halt_delay == 0 || !(system_state == SYSTEM_HALT
> +				|| system_state == SYSTEM_POWER_OFF
> +				|| system_state == SYSTEM_RESTART)))
> +		return;
> +
> +	mdelay(halt_delay);
> +}
> +
> +module_param(halt_delay, ushort, S_IRUGO | S_IWUSR);
> +
>  /*
>   * Commands to do_syslog:
>   *
> @@ -649,6 +665,7 @@ asmlinkage int vprintk(const char *fmt,
>  	char *p;
> 
>  	boot_delay_msec();
> +	halt_delay_msec();
> 
>  	preempt_disable();
>  	/* This stops the holder of console_sem just where we want him */

Looks nice now - but please also add a description to 
Documentation/kernel-parameters.txt.

Thanks,

	Ingo
