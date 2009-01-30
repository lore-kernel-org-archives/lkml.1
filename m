Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZA3Qlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZA3Qlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZA3Qk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:40:58 -0500
Received: from gw.goop.org ([64.81.55.164]:60240 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbZA3Qk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:40:57 -0500
Message-ID: <49832D93.5010307@goop.org>
Date: Fri, 30 Jan 2009 08:40:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: paulmck@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: Seeing "huh, entered softirq 8 ffffffff802682aa preempt_count
 00000100, exited with 00010100?" in tip.git
References: <498229CF.1090007@goop.org> <20090130005953.GD6716@linux.vnet.ibm.com> <49825B8B.2000202@goop.org> <20090130150859.GB27549@elte.hu>
In-Reply-To: <20090130150859.GB27549@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Paul E. McKenney wrote:
>>     
>>> On Thu, Jan 29, 2009 at 02:12:31PM -0800, Jeremy Fitzhardinge wrote:
>>>   
>>>       
>>>> When I boot my x86-64 tip.git kernel under Xen, I'm seeing:
>>>>
>>>> pnp: PnP ACPI: disabled
>>>> NET: Registered protocol family 2
>>>> huh, entered softirq 8 ffffffff802682aa preempt_count 00000100, 
>>>> exited with 00010100?
>>>> IP route cache hash table entries: 512 (order: 0, 4096 bytes)
>>>> TCP established hash table entries: 1024 (order: 2, 16384 bytes)
>>>> [...]
>>>> XENBUS: Device with no driver: device/console/0
>>>> Freeing unused kernel memory: 372k freed
>>>> Red Hat nash version 6.0.19 starting
>>>> Mounting proc filesystem
>>>> Mounting sysfs filesystem
>>>> Creating /dev
>>>> BUG: scheduling while atomic: swapper/0/0x00010000
>>>> Modules linked in:
>>>> Pid: 0, comm: swapper Not tainted 2.6.29-rc3-tip #481
>>>> Call Trace:
>>>> [<ffffffff80238c1f>] __schedule_bug+0x62/0x66
>>>> [<ffffffff80211d2d>] ? retint_restore_args+0x5/0x20
>>>> [<ffffffff80503921>] __schedule+0x95/0x792
>>>> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
>>>> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
>>>> [<ffffffff805040c2>] schedule+0xe/0x22
>>>> [<ffffffff8020ff04>] cpu_idle+0x70/0x72
>>>> [<ffffffff804fc3a0>] cpu_bringup_and_idle+0x13/0x15
>>>> Creating initial device nodes
>>>> Setting up hotplug.
>>>>
>>>>
>>>> From what I can see, softirq 8 is the RCU softirq.  I don't know if 
>>>> the "scheduling while atomic" is related or not, but its two new 
>>>> schedulerish symptoms appearing at once, so I think its likely 
>>>> they're related.
>>>>     
>>>>         
>>> Hmmm...  Mysterious, as you seem to be using classic RCU, which hasn't
>>> changed in awhile.  Which branch of the tip tree are you using?
>>>   
>>>       
>> tip/master.  It looks like this appeared since -rc1.  Mu current  
>> suspicion is the percpu changes, since I'm seeing some other strange  
>> symptoms.
>>     
>
> Cc:-ed more folks - it's either the percpu changes or the APIC changes 
> (both occured at about the same time). Or maybe something from upstream.
>   

In my case I'm only seeing it when running under Xen, so I don't think 
this particular problem is apic related.  My current theory - dreamed up 
last night and completely untested/uninvestigated - is that interrupt 
masking isn't working.  In Xen, interrupts are masked via a per-cpu 
piece of memory shared with the hypervisor, so if the percpu setup is 
wrong in some way, the kernel and Xen could be using different memory 
for the mask, with hilarious results.

    J
