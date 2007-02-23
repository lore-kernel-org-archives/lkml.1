Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXBWOiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXBWOiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbXBWOiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:38:12 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:9354 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbXBWOiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:38:11 -0500
Date: Fri, 23 Feb 2007 08:38:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ACPI driver support for pata
In-reply-to: <20070223125027.3f0a7f14@lxorguk.ukuu.org.uk>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@osdl.org, linux-kernel@vger.kernel.org
Message-id: <45DEFC48.8060802@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no>
 <45DD2E12.6000705@shaw.ca> <45DD3F20.7050907@pobox.com>
 <20070222142439.50cff3e9@lxorguk.ukuu.org.uk> <45DDCEC4.7050208@garzik.org>
 <20070222182939.56d43a68@lxorguk.ukuu.org.uk> <45DE3207.6020707@shaw.ca>
 <20070223125027.3f0a7f14@lxorguk.ukuu.org.uk>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> The link order is set up so that we try things in a very specific
> deliberate order
> 
> - Hardware specific driver (unless it deliberately punts to ACPI)
> - ACPI driver using _GTM/_STM etc
> - Generic PCI driver ("stay in the mode the BIOS set and pray")
> - ISA register compatibility mode (PIO)
> 
> This is essentially the strategy used by the old IDE layer since way back
> when (minus ACPI support) and has served us pretty well.

Unfortunately, link order appears to have no effect when the drivers in 
question are built modular, as appears to be the typical case, unlike 
old IDE where they were generally built in because of all the other 
busted behavior if you built the drivers as modules. This means that 
userspace tools like mkinitrd, udev, etc. will need to be taught to try 
to load drivers in this order, and not to try to use pata_acpi on an 
Nvidia SATA controller, for example, as the Fedora mkinitrd seems to do. 
This is more complicated than just that if you have multiple 
controllers, you have to be even more careful with the load ordering to 
ensure this ordering applies system-wide, since the pata_acpi or generic 
drivers will attach to anything, while trying to load a driver for the 
first controller, you may end up with the second controller getting 
those drivers attached to them when they had a controller-specific 
driver available that should have been used instead.

Plus there's controller hotplug - if multiple loaded drivers are listed 
as being able to drive a piece of hardware, does anything define which 
driver will get first dibs on attaching to the device when it's 
hotplugged? I don't know how this ordering will be enforced in that case.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


