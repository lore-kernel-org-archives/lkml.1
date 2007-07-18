Return-Path: <linux-kernel-owner+w=401wt.eu-S933433AbXGRP5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbXGRP5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbXGRP5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:57:05 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35538 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480AbXGRP5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:57:04 -0400
Date: Wed, 18 Jul 2007 11:57:03 -0400
To: Or Sagi <ors@tutis.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [RFC] Deferred interrupt handling.
Message-ID: <20070718155703.GA24545@csclub.uwaterloo.ca>
References: <005901c7c921$79c006c0$6d401440$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005901c7c921$79c006c0$6d401440$@com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 12:53:19PM +0300, Or Sagi wrote:
> Gentlepeople,
> 
> We're currently working on PCI device pass-through support for KVM. In this
> model all physical hardware access to specific devices will be performed by
> the VM, and not by the host.
> 
> In particular, this requires interrupt handling to be done by the guest --
> The host shouldn't load the corresponding device driver or otherwise access
> the device. Since the host kernel is not aware of the device semantics it
> cannot acknowledge the interrupt at the device level.
> 
> As far as the host kernel is concerned the VM is a user level process. We
> require the ability to forward interrupt handling to such entities. The
> current kernel interrupt handling path doesn't allow deferring interrupt
> handling _and_ acknowledgement.
> 
> We believe that this requires changing the current interrupt path in several
> fashions:
> 
> 0. Adding an IRQ_DEFERRED mechanism to the interrupt handling path. ISRs
> returning IRQ_DEFERRED will keep the interrupt masked until future
> acknowledge.
> 1. Deferred acknowledge mechanism which would acknowledge the APIC and
> unmask
> the interrupt.
> 
> An alternative idea was suggested at
> http://lists.xensource.com/archives/html/xen-devel/2007-05/msg01148.html ---
> which is based on reversing the polarity of the received interrupt. Once
> the guest acknowledges the interrupt at the device level, the polarity is
> reversed again by the host.
> 
> This may not be the best choice performance wise -- twice the interrupt
> count.
> 
> Another issue we are aware of is the effect deferred handling will have on
> other devices sharing the interrupt. This seems to be a problem regardless
> of the solution.
> 
> We wouldn't like to assume VT-d availability right now.
> 
> Any ideas ? Thoughts ?

What if you have two PCI devices sharing an interrupt, unless the host
OS knows about all the devices that can generate that interrupt, how it
is supposed to deal with it?  It can't know that it should pass in IRQ
to a guest OS, unless it can determine which device actually generated
the interrupt, which probably requires some knowledge of the devices
involved.  Should the guest be able to register as a handler of that
interrupt, so that the host has to call the guest's interrupt handler
everytime an interrupt occours that the guest has registered as a
potential handler of?  There might not be any other choice.  Maybe a
driver that simply registers as using the interrupt and then passes the
call to the guest somehow so the guest can determine if the device
generated the interrupt and handle it, and then return back to the main
interrupt handler.  Of course this would mean the guest has to be
scheduled and run during the host's interrupt handler which might just
not be an option.

Sounds tricky.

--
Len Sorensen
