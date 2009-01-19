Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZASBwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZASBwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 20:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZASBwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 20:52:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51711 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbZASBwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 20:52:21 -0500
Message-ID: <4973DCC1.3070009@jp.fujitsu.com>
Date: Mon, 19 Jan 2009 10:52:01 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
References: <200901042346.42723.rjw@sisk.pl> <4970385B.7030404@jp.fujitsu.com> <200901161029.58647.rjw@sisk.pl> <200901170120.38238.rjw@sisk.pl>
In-Reply-To: <200901170120.38238.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday 16 January 2009, Rafael J. Wysocki wrote:
>> On Friday 16 January 2009, Hidetoshi Seto wrote:
>>> Rafael J. Wysocki wrote:
>>>> On Thursday 15 January 2009, Rafael J. Wysocki wrote:
>>>>> On Thursday 15 January 2009, Rafael J. Wysocki wrote:
(snip)
>>>>>> In any case, I think we should
>>>>>> (a) get the number of the port's MSI-X table entries _first_, without enabling
>>>>>>     MSI-X,
>>> We cannot do this because both of PCIE_CAPABILITIES_REG and PCI_ERR_ROOT_STATUS
>>> will indicate the number for MSI, not for MSI-X without enabling MSI-X.
>> Yes, we can.  We don't read PCIE_CAPABILITIES_REG and PCI_ERR_ROOT_STATUS at
>> this point yet and the number of entries in the MSI-X table is constant
>> (read-only), so we can read it even before enabling MSI-X.  Actually, our MSI-X
>> code does that already anyway.

Now I caught you've mean "get the size of MSI-X table."

>>>>>> (b) allocate as many MSI-X vectors as indicated by this number, even though
>>>>>>     some of them may not be used,
>> (b) should be: call pci_enable_msix() with the last argument equal to the
>> number of entries in the MSI-X table or 32, whichever is smaller.

Good.

>>>>>> (c) use PCIE_CAPABILITIES_REG and PCI_ERR_ROOT_STATUS to check
>>>>>>     which vector has been allocated to which service.
>>>>> (d) mask the unused vectors.
>>>> However, it's probably simpler to do something like in your patch, although
>>>> I don't like the dummy enabling of MSI-X at all.
>>> How about this?
>>>
>>>   #define PCIE_MSIX_ENTRY_HPPME MAGIC_NUMBER_1
>>>   #define PCIE_MSIX_ENTRY_AER   MAGIC_NUMBER_2
>>>
>>>   struct msix_entry msix_entries[] =
>>>                         {{0, PCIE_MSIX_ENTRY_HPPME}, {0, PCIE_MSIX_ENTRY_AER}};
>>>   status = pci_enable_msix(dev, msix_entries, nvec);
>>>
>>> And modify pci_enable_msix() to handle these magic numbers.

I found a down side of my idea:
 it requires modification of arch_setup_msi_irqs etc. too.

>> Quite frankly, I prefer the procedure described above in (a) - (d).  I'll try
>> to implement it and we'll see how it looks like.
> 
> I've just sent the patch in the other thread.

OK. I'll review it.

Thanks,
H.Seto

