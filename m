Return-Path: <linux-kernel-owner+w=401wt.eu-S1764174AbXEWAb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764174AbXEWAb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbXEWAbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:31:51 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:23842 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbXEWAbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:31:50 -0400
Date: Tue, 22 May 2007 18:31:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-reply-to: <200705211322.18937.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Message-id: <46538B67.3080007@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4635510D.4060103@shaw.ca> <4651F26C.7010405@shaw.ca>
 <200705211307.14868.jbarnes@virtuousgeek.org>
 <200705211322.18937.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, May 21, 2007, Jesse Barnes wrote:
>> Yeah, I've got that data... just a sec while I make sure it's
>> reproducable...
>>
>> Aha, I hadn't decoded the devfn before, looks like it's dying on an
>> access to the graphics device (bus 0, slot 2, device 0):
>>
>> ...
>> pci_mmcfg_read: 0, 0, 0x10, 0x18, 4 = 0xc000000c
>> pci_mmcfg_read: 0, 0, 0x10, 0x18, 4 = <hang>
>> ...
>>
>> Offset 0x18 into the graphics config space should be the graphics memory
>> range address, and 0xc000000c is the correct value.  But for some reason
>> it hangs on the second access.
>>
>> It hangs here everytime.
> 
> That register is in the config space BAR region, so it should be ok to 
> write 0xffffffff to it and read it back to size the register.  However, 
> it's after writing the 0xffffffff to it and trying to read it back that 
> the machine hangs.  I didn't see any accesses to the command register to 
> disable decoding (at least not via the mmconfig methods), so maybe that's 
> broken during MCFG based probing?

Eww. I don't see where we disable the decode at all while we probe the 
BARs on the device. That seems like a bad thing, especially with the way 
we probe 64-bit BARs (do the low 32 bits first and then the high 32 
bits). This means the base address effectively gets set to 0xfffffff0 
momentarily, which might cause some issues.

I'd try adding some code inside pci_setup_device (drivers/pci/probe.c) 
to disable PCI_COMMAND_IO and PCI_COMMAND_MEMORY on the device when 
probing devices with the standard header type and then restoring the 
previous command bits afterwards, and see what effect that has. It'll be 
  interesting if it does, since obviously it seems to work as it is with 
non-MMCONFIG access methods. Maybe the base address being set like that 
interferes with MMCONFIG access itself somehow?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
