Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXE1CZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXE1CZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXE1CY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:24:56 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:50186 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbXE1CYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:24:55 -0400
X-IronPort-AV: i="4.14,585,1170662400"; 
   d="scan'208"; a="158022918:sNHT46420839"
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Greg KH <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
X-Message-Flag: Warning: May contain useful information
References: <20070523155958.GA5282@kroah.com> <4654AB40.6060208@gmail.com>
	<adaejl79rh0.fsf@cisco.com> <4654BC10.2000808@gmail.com>
	<adazm3v89hv.fsf@cisco.com> <4654C85B.6060505@gmail.com>
	<adatzu385g1.fsf@cisco.com> <46561287.8020103@gmail.com>
	<ada1wh560u1.fsf@cisco.com> <46584C30.4030206@gmail.com>
	<20070526182828.GA7080@colo.lackof.org> <46588A3D.2060208@gmail.com>
	<adaps4l21fe.fsf@cisco.com> <465A38B0.6030604@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 27 May 2007 19:24:54 -0700
In-Reply-To: <465A38B0.6030604@gmail.com> (Manu Abraham's message of "Mon, 28 May 2007 06:04:32 +0400")
Message-ID: <adahcpx1y89.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 May 2007 02:24:54.0397 (UTC) FILETIME=[60ACF2D0:01C7A0CF]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > At least on my device (PCI ID 1131:7162) there is no MSI-X capability,
 > > so that's not an option for you.  The current Linux implementation
 > > does not support more than one MSI interrupt, so you just get one
 > > interrupt with pci_enable_msi().
 > 
 > This would mean MSI or MSI-X ?  A bit confused now.

As I said, the device I have in my system:

    02:00.0 Multimedia controller: Philips Semiconductors Unknown device 7162
            Subsystem: Animation Technologies Inc. Unknown device 0820
            Flags: bus master, fast devsel, latency 0, IRQ 11
            Memory at 90200000 (64-bit, non-prefetchable) [size=1M]
            Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+ Queue=0/5 Enable-
            Capabilities: [50] Express Endpoint IRQ 0
            Capabilities: [74] Power Management version 2
            Capabilities: [80] Vendor Specific Information

...has only an MSI capability (the "[40] Message Signalled Interrupts"
line).  So MSI-X is not possible, since the device cannot do it.  And
that means you can at most do pci_enable_msi().  The current Linux MSI
support only handles a single interrupt, just like you get normally
(no matter how many MSI interrupts a device can handle).  To get
multiple interrupts from a single device under Linux, you must use
MSI-X and pci_enable_msix -- but for this to work, your device must
support MSI-X of course.

A device that supports both MSI and MSI-X would look like:

    0b:00.0 InfiniBand: Mellanox Technologies MT25204 [InfiniHost III Lx HCA] (rev 20)
            Subsystem: Mellanox Technologies MT25204 [InfiniHost III Lx HCA]
            Flags: bus master, fast devsel, latency 0, IRQ 16
            Memory at fc600000 (64-bit, non-prefetchable) [size=1M]
            Memory at d8800000 (64-bit, prefetchable) [size=8M]
            Capabilities: [40] Power Management version 2
            Capabilities: [48] Vital Product Data
            Capabilities: [90] Message Signalled Interrupts: Mask- 64bit+ Queue=0/5 Enable-
            Capabilities: [84] MSI-X: Enable- Mask- TabSize=32
            Capabilities: [60] Express Endpoint IRQ 0

with both "Message Signalled Interrupts" and "MSI-X" capabilities.

However, as I said before I think you shouldn't worry about MSI right
now.  Since there are many systems where MSI doesn't work, you'll need
to get the driver working with legacy (INTx) interrupts anyway.  And
you seem to be in a bit over your head just doing that without adding
the complexity of MSI on top, hence my recommendation to just focus on
the basic driver.

 - R.
