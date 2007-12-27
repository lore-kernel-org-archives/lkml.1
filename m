Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbXL0WSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbXL0WSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 17:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXL0WSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 17:18:34 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.189]:38040 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbXL0WSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 17:18:33 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: iaL9KxG65sFyH/NRHEm13ZpWIsASIz2sPdozvvFFdQCNetlf
Message-ID: <47742498.1060900@tragetaschen.dyndns.org>
Date: Thu, 27 Dec 2007 23:18:00 +0100
From: Kai Ruhnau <kai@tragetaschen.dyndns.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071122)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Loic Prylli <loic@myri.com>, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca> <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org> <477414C9.3040906@myri.com> <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 27 Dec 2007, Linus Torvalds wrote:
>   
>> Kai, can you try that? Just remove the call to pci_enable_crs() in 
>> pci_scan_bridge() in drivers/pci/probe.c, and see if mmconfig starts 
>> working for you?
>>     
>
> We could also make the error handling more permissive, and just check for 
> the low 16 bits, which is the part that the CRS spec mentions the actual 
> value for. The whole vendor ID of 0x0001 is mentioned int he CRS spec as 
> being explicitly chosen exactly because it's invalid.
>
> That said, given that we don't actually reap any benefits from CRS support 
> right now *anyway*, I think the right thing to do is disable it by 
> default. But it would be interesting to know if this patch makes it work 
> on those ATI bridges..
>
> 		Linus
>
> ---
>  drivers/pci/probe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 2f75d69..94cd3a4 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -908,7 +908,7 @@ pci_scan_device(struct pci_bus *bus, int devfn)
>  		return NULL;
>  
>  	/* Configuration request Retry Status */
> -	while (l == 0xffff0001) {
> +	while ((l & 0xffff) == 0x0001) {
>  		msleep(delay);
>  		delay *= 2;
>  		if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &l)

That one did not work out so well.
I reenabled the call to pci_enable_crs() and changed the line as above.
That resulted in two timeouts (from dmesg):

[....]
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOACPI for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
Device 0000:01:00.0 not responding
Device 0000:02:00.0 not responding
[....]

Then, the kernel boots up normally except of graphics and network card
not showing up at all in lspci.

Kai

-- 
This signature is left as an exercise for the reader.

