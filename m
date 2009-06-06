Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbZFFJZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbZFFJZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZFFJZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:25:00 -0400
Received: from www.tglx.de ([62.245.132.106]:54243 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZFFJY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:24:59 -0400
Date: Sat, 6 Jun 2009 11:24:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tick: add check for the existence of broadcast clock
 event device
In-Reply-To: <20090605112711.67e7d5cb@feng-desktop>
Message-ID: <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Feng Tang wrote:

> >From 2f076e1867c8bbb145b74d289358174644d9fed8 Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Fri, 5 Jun 2009 10:36:15 +0800
> Subject: [PATCH] tick: add check for the existence of broadcast clock event device
> 
> Some platform may have no broadcast clock event device, as it use always-on
> external timers for per-cpu timer and has no extra one for broadcast device.
> This check will secure the access to bc device when system get some boradcast
> on/off and enter/exit message
>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  kernel/time/tick-broadcast.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 118a3b3..110e0bc 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -214,10 +214,13 @@ static void tick_do_broadcast_on_off(void *why)
>  
>  	spin_lock_irqsave(&tick_broadcast_lock, flags);
>  
> +	bc = tick_broadcast_device.evtdev;
> +	if (!bc)
> +		goto out;
> +

This check is not necessary because we check whether the percpu device
is affected by the stops in C3 madness _before_ we touch the broadcast
device.

	 if (!dev || !(dev->features & CLOCK_EVT_FEAT_C3STOP))
	    	  got out;

If your percpu devices are always on (not affected by C3 stop) then
you never dereference bc. So why do we need an extra check for !bc ?

Thanks,

	tglx
