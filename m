Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZGFPok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZGFPok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZGFPnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:43:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47851 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbZGFPnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:43:42 -0400
Date: Mon, 6 Jul 2009 17:43:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 05/10] writeback: support > 1 flusher thread per bdi
Message-ID: <20090706154345.GT23611@kernel.dk>
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com> <1245926523-21959-6-git-send-email-jens.axboe@oracle.com> <4A51FE33.3070702@gmail.com> <20090706134930.GA4987@shareable.org> <4A520608.7070707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A520608.7070707@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06 2009, Artem Bityutskiy wrote:
> Jamie Lokier wrote:
>> Artem Bityutskiy wrote:
>>> Jens Axboe wrote:
>>>> +static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work
>>>> *work)
>>>> +{
>>>> +	if (work) {
>>>> +		work->seen = bdi->wb_mask;
>>>> +		BUG_ON(!work->seen);
>>>> +		atomic_set(&work->pending, bdi->wb_cnt);
>>>> +		BUG_ON(!bdi->wb_cnt);
>>>> +
>>>> +		/*
>>>> +		 * Make sure stores are seen before it appears on the list
>>>> +		 */
>>>> +		smp_mb();
>>>> +
>>>> +		spin_lock(&bdi->wb_lock);
>>>> +		list_add_tail_rcu(&work->list, &bdi->work_list);
>>>> +		spin_unlock(&bdi->wb_lock);
>>>> +	}
>>> Doesn't spin_lock() include an implicit memory barrier?
>>> After &bdi->wb_lock is acquired, it is guaranteed that all
>>> memory operations are finished.
>>
>> I'm pretty sure spin_lock() is an "acquire" barrier, which just guarantees
>> loads/stores after the spin_lock() are done after taking the lock.
>>
>> It doesn't guarantee anything about loads/stores before the spin_lock().
>
> Right, but comment says memops should be flushed before the
> list is changed.

The comment says that the _above_ stores should be seen before it
appears on the list, it doesn't say anything about the list itself. What
matters is that the ->seen/pending must be fully visible before it
appears on the list. A spin_lock() doesn't guarentee that, and the bdi
thread could even see the work before the spin_unlock() is started.

-- 
Jens Axboe

