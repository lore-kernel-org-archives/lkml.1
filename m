Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbXKOSYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbXKOSYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765932AbXKOSXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:23:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:36740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765929AbXKOSXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:23:19 -0500
Date: Thu, 15 Nov 2007 10:23:10 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
Message-ID: <20071115182310.GF24531@suse.de>
References: <20071115091158.GB6216@localhost.sw.ru> <20071115014446.f943d835.akpm@linux-foundation.org> <20071115213345.B3C1.Y-GOTO@jp.fujitsu.com> <20071115163435.GC24087@suse.de> <473C7CE4.5000702@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473C7CE4.5000702@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 12:07:48PM -0500, Mark Lord wrote:
> Greg KH wrote:
>> On Thu, Nov 15, 2007 at 09:55:34PM +0900, Yasunori Goto wrote:
>>>> On Thu, 15 Nov 2007 12:11:58 +0300 Alexey Dobriyan <adobriyan@sw.ru> 
>>>> wrote:
>>>>
>>>>> Three boxes rarely oops during reboot or poweroff with 2.6.24-rc2-mm1
>>>>> (1) and during 2.6.24 cycle (2):
>>>>>
>>>>> 	kernel_restart
>>>>> 	sys_reboot
>>>>> 	[garbage]
>>>>> Code: 8b 88 a8 00 00 00 85 c9 74 04 89
>>>>> EIP is at device_shutdown+0x32/0x60
>>>> Yes, all my test boxes did that - it's what I referred to in the releaee
>>>> notes.  Greg is pondering the problem - seem he's the only person who
>>>> cannot reproduce it ;)
>>> Fortunately, my ia64 box reproduces this oops "every time". So, I could 
>>> chase it.
>>>
>>> device_shutdown() function in drivers/base/power/shutdown.c
>>> is followings.
>>> -----------
>>> /**
>>>  * device_shutdown - call ->shutdown() on each device to shutdown.
>>>  */
>>> void device_shutdown(void)
>>> {
>>>         struct device * dev, *devn;
>>>
>>>         list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
>>>                                 kobj.entry) {
>>>                 if (dev->bus && dev->bus->shutdown) {
>>>                         dev_dbg(dev, "shutdown\n");
>>>                         dev->bus->shutdown(dev);
>>>                 } else if (dev->driver && dev->driver->shutdown) {
>>>                         dev_dbg(dev, "shutdown\n");
>>>                         dev->driver->shutdown(dev);
>>>                 }
>>>         }
>>> }
>>> --------
>>> When oops occured, dev->driver pointed kset_ktype's address,
>>> and dev->driver->shutdown was the address of bus_type_list.
>>> So, Oops was caused by "Illegal operation fault".
>>> kset_ktypes is pointed by system_kset.
>>>
>>> If my understanding is correct, this loop can't distinguish between
>>> struct device and struct kset, but both are connected in this list,
>>> right? It may be the cause of this.
>> Hm, no, it should just be a list of devices for the kset, but I'll go
>> verify that this is correct.
>> And yeah, I can duplicate this problem here too...
> ..
>
> Greg, I don't know if this is relevant or not,
> but x86 has bugs in the halt/reboot code for SMP.
>
> Specifically, in native_smp_send_stop() the code now uses
> spin_trylock() to "lock" the shared call buffers,
> but then ignores the result.
>
> This means that multiple CPUs can/will clobber each other
> in that code.
>
> The second bug, is that this code does not wait for the
> target CPUs to actually stop before it continues.
>
> This was the real cause of the failure-to-poweroff problems
> I was having with 2.6.23, which we fixed by using CPU hotplug
> to disable_nonboot_cpus() before the above code ever got run.

I have noticed that the shutdown path is quite weird, shutting down
sysdev devices differently depending on the type of shutdown, which is
probably not good.

But what change are you talking about for the poweroff problem?  I have
a _lot_ of people reporting that 2.6.22 is not powering off for them and
I can't seem to figure it out.  Do you have a changeset for something
that went in to fix this issue?

thanks,

greg k-h
