Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZFKBY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZFKBY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 21:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZFKBYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 21:24:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50926 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbZFKBYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 21:24:19 -0400
Message-ID: <4A305C52.7040804@cn.fujitsu.com>
Date: Thu, 11 Jun 2009 09:22:26 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 08/18] io-controller: idle for sometime on sync queue
 before expiring it
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-9-git-send-email-vgoyal@redhat.com> <4A2E15B6.8030001@cn.fujitsu.com> <20090609175131.GB13476@redhat.com> <4A2F0CBE.8030208@cn.fujitsu.com> <20090610132638.GB19680@redhat.com>
In-Reply-To: <20090610132638.GB19680@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Wed, Jun 10, 2009 at 09:30:38AM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> On Tue, Jun 09, 2009 at 03:56:38PM +0800, Gui Jianfeng wrote:
>>>> Vivek Goyal wrote:
>>>> ...
>>>>> +ssize_t elv_fairness_store(struct request_queue *q, const char *name,
>>>>> +			  size_t count)
>>>>> +{
>>>>> +	struct elv_fq_data *efqd;
>>>>> +	unsigned int data;
>>>>> +	unsigned long flags;
>>>>> +
>>>>> +	char *p = (char *)name;
>>>>> +
>>>>> +	data = simple_strtoul(p, &p, 10);
>>>>> +
>>>>> +	if (data < 0)
>>>>> +		data = 0;
>>>>> +	else if (data > INT_MAX)
>>>>> +		data = INT_MAX;
>>>>   Hi Vivek,
>>>>
>>>>   data might overflow on 64 bit systems. In addition, since "fairness" is nothing 
>>>>   more than a switch, just let it be.
>>>>
>>>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>>>> ---
>>> Hi Gui,
>>>
>>> How about following patch? Currently this should apply at the end of the
>>> patch series. If it looks good, I will merge the changes in higher level
>>> patches.
>>   This patch seems good to me. Some trivial issues comment below.
>>
>>> Thanks
>>> Vivek
>>>
>>> o Previously common layer elevator parameters were appearing as request
>>>   queue parameters in sysfs. But actually these are io scheduler parameters
>>>   in hiearchical mode. Fix it.
>>>
>>> o Use macros to define multiple sysfs C functions doing the same thing. Code
>>>   borrowed from CFQ. Helps reduce the number of lines of by 140.
>>>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> ...	\
>>> +}
>>> +SHOW_FUNCTION(elv_fairness_show, efqd->fairness, 0);
>>> +EXPORT_SYMBOL(elv_fairness_show);
>>> +SHOW_FUNCTION(elv_slice_idle_show, efqd->elv_slice_idle, 1);
>>> +EXPORT_SYMBOL(elv_slice_idle_show);
>>> +SHOW_FUNCTION(elv_async_slice_idle_show, efqd->elv_async_slice_idle, 1);
>>> +EXPORT_SYMBOL(elv_async_slice_idle_show);
>>> +SHOW_FUNCTION(elv_slice_sync_show, efqd->elv_slice[1], 1);
>>> +EXPORT_SYMBOL(elv_slice_sync_show);
>>> +SHOW_FUNCTION(elv_slice_async_show, efqd->elv_slice[0], 1);
>>> +EXPORT_SYMBOL(elv_slice_async_show);
>>> +#undef SHOW_FUNCTION
>>> +
>>> +#define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
>>> +ssize_t __FUNC(struct elevator_queue *e, const char *page, size_t count)	\
>>> +{									\
>>> +	struct elv_fq_data *efqd = &e->efqd;				\
>>> +	unsigned int __data;						\
>>> +	int ret = elv_var_store(&__data, (page), count);		\
>>   Since simple_strtoul returns unsigned long, it's better to make __data 
>>   be that type.
>>
> 
> I just took it from CFQ. BTW, what's the harm here in truncating unsigned
> long to int? Anyway for our variables we are not expecting any value 
> bigger than unsigned int and if it is, we expect to truncate it?
> 
>>> +	if (__data < (MIN))						\
>>> +		__data = (MIN);						\
>>> +	else if (__data > (MAX))					\
>>> +		__data = (MAX);						\
>>> +	if (__CONV)							\
>>> +		*(__PTR) = msecs_to_jiffies(__data);			\
>>> +	else								\
>>> +		*(__PTR) = __data;					\
>>> +	return ret;							\
>>> +}
>>> +STORE_FUNCTION(elv_fairness_store, &efqd->fairness, 0, 1, 0);
>>> +EXPORT_SYMBOL(elv_fairness_store);
>>> +STORE_FUNCTION(elv_slice_idle_store, &efqd->elv_slice_idle, 0, UINT_MAX, 1);
>>   Do we need to set an actual max limitation rather than UINT_MAX for these entries?
> 
> Again these are the same values CFQ was using.  Do you have a better upper
> limit in mind? Until and unless there is strong objection to UINT_MAX, we
> can stick to what CFQ has been doing so far.

  Ok, I don't have strong opinion about the above things.

> 
> Thanks
> Vivek
> 
> 
> 

-- 
Regards
Gui Jianfeng

