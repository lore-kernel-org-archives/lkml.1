Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbYJPRAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbYJPRAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYJPRAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:00:38 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:36182 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYJPRAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:00:37 -0400
Subject: Re: [PATCH] disable CPU side GART accesses
From: Bob Montgomery <bob.montgomery@hp.com>
Reply-To: bob.montgomery@hp.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <48F68940.40409@kernel.org>
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <20081015234842.GA10999@elte.hu>  <48F68940.40409@kernel.org>
Content-Type: text/plain
Organization: Contractor at HP
Date: Thu, 16 Oct 2008 11:00:45 -0600
Message-Id: <1224176445.2215.258.camel@amd.troyhebe>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 00:22 +0000, Yinghai Lu wrote:
> Ingo Molnar wrote:
> > (Cc:-ed the GART folks.)
> >
> > * Bob Montgomery <bob.montgomery@hp.com> wrote:
> >
> >> This patch prevents improper access of the GART aperture from kdump
> >> kernels running on AMD systems.
> >>

> >> This patch changes the initialization of the GART to set the
> >> DISGARTCPU bit in the GART Aperture Control Register
> >> (AMD64_GARTAPERTURECTL). Setting the bit prevents requests from the
> >> CPUs from accessing the GART.  In other words, CPU memory accesses to
> >> the aperture address range will not cause the GART to perform an
> >> address translation. The aperture area is currently being unmapped at
> >> the kernel level with set_memory_np() in gart_iommu_init to prevent
> >> accesses from the CPU, but that kernel level unmapping is not in
> >> effect in the kexec'd kdump kernel.  By disabling the CPU-side
> >> accesses within the GART, which does persist through the kexec of the
> >> kdump kernel, the kdump kernel is prevented from interacting with the
> >> GART during accesses to the dump memory areas which include the
> >> address range of the GART aperture. 


> >> Although the patch can be applied
> >> to the kdump kernel, it is not exercised there because the kdump
> >> kernel doesn't attempt to initialize the GART, since it typically runs
> >> in less than 4 GB of memory.

> 
> how about area is not used by IOMMU in GART?

> the code only set np to the iommu window.

I think you are not seeing the difference between kexec and kdump.  The
kdump kernel runs out of a pre-allocated area of memory that was taken
away from the original kernel, for example:
  01000000-08ffffff : Crash kernel

The kdump kernel does not try to re-use any of the original kernel's
memory, it only wants to copy it to a dump file.  The kdump kernel is
running in a small area of memory, so during initialization it ignores
the GART, since it doesn't need IOMMU translation to do IO to its memory
in the Crash kernel area.

The problem occurs when the copy operation reads from the GART aperture
(iommu window) and wakes up the GART translation hardware.  This patch
stops that by telling the GART to ignore addresses that come from the
CPU and to only translate addresses from the IO side. 
> 
> also following patch should fix the problem with kexec/kdump already. that patch is in mainline from 2.6.25-rc1.
> 

This problem was confirmed and then fixed by my patch on a 2.6.27 kernel
and independently on a 2.6.27-rc8 kernel by Chandru.  So it seems that
your patch does not fix this kdump-related problem.

Bob Montgomery

> YH
> 
> commit aaf230424204864e2833dcc1da23e2cb0b9f39cd
> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> Date:   Wed Jan 30 13:33:09 2008 +0100
> 
>     x86: disable the GART early, 64-bit
> 
>     For K8 system: 4G RAM with memory hole remapping enabled, or more than
>     4G RAM installed.
> 
>     when try to use kexec second kernel, and the first doesn't include
>     gart_shutdown. the second kernel could have different aper position than
>     the first kernel. and second kernel could use that hole as RAM that is
>     still used by GART set by the first kernel. esp. when try to kexec
>     2.6.24 with sparse mem enable from previous kernel (from RHEL 5 or SLES
>     10). the new kernel will use aper by GART (set by first kernel) for
>     vmemmap. and after new kernel setting one new GART. the position will be
>     real RAM. the _mapcount set is lost.
> 
>     Bad page state in process 'swapper'
>     page:ffffe2000e600020 flags:0x0000000000000000 mapping:0000000000000000 mapcount:1 count:0
>     Trying to fix it up, but a reboot is needed
>     Backtrace:
>     Pid: 0, comm: swapper Not tainted 2.6.24-rc7-smp-gcdf71a10-dirty #13
> 
>     Call Trace:
>      [<ffffffff8026401f>] bad_page+0x63/0x8d
>      [<ffffffff80264169>] __free_pages_ok+0x7c/0x2a5
>      [<ffffffff80ba75d1>] free_all_bootmem_core+0xd0/0x198
>      [<ffffffff80ba3a42>] numa_free_all_bootmem+0x3b/0x76
>      [<ffffffff80ba3461>] mem_init+0x3b/0x152
>      [<ffffffff80b959d3>] start_kernel+0x236/0x2c2
>      [<ffffffff80b9511a>] _sinittext+0x11a/0x121
> 
>     and
>      [ffffe2000e600000-ffffe2000e7fffff] PMD ->ffff81001c200000 on node 0
>     phys addr is : 0x1c200000
> 
>     RHEL 5.1 kernel -53 said:
>     PCI-DMA: aperture base @ 1c000000 size 65536 KB
> 
>     new kernel said:
>     Mapping aperture over 65536 KB of RAM @ 3c000000
> 
>     So could try to disable that GART if possible.
> 
> 

