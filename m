Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0CCCcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 21:32:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54750 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0CCCcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 21:32:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B8DC9DB.5090307@jp.fujitsu.com>
Date: Wed, 03 Mar 2010 11:30:51 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.8) Gecko/20100216 Thunderbird/3.0.2
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] ACPI, APEI, PCIE AER, use general HEST table parsing
 in AER firmware_first setup
References: <1267494902-7193-1-git-send-email-ying.huang@intel.com>	 <1267494902-7193-2-git-send-email-ying.huang@intel.com>	 <4B8CC7BD.5020206@jp.fujitsu.com>	 <1267521207.1640.130.camel@yhuang-dev.sh.intel.com>	 <4B8CF0D0.2000704@jp.fujitsu.com> <1267580629.1640.142.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1267580629.1640.142.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/03/03 10:43), Huang Ying wrote:
>> For example, assume that there are 2 endpoints under a same
>> root port.  One is (likely on-board) "firmware first" endpoint,
>> with driver which does not call pci_enable_pcie_error_reporting()
>> (because of no interest in AER, or just not implemented yet,
>> anyway).  The other is (likely card seated on a slot) not
>> firmware first, with better driver which can handle it's AER.
>> If my understanding is correct and if everything goes well,
>> errors on one should be reported via APEI while the other should
>> be reported via AER driver.
> 
> Yes. I think this should be supported. How about something as follow?
> 
> struct pci_dev {
> 	...
> 	unsigned int __firmware_first:2;
> 	...
> };
> 
> int pcie_aer_get_firmware_first(struct pci_dev *dev)
> {
> 	if (!dev->__firmware_first)
> 		aer_set_firmware_first(dev);
> 	return dev->__firmware_first & 0x1;
> }
> 
> Then we use pcie_aer_get_firmware_first() instead of dev->firmware_first
> directly.

Looks reasonable.  I think the following is more straightforward:

struct pci_dev {
	...
	unsigned int __firmware_first_valid:1;
	unsigned int __firmware_first:1;
	...
};

int pcie_aer_get_firmware_first(struct pci_dev *dev)
{
	if (!dev->__firmware_first_valid)
		aer_set_firmware_first(dev);
	return dev->__firmware_first;
}


Thanks,
H.Seto

