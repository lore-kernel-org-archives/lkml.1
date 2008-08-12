Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYHLOK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYHLOK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYHLOKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:10:21 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:53558 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYHLOKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:10:20 -0400
Date: Tue, 12 Aug 2008 15:10:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
In-Reply-To: <20080811211802.8fed7a4b.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0808121439270.18912@blonde.site>
References: <20080811211802.8fed7a4b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008, Randy Dunlap wrote:
> on x86_64, SMP, 8 GB RAM:
> 
> BUG: unable to handle kernel paging request at ffffe20001d5ae00
> IP: [<ffffffff8027c08f>] unmap_vmas+0x42d/0x7a0
> PGD 28102067 PUD 28103067 PMD 0
> Oops: 0000 [1] SMP
> CPU 3
> Modules linked in: lpfc(+) cciss ehci_hcd ohci_hcd uhci_hcd
> Pid: 1382, comm: udevd Not tainted 2.6.27-rc2-git5 #1
> RIP: 0010:[<ffffffff8027c08f>]  [<ffffffff8027c08f>] unmap_vmas+0x42d/0x7a0
> RSP: 0018:ffff88027dcffd68  EFLAGS: 00010246
> RAX: 000000008631b98b RBX: ffffe20001d5ade8 RCX: ffff880183a27500
> RDX: 0000000001d5ad00 RSI: 000000008631b98b RDI: ffff88027e549840
> RBP: ffff88027dcffe38 R08: 000000017efc3402 R09: 000000ffffffffff
> R10: ffff88017e84c9d8 R11: 0000000000000006 R12: 0000000000000020
> R13: 00007fbedb007000 R14: ffff88027dd81038 R15: 00007fbedb10a000
> FS:  00007fbedb777710(0000) GS:ffff88027f623c80(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffffe20001d5ae00 CR3: 000000027e12c000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process udevd (pid: 1382, threadinfo ffff88027dcfe000, task ffff88027d959bc0)
> Stack:  0000000000000000 0000000000000000 ffff88027dcffe50 ffffffffffffffff
>  0000000000000000 ffff88027e549840 ffff88027dcffe58 00000000003bc9f2
>  0000000000000000 0000000108b985a8 00007fbedb10a000 ffff88027e12c7f8
> Call Trace:
>  [<ffffffff8027ff11>] exit_mmap+0x75/0xed
>  [<ffffffff80232f3a>] mmput+0x42/0x98
>  [<ffffffff802369ff>] exit_mm+0xfd/0x108
>  [<ffffffff80237fce>] do_exit+0x272/0x84d
>  [<ffffffff8023861b>] do_group_exit+0x72/0xa2
>  [<ffffffff8023865d>] sys_exit_group+0x12/0x14
>  [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b

No "Code:" line?  Never mind, much more useful would be the
"objdump -d vmlinux" extract for unmap_vmas() - please send me or
the list that output if you still have or can reconstruct vmlinux.

I'm pretty sure it's oopsing on line 755 of mm/memory.c, the PageAnon
test in zap_pte_range(); but would like to confirm that and see if
there's any more info to be gleaned from the registers above.

It looks like a case of page table corruption.  RAX and RSI appear to
be holding pte 0x8631b98b, which has several bits wrong for a good pte;
its pfn 0x8631b matches up with struct page pointer in RBX, and the
faulting address to access page->mapping.

The BIOS-e820 map from the start of dmesg would be useful confirmatory
information too: that pfn isn't unreasonable itself, but you're using
CONFIG_SPARSEMEM_VMEMMAP, so I presume it falls in one of the holes.

Have you been seeing other weirdness on this machine?  It'd be great
if you could try to reproduce this corruption or something like it,
but not a lot we can tell from one instance.  I wonder if it relates
at all to [Bug 11237] corrupt PMD after resume - probably not but
maybe - did you do a suspend/resume before getting this?

Thanks,
Hugh
