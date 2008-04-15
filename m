Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbYDOSok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbYDOSok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYDOSod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:44:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:3764 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYDOSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JVYYIAzXYYTUn3EQz2DX/wuefrFZ1VP4nik/+HlwI6yeu8WejxXAoPTOV54dtUuOpaBnzlaBRmGxakKkb+ngnSrDt32qnqCza6UZW9dvcBMJUmrkfSyPHJMDc3ZxRbbaHi3GQbbKWIPYZRB9Ew/9nkmuDiHOplBMmv6DGHCG9Ro=
Message-ID: <86802c440804151144l7497dae3nb3b07374fd71a282@mail.gmail.com>
Date: Tue, 15 Apr 2008 11:44:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <87skxnibb1.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	 <20080412225850.704752615@symbol.fehenstaub.lan>
	 <87lk3hwv52.fsf@basil.nowhere.org>
	 <20080414232308.ffa4e269.akpm@linux-foundation.org>
	 <48045D6C.1010508@firstfloor.org> <87skxnibb1.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 4:53 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>
> Andi Kleen <andi@firstfloor.org> writes:
>
>  > Andrew Morton wrote:
>  >> On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>  >>
>  >>> Johannes Weiner <hannes@saeurebad.de> writes:
>  >>>
>  >>>> Make free_bootmem() look up the node holding the specified address
>  >>>> range which lets it work transparently on single-node and multi-node
>  >>>> configurations.
>  >>> Acked-by: Andi Kleen <andi@firstfloor.org>
>  >>>
>  >>> This is far better than the original change it replaces and which
>  >>> I also objected to in review.
>  >>>
>  >>
>  >> So...  do we think these two patches are sufficiently safe and important for
>  >> 2.6.25?
>  >
>  > It's only strictly needed for .26 I think for some (also slightly
>  > dubious) changes queued in git-x86.
>
>  Does anything yet rely on this new free_bootmem() behaviour?  If not,
>  the safest thing would be to just revert the original patch in mainline
>  and drop the second patch completely.

1. free_bootmem(ramdisk_image, ramdisk_size) in setup_arch of x86_64 need that
2. another patch in x86.git need that.

YH

commit f62f1fc9ef94f74fda2b456d935ba2da69fa0a40
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Fri Mar 7 15:02:50 2008 -0800

    x86: reserve dma32 early for gart

    a system with 256 GB of RAM, when NUMA is disabled crashes the
    following way:

    Your BIOS doesn't leave a aperture memory hole
    Please enable the IOMMU option in the BIOS setup
    This costs you 64 MB of RAM
    Cannot allocate aperture memory hole (ffff8101c0000000,65536K)
    Kernel panic - not syncing: Not enough memory for aperture
    Pid: 0, comm: swapper Not tainted 2.6.25-rc4-x86-latest.git #33

    Call Trace:
     [<ffffffff84037c62>] panic+0xb2/0x190
     [<ffffffff840381fc>] ? release_console_sem+0x7c/0x250
     [<ffffffff847b1628>] ? __alloc_bootmem_nopanic+0x48/0x90
     [<ffffffff847b0ac9>] ? free_bootmem+0x29/0x50
     [<ffffffff847ac1f7>] gart_iommu_hole_init+0x5e7/0x680
     [<ffffffff847b255b>] ? alloc_large_system_hash+0x16b/0x310
     [<ffffffff84506a2f>] ? _etext+0x0/0x1
     [<ffffffff847a2e8c>] pci_iommu_alloc+0x1c/0x40
     [<ffffffff847ac795>] mem_init+0x45/0x1a0
     [<ffffffff8479ff35>] start_kernel+0x295/0x380
     [<ffffffff8479f1c2>] _sinittext+0x1c2/0x230

    the root cause is : memmap PMD is too big,
    [ffffe200e0600000-ffffe200e07fffff] PMD ->ffff81383c000000 on node 0
    almost near 4G..., and vmemmap_alloc_block will use up the ram under 4G.

    solution will be:
    1. make memmap allocation get memory above 4G...
    2. reserve some dma32 range early before we try to set up memmap for all.
    and release that before pci_iommu_alloc, so gart or swiotlb could get some
    range under 4g limit for sure.

    the patch is using method 2.
    because method1 may need more code to handle SPARSEMEM and SPASEMEM_VMEMMAP

    will get
    Your BIOS doesn't leave a aperture memory hole
    Please enable the IOMMU option in the BIOS setup
    This costs you 64 MB of RAM
    Mapping aperture over 65536 KB of RAM @ 4000000
    Memory: 264245736k/268959744k available (8484k kernel code,
4187464k reserved, 4004k data, 724k init)
