Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYJFGAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYJFGAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 02:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYJFGAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 02:00:04 -0400
Received: from mga10.intel.com ([192.55.52.92]:3727 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752640AbYJFGAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 02:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,366,1220252400"; 
   d="scan'208";a="623754589"
Subject: Re: aim7 47% regression with 2.6.27-rc8
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1223271482.7794.1.camel@marge.simson.net>
References: <1223269135.1685.11.camel@ymzhang>
	 <1223271482.7794.1.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 13:52:58 +0800
Message-Id: <1223272378.1685.12.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-10-06 at 07:38 +0200, Mike Galbraith wrote:
> On Mon, 2008-10-06 at 12:58 +0800, Zhang, Yanmin wrote:
> > Comparing with 2.6.27-rc8, aim7 result has about 47% regression with 2.6.27-rc8 on
> > my 16-core tigerton and 8 core+HyperThreading x86_64 machine.
> > 
> > I bisected it down to patch:
> > 
> > 302745699c1b675b5d2a1af87271de10e4d96b6a is first bad commit
> 
> > After I reverted the patch against 2.6.27-rc8, the regression disappears.
> > It's interesting that the regression doesn't exist on 8-core stoakley.
> 
> Looks like it's been fixed meanwhile.
I did a new quick test and the patch does fix it.

Thanks,
Yanmin

> 
> commit 07454bfff151d2465ada809bbaddf3548cc1097c
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Sat Oct 4 10:51:07 2008 +0200
> 
>     clockevents: check broadcast tick device not the clock events device
>     
>     Impact: jiffies increment too fast.
>     
>     Hugh Dickins noted that with NOHZ=n and HIGHRES=n jiffies get
>     incremented too fast. The reason is a wrong check in the broadcast
>     enter/exit code, which keeps the local apic timer in periodic mode
>     when the switch happens.
>     
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index bd70345..cb01cd8 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -235,7 +235,8 @@ static void tick_do_broadcast_on_off(void *why)
>  	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
>  		if (!cpu_isset(cpu, tick_broadcast_mask)) {
>  			cpu_set(cpu, tick_broadcast_mask);
> -			if (bc->mode == TICKDEV_MODE_PERIODIC)
> +			if (tick_broadcast_device.mode ==
> +			    TICKDEV_MODE_PERIODIC)
>  				clockevents_shutdown(dev);
>  		}
>  		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
> @@ -245,7 +246,8 @@ static void tick_do_broadcast_on_off(void *why)
>  		if (!tick_broadcast_force &&
>  		    cpu_isset(cpu, tick_broadcast_mask)) {
>  			cpu_clear(cpu, tick_broadcast_mask);
> -			if (bc->mode == TICKDEV_MODE_PERIODIC)
> +			if (tick_broadcast_device.mode ==
> +			    TICKDEV_MODE_PERIODIC)
>  				tick_setup_periodic(dev, 0);
>  		}
>  		break;
> 
> 

