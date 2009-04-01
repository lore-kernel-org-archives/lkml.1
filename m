Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZDAULT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZDAULT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbZDAULB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:11:01 -0400
Received: from www.tglx.de ([62.245.132.106]:49588 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbZDAULB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:11:01 -0400
Date: Wed, 1 Apr 2009 22:10:45 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Herrera-Bendezu, Luis" <lherrera@harris.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UIO: uio_mem does not handle devices above 4 GB address
Message-ID: <20090401201045.GB3734@bluebox.local>
References: <6FCCA913376DD7488F4139A4D11B8F48AC8CDE@troe2k1.cs.myharris.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6FCCA913376DD7488F4139A4D11B8F48AC8CDE@troe2k1.cs.myharris.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 01:20:49PM -0400, Herrera-Bendezu, Luis wrote:
> I am working on a PPC440EPx board with some FPGAs located at
> addresses above 4 GB

That's not exactly a good idea on a 32-bit processor. Can't you remap
that chip select to a decent address?

> and kernel version 2.6.28.7. The UIO driver is
> used to access the FPGAs. I get following error when trying to read
> FPGA registers:
> Machine check in kernel mode.
> Data Read PLB Error
> 
> The problem is traced to member addr in struct uio_mem:
> struct uio_mem {
>     unsigned long     addr;
>     unsigned long     size;
>     int               memtype;
>     void __iomem      *internal_addr;
>     struct uio_map    *map;
> };
> 
> When UIO_MEM_PHYS is used with device address > 32-bit then
> uio_mmap_physical() remaps address using idev->info->mem[mi].addr
> thus loosing high address bits.
> 
> One way to solve this problem is to change addr member to:
>     phys_addr_t       addr;

That alone won't solve the problem.

> 
> and modify corresponding attributes in uio.c. Only concern is that
> uio_vma_fault() calls virt_to_page() and vmalloc_to_page() where both
> have addr arg (unsigned long) and (const void *) respectively for
> powerpc. But these functions are only used for UIO_MEM_LOGICAL and
> UIO_MEM_VIRTUAL.

That probably won't work without large modifications.

> 
> Any alternative approach?

Yes, fix your hardware design.

Thanks,
Hans

