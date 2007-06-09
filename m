Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbXFITtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbXFITtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbXFITs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:48:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:56853 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427AbXFITs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:48:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,403,1175497200"; 
   d="scan'208";a="255117763"
Message-ID: <466B041F.3030002@intel.com>
Date: Sat, 09 Jun 2007 12:48:47 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de
Subject: Re: [PATCH 1/2] [RFC] PCI: read revision ID by default
References: <20070608224630.31777.17807.stgit@localhost.localdomain> <20070609065953.GA1747@colo.lackof.org>
In-Reply-To: <20070609065953.GA1747@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Fri, Jun 08, 2007 at 03:46:30PM -0700, Auke Kok wrote:
>> Currently there are 97 occurrences where drivers need the pci
>> revision ID. We can do this once for all devices. Even the pci
>> subsystem needs the revision several times for quirks. The extra
>> u8 member pads out nicely in the pci_dev struct.
> 
> Good idea. I always wondered why we read the invariants so often
> in the code.
> 
>> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
>> ---
>>
>>  drivers/pci/probe.c |    3 +++
>>  include/linux/pci.h |    1 +
>>  2 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index e48fcf0..0fdb71d 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -918,6 +918,9 @@ pci_scan_device(struct pci_bus *bus, int devfn)
>>  	dev->cfg_size = pci_cfg_space_size(dev);
>>  	dev->error_state = pci_channel_io_normal;
>>  
>> +	/* read the PCI revision: 1 byte */
>> +	pci_read_config_byte(dev, PCI_REVISION_ID, &dev->revision);
> 
> probe.c:pci_setup_device() is also reading this byte but discards it:
> 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
> 	class >>= 8;                                /* upper 3 bytes */
> 	dev->class = class;
> 
> Can you use "class & 0xff"? Or is pci_setup_device() too late?
> Or can you read the whole 32-bits in pci_scan_device() and remove
> the pci_read_config() in pci_setup_device()?

no, pci_setup_device() is just called right after the location where I read the 
REVISION_ID. I'll remove the read and put the dev->revision right after where we 
read the class dword.

Auke
