Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbXEPRVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbXEPRVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbXEPRVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:21:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:19568 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbXEPRVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:21:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,544,1170662400"; 
   d="scan'208";a="87484361"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22-rc1-mm1 - s390 vs. md
Date: Wed, 16 May 2007 10:21:25 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201DB0584@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070516095740.0f123058@gondolin.boeblingen.de.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22-rc1-mm1 - s390 vs. md
Thread-Index: AceXj+LC5y9esC0yRN6zfZFdNaRYBQASIjDQ
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "NeilBrown" <neilb@suse.de>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "linux-s390" <linux-s390@vger.kernel.org>
X-OriginalArrivalTime: 16 May 2007 17:21:21.0583 (UTC) FILETIME=[9F6133F0:01C797DE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Cornelia Huck [mailto:cornelia.huck@de.ibm.com]
> 
> On Tue, 15 May 2007 20:19:14 -0700,
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> >
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-
> rc1/2.6.22-rc1-mm1/
> 
> Doesn't build on s390 when selecting the md menu:
> 
> drivers/built-in.o(.text+0x438ae): In function `async_xor':
> : undefined reference to `dma_map_page'
> drivers/built-in.o(.text+0x43aac): In function `async_xor':
> : undefined reference to `dma_map_page'
> drivers/built-in.o(.text+0x43d2e): In function `async_xor_zero_sum':
> : undefined reference to `dma_map_page'
> drivers/built-in.o(.text+0x43f50): In function `async_memcpy':
> : undefined reference to `dma_map_page'
> drivers/built-in.o(.text+0x43f90): In function `async_memcpy':
> : undefined reference to `dma_map_page'
> drivers/built-in.o(.text+0x4423e): more undefined references to
> `dma_map_page' follow
> 
> This is caused by the following in drivers/md/Kconfig:
> 
> menuconfig MD
>         bool "Multiple devices driver support (RAID and LVM)"
>         depends on BLOCK
>         select ASYNC_TX_DMA
>         help
>           Support multiple physical spindles through a single logical
device.
>           Required for RAID and logical volume management.

The rationale for the 'select' here was to attempt to prevent user
confusion since MD_RAID456 now depends on ASYNC_TX_DMA.

> 
> ASYNC_TX_DMA is defined in drivers/dma/Kconfig, which has
> 
> menu "DMA Engine support"
>         depends on !S390
> 
> but unfortunately ASYNC_TX_DMA depends neither on the menu nor
> on !S390. (I think it was just an unknown symbol on s390 before
> Martin's Kconfig rework, so I could build older -mm kernels.)
> 
> Currently, the only md stuff depending on ASYNC_TX_DMA is MD_RAID456
> (which means it doesn't work on s390 anymore, which is bad enough).
> With the select statement, no md stuff can be build on s390 at all
(and
> I really don't see why ASYNC_TX_DMA should be forced upon all md
> users)...

I agree it should not be forced on all users, I will push the following
change:

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 4a1b77e..fd29a54 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -8,7 +8,6 @@ menu "Multi-device support (RAID and LVM)"

 config MD
        bool "Multiple devices driver support (RAID and LVM)"
-       select ASYNC_TX_DMA
        help
          Support multiple physical spindles through a single logical
device.
          Required for RAID and logical volume management.
@@ -109,7 +108,8 @@ config MD_RAID10

 config MD_RAID456
        tristate "RAID-4/RAID-5/RAID-6 mode"
-       depends on BLK_DEV_MD && ASYNC_TX_DMA
+       depends on BLK_DEV_MD
+       select ASYNC_TX_DMA
        ---help---
          A RAID-5 set of N drives with a capacity of C MB per drive
provides
          the capacity of C * (N - 1) MB, and protects against a failure

However this still will not allow s390 to build MD_RAID456.  This
dependency is in place because the xor.o object has moved from
drivers/md to drivers/dma.  The goal of the interface is to support
using offload engines when they are present, and use software routines
(like xor_block) when engines are not available.  In other words, the
intent is that DMA_ENGINE=n && ASYNC_TX_DMA=y is a valid configuration.

Can we rework the !S390 change to the DMA_ENGINE menu?  It seems to me
that S390 should follow the ARM example and only enable the driver menus
they want in arch/s390/Kconfig, no?

...

On a closer look, it seems async_tx should be its own directory like
crypto...  I'll post the incremental changes to the md-accel git tree
for review.

Dan
