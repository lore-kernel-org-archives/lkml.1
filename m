Return-Path: <linux-kernel-owner+w=401wt.eu-S932093Ab0ANI06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab0ANI06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 03:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227Ab0ANI05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 03:26:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58002 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab0ANI05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:26:57 -0500
Message-ID: <4B4ED420.2020701@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 16:21:52 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests
 pending
References: <20100113074442.GA10492@sli10-desk.sh.intel.com> <4e5e476b1001130018n2ad9e830s4a20d922abd4c7bb@mail.gmail.com> <20100113082322.GA24345@sli10-desk.sh.intel.com> <20100113111341.GB3087@redhat.com> <20100114034150.GA3922@sli10-desk.sh.intel.com> <4B4EAB39.1070301@cn.fujitsu.com> <20100114061731.GA23590@sli10-desk.sh.intel.com>
In-Reply-To: <20100114061731.GA23590@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> On Thu, Jan 14, 2010 at 01:27:21PM +0800, Gui Jianfeng wrote:
>> Shaohua Li wrote:
>>> On Wed, Jan 13, 2010 at 07:13:41PM +0800, Vivek Goyal wrote:
>>>> On Wed, Jan 13, 2010 at 04:23:22PM +0800, Shaohua Li wrote:
>>>>> On Wed, Jan 13, 2010 at 04:18:47PM +0800, Corrado Zoccolo wrote:
>>>>>> On Wed, Jan 13, 2010 at 8:44 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>>>>>>> My SSD speed of direct write is about 80m/s, while I test page writeback,
>>>>>>> the speed can only go to 68m/s. Below patch fixes this.
>>>>>>> It appears we missused cfq_should_idle in cfq_may_dispatch. cfq_should_idle
>>>>>>> means a queue should idle because it's seekless sync queue or it's the last queue,
>>>>>>> which is to maintain service tree time slice. So it doesn't mean the
>>>>>>> last queue is always a sync queue. If the last queue is asyn queue,
>>>>>>> we definitely shouldn't stop dispatch requests because of pending async
>>>>>>> requests.
>>>>>> An other option is that cfq_should_idle returns false for async
>>>>>> queues, since cfq will never idle on them.
>>>>> I'm considering this option too, but it appears we need make async queue
>>>>> idle to maintain domain time slice.
>>>> IMHO, we don't have to wait on async write service tree. Generally aysnc
>>>> write queus contain many requests and they are not like reads where next
>>>> request is expected. So idling on aysnc write service tree is waste of
>>>> time and will lead to reduced throughput.
>>> I fully agree async queue doesn't need wait. I thought the purpose we add the last
>>> queue check in cfq_should_idle is we want a service tree or a group has dedicated
>>> slice, because before the service tree/group slice is expired, new queue can jump
>>> in and if we don't idle, the new queue can only run at next slice. Not sure if I
>>> understand the code correctly.
>> Hi Shaohua,
>>
>> If a cfq queue is the last one in the io group, if we expire this cfqq immediately,
>> io group will be removed from service tree. When io group gets backlogged again, it
>> will be put at the end of service tree, so it loses its previous share. so we add
>> the last check here from the fairness point of view.
> ya, this is what I'm understanding. So we can't return false for async queue
> in cfq_should_idle if the queue is the last one of service tree.

I see your point, whether can we add the extra sync queue check into cfq_should_idle
for common use?

Thanks,
Gui

> 
> Thanks,
> Shaohua
> 
> 
> 


