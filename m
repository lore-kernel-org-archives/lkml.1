Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0BHWH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:07:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab0BHWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:07:25 -0500
Date: Mon, 8 Feb 2010 14:06:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] printk delay for each line break instead of
 callback
Message-Id: <20100208140648.3c38d909.akpm@linux-foundation.org>
In-Reply-To: <20100206133425.GA2562@darkstar>
References: <20100206133425.GA2562@darkstar>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Feb 2010 21:34:25 +0800
Dave Young <hidave.darkstar@gmail.com> wrote:

> printk delay for every callback does not make sense, change to delay every line
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
> 
>  kernel/printk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.orig/kernel/printk.c	2010-02-02 13:38:47.646659531 +0800
> +++ linux-2.6/kernel/printk.c	2010-02-02 13:39:19.446657319 +0800
> @@ -678,7 +678,6 @@ asmlinkage int vprintk(const char *fmt, 
>  	char *p;
>  
>  	boot_delay_msec();
> -	printk_delay();
>  
>  	preempt_disable();
>  	/* This stops the holder of console_sem just where we want him */
> @@ -746,6 +745,7 @@ asmlinkage int vprintk(const char *fmt, 
>  	 */
>  	for ( ; *p; p++) {
>  		if (new_text_line) {
> +			printk_delay();
>  			/* Always output the token */
>  			emit_log_char('<');
>  			emit_log_char(current_log_level + '0');

This moves the printk_delay() so that it is now inside
spin_lock_irqsave(logbuf_lock).

This fixes the race I mentioned in the previous email, but it seems a
bad idea.  If the delay is long enough, it could even cause other CPUs
to get hit by the NMI watchdog when trying to acquire logbuf_lock.

A better approach would be to perform the calculation of "how long must
I delay" at this site, but perform the actual delay later, after the
raw_local_irq_restore().  This means that if the printk contains
"a\nb\nc\n" then we won't delay until the final \n, but that seems a
fairly small problem.


