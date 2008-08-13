Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYHMXvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYHMXvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYHMXvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:51:31 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:37291 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYHMXva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:51:30 -0400
Date: Thu, 14 Aug 2008 00:51:02 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
In-Reply-To: <20080812085334.fa1b8f0f.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0808140028090.24365@blonde.site>
References: <20080811211802.8fed7a4b.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0808121439270.18912@blonde.site> <20080812085334.fa1b8f0f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008, Randy Dunlap wrote:
> On Tue, 12 Aug 2008 15:10:09 +0100 (BST) Hugh Dickins wrote:
> > On Mon, 11 Aug 2008, Randy Dunlap wrote:
> > > on x86_64, SMP, 8 GB RAM:
> > > 
> > > BUG: unable to handle kernel paging request at ffffe20001d5ae00
> > > IP: [<ffffffff8027c08f>] unmap_vmas+0x42d/0x7a0
> > > PGD 28102067 PUD 28103067 PMD 0
> > > Oops: 0000 [1] SMP
> > > CPU 3
> > > Modules linked in: lpfc(+) cciss ehci_hcd ohci_hcd uhci_hcd
> > > Pid: 1382, comm: udevd Not tainted 2.6.27-rc2-git5 #1
> > > RIP: 0010:[<ffffffff8027c08f>]  [<ffffffff8027c08f>] unmap_vmas+0x42d/0x7a0
> > > RSP: 0018:ffff88027dcffd68  EFLAGS: 00010246
> > > RAX: 000000008631b98b RBX: ffffe20001d5ade8 RCX: ffff880183a27500
> > > RDX: 0000000001d5ad00 RSI: 000000008631b98b RDI: ffff88027e549840
> > > RBP: ffff88027dcffe38 R08: 000000017efc3402 R09: 000000ffffffffff
> > > R10: ffff88017e84c9d8 R11: 0000000000000006 R12: 0000000000000020
> > > R13: 00007fbedb007000 R14: ffff88027dd81038 R15: 00007fbedb10a000
...
> > I'm pretty sure it's oopsing on line 755 of mm/memory.c, the PageAnon
> > test in zap_pte_range(); but would like to confirm that and see if
> > there's any more info to be gleaned from the registers above.
> > 
> > It looks like a case of page table corruption.  RAX and RSI appear to
> > be holding pte 0x8631b98b, which has several bits wrong for a good pte;
> > its pfn 0x8631b matches up with struct page pointer in RBX, and the
> > faulting address to access page->mapping.
> > 
> > The BIOS-e820 map from the start of dmesg would be useful confirmatory
> > information too: that pfn isn't unreasonable itself, but you're using
> > CONFIG_SPARSEMEM_VMEMMAP, so I presume it falls in one of the holes.

Thanks a lot for all the additional info you supplied, Randy.
The unmap_vmas disassembly (sent privately), and the BIOS-e820 map,
confirmed what I thought above.  The disassembly was also useful for
identifying R14 as the pointer to the (7th entry in the) page table.

The full log was interesting for the 5 "swap_free: bad swap file entry"
messages which preceded the oops, I'd guess they were corruption of the
very same page table, just one entry (perhaps a 0) looking good enough
not to cause any trouble.  And for the similar oops on another process
just after, and then the general protection faults in kmem_cache_alloc.

However... interesting though the corruptions are, I'm no further to
guessing the cause.  If these numbers (yes, they're not the numbers
seen in the log: that's because pte_to_swp_entry/swp_entry_to_pte
involve munging things around) inspire anyone to an identification,
that would be wonderful, but I doubt it.  The pair at the end are
the RSIs in the GPFs, which Code: confirms would have caused them.

b98b is popular.

ffffffffffff0000 06087480ed020800
0100040600080100 b98b7480ed020800
0000000000000530 000000008631b98b

ffffffffffff0000 060868134e0b1e00
0100040600080100 b98b68134e0b1e00
0000000000009e32 00000000d230b98b

b98bc31c00313000
b98bc31c00313000

Hugh
