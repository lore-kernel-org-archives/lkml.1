Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZGGP3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZGGP3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZGGP3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:29:11 -0400
Received: from smtp.nokia.com ([192.100.122.233]:57758 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbZGGP3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:29:09 -0400
Message-ID: <4A53694D.2010905@gmail.com>
Date: Tue, 07 Jul 2009 18:27:09 +0300
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
X-OriginalArrivalTime: 07 Jul 2009 15:27:16.0135 (UTC) FILETIME=[689EFB70:01C9FF17]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens, I've noticed the following _possible_ issue.

Jens Axboe wrote:
> +static int bdi_forker_task(void *ptr)
> +{
> +	struct backing_dev_info *me = ptr;
> +
> +	for (;;) {
> +		struct backing_dev_info *bdi, *tmp;
> +
> +		/*
> +		 * Temporary measure, we want to make sure we don't see
> +		 * dirty data on the default backing_dev_info
> +		 */
> +		if (bdi_has_dirty_io(me))
> +			bdi_flush_io(me);
> +
> +		spin_lock(&bdi_lock);
> +
> +		/*
> +		 * Check if any existing bdi's have dirty data without
> +		 * a thread registered. If so, set that up.
> +		 */
> +		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
> +			if (bdi->task || !bdi_has_dirty_io(bdi))
> +				continue;
> +
> +			bdi_add_default_flusher_task(bdi);
> +		}
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +
What happens if we are preempted here? Since we have TASK_INTERRUPTIBLE
state, we will not come back unless some other task wakes us up. Who
would wake us up in this case?

> +		if (list_empty(&bdi_pending_list)) {
> +			unsigned long wait;
> +
> +			spin_unlock(&bdi_lock);
> +			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
> +			schedule_timeout(wait);
> +			try_to_freeze();
> +			continue;
> +		}
> +
> +		__set_current_state(TASK_RUNNING);
> +
> +		/*
> +		 * This is our real job - check for pending entries in
> +		 * bdi_pending_list, and create the tasks that got added
> +		 */
> +		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
> +				 bdi_list);
> +		list_del_init(&bdi->bdi_list);
> +		spin_unlock(&bdi_lock);
> +
> +		BUG_ON(bdi->task);
> +
> +		bdi->task = kthread_run(bdi_start_fn, bdi, "flush-%s",
> +					dev_name(bdi->dev));
> +		/*
> +		 * If task creation fails, then readd the bdi to
> +		 * the pending list and force writeout of the bdi
> +		 * from this forker thread. That will free some memory
> +		 * and we can try again.
> +		 */
> +		if (IS_ERR(bdi->task)) {
> +			bdi->task = NULL;
> +
> +			/*
> +			 * Add this 'bdi' to the back, so we get
> +			 * a chance to flush other bdi's to free
> +			 * memory.
> +			 */
> +			spin_lock(&bdi_lock);
> +			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
> +			spin_unlock(&bdi_lock);
> +
> +			bdi_flush_io(bdi);
> +		}
> +	}
> +
> +	return 0;
> +}



-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
