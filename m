Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbXE0HkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbXE0HkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 03:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbXE0HkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 03:40:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49409
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbXE0HkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 03:40:14 -0400
Date: Sun, 27 May 2007 00:40:19 -0700 (PDT)
Message-Id: <20070527.004019.41635814.davem@davemloft.net>
To: hpa@zytor.com
Cc: abraham.manu@gmail.com, rdreier@cisco.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
From: David Miller <davem@davemloft.net>
In-Reply-To: <4658EE32.5080506@zytor.com>
References: <46584C30.4030206@gmail.com>
	<20070526.154910.78725926.davem@davemloft.net>
	<4658EE32.5080506@zytor.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 May 2007 19:34:26 -0700

> There are systems which only get a single bit indication that an MSI has
> happened.
> 
> Presumably we need something like IRQF_MSI which can be set as
> appropriate depending on the architecture?

Although I don't want to make the IRQ handling subsystems any more
complicated than they already are, one idea I floated around is that
we could seperate CPU irq numbers (the things we pass around today)
and MSI vector numbers.

But I immediately understand how that is unnecessary to some extent,
any platform which needs to deal with that kind of distinction can use
virtual IRQ numbers like sparc64 and powerpc do.

Sparc64 PCI-E controllers, for example, allow you to group several
MSIs into a 'group', and the interrupt source is for the group rather
than the individual MSIs.  When the MSI group interrupt arrives, you
get a descriptor in a per-MSI-group ring buffer that describes the MSI
that arrived.

This descriptor in fact passes on a ton of interesting information,
see arch/sparc64/kernel/pci_sun4v.c:pci_sun4v_msiq_entry.

It gives you the type, the system TSC value at the time of interrupt
arrival (so you could do incredibly cool profiling with this),
the PCI bus/device/fn that generated the MSI vector, the MSI address
that was signalled, the MSI data field, and full information for PCI-E
MSG packets including bus/dev/fn of target, the message routing code,
and the message code.

But we use none of these facilities currently because it's either
impossible or too cumbersome to be useful at the moment.

