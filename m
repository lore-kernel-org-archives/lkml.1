Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZBBRHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZBBRHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZBBRHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:07:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbZBBRHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:07:22 -0500
Date: Mon, 2 Feb 2009 09:06:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Schwab <schwab@suse.de>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <1233568479.18767.86.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <1233568479.18767.86.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> I don't know how x86 does but I'm sure there must be some kind ACPI
> thingy that must be called too before you can touch a device, in case it
> got powered off by more than just the standard D states (ie, clock
> stopped on the bus or whole power plane switched off).

It gets called later in that case.

> I'll try to reproduce and think about it more, but it looks to me that
> this patch might not be quite the right approach yet.

I think you'll need to move the clock gating thing to be a sysdev 
suspend/resume event, which gets done really early along with things like 
core timekeeping etc. We kind of hit that already with the USB driver, 
where CONFIG_PPC does all kinds of wrong things:

	#ifdef CONFIG_PPC_PMAC
	        if (retval == 0) {
	                /* Disable ASIC clocks for USB */
	                if (machine_is(powermac)) {
	                        struct device_node      *of_node;

	                        of_node = pci_device_to_OF_node(dev);
	                        if (of_node)
	                                pmac_call_feature(PMAC_FTR_USB_ENABLE,
	                                                        of_node, 0, 0);
	                }
	        }
	#endif

inside the hcd-pci.c driver. If that whole thing was a sysdev feature, you 
wouldn't need that kind of insane "do my own arch-specific thing in a 
generic driver" thing. AND waking it up would work too.

I'm assuming this is exactly the kind of thing that is now biting you?

		Linus
