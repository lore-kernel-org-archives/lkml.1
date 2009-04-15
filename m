Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZDOXOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZDOXOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZDOXOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:14:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbZDOXOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:14:37 -0400
Date: Wed, 15 Apr 2009 16:10:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Horton <zero@colonel-panic.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org
Subject: Re: [PATCH] mtd: fix timeout in M25P80 driver
Message-Id: <20090415161041.10d1aa71.akpm@linux-foundation.org>
In-Reply-To: <20090413142633.GA1560@sloth.localnet>
References: <20090413142633.GA1560@sloth.localnet>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 15:26:33 +0100
Peter Horton <zero@colonel-panic.org> wrote:

> Extend erase timeout in M25P80 SPI Flash driver.
> 
> The M25P80 drivers fails erasing sectors on a M25P128 because the ready
> wait timeout is too short. Change the timeout from a simple loop count to a
> suitable number of seconds.
> 
> Signed-off-by: Peter Horton <zero@colonel-panic.org>
> ---
> Index: linux-2.6.29-git12/drivers/mtd/devices/m25p80.c
> ===================================================================
> --- linux-2.6.29-git12.orig/drivers/mtd/devices/m25p80.c	2009-04-12 21:41:16.000000000 +0000
> +++ linux-2.6.29-git12/drivers/mtd/devices/m25p80.c	2009-04-12 21:43:01.000000000 +0000
> @@ -54,7 +54,7 @@
>  #define	SR_SRWD			0x80	/* SR write protect */
>  
>  /* Define max times to check status register before we give up. */
> -#define	MAX_READY_WAIT_COUNT	100000
> +#define	MAX_READY_WAIT_JIFFIES	(10 * HZ)	/* eg. M25P128 specs 6s max sector erase */
>  #define	CMD_SIZE		4
>  
>  #ifdef CONFIG_M25PXX_USE_FAST_READ
> @@ -145,20 +145,20 @@
>   */
>  static int wait_till_ready(struct m25p *flash)
>  {
> -	int count;
> +	unsigned long deadline;
>  	int sr;
>  
> -	/* one chip guarantees max 5 msec wait here after page writes,
> -	 * but potentially three seconds (!) after page erase.
> -	 */
> -	for (count = 0; count < MAX_READY_WAIT_COUNT; count++) {
> +	deadline = jiffies + MAX_READY_WAIT_JIFFIES;
> +
> +	do {
>  		if ((sr = read_sr(flash)) < 0)
>  			break;
>  		else if (!(sr & SR_WIP))
>  			return 0;
>  
> -		/* REVISIT sometimes sleeping would be best */
> -	}
> +		cond_resched();
> +
> +	} while (!time_after_eq(jiffies, deadline));
>  
>  	return 1;

ow, so it sits there chewing electricity for up to ten seconds.

How much time does this really take, in the real world?

It would be better to fall back to (say) msleep(1) if we find out that
the device is being slow to respond.

