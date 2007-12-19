Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbXLSTX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbXLSTX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXLSTXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:23:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:51676 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbXLSTXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:23:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,185,1196668800"; 
   d="scan'208";a="345351625"
Message-ID: <47696AC9.90204@intel.com>
Date: Wed, 19 Dec 2007 11:02:33 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: parag.warudkar@gmail.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] e1000: Use deferrable timer for watchdog
References: <Pine.LNX.4.64.0712182040470.3616@mini.warudkars.net>
In-Reply-To: <Pine.LNX.4.64.0712182040470.3616@mini.warudkars.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2007 19:03:12.0873 (UTC) FILETIME=[CDA1CD90:01C84271]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> 
> Use deferrable timer for watchdog. Reduces wakeups from idle per second.


no, we don't want this. We already allow the re-scheduling of the watchdog to be
round_jiffies() modified so that it coincides with other interrupts.

but at load time we don't want the timer to be postponed at all for up to a whole
second. Since we're doing all sorts of initialization work anyway this is
counterproductive anyway, and you really want the link to come up as soon as
possible, which is exactly what the watchdog handles when it runs first.

I can't possibly see any benefit from this other than that you just add up to a
whole second to the initialization cycle, which is bad.

Auke


> 
> Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
> 
> --- linux-2.6/drivers/net/e1000/e1000_main.c    2007-12-07
> 10:04:39.000000000 -0500
> +++ linux-2.6-work/drivers/net/e1000/e1000_main.c    2007-12-18
> 20:38:38.000000000 -0500
> @@ -1030,7 +1030,7 @@
>      adapter->tx_fifo_stall_timer.function = &e1000_82547_tx_fifo_stall;
>      adapter->tx_fifo_stall_timer.data = (unsigned long) adapter;
> 
> -    init_timer(&adapter->watchdog_timer);
> +    init_timer_deferrable(&adapter->watchdog_timer);
>      adapter->watchdog_timer.function = &e1000_watchdog;
>      adapter->watchdog_timer.data = (unsigned long) adapter;
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

