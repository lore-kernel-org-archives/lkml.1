Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbYH3EXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbYH3EXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 00:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYH3EXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 00:23:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:63193 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYH3EXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 00:23:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,295,1217833200"; 
   d="scan'208";a="610995161"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: refcount leak in pci_get_device()?
Date: Sat, 30 Aug 2008 12:23:20 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110177E488@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080821221438.GC20014@ldl.fc.hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: refcount leak in pci_get_device()?
Thread-Index: AckD23noVavNC9peTpiSOQNGwz4ySwGevwMg
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de> <20080821221438.GC20014@ldl.fc.hp.com>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Alex Chiang" <achiang@hp.com>, "Greg KH" <gregkh@suse.de>
Cc: "Matthew Wilcox" <matthew@wil.cx>, <linux-pci@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Aug 2008 04:23:23.0060 (UTC) FILETIME=[23C9D740:01C90A58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And the pci_get_dev_by_id() is not safe again the PCI device removal. It might fire a warning in bus_find_device() when reference count of the knode_bus is decreased to 0 by pci_remove_bus().

Need to document this or a fix?

Thanks,
Yu

On Friday, August 22, 2008 6:15 AM, Alex Chiang wrote:
>* Greg KH <gregkh@suse.de>:
>> On Thu, Aug 21, 2008 at 02:25:04PM -0600, Matthew Wilcox wrote:
>> > On Thu, Aug 21, 2008 at 02:19:18PM -0600, Alex Chiang wrote:
>> > > #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID,
>PCI_ANY_ID, d)) != NULL)
>> > >
>> > > That eventually calls pci_get_dev_by_id(), which increases the
>> > > refcount on the device, but never decrements it.
>> > >
>> > > Looks like that change in behavior happened here:
>> > >
>> > > 	PCI: clean up search.c a lot
>> > > 	95247b57ed844511a212265b45cf9a919753aea1
>> > >
>> > > pci_get_device() used to decrement the refcount, but no longer
>> > > does.
>> > >
>> > > Thanks to Matthew Wilcox for helping me get this far...
>> > >
>> > > Like I said, I'm still trying to track down my particular issue,
>> > > but I'd like to get your opinion on this.
>> >
>> > In particular, I'd like to know whether this should be fixed by
>> > pci_get_dev_by_id() decrementing the refcount of from/dev_start,
>> > pci_get_subsys() decrementing 'from', or by bus_find_device()
>> > decrementing 'start'.  It looks like bus_find_device() is the place
>> > where this should logically happen, but the kerneldoc doesn't document
>> > the intended behaviour.
>>
>> Ah, no the driver core isn't supposed to do this, it's something the pci
>> functions do out of "niceness" as that's how we can use them in an
>> iterator properly.
>>
>> Does the following (untested) patch fix the issue for you all?
>
>Perfect, yes.
>
>I applied it, and observed the refcount on the device I was using
>to debug this problem.
>
>I was able to modprobe acpiphp successfully, and echo 0 into the
>device's 'power' file.
>
>I then watched the rest of the hotplug core do its thing,
>decrementing the refcount properly along the way, and at the end,
>we did call pci_release_dev(), as I originally expected to. :)
>
>Just to verify, I toggled the device's power a few times (echoing
>a 1 and then a 0, etc.) and watched the refcounts. After each
>offline, we properly called pci_release_dev().
>
>Thanks for fixing this. It fixes a pretty bad leak in the hotplug
>core (we were leaking an entire struct pci_dev * # of functions
>for each offlined card, the first time around; subsequent
>onlines/offlines were ok).
>
>Tested-by: Alex Chiang <achiang@hp.com>
>
>/ac
>
>>
>> thanks,
>>
>> greg k-h
>>
>> --------------
>> Subject: PCI: fix reference leak in pci_get_dev_by_id()
>>
>> From: Greg Kroah-Hartman <gregkh@suse.de>
>>
>> Alex Chiang and Matthew Wilcox pointed out that pci_get_dev_by_id() does
>> not properly decrement the reference on the from pointer if it is
>> present, like the documentation for the function states it will.
>>
>> Cc: Matthew Wilcox <matthew@wil.cx>
>> Cc: Alex Chiang <achiang@hp.com>
>> Cc: stable <stable@kernel.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>
>>
>> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
>> index 217814f..3b3b5f1 100644
>> --- a/drivers/pci/search.c
>> +++ b/drivers/pci/search.c
>> @@ -280,6 +280,8 @@ static struct pci_dev *pci_get_dev_by_id(const struct
>pci_device_id *id,
>>  			      match_pci_dev_by_id);
>>  	if (dev)
>>  		pdev = to_pci_dev(dev);
>> +	if (from)
>> +		pci_dev_put(from);
>>  	return pdev;
>>  }
>>
>>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
