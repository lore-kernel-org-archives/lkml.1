Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZBTIcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZBTIcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZBTIcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:32:01 -0500
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:63103 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbZBTIcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:32:01 -0500
Message-ID: <499E6A71.8060609@shipmail.org>
Date: Fri, 20 Feb 2009 09:31:45 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081231)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Eric Anholt <eric@anholt.net>, Wang Chen <wangchen@cn.fujitsu.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Fix lock order reversal between mmap_sem and struct_mutex.
References: <1234918786-854-1-git-send-email-eric@anholt.net>	 <1234969734.4637.111.camel@laptop>  <499DC8EC.3000806@shipmail.org> <1235082372.4612.665.camel@laptop>
In-Reply-To: <1235082372.4612.665.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-02-19 at 22:02 +0100, Thomas Hellstrom wrote:
>   
>>  
>> It looks to me like the driver preferred locking order is
>>
>> object_mutex (which happens to be the device global struct_mutex)
>>   mmap_sem
>>      offset_mutex.
>>
>> So if one could avoid using the struct_mutex for object bookkeeping (A 
>> separate lock) then
>> vm_open() and vm_close() would adhere to that locking order as well, 
>> simply by not taking the struct_mutex at all.
>>
>> So only fault() remains, in which that locking order is reversed. 
>> Personally I think the trylock ->reschedule->retry method with proper 
>> commenting is a good solution. It will be the _only_ place where locking 
>> order is reversed and it is done in a deadlock-safe manner. Note that 
>> fault() doesn't really fail, but requests a retry from user-space with 
>> rescheduling to give the process holding the struct_mutex time to 
>> release it.
>>     
>
> It doesn't do the reschedule -- need_resched() will check if the current
> task was marked to be scheduled away, 
Yes. my mistake. set_tsk_need_resched() would be the proper call. If I'm 
correctly informed, that would kick in the scheduler _after_ the 
mmap_sem() is released, just before returning to user-space.
> furthermore yield based locking
> sucks chunks.
>   
Yes, but AFAICT in this situation it is the only way to reverse locking 
order in a deadlock safe manner. If there is a lot of contention it will 
eat cpu. Unfortunately since the struct_mutex is such a wide lock there 
will probably be contention in some situations.

BTW isn't this quite common in distributed resource management, when you 
can't ensure that all requestors will request resources in the same order?
Try to grab all resources you need for an operation. If you fail to get 
one, release the resources you already have, sleep waiting for the 
failing one to be available and then retry.

In this case we fail be cause we _may_ have a deadlock. Since we cannot 
release the mmap_sem and wait, we do the second best thing and tell the 
kernel to reschedule when the mmap_sem is released.

> What's so very difficult about pulling the copy_*_user() out from under
> the locks?
>
>   
Given Eric's comment this is a GEM performance-critical path, so even 
from a CPU-usage perspecive, the trylock solution may be preferred.

 From a make-the-code-easy-to-understand perspective, I agree pulling 
out copy_*_user() is a better solution.  It might even be that the 
trylock solution doesn't kill the warnings from the lock dependency tracker.

/Thomas


