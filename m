Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbYCXSwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbYCXSwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbYCXSwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:52:06 -0400
Received: from fallback.us4.outblaze.com ([205.158.62.120]:58918 "EHLO
	fallback.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbYCXSwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:52:05 -0400
X-OB-Received: from unknown (205.158.62.55)
  by wfilter3.us4.outblaze.com; 24 Mar 2008 19:40:06 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "John Z." <md2sf@mail.com>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Mar 2008 13:49:03 -0500
Subject: Re: FW: [PATCH 008 of 9] md: Fix possible raid1/raid10 deadlock on
 read error during resync.
X-Originating-Ip: 65.113.45.241
X-Originating-Server: ws1-3.us4.outblaze.com
Message-Id: <20080324184903.D9213103C6@ws1-3.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Sunday, March 02, 2008 5:18 PM
> To: Andrew Morton
> Cc: linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org; K.Tanaka
> Subject: [PATCH 008 of 9] md: Fix possible raid1/raid10 deadlock on read
> error during resync.
> 

> diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
> --- .prev/drivers/md/raid1.c	2008-03-03 11:03:39.000000000 +1100
> +++ ./drivers/md/raid1.c	2008-03-03 09:56:52.000000000 +1100
> @@ -704,13 +704,20 @@ static void freeze_array(conf_t *conf)
>   	/* stop syncio and normal IO and wait for everything to
>   	 * go quite.
>   	 * We increment barrier and nr_waiting, and then
> -	 * wait until barrier+nr_pending match nr_queued+2
> +	 * wait until nr_pending match nr_queued+1
> +	 * This is called in the context of one normal IO request
> +	 * that has failed. Thus any sync request that might be pending
> +	 * will be blocked by nr_pending, and we need to wait for
> +	 * pending IO requests to complete or be queued for re-try.
> +	 * Thus the number queued (nr_queued) plus this request (1)
> +	 * must match the number of pending IOs (nr_pending) before
> +	 * we continue.
>   	 */
>   	spin_lock_irq(&conf->resync_lock);
>   	conf->barrier++;
>   	conf->nr_waiting++;
>   	wait_event_lock_irq(conf->wait_barrier,
> -			    conf->barrier+conf->nr_pending ==
> conf->nr_queued+2,
> +			    conf->nr_pending == conf->nr_queued+1,
>   			    conf->resync_lock,
>   			    ({ flush_pending_writes(conf);
>   			       raid1_unplug(conf->mddev->queue); }));
> --

When we call freeze_array, it is after reschedule_retry, during which conf->nr_queued is already incremented.
Should we use conf->nr_pending == conf->nr_pending here?




-- 
Want an e-mail address like mine?
Get a free e-mail account today at www.mail.com!

