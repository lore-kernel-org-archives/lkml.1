Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYFIITl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYFIITl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYFIITc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:19:32 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45684 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbYFIITa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:19:30 -0400
Message-ID: <484CE515.4030205@jp.fujitsu.com>
Date: Mon, 09 Jun 2008 17:08:53 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kaneshige.kenji@jp.fujitsu.com, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4, v14] PCI, ACPI: Physical PCI slot objects
References: <20080604200829.GC379@ldl.fc.hp.com>
In-Reply-To: <20080604200829.GC379@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Hi Jesse, Ben, Kenji-san,
> 
> This is v14 of the physical PCI slot series.
> 
> This patchset has been kicking around -mm for the past few
> months, and they were getting clobbered on a continual basis, so
> let's say I'm quite motivated to get them into mainline. ;)
> 
> This mail describes two things:
> 
> 	- an update for handling pSeries
> 	- explanation of how I did not regress Kenji-san's latest
> 	  changes
> 
> Review comments are much appreciated.
> 
> -----------------------
> pSeries-related changes
> -----------------------
> The most recent outstanding issue with this series was breakage
> with pSeries. In a nutshell, the problem was:
> 
> 	- pci_hp_register() interface changed to require a devfn
> 	  when registering a slot
> 
> 	- pSeries doesn't necessarily know the devfn of an
> 	  unpopulated slot
> 
> There are more details, of course, and they are in the archives.
> I can dig them up if people want more context.
> 
> After working offline with BenH and Willy, we thought that the
> best way forward was for the new infrastructure to provide a new
> API, pci_update_slot_number(), which can be used by callers to
> modify the slot number after slot creation. 
> 
> This change goes hand in hand with modifying the semantics of
> pci_hp_register() where callers are now allowed to pass -1 for
> slot_nr to create a 'placeholder' slot.
> 
> The third related change is that the infrastructure will only
> display an 'address' value of 'dddd:bb' (domain:bus) when the
> device is -1. In the normal case, the full address of dddd:bb:dd
> is displayed.
> 
> I did fold an earlier -mm fixup patch into these changes to
> improve future bisectability.
> 
> I added kerneldoc to explain the APIs.
> 
> -----------------------------
> maintaining Kenji-san's fixes
> -----------------------------
> Finally, this patch series slightly changes the logic introduced
> by Kenji-san's patches:
> 
> 	9e4f2e8d4ddb04ad16a3828cd9a369a5a5287009
> 	a86161b3134465f072d965ca7508ec9c1e2e52c7
> 
> For a86161b31344, the check against registering a slot with the
> same name multiple times is removed. That check prevents a
> scenario where multiple pcihp drivers try to claim the same slot.
> 
> The check is removed because the new code allows multiple callers
> of pci_create_slot(). One callsite is pci_hp_register(), the
> other is in the ACPI slot detection driver provided in patch 4/4.
> In the case of multiple legitimate callers, the correct thing to
> do is refcount the struct pci_slot's kobj.
> 
> In the case of two pcihp drivers attempting to claim the same
> slot, pci_hp_register() returns -EBUSY to indicate it has already
> been claimed. This logic has been part of the patch series from
> the beginning.
> 
> Thus, the end behavior introduced by a86161b31344 is preserved,
> although in a slightly different implementation.
> 
> The firmware defect that Kenji-san is trying to fix with
> 9e4f2e8d4d is the case where broken firmware will present the
> kernel with slots like bb1:dd1, name "A" and bb2:dd2, name "A".
> 
> In other words, two different busses or two different devices on
> the same bus, but both have the same name.
> 
> In this case, pci_create_slot() thinks they are two different
> physical slots (which is true), and tries to register them with
> the kobject core, which will then complain about registering two
> objects with the same name. -EEXIST will be returned back up
> through the pcihp core and back to pciehp, which will then printk
> the message added by 9e4f2e8d4d.
> 
> Thus, the condition Kenji-san is trying to warn about with
> 9e4f2e8d4d is preserved.
> 

I tried your patches and I have a comment (question) about the behavior.

To emulate the (broken?) platform that assigns the same name to multiple
slots, I made a debug patch for pciehp driver to assign same name ('1000')
to all slots (my environment has two PCIe slots). With this patch, I
noticed that the behavior or pci_hp_register() (or pci_create_slot())
varies depending on whether pci_slot driver is loaded or not. See below.

(a) With pci_slot driver loaded
    I got the following error message when I loaded pciehp driver.

        pciehp: pci_hp_register failed with error -17
        pciehp: Failed to register slot because of name collision. Try
        'pciehp_slot_with_bus' module option.
        pciehp: pciehp: slot initialization failed
      
(b) Without pci_slot driver loaded
    I got the kernel stack dump and error messages when I loaded pciehp
    driver.

	kobject_add_internal failed for 1000 with -EEXIST, don't try to
	register things with the same name in the same directory.

	Call Trace:
 	 [<a000000100015180>] show_stack+0x40/0xa0
	                                sp=e0000040a086fb80 bsp=e0000040a0861158
 	 [<a000000100015210>] dump_stack+0x30/0x60
                                sp=e0000040a086fd50 bsp=e0000040a0861140
	 [<a0000001003b3910>] kobject_add_internal+0x330/0x400
	                                sp=e0000040a086fd50 bsp=e0000040a0861100
	 [<a0000001003b3bd0>] kobject_add_varg+0x90/0xc0
	                                sp=e0000040a086fd50 bsp=e0000040a08610c8
	 [<a0000001003b3c90>] kobject_init_and_add+0x90/0xc0
	                                sp=e0000040a086fd50 bsp=e0000040a0861068
	 [<a0000001003d69b0>] pci_create_slot+0x150/0x260
	                                sp=e0000040a086fd80 bsp=e0000040a0861030
	 [<a000000200b71870>] pci_hp_register+0x130/0x880 [pci_hotplug]
	                                sp=e0000040a086fd80 bsp=e0000040a0860ff0
	 [<a000000200ec1a60>] pciehp_probe+0x720/0xca0 [pciehp]

	(snip...)

	Unable to register kobject 1000
	pciehp: pci_hp_register failed with error -17
	pciehp: Failed to register slot because of name collision. Try 
	'pciehp_slot_with_bus' module option.
	pciehp: pciehp: slot initialization failed

Could you tell me why that difference happen? And my expectation is
the result should be (a) above regardless of whether pci_slot driver
is loaded or not.

Thanks,
Kenji Kaneshige


