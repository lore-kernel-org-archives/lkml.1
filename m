Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZFBK4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZFBK4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 06:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbZFBK4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 06:56:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48820 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbZFBK4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 06:56:11 -0400
Date: Tue, 2 Jun 2009 12:56:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk: add halt_delay parameter for printk delay in
	halt phase
Message-ID: <20090602105609.GA9182@elte.hu>
References: <a8e1da0906020254s34dd0cd9id1b88655cab6d72d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0906020254s34dd0cd9id1b88655cab6d72d@mail.gmail.com>
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

nice idea! We frequently have kernel-death warnings/messages that 
scroll off too fast and which cannot be captured.

> halt_delay default value is 0, change it by:
> 
> echo xxx > /sys/module/printk/parameters/halt_delay
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
> kernel/printk.c   |   21 +++++++++++++++++++++
> lib/Kconfig.debug |   10 ++++++++++
> 2 files changed, 31 insertions(+)
> 
> --- linux-2.6.orig/kernel/printk.c	2009-04-09 16:23:03.000000000 +0800
> +++ linux-2.6/kernel/printk.c	2009-06-02 17:45:54.000000000 +0800
> @@ -250,6 +250,26 @@ static inline void boot_delay_msec(void)
>  }
>  #endif
> 
> +#ifdef CONFIG_HALT_PRINTK_DELAY

(this #ifdef is ugly - see below.)

> +/* msecs delay after each halt/poweroff/restart phase printk */
> +static unsigned int halt_delay;
> +
> +static inline void halt_delay_msec(void)
> +{
> +	if (halt_delay == 0 || !(system_state == SYSTEM_HALT
> +				|| system_state == SYSTEM_POWER_OFF
> +				|| system_state == SYSTEM_RESTART))
> +		return;
> +
> +	mdelay(halt_delay);

>
>  	boot_delay_msec();
> +	halt_delay_msec();


i think it should be done in boot_delay_msec() and the function 
should be renamed to print_delay_msec() or so.

>  	preempt_disable();
>  	/* This stops the holder of console_sem just where we want him */
> --- linux-2.6.orig/lib/Kconfig.debug	2009-05-12 11:27:22.000000000 +0800
> +++ linux-2.6/lib/Kconfig.debug	2009-06-02 17:50:15.000000000 +0800
> @@ -647,6 +647,16 @@ config BOOT_PRINTK_DELAY
>  	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
>  	  what it believes to be lockup conditions.
> 
> +config HALT_PRINTK_DELAY
> +	bool "Delay halt/poweroff/restart printk message by N milliseconds"
> +	depends on DEBUG_KERNEL && PRINTK && SYSFS
> +	default n
> +	help
> +	  This build option allows you to read kernel messages in
> +	  halt/poweroff/restart phase by inserting a short delay after
> +	  each one.  The delay is specified in milliseconds on the
> +	  module parameter: /sys/module/printk/halt_delay.

No need for a Kconfig option - this should be an unconditional 
feature like boot-delay.

This will further simplify the patch and will get rid of that ugly 
#ifdef.

	Ingo
