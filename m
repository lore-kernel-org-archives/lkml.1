Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXCGQpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXCGQpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965554AbXCGQpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:45:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:6869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965114AbXCGQpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:45:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,261,1170662400"; 
   d="scan'208"; a="208150630:sNHT21622020"
Message-ID: <45EEEC2C.5090609@intel.com>
Date: Wed, 07 Mar 2007 08:45:32 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu>	<20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk>	<20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz>	<20070305084257.GA4464@mellanox.co.il>	<20070305101120.GA23032@elte.hu> <45ECFC5F.7000102@garzik.org>	<45ED0BBF.1050000@intel.com> <20070306090444.GA25409@elte.hu>	<45ED8A12.5040803@intel.com> <m1ejo1elj6.fsf@ebiederm.dsl.xmission.com> <45EEE8CF.1060803@intel.com>
In-Reply-To: <45EEE8CF.1060803@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 16:45:34.0023 (UTC) FILETIME=[066B0D70:01C760D8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Eric W. Biederman wrote:
>> "Kok, Auke" <auke-jan.h.kok@intel.com> writes:
>>
>>> Ingo Molnar wrote:
>>>> * Kok, Auke <auke-jan.h.kok@intel.com> wrote:
>>>>
>>>>>>> BUG: at drivers/pci/msi.c:611 pci_enable_msi()
>>>>>> I would poke Eric Biederman(sp?) about this one.  Maybe its even solved by
>>>>>> the MSI-enable-related patch he posted in the past 24-48 hours.
>>>>> I tried the 3-patch series "[PATCH 0/3] Basic msi bug fixes.." and they fix
>>>>> this problem for me. Were you expecting the OOPS in the first place? [...]
>>>> the bug was the warning message (a WARN_ON()) above - not an oops. So that
>>>> warning message is gone in your testing?
>>> yes.
>> Sorry for the slow delay.  I was out of town for my brothers wedding the last few
>> days.
>>
>> I wasn't exactly expecting the WARN_ON to trigger.  What I fixed was
>> an inconsistency in handling our state bits.  Fixing that
>> inconsistency appears to have fixed the e1000 usage scenario mostly by
>> accident.
>>
>> The basic issue is that pci_save_state saves the current msi state
>> along with other registers, and then the e1000 driver goes and
>> disables the msi irq after we have saved the irq state as on.
>>
>> My code notices that the msi irq was disabled before restore time, so
>> it skips the restore.  However we now have a leak of the msi saved cap
>> because we are not freeing it. 
>>
>> This leaves with some basic questions.
>> - Does it make sense for suspend/resume methods to request/free irqs?
>> - Does it make sense for suspend/resume methods to allocate/free msi irqs?
>> - Do we want pci_save/restore_cap to save/restore msi state?
>>
>> The path of least resistance is to just free the extra state and we
>> are good.  I'm just not quite certain that is sane and it has been a
>> long day.
> 
> we used to have a lengthy e1000_pci_save|restore_state in our code, which is now 
> gone, so I'm all for that. A separate pci_save_pxie|msi(x)_state for every 
> driver seems completely unnecessary. I can't think of a use case where 
> saving+restoring everything hurts. That's what you want I presume.
> 
> We currently free all irq's and msi before going into suspend in e1000, and I 
> think that is probably a good thing, somehow I can think of bad things happening 
> if we dont, but I admit that I haven't tried it without alloc/free. We do this 
> in e100 as well and it works.
> 
> Another motivation would be to leave this up to the driver: if the driver 
> chooses to free/alloc interrupts because it makes sense, you probably would want 
> to keep that choice available. Devices that don't need this can skip the 
> alloc/free, but leave the choice open for others.

ah, looking at the code in e1000 we do:

_suspend:
	pci_save_state();
	free_irq()

_resume:
	pci_restore_state();
	alloc_irq();

I suppose that's not good either, and the major cause of the warning in the 
first place.

Maybe I can rollback your latest patches and try to fix that mess by postponing 
the pci_save_state until after we free'd the irq's.

Auke
