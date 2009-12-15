Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbZLOTem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbZLOTem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbZLOTeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:34:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbZLOTeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:34:36 -0500
Message-ID: <4B27E49E.6000305@redhat.com>
Date: Tue, 15 Dec 2009 14:33:50 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 4/8] Use prepare_to_wait_exclusive() instead prepare_to_wait()
References: <20091214212936.BBBA.A69D9226@jp.fujitsu.com>	 <4B264CCA.5010609@redhat.com> <20091215085631.CDAD.A69D9226@jp.fujitsu.com>	 <1260855146.6126.30.camel@marge.simson.net>  <4B27A417.3040206@redhat.com> <1260902610.5913.19.camel@marge.simson.net>
In-Reply-To: <1260902610.5913.19.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2009 01:43 PM, Mike Galbraith wrote:
> On Tue, 2009-12-15 at 09:58 -0500, Rik van Riel wrote:
>> On 12/15/2009 12:32 AM, Mike Galbraith wrote:
>>> On Tue, 2009-12-15 at 09:45 +0900, KOSAKI Motohiro wrote:
>>>>> On 12/14/2009 07:30 AM, KOSAKI Motohiro wrote:
>>>>>> if we don't use exclusive queue, wake_up() function wake _all_ waited
>>>>>> task. This is simply cpu wasting.
>>>>>>
>>>>>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>>>>
>>>>>>     		if (zone_watermark_ok(zone, sc->order, low_wmark_pages(zone),
>>>>>>     					0, 0)) {
>>>>>> -			wake_up(wq);
>>>>>> +			wake_up_all(wq);
>>>>>>     			finish_wait(wq,&wait);
>>>>>>     			sc->nr_reclaimed += sc->nr_to_reclaim;
>>>>>>     			return -ERESTARTSYS;
>>>>>
>>>>> I believe we want to wake the processes up one at a time
>>>>> here.
>>
>>>> Actually, wake_up() and wake_up_all() aren't different so much.
>>>> Although we use wake_up(), the task wake up next task before
>>>> try to alloate memory. then, it's similar to wake_up_all().
>>
>> That is a good point.  Maybe processes need to wait a little
>> in this if() condition, before the wake_up().  That would give
>> the previous process a chance to allocate memory and we can
>> avoid waking up too many processes.
>
> Pondering, I think I'd at least wake NR_CPUS.  If there's not enough to
> go round, oh darn, but if there is, you have full utilization quicker.

That depends on what the other CPUs in the system are doing.

If they were doing work, you've just wasted some resources.

-- 
All rights reversed.
