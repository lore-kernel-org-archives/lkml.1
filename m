Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbXEPH5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbXEPH5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbXEPH5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:57:45 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:54500 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbXEPH5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:57:43 -0400
Date: Wed, 16 May 2007 09:57:40 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       NeilBrown <neilb@suse.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1 - s390 vs. md
Message-ID: <20070516095740.0f123058@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 20:19:14 -0700,
Andrew Morton <akpm@linux-foundation.org> wrote:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/

Doesn't build on s390 when selecting the md menu:

drivers/built-in.o(.text+0x438ae): In function `async_xor':
: undefined reference to `dma_map_page'
drivers/built-in.o(.text+0x43aac): In function `async_xor':
: undefined reference to `dma_map_page'
drivers/built-in.o(.text+0x43d2e): In function `async_xor_zero_sum':
: undefined reference to `dma_map_page'
drivers/built-in.o(.text+0x43f50): In function `async_memcpy':
: undefined reference to `dma_map_page'
drivers/built-in.o(.text+0x43f90): In function `async_memcpy':
: undefined reference to `dma_map_page'
drivers/built-in.o(.text+0x4423e): more undefined references to
`dma_map_page' follow

This is caused by the following in drivers/md/Kconfig:

menuconfig MD
        bool "Multiple devices driver support (RAID and LVM)"
        depends on BLOCK
        select ASYNC_TX_DMA
        help
          Support multiple physical spindles through a single logical device.
          Required for RAID and logical volume management.

ASYNC_TX_DMA is defined in drivers/dma/Kconfig, which has

menu "DMA Engine support"
        depends on !S390

but unfortunately ASYNC_TX_DMA depends neither on the menu nor
on !S390. (I think it was just an unknown symbol on s390 before
Martin's Kconfig rework, so I could build older -mm kernels.)

Currently, the only md stuff depending on ASYNC_TX_DMA is MD_RAID456
(which means it doesn't work on s390 anymore, which is bad enough).
With the select statement, no md stuff can be build on s390 at all (and
I really don't see why ASYNC_TX_DMA should be forced upon all md
users)...
