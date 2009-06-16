Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZFPOGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZFPOGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZFPOGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:06:37 -0400
Received: from mail.oxtel.com ([193.200.114.15]:2610 "EHLO oxtel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752327AbZFPOGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:06:36 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 10:06:36 EDT
Message-ID: <4A37A503.3030209@oxtel.com>
Date: Tue, 16 Jun 2009 14:58:27 +0100
From: Chris Pringle <chris.pringle@oxtel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PowerPC PCI DMA issues (prefetch/coherency?)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: chris.pringle
X-Server: VPOP3 Enterprise V2.6.0b - Registered
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

We're developing on a Freescale MPC8272 and are having some nasty 
problems with PCI bus mastering and data corruption.

We have some custom hardware that is bus mastering, reading data from 
the CPUs memory for it's own use. Most of the time, the data is correct, 
however occasionally we are seeing data that appears to be from 
somewhere else in memory (usually memory that has already been read by 
the PCI device). The problem looks like stale data on the PCI bridge 
prefetch buffers or a cache coherency problem, but we've been unable to 
come up with a solution to our problem. It is my understanding that it 
shouldn't be a cache coherency problem as the CPU cache should be 
snooped as the data is read from memory. Even if it were an issue, the 
pci_map_sg* functions should have sorted out any cache coherency issues 
before the DMA operation started.

I've not been able to find anything on the Freescale data sheet that 
provides any way of flushing the prefetch cache on the PCI bridge. We've 
done a bit of experimenting, and found that turning off prefetch appears 
to solve (or possibly mask?) the problem (at the expensive of massive 
performance problems). I've also tried DMA'ing two adjacent userspace 
buffers in memory (from the same page), and see corruption on the second 
buffer. If I populate both buffers, then DMA them both, the data is 
fine. If I populate the first, DMA the first, then populate the second 
and DMA the second, corruption occurs at the start of the second buffer. 
If I add 8-32 bytes of padding between the buffers, the problem goes away.

The PCI spec says that the PCI bridge is supposed to flush any data from 
it's prefetch buffers that are not read by the bus master, so 
technically, this isn't supposed to happen.

I've tried making sure that buffers are cache line (and page) aligned, 
and are multiples of cache lines, but it's made no difference. PIO mode 
works fine, and I've checked the data with the CPU just before, and 
immediately after the DMA and the driver sees no data integrity issues. 
There are memory write barriers just before the DMA start, so all the 
registers should be correct before the DMA starts.

For background info, the device doing the bus mastering is a Xilinx 
Virtex 5 FPGA. We've monitored the data as it comes off the PCI bus 
using ChipScope - so the firmware should not be manipulating the data in 
any way.

We have some hardware/firmware/drivers that has a lot of common code 
that runs on an x86 platform (as opposed to powerpc), and that works 
without any issues whatsoever.

Has anyone got any ideas what this might be? Does anyone of know issues 
with PCI bridges on the PowerPC platform? Is there extra things that 
need to be done from the driver when DMAing on PowerPC (I've looked at 
other drivers and there's nothing obvious). The chip errata doesn't have 
anything on it that looks like it could cause this.

I'm really hoping this is something that we're doing wrong in the driver 
or the firmware, but we've been through both the firmware and drivers 
countless times and are unable to see anything wrong.

Any thoughts/ideas would be much appreciated!

Regards,
Chris

-- 

______________________________
Chris Pringle
Software Engineer

Miranda Technologies Ltd.
Hithercroft Road
Wallingford
Oxfordshire OX10 9DG
UK

Tel. +44 1491 820206
Fax. +44 1491 820001
www.miranda.com

____________________________

Miranda Technologies Limited
Registered in England and Wales CN 02017053
Registered Office: James House, Mere Park, Dedmere Road, Marlow, Bucks, SL7 1FJ
