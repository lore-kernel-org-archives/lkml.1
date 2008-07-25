Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYGYN3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYGYN3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYGYN31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:29:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbYGYN30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:29:26 -0400
Date: Fri, 25 Jul 2008 15:29:18 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Vrabel <david.vrabel@csr.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080725152918.43bf3100@brian.englab.brq.redhat.com>
In-Reply-To: <200807221052.26879.jbarnes@virtuousgeek.org>
References: <4860D09D.4060801@csr.com>
	<48807166.9010006@csr.com>
	<20080722155629.1160635e@brian.englab.brq.redhat.com>
	<200807221052.26879.jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 10:52:26 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tuesday, July 22, 2008 6:56 am Michal Schmidt wrote:
> > This breaks the setting of SMP affinity for MSI interrupts :-(
> > With the patch, writes to /proc/irq/<n>/smp_affinity are ignored
> > for an MSI interrupt.
> 
> It should only break it for devices that don't provide a mask bit.
> But given that we can't really mask generically on those devices,
> maybe that's ok given that it fixes the other problems mentioned in
> this thread...

I looked a bit more into why exactly it breaks. The device for which
MSI IRQ affinity breaks is a "Broadcom Corporation NetXtreme II BCM5708
Gigabit Ethernet" (14e4:164c rev 12) in HP DL360 G5.

The interesting thing is that I can see Destination ID bits of MSI
Message Address change correctly in lspci output. But the interrupt is
still delivered load-balanced to all CPUs even though the Destination
ID identifies the single CPU I asked for. It seems the device only
takes the new Message Address setting into account when the MSI Enable
bit in the Message Control register is changed from 0 to 1. I tested
this by setting the MSI enable bit to 0 and then immediately back to 1
at the end of io_apic_64.c:set_msi_irq_affinity().

Is this a permitted behaviour for the device? I couldn't find anything
in the PCI specification that would mentioned it.

Later I tested it with a different device which does not have maskbits
either (an Intel Ethernet controller). For this device MSI IRQ
migration works without problems and no hackery with the MSI enable bit
was necessary.

Michal
