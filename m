Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZBKULk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZBKULk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbZBKULb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:11:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBKULa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:11:30 -0500
Message-ID: <499330D9.6090808@redhat.com>
Date: Wed, 11 Feb 2009 22:11:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.28.4 freezing on a 32-bits x86 Thinkpad T43p
References: <20090204211106.GA30824@Krystal> <20090204211759.GK22608@elte.hu> <20090211193125.GA30975@Krystal>
In-Reply-To: <20090211193125.GA30975@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
>   
>> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
>>
>>     
>>> Hi,
>>>
>>> I've started experiencing freezes on my uniprocessor laptop with a
>>> 2.6.28.2/2.6.28.3 kernel with the LTTng patchset applied
>>> (http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=shortlog;h=2.6.28.3-lttng-0.88).
>>> Instrumentation is dynamically disabled when this happens, so it's
>>> unlikely that the LTTng patches would be causing this problem.
>>>
>>> It happens when I work in X. The keyboard and mouse stop responding, and
>>> the machine stops answering to the network. It may take a few days to
>>> reproduce, and happens randomly when I actively use the computer (e.g
>>> surfing with firefox).
>>>
>>> I managed to install a 50' serial cable through my appartment to capture
>>> the following OOPS. It points to a NULL pointer dereference in
>>> kernel/timer.c:cascade(). My config has hrtimers and no_hz activated.
>>> I suspect a race with with timer base lock or interrupt disabling
>>> protecting the timer base.
>>>
>>> Any idea what is going on with the timers here ? In the meantime, I'll
>>> try to enable more debugging options to get more information when the
>>> problem reappears.
>>>       
>> hm, it would be nice to know which timer got corrupted. It could possibly 
>> have gotten kfreed, reallocated, overwritten - and crashes things like this.
>>
>> There's two ways to debug such things more directly:
>>
>> 1) enable CONFIG_PAGEALLOC=y. These days its plenty fast and its overhead 
>>    cannot be noticed.
>>
>> 2) enable DEBUGOBJECTS - you also need 'debugobjects' on the boot line for 
>>    this to be activated. This will report such corruptions sooner and in a 
>>    more specific way.
>>
>> 3) any particular reason why you have:
>>
>>     # CONFIG_DEBUG_KERNEL is not set
>>
>>    There's a number of goodies in that menu. CONFIG_LIST_DEBUG=y for 
>>    example.
>>
>> It is highly unlikely that the timer list code is the culprit here - it has 
>> not changed in ages and it is very intensively used by all subsystems so 
>> breakages in it get found and reported very, very quickly.
>>
>> btw., your stacktrace also has this:
>>
>>     
>>>  [<c1010000>] kvm_mmu_pte_write+0xb0/0xa60
>>>       
>> So in theory there could be some kvm induced memory corruption as well.
>>
>> Hope this helps,
>>
>> 	Ingo
>>     
>
> Hi Ingo,
>
> Thanks for the hints.
>
> Here is a new backtrace, taken with a huge amount of debugging active,
> which still points to an interrupt handler nested over kvm_mmu_pte_write
> as the culprit. It's weird that the kvm code gets called on my modest
> Pentium M laptop, which I think has no VT-x support at all. I am not
> running any KVM VMs on this machine. The problem still happens on
> 2.6.28.4, and Slub redzones did not identify any memory corruption. This
> could be due to kvm_mmu_pte_write which either should not be called at
> all, or due to improper interrupt disabling in this function.
>
>   

I think kvm_mmu_pte_write is just random crap on the stack here.  Your 
cpu definitely has no VT support so that code cannot be enabled at all.

Note the address is 64KB aligned which further suggests it isn't a real EIP.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

