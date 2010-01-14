Return-Path: <linux-kernel-owner+w=401wt.eu-S932279Ab0ANSBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab0ANSBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197Ab0ANSBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:01:50 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48589 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab0ANSBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:01:50 -0500
Message-ID: <4B4F5B93.8030202@vflare.org>
Date: Thu, 14 Jan 2010 23:29:47 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [mmotm] comment on swap notify locking constraints
References: <1263479571-7873-1-git-send-email-ngupta@vflare.org> <alpine.LSU.2.00.1001141503140.1943@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1001141503140.1943@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 08:40 PM, Hugh Dickins wrote:
> On Thu, 14 Jan 2010, Nitin Gupta wrote:
> 
>> A block device makes swap_slot_free_notify() callback
>> when the last reference to a swap slot is dropped.
>>
>> This callback is made under swap_lock and often with
>> lock for corresponding swapcache page also held. This
>> is a note of warning for registered callback function 
>> which must meet these constraints.
> 
> You're right that the page lock of the corresponding swapcache page
> may be held there, but that isn't what worried me enough to ask for
> a comment: it's the page table lock (sometimes we call it pte lock),
> a spinlock like the swap_lock, being held there that particularly
> deserves comment.  We don't want someone going to lots of effort
> to avoid holding swap_lock there, only to find that effort wasted
> because page table lock is also held.

Thanks for the review.

I was missing this important point regarding pte lock. I will edit
the comment and resend the patch.

Nitin





>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>> ---
>>  include/linux/blkdev.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 14b95a3..e3dcff6 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1295,6 +1295,7 @@ struct block_device_operations {
>>  						unsigned long long);
>>  	int (*revalidate_disk) (struct gendisk *);
>>  	int (*getgeo)(struct block_device *, struct hd_geometry *);
>> +	/* this callback is with swap_lock and often page lock also held */
> 
>                                                      and page table lock
> 
>>  	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
>>  	struct module *owner;
>>  };
>> -- 
>> 1.6.2.5
> 

