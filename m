Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYKJNZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYKJNZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbYKJNZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:25:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:54410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbYKJNZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:25:00 -0500
Message-ID: <491835FF.1060403@kernel.org>
Date: Mon, 10 Nov 2008 22:24:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: request to revert libata-convert-to-block-tagging patches
References: <4917C449.2080504@kernel.org> <20081110120533.GB26778@kernel.dk>
In-Reply-To: <20081110120533.GB26778@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Nov 2008 13:24:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Nov 10 2008, Tejun Heo wrote:
>> Hello, all.
>>
>> I went through libata-convert-to-block-tagging today and found several
>> issues.
>>
>> 1. libata internal data structure for command context (qc) allocation is
>> bound to tag allocation, which means that block layer tagging should be
>> enabled for all controllers which have can_queue > 1.
> 
> Naturally, is there a problem there?

Queueing wasn't enabled for ATAPI device behind PMP so it made those
devices reuse already allocated qc's.  Not difficult to fix.

>> 2. blk-tag offsets allocation for non-sync requests.  I'm not confident
>> this is safe.  Till now, if there was only single command in flight for
>> the port, it was guaranteed that the qc gets tag zero whether the device
>> is NCQ capable or not.  qc allocation is tied tightly with hardware
>> command slot allocation and I don't think it's wise to change this
>> assumption.
>>
>> #1 is easy to fix but #2 requires either adding a spinlock or two atomic
>> variables to struct blk_queue_tag to keep the current behavior while
>> guaranteeing that tags are used in order.  Also, there's delay between
>> libata marks a request complete and the request actually gets completed
>> and the tag is freed.  If another request gets issued inbetween, the tag
>> number can't be guaranteed.  This can be worked around by re-mapping tag
>> number in libata depending on command type but, well then, it's worse
>> than the original implementation.
> 
> Or we could just change the blk-tag.c logic to stop of
> find_first_zero_bit() returns >= some_value instead of starting at an
> offset? You don't need any extra locking for that.

I tried that but there's a behavior difference.  If you reserve from
the beginning, the sync IOs prefer the reserved slots.  If you
reserved from the end, the sync IO prefer non-reserved slots.
ie. When 4 slots are reserved for sync IO, and 4 sync IOs are already
in flight, the fifth sync IO competes with async IOs on the same
ground in the former case but in the latter it either wins or is very
likely to take another reserved slot.

> The second part is more tricky I think, but I'm not sure there's a race
> there. For normally issued IO, queueing is restarted when the tag
> completes. There's a small softirq delay there, but that delay is before
> the tag is completed and queueing restarted. Any non-ncq command (eg
> through an ioctl) will have to wait for completion as well.

For drivers with .can_queue == 1, nothing can go wrong.  I was worried
about NCQ -> non-NCQ transition because blk-tag doesn't know that the
non-NCQ command is not to be scheduled with NCQ commands and will
happily assign any tag and in this case the race window definitely is
there.

>> So, please revert the following commits.
>>
>> 43a49cbdf31e812c0d8f553d433b09b421f5d52c
>> e013e13bf605b9e6b702adffbe2853cfc60e7806
>> 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e
> 
> It's not a big deal to me, it can wait for 2.6.29 if there really are
> more issues there. But I'm not sure that your points are very valid, so
> lets please discuss it a bit more :-)

Yeap, I fully agree moving to blk tagging is good.  If we fix the
problem from #1, it's probably gonna be okay for most cases too.  I'm
just a little bit nervous because libata always has had this tag 0 for
non-NCQ commands assumption and this conversion changes that, so I was
hoping to update blk-tag such that such assumption can be guaranteed
first and then convert libata to be on the safe side.  Some
controllers use completely different command mechanism for different
protocols and it's much safer and more deterministic if same tag can
be guaranteed.

Thanks.

-- 
tejun
