Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbZLHPy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbZLHPy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932135AbZLHPy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:54:56 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:45655 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbZLHPyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:54:55 -0500
Message-ID: <4B1E76C9.50901@linux.vnet.ibm.com>
Date: Tue, 08 Dec 2009 16:54:49 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Elladan <elladan@eskimo.com>, Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Increased Buffers due to patch 56e49d (vmscan: evict use-once
 pages first), but why exactly?
References: <4B1D12E7.4070701@linux.vnet.ibm.com> <4B1D46C0.4040503@redhat.com> <20091208093533.B57B.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091208093533.B57B.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> On 12/07/2009 09:36 AM, Christian Ehrhardt wrote:
>>     
>>> Hi,
>>> commit 56e49d - "vmscan: evict use-once pages first" changed behavior of
>>> memory management quite a bit which should be fine.
>>> But while tracking down a performance regression I was on the wrong path
>>> for a while suspecting this patch is causing the regression.
>>> Fortunately this was not the case, but I got some interesting data which
>>> I couldn't explain completely and I thought maybe its worth to get it
>>> clarified publicly in case someone else looks at similar data again :-)
>>>
>>> All is about the increased amount of "Buffers" accounted as active while
>>> loosing the same portion from "Cache" accounted as inactive in
>>> /proc/meminfo.
>>> I understand that with the patch applied there will be some more
>>> pressure to file pages until the balance of active/inactive file pages
>>> is reached.
>>> But I didn't get how this prefers buffers compared to cache pages (I
>>> assume dropping inactive before active was the case all the time so that
>>> can't be the only difference between buffers/cache).
>>>       
>> Well, "Buffers" is the same kind of memory as "Cached", with
>> the only difference being that "Cached" is associated with
>> files, while "Buffers" is associated with a block device.
>>
>> This means that "Buffers" is more likely to contain filesystem
>> metadata, while "Cached" is more likely to contain file data.
>>
>> Not putting pressure on the active file list if there are a
>> large number of inactive file pages means that pages which were
>> accessed more than once get protected more from pages that were
>> only accessed once.
>>
>> My guess is that "Buffers" is larger because the VM now caches
>> more (frequently used) filesystem metadata, at the expense of
>> caching less (used once) file data.
>>
>>     
>>> The scenario I'm running is a low memory system (256M total), that does
>>> sequential I/O with parallel iozone processes.
>>>       
>> This indeed sounds like the kind of workload that would only
>> access the file data very infrequently, while accessing the
>> filesystem metadata all the time.
>>
>>     
>>> But I can't really see in the code where buffers are favored in
>>> comparison to cached pages - (it very probably makes sense to do so, as
>>> they might contain e.g. the inode data about the files in cache).
>>>       
>> You are right that the code does not favor Buffers or Cache
>> over the other, but treats both kinds of pages the same.
>>
>> I believe that you are just seeing the effect of code that
>> better protects the frequently accessed metadata from the
>> infrequently accessed data.
>>     
>
> I try to explain the same thing as another word. if active list have
> lots unimportant pages, the patch makes to gurard unimportant pages.
> it might makes stream I/O benchmark score a bit because such workload
> doesn't have the pages theat should be protected. iow, it only reduce
> memory for cache.
>
> The patch's intention is to improve real workload (i.e. stream/random I/O mixed workload).
> not improve benchmark score. So, I'm interest how much decrease your
> benchmark score.
>   
As mentioned initially it doesn't have any benchmark score impact at all 
(neither positive nor negative). I expect it might be beneficial for 
scores in e.g. reread scenarios.
It was just wondering about the buffers vs cached pages preference, 
which as I stated and also Rik confirmed is meta data and therefore wise 
to keep in comparison to less used data.

btw thanks for the explanation Rik, the file/blockdev association was 
exactly what I was missing in my thoughts.
While my question was more intended to ask where in code these 
differentiation is made I'm perfectly fine with having it just working 
knowing that file/blockdev association is the key.


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

