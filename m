Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZCTDx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZCTDx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZCTDxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:53:18 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:38005 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZCTDxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:53:17 -0400
Date: Thu, 19 Mar 2009 21:53:14 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH v4 08/12] PCI: Introduce /sys/bus/pci/devices/.../remove
Message-ID: <20090320035314.GA26595@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318224006.887.91805.stgit@bob.kio> <49C2540E.70207@jp.fujitsu.com> <20090319164119.GC8074@ldl.fc.hp.com> <49C2D31C.3030605@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2D31C.3030605@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
>> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>>> Alex Chiang wrote:
>>>> +
>>>> +static void remove_callback(struct device *dev)
>>>> +{
>>>> +	int bridge = 0;
>>>> +	struct pci_dev *pdev = to_pci_dev(dev);
>>>> +
>>>> +	mutex_lock(&pci_remove_rescan_mutex);
>>>> +
>>>> +	if (pdev->subordinate)
>>>> +		bridge = 1;
>>>> +
>>>> +	pci_remove_bus_device(pdev);
>>>> +	if (bridge && list_empty(&pdev->bus->devices))
>>>> +		pci_remove_bus(pdev->bus);
>>> I cannot understand the above two lines. Could you explain
>>> what it intend?
>>
>> If the user says:
>>
>> 	echo 1 > /sys/bus/pci/devices/.../remove
>>
>> And that device is a bridge, then we need to specifically call
>> pci_remove_bus as well, to actually remove the bus itself.
>> Without it, pci_bus_remove_device() will remove all of its
>> children (and subordinate buses) in a depth-first manner, but we
>> will never actually remove the bus that the user specified.
>>
>
> Do you mean user removes bridge device to remove its *primary*
> bus? It is very strange. I think the bus should be removed
> when its parent bridge is removed.

You are correct.

>> In other words, without it, we will still see the bus in:
>>
>> 	/sys/class/pci_bus/...
>>
>
> What is the problem?
>
>> We only want to remove the bus if it has no children left. I
>> think the check for list_empty(&pdev->bus->devices) might be
>> overkill... I can try taking that bit out and testing again.
>>
>
> I think we don't need the two lines. But if you do that, you
> need list_empty(&pdev->bus->devices), doesn't it? On the other
> hand, we must not check 'bridge' in the if statement. Or bus
> will never be removed when non-bridge device is removed last
> on the bus.
>
> Again, I think we don't need the two lines. But am I
> misunderstanding something?

No, you are correct.

I think what was happening was that I inserted that code before I
discovered the double-free in the PCIe port driver, and that
extra call to pci_remove_bus() helped mask the double-free.

I re-tested again tonight with the port driver fix, and also
removing the two lines you mention, and it is behaving correctly.

As always, thanks for your review.

/ac

