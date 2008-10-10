Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYJJWua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYJJWua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYJJWuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:50:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:54204 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYJJWtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:49:53 -0400
Date: Fri, 10 Oct 2008 15:49:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] fastboot tree for v2.6.28
Message-ID: <20081010154929.6ec201fe@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0810101254240.3503@nehalem.linux-foundation.org>
References: <20081010003241.GA23940@elte.hu>
	<alpine.LFD.2.00.0810101254240.3503@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 13:10:30 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 10 Oct 2008, Ingo Molnar wrote:
> >
> > Please pull the latest fastboot-v28-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> > fastboot-v28-for-linus
> > 
> > the (opt-in) fastboot async bootup feature, as described by Arjan
> > in his v2.6.28 announcement:
> > 
> >    http://lwn.net/Articles/299591/
> > 
> > tested and maintained in -tip because tip/tracing embedd-merges
> > this topic. (for the fastboot tracer)
> 
> Ok, so I finally looked at the patch, I quite frankly, I think it's 
> fundamentally wrong.
> 
> This is just an example of the wrongness:
> 
> 	-module_init(uhci_hcd_init);
> 	+module_init_async(uhci_hcd_init);
> 	-module_init(ehci_hcd_init);
> 	+module_init_async(ehci_hcd_init);
> 	-module_init(ohci_hcd_mod_init);
> 	+module_init_async(ohci_hcd_mod_init);
> 
> 	-device_initcall(pci_init);
> 	+device_initcall_sync(pci_init);

(I know you saw this, but I want to just point out to more casual
readers that the pci_init call above is not "async", there's
deliberately no "a" there)
> 
> because there is absolutely _no_ excuse for doing the PCI part of the 
> probing asynchronously.

The PCI layer is absolutely not asychronous indeed, that would be
totally insane, and I really don't want to go there (nor do I think we
would need to to get to a fast boot). The initcall_sync above is to fix
a bug in the PCI layer where there was a subsystem level required call
stuck in the device level, and by sticking it in device_initcall_sync
it is at least guaranteed to run before any device initcalls.
>
> The "ohci_hcd_mod_init" part is _especially_ dangerous, because
> clearly nobody looked at the OHCI setup sequence, which includes a
> lot of odd devices and not all of them at all PCI-related etc. Making
> it asynchronous is not safe, nor is it appropriate.
> 
> The fact is, those things all have one thing in common:
> 
>  - they call usb_add_hcd, and usb_add_hcd is a horrible and slow
> piece of crap that doesn't just add the host controller, but does all
> the probing too.
> 
> In other words, what should be fixed is not the initcall sequence,
> and certainly not make PCI device probing (or other random buses) be
> partly asynchronous, but simply make that USB host controller startup
> function be asynchronous.

You are right and when you pull the USB tree later this week you'll get
that into your tree. You are right that for subsystem level components
that that is absolutely the right approach
> 
> In other words, I really think it's very wrong to make that 
> "async_init_wq" be somethign that is internal to do_initcalls. It
> should be a workqueue that the initcalls can _choose_ to use at the
> appropriate level (which may be deeper down, like 'usb_add_hcd()'),
> not be forced to use at the outermost one.
> 
> You can try to convince me otherwise, but I really do think this
> patch is fundamentally the wrong approach.

there's an angle here which I would like to bring up.
There is a fundamental difference between a spider functionality like
USB, and "leaf drivers". Yes USB should do it right, it's drivers are
effectively a midlayer. (and again, pull gregkh's tree and you'll get
that; although even with that there's a noticeable amount of time
spent there).

For leaf drivers, it's a matter of where you want to push the
functionality. With leaf drivers I mean things like the ACPI battery
driver (or other ACPI drivers), but also various PCI drivers that don't
have or are elaborate subsystems or boot dependencies. We could make all
their probing functions async in each driver, or we could provide the
most simple interface as is done in this case, they just change how
they declare their initcall.
(I'll grant you that we could also do a pci_register_device_async()
like of helper, but that's just solving part of the same problem)

Personally for leaf drivers, I think the initcall-level approach is much
less error prone. 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
