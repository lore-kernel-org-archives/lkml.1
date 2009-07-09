Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbZGIApy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbZGIApy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbZGIApp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:45:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:45509 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbZGIApp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:45:45 -0400
Message-ID: <4A553DA4.4080408@kernel.org>
Date: Thu, 09 Jul 2009 09:45:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Niel Lambrechts <niel.lambrechts@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] block: use the same failfast bits for bio and request
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-3-git-send-email-tj@kernel.org> <4A5071E5.8030908@panasas.com>
In-Reply-To: <4A5071E5.8030908@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Jul 2009 00:45:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> Thanks for doing this, it has been neglected for a long time.
> However, it will happen again, I don't like these implicit matches
> which are not enforced, They get to drift away. There are several ways
> to make sure two sets of enums stay in sync. (I'll have a try at it
> tomorrow. if you want). 

They don't share the exact same set of bits, so it's a bit blurry but
yeah it would be better if the bits are defined in more systematic
way.

>> @@ -142,37 +142,40 @@ struct bio {
>>   *
>>   * bit 0 -- data direction
>>   *	If not set, bio is a read from device. If set, it's a write to device.
>> - * bit 1 -- rw-ahead when set
>> - * bit 2 -- barrier
>> + * bit 1 -- fail fast device errors
>> + * bit 2 -- fail fast transport errors
>> + * bit 3 -- fail fast driver errors
>> + * bit 4 -- rw-ahead when set
>> + * bit 5 -- barrier
> 
> Please kill all these evil bit 1, bit 2 ,bit n comments. The ways we
> invent to torture ourselfs...
> 
> Just move all the comments to the enums declarations below. And be done
> with it, also for the next time.

Heh... I agree too.  Unless ABI is fixed, this type of comments are
often painful.  Care to submit a patch.  This series is already in
block#for-next.

>>  #define bio_rw_flagged(bio, flag)	((bio)->bi_rw & (1 << (flag)))
>>  
> 
> I wish there was also an helper to set these bits. it gives me an heart attack
> every time I need to:
> 	bio->bi_rw &= ~(1 << BIO_RW);

What's more disturbing to me is the different between RQ and BIO
flags.  __REQ_* are bit positions, REQ_* are masks while BIO_* are bit
positions.  Sadly it seems it's already too late to change that.  I
personally an not a big fan of simple accessors or flags defined as
bit positions.  They seem to obscure things without much benefit.

Thanks.

-- 
tejun
