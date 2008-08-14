Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYHNXLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYHNXLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYHNXLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:11:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYHNXLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:11:24 -0400
Date: Thu, 14 Aug 2008 19:11:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: David Miller <davem@davemloft.net>, Johannes Weiner <hannes@saeurebad.de>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Bootmem allocator broken [was: console handover badness]
In-Reply-To: <20080813.202559.193705172.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0808141855500.15262@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0808122053280.31704@hs20-bc2-1.build.redhat.com>
 <20080812.184052.193693538.davem@davemloft.net>
 <Pine.LNX.4.64.0808130845290.8416@hs20-bc2-1.build.redhat.com>
 <20080813.202559.193705172.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Wed, 13 Aug 2008 08:46:37 -0400 (EDT)
> 
> > On Tue, 12 Aug 2008, David Miller wrote:
> > 
> > > Mikulas can you send me the .config you're using in 2.6.27 to trigger
> > > this?
> > > 
> > > Thanks.
> > 
> > Here it is. The computer is Ultra 5 with 512MB RAM.
> 
> Thanks, I've tried a lot of things to try and reproduce this myself but to
> no avail.
> 
> Let's try to track down exactly where the corruption happens.  Please try
> the debug patch below on your box.  It will spit out a message something
> like:
> 
> [    0.000000] BUG: Bogus migrate type 5
> [    0.000000] BUG: Usemap for section 0 corrupted at sparse_init+0x17c/0x218[mm/sparse.c:498]
> 
> The theory is that some other piece of code is either not allocating a large
> enough buffer or overwriting past the end of a validly sized other buffer
> for some reason, and thus clobbering this pageblock flags bitmap.
> 
> Wherever this debugging check first triggers should give us some idea
> of who the culprit might be.

Hi

So I tried the patch and found out that the corruption happens in 
setup_command_line --- the first strcpy call corrupted the migratetype 
map.

Examining the problem further, it turned out that Johannes Weiner 
committed new bootmem allocator to 2.6.27-rc1 and the allocator is broken.

This is the minimal sequence that jams the allocator:

void *p, *q, *r;
p = alloc_bootmem(PAGE_SIZE);
q = alloc_bootmem(64);
free_bootmem(p, PAGE_SIZE);
p = alloc_bootmem(PAGE_SIZE);
r = alloc_bootmem(64);

--- after this sequence (assuming that the allocator was empty or 
page-aligned before), pointer "q" will be equal to pointer "r".

What's hapenning inside the allocator:
p = alloc_bootmem(PAGE_SIZE);
in allocator: last_end_off == PAGE_SIZE, bitmap contains bits 10000...
q = alloc_bootmem(64);
in allocator: last_end_off == PAGE_SIZE + 64, bitmap contains 11000...
free_bootmem(p, PAGE_SIZE);
in allocator: last_end_off == PAGE_SIZE + 64, bitmap contains 01000...
p = alloc_bootmem(PAGE_SIZE);
in allocator: last_end_off == PAGE_SIZE, bitmap contains 11000...
r = alloc_bootmem(64);
and now:
it finds bit "2", as a place where to allocate (sidx)
it hits the condition
if (bdata->last_end_off && PFN_DOWN(bdata->last_end_off) + 1 == sidx))
start_off = ALIGN(bdata->last_end_off, align);
--- you can see that the condition is true, so it assigns start_off = 
ALIGN(bdata->last_end_off, align); --- that is PAGE_SIZE --- and allocates 
over already allocated block.

This patch fixes it (kernels 2.6.27-rc2 and 2.6.27-rc3 boot ok after the 
patch). Johannes, please review the patch and submit it to Linus.

With the patch it tries to continue at the end of previous allocation only 
if the previous allocation ended in the middle of the page.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.27-rc2-orig/mm/bootmem.c
===================================================================
--- linux-2.6.27-rc2-orig.orig/mm/bootmem.c	2008-08-15 00:10:38.000000000 +0200
+++ linux-2.6.27-rc2-orig/mm/bootmem.c	2008-08-15 00:10:53.000000000 +0200
@@ -473,7 +473,7 @@ find_block:
 				goto find_block;
 			}
 
-		if (bdata->last_end_off &&
+		if (bdata->last_end_off & (PAGE_SIZE - 1) &&
 				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
 			start_off = ALIGN(bdata->last_end_off, align);
 		else


