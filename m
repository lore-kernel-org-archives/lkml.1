Return-Path: <linux-kernel-owner+w=401wt.eu-S933141AbYGQXRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbYGQXRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760521AbYGQXQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:16:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138AbYGQXQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:16:50 -0400
Date: Thu, 17 Jul 2008 16:14:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chandru <chandru@in.ibm.com>
Cc: muli@il.ibm.com, linux-kernel@vger.kernel.org, alexisb@us.ibm.com,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
 in kdump
Message-Id: <20080717161414.c5a267f7.akpm@linux-foundation.org>
In-Reply-To: <200807151415.27845.chandru@in.ibm.com>
References: <1191962414.24134.68.camel@chandru>
	<200806211741.43703.chandru@in.ibm.com>
	<20080623192918.GB6989@il.ibm.com>
	<200807151415.27845.chandru@in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 14:15:27 +0530
Chandru <chandru@in.ibm.com> wrote:

> kdump kernel fails to boot with calgary iommu and aacraid driver on a x366 
> box. The ongoing dma's of aacraid from the first kernel continue to exist 
> until the driver is loaded in the kdump kernel. Calgary is initialized prior 
> to aacraid and creation of new tce tables causes wrong dma's to occur. Here 
> we try to get the tce tables of the first kernel in kdump kernel and use 
> them. While in the kdump kernel we do not allocate new tce tables but instead 
> read the base addres register contents of calgary iommu and use the tables 
> that the registers point to. With these changes the kdump kernel and hence 
> aacraid now boots normally.
> 
> Signed-off-by: Chandru Siddalingappa <chandru@in.ibm.com>
> ---
> 
> patch taken on top of linux-2.6.26 stable. Comments from Muli Ben-Yehuda taken 
> into consideration. Pls apply it as a stop-gap patch until we can come up 
> with a more stable patch for this issue. Thanks,

Is this needed in 2.6.26?

If so, the patch whcih I applied will need a little work because I had
to touch up some rejects against already-queued changes.  I can fix
that issue by applying this _ahead_ of those changes, but I'm just not
able to judge whether this is needed from the information which was
provided.

> diff -Narup linux-2.6.26-orig/arch/x86/kernel/pci-calgary_64.c 
> linux-2.6.26/arch/x86/kernel/pci-calgary_64.c
> --- linux-2.6.26-orig/arch/x86/kernel/pci-calgary_64.c	2008-07-15 
> 13:36:00.000000000 +0530
> +++ linux-2.6.26/arch/x86/kernel/pci-calgary_64.c	2008-07-15 
> 13:45:36.000000000 +0530
> @@ -36,6 +36,7 @@
>  #include <linux/delay.h>
>  #include <linux/scatterlist.h>
>  #include <linux/iommu-helper.h>
> +#include <linux/crash_dump.h>

You don't _have_ to put new includes right at the end of the list! 
Everyone does this, and it just maximises the probability of merge
conflcits :(


>  #include <asm/gart.h>
>  #include <asm/calgary.h>
>  #include <asm/tce.h>
> @@ -167,6 +168,8 @@ static void calgary_dump_error_regs(stru
>  static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev 
> *dev);

The patch was wordwrapped.

> +	max_pfn = is_kdump_kernel() ? saved_max_pfn : end_pfn ;
> ...
> +	return (elfcorehdr_addr != ELFCORE_ADDR_MAX) ? 1 : 0 ;
> ...

A couple of little coding-style errors there.  checkpatch missed them.
