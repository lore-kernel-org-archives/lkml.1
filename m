Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbXLTMZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbXLTMZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbXLTMZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:25:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbXLTMZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:25:15 -0500
Message-ID: <476A5F27.4040209@redhat.com>
Date: Thu, 20 Dec 2007 07:25:11 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [Fwd: Re: [PATCH 2/5]PCI: x86 MMCONFIG: add legacy pci conf functions]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-------- Original Message --------
Subject: Re: [PATCH 2/5]PCI: x86 MMCONFIG: add legacy pci conf functions
Date: Wed, 19 Dec 2007 19:07:27 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
To: Greg KH <gregkh@suse.de>
References: 
<20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com> 
<20071219221756.20362.84805.sendpatchset@dhcp83-188.boston.redhat.com> 
<20071219230615.GB24219@suse.de>

Greg KH wrote:

>> +struct pci_ops pci_legacy_ops = {
>> +	.read =		pci_ops_legacy_read,
>> +	.write =	pci_ops_legacy_write,
>> +};
> 
> This whole structure is never used in this patch, why add it now?

It gets used by the routine pcibios_fix_bus_scan_quirk in
arch/x86/pci/common.c

> 
>>  /*
>>   * Before we decide to use direct hardware access mechanisms, we try to do some
>> @@ -258,18 +284,28 @@ void __init pci_direct_init(int type)
>>  {
>>  	if (type == 0)
>>  		return;
>> -	printk(KERN_INFO "PCI: Using configuration type %d\n", type);
>> -	if (type == 1)
>> +	if (type == 1) {
>>  		raw_pci_ops = &pci_direct_conf1;
>> -	else
>> +		pci_legacy_conf = &pci_direct_conf1;
>> +	} else {
>>  		raw_pci_ops = &pci_direct_conf2;
>> +		pci_legacy_conf = &pci_direct_conf2;
> 
> Why have two pointers to the same thing?  What is pci_legacy_conf going
> to be used for?  Why not just use raw_pci_ops?
> 
> thanks,
> 
> greg k-h

The way the code works today, when raw_pci_ops is set to use mmconf,
it is platform-wide. Legacy pci config reads are not available.

I would have simply used the pci_direct_conf1, but because there can
also be a pci_direct_conf2, I thought it best to abstract it as
pci_legacy_conf.

A pointer to struct pci_ops pci_legacy_ops data is written into the
pci_bus.ops field for buses that must use legacy pci config access.

The other busses can continue to use the pointer to the mmconf pci_ops.



