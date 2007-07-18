Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXGRLY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXGRLY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXGRLYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:24:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46902 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751179AbXGRLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:24:19 -0400
Date: Wed, 18 Jul 2007 12:30:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Or Sagi" <ors@tutis.com>
Cc: <linux-kernel@vger.kernel.org>, <kvm-devel@lists.sourceforge.net>
Subject: Re: [RFC] Deferred interrupt handling.
Message-ID: <20070718123040.615795b7@the-village.bc.nu>
In-Reply-To: <005901c7c921$79c006c0$6d401440$@com>
References: <005901c7c921$79c006c0$6d401440$@com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In particular, this requires interrupt handling to be done by the guest --
> The host shouldn't load the corresponding device driver or otherwise access
> the device. Since the host kernel is not aware of the device semantics it
> cannot acknowledge the interrupt at the device level.

Tricky indeed.

> As far as the host kernel is concerned the VM is a user level process. We
> require the ability to forward interrupt handling to such entities. The
> current kernel interrupt handling path doesn't allow deferring interrupt
> handling _and_ acknowledgement.

We don't support this model at all, and it doesn't appear to work anyway.

> 0. Adding an IRQ_DEFERRED mechanism to the interrupt handling path. ISRs
> returning IRQ_DEFERRED will keep the interrupt masked until future
> acknowledge.

Deadlock. If you get an IRQ for a guest and you block the IRQ until the
guest handles it you may (eg if the IRQ is shared) get priority inversion
with another interrupt source on the same line the guest requires first
(eg disks and other I/O)

> Another issue we are aware of is the effect deferred handling will have on
> other devices sharing the interrupt. This seems to be a problem regardless
> of the solution.

Yes. This is the big reason Linux has never supported this kind of model
for anything but old ISA IRQ handling in vm86.
> 
> We wouldn't like to assume VT-d availability right now.
> 
> Any ideas ? Thoughts ?

Mask the interrupt in the main kernel, pass an event of some kind to the
guest. You can describe most devices from guest to kernel in a safe form
as

device, bar, offset, register size, mask, bits to set, bits to clear

(or bits to test when deciding if it is the irq source)

