Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZBTWi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZBTWi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZBTWiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:38:50 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43817 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbZBTWit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:38:49 -0500
Message-ID: <499F30F4.509@linux.vnet.ibm.com>
Date: Fri, 20 Feb 2009 14:38:44 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
References: <20090121185021.GA8852@elte.hu> <499DD4BE.2000704@linux.vnet.ibm.com> <20090220081040.GA11490@elte.hu>
In-Reply-To: <20090220081040.GA11490@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> 
>> Ingo Molnar wrote:
>>> We are pleased to announce version 6 of our performance counters 
>>> subsystem implementation. The shortlog, diffstat and the combo patch 
>>> can be found below. The combo patch against latest -git (2.6.29-rc2) 
>>> can be also found at:
>>>
>> [snip]
>>
>> Hi Ingo,
>>
>> As I was starting to put together a simple implementation of 
>> PAPI on top of PCL for Power, I noticed that PCL does not seem 
>> to have any sort of versioning and way of ascertaining the 
>> current capabilities of what is in the kernel.
>>
>> This information is needed by tools and libraries built on top 
>> of PCL so that they can know what is supported and if any bugs 
>> need to be worked around.
> 
> I'd prefer to use the standard Linux syscall ABI convention 
> here:
> 
>  - once upstream, existing functionality is compatible forever
> 
>  - new functionality is added in a way that it generates a 
>    -ENOSYS return from the syscall in an older kernel.
> 
> That's why the event structure is sized relatively large for 
> example - to make sure we have space to grow into.
> 
> So instead of adding versioning information, it would be very 
> nice if you could check the ABI details for 'traps' that make 
> extensions harder. Try to come up with pie-in-the-sky future 
> items you'd like to see in the ABI, and lets see how supportable 
> it would be.
> 
> Example #1 - made up. Say if we had an ABI detail like this:
> 
>   struct perf_counter_hw_event {
>           u8                     type;
> 
> this would limit us to 256 events - which would be clearly 
> stupid as we can easily hit that limit.
> 
> Example #2. Not made up:
> 
> asmlinkage int
> sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr __user,
>                       pid_t pid, int cpu, int group_fd)
> 
> Those are 5 parameters - we could extend it to 6 and add a 
> 'flags' value that in the current version will return -ENOSYS if 
> the flags value is not zero.
> 
> This would add one more dimension of extensibility to the 
> interface.
> 
> If you could come up with a list of small details like this, 
> that would be really helpful. Would this work?
> 
> 	Ingo

Thanks for the reply.  As I flesh out this PAPI code, I will keep 
thinking about these issues.

I think the method you describe is good for adding new event types and 
accessing fancy PMU hardware (instruction matching CAM's for example).

There may be other non-event-related changes that will not be handled 
quite as well in this way.  In the original email I hinted at that we 
may want an option for mmap'd sample buffers at some point, and so I'm 
not clear how you'd provide an ABI to request mmap'd buffers (you would 
probably need to be able to request the size and get back a pointer to 
the mmap'd buffer).  Would this be done through a special 
sys_perf_counter_open call?  Or through a subsequent ioctl call on the 
group leader after an open (which requires the counters to be initially 
disabled), etc.

For bugs in the kernel that need to be worked around, I assume you would 
suggest to the tool programmers that they somehow test for the bug's 
presence?  What if the bug causes a system crash?  Perhaps a better 
solution for that case would be to check the kernel's version number 
rather than create a separate PCL version?

Thanks for your consideration,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com



