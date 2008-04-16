Return-Path: <linux-kernel-owner+w=401wt.eu-S1762162AbYDPU0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162AbYDPU0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYDPUZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:25:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYDPUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:25:57 -0400
Date: Wed, 16 Apr 2008 16:25:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Scott Lovenberg <scott.lovenberg@gmail.com>
Cc: Peter Teoh <htmldeveloper@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: RFC: Self-snapshotting in Linux
Message-ID: <20080416202553.GC27967@redhat.com>
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajd42-7Gt-49@gated-at.bofh.it> <db1091b2-68a6-4f71-800e-c4df6f8641ca@m44g2000hsc.googlegroups.com> <804dabb00804160806o39a2c89eg8d3a3387beb7b5cb@mail.gmail.com> <20080416195053.GB27967@redhat.com> <48065C64.7010808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48065C64.7010808@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 04:07:00PM -0400, Scott Lovenberg wrote:
> Vivek Goyal wrote:
>> On Wed, Apr 16, 2008 at 11:06:05PM +0800, Peter Teoh wrote:
>>   
>>> On 4/16/08, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>>>     
>>>> Scott Lovenberg wrote:
>>>>
>>>>       
>>>>> Peter Teoh wrote:
>>>>>         
>>>>  > Maybe you load up another kernel to handle the snapshot, and then hand
>>>>  > the system back to it afterwards?  What do you think?
>>>>
>>>>
>>>> Isn't that just what Ying Huans kexec-based hibernation does?
>>>>
>>>>       
>>> This list is awesome.   After I read up on this kexec-based hibernation thing:
>>>
>>> http://kerneltrap.org/node/11756
>>>
>>> I realized it is about the same idea.   Some differences though:
>>>
>>> My original starting point was VMWare's snapshot idea.   Drawing an
>>> analogy from there, the idea is to freeze and restore back entire
>>> kernel + userspace application.   For integrity reason, filesystem
>>> should be included in the frozen image as well.
>>>
>>> Currently, what we are doing now is to have a bank of Norton
>>> Ghost-based images of the entire OS and just selectively restoring
>>> back the OS we want to work on.   Very fast - less than 30secs the
>>> entire OS can be restored back.   But problem is that it need to be
>>> boot up - which is very slow.   And there userspace state cannot be
>>> frozen and restored back.
>>>
>>> VMWare images is slow, and cannot meet bare-metal CPU/direct hardware
>>> access requirements.   There goes Xen's virtualization approach as
>>> well.
>>>
>>> Another approach is this (from an email by Scott Lovenberg) - using
>>> RELOCATABLE kernel (or may be not?????I really don't know, but idea is
>>> below):
>>>
>>> a.   Assuming we have 32G (64bit hardware can do that) of memory, but
>>> we want to have 7 32-bit OS running (not concurrently) - so then
>>> memory is partition into 8 x 4GB each - the lowest 4GB reserved for
>>> the current running OS.   Each OS will be housed into each 4G of
>>> memory.   When each OS is running, it will access its own partition on
>>> the harddisk/memory, security concerns put aside.   Switching from one
>>> OS to another OS is VOLUNTARILY done by the user - equivalent to that
>>> of "desktop" feature in Solaris CDE. Restoring back essentially is
>>> just copying from each of the 4GB into the lowest 4GB memory range.
>>> Because only the lowest 4gb is used, only 32 bit instruction is
>>> needed, 64bit is needed only when copying from one 4GB memory
>>> partition into the lowest 4GB region, and vice versa.   And together
>>> with using  partitioning of harddisk for each OS, switching among the
>>> different OS kernel should be in seconds, much less than 1 minute,
>>> correct?
>>>
>>>     
>>
>> [CCing Huang and Eric]
>>
>> I think Huang is doing something very similar in kexec based hibernation
>> and probably that idea can be extended to achive above.
>>
>> Currently if system has got 4G of memory then one can reserve some
>> amount of RAM, lets say 128 MB (with in 4G) and load the kernel there
>> and let it run from there. Huang's implementation is also targetting
>> the same thing where more than one kernel be in RAM at the same time
>> (in mutually exclusive RAM locations) and one can switch between those
>> kernels using kexec techniques.
>>
>> To begin with, he is targetting co-existence of just two kernels and
>> second kernel can be used to save/resume the hibernated image.
>>
>> In fact, because of RELOCATABLE nature of kernel, you don't have to
>> copy the kernel to lower 4GB of memory (Assuming all 64bit kernels
>> running). At max one might require first 640 KB of memory and that
>> can be worked out, if need be.
>>
>> This will indeed need to put devices into some kind of sleep state so
>> that next kernel can resume it.
>>
>> So I think a variant of above is possible where on a large memory system
>> multiple kernels can coexist (while accessing separate disk partitions)
>> and one ought to be able to switch between kernels.
>>
>> Technically, there are few important pieces. kexec, relocatable kernel,
>> hibernation, kexec based hibernation. First three pieces are already
>> in place and fourth one is under development and after that I think
>> it is just a matter of putting everything together.
>>
>> Thanks
>> Vivek
>>   
> What about the way that the kernel does interrupt masks on CPUs during a 
> critical section of code on SMP machines?  It basically flushes the TLB, 
> and the cache, moves the process in critical section to a (now) isolated 
> CPU, and reroutes interrupts to another CPU.  If you took that basic model 
> and applied it to kernels instead of CPUs, you could probably get the 
> desired hand off of freezing one after flushing its caches back (or 
> sideways and then back in SMP) and moving the mm to your unfrozen kernel 
> and routing the processes there. After snapshotting, flush the cache back 
> again, and reroute each process to the once again unfrozen kernel, handing 
> them back again?  Would this basic model work for isolation and 
> snapshotting and then transitioning back?  Oh, yeah, and block each process 
> so it doesn't try to run anything during snapshot :-).  Or, save PCs and 
> then load them back again, I guess... although that's a waste, and a 
> disaster waiting to happen... not that I've let that deter me before :-).  
> Unfortunately, this is so far out of my skill range and knowledge base, 
> that I can't speak intelligently on it at any lower level.  Can someone 
> fill in the gaps for me?

Not very sure what you are saying here but one important piece missing
from your prposal seems to be state of various devices between kernels.

Thanks
Vivek

