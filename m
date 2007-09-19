Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbXISLAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbXISLAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbXISLAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:00:36 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:12394 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753012AbXISLAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:00:36 -0400
Message-ID: <46F10113.1040205@ru.mvista.com>
Date: Wed, 19 Sep 2007 14:59:31 +0400
From: Valentine Barshak <vbarshak@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix e100 interrupt quirk
References: <20070919104342.GB3226@ff.dom.local>
In-Reply-To: <20070919104342.GB3226@ff.dom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On 18-09-2007 13:17, Valentine Barshak wrote:
>> PCI memory space may have a 64-bit offset on some architectures
>> (for example, PowerPC 440) and the actual PCI memory address
>> has to fixed up (an offset to PCI mem space shuld be added)
>> before remapping. So, pci_iomap should be used instead of
>> reading and remapping PCI BAR directly. This has been tested
>> on Sequoia PowerPC 440EPx board.
>>
>> Signed-off-by: Valentine Barshak <vbarshak@ru.mvista.com>
>> ---
>>
>> --- linux-2.6.orig/drivers/pci/quirks.c	2007-09-04 21:15:43.000000000 +0400
>> +++ linux-2.6.bld/drivers/pci/quirks.c	2007-09-05 20:46:14.000000000 +0400
>> @@ -1444,9 +1444,9 @@
>>  static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
>>  {
>>  	u16 command;
>> -	u32 bar;
>>  	u8 __iomem *csr;
>>  	u8 cmd_hi;
>> +	int rc;
>>  
>>  	switch (dev->device) {
>>  	/* PCI IDs taken from drivers/net/e100.c */
>> @@ -1476,16 +1476,17 @@
>>  	 * re-enable them when it's ready.
>>  	 */
>>  	pci_read_config_word(dev, PCI_COMMAND, &command);
>> -	pci_read_config_dword(dev, PCI_BASE_ADDRESS_0, &bar);
>>  
>> -	if (!(command & PCI_COMMAND_MEMORY) || !bar)
>> +	rc = pci_request_region(dev, 0, "e100_quirk");
>> +
>> +	if (!(command & PCI_COMMAND_MEMORY) || (rc < 0))
>>  		return;
> 
> I didn't look at this too much, but isn't something like:
> 		if (rc >=  0)
> 			goto e100_quirk_exit;
> needed before this return?

I'll split these 2 checks and submit new patch in a minute.
Thanks.

> 
> Regards,
> Jarek P.

