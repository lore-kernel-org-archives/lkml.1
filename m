Return-Path: <linux-kernel-owner+w=401wt.eu-S934190AbZGQHqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190AbZGQHqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 03:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934171AbZGQHqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 03:46:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52364 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934160AbZGQHqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 03:46:44 -0400
Message-ID: <4A602AA1.70908@redhat.com>
Date: Fri, 17 Jul 2009 15:39:13 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] block: sysfs fix mismatched queue_var_{store,show}
 in 64bit kernel
References: <1247572618-24073-1-git-send-email-dfeng@redhat.com> <1247580906-24762-1-git-send-email-dfeng@redhat.com> <4A601ED2.50800@kernel.org>
In-Reply-To: <4A601ED2.50800@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------090706090905010204080206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090706090905010204080206
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello, Tejun:

     Thank you very much for the review, I've attached v3 patch follow 
your advices, please help me review.

     Another thing on block sysfs is that we can echo some invalid value 
(e.g 123abc), should sysfs return -EINVAL for those?

Regards

On 07/17/2009 02:48 PM, Tejun Heo wrote:
> Hello, Xiaotian.
>
> Xiaotian Feng wrote:
>>   static ssize_t queue_ra_show(struct request_queue *q, char *page)
>>   {
>> -	int ra_kb = q->backing_dev_info.ra_pages<<  (PAGE_CACHE_SHIFT - 10);
>> +	unsigned long ra_kb = q->backing_dev_info.ra_pages<<
>> +					(PAGE_CACHE_SHIFT - 10);
>>
>>   	return queue_var_show(ra_kb, (page));
>>   }
>
> Nice.
>
>> @@ -95,7 +96,7 @@ queue_ra_store(struct request_queue *q, const char *page, size_t count)
>>
>>   static ssize_t queue_max_sectors_show(struct request_queue *q, char *page)
>>   {
>> -	int max_sectors_kb = queue_max_sectors(q)>>  1;
>> +	unsigned long max_sectors_kb = queue_max_sectors(q)>>  1;
>>
>>   	return queue_var_show(max_sectors_kb, (page));
>>   }
>> @@ -140,7 +141,7 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
>>
>>   static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
>>   {
>> -	int max_hw_sectors_kb = queue_max_hw_sectors(q)>>  1;
>> +	unsigned long max_hw_sectors_kb = queue_max_hw_sectors(q)>>  1;
>>
>>   	return queue_var_show(max_hw_sectors_kb, (page));
>>   }
>
> The above two aren't necessary but well why not.
>
>> @@ -189,7 +190,7 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
>>
>>   static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
>>   {
>> -	unsigned int set = test_bit(QUEUE_FLAG_SAME_COMP,&q->queue_flags);
>> +	unsigned long set = test_bit(QUEUE_FLAG_SAME_COMP,&q->queue_flags);
>>
>>   	return queue_var_show(set != 0, page);
>>   }
>
> Wouldn't it be better to make it "bool set = " and then remove the
> "!= 0"?
>
> Thanks.
>


--------------090706090905010204080206
Content-Type: text/x-patch;
 name="0001--block-sysfs-fix-mismatched-queue_var_-store-show.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001--block-sysfs-fix-mismatched-queue_var_-store-show.patch"

>From c3c0a8a6db9ff124d700b6d4ebf56bb4069f42c0 Mon Sep 17 00:00:00 2001
From: Xiaotian Feng <dfeng@redhat.com>
Date: Fri, 17 Jul 2009 15:26:26 +0800
Subject: [PATCH V3] block: sysfs fix mismatched queue_var_{store,show} in 64bit kernel

In blk-sysfs.c, queue_var_store uses unsigned long to store data,
but queue_var_show uses unsigned int to show data. This causes,

	# echo 70000000000 > /sys/block/<dev>/queue/read_ahead_kb
	# cat /sys/block/<dev>/queue/read_ahead_kb => get wrong value

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 block/blk-sysfs.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b1cd040..418d636 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -16,9 +16,9 @@ struct queue_sysfs_entry {
 };
 
 static ssize_t
-queue_var_show(unsigned int var, char *page)
+queue_var_show(unsigned long var, char *page)
 {
-	return sprintf(page, "%d\n", var);
+	return sprintf(page, "%lu\n", var);
 }
 
 static ssize_t
@@ -77,7 +77,8 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 
 static ssize_t queue_ra_show(struct request_queue *q, char *page)
 {
-	int ra_kb = q->backing_dev_info.ra_pages << (PAGE_CACHE_SHIFT - 10);
+	unsigned long ra_kb = q->backing_dev_info.ra_pages <<
+					(PAGE_CACHE_SHIFT - 10);
 
 	return queue_var_show(ra_kb, (page));
 }
@@ -189,9 +190,9 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
 {
-	unsigned int set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
+	bool set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
 
-	return queue_var_show(set != 0, page);
+	return queue_var_show(set, page);
 }
 
 static ssize_t
-- 
1.6.2.5


--------------090706090905010204080206--
