Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZBVPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZBVPZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 10:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZBVPZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 10:25:34 -0500
Received: from imta-38.everyone.net ([216.200.145.38]:49196 "EHLO
	omta0105.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753116AbZBVPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 10:25:33 -0500
X-Eon-Dm: dm0205
X-Eon-Sig: AQHOS7NJoW5rbAkywQIAAAAD,2a5d6b9016d547befe776c4ef9f509d5
Date: Sun, 22 Feb 2009 10:25:31 -0500
From: "Kevin O'Connor" <kevin@koconnor.net>
To: Stefan Reinauer <stepan@coresystems.de>
Cc: linux-kernel@vger.kernel.org, coreboot@coreboot.org
Subject: MPTable can not be high-memory on Linux
Message-ID: <20090222152530.GA30576@morn.localdomain>
References: <499DB40C.1060205@coresystems.de> <499DB480.1000909@coresystems.de> <499DB6D8.5040706@coresystems.de> <499DBDA0.2010606@coresystems.de> <499DCE79.8020809@coresystems.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499DCE79.8020809@coresystems.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

I'm CC'ing lkml and coreboot mailing lists.

On Thu, Feb 19, 2009 at 10:26:17PM +0100, Stefan Reinauer wrote:
> OK, I played some more, and I finally found out it's earlyprintk and not
> early_printk. Plus there is bootmem_debug:
> 
> Initializing cgroup subsys cpuset
> Initializing cgroup subsys cpu
> Linux version 2.6.27.7-9-default (geeko@buildhost) (gcc version 4.3.2
> [gcc-4_3-branch re0
> PAT WC disabled due to known CPU erratum.
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 0000000000001000 (reserved)
>  BIOS-e820: 0000000000001000 - 0000000000090000 (usable)
>  BIOS-e820: 0000000000090000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003f7f0000 (usable)
>  BIOS-e820: 000000003f7f0000 - 0000000040000000 (reserved)
>  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[...]
> ACPI: no DMI BIOS year, acpi=force is required to enable ACPI
> ACPI: Disabling ACPI support
[...]
> found SMP MP-table at [c00f9fc0] 000f9fc0
> bootmem::mark_bootmem_node nid=0 start=f9 end=fb reserve=1 flags=0
> bootmem::__reserve nid=0 start=f9 end=fb flags=0
> bootmem::__reserve silent double reserve of PFN f9
> bootmem::__reserve silent double reserve of PFN fa
> BUG: Int 6: CR2 00000000
>      EDI c00f9fd0  ESI 3f7f5410  EBP 0003f7f5  ESP c0535f20
>      EBX c056c00c  EDX 00000006  ECX 00000001  EAX c056c03c
>      err 00000000  EIP c054f8f0   CS 00000060  flg 00010046
> Stack: 00000000 00000000 00000001 00038000 0003f7f5 f880abf0 3f7f5410
> c00f9fd0
>        00000001 c054f91d 00000000 c054571a c0413e7e c00f9fc0 000f9fc0
> 00000001
>        3f7bf64d 00000000 3e2c5000 c054578a 00000000 c053f3b6 3f7bf64d
> 00000000
> 
> So it dies because of the way it tries to reserve the MP-table.
> 
> Here's the stack trace.
> 
>  [<c054f8f0>] mark_bootmem+0x9b/0xab
>  [<c054f91d>] reserve_bootmem+0x1d/0x1f
>  [<c054571a>] smp_scan_config+0xd9/0xfa
>  [<c054578a>] __find_smp_config+0x4f/0x6e
>  [<c053f3b6>] setup_arch+0x576/0x639
>  [<c054ebc4>] cgroup_init_subsys+0x29/0xc9
>  [<c053a6ac>] start_kernel+0x6b/0x31f
>  =======================

It looks like the problem is that the MPTable is located in the last
64K of memory (instead of the first few megabytes).  There is a
comment about this in arch/x86/kernel/mpparse.c:

   /*
    * We cannot access to MPC table to compute
    * table size yet, as only few megabytes from
    * the bottom is mapped now.
    * PC-9800's MPC table places on the very last
    * of physical memory; so that simply reserving
    * PAGE_SIZE from mpg->mpf_physptr yields BUG()
    * in reserve_bootmem.
    */

However, that comment is in an #ifdef specific to 32bit kernels.
(Though, it's not clear to me how that code would help as it sets size
to be a negative number.)

The easiest way to fix this is to change SeaBIOS to copy the whole
mptable to the first megabyte.  Also, we need to fix your SMBIOS so
that ACPI is used instead of the mptable.

-Kevin
