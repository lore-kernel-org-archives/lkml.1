Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbYJVLaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbYJVLaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJVLaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:30:04 -0400
Received: from sh.osrg.net ([192.16.179.4]:47130 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbYJVLaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:30:01 -0400
Date: Wed, 22 Oct 2008 20:29:24 +0900
To: tiwai@suse.de
Cc: svens@stackframe.org, fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: swiotlb_alloc_coherent: allocated memory is out of range for
 device
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <s5htzb4nbnd.wl%tiwai@suse.de>
References: <87d4hwuc9v.fsf@apollo.stackframe.org>
	<s5htzb4nbnd.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081022202809M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 12:53:58 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> At Sun, 19 Oct 2008 12:09:32 +0200,
> Sven Schnelle wrote:
> > 
> > Hi List,
> > 
> > my kernel dies while probing parport with the following last words:
> > 
> > [    3.672199] parport_pc 00:0b: reported by Plug and Play ACPI
> > [    3.677969] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
> > [    3.687691] hwdev DMA mask = 0x0000000000ffffff, dev_addr = 0x0000000020000000
> > [    3.694916] Kernel panic - not syncing: swiotlb_alloc_coherent: allocated memory is out of range for device
> > 
> > I haven't started a bisection yet, but this seems to be introduced
> > somewhere between 2.6.26 and 2.6.27, at least 2.6.26 was working without
> > problems. The dmesg log + config was obtained from a kernel compiled
> > from git on 10/16/2008.
> 
> This bug hits me, too.  Looks like swiotlb assumes that the alloc caller
> must set GFP_DMA appropriately by itself since GFP_DMA hack was
> removed.  The patch below should fix this particular case.

This happens with 2.6.27, right? GFP_DMA hack was removed post
2.6.27. What kernel version do you hit this problem?

Post 2.6.27, x86's alloc_coherent works a bit differently, but neither
require the caller set to GFP flag. arch/x86/kernel/pci-dma.c does
with 2.6.27 and asm-x86/dma-mapping.h does with post 2.6.27.


> HOWEVER: the fundamental problem appears to be in swiotlb itself.
> It assumes that iotlb pages are in DMA area.  But, in this case, the
> driver sets 24bit DMA (as of PnP) while iotlb pages are allocated 
> under 32bit DMA via alloc_bootmem_low_pages().  This doesn't work, of
> course.

If a device has 24bit dma mask, alloc_coherent is supposed to use
GFP_DMA.


> So, even adding GFP_DMA works mostly, it has still potentially
> breakage when you can't get the page and fall back to iotlb pages,
> just like the panic above.
> 
> Also, the removal of GFP_DMA hack is a bad idea.  For example, if a
> device requires 28bit DMA mask, it doesn't set always GFP_DMA for
> allocation because pages in ZONE_NORMAL may be inside that DMA mask.
> Normal allocators allow this behavior but swiotlb allocator doesn't.
> (Correct me if I'm wrong here -- I haven't followed much the recent
>  changes.)

28bit DMA mask is supposed to be handled properly. Firstly, we try
with DMA_32BIT_MASK and if an allocated address is not fit for 28bit
mask, we try GFP_DMA again.


> Last but not least, I think panic() in allocation error path is too
> strict.  Usually returning NULL isn't always fatal error, so give some
> more chance to debug, e.g. by calling WARN() (or whatever) instead of
> panic().

Yeah, this was discussed several times. The problem is that many
drivers assume that dma mapping operations, map_single, map_sg, and
map_coherent, always succeed and doesn't even check the errors. So we
have some panic() in IOMMU drivers to prevent really bad events like
data corruption.
