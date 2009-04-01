Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbZDAWRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbZDAWRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbZDAWRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:17:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:51563 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760390AbZDAWRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:17:21 -0400
Message-ID: <49D3E811.4000802@kernel.org>
Date: Thu, 02 Apr 2009 07:17:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 16/17] blk-map/bio: remove superflous @len parameter from
 blk_rq_map_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-17-git-send-email-tj@kernel.org> <49D3A07C.9050400@panasas.com>
In-Reply-To: <49D3A07C.9050400@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 22:17:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Boaz Harrosh wrote:
> I did not go to the bottom of this but how does that do not change
> user-space API. It would now fail in code that would work before.
> 
> What if I want to try variable size commands, where I try the
> shorter first, then a longer one (or vis versa). I would setup
> memory mapping to the biggest command but issue a length that
> correspond to the encoded command inside the CDB.
> 
> The bi->bi_size is not only mapping size it is also the command size
> I want to actually read/write.
> 
> But I might read this wrong though

Please see below.

>> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
>> index 73cfd91..fd538f8 100644
>> --- a/block/scsi_ioctl.c
>> +++ b/block/scsi_ioctl.c
>> @@ -288,7 +288,6 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>>  
>>  	if (hdr->iovec_count) {
>>  		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
>> -		size_t iov_data_len;
>>  		struct iovec *iov;
>>  
>>  		iov = kmalloc(size, GFP_KERNEL);
>> @@ -304,15 +303,11 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>>  		}
>>  
>>  		/* SG_IO howto says that the shorter of the two wins */
>> -		iov_data_len = iov_length(iov, hdr->iovec_count);
>> -		if (hdr->dxfer_len < iov_data_len) {
>> -			hdr->iovec_count = iov_shorten(iov, hdr->iovec_count,
>> -						       hdr->dxfer_len);
>> -			iov_data_len = hdr->dxfer_len;
>> -		}
>> +		hdr->iovec_count = iov_shorten(iov, hdr->iovec_count,
>> +					       hdr->dxfer_len);
>>  
>>  		ret = blk_rq_map_user_iov(q, rq, NULL, iov, hdr->iovec_count,
>> -					  iov_data_len, GFP_KERNEL);
>> +					  GFP_KERNEL);

blk_rq_map_user_iov() never had the shorter data len functionality.
It fails requests with -EINVAL if iov_length(iov) != dxfer_len, so a
patch in the previous patchset adds the above iov_shorten() call to
trim iov if dxfer_len is shorter.  In this patch, it gets a bit
simpler as the length parameter isn't necessary.

Thanks.

-- 
tejun
