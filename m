Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXL0Vrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXL0Vrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 16:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXL0Vrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 16:47:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbXL0Vrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 16:47:45 -0500
Date: Thu, 27 Dec 2007 13:46:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Loic Prylli <loic@myri.com>
cc: Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca> <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org> <477414C9.3040906@myri.com>
 <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Dec 2007, Linus Torvalds wrote:
> 
> Kai, can you try that? Just remove the call to pci_enable_crs() in 
> pci_scan_bridge() in drivers/pci/probe.c, and see if mmconfig starts 
> working for you?

We could also make the error handling more permissive, and just check for 
the low 16 bits, which is the part that the CRS spec mentions the actual 
value for. The whole vendor ID of 0x0001 is mentioned int he CRS spec as 
being explicitly chosen exactly because it's invalid.

That said, given that we don't actually reap any benefits from CRS support 
right now *anyway*, I think the right thing to do is disable it by 
default. But it would be interesting to know if this patch makes it work 
on those ATI bridges..

		Linus

---
 drivers/pci/probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2f75d69..94cd3a4 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -908,7 +908,7 @@ pci_scan_device(struct pci_bus *bus, int devfn)
 		return NULL;
 
 	/* Configuration request Retry Status */
-	while (l == 0xffff0001) {
+	while ((l & 0xffff) == 0x0001) {
 		msleep(delay);
 		delay *= 2;
 		if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &l))
