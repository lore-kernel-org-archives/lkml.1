Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510AbZGLMGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbZGLMGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 08:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZGLMGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 08:06:12 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:6970
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751666AbZGLMGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 08:06:11 -0400
Message-ID: <4A59D1AB.2040705@panasas.com>
Date: Sun, 12 Jul 2009 15:06:03 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Niel Lambrechts <niel.lambrechts@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] block: use the same failfast bits for bio and	request
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-3-git-send-email-tj@kernel.org> <4A5071E5.8030908@panasas.com> <4A553DA4.4080408@kernel.org> <20090709133746.GA21929@infradead.org> <4A573FB9.2090202@kernel.org>
In-Reply-To: <4A573FB9.2090202@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jul 2009 12:06:07.0174 (UTC) FILETIME=[23066E60:01CA02E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2009 04:18 PM, Tejun Heo wrote:
> Hello, Christoph.
> 
> Christoph Hellwig wrote:
>> On Thu, Jul 09, 2009 at 09:45:24AM +0900, Tejun Heo wrote:
>>> What's more disturbing to me is the different between RQ and BIO
>>> flags.  __REQ_* are bit positions, REQ_* are masks while BIO_* are bit
>>> positions.  Sadly it seems it's already too late to change that.  I
>>> personally an not a big fan of simple accessors or flags defined as
>>> bit positions.  They seem to obscure things without much benefit.
>> flags as bit positions generally only make sense if you use
>> test/set/clear_bit, otherwise they just confuse things.
> 

first please make a distinction between test/set/clear_bit and
test/__set/__clear_bit the former is not an option since it's not what
we need.

I too, do not like the lower-case accessors for upper-case bits like:
blk_failfast_dev() && blk_failfast_transport() which give nothing
and confuse the grepping of sets-vs-clears.

But I do like the use of __set/__clear_bit of flags. grepping is clear
and code semantics are more correct. Actually I prefer when a construct
like bio or request have two accessors set/clear_flags, which abstract
out not the bits but the flags member. Say when things evolve in the future
it is easer to adapted.

What can be more clear then rq_set_flags(req, QUEUE_FLAG_QUEUED) then
rq_clear_flags(req, QUEUE_FLAG_QUEUED) later.

> Another shortcoming of bit position flags is masking / multi flag
> operations.  It's just awful.  I think it's always better to define
> flags as masks even when it's used with test/set/clear_bit().  If such
> usages are common enough, we can easily add test/set/clear_bit_mask().
> The conversion from mask to bit would be constant most of the time and
> it's not like fls/ffs() are expensive.
> 

That's why I suggested the set/clear_flags() variable size macro
which can  set/clear multiple bit-flags at same cost of masks, only
that the compiler calculates the mask in compile time.

This can also be good for the greps above. .eg:
test_flags(&rq->cmd_flags, REQ_FAILFAST_DEV, REQ_FAILFAST_TRANSPORT, REQ_FAILFAST_DRIVER);

>> And the accessors are pretty annoying, especially in the block
>> layer.  Trying to find the places where a BIO flag has an actual
>> effect is pretty painful due to the mix of the different flags and
>> the accessors.
> 
> Yeap, fully agreed.
> 

As said, yes, the the lower-case accessors for upper-case bits does nothing,
but use __set/__clear/test is a different matter that can also replace the
sugary need of these.

> Thanks.
> 

Thanks
Boaz
