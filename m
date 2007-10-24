Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbXJXWW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbXJXWW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbXJXWWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:22:52 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:33214 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbXJXWWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:22:51 -0400
Date: Thu, 25 Oct 2007 07:09:06 +0900
To: kamalesh@linux.vnet.ibm.com, jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, apw@shadowen.org,
       linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <471F6DFE.3040304@linux.vnet.ibm.com>
References: <20071024115436.GT32058@shadowen.org>
	<20071024214014C.fujita.tomonori@lab.ntt.co.jp>
	<471F6DFE.3040304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071025071043P.tomof@acm.org>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 21:38:30 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> FUJITA Tomonori wrote:
> > On Wed, 24 Oct 2007 12:54:36 +0100
> > Andy Whitcroft <apw@shadowen.org> wrote:
> > 
> >> On Tue, Oct 23, 2007 at 08:44:20PM +0200, Jens Axboe wrote:
> >>> On Tue, Oct 23 2007, Kamalesh Babulal wrote:
> >>>> Hi,
> >>>>
> >>>> Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
> >>>> over the AMD box
> >>>>
> >>>> Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
> >>>>  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> >>>> PGD 10185b067 PUD 10075b067 PMD 0 
> >>>> Oops: 0002 [1] SMP 
> >>>> CPU 3 
> >>>> Modules linked in:
> >>>> Pid: 18676, comm: fsx-linux Not tainted 2.6.23-git18-autokern1 #1
> >>>> RIP: 0010:[<ffffffff8021f2f6>]  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> >>>> RSP: 0000:ffff810181edf948  EFLAGS: 00010002
> >>> Can you check where gart_map_sg+0x26c is at? Make sure you have
> >>> CONFIG_DEBUG_INFO defined, then do:
> >>>
> >>> $ gdb vmlinux
> >>> $ l *gart_map_sg+0x26c
> >> Ok, this problem still seems to be about in 2.6.24-rc1.  Here is the gdb
> >> output from that version, the panic (also below) seems the same:
> >>
> >> (gdb) l *gart_map_sg+0x26c
> >> 0xffffffff8022011e is in gart_map_sg (arch/x86/kernel/pci-gart_64.c:433).
> >> 428                     goto error;
> >> 429             out++;
> >> 430             flush_gart();
> >> 431             if (out < nents) {
> >> 432                     sgmap = sg_next(sgmap);
> >> 433                     sgmap->dma_length = 0;
> >> 434             }
> >> 435             return out;
> >> 436
> >> 437     error:
> >>
> >> So it seems sg_next has returned 0.
> > 
> > Have you tried this?
> > 
> > http://marc.info/?l=linux-kernel&m=119317981406073&w=2
> > -
> Hi,
> Thanks, this patch solves the kernel oops.

Thanks for testing!

Jens, here's the proper changelog.

-
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: pci-gart fix

map_sg could copy the last sg element to another position (if merging
some elements). It breaks sg chaining. This copies only
dma_address/length instead of the whole sg element.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index c56e9ee..ae7e016 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -338,7 +338,6 @@ static int __dma_map_cont(struct scatterlist *start, int nelems,
 		
 		BUG_ON(s != start && s->offset);
 		if (s == start) {
-			*sout = *s; 
 			sout->dma_address = iommu_bus_base;
 			sout->dma_address += iommu_page*PAGE_SIZE + s->offset;
 			sout->dma_length = s->length;
@@ -365,7 +364,7 @@ static inline int dma_map_cont(struct scatterlist *start, int nelems,
 {
 	if (!need) {
 		BUG_ON(nelems != 1);
-		*sout = *start;
+		sout->dma_address = start->dma_address;
 		sout->dma_length = start->length;
 		return 0;
 	}
-- 
1.5.2.4

