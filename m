Return-Path: <linux-kernel-owner+w=401wt.eu-S1762988AbYJJUL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762988AbYJJUL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761366AbYJJULU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:11:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761087AbYJJULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:11:19 -0400
Date: Fri, 10 Oct 2008 13:10:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] fastboot tree for v2.6.28
In-Reply-To: <20081010003241.GA23940@elte.hu>
Message-ID: <alpine.LFD.2.00.0810101254240.3503@nehalem.linux-foundation.org>
References: <20081010003241.GA23940@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Ingo Molnar wrote:
>
> Please pull the latest fastboot-v28-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git fastboot-v28-for-linus
> 
> the (opt-in) fastboot async bootup feature, as described by Arjan in his 
> v2.6.28 announcement:
> 
>    http://lwn.net/Articles/299591/
> 
> tested and maintained in -tip because tip/tracing embedd-merges this 
> topic. (for the fastboot tracer)

Ok, so I finally looked at the patch, I quite frankly, I think it's 
fundamentally wrong.

This is just an example of the wrongness:

	-module_init(uhci_hcd_init);
	+module_init_async(uhci_hcd_init);
	-module_init(ehci_hcd_init);
	+module_init_async(ehci_hcd_init);
	-module_init(ohci_hcd_mod_init);
	+module_init_async(ohci_hcd_mod_init);

	-device_initcall(pci_init);
	+device_initcall_sync(pci_init);

because there is absolutely _no_ excuse for doing the PCI part of the 
probing asynchronously.

The "ohci_hcd_mod_init" part is _especially_ dangerous, because clearly 
nobody looked at the OHCI setup sequence, which includes a lot of odd 
devices and not all of them at all PCI-related etc. Making it asynchronous 
is not safe, nor is it appropriate.

The fact is, those things all have one thing in common:

 - they call usb_add_hcd, and usb_add_hcd is a horrible and slow piece of 
   crap that doesn't just add the host controller, but does all the 
   probing too.

In other words, what should be fixed is not the initcall sequence, and 
certainly not make PCI device probing (or other random buses) be partly 
asynchronous, but simply make that USB host controller startup function be 
asynchronous.

There are other devices too that may need synchronous core hub discovery 
(eg the actual controller), but that want to do the "devices hanging off 
this controller" asynchronously. Disks come to mind. That shouldn't mean 
that the IDE driver discovery should be asynchronous, it should just mean 
that the driver has some simple way to execute something asynchronously.

In other words, I really think it's very wrong to make that 
"async_init_wq" be somethign that is internal to do_initcalls. It should 
be a workqueue that the initcalls can _choose_ to use at the appropriate 
level (which may be deeper down, like 'usb_add_hcd()'), not be forced to 
use at the outermost one.

You can try to convince me otherwise, but I really do think this patch is 
fundamentally the wrong approach.

			Linus
