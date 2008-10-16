Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYJPAYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYJPAYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 20:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbYJPAY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 20:24:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:60506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbYJPAY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 20:24:26 -0400
Message-ID: <48F68940.40409@kernel.org>
Date: Wed, 15 Oct 2008 17:22:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bob Montgomery <bob.montgomery@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       vojtech@suse.cz, Linus Torvalds <torvalds@linux-foundation.org>,
       chandru@in.ibm.com, Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] disable CPU side GART accesses
References: <1224107317.2215.238.camel@amd.troyhebe> <20081015234842.GA10999@elte.hu>
In-Reply-To: <20081015234842.GA10999@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> (Cc:-ed the GART folks.)
> 
> * Bob Montgomery <bob.montgomery@hp.com> wrote:
> 
>> This patch prevents improper access of the GART aperture from kdump 
>> kernels running on AMD systems.
>>
>> Symptoms of the problem include hangs, spurious restarts, and MCE 
>> (Machine Check Exception) panics in some AMD Opteron systems that 
>> enable the GART IOMMU and access /proc/vmcore or /dev/oldmem from a 
>> kdump kernel.  Note that the GART IOMMU will not be enabled on systems 
>> with less than 4 GB of RAM, so symptoms will not appear.  This problem 
>> has been reproduced on Family 10H Quad-Core AMD Opteron systems.
>>
>> This patch changes the initialization of the GART to set the 
>> DISGARTCPU bit in the GART Aperture Control Register 
>> (AMD64_GARTAPERTURECTL). Setting the bit prevents requests from the 
>> CPUs from accessing the GART.  In other words, CPU memory accesses to 
>> the aperture address range will not cause the GART to perform an 
>> address translation. The aperture area is currently being unmapped at 
>> the kernel level with set_memory_np() in gart_iommu_init to prevent 
>> accesses from the CPU, but that kernel level unmapping is not in 
>> effect in the kexec'd kdump kernel.  By disabling the CPU-side 
>> accesses within the GART, which does persist through the kexec of the 
>> kdump kernel, the kdump kernel is prevented from interacting with the 
>> GART during accesses to the dump memory areas which include the 
>> address range of the GART aperture.  Although the patch can be applied 
>> to the kdump kernel, it is not exercised there because the kdump 
>> kernel doesn't attempt to initialize the GART, since it typically runs 
>> in less than 4 GB of memory.

how about area is not used by IOMMU in GART?

        /*
         * Unmap the IOMMU part of the GART. The alias of the page is
         * always mapped with cache enabled and there is no full cache
         * coherency across the GART remapping. The unmapping avoids
         * automatic prefetches from the CPU allocating cache lines in
         * there. All CPU accesses are done via the direct mapping to
         * the backing memory. The GART address is only used by PCI
         * devices.
         */
        set_memory_np((unsigned long)__va(iommu_bus_base),
                                iommu_size >> PAGE_SHIFT);

the code only set np to the iommu window.

also following patch should fix the problem with kexec/kdump already. that patch is in mainline from 2.6.25-rc1.

YH

commit aaf230424204864e2833dcc1da23e2cb0b9f39cd
Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date:   Wed Jan 30 13:33:09 2008 +0100

    x86: disable the GART early, 64-bit

    For K8 system: 4G RAM with memory hole remapping enabled, or more than
    4G RAM installed.

    when try to use kexec second kernel, and the first doesn't include
    gart_shutdown. the second kernel could have different aper position than
    the first kernel. and second kernel could use that hole as RAM that is
    still used by GART set by the first kernel. esp. when try to kexec
    2.6.24 with sparse mem enable from previous kernel (from RHEL 5 or SLES
    10). the new kernel will use aper by GART (set by first kernel) for
    vmemmap. and after new kernel setting one new GART. the position will be
    real RAM. the _mapcount set is lost.

    Bad page state in process 'swapper'
    page:ffffe2000e600020 flags:0x0000000000000000 mapping:0000000000000000 mapcount:1 count:0
    Trying to fix it up, but a reboot is needed
    Backtrace:
    Pid: 0, comm: swapper Not tainted 2.6.24-rc7-smp-gcdf71a10-dirty #13

    Call Trace:
     [<ffffffff8026401f>] bad_page+0x63/0x8d
     [<ffffffff80264169>] __free_pages_ok+0x7c/0x2a5
     [<ffffffff80ba75d1>] free_all_bootmem_core+0xd0/0x198
     [<ffffffff80ba3a42>] numa_free_all_bootmem+0x3b/0x76
     [<ffffffff80ba3461>] mem_init+0x3b/0x152
     [<ffffffff80b959d3>] start_kernel+0x236/0x2c2
     [<ffffffff80b9511a>] _sinittext+0x11a/0x121

    and
     [ffffe2000e600000-ffffe2000e7fffff] PMD ->ffff81001c200000 on node 0
    phys addr is : 0x1c200000

    RHEL 5.1 kernel -53 said:
    PCI-DMA: aperture base @ 1c000000 size 65536 KB

    new kernel said:
    Mapping aperture over 65536 KB of RAM @ 3c000000

    So could try to disable that GART if possible.


