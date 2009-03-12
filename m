Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZCLQJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZCLQJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbZCLQIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:08:55 -0400
Received: from iona.labri.fr ([147.210.8.143]:56891 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbZCLQIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:08:54 -0400
X-Greylist: delayed 1637 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 12:08:54 EDT
Message-ID: <49B92D2B.2090100@ens-lyon.org>
Date: Thu, 12 Mar 2009 16:41:31 +0100
From: Brice Goglin <Brice.Goglin@ens-lyon.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, akpm@linux-foundation.org
Subject: Re: [PATCH] acquire mmap semaphore in pagemap_read.
References: <20090312113308.6fe18a93@skybase>	<20090312114533.GA2407@x200.localdomain>	<20090312125410.25400d18@skybase>	<1236871414.3213.50.camel@calx> <20090312162733.4e8fd197@skybase>
In-Reply-To: <20090312162733.4e8fd197@skybase>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Thu, 12 Mar 2009 10:23:34 -0500
> Matt Mackall <mpm@selenic.com> wrote:
> 
>> On Thu, 2009-03-12 at 12:54 +0100, Martin Schwidefsky wrote:
>>> On Thu, 12 Mar 2009 14:45:33 +0300
>>> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>>
>>>> On Thu, Mar 12, 2009 at 11:33:08AM +0100, Martin Schwidefsky wrote:
>>>>> --- linux-2.6/fs/proc/task_mmu.c
>>>>> +++ linux-2.6-patched/fs/proc/task_mmu.c
>>>>> @@ -716,7 +716,9 @@ static ssize_t pagemap_read(struct file 
>>>>>  	 * user buffer is tracked in "pm", and the walk
>>>>>  	 * will stop when we hit the end of the buffer.
>>>>>  	 */
>>>>> +	down_read(&mm->mmap_sem);
>>>>>  	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
>>>>> +	up_read(&mm->mmap_sem);
>>>> This will introduce "put_user under mmap_sem" which is deadlockable.
>>> Hmm, interesting. In this case the pagemap interface is fundamentally broken.
>> Well it means we may have to reintroduce the very annoying double
>> buffering from various earlier implementations. But let's leave this
>> discussion until after we've figured out what to do about the walker
>> code.
> 
> Which would be really ugly. I still have not grasped why this will
> introduce a deadlock though. The worst the put_user can do is to cause
> a page fault, no? I do not see where the fault handler acquires the
> mmap_sem as writer. It takes the mmap_sem as reader and two readers
> should be fine.

Somebody else can acquire for write in the meantime, for instance
another thread doing mprotect. This writer is blocked by the first
reader, and the second reader is blocked by the writer. So both
tasks are blocked.

Brice
