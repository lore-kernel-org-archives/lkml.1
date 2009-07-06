Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZGFNNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZGFNNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZGFNNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:13:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37559 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbZGFNNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:13:10 -0400
Date: Mon, 6 Jul 2009 15:13:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 02/10] writeback: switch to per-bdi threads for
	flushing  data
Message-ID: <20090706131313.GR23611@kernel.dk>
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com> <1245926523-21959-3-git-send-email-jens.axboe@oracle.com> <4A51F443.8070402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A51F443.8070402@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06 2009, Artem Bityutskiy wrote:
> Jens Axboe wrote:
>> +/*
>> + * kupdated() used to do this. We cannot do it from the bdi_forker_task()
>> + * or we risk deadlocking on ->s_umount. The longer term solution would be
>> + * to implement sync_supers_bdi() or similar and simply do it from the
>> + * bdi writeback tasks individually.
>> + */
>> +static int bdi_sync_supers(void *unused)
>> +{
>> +	set_user_nice(current, 0);
>> +
>> +	while (!kthread_should_stop()) {
>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		schedule();
>> +
>> +		/*
>> +		 * Do this periodically, like kupdated() did before.
>> +		 */
>> +		sync_supers();
>> +	}
>> +
>> +	return 0;
>
> ATM we have one timer for both data and super-block synchronization.
> With per-bdi write-back we have:
>
> 1. one timer for super blocks
> 2. many per-bdi timers for data (schedule_timeout() is essentially
>   using timers).

That is correct. Note that these exit when they have been idle for a
while, for embedded and such you could make it more aggressive by
exiting quicker. The sync_supers should be directly fixable by your
sb_dirty() stuff.

So I don't think it's a huge change from what we currently have.

> This is not nice, because each timer is an additional source of
> power-savings killers. I mean, it is more power management (PM)
> friendly to have less timers and disturb CPU less, make CPU wake
> up from retention less frequently.
>
> I do not challange the per-bdi idea at all, but is it possible to
> think about a more PM-friendly desing and have one source of
> periodic write-back, not many. I mean, could there be one timer
> which periodically syncs supers and wakes up the BDI write-back
> tasks?

You could replace the schedule_timeout() by a schedule(), and instead
have a single timer running that would scan the bdi_list and issue the
kupdated() timed writeback that is the reason it uses schedule_timeout()
now. Explicitly issued work will manually wake up the per-bdi thread(s).
That single timer could easily handle waking up bdi_sync_supers() as
well.

-- 
Jens Axboe

