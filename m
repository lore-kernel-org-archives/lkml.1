Return-Path: <linux-kernel-owner+w=401wt.eu-S1763434AbZE0LSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763434AbZE0LSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762136AbZE0LNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:13:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:35518 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762038AbZE0LNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:13:47 -0400
Subject: Re: [PATCH 04/11] writeback: switch to per-bdi threads for
 flushing data
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
In-Reply-To: <1243417312-7444-5-git-send-email-jens.axboe@oracle.com>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com>
	 <1243417312-7444-5-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 27 May 2009 13:11:53 +0200
Message-Id: <1243422713.23657.53.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 11:41 +0200, Jens Axboe wrote:

> +	if (writeback_acquire(bdi)) {
> +		bdi->wb_arg.nr_pages = nr_pages;
> +		bdi->wb_arg.sb = sb;
> +		bdi->wb_arg.sync_mode = sync_mode;
> +		/*
> +		 * make above store seen before the task is woken
> +		 */
> +		smp_mb();
> +		wake_up(&bdi->wait);
> +	}

wake_up() implies a wmb() when we indeed to a wakeup, is that
sufficient?

> +int bdi_writeback_task(struct backing_dev_info *bdi)
> +{
> +	while (!kthread_should_stop()) {
> +		unsigned long wait_jiffies;
> +		DEFINE_WAIT(wait);
> +
> +		prepare_to_wait(&bdi->wait, &wait, TASK_INTERRUPTIBLE);
> +		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
> +		schedule_timeout(wait_jiffies);
> +		try_to_freeze();
> +
> +		/*
> +		 * We get here in two cases:
> +		 *
> +		 *  schedule_timeout() returned because the dirty writeback
> +		 *  interval has elapsed. If that happens, we will be able
> +		 *  to acquire the writeback lock and will proceed to do
> +		 *  kupdated style writeout.
> +		 *
> +		 *  Someone called bdi_start_writeback(), which will acquire
> +		 *  the writeback lock. This means our writeback_acquire()
> +		 *  below will fail and we call into bdi_pdflush() for
> +		 *  pdflush style writeout.
> +		 *
> +		 */
> +		if (writeback_acquire(bdi))
> +			bdi_kupdated(bdi);
> +		else
> +			bdi_pdflush(bdi);
> +
> +		writeback_release(bdi);
> +		finish_wait(&bdi->wait, &wait);
> +	}
> +
> +	return 0;
> +}

the unpaired writeback_release() wrt writeback_acquire() looks odd.

Also the prepare/finish wait bits seem oddly out of place. Are there
really multiple waiters on bdi->wait? The above wake_up() seems to
suggest not, since it directly modifies bdi state instead of queueing
work.


