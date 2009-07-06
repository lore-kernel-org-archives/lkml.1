Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZGFOTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZGFOTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbZGFOTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:19:37 -0400
Received: from smtp.nokia.com ([192.100.122.233]:33999 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbZGFOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:19:36 -0400
Message-ID: <4A520608.7070707@gmail.com>
Date: Mon, 06 Jul 2009 17:11:20 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 05/10] writeback: support > 1 flusher thread per bdi
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com> <1245926523-21959-6-git-send-email-jens.axboe@oracle.com> <4A51FE33.3070702@gmail.com> <20090706134930.GA4987@shareable.org>
In-Reply-To: <20090706134930.GA4987@shareable.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Jul 2009 14:11:22.0806 (UTC) FILETIME=[A4365D60:01C9FE43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Artem Bityutskiy wrote:
>> Jens Axboe wrote:
>>> +static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work 
>>> *work)
>>> +{
>>> +	if (work) {
>>> +		work->seen = bdi->wb_mask;
>>> +		BUG_ON(!work->seen);
>>> +		atomic_set(&work->pending, bdi->wb_cnt);
>>> +		BUG_ON(!bdi->wb_cnt);
>>> +
>>> +		/*
>>> +		 * Make sure stores are seen before it appears on the list
>>> +		 */
>>> +		smp_mb();
>>> +
>>> +		spin_lock(&bdi->wb_lock);
>>> +		list_add_tail_rcu(&work->list, &bdi->work_list);
>>> +		spin_unlock(&bdi->wb_lock);
>>> +	}
>> Doesn't spin_lock() include an implicit memory barrier?
>> After &bdi->wb_lock is acquired, it is guaranteed that all
>> memory operations are finished.
> 
> I'm pretty sure spin_lock() is an "acquire" barrier, which just guarantees
> loads/stores after the spin_lock() are done after taking the lock.
> 
> It doesn't guarantee anything about loads/stores before the spin_lock().

Right, but comment says memops should be flushed before the
list is changed.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
