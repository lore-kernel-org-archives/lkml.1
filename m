Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbZDQHZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbZDQHZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZDQHYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:24:49 -0400
Received: from smtp.nokia.com ([192.100.122.230]:31640 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084AbZDQHYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:24:48 -0400
Subject: Re: [PATCH] mtd: fix timeout in M25P80 driver
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Peter Horton <zero@colonel-panic.org>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090413142633.GA1560@sloth.localnet>
References: <20090413142633.GA1560@sloth.localnet>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Apr 2009 10:24:20 +0300
Message-Id: <1239953060.3390.239.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Apr 2009 07:24:22.0541 (UTC) FILETIME=[878DA3D0:01C9BF2D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 15:26 +0100, Peter Horton wrote:
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
Why did you remove the comment? Is it wrong or useless?

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
>  }

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

