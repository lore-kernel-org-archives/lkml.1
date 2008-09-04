Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYIDPDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYIDPDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYIDPDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:03:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:38440 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYIDPDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:03:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="435646645"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] PCI Hotplug: fakephp: fix deadlock... again
Date: Thu, 4 Sep 2008 23:03:26 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E11017B3D1D@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080901184018.GA14492@ldl.fc.hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] PCI Hotplug: fakephp: fix deadlock... again
Thread-Index: AckMYjF7FdIPZE1eQZ2wNarQ+E9IHACPOMKA
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de> <20080821221438.GC20014@ldl.fc.hp.com> <7A25B56E4BE99C4283EB931CD1A40E110177E488@pdsmsx414.ccr.corp.intel.com> <20080830053755.GA16219@suse.de> <7A25B56E4BE99C4283EB931CD1A40E110177E490@pdsmsx414.ccr.corp.intel.com> <7A25B56E4BE99C4283EB931CD1A40E110177E4DA@pdsmsx414.ccr.corp.intel.com> <20080901184018.GA14492@ldl.fc.hp.com>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Alex Chiang" <achiang@hp.com>, <jbarnes@virtuousgeek.org>
Cc: "Greg KH" <gregkh@suse.de>, "Matthew Wilcox" <matthew@wil.cx>,
       <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Sep 2008 15:03:29.0348 (UTC) FILETIME=[63C91040:01C90E9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the fix.

Acked-by: Yu Zhao <yu.zhao@intel.com>

On Tuesday, September 02, 2008 2:40 AM, Alex Chiang wrote:
>* Zhao, Yu <yu.zhao@intel.com>:
>> Just happened to see a change in fakephp when searching usage
>> of the pci_remove_bus_device(). I couldn't find the original
>> patches, but this
>>
>http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commitdiff;
>h=fe99740cac117f208707488c03f3789cf4904957
>> shows, the pci_remove_bus_device() was removed while the
>> remove_slot() was added in disable_slot(), which means: 1)
>> fakephp can't remove pci_dev anymore; 2) deadlock happens
>> because remove_slot() tries to remove the sysfs entry calling
>> itself.
>
>Sorry about introducing this regression. Does the following patch
>fix it for you?
>
>I've tested it on my system, and I can again use fakephp to
>remove a device:
>
>sapphire:/sys/bus/pci/slots # echo 0 > fake4/power
>fakephp: disable_slot - physical_slot = fake4
>e1000 0000:01:02.1: PCI INT B disabled
>GSI 32 (level, low) -> CPU 2 (0x0200) vector 54 unregistered
>fakephp: Slot already scheduled for removal
>fakephp: removing slot fake4
>
>We get the "slot already scheduled for removal" because that
>particular device has 2 functions, and we're creating slots on a
>per-slot basis now, not a per-function basis.
>
>Although, I wonder, Willy -- is that really the right thing to
>do? Seems like fakephp would be more useful if we did operate on
>a per-function basis, and not per-slot. Especially given Yu's
>work with SR-IOV, where we can apparently have lots of functions
>per a physical device.
>
>Hm?
>
>Thanks.
>
>/ac
>
>From: Alex Chiang <achiang@hp.com>
>
>PCI Hotplug: fakephp: fix deadlock... again
>
>Commit fe99740cac117f208707488c03f3789cf4904957 (construct one
>fakephp slot per PCI slot) introduced a regression, causing a
>deadlock when removing a PCI device.
>
>We also never actually removed the device from the PCI core.
>
>So we:
>
>	- remove the device from the PCI core
>	- do not directly call remove_slot() to prevent deadlock
>
>Yu Zhao reported and diagnosed this defect.
>
>Signed-off-by: Alex Chiang <achiang@hp.com>
>---
>diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
>index 40337a0..146ca9c 100644
>--- a/drivers/pci/hotplug/fakephp.c
>+++ b/drivers/pci/hotplug/fakephp.c
>@@ -320,15 +320,15 @@ static int disable_slot(struct hotplug_slot *slot)
> 			return -ENODEV;
> 		}
>
>+		/* remove the device from the pci core */
>+		pci_remove_bus_device(dev);
>+
> 		/* queue work item to blow away this sysfs entry and other
> 		 * parts.
> 		 */
> 		INIT_WORK(&dslot->remove_work, remove_slot_worker);
> 		queue_work(dummyphp_wq, &dslot->remove_work);
>
>-		/* blow away this sysfs entry and other parts. */
>-		remove_slot(dslot);
>-
> 		pci_dev_put(dev);
> 	}
> 	return 0;
