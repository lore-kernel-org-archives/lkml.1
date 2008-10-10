Return-Path: <linux-kernel-owner+w=401wt.eu-S1763005AbYJJV3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005AbYJJV3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759905AbYJJV3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:29:10 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:8748 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759655AbYJJV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:29:08 -0400
Date: Fri, 10 Oct 2008 15:29:05 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v5 04/16] PCI: prevent duplicate slot names
Message-ID: <20081010212905.GH3286@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20081009043140.8678.44164.stgit@bob.kio> <20081009044649.8678.30990.stgit@bob.kio> <48ED9716.3040301@jp.fujitsu.com> <20081009055654.GA30972@ldl.fc.hp.com> <48EDF9F5.9020802@jp.fujitsu.com> <20081010021034.GA13292@ldl.fc.hp.com> <48EEDD7E.5090002@jp.fujitsu.com> <20081010052757.GA26341@ldl.fc.hp.com> <48EF0E21.5000500@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EF0E21.5000500@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
>> Ugh, I'm not sure which is worse, an unbalanced API vs passing a
>> hotplug_slot to pci_destroy_slot.
>>
>> pci_destroy_slot should never touch the pci_slot->hotplug
>> argument, I think, because it is possible for non-hotplug callers
>> to call pci_create_slot.
>>
>> I think the rule should just be:
>>
>> 	- all hotplug drivers must use pci_hp_register/deregister
>> 	- hotplug drivers must pass a valid hotplug_slot argument
>>
>> 	- all detection drivers must use pci_create/destroy_slot
>> 	- detection drivers must pass NULL for hotplug_slot
>>
>
> I'm still concerned about one thing. Now that we added hotplug
> arg to pci_create_slot(), pci_bus_sem could be used for changing
> pci_slot->hotplug. But if there is no generic API to clean up
> pci_slot->hotplug, we can't use pci_bus_sem because pci hotplug
> core cannot hold pci_bus_sem. As a result, we need to add the
> following rule in addition to the above rules.
>
> 	- hotplug core driver must hold some mutex/semaphore when
> 	  calling pci_create_slot()
> 	- hotplug core driver must hold the same mutex/semaphore
> 	  when cleaning up pci_slot->hotplug.
>
> That is, even though pci_create_slot provides the interface to
> setup pci_slot->hotplug, caller needs to pay attention to race
> condition about pci_slot->hotplug. I think it's a little strange.

I think we can use your earlier patch that replaced the hotplug
list spinlock with a pci_hp_mutex, and that should implement the
two new rules you mention, right?

Let me try and insert your patch into the rest of my series and
see how it looks.

/ac

