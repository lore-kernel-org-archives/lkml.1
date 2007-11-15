Return-Path: <linux-kernel-owner+w=401wt.eu-S1764940AbXKORH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764940AbXKORH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXKORHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:07:50 -0500
Received: from rtr.ca ([76.10.145.34]:3836 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbXKORHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:07:49 -0500
Message-ID: <473C7CE4.5000702@rtr.ca>
Date: Thu, 15 Nov 2007 12:07:48 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
References: <20071115091158.GB6216@localhost.sw.ru> <20071115014446.f943d835.akpm@linux-foundation.org> <20071115213345.B3C1.Y-GOTO@jp.fujitsu.com> <20071115163435.GC24087@suse.de>
In-Reply-To: <20071115163435.GC24087@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Nov 15, 2007 at 09:55:34PM +0900, Yasunori Goto wrote:
>>> On Thu, 15 Nov 2007 12:11:58 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
>>>
>>>> Three boxes rarely oops during reboot or poweroff with 2.6.24-rc2-mm1
>>>> (1) and during 2.6.24 cycle (2):
>>>>
>>>> 	kernel_restart
>>>> 	sys_reboot
>>>> 	[garbage]
>>>> Code: 8b 88 a8 00 00 00 85 c9 74 04 89
>>>> EIP is at device_shutdown+0x32/0x60
>>> Yes, all my test boxes did that - it's what I referred to in the releaee
>>> notes.  Greg is pondering the problem - seem he's the only person who
>>> cannot reproduce it ;)
>> Fortunately, my ia64 box reproduces this oops "every time". 
>> So, I could chase it.
>>
>> device_shutdown() function in drivers/base/power/shutdown.c
>> is followings.
>> -----------
>> /**
>>  * device_shutdown - call ->shutdown() on each device to shutdown.
>>  */
>> void device_shutdown(void)
>> {
>>         struct device * dev, *devn;
>>
>>         list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
>>                                 kobj.entry) {
>>                 if (dev->bus && dev->bus->shutdown) {
>>                         dev_dbg(dev, "shutdown\n");
>>                         dev->bus->shutdown(dev);
>>                 } else if (dev->driver && dev->driver->shutdown) {
>>                         dev_dbg(dev, "shutdown\n");
>>                         dev->driver->shutdown(dev);
>>                 }
>>         }
>> }
>> --------
>> When oops occured, dev->driver pointed kset_ktype's address,
>> and dev->driver->shutdown was the address of bus_type_list.
>> So, Oops was caused by "Illegal operation fault".
>> kset_ktypes is pointed by system_kset.
>>
>> If my understanding is correct, this loop can't distinguish between
>> struct device and struct kset, but both are connected in this list,
>> right? It may be the cause of this.
> 
> Hm, no, it should just be a list of devices for the kset, but I'll go
> verify that this is correct.
> 
> And yeah, I can duplicate this problem here too...
..

Greg, I don't know if this is relevant or not,
but x86 has bugs in the halt/reboot code for SMP.

Specifically, in native_smp_send_stop() the code now uses
spin_trylock() to "lock" the shared call buffers,
but then ignores the result.

This means that multiple CPUs can/will clobber each other
in that code.

The second bug, is that this code does not wait for the
target CPUs to actually stop before it continues.

This was the real cause of the failure-to-poweroff problems
I was having with 2.6.23, which we fixed by using CPU hotplug
to disable_nonboot_cpus() before the above code ever got run.

Maybe it's related, maybe not.

