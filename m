Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbYF2FCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbYF2FCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYF2FCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:02:03 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:49770 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbYF2FCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:02:00 -0400
Message-ID: <4867174B.3090005@linux.vnet.ibm.com>
Date: Sun, 29 Jun 2008 10:32:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC 0/5] Memory controller soft limit introduction (v3)
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop> <20080628133615.a5fa16cf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080628133615.a5fa16cf.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 27 Jun 2008 20:48:08 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> This patchset implements the basic changes required to implement soft limits
>> in the memory controller. A soft limit is a variation of the currently
>> supported hard limit feature. A memory cgroup can exceed it's soft limit
>> provided there is no contention for memory.
>>
>> These patches were tested on a x86_64 box, by running a programs in parallel,
>> and checking their behaviour for various soft limit values.
>>
>> These patches were developed on top of 2.6.26-rc5-mm3. Comments, suggestions,
>> criticism are all welcome!
>>
>> A previous version of the patch can be found at
>>
>> http://kerneltrap.org/mailarchive/linux-kernel/2008/2/19/904114
>>
> I have a couple of comments.
> 
> 1. Why you add soft_limit to res_coutner ?
>    Is there any other controller which uses soft-limit ?
>    I'll move watermark handling to memcg from res_counter becasue it's
>    required only by memcg.
> 

I expect soft_limits to be controller independent. The same thing can be applied
to an io-controller for example, right?

> 2. *please* handle NUMA
>    There is a fundamental difference between global VMM and memcg.
>      global VMM - reclaim memory at memory shortage.
>      memcg     - for reclaim memory at memory limit
>    Then, memcg wasn't required to handle place-of-memory at hitting limit. 
>    *just reducing the usage* was enough.
>    In this set, you try to handle memory shortage handling.
>    So, please handle NUMA, i.e. "what node do you want to reclaim memory from ?"
>    If not, 
>     - memory placement of Apps can be terrible.
>     - cannot work well with cpuset. (I think)
> 

try_to_free_mem_cgroup_pages() handles NUMA right? We start with the
node_zonelists of the current node on which we are executing.  I can pass on the
zonelist from __alloc_pages_internal() to try_to_free_mem_cgroup_pages(). Is
there anything else you had in mind?


> 3. I think  when "mem_cgroup_reclaim_on_contention" exits is unclear.
>    plz add explanation of algorithm. It returns when some pages are reclaimed ?
> 

Sure, I will do that.

> 4. When swap-full cgroup is on the top of heap, which tends to contain
>    tons of memory, much amount of cpu-time will be wasted.
>    Can we add "ignore me" flag  ?
> 

Could you elaborate on swap-full cgroup please? Are you referring to changes
introduced by the memcg-handle-swap-cache patch? I don't mind adding a ignore me
flag, but I guess we need to figure out when a cgroup is swap full.

> Maybe "2" is the most important to implement this.
> I think this feature itself is interesting, so please handle NUMA.
> 

Thanks, I'll definitely fix what ever is needed to make the functionality more
correct and useful.

> "4" includes the user's (middleware's) memcg handling problem. But maybe
> a problem should be fixed in future.

Thanks for the review!

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
