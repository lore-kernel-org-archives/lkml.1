Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYDWNma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYDWNma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYDWNmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:42:23 -0400
Received: from rtr.ca ([76.10.145.34]:4708 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbYDWNmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:42:22 -0400
Message-ID: <480F3CBC.60305@rtr.ca>
Date: Wed, 23 Apr 2008 09:42:20 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <480E70ED.3030701@rtr.ca> <20080423072432.GX12774@kernel.dk>
In-Reply-To: <20080423072432.GX12774@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Date:	Thu, 15 Nov 2007 12:07:48 -0500
>>> From: Mark Lord <lkml@rtr.ca>
>>> To: Greg KH <gregkh@suse.de>
>>> Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
>>> 	Andrew Morton <akpm@linux-foundation.org>,
>>> 	Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
>>> Subject: Re: EIP is at device_shutdown+0x32/0x60
>>> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>>> Content-Transfer-Encoding: 7bit
>>> Sender: linux-kernel-owner@vger.kernel.org
>>>
>>> ... < snip > ...
>>>
>>> Greg, I don't know if this is relevant or not,
>>> but x86 has bugs in the halt/reboot code for SMP.
>>>
>>> Specifically, in native_smp_send_stop() the code now uses
>>> spin_trylock() to "lock" the shared call buffers,
>>> but then ignores the result.
>>>
>>> This means that multiple CPUs can/will clobber each other
>>> in that code.
>>>
>>> The second bug, is that this code does not wait for the
>>> target CPUs to actually stop before it continues.
>>>
>>> This was the real cause of the failure-to-poweroff problems
>>> I was having with 2.6.23, which we fixed by using CPU hotplug
>>> to disable_nonboot_cpus() before the above code ever got run.

Jens Axboe wrote:
> On Tue, Apr 22 2008, Mark Lord wrote:
>> Jens,
>>
>> While you're in there, :)
>>
>> Could you perhaps fix this bug (above) if it still exists?
> 
> I don't understand the bug - what are the shared call buffers you are
> talking of?
> 
> With the changes, there's not even an spin_trylock() in there anymore.
> But I don't see the original bug either, so...
..

arch/x86/kernel/smp.c:

static void native_smp_send_stop(void)
{
        int nolock;
        unsigned long flags;

        if (reboot_force)
                return;

        /* Don't deadlock on the call lock in panic */
        nolock = !spin_trylock(&call_lock);       <<<<<<<<<< buggy
        local_irq_save(flags);
        __smp_call_function(stop_this_cpu, NULL, 0, 0);
        if (!nolock)
                spin_unlock(&call_lock);
        disable_local_APIC();
        local_irq_restore(flags);
}

The spinlock is trying to protect access to the global variable
"call_data" (higher up in the same file), which is used
in __smp_call_function() and friends.

But since the spinlock is ignored in this case,
the global "call_data will get clobbered if it was already in-use.

The second bug, is that for the halt case at least,
nobody waits for the other CPU to actually halt
before continuing.. so we sometimes enter the shutdown
code while other CPUs are still active.

This causes some machines to hang at shutdown,
unless CPU_HOTPLUG is configured and takes them offline
before we get here.

Cheers
