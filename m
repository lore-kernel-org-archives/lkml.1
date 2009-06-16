Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbZFPOQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbZFPOQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZFPOQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:16:29 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:49625 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZFPOQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:16:29 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Chris Pringle <chris.pringle@oxtel.com>
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
Date: Tue, 16 Jun 2009 09:16:25 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4A37A503.3030209@oxtel.com>
In-Reply-To: <4A37A503.3030209@oxtel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906160916.28430.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue June 16 2009, Chris Pringle wrote:
> Hello All,
> 
> We're developing on a Freescale MPC8272 and are having some nasty 
> problems with PCI bus mastering and data corruption.
> 
> We have some custom hardware that is bus mastering, reading data from 
> the CPUs memory for it's own use. Most of the time, the data is correct, 
> however occasionally we are seeing data that appears to be from 
> somewhere else in memory (usually memory that has already been read by 
> the PCI device). The problem looks like stale data on the PCI bridge 
> prefetch buffers or a cache coherency problem, but we've been unable to 
> come up with a solution to our problem. It is my understanding that it 
> shouldn't be a cache coherency problem as the CPU cache should be 
> snooped as the data is read from memory. Even if it were an issue, the 
> pci_map_sg* functions should have sorted out any cache coherency issues 
> before the DMA operation started.
> 
> I've not been able to find anything on the Freescale data sheet that 
> provides any way of flushing the prefetch cache on the PCI bridge. We've 
> done a bit of experimenting, and found that turning off prefetch appears 
> to solve (or possibly mask?) the problem (at the expensive of massive 
> performance problems). I've also tried DMA'ing two adjacent userspace 
> buffers in memory (from the same page), and see corruption on the second 
> buffer. If I populate both buffers, then DMA them both, the data is 
> fine. If I populate the first, DMA the first, then populate the second 
> and DMA the second, corruption occurs at the start of the second buffer. 
> If I add 8-32 bytes of padding between the buffers, the problem goes away.
> 
> The PCI spec says that the PCI bridge is supposed to flush any data from 
> it's prefetch buffers that are not read by the bus master, so 
> technically, this isn't supposed to happen.
> 
> I've tried making sure that buffers are cache line (and page) aligned, 
> and are multiples of cache lines, but it's made no difference. PIO mode 
> works fine, and I've checked the data with the CPU just before, and 
> immediately after the DMA and the driver sees no data integrity issues. 
> There are memory write barriers just before the DMA start, so all the 
> registers should be correct before the DMA starts.
> 
> For background info, the device doing the bus mastering is a Xilinx 
> Virtex 5 FPGA. We've monitored the data as it comes off the PCI bus 
> using ChipScope - so the firmware should not be manipulating the data in 
> any way.
> 
> We have some hardware/firmware/drivers that has a lot of common code 
> that runs on an x86 platform (as opposed to powerpc), and that works 
> without any issues whatsoever.
> 
> Has anyone got any ideas what this might be? Does anyone of know issues 
> with PCI bridges on the PowerPC platform? Is there extra things that 
> need to be done from the driver when DMAing on PowerPC (I've looked at 
> other drivers and there's nothing obvious). The chip errata doesn't have 
> anything on it that looks like it could cause this.
> 
> I'm really hoping this is something that we're doing wrong in the driver 
> or the firmware, but we've been through both the firmware and drivers 
> countless times and are unable to see anything wrong.
> 
> Any thoughts/ideas would be much appreciated!
> 

Did you actually check the load image for proper alignment?
Like in:

gen2-32 compressed # objdump -x vmlinux.bin
- - - - -
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
- - - - -
 21 .data.page_aligned 00001800  c068a000  0068a000  0058b000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
 22 .data.cacheline_aligned 000026c0  c068b800  0068b800  0058c800  2**6
                  CONTENTS, ALLOC, LOAD, DATA
 23 .data.read_mostly 00001e98  c068dec0  0068dec0  0058eec0  2**6
                  CONTENTS, ALLOC, LOAD, DATA

= = = =

I had to make this change to the x86 loader script to get alignment for VIA:

diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 62ad500..26f68a5 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -82,7 +82,7 @@ SECTIONS
        *(.data.idt)
   }

-  . = ALIGN(32);
+  . = ALIGN(L1_CACHE_BYTES);
   .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
        *(.data.cacheline_aligned)
   }

= = = =

Eyeball your loader script if you haven't already done so.

Mike
> Regards,
> Chris
> 


