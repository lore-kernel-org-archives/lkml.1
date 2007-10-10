Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbXJJFh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbXJJFh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 01:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXJJFhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 01:37:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38994 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXJJFhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 01:37:14 -0400
Date: Wed, 10 Oct 2007 11:07:30 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: chandru <chandru@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, mark_salyzyn@adaptec.com, muli@il.ibm.com,
       ak@suse.de
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables in kdump
Message-ID: <20071010053730.GB24434@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1191962414.24134.68.camel@chandru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191962414.24134.68.camel@chandru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 02:10:13AM +0530, chandru wrote:
> kdump kernel fails to boot with calgary iommu and aacraid driver on a
> x366 box.  The ongoing dma's of aacraid from the first kernel continue
> to exist until the driver is loaded in the kdump kernel. Calgary is
> initialized prior to aacraid and creation of new tce tables causes wrong
> dma's to occur. 
> 
> Here we try to grab the tce tables of the first kernel in kdump kernel
> and use them. While in the kdump kernel we do not allocate new tce
> tables but rather read the base address register contents of calgary
> iommu and use the tables that the registers point to. With these changes
> the kdump kernel and hence aacraid now boots normally. 
> 
> Another point that came when talking with Vivek was to reserve part of
> the tce table space in first kernel for use in the kdump kernel. 
> 

Yes, I think reserving some entries for second kernel will be important
to make sure second kernel can perform DMA while saving the kernel core.
We don't want to clear some entries in second kernel as some ongoing DMA
might be using it and we will run into issues.

[..]
> --- linux-2.6.23-rc9/include/linux/bootmem.h.orig       2007-10-09
> 23:39:32.000000000 +0530
> +++ linux-2.6.23-rc9/include/linux/bootmem.h    2007-10-09
> 23:26:19.000000000 +0530
> @@ -21,6 +21,12 @@ extern unsigned long max_pfn;
> 
>  #ifdef CONFIG_CRASH_DUMP
>  extern unsigned long saved_max_pfn;
> +static inline int is_kdump_kernel(void)
> +{
> +       return reset_devices ? 1 : 0 ;
> +}
> +#else
> +static inline is_kdump_kernel(void) { return 0; }
>  #endif

In general, run checkpatch.pl on the patch.

is_kdump_kernel() can go in kdump specific files and exported here.
This function can be used by some other drivers too.

I think use "elfcorehdr" instead of "reset_devices" to detect the kdump
kernel. reset_devices can in general also be used for booting on a kernel
on a fauly bios which does not does a good job of resetting the devices.

Thanks
Vivek
