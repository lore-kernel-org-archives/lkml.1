Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbYIJIRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbYIJIRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYIJIRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:17:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:11561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbYIJIRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:17:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,371,1217833200"; 
   d="scan'208";a="334780522"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/4 v2] PCI: introduce new base functions
Date: Wed, 10 Sep 2008 16:17:18 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110181CB4E@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080901161534.GF16796@ldl.fc.hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/4 v2] PCI: introduce new base functions
Thread-Index: AckMTgFBuWQMWOYaS5id0r8ourkbQQGzYaHQ
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6D@pdsmsx414.ccr.corp.intel.com> <20080901161534.GF16796@ldl.fc.hp.com>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Alex Chiang" <achiang@hp.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
X-OriginalArrivalTime: 10 Sep 2008 08:17:21.0191 (UTC) FILETIME=[A5B5E370:01C9131D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 02, 2008 12:16 AM, Alex Chiang wrote:
>* Zhao, Yu <yu.zhao@intel.com>:
>> Some basic changes to allocation bus range, MMIO resource for SR-IOV device.
>
>This following comment is a bit confusing:
>> And add new sysfs entry to hotplug core to pass parameter to a
>> slot, which will be used by SR-IOV code.
>
>I was reading this patch, expecting to see a change to the
>hotplug core _API_ taking a param, not just a new sysfs entry.
>
>I would suggest rewording this part of the changelog as:
>
>	Add new sysfs file 'param' to /sys/bus/pci/slots/.../
>	which allows the user to pass a parameter to a slot. This
>	parameter will be used by the SR-IOV code.
>
>More about this new 'param' file below.
>
>>
>
>Please break the 80-column "rule" and make this all one line, to
>help with greppability.
>
>I know the prior version had it broken across two lines too, but
>we can improve it now. :)

Sure, will do this in next version :-)

>
>> +			continue;
>> +		}
>> +		child->is_added = 1;
>> +		retval = device_create_file(&child->dev,
>> +					    &dev_attr_cpuaffinity);
>> +		if (retval)
>> +			dev_err(&dev->dev, "Error creating cpuaffinity"
>> +					   " file, continuing...\n");
>
>This one too, please.
>
>> diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
>> index e1098c3..f6f2a59 100644
>> --- a/drivers/pci/proc.c
>> +++ b/drivers/pci/proc.c
>> @@ -352,15 +352,16 @@ static int show_device(struct seq_file *m, void *v)
>>  			dev->vendor,
>>  			dev->device,
>>  			dev->irq);
>> -	/* Here should be 7 and not PCI_NUM_RESOURCES as we need to preserve
>compatibility */
>> -	for (i=0; i<7; i++) {
>> +
>> +	/* only print standard and ROM resources to preserve compatibility */
>> +	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
>
>Why not:
>
>	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
>
>Looks like the tradeoff is explicit mention of PCI_ROM_RESOURCE
>vs using a non-standard C idiom (personally, I'm not a huge fan
>of <= in a for loop, but ymmv).
>
>Again, this is a minor nit, feel free to ignore.

It can be PCI_BRIDGE_RESOURCES, because there may be some non-standard resources following PCI_ROM_RESOURCE and before PCI_BRIDGE_RESOURCES.

For example, a standard PCI device has following resources:
	0 - 5   BARs
	6       ROM
	7 - 10  Bridge

After SR-IOV is enabled, it becomes
	0 - 5   standard BARs
	6       Rom
     7 - 12  SR-IOV BARs
	13 - 16 Bridge

>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index c0e1400..687be00 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -76,7 +76,29 @@ enum pci_mmap_state {
>>  #define PCI_DMA_FROMDEVICE	2
>>  #define PCI_DMA_NONE		3
>>
>> -#define DEVICE_COUNT_RESOURCE	12
>> +/*
>> + *  For PCI devices, the region numbers are assigned this way:
>> + */
>> +enum {
>> +	/* 0-5	standard PCI regions */
>> +	PCI_STD_RESOURCE,
>> +
>> +	/* expansion ROM */
>> +	PCI_ROM_RESOURCE = 6,
>> +
>> +	/* address space assigned to buses behind the bridge */
>> +#ifndef PCI_BRIDGE_NUM_RES
>> +#define PCI_BRIDGE_NUM_RES 4
>> +#endif
>> +	PCI_BRIDGE_RESOURCES,
>> +	PCI_BRIDGE_RES_END = PCI_BRIDGE_RESOURCES + PCI_BRIDGE_NUM_RES - 1,
>> +
>> +	/* total resources associated with a PCI device */
>> +	PCI_NUM_RESOURCES,
>> +
>> +	/* preserve this for compatibility */
>> +	DEVICE_COUNT_RESOURCE
>> +};
>
>Ouch, this enum makes my head hurt a little. Care to put in a
>comment for PCI_BRIDGE_RES_END, saying that it has a value of 10?

Same as above, the PCI_BRIDGE_RES_END varies when some features is enabled or disabled.

Thank you very much for carefully reviewing these patches. I'd like to invite you to review next version again if it's convenient for you.

>
>Thanks,
>
>/ac

