Return-Path: <linux-kernel-owner+w=401wt.eu-S1764281AbZDAMvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764281AbZDAMvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761489AbZDAMvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:51:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:57693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758082AbZDAMvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:51:09 -0400
Message-ID: <49D36329.20004@kernel.org>
Date: Wed, 01 Apr 2009 21:50:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       tj@kenel.org
Subject: Re: [PATCH 8/8] blk-map: reimplement blk_rq_map_user() using blk_rq_map_user_iov()
References: <1238583884-13517-1-git-send-email-tj@kernel.org>	<1238583884-13517-9-git-send-email-tj@kernel.org> <20090401214415W.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090401214415W.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 12:50:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> * Because each call to bio_map/copy_user() is independent, segment
>>   limit check was done only per each bio, so it was possible to create
>>   requests which are larger than the driver and hardware limits, which
>>   could lead to disastrous outcome.
> 
> What do you mean? blk_rq_append_bio properly checks the segment and
> limit, I think.

Right, ll_back_merge_fn() does that.  Sorry about that.

>> * Layers under FS may call blk_rq_map*() functions during request
>>   processing.  Under severe memory pressure and with enough bad luck,
>>   this can lead to deadlock.  As fs bvec pool is quite small, the
>>   possibility isn't completely theoretical.
>>
>> This patch reimplement blk_rq_map_user() in terms of
>> blk_rq_map_user_iov() which doesn't support multi-bio mappping and
>> drop multi bio handling from blk_rq_unmap_user().  Note that with the
>> previous patch to remove bio max size limit and to add null mapping
>> support to blk_rq_map_user_iov(), this change doesn't remove any
>> functionality.
> 
> I don't think that we can drop multi bio handling from
> blk_rq_unmap_user(). It may make some users angry. Mike Christie added
> it because it was necessary.

The only user of blk_rq_append_bio() is scsi_lib.c.  Is Mike
Christie's code chaining bio's directly into rq?

Thanks.

-- 
tejun
