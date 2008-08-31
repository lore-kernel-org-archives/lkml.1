Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYHaDPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYHaDPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 23:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYHaDOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 23:14:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:15663 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbYHaDOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 23:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,299,1217833200"; 
   d="scan'208";a="375166160"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: problems in fakephp (was RE: refcount leak in pci_get_device()?)
Date: Sun, 31 Aug 2008 11:14:38 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110177E4DA@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110177E490@pdsmsx414.ccr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: problems in fakephp (was RE: refcount leak in pci_get_device()?)
Thread-Index: AckKYq7Nz0ZfxC9ASHifJs16Et9eRgABI+4gACuK9yA=
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de> <20080821221438.GC20014@ldl.fc.hp.com> <7A25B56E4BE99C4283EB931CD1A40E110177E488@pdsmsx414.ccr.corp.intel.com> <20080830053755.GA16219@suse.de> <7A25B56E4BE99C4283EB931CD1A40E110177E490@pdsmsx414.ccr.corp.intel.com>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Alex Chiang" <achiang@hp.com>, "Greg KH" <gregkh@suse.de>
Cc: "Matthew Wilcox" <matthew@wil.cx>, <linux-pci@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 31 Aug 2008 03:14:40.0606 (UTC) FILETIME=[B50707E0:01C90B17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just happened to see a change in fakephp when searching usage of the pci_remove_bus_device(). I couldn't find the original patches, but this http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commitdiff;h=fe99740cac117f208707488c03f3789cf4904957 shows, the pci_remove_bus_device() was removed while the remove_slot() was added in disable_slot(), which means: 1) fakephp can't remove pci_dev anymore; 2) deadlock happens because remove_slot() tries to remove the sysfs entry calling itself.

On Saturday, August 30, 2008 2:21 PM, Zhao, Yu wrote:
>It's been so for a while, guess since 2.5. I meant to say the
>pci_remove_bus_device(), not pci_remove_bus(), is used by pci hotplug code. If
>a device is being plugged off, and some drivers are calling pci_get_dev_by_id()
>to search something, then the warning might be fired through bus_find_device
>-> klist_iter_init_node ->kref_get.
>
>Thanks,
>Yu
>
>>-----Original Message-----
>>From: linux-pci-owner@vger.kernel.org
>>[mailto:linux-pci-owner@vger.kernel.org] On Behalf Of Greg KH
>>Sent: Saturday, August 30, 2008 1:38 PM
>>To: Zhao, Yu
>>Cc: Alex Chiang; Matthew Wilcox; linux-pci@vger.kernel.org;
>>linux-kernel@vger.kernel.org
>>Subject: Re: refcount leak in pci_get_device()?
>>
>>On Sat, Aug 30, 2008 at 12:23:20PM +0800, Zhao, Yu wrote:
>>> And the pci_get_dev_by_id() is not safe again the PCI device removal.
>>> It might fire a warning in bus_find_device() when reference count of
>>> the knode_bus is decreased to 0 by pci_remove_bus().
>>
>>Is this something new?  Hasn't this always been that way?  Why would you
>>be wanting to call this function anyway?
>>
>>thanks,
>>
>>greg k-h
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>--
>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
