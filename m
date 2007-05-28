Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbXE1BDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbXE1BDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXE1BDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:03:33 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31527 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbXE1BDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:03:32 -0400
X-IronPort-AV: i="4.14,585,1170662400"; 
   d="scan'208"; a="155191097:sNHT42938388"
To: David Miller <davem@davemloft.net>
Cc: abraham.manu@gmail.com, greg@kroah.com, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: PCIE
X-Message-Flag: Warning: May contain useful information
References: <46561287.8020103@gmail.com> <ada1wh560u1.fsf@cisco.com>
	<46584C30.4030206@gmail.com>
	<20070526.154910.78725926.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 27 May 2007 18:03:29 -0700
In-Reply-To: <20070526.154910.78725926.davem@davemloft.net> (David Miller's message of "Sat, 26 May 2007 15:49:10 -0700 (PDT)")
Message-ID: <ada3b1h3gke.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 May 2007 01:03:30.0374 (UTC) FILETIME=[01922E60:01C7A0C4]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > i presume then i shouldn't be using IRQF_SHARED, if using MSI.
 > 
 > That's actually a really good question.
 > 
 > It is likely architecture dependant whether the PCI controller wires
 > unique MSI interrupts to shared cpu interrupt lines.

Yes, but current Linux drivers assume that MSI interrupts are
non-shared.  Certainly in my drivers I make that assumption, and from
a quick look neither tg3 nor e1000 sets IRQF_SHARED if they enable
MSI.

I think that if we run on a system where MSI interrupts may be shared,
then we should just have pci_enable_msi() fail.  If drivers have to
allow for shared MSI interrupts, then they lose most of the advantage
of MSI -- if I get an MSI but I don't know it came from my device, I
probably have to do an MMIO read to find out if it's mine or not and
also to preserve DMA ordering, which kills the main advantage of MSI.
And since MSIs are basically edge triggered, sharing vectors is going
to lead to all sorts of hassles.

 > I can imagine many systems where the cpu simply doesn't have enough
 > interrupt pins to uniquely identify every possible MSI interrupt
 > source.

I have a hard time imagining a PCI host bus controller that converts
MSI interrupts back to wire interrupts that go to pins on the CPU.
For one thing it would be hard to maintain the guarantee that
MSI interrupts can't pass DMAs.  And it would be an absolutely silly
architecture too.

 - R.
