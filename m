Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYGHN3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYGHN3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYGHN32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:29:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbYGHN31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:29:27 -0400
Date: Tue, 8 Jul 2008 09:28:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bob Montgomery <bob.montgomery@hp.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       Andi Kleen <ak@suse.de>, Dave Jones <rhkernel-list@redhat.com>,
       airlied@linux.ie,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: AMD Family 10H machine check on vmcore read
Message-ID: <20080708132855.GB7866@redhat.com>
References: <1215472086.3361.297.camel@amd.troyhebe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215472086.3361.297.camel@amd.troyhebe>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 05:08:06PM -0600, Bob Montgomery wrote:
> We maintain a 2.6.18 derived kernel.  
> When testing kdump on a new AMD Family 10h (16) processor, once in the
> kdump kernel, a read from either /proc/vmcore or /dev/oldmem that
> corresponds to the area of memory identified in the original (crashing)
> kernel by these boot messages:
> 
> Mapping aperture over 65536 KB of RAM @ 1c000000
> ...
> PCI-DMA: Disabling AGP.
> PCI-DMA: aperture base @ 1c000000 size 65536 KB
> PCI-DMA: using GART IOMMU.
> 
> causes a machine check.
> 
> On a Family 15 AMD64 processor running this kernel and kdump kernel, I
> can read the areas identified as being in the aperture from the kdump
> kernel and get values, but on the new processor, reads from the kdump
> kernel that are within that address range result in the machine check:
> 
> HARDWARE ERROR
> CPU 0: Machine Check Exception:                4 Bank 4: be0000010005001b
> TSC 141bd974323de ADDR 1c000000 MISC e00c0ffe01000000
> 
> While up on the original kernel, attempts to read those locations
> from /dev/mem result in EFAULTs on both the old and new processors.
> It's just the reads from the kdump kernel's /proc/vmcore or /dev/oldmem
> that work ok on the old processor and machine check on the new one.
> 
> The output of /proc/iomem does not specifically identify the area.  It's
> just within the range of: 
> 
> 00100000-cfe4ffff : System RAM
> 
> I found code in arch/x86_64/kernel/mce.c:mce_cpu_quirks() that disables
> GART TBL walk errors to prevent machine checks.  The code checked for
> family 15 and so I added family 16 as well.  Here is a patch that fixes
> my version of the kernel:
> 
> --- linux-source-2.6.18-kdump/arch/x86_64/kernel/mce.c.orig	2008-07-02 09:27:39.000000000 -0600
> +++ linux-source-2.6.18-kdump/arch/x86_64/kernel/mce.c	2008-07-02 09:28:45.000000000 -0600
> @@ -354,7 +354,8 @@ static void mce_init(void *dummy)
>  static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
>  { 
>  	/* This should be disabled by the BIOS, but isn't always */
> -	if (c->x86_vendor == X86_VENDOR_AMD && c->x86 == 15) {
> +	if (c->x86_vendor == X86_VENDOR_AMD && 
> +			((c->x86 == 15) || (c->x86 == 16))) {
>  		/* disable GART TBL walk error reporting, which trips off 
>  		   incorrectly with the IOMMU & 3ware & Cerberus. */
>  		clear_bit(10, &bank[4]);
> 
> 
Hi Bob,

I am not sure what's happening here. Because in /proc/iomem, GART reserved
area is reported as System RAM, kdump kernel will try to read this area
and save it. Now I am not sure, what is so special about this area that
mapping it and reading it in second kernel would cause a MCE.

CCing it to LKML, hoping people knowing GART will be able to provide some
input.

> But I don't see this fix upstream in the kernel.  So I'm wondering if
> some other patch protects other kdump kernels from this problem.  In
> particular, a recent patch that informed the e820 map about the gart
> aperture to prevent a normal kernel and a kexec kernel from putting it
> at different addresses.  It didn't mention machine checks from kdump
> kernels, but I wonder if it would have prevented access to that memory
> area by having it be excluded from the /proc/vmcore list of areas??

Can you provide a link to the patch above? If /proc/iomem, does not report
GART area as system ram then it will be excluded from the dump. (IIUC,
IOMMU tables are in GART area and ideally one should be capturing it to 
find out how IOMMU tables looked like at the time of crash).

Thanks
Vivek
