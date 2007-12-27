Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXL0VjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXL0VjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 16:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXL0Vi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 16:38:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbXL0Vi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 16:38:59 -0500
Date: Thu, 27 Dec 2007 13:37:41 -0800 (PST)
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
In-Reply-To: <477414C9.3040906@myri.com>
Message-ID: <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca> <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
 <477414C9.3040906@myri.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Dec 2007, Loic Prylli wrote:
> 
> The root pcie port implementation is obviously buggy. But did we confirm
> whether that hardware bug might be partly related to
> "configuration-retry-status" pcie-root handling as introduced/described in:

Ahh, yes, that sounds like an excellent explanation of what might be going 
on.

Our code expects that the retry status is read as a 32-bit word that is 
0xffff0001, but you're right, that "0001" in the low-order bits is an 
interesting coincidence, and it may be that what the ATI pcie bridge 
does the high bits wrong.

The CRS docs *do* say that it has to return 0001h for the Vendor ID, but 
also that any additional bytes (ie the device ID) should be all ones. So 
we're doing the right thing from a spec standpoint, but as I often say: 
the spec doesn't count for anything, compared to reality.

> Does the 0001 vendor-id still shows up if pci_enable_crs() has never
> been called?

I don't believe we have ever tried, but it would be very interesting to 
hear. 

Kai, can you try that? Just remove the call to pci_enable_crs() in 
pci_scan_bridge() in drivers/pci/probe.c, and see if mmconfig starts 
working for you?

> Does anybody knows what was the original rational to call
> pci_enable_crs() by default?

.. another good question. I don't think anybody expected it to be broken, 
but if this turns out to be the thing that triggers it, I think we should 
disable CRS by default.

The code doesn't actually do what CRS is supposed to help with (ie go on 
to probe another device and then come back to the slow one later), so 
right now it's pretty much useless *anyway*. 

Matthew?

			Linus
