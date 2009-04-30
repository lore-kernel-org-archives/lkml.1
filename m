Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbZD3U7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbZD3U7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 16:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZD3U7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 16:59:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50132 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZD3U7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 16:59:23 -0400
Date: Thu, 30 Apr 2009 21:59:19 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] 2.6.30-rc3: BUG triggered on some hugepage usages
Message-ID: <20090430205919.GA24279@csn.ul.ie>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090424095116.GB14283@csn.ul.ie> <1240586690.12551.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1240586690.12551.31.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 01:24:50AM +1000, Michael Ellerman wrote:
> On Fri, 2009-04-24 at 10:51 +0100, Mel Gorman wrote:
> > On Tue, Apr 21, 2009 at 08:27:57PM -0700, Linus Torvalds wrote:
> > > Another week, another -rc.
> > > 
> > 
> > I'm seeing some tests with sysbench+postgres+large pages fail on ppc64
> > although a very clear pattern is not forming as to what exactly is
> > causing it. However, the libhugetlbfs regression tests (make && make
> > func) are triggering the following oops when calling mlock() and so are
> > likely related.
> > 
> > ------------[ cut here ]------------
> > kernel BUG at arch/powerpc/mm/pgtable.c:243!
> > Oops: Exception in kernel mode, sig: 5 [#1]
> > SMP NR_CPUS=128 NUMA pSeries
> > Modules linked in: dm_snapshot dm_mirror dm_region_hash dm_log qla2xxx
> > loop nfnetlink iptable_filter iptable_nat nf_nat ip_tables
> > nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
> > xt_tcpudp xt_limit ipt_LOG xt_pkttype x_tables
> > NIP: c00000000002becc LR: c00000000002c02c CTR: 0000000000000000
> > REGS: c0000000ea92b4c0 TRAP: 0700   Not tainted  (2.6.30-rc3-autokern1)
> > MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28000484  XER: 20000020
> > TASK = c00000000395b660[7611] 'mlock' THREAD: c0000000ea928000 CPU: 3
> > GPR00: 0000000000000001 c0000000ea92b740 c0000000008ea170 c0000000ec7d4980 
> > GPR04: 000000003f000000 c0000001e2278cf8 0000001900000393 0000000000000001 
> > GPR08: f000000002bc0000 0000000000000000 0000000000000113 c0000001e2278c81 
> > GPR12: 0000000044000482 c00000000093b880 0000000028004422 0000000000000000 
> > GPR16: c0000000ea92bbf0 c0000000009f06f0 0000001900000113 c0000000ec7d4980 
> > GPR20: 0000000000000000 f000000002bc0000 000000003f000000 c0000001e2278cf8 
> > GPR24: c0000000eaa90bb0 0000000000000000 c0000000eaa90bb0 c0000000ea928000 
> > GPR28: f000000002bc0000 0000001900000393 0000000000000001 c0000001e2278cf8 
> > NIP [c00000000002becc] .assert_pte_locked+0x54/0x8c
> > LR [c00000000002c02c] .ptep_set_access_flags+0x50/0x8c
> > Call Trace:
> > [c0000000ea92b740] [c0000000eaa90bb0] 0xc0000000eaa90bb0 (unreliable)
> > [c0000000ea92b7d0] [c0000000000ed1b0] .hugetlb_cow+0xd4/0x654
> > [c0000000ea92b900] [c0000000000edbf0] .hugetlb_fault+0x4c0/0x708
> > [c0000000ea92b9f0] [c0000000000ee890] .follow_hugetlb_page+0x174/0x364
> > [c0000000ea92bae0] [c0000000000d8d30] .__get_user_pages+0x288/0x4c0
> > [c0000000ea92bbb0] [c0000000000da10c] .make_pages_present+0xa0/0xe0
> > [c0000000ea92bc40] [c0000000000db758] .mlock_fixup+0x90/0x228
> > [c0000000ea92bd00] [c0000000000dbb38] .do_mlock+0xc4/0x128
> > [c0000000ea92bda0] [c0000000000dbccc] .SyS_mlock+0xb0/0xec
> > [c0000000ea92be30] [c00000000000852c] syscall_exit+0x0/0x40
> > Instruction dump:
> > 0b000000 78892662 79291f24 7d69582a 7d600074 7800d182 0b000000 78895e62 
> > 79291f24 7d29582a 7d200074 7800d182 <0b000000> 3c004000 3960ffff
> > 780007c6 
> > ---[ end trace 36a7faa04fa9452b ]---
> > 
> > This corresponds to
> > 
> > #ifdef CONFIG_DEBUG_VM
> > void assert_pte_locked(struct mm_struct *mm, unsigned long addr)
> > {
> >         pgd_t *pgd;
> >         pud_t *pud;
> >         pmd_t *pmd;
> > 
> >         if (mm == &init_mm)
> >                 return;
> >         pgd = mm->pgd + pgd_index(addr);
> >         BUG_ON(pgd_none(*pgd));
> >         pud = pud_offset(pgd, addr);
> >         BUG_ON(pud_none(*pud));
> >         pmd = pmd_offset(pud, addr);
> >         BUG_ON(!pmd_present(*pmd));			<----- THIS LINE
> >         BUG_ON(!spin_is_locked(pte_lockptr(mm, pmd)));
> > }
> > #endif /* CONFIG_DEBUG_VM */
> > 
> > This area was last changed by commit 8d30c14cab30d405a05f2aaceda1e9ad57800f36
> > in the 2.6.30-rc1 timeframe. I think there was another hugepage-related
> > problem with this patch but I can't remember what it was.
> 
> It broke modules, but I don't remember anything hugepage related.
> 
> So the code changed from:
> 
> -#define  ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
> -({                                                                        \
> -       int __changed = !pte_same(*(__ptep), __entry);                     \
> -       if (__changed) {                                                   \
> -               __ptep_set_access_flags(__ptep, __entry, __dirty);         \
> -               flush_tlb_page_nohash(__vma, __address);                   \
> -       }                                                                  \
> -       __changed;                                                         \
> -})
> 
> to:
> 
> +int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
> +                         pte_t *ptep, pte_t entry, int dirty)
> +{
> +       int changed;
> +       if (!dirty && pte_need_exec_flush(entry, 0))
> +               entry = do_dcache_icache_coherency(entry);
> +       changed = !pte_same(*(ptep), entry);
> +       if (changed) {
> +               assert_pte_locked(vma->vm_mm, address);
> +               __ptep_set_access_flags(ptep, entry);
> +               flush_tlb_page_nohash(vma, address);
> +       }
> +       return changed;
> +}
> 
> So the call to assert_pte_locked() is new. And it's never going to work
> for huge pages, the page table structure is different right?

Right

> Notice
> pte_update() checks (arch/powerpc/include/asm/pgtable-ppc64.h):
> 
> 198         /* huge pages use the old page table lock */
> 199         if (!huge)
> 200                 assert_pte_locked(mm, addr);
> 
> But unlike pte_update() ptep_set_access_flags() has no way of knowing
> it's been called from huge_ptep_set_access_flags().
> 

It does because it has the VMA. This patch fixes the problem for me. If it
looks ok, I'll resend to Paul Mackerras for the powerpc tree.

As Ben says, it doesn't explain the functional difficulties I had in
sysbench+postgres so I'll reinvestigate that.

==== CUT HERE ====

powerpc: Do not assert pte_locked for hugepage PTE entries

With CONFIG_DEBUG_VM, an assertion is made when changing the protection
flags of a PTE that the PTE is locked. Huge pages use a different pagetable
format and the assertion is bogus and will always trigger with a bug looking
something like

 Unable to handle kernel paging request for data at address 0xf1a00235800006f8
 Faulting instruction address: 0xc000000000034a80
 Oops: Kernel access of bad area, sig: 11 [#1]
 SMP NR_CPUS=32 NUMA Maple
 Modules linked in: dm_snapshot dm_mirror dm_region_hash
  dm_log dm_mod loop evdev ext3 jbd mbcache sg sd_mod ide_pci_generic
  pata_amd ata_generic ipr libata tg3 libphy scsi_mod windfarm_pid
  windfarm_smu_sat windfarm_max6690_sensor windfarm_lm75_sensor
  windfarm_cpufreq_clamp windfarm_core i2c_powermac
 NIP: c000000000034a80 LR: c000000000034b18 CTR: 0000000000000003
 REGS: c000000003037600 TRAP: 0300   Not tainted (2.6.30-rc3-autokern1)
 MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 28002484  XER: 200fffff
 DAR: f1a00235800006f8, DSISR: 0000000040010000
 TASK = c0000002e54cc740[2960] 'map_high_trunca' THREAD: c000000003034000 CPU: 2
 GPR00: 4000000000000000 c000000003037880 c000000000895d30 c0000002e5a2e500
 GPR04: 00000000a0000000 c0000002edc40880 0000005700000393 0000000000000001
 GPR08: f000000011ac0000 01a00235800006e8 00000000000000f5 f1a00235800006e8
 GPR12: 0000000028000484 c0000000008dd780 0000000000001000 0000000000000000
 GPR16: fffffffffffff000 0000000000000000 00000000a0000000 c000000003037a20
 GPR20: c0000002e5f4ece8 0000000000001000 c0000002edc40880 0000000000000000
 GPR24: c0000002e5f4ece8 0000000000000000 00000000a0000000 c0000002e5f4ece8
 GPR28: 0000005700000393 c0000002e5a2e500 00000000a0000000 c000000003037880
 NIP [c000000000034a80] .assert_pte_locked+0xa4/0xd0
 LR [c000000000034b18] .ptep_set_access_flags+0x6c/0xb4
 Call Trace:
 [c000000003037880] [c000000003037990] 0xc000000003037990 (unreliable)
 [c000000003037910] [c000000000034b18] .ptep_set_access_flags+0x6c/0xb4
 [c0000000030379b0] [c00000000014bef8] .hugetlb_cow+0x124/0x674
 [c000000003037b00] [c00000000014c930] .hugetlb_fault+0x4e8/0x6f8
 [c000000003037c00] [c00000000013443c] .handle_mm_fault+0xac/0x828
 [c000000003037cf0] [c0000000000340a8] .do_page_fault+0x39c/0x584
 [c000000003037e30] [c0000000000057b0] handle_page_fault+0x20/0x5c
 Instruction dump:
 7d29582a 7d200074 7800d182 0b000000 3c004000 3960ffff 780007c6 796b00c4
 7d290214 7929a302 1d290068 7d6b4a14 <800b0010> 7c000074 7800d182 0b000000

This patch fixes the problem by not asseting the PTE is locked for VMAs
backed by huge pages.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 arch/powerpc/mm/pgtable.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index f5c6fd4..ae1d67c 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -219,7 +219,8 @@ int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 		entry = do_dcache_icache_coherency(entry);
 	changed = !pte_same(*(ptep), entry);
 	if (changed) {
-		assert_pte_locked(vma->vm_mm, address);
+		if (!(vma->vm_flags & VM_HUGETLB))
+			assert_pte_locked(vma->vm_mm, address);
 		__ptep_set_access_flags(ptep, entry);
 		flush_tlb_page_nohash(vma, address);
 	}
