Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbZDQMYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbZDQMYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 08:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbZDQMYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 08:24:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60832 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968AbZDQMYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 08:24:43 -0400
Message-ID: <49E87502.3050806@redhat.com>
Date: Fri, 17 Apr 2009 14:24:34 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH v2] block: simplify I/O stat accounting
References: <49E72F19.1030400@redhat.com> <49E8662D.5010607@redhat.com> <20090417113756.GU4593@kernel.dk> <20090417115449.GV4593@kernel.dk>
In-Reply-To: <20090417115449.GV4593@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Apr 17 2009, Jens Axboe wrote:
>> On second thought, not sure why you add 'iostat' for this. It would be
>> OK to just do
>>
>>         if (blk_queue_io_stat(q))
>>                 rw_flags |= REQ_IO_STAT;
>>
>> since it's just used for the allocation call, and the trace call (which
>> does & 1 on it anyway).
>>
OK.

>>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>>> index 63760ca..6a05270 100644
>>> --- a/block/blk-merge.c
>>> +++ b/block/blk-merge.c
>>> @@ -338,9 +338,9 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
>>>  	return 1;
>>>  }
>>>  
>>> -static void blk_account_io_merge(struct request *req)
>>> +static void blk_account_io_merge(struct request *req, struct request *next)
>>>  {
>>> -	if (blk_do_io_stat(req)) {
>>> +	if (req->rq_disk && blk_rq_io_stat(next)) {
>> This at least needs a comment, it's not at all directly clear why we are
>> checking 'next' for io stat and ->rq_disk in 'req'. Since it's just
>> called from that one spot, it would be cleaner to do:
>>
>>         /*
>>          * 'next' is going away, so update stats accordingly
>>          */
>>         if (blk_rq_io_stat(next))
>>                 blk_account_io_merge(req->rq_disk, req->sector);
>>
>> and have blk_account_io_merge() be more ala:
>>
>> static void blk_account_io_merge(struct request *req)
>> {
>>         struct hd_struct *part;
>>         int cpu;
>>
>>         cpu = part_stat_lock();
>>         part = disk_map_sector_rcu(disk, sector);
>>         ...
>> }
> 
> BTW, it seems there's a current problem with this construct. If 'req'
> and 'next' reside on different partitions, the accounting will be wrong.
> This wont happen with normal fs activity of course, but it's definitely
> possible with buffered (or O_DIRECT) IO on the full device.
> 

You're right. We may end up decrease in_flight on the wrong partition.
I think having blk_account_io_merge() unchanged but call it for next
request would solve that:

-	blk_account_io_merge(req)
+	blk_account_io_merge(next)

We would still have the request payload accounted to the wrong partition
(as it always was), but I don't think that small inaccuracy really matters.

Jérôme

