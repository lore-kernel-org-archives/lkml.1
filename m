Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbXBSLRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbXBSLRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbXBSLRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:17:05 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:47867 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbXBSLRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:17:04 -0500
Message-ID: <45D98711.609@in.ibm.com>
Date: Mon, 19 Feb 2007 16:46:33 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, xemul@sw.ru, linux-mm@kvack.org,
       menage@google.com, svaidy@linux.vnet.ibm.com, devel@openvz.org
Subject: Re: [RFC][PATCH][3/4] Add reclaim support
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop> <20070219065042.3626.95544.sendpatchset@balbir-laptop> <20070219005912.b1c74bd4.akpm@linux-foundation.org> <45D9810D.3040508@in.ibm.com> <20070219031017.c6e180e9.akpm@linux-foundation.org>
In-Reply-To: <20070219031017.c6e180e9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 19 Feb 2007 16:20:53 +0530 Balbir Singh <balbir@in.ibm.com> wrote:
> 
>>>> + * so, is the container over it's limit. Returns 1 if the container is above
>>>> + * its limit.
>>>> + */
>>>> +int memctlr_mm_overlimit(struct mm_struct *mm, void *sc_cont)
>>>> +{
>>>> +	struct container *cont;
>>>> +	struct memctlr *mem;
>>>> +	long usage, limit;
>>>> +	int ret = 1;
>>>> +
>>>> +	if (!sc_cont)
>>>> +		goto out;
>>>> +
>>>> +	read_lock(&mm->container_lock);
>>>> +	cont = mm->container;
>>>> +
>>>> +	/*
>>>> + 	 * Regular reclaim, let it proceed as usual
>>>> + 	 */
>>>> +	if (!sc_cont)
>>>> +		goto out;
>>>> +
>>>> +	ret = 0;
>>>> +	if (cont != sc_cont)
>>>> +		goto out;
>>>> +
>>>> +	mem = memctlr_from_cont(cont);
>>>> +	usage = atomic_long_read(&mem->counter.usage);
>>>> +	limit = atomic_long_read(&mem->counter.limit);
>>>> +	if (limit && (usage > limit))
>>>> +		ret = 1;
>>>> +out:
>>>> +	read_unlock(&mm->container_lock);
>>>> +	return ret;
>>>> +}
>>> hm, I wonder how much additional lock traffic all this adds.
>>>
>> It's a read_lock() and most of the locks are read_locks
>> which allow for concurrent access, until the container
>> changes or goes away
> 
> read_lock isn't free, and I suspect we're calling this function pretty
> often (every pagefault?) It'll be measurable on some workloads, on some
> hardware.
> 
> It probably won't be terribly bad because each lock-taking is associated
> with a clear_page().  But still, if there's any possibility of lightening
> the locking up, now is the time to think about it.
> 

Yes, good point. I'll revisit to see if barriers can replace the locking
or if the locking is required at all?

>>>> @@ -66,6 +67,9 @@ struct scan_control {
>>>>  	int swappiness;
>>>>  
>>>>  	int all_unreclaimable;
>>>> +
>>>> +	void *container;		/* Used by containers for reclaiming */
>>>> +					/* pages when the limit is exceeded  */
>>>>  };
>>> eww.  Why void*?
>>>
>> I did not want to expose struct container in mm/vmscan.c.
> 
> It's already there, via rmap.h
> 

Yes, true

>> An additional
>> thought was that no matter what container goes in the field would be
>> useful for reclaim.
> 
> Am having trouble parsing that sentence ;)
> 
> 

The thought was that irrespective of the infrastructure that goes in
having an entry for reclaim in scan_control would be useful. I guess
the name exposes what the type tries to hide :-)

-- 
	Warm Regards,
	Balbir Singh
