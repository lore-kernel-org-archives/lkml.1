Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbYCHBGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbYCHBGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYCHBGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:06:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:10407 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYCHBGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:06:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dj2LScI0b/73iVcoccGq2Y6owdQsq6MVHiwmtjExS5xSYhmX/Qa0TYnHSIkEazdMH7tC3vLr3vnuOgPHLPD2u124wBhFFg35kCrM9lJyiv9fz511nN5iF75F7Ti4oYBnBEYRrWnJ5K0I7sUDDUQTc0TmjuiKParHM8AHU9rTZGE=
Message-ID: <47D1E696.5060308@gmail.com>
Date: Sat, 08 Mar 2008 10:06:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
   count
References: <20080306134146A.fujita.tomonori@lab.ntt.co.jp>	<20080306134138.GF17940@kernel.dk>	<47D0873B.6090705@gmail.com> <20080308000718H.tomof@acm.org>
In-Reply-To: <20080308000718H.tomof@acm.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Fri, 07 Mar 2008 09:07:23 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Jens Axboe wrote:
>>>>> If we want the use paradigm shared between block and driver, then I
>>>>> think the best approach is to keep all the bios the same (so not adjust
>>>>> for padding), but do adjust in the blk_rq_map_sg().  That way we have
>>>>> the padding and draining unwind information by comparing with the bio.
>>>> Adjusting only sg in blk_rq_map_sg (like drain) looks much
>>>> better. This works with libata for me.
>>> Looks like a much better solution to me. Anyone have any valid
>>> objections against moving the padding to the sg map time?
>> Not necessarily objections but some concerns.
>>
>> * As completion is done in bio terms, it makes completion from LLDs a
>> bit cumbersome, but this is unavoidable if we break sum(bio) == sum(sg).
> 
> What do you mean? How does sub(bio) affect LLDs?

LLDs which loop over sg's trying to complete rq incrementally will see
rq going away sooner than it expected.

>> * I've been wondering why we are not using sg chain / table or whatever
>> directly in bios and maybe rq_map_sg can go away in future.
> 
> You mean that LLDs use bios directly? For me, sg and bio have very
> different objectives and it's a clean layer separation.

Actually the other way, block layer use sg instead of bio_vec in bio.
Layer separation doesn't necessarily require copying about the same
information to differently formatted data structure.  I'm not sure it
will be a clean win tho.  Requests hang longer in scheduler queue and
and bio_vec is smaller and scatterlist.

The thing is that, to me, blk_rq_map_sg() doesn't really look necessary,
it can be done just as well when the request is fetched from the queue
by block driver. (continued below...)

>> How about separating out the padding / draining adjustment into a
>> separate interface?  Say, blk_rq_apply_extra() and blk_rq_undo_extra()
>> and make it the responsibility of the LLD which requested
>> padding/draining to apply and undo the adjustments?  It can undo the
>> adjustments when it returns the the request to its upper layer.  If rq
>> completion is handled by upper layer, it will do the right thing.  If rq
>> completion is handled by LLD, it can see the bio it wants to see.
> 
> If possible, I'd like to avoid creating APIs for them. I think that
> the current approach is much better than such APIs.

And, so, I'm not too sure whether putting more mechanisms into it is a
good idea.

Thanks.

-- 
tejun
