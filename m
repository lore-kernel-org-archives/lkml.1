Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbYFJOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbYFJOjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYFJOjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:39:06 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:7419 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbYFJOjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:39:05 -0400
Date: Tue, 10 Jun 2008 08:40:39 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Can Linux control PCIe Transaction Layer Packet creation,
 when writing to a region pointed to by Base Address Register
In-reply-to: <fa.ad+IRCXve3eoRX6uYMTipc37Wuw@ifi.uio.no>
To: "Meyers, Jordan" <Jordan_Meyers@cable.comcast.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <484E9267.8090701@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ad+IRCXve3eoRX6uYMTipc37Wuw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meyers, Jordan wrote:
>      During the process of writing a PCIe device driver, I observed an interesting phenomenon with respect to Transaction Layer Packet (TLP) generation.  The device driver needs to transfer upwards of 1/3 KB in the payload of a single TLP.  I used the pci_iomap function combined with memcpy_toio for data transfer to the address space pointed to by a Base Address Register (BAR).  When I used the memcpy_toio, the buffer content I tried to write was split into dword (4B) sized pieces and each dword was given its own TLP.  According to PCI-SIG and some of the research I've done, the PCIe Bus Controller is responsible for this behavior.  The PCIe Bus Controller turns the driver accesses into TLPs.  This presents an interesting problem.  Since the generation of these TLPs (from the BAR region) are out of the hands of the Operating System, what procedure can a driver go through to ensure that all the data makes it into a single TLP payload.  One thought I had was the use of DMA b
uffers, an
> d having the PCIe card pull the data from the DMA buffer.  I observed the DMA pushes from the card to the buffer, were not subject to the same limiting factors.  
>      All the observations I made were done by using a Lecroy PCIe analyzer.  The machine I ran this on was a Dell Precision 490 (which had 2 AMD quad core, x86_64 architecture).  I've tested the behavior on SUSE Linux running kernel 2.6.16 and 2.6.22.  And the chipset was Intel 5000x ( the relevant PCIe component of the chipset is the 6321 ESB I/O Hub Controller).
> 
>      Any thoughts or suggestions of how to ensure a buffer's data is transferred from the driver to the PCIe card in a single TLP (where the intended payload size is less than the max payload value in Device Control register of the PCI register space)?  Thank you to everyone who has taken the time to read this post. 

In general you have no control over what the chipset decides to do with 
CPU writes over the PCI or PCI Express bus. In newer kernels you might 
be able to use iomap_wc, etc. to map the device BAR as write combining 
(if your device can handle the effects of this) which would likely at 
least result in sending more than one dword per TLP. However, in 
general, if you want full efficiency in bus utilization, you typically 
have to make the device perform the reads from memory rather than 
pushing data from the CPU.
