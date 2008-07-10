Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbYGJCIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbYGJCIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 22:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYGJCIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 22:08:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbYGJCIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 22:08:42 -0400
Date: Wed, 9 Jul 2008 19:01:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 17/34] AMD IOMMU: add generic defines and structures for
 mapping code
Message-Id: <20080709190140.ab662def.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-18-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:53 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds generic stuff used by the mapping and unmapping code for the
> AMD IOMMU.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/kernel/amd_iommu.c
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> new file mode 100644
> index 0000000..90392c7
> --- /dev/null
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -0,0 +1,40 @@
> +/*
> + * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
> + * Author: Joerg Roedel <joerg.roedel@amd.com>
> + *         Leo Duran <leo.duran@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/gfp.h>
> +#include <linux/bitops.h>
> +#include <linux/scatterlist.h>
> +#include <linux/iommu-helper.h>
> +#include <asm/proto.h>
> +#include <asm/gart.h>
> +#include <asm/amd_iommu_types.h>
> +
> +#define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))

Doesn't need to be implemented in a macro, hence should be implemented in C,
please.

> +#define to_pages(addr, size) \
> +	 (round_up(((addr) & ~PAGE_MASK) + (size), PAGE_SIZE) >> PAGE_SHIFT)

Does this patchset add any comments *at all*?  Is it really all so obvious
that this was justifiable?

I don't know what this function does, but it shouldn't be doing it here. 
Either it duplicates an existing helper or it should be implemented in mm.h

Preferably not as a macro.

Preferably with some documentation.

It is unobvious whether this haler has correct behaviour with all mixes of
32-bit and 64-bit signed and unsigned types.

> +static DEFINE_RWLOCK(amd_iommu_devtable_lock);
> +
> +struct command {
> +	u32 data[4];
> +};

Nothing in this file is used by anything.  I assume that later patches add
stuff to it.  This made it a bit hard to review.
