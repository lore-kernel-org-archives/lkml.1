Return-Path: <linux-kernel-owner+w=401wt.eu-S1750807AbXBSKA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750807AbXBSKA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXBSKAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:00:55 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:47167 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXBSKAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:00:55 -0500
Message-ID: <45D97547.3000502@in.ibm.com>
Date: Mon, 19 Feb 2007 15:30:39 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, xemul@sw.ru, linux-mm@kvack.org,
       menage@google.com, svaidy@linux.vnet.ibm.com, devel@openvz.org
Subject: Re: [RFC][PATCH][0/4] Memory controller (RSS Control)
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop> <20070219005441.7fa0eccc.akpm@linux-foundation.org>
In-Reply-To: <20070219005441.7fa0eccc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 19 Feb 2007 12:20:19 +0530 Balbir Singh <balbir@in.ibm.com> wrote:
> 
>> This patch applies on top of Paul Menage's container patches (V7) posted at
>>
>> 	http://lkml.org/lkml/2007/2/12/88
>>
>> It implements a controller within the containers framework for limiting
>> memory usage (RSS usage).
> 
> It's good to see someone building on someone else's work for once, rather
> than everyone going off in different directions.  It makes one hope that we
> might actually achieve something at last.
> 

Thanks! It's good to know we are headed in the right direction.

> 
> The key part of this patchset is the reclaim algorithm:
> 
>> @@ -636,6 +642,15 @@ static unsigned long isolate_lru_pages(u
>>  
>>  		list_del(&page->lru);
>>  		target = src;
>> +		/*
>> + 		 * For containers, do not scan the page unless it
>> + 		 * belongs to the container we are reclaiming for
>> + 		 */
>> +		if (container && !page_in_container(page, zone, container)) {
>> +			scan--;
>> +			goto done;
>> +		}
> 
> Alas, I fear this might have quite bad worst-case behaviour.  One small
> container which is under constant memory pressure will churn the
> system-wide LRUs like mad, and will consume rather a lot of system time. 
> So it's a point at which container A can deleteriously affect things which
> are running in other containers, which is exactly what we're supposed to
> not do.
> 

Hmm.. I guess it's space vs time then :-) A CPU controller could
control how much time is spent reclaiming ;)

Coming back, I see the problem you mentioned and we have been thinking
of several possible solutions. In my introduction I pointed out

    "Come up with cool page replacement algorithms for containers
    (if possible without any changes to struct page)"


The solutions we have looked at are

1. Overload the LRU list_head in struct page to have a global
    LRU + a per container LRU

+------+           prev       +------+
| page +--------------------->| page +---------
|  0   |<---------------------+  1   |<--------
+------+           next       +------+

                  Global LRU

             +------+
    +------- + prev |
    |        | next +-------------------------------------------+
    |        +------+                                           |
    V            ^                                              V
+------+        |  prev       +------+                     +------+
| page +        +------------ + page +---------.....       | page +
|  0   |--------------------->+  1   |<--------            |  n   |
+------+           next       +------+                     +------+

                  Global LRU + Container LRU


Page 1 and n belong to the same container, to get to page 0, you need
two de-references


2. Modify struct page to point to a container and allow each container to
    have a per-container LRU along with the global LRU


For efficiency we need the container LRU and we don't want to split
the global LRU either.

We need to optimize the reclaim path, but I thought of that as a secondary
problem. Once we all agree that the controller looks simple, accounts well
and works. We can/should definitely optimize the reclaim path.


-- 
	Warm Regards,
	Balbir Singh
