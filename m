Return-Path: <linux-kernel-owner+w=401wt.eu-S2992942AbXEBIz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992942AbXEBIz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992943AbXEBIz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:55:59 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:33407 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992942AbXEBIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:55:58 -0400
X-IronPort-AV: i="4.14,478,1170651600"; 
   d="scan'208"; a="28854636:sNHT25461485"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg Ungerer" <gerg@snapgear.com>
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
Date: Wed, 2 May 2007 04:58:06 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <46382055.8030203@snapgear.com>
In-Reply-To: <46382055.8030203@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705020458.06595.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 02 May 2007 08:55:55.0356 (UTC) FILETIME=[B1C1B1C0:01C78C97]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2 May 2007 01:23, Greg Ungerer pondered:
> Hi All,
>
> An update of the uClinux (MMU-less) code against 2.6.21.
> A lot of cleanups, and a few bug fixes.
>
> Ahead is more changes to finalize platform device support
> for the new style ColdFire serial driver, and switching to
> the generic irq code.
>
> http://www.uclinux.org/pub/uClinux/uClinux-2.6.x/linux-2.6.21-uc0.patch.gz

Greg:

Is is possible to split out the m68k stuff from the generic nommu stuff? (or 
maybe I am missing the point of this patch? - it is for review/inclusion into 
the -mm tree, or just for end users wanting to use 2.6.21?)

The patch is labeled uClinux (MMU-less), which I read as generic, but the 
majority has to do with only m68knommu.

 arch/m68knommu/Kconfig                   |   12
 arch/m68knommu/Makefile                  |    4
 arch/m68knommu/kernel/process.c          |    2
 arch/m68knommu/kernel/setup.c            |  116 +---
 arch/m68knommu/kernel/time.c             |    9
 arch/m68knommu/mm/memory.c               |  100 ---
 arch/m68knommu/platform/5206/config.c    |    8
 arch/m68knommu/platform/5206e/config.c   |    7
 arch/m68knommu/platform/520x/config.c    |  122 ++++
 arch/m68knommu/platform/523x/config.c    |    8
 arch/m68knommu/platform/5249/config.c    |   51 +
 arch/m68knommu/platform/5272/config.c    |    7
 arch/m68knommu/platform/527x/config.c    |    7
 arch/m68knommu/platform/528x/config.c    |    7
 arch/m68knommu/platform/5307/config.c    |    5
 arch/m68knommu/platform/5307/entry.S     |   20
 arch/m68knommu/platform/5307/ints.c      |   23
 arch/m68knommu/platform/5307/timers.c    |   10
 arch/m68knommu/platform/532x/config.c    |   46 +
 arch/m68knommu/platform/5407/config.c    |    7
 arch/m68knommu/platform/68328/config.c   |    3
 arch/m68knommu/platform/68360/config.c   |    2
 arch/m68knommu/platform/68EZ328/config.c |    2
 arch/m68knommu/platform/68VZ328/config.c |    7
 include/asm-m68knommu/dma.h              |    2
 include/asm-m68knommu/hw_irq.h           |    4
 include/asm-m68knommu/m528xsim.h         |    3
 include/asm-m68knommu/m532xsim.h         |   85 ++-
 include/asm-m68knommu/machdep.h          |   50 -
 include/asm-m68knommu/mcfuart.h          |   11
 include/asm-m68knommu/pgtable.h          |    7
 include/asm-m68knommu/timex.h            |   24
 include/asm-m68knommu/uaccess.h          |   11
 drivers/net/fec.c                        |   71 +-
 drivers/serial/68328serial.c             |   59 --
 drivers/serial/mcf.c                     |  826 +++++++++++++++++++++++++++++

The only generic stuff is:

 Makefile                                 |    2
 drivers/pci/pci.c                        |    2
 fs/binfmt_flat.c                         |    2
 fs/namei.c                               |    2
 mm/nommu.c                               |   15
 mm/page_alloc.c                          |    8

I looked at those, and had a question:

(copy and paste screws up the formatting, sorry):

> diff -Naur linux-2.6.21/fs/namei.c linux-2.6.21-uc0/fs/namei.c
> --- linux-2.6.21/fs/namei.c     2007-05-01 17:12:53.000000000 +1000
> +++ linux-2.6.21-uc0/fs/namei.c 2007-05-01 17:16:18.000000000 +1000
> @@ -120,12 +120,14 @@
>         int retval;
>         unsigned long len = PATH_MAX;
>
> +#ifdef CONFIG_MMU
>         if (!segment_eq(get_fs(), KERNEL_DS)) {
>                 if ((unsigned long) filename >= TASK_SIZE)
>                         return -EFAULT;
>                 if (TASK_SIZE - (unsigned long) filename < PATH_MAX)
>                         len = TASK_SIZE - (unsigned long) filename;
>         }
> +#endif
>
>         retval = strncpy_from_user(page, filename, len);
>         if (retval > 0) {

I was trying to understand why we don't want to do the same checking on noMMU?

Thanks
-Robin
