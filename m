Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZGFM4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZGFM4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZGFM4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:56:41 -0400
Received: from smtp.nokia.com ([192.100.105.134]:50471 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZGFM4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:56:40 -0400
Message-ID: <4A51F443.8070402@gmail.com>
Date: Mon, 06 Jul 2009 15:55:31 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 02/10] writeback: switch to per-bdi threads for flushing
 data
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com> <1245926523-21959-3-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1245926523-21959-3-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Jul 2009 12:55:33.0570 (UTC) FILETIME=[0CA80A20:01C9FE39]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> +/*
> + * kupdated() used to do this. We cannot do it from the bdi_forker_task()
> + * or we risk deadlocking on ->s_umount. The longer term solution would be
> + * to implement sync_supers_bdi() or similar and simply do it from the
> + * bdi writeback tasks individually.
> + */
> +static int bdi_sync_supers(void *unused)
> +{
> +	set_user_nice(current, 0);
> +
> +	while (!kthread_should_stop()) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule();
> +
> +		/*
> +		 * Do this periodically, like kupdated() did before.
> +		 */
> +		sync_supers();
> +	}
> +
> +	return 0;

ATM we have one timer for both data and super-block synchronization.
With per-bdi write-back we have:

1. one timer for super blocks
2. many per-bdi timers for data (schedule_timeout() is essentially
   using timers).

This is not nice, because each timer is an additional source of
power-savings killers. I mean, it is more power management (PM)
friendly to have less timers and disturb CPU less, make CPU wake
up from retention less frequently.

I do not challange the per-bdi idea at all, but is it possible to
think about a more PM-friendly desing and have one source of
periodic write-back, not many. I mean, could there be one timer
which periodically syncs supers and wakes up the BDI write-back
tasks?

I've just started looking at your work, so I do not have good overall
picture of what's going on, so apologies in advance if I missed
something.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
