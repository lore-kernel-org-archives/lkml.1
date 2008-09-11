Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYIKKil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYIKKil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYIKKic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:38:32 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43194 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYIKKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:38:31 -0400
Date: Thu, 11 Sep 2008 04:37:46 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v2 02/13] PCI: prevent duplicate slot names
Message-ID: <20080911103746.GB8795@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100012.29542.62582.stgit@bob.kio> <48C886B0.8030605@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C886B0.8030605@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
>> @@ -570,9 +571,17 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>>  		return -EINVAL;
>>  	}
>>  -	/* Check if we have already registered a slot with the same name. */
>> -	if (get_slot_from_name(name))
>> -		return -EEXIST;
>> +	/*
>> +	 * If we find a tmp_slot here, it means that another slot
>> +	 * driver has already created a pci_slot for this device.
>> +	 * We care (below) if the existing slot has a different name from
>> +	 * the new name that this particular hotplug driver is requesting.
>> +	 */
>> +	dev = pci_get_slot(bus, PCI_DEVFN(slot_nr, 0));
>> +	if (dev && dev->slot) {
>> +		tmp_slot = dev->slot;
>> +		pci_dev_put(dev);
>> +	}
>>
>
> I have two comments here.
>
> (1) I think the reference counter of the device will be leaked if
> (dev == NULL) && (dev->slot != NULL). We need pci_dev_put() whenever
> dev is not NULL.

You're right, thank you.

[one day, I _will_ learn how to get refcounting correct. :-/]

> (2) When the slot is empty, the 'dev' will be always NULL. Therefore,
> 'tmp_slot' will be always NULL on the empty slot here. Because of
> this, the following code to rename the slot will not work on the
> empty slot, I think.

Ok, I was trying to avoid creating a new interface called
"pci_find_phys_slot()" or something similar, but I think we need
it, and it will fix this issue.

Thanks again for the review.

/ac

