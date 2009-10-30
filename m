Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZJ3DYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZJ3DYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 23:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZJ3DYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 23:24:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49445 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZJ3DYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 23:24:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AEA5C52.2030900@jp.fujitsu.com>
Date: Fri, 30 Oct 2009 12:24:02 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Huong_Nguyen@dell.com
Subject: Re: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
References: <20091006173311.GA15751@auslistsprd01.us.dell.com> <4ACEE220.1020705@jp.fujitsu.com> <20091009182810.GB24889@mock.linuxdev.us.dell.com> <20091009183319.GC24889@mock.linuxdev.us.dell.com> <4AEA4C82.6010604@jp.fujitsu.com> <20091030025313.GA1042@mock.linuxdev.us.dell.com>
In-Reply-To: <20091030025313.GA1042@mock.linuxdev.us.dell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:
>> Matt Domsch wrote:
>>> +		/* These three should never appear */
>>> +		case ACPI_HEST_TYPE_NOT_USED3:
>>> +		case ACPI_HEST_TYPE_NOT_USED4:
>>> +		case ACPI_HEST_TYPE_NOT_USED5:
>>> +			break;
>> Yes, these should never.  But if there, what will happen?
>> I'd like to see a error message rather than hang in infinite loops.
>>
>>> +		/* These should never appear either */
>>> +		case ACPI_HEST_TYPE_RESERVED:
>>> +		default:
>>> +			break;
>> Ditto.
> 
> It won't infinite loop, due to i incrementing.  If one of these types
> appears early in the error_source list, it would prevent us from
> seeing the (correct) source types later in the list.

Ah, you are right.  Thanks for correcting me.

> But we can't advance the pointer because we can't know by how much to
> advance it.  We could print a debug message.  How about:
> 
> printk(KERN_DEBUG PREFIX
>        "HEST Error Source list contains an obsolete type.\n");

Good.
And it would be informative to print the type number.
 ... "HEST Error Source list contains an obsolete type (%d).\n", hdr->type);

> At some point, the RESERVED type will move to higher number as new
> sources are defined in the spec, so that would be different message.
> How about:
> 
> printk(KERN_DEBUG PREFIX
>        "HEST Error Source list contains a reserved type.\n");

Of course good.
And print the type number too, please.

> and I'll have it print only once.

Nice!

>> One another concern I got here is if there was a seg_n, segment
>> number, how we can handle it... but it will be one of future works,
>> so this would be OK at this time.
> 
> Yes, but this ACPI table doesn't have a domain / segment number in
> it.  Does this test:
> 
>         if (p->flags & ACPI_HEST_FIRMWARE_FIRST &&
>             (p->flags & ACPI_HEST_GLOBAL ||
>              (p->bus      == pci->bus->number &&
>               p->device   == PCI_SLOT(pci->devfn) &&
>               p->function == PCI_FUNC(pci->devfn))))
>                 *firmware_first = 1;
> 
> need to add an explicit test for && 0 == pci_domain_nr(pci->bus) ?

Maybe it would be better to have, to find problem early if it happens.

>>> @@ -35,6 +36,9 @@ int pci_enable_pcie_error_reporting(struct pci_dev *dev)
>>>  	u16 reg16 = 0;
>>>  	int pos;
>>>  
>>> +	if (dev->aer_firmware_first)
>>> +		return -EIO;
>>> +
>> The aer_init() will be called for root ports (via aer_probe() of
>> aer service driver), but not for end point devices or so on.
>> So you need to call aer_init() for end points from here or somewhere
>> else, to set aer_firmware_first correctly.
> 
> Good catch.  I'll move the setting of dev->aer_firmware_first into the
> PCI device discovery path.  By that point, ACPI is configured and
> available.

Please be careful that there could be hot-plugged devices later.

>>> +	if (acpi_hest_firmware_first_pci(dev->port)) {
>>> +		dev_printk(KERN_DEBUG, &dev->device,
>>> +			   "PCIe device errors handled by platform firmware.\n");
>>> +		dev->port->aer_firmware_first=1;
>> Coding style requests you to add spaces before and after of "=".
> 
> OK.  This and the next will move as noted above.

Thanks,
H.Seto

