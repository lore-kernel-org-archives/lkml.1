Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZERRNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZERRNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZERRN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:13:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56419 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZERRNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:13:24 -0400
Date: Mon, 18 May 2009 18:13:23 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebmunson@us.ibm.com
Subject: Re: [BUG] 2.6.30-rc3: BUG triggered on some hugepage usages
Message-ID: <20090518171322.GB13093@csn.ul.ie>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090424095116.GB14283@csn.ul.ie> <1240586690.12551.31.camel@localhost> <20090430205919.GA24279@csn.ul.ie> <1241128126.29501.48.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1241128126.29501.48.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 07:48:46AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2009-04-30 at 21:59 +0100, Mel Gorman wrote:
> 
> > This patch fixes the problem by not asseting the PTE is locked for VMAs
> > backed by huge pages.
> 
> Thanks, will apply.
> 

What's the story with this patch? I'm still hearing of failures with huge pages
that this patch fixes but I'm no seeing it upstream. Was the patch
rejected or did it just slip through the cracks?

To refresh, an assertion is being made on ppc64 that only makes sense for
base pages. Hugepages through a wobbly every time. For convenience, here is
the patch again.

Thanks.

==== CUT HERE ====
powerpc: Do not assert pte_locked for hugepage PTE entries

With DEBUG_VM enabled, an assertion is made when changing the protection
flags of a PTE that the PTE is locked. Huge pages use a different
pagetable format and the assertion is bogus and will always trigger with
a bug looking something like

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
