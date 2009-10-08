Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbZJHPgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbZJHPgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758354AbZJHPgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:36:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:37185 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbZJHPgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:36:03 -0400
Subject: [RFC][PATCH] kmap_atomic_push
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>
Cc: David Howells <dhowells@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 17:35:23 +0200
Message-Id: <1255016123.17055.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patchlet changes the kmap_atomic interface to a stack based
one that doesn't require the KM_types anymore.

This significantly simplifies some code (more still than are present in
this patch -- ie. pte_map_nested can go now)

This obviously requires that push and pop are matched, I fixed a few
cases that were not properly nested, the (x86) code checks for this and
will go BUG when trying to pop a vaddr that isn't the top one so abusers
should be rather visible.

build-tested on i386-defconfig

What do people think?

David, frv has a 'funny' issue in that it treats __KM_CACHE special from
the other ones, something which isn't possibly anymore. Do you see
another option than to add kmap_atomic_push_cache() for frv?

Almost-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/block/biodoc.txt            |    4 -
 Documentation/frv/mmu-layout.txt          |   36 +++++------
 Documentation/io-mapping.txt              |    4 -
 arch/arm/include/asm/highmem.h            |    6 -
 arch/arm/include/asm/pgtable.h            |   12 +--
 arch/arm/mm/copypage-fa.c                 |   12 +--
 arch/arm/mm/copypage-feroceon.c           |   12 +--
 arch/arm/mm/copypage-v3.c                 |   12 +--
 arch/arm/mm/copypage-v4mc.c               |    8 +-
 arch/arm/mm/copypage-v4wb.c               |   12 +--
 arch/arm/mm/copypage-v4wt.c               |   12 +--
 arch/arm/mm/copypage-v6.c                 |   12 +--
 arch/arm/mm/copypage-xsc3.c               |   12 +--
 arch/arm/mm/copypage-xscale.c             |    8 +-
 arch/arm/mm/flush.c                       |    4 -
 arch/arm/mm/highmem.c                     |   20 +++---
 arch/frv/include/asm/highmem.h            |   63 ++++++++++----------
 arch/frv/include/asm/pgtable.h            |    8 +-
 arch/frv/kernel/head-mmu-fr451.S          |    2
 arch/frv/mb93090-mb00/pci-dma.c           |    4 -
 arch/frv/mm/cache-page.c                  |   10 +--
 arch/ia64/kernel/crash_dump.c             |    2
 arch/microblaze/include/asm/pgtable.h     |    8 +-
 arch/mips/include/asm/highmem.h           |   10 +--
 arch/mips/mm/c-r4k.c                      |    6 -
 arch/mips/mm/highmem.c                    |   22 +++----
 arch/mips/mm/init.c                       |    8 +-
 arch/mn10300/include/asm/highmem.h        |   13 +---
 arch/parisc/include/asm/cacheflush.h      |    6 -
 arch/powerpc/include/asm/highmem.h        |    9 +-
 arch/powerpc/include/asm/pgtable-ppc32.h  |    8 +-
 arch/powerpc/include/asm/pgtable.h        |    2
 arch/powerpc/kernel/crash_dump.c          |    2
 arch/powerpc/mm/dma-noncoherent.c         |    8 +-
 arch/powerpc/mm/highmem.c                 |   17 ++---
 arch/powerpc/mm/mem.c                     |    4 -
 arch/powerpc/sysdev/ppc4xx_pci.c          |    2
 arch/sh/kernel/crash_dump.c               |    2
 arch/sh/mm/cache.c                        |   12 +--
 arch/sparc/include/asm/highmem.h          |    4 -
 arch/sparc/mm/highmem.c                   |   21 +++---
 arch/sparc/mm/io-unit.c                   |    2
 arch/sparc/mm/iommu.c                     |    2
 arch/um/kernel/skas/uaccess.c             |    4 -
 arch/x86/include/asm/highmem.h            |   12 +--
 arch/x86/include/asm/iomap.h              |   15 +---
 arch/x86/include/asm/paravirt.h           |    4 -
 arch/x86/include/asm/paravirt_types.h     |    2
 arch/x86/include/asm/pgtable_32.h         |   12 +--
 arch/x86/kernel/cpu/perf_event.c          |    5 -
 arch/x86/kernel/crash_dump_32.c           |   10 +--
 arch/x86/kernel/crash_dump_64.c           |    2
 arch/x86/kernel/paravirt.c                |    2
 arch/x86/kernel/vmi_32.c                  |    6 -
 arch/x86/kvm/lapic.c                      |    8 +-
 arch/x86/kvm/paging_tmpl.h                |    4 -
 arch/x86/kvm/svm.c                        |   28 ++++----
 arch/x86/kvm/x86.c                        |    8 +-
 arch/x86/lib/usercopy_32.c                |    4 -
 arch/x86/mm/highmem_32.c                  |   45 +++++++++-----
 arch/x86/mm/iomap_32.c                    |   58 ++++--------------
 arch/x86/xen/mmu.c                        |    6 -
 block/blk-settings.c                      |    2
 crypto/ahash.c                            |    4 -
 crypto/async_tx/async_memcpy.c            |    8 +-
 crypto/blkcipher.c                        |   10 +--
 crypto/ccm.c                              |    4 -
 crypto/digest.c                           |    4 -
 crypto/scatterwalk.c                      |    8 +-
 crypto/shash.c                            |    8 +-
 drivers/ata/libata-sff.c                  |    8 +-
 drivers/block/brd.c                       |   20 +++---
 drivers/block/loop.c                      |   16 ++---
 drivers/block/pktcdvd.c                   |    8 +-
 drivers/crypto/hifn_795x.c                |   10 +--
 drivers/edac/edac_mc.c                    |    4 -
 drivers/gpu/drm/drm_cache.c               |    8 +-
 drivers/gpu/drm/i915/i915_gem.c           |   44 +++++++-------
 drivers/gpu/drm/i915/i915_gem_debug.c     |   10 +--
 drivers/gpu/drm/ttm/ttm_bo_util.c         |    8 +-
 drivers/gpu/drm/ttm/ttm_tt.c              |   16 ++---
 drivers/ide/ide-taskfile.c                |    4 -
 drivers/infiniband/ulp/iser/iser_memory.c |    8 +-
 drivers/md/bitmap.c                       |   36 +++++------
 drivers/media/video/ivtv/ivtv-udma.c      |    4 -
 drivers/memstick/host/jmb38x_ms.c         |    4 -
 drivers/memstick/host/tifm_ms.c           |    4 -
 drivers/mmc/host/at91_mci.c               |    8 +-
 drivers/mmc/host/mmci.c                   |    4 -
 drivers/mmc/host/mmci.h                   |    8 +-
 drivers/mmc/host/msm_sdcc.c               |    6 -
 drivers/mmc/host/sdhci.c                  |   16 ++---
 drivers/mmc/host/tifm_sd.c                |   16 ++---
 drivers/mmc/host/tmio_mmc.c               |    4 -
 drivers/mmc/host/tmio_mmc.h               |    8 +-
 drivers/net/cassini.c                     |    4 -
 drivers/net/e1000/e1000_main.c            |    6 -
 drivers/net/e1000e/netdev.c               |   12 +--
 drivers/scsi/arcmsr/arcmsr_hba.c          |    8 +-
 drivers/scsi/cxgb3i/cxgb3i_pdu.c          |    5 -
 drivers/scsi/dc395x.c                     |   12 +--
 drivers/scsi/fcoe/fcoe.c                  |    9 +-
 drivers/scsi/gdth.c                       |    6 -
 drivers/scsi/ips.c                        |    8 +-
 drivers/scsi/libfc/fc_fcp.c               |   12 +--
 drivers/scsi/libiscsi_tcp.c               |    4 -
 drivers/scsi/libsas/sas_host_smp.c        |    8 +-
 drivers/scsi/megaraid.c                   |    4 -
 drivers/scsi/mvsas/mv_sas.c               |    8 +-
 drivers/scsi/scsi_debug.c                 |   24 +++----
 drivers/scsi/scsi_lib.c                   |   16 ++---
 drivers/scsi/sd_dif.c                     |   12 +--
 drivers/scsi/tmscsim.c                    |    4 -
 drivers/staging/hv/RndisFilter.c          |    9 +-
 drivers/staging/hv/netvsc_drv.c           |    9 +-
 drivers/staging/hv/storvsc_drv.c          |   29 ++++-----
 drivers/staging/pohmelfs/inode.c          |    8 +-
 fs/afs/fsclient.c                         |    8 +-
 fs/afs/mntpt.c                            |    4 -
 fs/aio.c                                  |   36 +++++------
 fs/bio-integrity.c                        |   10 +--
 fs/btrfs/compression.c                    |    8 +-
 fs/btrfs/ctree.h                          |    8 +-
 fs/btrfs/extent_io.c                      |   60 +++++++++----------
 fs/btrfs/file-item.c                      |   10 +--
 fs/btrfs/inode.c                          |   22 +++----
 fs/btrfs/zlib.c                           |    8 +-
 fs/cifs/file.c                            |    4 -
 fs/ecryptfs/mmap.c                        |    4 -
 fs/ecryptfs/read_write.c                  |    8 +-
 fs/exec.c                                 |    4 -
 fs/exofs/dir.c                            |    4 -
 fs/ext2/dir.c                             |    4 -
 fs/fuse/dev.c                             |   12 +--
 fs/fuse/file.c                            |    4 -
 fs/gfs2/aops.c                            |   12 +--
 fs/gfs2/lops.c                            |    8 +-
 fs/gfs2/quota.c                           |    4 -
 fs/jbd/journal.c                          |   12 +--
 fs/jbd/transaction.c                      |    4 -
 fs/jbd2/commit.c                          |    4 -
 fs/jbd2/journal.c                         |   12 +--
 fs/jbd2/transaction.c                     |    4 -
 fs/libfs.c                                |    4 -
 fs/minix/dir.c                            |    4 -
 fs/namei.c                                |    4 -
 fs/nfs/dir.c                              |    4 -
 fs/nfs/nfs2xdr.c                          |    8 +-
 fs/nfs/nfs3xdr.c                          |    8 +-
 fs/nfs/nfs4proc.c                         |    4 -
 fs/nfs/nfs4xdr.c                          |   10 +--
 fs/nilfs2/cpfile.c                        |   94 +++++++++++++++---------------
 fs/nilfs2/dat.c                           |   38 ++++++------
 fs/nilfs2/dir.c                           |    4 -
 fs/nilfs2/ifile.c                         |    4 -
 fs/nilfs2/mdt.c                           |    4 -
 fs/nilfs2/page.c                          |    8 +-
 fs/nilfs2/recovery.c                      |    4 -
 fs/nilfs2/segbuf.c                        |    4 -
 fs/nilfs2/segment.c                       |    4 -
 fs/nilfs2/sufile.c                        |   50 +++++++--------
 fs/ntfs/ChangeLog                         |    4 -
 fs/ntfs/aops.c                            |   20 +++---
 fs/ntfs/attrib.c                          |   20 +++---
 fs/ntfs/file.c                            |   16 ++---
 fs/ntfs/super.c                           |    8 +-
 fs/ocfs2/aops.c                           |   16 ++---
 fs/pipe.c                                 |    8 +-
 fs/reiserfs/stree.c                       |    4 -
 fs/reiserfs/tail_conversion.c             |    4 -
 fs/splice.c                               |    4 -
 fs/squashfs/file.c                        |    8 +-
 fs/squashfs/symlink.c                     |    6 -
 fs/ubifs/file.c                           |    4 -
 fs/udf/file.c                             |    4 -
 include/crypto/scatterwalk.h              |   35 ++---------
 include/linux/bio.h                       |   10 +--
 include/linux/highmem.h                   |   58 ++++++++++--------
 include/linux/io-mapping.h                |    5 -
 include/linux/scatterlist.h               |    2
 include/scsi/scsi_cmnd.h                  |    4 -
 kernel/power/snapshot.c                   |   30 ++++-----
 lib/scatterlist.c                         |    4 -
 lib/swiotlb.c                             |    5 -
 mm/bounce.c                               |    4 -
 mm/debug-pagealloc.c                      |    2
 mm/filemap.c                              |    8 +-
 mm/highmem.c                              |   48 ---------------
 mm/ksm.c                                  |   12 +--
 mm/memory.c                               |    4 -
 mm/shmem.c                                |   18 ++---
 mm/vmalloc.c                              |    8 +-
 net/core/kmap_skb.h                       |    4 -
 net/rds/ib_recv.c                         |   12 +--
 net/rds/info.c                            |    6 -
 net/rds/iw_recv.c                         |    4 -
 net/rds/page.c                            |    4 -
 net/sunrpc/auth_gss/gss_krb5_wrap.c       |    4 -
 net/sunrpc/socklib.c                      |    4 -
 net/sunrpc/xdr.c                          |   16 ++---
 net/sunrpc/xprtrdma/rpc_rdma.c            |   10 +--
 201 files changed, 1055 insertions(+), 1155 deletions(-)

Index: linux-2.6/Documentation/block/biodoc.txt
===================================================================
--- linux-2.6.orig/Documentation/block/biodoc.txt
+++ linux-2.6/Documentation/block/biodoc.txt
@@ -217,7 +217,7 @@ may need to abort DMA operations and rev
 which case a virtual mapping of the page is required. For SCSI it is also
 done in some scenarios where the low level driver cannot be trusted to
 handle a single sg entry correctly. The driver is expected to perform the
-kmaps as needed on such occasions using the __bio_kmap_atomic and bio_kmap_irq
+kmaps as needed on such occasions using the __bio_kmap_atomic_push and bio_kmap_irq
 routines as appropriate. A driver could also use the blk_queue_bounce()
 routine on its own to bounce highmem i/o to low memory for specific requests
 if so desired.
@@ -1167,7 +1167,7 @@ use blk_rq_map_sg for scatter gather) to
 PIO drivers (or drivers that need to revert to PIO transfer once in a
 while (IDE for example)), where the CPU is doing the actual data
 transfer a virtual mapping is needed. If the driver supports highmem I/O,
-(Sec 1.1, (ii) ) it needs to use __bio_kmap_atomic and bio_kmap_irq to
+(Sec 1.1, (ii) ) it needs to use __bio_kmap_atomic_push and bio_kmap_irq to
 temporarily map a bio into the virtual address space.
 
 
Index: linux-2.6/Documentation/frv/mmu-layout.txt
===================================================================
--- linux-2.6.orig/Documentation/frv/mmu-layout.txt
+++ linux-2.6/Documentation/frv/mmu-layout.txt
@@ -29,7 +29,7 @@ Certain control registers are used by th
 	DAMR3			Current PGD mapping
 	SCR0, DAMR4		Instruction TLB PGE/PTD cache
 	SCR1, DAMR5		Data TLB PGE/PTD cache
-	DAMR6-10		kmap_atomic() mappings
+	DAMR6-10		kmap_atomic_push() mappings
 	DAMR11			I/O mapping
 	CXNR			mm_struct context ID
 	TTBR			Page directory (PGD) pointer (physical address)
@@ -64,17 +64,17 @@ The virtual memory layout is:
   C0000000-CFFFFFFF  00000000	xAMPR0		-L-S--V	256MB	Kernel image and data
   D0000000-D7FFFFFF  various	TLB,xAMR1	D-NS??V	128MB	vmalloc area
   D8000000-DBFFFFFF  various	TLB,xAMR1	D-NS??V	64MB	kmap() area
-  DC000000-DCFFFFFF  various	TLB			1MB	Secondary kmap_atomic() frame
-  DD000000-DD27FFFF  various	DAMR			160KB	Primary kmap_atomic() frame
+  DC000000-DCFFFFFF  various	TLB			1MB	Secondary kmap_atomic_push() frame
+  DD000000-DD27FFFF  various	DAMR			160KB	Primary kmap_atomic_push() frame
   DD040000			DAMR2/IAMR2	-L-S--V	page	Page cache flush attachment point
   DD080000			DAMR3		-L-SC-V	page	Page Directory (PGD)
   DD0C0000			DAMR4		-L-SC-V	page	Cached insn TLB Page Table lookup
   DD100000			DAMR5		-L-SC-V	page	Cached data TLB Page Table lookup
-  DD140000			DAMR6		-L-S--V	page	kmap_atomic(KM_BOUNCE_READ)
-  DD180000			DAMR7		-L-S--V	page	kmap_atomic(KM_SKB_SUNRPC_DATA)
-  DD1C0000			DAMR8		-L-S--V	page	kmap_atomic(KM_SKB_DATA_SOFTIRQ)
-  DD200000			DAMR9		-L-S--V	page	kmap_atomic(KM_USER0)
-  DD240000			DAMR10		-L-S--V	page	kmap_atomic(KM_USER1)
+  DD140000			DAMR6		-L-S--V	page	kmap_atomic_push(KM_BOUNCE_READ)
+  DD180000			DAMR7		-L-S--V	page	kmap_atomic_push(KM_SKB_SUNRPC_DATA)
+  DD1C0000			DAMR8		-L-S--V	page	kmap_atomic_push(KM_SKB_DATA_SOFTIRQ)
+  DD200000			DAMR9		-L-S--V	page	kmap_atomic_push(KM_USER0)
+  DD240000			DAMR10		-L-S--V	page	kmap_atomic_push(KM_USER1)
   E0000000-FFFFFFFF  E0000000	DAMR11		-L-SC-V	512MB	I/O region
 
 IAMPR1 and DAMPR1 are used as an extension to the TLB.
@@ -85,27 +85,27 @@ KMAP AND KMAP_ATOMIC
 ====================
 
 To access pages in the page cache (which may not be directly accessible if highmem is available),
-the kernel calls kmap(), does the access and then calls kunmap(); or it calls kmap_atomic(), does
-the access and then calls kunmap_atomic().
+the kernel calls kmap(), does the access and then calls kunmap(); or it calls kmap_atomic_push(), does
+the access and then calls kmap_atomic_pop().
 
 kmap() creates an attachment between an arbitrary inaccessible page and a range of virtual
 addresses by installing a PTE in a special page table. The kernel can then access this page as it
 wills. When it's finished, the kernel calls kunmap() to clear the PTE.
 
-kmap_atomic() does something slightly different. In the interests of speed, it chooses one of two
+kmap_atomic_push() does something slightly different. In the interests of speed, it chooses one of two
 strategies:
 
- (1) If possible, kmap_atomic() attaches the requested page to one of DAMPR5 through DAMPR10
-     register pairs; and the matching kunmap_atomic() clears the DAMPR. This makes high memory
+ (1) If possible, kmap_atomic_push() attaches the requested page to one of DAMPR5 through DAMPR10
+     register pairs; and the matching kmap_atomic_pop() clears the DAMPR. This makes high memory
      support really fast as there's no need to flush the TLB or modify the page tables. The DAMLR
      registers being used for this are preset during boot and don't change over the lifetime of the
-     process. There's a direct mapping between the first few kmap_atomic() types, DAMR number and
+     process. There's a direct mapping between the first few kmap_atomic_push() types, DAMR number and
      virtual address slot.
 
-     However, there are more kmap_atomic() types defined than there are DAMR registers available,
+     However, there are more kmap_atomic_push() types defined than there are DAMR registers available,
      so we fall back to:
 
- (2) kmap_atomic() uses a slot in the secondary frame (determined by the type parameter), and then
+ (2) kmap_atomic_push() uses a slot in the secondary frame (determined by the type parameter), and then
      locks an entry in the TLB to translate that slot to the specified page. The number of slots is
      obviously limited, and their positions are controlled such that each slot is matched by a
      different line in the TLB. kunmap() ejects the entry from the TLB.
@@ -113,9 +113,9 @@ strategies:
 Note that the first three kmap atomic types are really just declared as placeholders. The DAMPR
 registers involved are actually modified directly.
 
-Also note that kmap() itself may sleep, kmap_atomic() may never sleep and both always succeed;
+Also note that kmap() itself may sleep, kmap_atomic_push() may never sleep and both always succeed;
 furthermore, a driver using kmap() may sleep before calling kunmap(), but may not sleep before
-calling kunmap_atomic() if it had previously called kmap_atomic().
+calling kmap_atomic_pop() if it had previously called kmap_atomic_push().
 
 
 ===============================
Index: linux-2.6/Documentation/io-mapping.txt
===================================================================
--- linux-2.6.orig/Documentation/io-mapping.txt
+++ linux-2.6/Documentation/io-mapping.txt
@@ -72,8 +72,8 @@ map_atomic and map functions add the req
 virtual address returned by ioremap_wc.
 
 On 32-bit processors with HIGHMEM defined, io_mapping_map_atomic_wc uses
-kmap_atomic_pfn to map the specified page in an atomic fashion;
-kmap_atomic_pfn isn't really supposed to be used with device pages, but it
+kmap_atomic_push_pfn to map the specified page in an atomic fashion;
+kmap_atomic_push_pfn isn't really supposed to be used with device pages, but it
 provides an efficient mapping for this usage.
 
 On 32-bit processors without HIGHMEM defined, io_mapping_map_atomic_wc and
Index: linux-2.6/arch/arm/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/highmem.h
+++ linux-2.6/arch/arm/include/asm/highmem.h
@@ -23,9 +23,9 @@ extern void kunmap_high(struct page *pag
 
 extern void *kmap(struct page *page);
 extern void kunmap(struct page *page);
-extern void *kmap_atomic(struct page *page, enum km_type type);
-extern void kunmap_atomic(void *kvaddr, enum km_type type);
-extern void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
+extern void *kmap_atomic_push(struct page *page);
+extern void kmap_atomic_pop(void *kvaddr);
+extern void *kmap_atomic_push_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(const void *ptr);
 
 #endif
Index: linux-2.6/arch/arm/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/pgtable.h
+++ linux-2.6/arch/arm/include/asm/pgtable.h
@@ -263,17 +263,17 @@ extern struct page *empty_zero_page;
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 #define pte_offset_kernel(dir,addr)	(pmd_page_vaddr(*(dir)) + __pte_index(addr))
 
-#define pte_offset_map(dir,addr)	(__pte_map(dir, KM_PTE0) + __pte_index(addr))
-#define pte_offset_map_nested(dir,addr)	(__pte_map(dir, KM_PTE1) + __pte_index(addr))
-#define pte_unmap(pte)			__pte_unmap(pte, KM_PTE0)
-#define pte_unmap_nested(pte)		__pte_unmap(pte, KM_PTE1)
+#define pte_offset_map(dir,addr)	(__pte_map(dir) + __pte_index(addr))
+#define pte_offset_map_nested(dir,addr)	(__pte_map(dir) + __pte_index(addr))
+#define pte_unmap(pte)			__pte_unmap(pte)
+#define pte_unmap_nested(pte)		__pte_unmap(pte)
 
 #ifndef CONFIG_HIGHPTE
 #define __pte_map(dir,km)	pmd_page_vaddr(*(dir))
 #define __pte_unmap(pte,km)	do { } while (0)
 #else
-#define __pte_map(dir,km)	((pte_t *)kmap_atomic(pmd_page(*(dir)), km) + PTRS_PER_PTE)
-#define __pte_unmap(pte,km)	kunmap_atomic((pte - PTRS_PER_PTE), km)
+#define __pte_map(dir,km)	((pte_t *)kmap_atomic_push(pmd_page(*(dir)), km) + PTRS_PER_PTE)
+#define __pte_unmap(pte,km)	kmap_atomic_pop((pte - PTRS_PER_PTE), km)
 #endif
 
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
Index: linux-2.6/arch/arm/mm/copypage-fa.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/copypage-fa.c
+++ linux-2.6/arch/arm/mm/copypage-fa.c
@@ -44,11 +44,11 @@ void fa_copy_user_highpage(struct page *
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic_push(to);
+	kfrom = kmap_atomic_push(from);
 	fa_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kmap_atomic_pop(kfrom);
+	kmap_atomic_pop(kto);
 }
 
 /*
@@ -58,7 +58,7 @@ void fa_copy_user_highpage(struct page *
  */
 void fa_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic_push(page);
 	asm volatile("\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -77,7 +77,7 @@ void fa_clear_user_highpage(struct page 
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 32)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 struct cpu_user_fns fa_user_fns __initdata = {
Index: linux-2.6/arch/arm/mm/copypage-feroceon.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/copypage-feroceon.c
+++ linux-2.6/arch/arm/mm/copypage-feroceon.c
@@ -72,16 +72,16 @@ void feroceon_copy_user_highpage(struct 
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic_push(to);
+	kfrom = kmap_atomic_push(from);
 	feroceon_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kmap_atomic_pop(kfrom);
+	kmap_atomic_pop(kto);
 }
 
 void feroceon_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic_push(page);
 	asm volatile ("\
 	mov	r1, %2				\n\
 	mov	r2, #0				\n\
@@ -101,7 +101,7 @@ void feroceon_clear_user_highpage(struct
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 32)
 	: "r1", "r2", "r3", "r4", "r5", "r6", "r7", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 struct cpu_user_fns feroceon_user_fns __initdata = {
Index: linux-2.6/arch/arm/mm/copypage-v3.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/copypage-v3.c
+++ linux-2.6/arch/arm/mm/copypage-v3.c
@@ -42,11 +42,11 @@ void v3_copy_user_highpage(struct page *
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic_push(to);
+	kfrom = kmap_atomic_push(from);
 	v3_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kmap_atomic_pop(kfrom);
+	kmap_atomic_pop(kto);
 }
 
 /*
@@ -56,7 +56,7 @@ void v3_copy_user_highpage(struct page *
  */
 void v3_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic_push(page);
 	asm volatile("\n\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -72,7 +72,7 @@ void v3_clear_user_highpage(struct page 
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 64)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 struct cpu_user_fns v3_user_fns __initdata = {
Index: linux-2.6/arch/arm/mm/copypage-v4mc.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/copypage-v4mc.c
+++ linux-2.6/arch/arm/mm/copypage-v4mc.c
@@ -71,7 +71,7 @@ mc_copy_user_page(void *from, void *to)
 void v4_mc_copy_user_highpage(struct page *to, struct page *from,
 	unsigned long vaddr)
 {
-	void *kto = kmap_atomic(to, KM_USER1);
+	void *kto = kmap_atomic_push(to);
 
 	if (test_and_clear_bit(PG_dcache_dirty, &from->flags))
 		__flush_dcache_page(page_mapping(from), from);
@@ -85,7 +85,7 @@ void v4_mc_copy_user_highpage(struct pag
 
 	spin_unlock(&minicache_lock);
 
-	kunmap_atomic(kto, KM_USER1);
+	kmap_atomic_pop(kto);
 }
 
 /*
@@ -93,7 +93,7 @@ void v4_mc_copy_user_highpage(struct pag
  */
 void v4_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic_push(page);
 	asm volatile("\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -111,7 +111,7 @@ void v4_mc_clear_user_highpage(struct pa
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 64)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 struct cpu_user_fns v4_mc_user_fns __initdata = {
Index: linux-2.6/arch/arm/mm/copypage-v4wb.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/copypage-v4wb.c
+++ linux-2.6/arch/arm/mm/copypage-v4wb.c
@@ -52,11 +52,11 @@ void v4wb_copy_user_highpage(struct page
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic_push(to);
+	kfrom = kmap_atomic_push(from);
 	v4wb_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kmap_atomic_pop(kfrom);
+	kmap_atomic_pop(kto);
 }
 
 /*
@@ -66,7 +66,7 @@ void v4wb_copy_user_highpage(struct page
  */
 void v4wb_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic_push(page);
 	asm volatile("\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -85,7 +85,7 @@ void v4wb_clear_user_highpage(struct pag
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 64)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 struct cpu_user_fns v4wb_user_fns __initdata = {
Index: linux-2.6/arch/arm/mm/copypage-v4wt.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/copypage-v4wt.c
+++ linux-2.6/arch/arm/mm/copypage-v4wt.c
@@ -48,11 +48,11 @@ void v4wt_copy_user_highpage(struct page
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic_push(to);
+	kfrom = kmap_atomic_push(from);
 	v4wt_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kmap_atomic_pop(kfrom);
+	kmap_atomic_pop(kto);
 }
 
 /*
@@ -62,7 +62,7 @@ void v4wt_copy_user_highpage(struct page
  */
 void v4wt_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic_push(page);
 	asm volatile("\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -79,7 +79,7 @@ void v4wt_clear_user_highpage(struct pag
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 64)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 struct cpu_user_fns v4wt_user_fns __initdata = {
Index: linux-2.6/arch/arm/mm/copypage-v6.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/copypage-v6.c
+++ linux-2.6/arch/arm/mm/copypage-v6.c
@@ -38,11 +38,11 @@ static void v6_copy_user_highpage_nonali
 {
 	void *kto, *kfrom;
 
-	kfrom = kmap_atomic(from, KM_USER0);
-	kto = kmap_atomic(to, KM_USER1);
+	kfrom = kmap_atomic_push(from);
+	kto = kmap_atomic_push(to);
 	copy_page(kto, kfrom);
-	kunmap_atomic(kto, KM_USER1);
-	kunmap_atomic(kfrom, KM_USER0);
+	kmap_atomic_pop(kto);
+	kmap_atomic_pop(kfrom);
 }
 
 /*
@@ -51,9 +51,9 @@ static void v6_copy_user_highpage_nonali
  */
 static void v6_clear_user_highpage_nonaliasing(struct page *page, unsigned long vaddr)
 {
-	void *kaddr = kmap_atomic(page, KM_USER0);
+	void *kaddr = kmap_atomic_push(page);
 	clear_page(kaddr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 /*
Index: linux-2.6/arch/arm/mm/copypage-xsc3.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/copypage-xsc3.c
+++ linux-2.6/arch/arm/mm/copypage-xsc3.c
@@ -75,11 +75,11 @@ void xsc3_mc_copy_user_highpage(struct p
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic_push(to);
+	kfrom = kmap_atomic_push(from);
 	xsc3_mc_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kmap_atomic_pop(kfrom);
+	kmap_atomic_pop(kto);
 }
 
 /*
@@ -89,7 +89,7 @@ void xsc3_mc_copy_user_highpage(struct p
  */
 void xsc3_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic_push(page);
 	asm volatile ("\
 	mov	r1, %2				\n\
 	mov	r2, #0				\n\
@@ -104,7 +104,7 @@ void xsc3_mc_clear_user_highpage(struct 
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 32)
 	: "r1", "r2", "r3");
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 struct cpu_user_fns xsc3_mc_user_fns __initdata = {
Index: linux-2.6/arch/arm/mm/copypage-xscale.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/copypage-xscale.c
+++ linux-2.6/arch/arm/mm/copypage-xscale.c
@@ -93,7 +93,7 @@ mc_copy_user_page(void *from, void *to)
 void xscale_mc_copy_user_highpage(struct page *to, struct page *from,
 	unsigned long vaddr)
 {
-	void *kto = kmap_atomic(to, KM_USER1);
+	void *kto = kmap_atomic_push(to);
 
 	if (test_and_clear_bit(PG_dcache_dirty, &from->flags))
 		__flush_dcache_page(page_mapping(from), from);
@@ -107,7 +107,7 @@ void xscale_mc_copy_user_highpage(struct
 
 	spin_unlock(&minicache_lock);
 
-	kunmap_atomic(kto, KM_USER1);
+	kmap_atomic_pop(kto);
 }
 
 /*
@@ -116,7 +116,7 @@ void xscale_mc_copy_user_highpage(struct
 void
 xscale_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic_push(page);
 	asm volatile(
 	"mov	r1, %2				\n\
 	mov	r2, #0				\n\
@@ -133,7 +133,7 @@ xscale_mc_clear_user_highpage(struct pag
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 32)
 	: "r1", "r2", "r3", "ip");
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 struct cpu_user_fns xscale_mc_user_fns __initdata = {
Index: linux-2.6/arch/arm/mm/flush.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/flush.c
+++ linux-2.6/arch/arm/mm/flush.c
@@ -146,8 +146,8 @@ void __flush_dcache_page(struct address_
 	 */
 #ifdef CONFIG_HIGHMEM
 	/*
-	 * kmap_atomic() doesn't set the page virtual address, and
-	 * kunmap_atomic() takes care of cache flushing already.
+	 * kmap_atomic_push() doesn't set the page virtual address, and
+	 * kmap_atomic_pop() takes care of cache flushing already.
 	 */
 	if (page_address(page))
 #endif
Index: linux-2.6/arch/arm/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/highmem.c
+++ linux-2.6/arch/arm/mm/highmem.c
@@ -36,7 +36,7 @@ void kunmap(struct page *page)
 }
 EXPORT_SYMBOL(kunmap);
 
-void *kmap_atomic(struct page *page, enum km_type type)
+void *kmap_atomic_push(struct page *page)
 {
 	unsigned int idx;
 	unsigned long vaddr;
@@ -50,18 +50,18 @@ void *kmap_atomic(struct page *page, enu
 	if (kmap)
 		return kmap;
 
-	idx = type + KM_TYPE_NR * smp_processor_id();
+	idx = kmap_atomic_push_idx() + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	/*
-	 * With debugging enabled, kunmap_atomic forces that entry to 0.
+	 * With debugging enabled, kmap_atomic_pop forces that entry to 0.
 	 * Make sure it was indeed properly unmapped.
 	 */
 	BUG_ON(!pte_none(*(TOP_PTE(vaddr))));
 #endif
 	set_pte_ext(TOP_PTE(vaddr), mk_pte(page, kmap_prot), 0);
 	/*
-	 * When debugging is off, kunmap_atomic leaves the previous mapping
+	 * When debugging is off, kmap_atomic_pop leaves the previous mapping
 	 * in place, so this TLB flush ensures the TLB is updated with the
 	 * new mapping.
 	 */
@@ -69,12 +69,12 @@ void *kmap_atomic(struct page *page, enu
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_push);
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void kmap_atomic_pop(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	unsigned int idx = type + KM_TYPE_NR * smp_processor_id();
+	unsigned int idx = kmap_atomic_pop_idx() + KM_TYPE_NR * smp_processor_id();
 
 	if (kvaddr >= (void *)FIXADDR_START) {
 		__cpuc_flush_dcache_page((void *)vaddr);
@@ -91,16 +91,16 @@ void kunmap_atomic(void *kvaddr, enum km
 	}
 	pagefault_enable();
 }
-EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_pop);
 
-void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
+void *kmap_atomic_push_pfn(unsigned long pfn)
 {
 	unsigned int idx;
 	unsigned long vaddr;
 
 	pagefault_disable();
 
-	idx = type + KM_TYPE_NR * smp_processor_id();
+	idx = kmap_atomic_push_idx() + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(TOP_PTE(vaddr))));
Index: linux-2.6/arch/frv/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/highmem.h
+++ linux-2.6/arch/frv/include/asm/highmem.h
@@ -67,8 +67,8 @@ extern struct page *kmap_atomic_to_page(
 #endif /* !__ASSEMBLY__ */
 
 /*
- * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
- * gives a more generic (and caching) interface. But kmap_atomic can
+ * The use of kmap_atomic_push/kmap_atomic_pop is discouraged - kmap/kunmap
+ * gives a more generic (and caching) interface. But kmap_atomic_push can
  * be used in IRQ contexts, so in some (very limited) cases we need
  * it.
  */
@@ -76,7 +76,7 @@ extern struct page *kmap_atomic_to_page(
 
 #ifndef __ASSEMBLY__
 
-#define __kmap_atomic_primary(type, paddr, ampr)						\
+#define __kmap_atomic_push_primary(type, paddr, ampr)						\
 ({												\
 	unsigned long damlr, dampr;								\
 												\
@@ -97,7 +97,7 @@ extern struct page *kmap_atomic_to_page(
 	(void *) damlr;										\
 })
 
-#define __kmap_atomic_secondary(slot, paddr)							  \
+#define __kmap_atomic_push_secondary(slot, paddr)							  \
 ({												  \
 	unsigned long damlr = KMAP_ATOMIC_SECONDARY_FRAME + (slot) * PAGE_SIZE;			  \
 	unsigned long dampr = paddr | xAMPRx_L | xAMPRx_M | xAMPRx_S | xAMPRx_SS_16Kb | xAMPRx_V; \
@@ -112,27 +112,28 @@ extern struct page *kmap_atomic_to_page(
 	(void *) damlr;										  \
 })
 
-static inline void *kmap_atomic(struct page *page, enum km_type type)
+static inline void *kmap_atomic_push(struct page *page)
 {
 	unsigned long paddr;
+	int type;
 
 	pagefault_disable();
-	debug_kmap_atomic(type);
-	paddr = page_to_phys(page);
 
+	paddr = page_to_phys(page);
+	type = kmap_atomic_push_idx();
 	switch (type) {
-        case 0:		return __kmap_atomic_primary(0, paddr, 2);
-        case 1:		return __kmap_atomic_primary(1, paddr, 3);
-        case 2:		return __kmap_atomic_primary(2, paddr, 4);
-        case 3:		return __kmap_atomic_primary(3, paddr, 5);
-        case 4:		return __kmap_atomic_primary(4, paddr, 6);
-        case 5:		return __kmap_atomic_primary(5, paddr, 7);
-        case 6:		return __kmap_atomic_primary(6, paddr, 8);
-        case 7:		return __kmap_atomic_primary(7, paddr, 9);
-        case 8:		return __kmap_atomic_primary(8, paddr, 10);
+        case 0:		return __kmap_atomic_push_primary(0, paddr, 2);
+        case 1:		return __kmap_atomic_push_primary(1, paddr, 3);
+        case 2:		return __kmap_atomic_push_primary(2, paddr, 4);
+        case 3:		return __kmap_atomic_push_primary(3, paddr, 5);
+        case 4:		return __kmap_atomic_push_primary(4, paddr, 6);
+        case 5:		return __kmap_atomic_push_primary(5, paddr, 7);
+        case 6:		return __kmap_atomic_push_primary(6, paddr, 8);
+        case 7:		return __kmap_atomic_push_primary(7, paddr, 9);
+        case 8:		return __kmap_atomic_push_primary(8, paddr, 10);
 
 	case 9 ... 9 + NR_TLB_LINES - 1:
-		return __kmap_atomic_secondary(type - 9, paddr);
+		return __kmap_atomic_push_secondary(type - 9, paddr);
 
 	default:
 		BUG();
@@ -140,33 +141,35 @@ static inline void *kmap_atomic(struct p
 	}
 }
 
-#define __kunmap_atomic_primary(type, ampr)				\
+#define __kmap_atomic_pop_primary(type, ampr)				\
 do {									\
 	asm volatile("movgs gr0,dampr"#ampr"\n" ::: "memory");		\
 	if (type == __KM_CACHE)						\
 		asm volatile("movgs gr0,iampr"#ampr"\n" ::: "memory");	\
 } while(0)
 
-#define __kunmap_atomic_secondary(slot, vaddr)				\
+#define __kmap_atomic_pop_secondary(slot, vaddr)				\
 do {									\
 	asm volatile("tlbpr %0,gr0,#4,#1" : : "r"(vaddr) : "memory");	\
 } while(0)
 
-static inline void kunmap_atomic(void *kvaddr, enum km_type type)
+static inline void kmap_atomic_pop(void *kvaddr)
 {
+	int type = kmap_atomic_pop_idx();
+
 	switch (type) {
-        case 0:		__kunmap_atomic_primary(0, 2);	break;
-        case 1:		__kunmap_atomic_primary(1, 3);	break;
-        case 2:		__kunmap_atomic_primary(2, 4);	break;
-        case 3:		__kunmap_atomic_primary(3, 5);	break;
-        case 4:		__kunmap_atomic_primary(4, 6);	break;
-        case 5:		__kunmap_atomic_primary(5, 7);	break;
-        case 6:		__kunmap_atomic_primary(6, 8);	break;
-        case 7:		__kunmap_atomic_primary(7, 9);	break;
-        case 8:		__kunmap_atomic_primary(8, 10);	break;
+        case 0:		__kmap_atomic_pop_primary(0, 2);	break;
+        case 1:		__kmap_atomic_pop_primary(1, 3);	break;
+        case 2:		__kmap_atomic_pop_primary(2, 4);	break;
+        case 3:		__kmap_atomic_pop_primary(3, 5);	break;
+        case 4:		__kmap_atomic_pop_primary(4, 6);	break;
+        case 5:		__kmap_atomic_pop_primary(5, 7);	break;
+        case 6:		__kmap_atomic_pop_primary(6, 8);	break;
+        case 7:		__kmap_atomic_pop_primary(7, 9);	break;
+        case 8:		__kmap_atomic_pop_primary(8, 10);	break;
 
 	case 9 ... 9 + NR_TLB_LINES - 1:
-		__kunmap_atomic_secondary(type - 9, kvaddr);
+		__kmap_atomic_pop_secondary(type - 9, kvaddr);
 		break;
 
 	default:
Index: linux-2.6/arch/frv/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/pgtable.h
+++ linux-2.6/arch/frv/include/asm/pgtable.h
@@ -451,11 +451,11 @@ static inline pte_t pte_modify(pte_t pte
 
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
+	((pte_t *)kmap_atomic_push(pmd_page(*(dir))) + pte_index(address))
 #define pte_offset_map_nested(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
-#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
+	((pte_t *)kmap_atomic_push(pmd_page(*(dir))) + pte_index(address))
+#define pte_unmap(pte) kmap_atomic_pop(pte)
+#define pte_unmap_nested(pte) kmap_atomic_pop((pte))
 #else
 #define pte_offset_map(dir, address) \
 	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
Index: linux-2.6/arch/frv/kernel/head-mmu-fr451.S
===================================================================
--- linux-2.6.orig/arch/frv/kernel/head-mmu-fr451.S
+++ linux-2.6/arch/frv/kernel/head-mmu-fr451.S
@@ -276,7 +276,7 @@ __head_fr451_set_protection:
 	movgs		gr9,damlr1
 	movgs		gr8,dampr1
 
-	# we use DAMR2-10 for kmap_atomic(), cache flush and TLB management
+	# we use DAMR2-10 for kmap_atomic_push(), cache flush and TLB management
 	# since the DAMLR regs are not going to change, we can set them now
 	# also set up IAMLR2 to the same as DAMLR5
 	sethi.p		%hi(KMAP_ATOMIC_PRIMARY_FRAME),gr4
Index: linux-2.6/arch/frv/mb93090-mb00/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/frv/mb93090-mb00/pci-dma.c
+++ linux-2.6/arch/frv/mb93090-mb00/pci-dma.c
@@ -85,14 +85,14 @@ int dma_map_sg(struct device *dev, struc
 	dampr2 = __get_DAMPR(2);
 
 	for (i = 0; i < nents; i++) {
-		vaddr = kmap_atomic(sg_page(&sg[i]), __KM_CACHE);
+		vaddr = kmap_atomic_push(sg_page(&sg[i]), __KM_CACHE);
 
 		frv_dcache_writeback((unsigned long) vaddr,
 				     (unsigned long) vaddr + PAGE_SIZE);
 
 	}
 
-	kunmap_atomic(vaddr, __KM_CACHE);
+	kmap_atomic_pop(vaddr, __KM_CACHE);
 	if (dampr2) {
 		__set_DAMPR(2, dampr2);
 		__set_IAMPR(2, dampr2);
Index: linux-2.6/arch/frv/mm/cache-page.c
===================================================================
--- linux-2.6.orig/arch/frv/mm/cache-page.c
+++ linux-2.6/arch/frv/mm/cache-page.c
@@ -17,7 +17,7 @@
 /*****************************************************************************/
 /*
  * DCF takes a virtual address and the page may not currently have one
- * - temporarily hijack a kmap_atomic() slot and attach the page to it
+ * - temporarily hijack a kmap_atomic_push() slot and attach the page to it
  */
 void flush_dcache_page(struct page *page)
 {
@@ -26,11 +26,11 @@ void flush_dcache_page(struct page *page
 
 	dampr2 = __get_DAMPR(2);
 
-	vaddr = kmap_atomic(page, __KM_CACHE);
+	vaddr = kmap_atomic_push(page, __KM_CACHE);
 
 	frv_dcache_writeback((unsigned long) vaddr, (unsigned long) vaddr + PAGE_SIZE);
 
-	kunmap_atomic(vaddr, __KM_CACHE);
+	kmap_atomic_pop(vaddr, __KM_CACHE);
 
 	if (dampr2) {
 		__set_DAMPR(2, dampr2);
@@ -54,12 +54,12 @@ void flush_icache_user_range(struct vm_a
 
 	dampr2 = __get_DAMPR(2);
 
-	vaddr = kmap_atomic(page, __KM_CACHE);
+	vaddr = kmap_atomic_push(page, __KM_CACHE);
 
 	start = (start & ~PAGE_MASK) | (unsigned long) vaddr;
 	frv_cache_wback_inv(start, start + len);
 
-	kunmap_atomic(vaddr, __KM_CACHE);
+	kmap_atomic_pop(vaddr, __KM_CACHE);
 
 	if (dampr2) {
 		__set_DAMPR(2, dampr2);
Index: linux-2.6/arch/ia64/kernel/crash_dump.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/crash_dump.c
+++ linux-2.6/arch/ia64/kernel/crash_dump.c
@@ -27,7 +27,7 @@ unsigned long long elfcorehdr_addr = ELF
  *	otherwise @buf is in kernel address space, use memcpy().
  *
  * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
+ * in the current kernel. We stitch up a pte, similar to kmap_atomic_push.
  *
  * Calling copy_to_user() in atomic context is not desirable. Hence first
  * copying the data to a pre-allocated kernel page and then copying to user
Index: linux-2.6/arch/microblaze/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/pgtable.h
+++ linux-2.6/arch/microblaze/include/asm/pgtable.h
@@ -478,12 +478,12 @@ static inline pmd_t *pmd_offset(pgd_t *d
 #define pte_offset_kernel(dir, addr)	\
 	((pte_t *) pmd_page_kernel(*(dir)) + pte_index(addr))
 #define pte_offset_map(dir, addr)		\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
+	((pte_t *) kmap_atomic_push(pmd_page(*(dir))) + pte_index(addr))
 #define pte_offset_map_nested(dir, addr)	\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE1) + pte_index(addr))
+	((pte_t *) kmap_atomic_push(pmd_page(*(dir))) + pte_index(addr))
 
-#define pte_unmap(pte)		kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte)	kunmap_atomic(pte, KM_PTE1)
+#define pte_unmap(pte)		kmap_atomic_pop(pte)
+#define pte_unmap_nested(pte)	kmap_atomic_pop(pte)
 
 /* Encode and decode a nonlinear file mapping entry */
 #define PTE_FILE_MAX_BITS	29
Index: linux-2.6/arch/mips/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/highmem.h
+++ linux-2.6/arch/mips/include/asm/highmem.h
@@ -47,15 +47,15 @@ extern void kunmap_high(struct page *pag
 
 extern void *__kmap(struct page *page);
 extern void __kunmap(struct page *page);
-extern void *__kmap_atomic(struct page *page, enum km_type type);
-extern void __kunmap_atomic(void *kvaddr, enum km_type type);
-extern void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
+extern void *__kmap_atomic_push(struct page *page);
+extern void __kmap_atomic_pop(void *kvaddr);
+extern void *kmap_atomic_push_pfn(unsigned long pfn);
 extern struct page *__kmap_atomic_to_page(void *ptr);
 
 #define kmap			__kmap
 #define kunmap			__kunmap
-#define kmap_atomic		__kmap_atomic
-#define kunmap_atomic		__kunmap_atomic
+#define kmap_atomic_push	__kmap_atomic_push
+#define kmap_atomic_pop		__kmap_atomic_pop
 #define kmap_atomic_to_page	__kmap_atomic_to_page
 
 #define flush_cache_kmaps()	flush_cache_all()
Index: linux-2.6/arch/mips/mm/c-r4k.c
===================================================================
--- linux-2.6.orig/arch/mips/mm/c-r4k.c
+++ linux-2.6/arch/mips/mm/c-r4k.c
@@ -490,7 +490,7 @@ static inline void local_r4k_flush_cache
 		vaddr = NULL;
 	else {
 		/*
-		 * Use kmap_coherent or kmap_atomic to do flushes for
+		 * Use kmap_coherent or kmap_atomic_push to do flushes for
 		 * another ASID than the current one.
 		 */
 		map_coherent = (cpu_has_dc_aliases &&
@@ -498,7 +498,7 @@ static inline void local_r4k_flush_cache
 		if (map_coherent)
 			vaddr = kmap_coherent(page, addr);
 		else
-			vaddr = kmap_atomic(page, KM_USER0);
+			vaddr = kmap_atomic_push(page);
 		addr = (unsigned long)vaddr;
 	}
 
@@ -521,7 +521,7 @@ static inline void local_r4k_flush_cache
 		if (map_coherent)
 			kunmap_coherent();
 		else
-			kunmap_atomic(vaddr, KM_USER0);
+			kmap_atomic_pop(vaddr);
 	}
 }
 
Index: linux-2.6/arch/mips/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/mips/mm/highmem.c
+++ linux-2.6/arch/mips/mm/highmem.c
@@ -32,7 +32,7 @@ void __kunmap(struct page *page)
 EXPORT_SYMBOL(__kunmap);
 
 /*
- * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
+ * kmap_atomic_push/kmap_atomic_pop is significantly faster than kmap/kunmap because
  * no global lock is needed and because the kmap code must perform a global TLB
  * invalidation when the kmap pool wraps.
  *
@@ -40,7 +40,7 @@ EXPORT_SYMBOL(__kunmap);
  * kmaps are appropriate for short, tight code paths only.
  */
 
-void *__kmap_atomic(struct page *page, enum km_type type)
+void *__kmap_atomic_push(struct page *page)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
@@ -50,8 +50,7 @@ void *__kmap_atomic(struct page *page, e
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic(type);
-	idx = type + KM_TYPE_NR*smp_processor_id();
+	idx = kmap_atomic_push_idx() + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte - idx)));
@@ -61,13 +60,13 @@ void *__kmap_atomic(struct page *page, e
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(__kmap_atomic);
+EXPORT_SYMBOL(__kmap_atomic_push);
 
-void __kunmap_atomic(void *kvaddr, enum km_type type)
+void __kmap_atomic_pop(void *kvaddr)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
+	enum fixed_addresses idx = kmap_atomic_pop_idx() + KM_TYPE_NR*smp_processor_id();
 
 	if (vaddr < FIXADDR_START) { // FIXME
 		pagefault_enable();
@@ -86,21 +85,20 @@ void __kunmap_atomic(void *kvaddr, enum 
 
 	pagefault_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(__kmap_atomic_pop);
 
 /*
- * This is the same as kmap_atomic() but can map memory that doesn't
+ * This is the same as kmap_atomic_push() but can map memory that doesn't
  * have a struct page associated with it.
  */
-void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
+void *kmap_atomic_push_pfn(unsigned long pfn)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
 
 	pagefault_disable();
 
-	debug_kmap_atomic(type);
-	idx = type + KM_TYPE_NR*smp_processor_id();
+	idx = kmap_atomic_push_idx() + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, PAGE_KERNEL));
 	flush_tlb_one(vaddr);
Index: linux-2.6/arch/mips/mm/init.c
===================================================================
--- linux-2.6.orig/arch/mips/mm/init.c
+++ linux-2.6/arch/mips/mm/init.c
@@ -204,21 +204,21 @@ void copy_user_highpage(struct page *to,
 {
 	void *vfrom, *vto;
 
-	vto = kmap_atomic(to, KM_USER1);
+	vto = kmap_atomic_push(to);
 	if (cpu_has_dc_aliases &&
 	    page_mapped(from) && !Page_dcache_dirty(from)) {
 		vfrom = kmap_coherent(from, vaddr);
 		copy_page(vto, vfrom);
 		kunmap_coherent();
 	} else {
-		vfrom = kmap_atomic(from, KM_USER0);
+		vfrom = kmap_atomic_push(from);
 		copy_page(vto, vfrom);
-		kunmap_atomic(vfrom, KM_USER0);
+		kmap_atomic_pop(vfrom);
 	}
 	if ((!cpu_has_ic_fills_f_dc) ||
 	    pages_do_alias((unsigned long)vto, vaddr & PAGE_MASK))
 		flush_data_cache_page((unsigned long)vto);
-	kunmap_atomic(vto, KM_USER1);
+	kmap_atomic_pop(vto);
 	/* Make sure this page is cleared on other CPU's too before using it */
 	smp_wmb();
 }
Index: linux-2.6/arch/mn10300/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/highmem.h
+++ linux-2.6/arch/mn10300/include/asm/highmem.h
@@ -65,12 +65,12 @@ static inline void kunmap(struct page *p
 }
 
 /*
- * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
- * gives a more generic (and caching) interface. But kmap_atomic can
+ * The use of kmap_atomic_push/kmap_atomic_pop is discouraged - kmap/kunmap
+ * gives a more generic (and caching) interface. But kmap_atomic_push can
  * be used in IRQ contexts, so in some (very limited) cases we need
  * it.
  */
-static inline unsigned long kmap_atomic(struct page *page, enum km_type type)
+static inline unsigned long kmap_atomic_push(struct page *page)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
@@ -78,8 +78,7 @@ static inline unsigned long kmap_atomic(
 	if (page < highmem_start_page)
 		return page_address(page);
 
-	debug_kmap_atomic(type);
-	idx = type + KM_TYPE_NR * smp_processor_id();
+	idx = kmap_atomic_push_idx() + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #if HIGHMEM_DEBUG
 	if (!pte_none(*(kmap_pte - idx)))
@@ -91,10 +90,10 @@ static inline unsigned long kmap_atomic(
 	return vaddr;
 }
 
-static inline void kunmap_atomic(unsigned long vaddr, enum km_type type)
+static inline void kmap_atomic_pop(unsigned long vaddr)
 {
 #if HIGHMEM_DEBUG
-	enum fixed_addresses idx = type + KM_TYPE_NR * smp_processor_id();
+	enum fixed_addresses idx = kmap_atomic_pop_idx() + KM_TYPE_NR * smp_processor_id();
 
 	if (vaddr < FIXADDR_START) /* FIXME */
 		return;
Index: linux-2.6/arch/parisc/include/asm/cacheflush.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/cacheflush.h
+++ linux-2.6/arch/parisc/include/asm/cacheflush.h
@@ -112,11 +112,11 @@ static inline void *kmap(struct page *pa
 
 #define kunmap(page)			kunmap_parisc(page_address(page))
 
-#define kmap_atomic(page, idx)		page_address(page)
+#define kmap_atomic_push(page, idx)		page_address(page)
 
-#define kunmap_atomic(addr, idx)	kunmap_parisc(addr)
+#define kmap_atomic_pop(addr, idx)	kunmap_parisc(addr)
 
-#define kmap_atomic_pfn(pfn, idx)	page_address(pfn_to_page(pfn))
+#define kmap_atomic_push_pfn(pfn, idx)	page_address(pfn_to_page(pfn))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
 #endif
 
Index: linux-2.6/arch/powerpc/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/highmem.h
+++ linux-2.6/arch/powerpc/include/asm/highmem.h
@@ -60,9 +60,8 @@ extern pte_t *pkmap_page_table;
 
 extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
-extern void *kmap_atomic_prot(struct page *page, enum km_type type,
-			      pgprot_t prot);
-extern void kunmap_atomic(void *kvaddr, enum km_type type);
+extern void *kmap_atomic_push_prot(struct page *page, pgprot_t prot);
+extern void kmap_atomic_pop(void *kvaddr);
 
 static inline void *kmap(struct page *page)
 {
@@ -80,9 +79,9 @@ static inline void kunmap(struct page *p
 	kunmap_high(page);
 }
 
-static inline void *kmap_atomic(struct page *page, enum km_type type)
+static inline void *kmap_atomic_push(struct page *page)
 {
-	return kmap_atomic_prot(page, type, kmap_prot);
+	return kmap_atomic_push_prot(page, kmap_prot);
 }
 
 static inline struct page *kmap_atomic_to_page(void *ptr)
Index: linux-2.6/arch/powerpc/include/asm/pgtable-ppc32.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/pgtable-ppc32.h
+++ linux-2.6/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -308,12 +308,12 @@ static inline void __ptep_set_access_fla
 #define pte_offset_kernel(dir, addr)	\
 	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(addr))
 #define pte_offset_map(dir, addr)		\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
+	((pte_t *) kmap_atomic_push(pmd_page(*(dir))) + pte_index(addr))
 #define pte_offset_map_nested(dir, addr)	\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE1) + pte_index(addr))
+	((pte_t *) kmap_atomic_push(pmd_page(*(dir))) + pte_index(addr))
 
-#define pte_unmap(pte)		kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte)	kunmap_atomic(pte, KM_PTE1)
+#define pte_unmap(pte)		kmap_atomic_pop(pte)
+#define pte_unmap_nested(pte)	kmap_atomic_pop(pte)
 
 /*
  * Encode and decode a swap entry.
Index: linux-2.6/arch/powerpc/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/pgtable.h
+++ linux-2.6/arch/powerpc/include/asm/pgtable.h
@@ -95,7 +95,7 @@ static inline void __set_pte_at(struct m
 	/* First case is 32-bit Hash MMU in SMP mode with 32-bit PTEs. We use the
 	 * helper pte_update() which does an atomic update. We need to do that
 	 * because a concurrent invalidation can clear _PAGE_HASHPTE. If it's a
-	 * per-CPU PTE such as a kmap_atomic, we do a simple update preserving
+	 * per-CPU PTE such as a kmap_atomic_push, we do a simple update preserving
 	 * the hash bits instead (ie, same as the non-SMP case)
 	 */
 	if (percpu)
Index: linux-2.6/arch/powerpc/kernel/crash_dump.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/crash_dump.c
+++ linux-2.6/arch/powerpc/kernel/crash_dump.c
@@ -118,7 +118,7 @@ static size_t copy_oldmem_vaddr(void *va
  *      otherwise @buf is in kernel address space, use memcpy().
  *
  * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
+ * in the current kernel. We stitch up a pte, similar to kmap_atomic_push.
  */
 ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 			size_t csize, unsigned long offset, int userbuf)
Index: linux-2.6/arch/powerpc/mm/dma-noncoherent.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/dma-noncoherent.c
+++ linux-2.6/arch/powerpc/mm/dma-noncoherent.c
@@ -346,7 +346,7 @@ EXPORT_SYMBOL(__dma_sync);
  * __dma_sync_page() implementation for systems using highmem.
  * In this case, each page of a buffer must be kmapped/kunmapped
  * in order to have a virtual address for __dma_sync(). This must
- * not sleep so kmap_atomic()/kunmap_atomic() are used.
+ * not sleep so kmap_atomic_push()/kmap_atomic_pop() are used.
  *
  * Note: yes, it is possible and correct to have a buffer extend
  * beyond the first page.
@@ -363,12 +363,12 @@ static inline void __dma_sync_page_highm
 	local_irq_save(flags);
 
 	do {
-		start = (unsigned long)kmap_atomic(page + seg_nr,
-				KM_PPC_SYNC_PAGE) + seg_offset;
+		start = (unsigned long)kmap_atomic_push(page + seg_nr)
+			+ seg_offset;
 
 		/* Sync this buffer segment */
 		__dma_sync((void *)start, seg_size, direction);
-		kunmap_atomic((void *)start, KM_PPC_SYNC_PAGE);
+		kmap_atomic_pop((void *)start);
 		seg_nr++;
 
 		/* Calculate next buffer segment size */
Index: linux-2.6/arch/powerpc/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/highmem.c
+++ linux-2.6/arch/powerpc/mm/highmem.c
@@ -24,12 +24,12 @@
 #include <linux/module.h>
 
 /*
- * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
- * gives a more generic (and caching) interface. But kmap_atomic can
+ * The use of kmap_atomic_push/kmap_atomic_pop is discouraged - kmap/kunmap
+ * gives a more generic (and caching) interface. But kmap_atomic_push can
  * be used in IRQ contexts, so in some (very limited) cases we need
  * it.
  */
-void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
+void *kmap_atomic_push_prot(struct page *page, pgprot_t prot)
 {
 	unsigned int idx;
 	unsigned long vaddr;
@@ -39,8 +39,7 @@ void *kmap_atomic_prot(struct page *page
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic(type);
-	idx = type + KM_TYPE_NR*smp_processor_id();
+	idx = kmap_atomic_push_idx() + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
@@ -50,13 +49,13 @@ void *kmap_atomic_prot(struct page *page
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_prot);
+EXPORT_SYMBOL(kmap_atomic_push_prot);
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void kmap_atomic_pop(void *kvaddr)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
+	enum fixed_addresses idx = kmap_atomic_pop_idx() + KM_TYPE_NR*smp_processor_id();
 
 	if (vaddr < __fix_to_virt(FIX_KMAP_END)) {
 		pagefault_enable();
@@ -74,4 +73,4 @@ void kunmap_atomic(void *kvaddr, enum km
 #endif
 	pagefault_enable();
 }
-EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_pop);
Index: linux-2.6/arch/powerpc/mm/mem.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/mem.c
+++ linux-2.6/arch/powerpc/mm/mem.c
@@ -418,9 +418,9 @@ EXPORT_SYMBOL(flush_dcache_page);
 void flush_dcache_icache_page(struct page *page)
 {
 #ifdef CONFIG_BOOKE
-	void *start = kmap_atomic(page, KM_PPC_SYNC_ICACHE);
+	void *start = kmap_atomic_push(page);
 	__flush_dcache_icache(start);
-	kunmap_atomic(start, KM_PPC_SYNC_ICACHE);
+	kmap_atomic_pop(start);
 #elif defined(CONFIG_8xx) || defined(CONFIG_PPC64)
 	/* On 8xx there is no need to kmap since highmem is not supported */
 	__flush_dcache_icache(page_address(page)); 
Index: linux-2.6/arch/powerpc/sysdev/ppc4xx_pci.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/ppc4xx_pci.c
+++ linux-2.6/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -1613,7 +1613,7 @@ static void __init ppc4xx_pciex_port_set
 
 	/* Because of how big mapping the config space is (1M per bus), we
 	 * limit how many busses we support. In the long run, we could replace
-	 * that with something akin to kmap_atomic instead. We set aside 1 bus
+	 * that with something akin to kmap_atomic_push instead. We set aside 1 bus
 	 * for the host itself too.
 	 */
 	busses = hose->last_busno - hose->first_busno; /* This is off by 1 */
Index: linux-2.6/arch/sh/kernel/crash_dump.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/crash_dump.c
+++ linux-2.6/arch/sh/kernel/crash_dump.c
@@ -24,7 +24,7 @@ unsigned long long elfcorehdr_addr = ELF
  *	otherwise @buf is in kernel address space, use memcpy().
  *
  * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
+ * in the current kernel. We stitch up a pte, similar to kmap_atomic_push.
  */
 ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
                                size_t csize, unsigned long offset, int userbuf)
Index: linux-2.6/arch/sh/mm/cache.c
===================================================================
--- linux-2.6.orig/arch/sh/mm/cache.c
+++ linux-2.6/arch/sh/mm/cache.c
@@ -83,7 +83,7 @@ void copy_user_highpage(struct page *to,
 {
 	void *vfrom, *vto;
 
-	vto = kmap_atomic(to, KM_USER1);
+	vto = kmap_atomic_push(to);
 
 	if (boot_cpu_data.dcache.n_aliases && page_mapped(from) &&
 	    !test_bit(PG_dcache_dirty, &from->flags)) {
@@ -91,15 +91,15 @@ void copy_user_highpage(struct page *to,
 		copy_page(vto, vfrom);
 		kunmap_coherent(vfrom);
 	} else {
-		vfrom = kmap_atomic(from, KM_USER0);
+		vfrom = kmap_atomic_push(from);
 		copy_page(vto, vfrom);
-		kunmap_atomic(vfrom, KM_USER0);
+		kmap_atomic_pop(vfrom);
 	}
 
 	if (pages_do_alias((unsigned long)vto, vaddr & PAGE_MASK))
 		__flush_purge_region(vto, PAGE_SIZE);
 
-	kunmap_atomic(vto, KM_USER1);
+	kmap_atomic_pop(vto);
 	/* Make sure this page is cleared on other CPU's too before using it */
 	smp_wmb();
 }
@@ -107,14 +107,14 @@ EXPORT_SYMBOL(copy_user_highpage);
 
 void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *kaddr = kmap_atomic(page, KM_USER0);
+	void *kaddr = kmap_atomic_push(page);
 
 	clear_page(kaddr);
 
 	if (pages_do_alias((unsigned long)kaddr, vaddr & PAGE_MASK))
 		__flush_purge_region(kaddr, PAGE_SIZE);
 
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 EXPORT_SYMBOL(clear_user_highpage);
 
Index: linux-2.6/arch/sparc/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/highmem.h
+++ linux-2.6/arch/sparc/include/asm/highmem.h
@@ -70,8 +70,8 @@ static inline void kunmap(struct page *p
 	kunmap_high(page);
 }
 
-extern void *kmap_atomic(struct page *page, enum km_type type);
-extern void kunmap_atomic(void *kvaddr, enum km_type type);
+extern void *kmap_atomic_push(struct page *page);
+extern void kmap_atomic_pop(void *kvaddr);
 extern struct page *kmap_atomic_to_page(void *vaddr);
 
 #define flush_cache_kmaps()	flush_cache_all()
Index: linux-2.6/arch/sparc/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/sparc/mm/highmem.c
+++ linux-2.6/arch/sparc/mm/highmem.c
@@ -3,17 +3,17 @@
  *
  *  Provides kernel-static versions of atomic kmap functions originally
  *  found as inlines in include/asm-sparc/highmem.h.  These became
- *  needed as kmap_atomic() and kunmap_atomic() started getting
+ *  needed as kmap_atomic_push() and kmap_atomic_pop() started getting
  *  called from within modules.
  *  -- Tomas Szepe <szepe@pinerecords.com>, September 2002
  *
- *  But kmap_atomic() and kunmap_atomic() cannot be inlined in
+ *  But kmap_atomic_push() and kmap_atomic_pop() cannot be inlined in
  *  modules because they are loaded with btfixup-ped functions.
  */
 
 /*
- * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
- * gives a more generic (and caching) interface. But kmap_atomic can
+ * The use of kmap_atomic_push/kmap_atomic_pop is discouraged - kmap/kunmap
+ * gives a more generic (and caching) interface. But kmap_atomic_push can
  * be used in IRQ contexts, so in some (very limited) cases we need it.
  *
  * XXX This is an old text. Actually, it's good to use atomic kmaps,
@@ -29,7 +29,7 @@
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
 
-void *kmap_atomic(struct page *page, enum km_type type)
+void *kmap_atomic_push(struct page *page)
 {
 	unsigned long idx;
 	unsigned long vaddr;
@@ -39,8 +39,7 @@ void *kmap_atomic(struct page *page, enu
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic(type);
-	idx = type + KM_TYPE_NR*smp_processor_id();
+	idx = kmap_atomic_push_idx() + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 
 /* XXX Fix - Anton */
@@ -63,13 +62,13 @@ void *kmap_atomic(struct page *page, enu
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_push);
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void kmap_atomic_pop(void *kvaddr)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	unsigned long idx = type + KM_TYPE_NR*smp_processor_id();
+	unsigned long idx = kmap_atomic_pop_idx() + KM_TYPE_NR*smp_processor_id();
 
 	if (vaddr < FIXADDR_START) { // FIXME
 		pagefault_enable();
@@ -100,7 +99,7 @@ void kunmap_atomic(void *kvaddr, enum km
 
 	pagefault_enable();
 }
-EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_pop);
 
 /* We may be fed a pagetable here by ptep_to_xxx and others. */
 struct page *kmap_atomic_to_page(void *ptr)
Index: linux-2.6/arch/sparc/mm/io-unit.c
===================================================================
--- linux-2.6.orig/arch/sparc/mm/io-unit.c
+++ linux-2.6/arch/sparc/mm/io-unit.c
@@ -9,7 +9,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
-#include <linux/highmem.h>	/* pte_offset_map => kmap_atomic */
+#include <linux/highmem.h>	/* pte_offset_map => kmap_atomic_push */
 #include <linux/bitops.h>
 #include <linux/scatterlist.h>
 #include <linux/of.h>
Index: linux-2.6/arch/sparc/mm/iommu.c
===================================================================
--- linux-2.6.orig/arch/sparc/mm/iommu.c
+++ linux-2.6/arch/sparc/mm/iommu.c
@@ -11,7 +11,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/highmem.h>	/* pte_offset_map => kmap_atomic */
+#include <linux/highmem.h>	/* pte_offset_map => kmap_atomic_push */
 #include <linux/scatterlist.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
Index: linux-2.6/arch/um/kernel/skas/uaccess.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/skas/uaccess.c
+++ linux-2.6/arch/um/kernel/skas/uaccess.c
@@ -68,7 +68,7 @@ static int do_op_one_page(unsigned long 
 		return -1;
 
 	page = pte_page(*pte);
-	addr = (unsigned long) kmap_atomic(page, KM_UML_USERCOPY) +
+	addr = (unsigned long) kmap_atomic_push(page) +
 		(addr & ~PAGE_MASK);
 
 	current->thread.fault_catcher = &buf;
@@ -81,7 +81,7 @@ static int do_op_one_page(unsigned long 
 
 	current->thread.fault_catcher = NULL;
 
-	kunmap_atomic(page, KM_UML_USERCOPY);
+	kmap_atomic_pop(page);
 
 	return n;
 }
Index: linux-2.6/arch/x86/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/highmem.h
+++ linux-2.6/arch/x86/include/asm/highmem.h
@@ -59,15 +59,15 @@ extern void kunmap_high(struct page *pag
 
 void *kmap(struct page *page);
 void kunmap(struct page *page);
-void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
-void *kmap_atomic(struct page *page, enum km_type type);
-void kunmap_atomic(void *kvaddr, enum km_type type);
-void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
-void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
+void *kmap_atomic_push_prot(struct page *page, pgprot_t prot);
+void *kmap_atomic_push(struct page *page);
+void kmap_atomic_pop(void *kvaddr);
+void *kmap_atomic_push_pfn(unsigned long pfn);
+void *kmap_atomic_push_prot_pfn(unsigned long pfn, pgprot_t prot);
 struct page *kmap_atomic_to_page(void *ptr);
 
 #ifndef CONFIG_PARAVIRT
-#define kmap_atomic_pte(page, type)	kmap_atomic(page, type)
+#define kmap_atomic_push_pte(page)	kmap_atomic_push(page)
 #endif
 
 #define flush_cache_kmaps()	do { } while (0)
Index: linux-2.6/arch/x86/include/asm/iomap.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/iomap.h
+++ linux-2.6/arch/x86/include/asm/iomap.h
@@ -26,16 +26,9 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
-void *
-iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
-
-void
-iounmap_atomic(void *kvaddr, enum km_type type);
-
-int
-iomap_create_wc(resource_size_t base, unsigned long size, pgprot_t *prot);
-
-void
-iomap_free(resource_size_t base, unsigned long size);
+void *iomap_atomic_push_prot_pfn(unsigned long pfn, pgprot_t prot);
+void iomap_atomic_pop(void *kvaddr);
+int iomap_create_wc(resource_size_t base, unsigned long size, pgprot_t *prot);
+void iomap_free(resource_size_t base, unsigned long size);
 
 #endif /* _ASM_X86_IOMAP_H */
Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -436,10 +436,10 @@ static inline void paravirt_release_pud(
 }
 
 #ifdef CONFIG_HIGHPTE
-static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
+static inline void *kmap_atomic_push_pte(struct page *page, enum km_type type)
 {
 	unsigned long ret;
-	ret = PVOP_CALL2(unsigned long, pv_mmu_ops.kmap_atomic_pte, page, type);
+	ret = PVOP_CALL2(unsigned long, pv_mmu_ops.kmap_atomic_push_pte, page, type);
 	return (void *)ret;
 }
 #endif
Index: linux-2.6/arch/x86/include/asm/paravirt_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt_types.h
+++ linux-2.6/arch/x86/include/asm/paravirt_types.h
@@ -305,7 +305,7 @@ struct pv_mmu_ops {
 #endif	/* PAGETABLE_LEVELS >= 3 */
 
 #ifdef CONFIG_HIGHPTE
-	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
+	void *(*kmap_atomic_push_pte)(struct page *page, enum km_type type);
 #endif
 
 	struct pv_lazy_ops lazy_mode;
Index: linux-2.6/arch/x86/include/asm/pgtable_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_32.h
+++ linux-2.6/arch/x86/include/asm/pgtable_32.h
@@ -49,18 +49,14 @@ extern void set_pmd_pfn(unsigned long, u
 #endif
 
 #if defined(CONFIG_HIGHPTE)
-#define __KM_PTE			\
-	(in_nmi() ? KM_NMI_PTE : 	\
-	 in_irq() ? KM_IRQ_PTE :	\
-	 KM_PTE0)
 #define pte_offset_map(dir, address)					\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
+	((pte_t *)kmap_atomic_push_pte(pmd_page(*(dir))) +		\
 	 pte_index((address)))
 #define pte_offset_map_nested(dir, address)				\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE1) +		\
+	((pte_t *)kmap_atomic_push_pte(pmd_page(*(dir))) +		\
 	 pte_index((address)))
-#define pte_unmap(pte) kunmap_atomic((pte), __KM_PTE)
-#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
+#define pte_unmap(pte) kmap_atomic_pop((pte))
+#define pte_unmap_nested(pte) kmap_atomic_pop((pte))
 #else
 #define pte_offset_map(dir, address)					\
 	((pte_t *)page_address(pmd_page(*(dir))) + pte_index((address)))
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -2190,7 +2190,6 @@ static unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long offset, addr = (unsigned long)from;
-	int type = in_nmi() ? KM_NMI : KM_IRQ0;
 	unsigned long size, len = 0;
 	struct page *page;
 	void *map;
@@ -2204,9 +2203,9 @@ copy_from_user_nmi(void *to, const void 
 		offset = addr & (PAGE_SIZE - 1);
 		size = min(PAGE_SIZE - offset, n - len);
 
-		map = kmap_atomic(page, type);
+		map = kmap_atomic_push(page);
 		memcpy(to, map+offset, size);
-		kunmap_atomic(map, type);
+		kmap_atomic_pop(map);
 		put_page(page);
 
 		len  += size;
Index: linux-2.6/arch/x86/kernel/crash_dump_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/crash_dump_32.c
+++ linux-2.6/arch/x86/kernel/crash_dump_32.c
@@ -27,7 +27,7 @@ unsigned long long elfcorehdr_addr = ELF
  *	otherwise @buf is in kernel address space, use memcpy().
  *
  * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
+ * in the current kernel. We stitch up a pte, similar to kmap_atomic_push.
  *
  * Calling copy_to_user() in atomic context is not desirable. Hence first
  * copying the data to a pre-allocated kernel page and then copying to user
@@ -41,20 +41,20 @@ ssize_t copy_oldmem_page(unsigned long p
 	if (!csize)
 		return 0;
 
-	vaddr = kmap_atomic_pfn(pfn, KM_PTE0);
+	vaddr = kmap_atomic_push_pfn(pfn);
 
 	if (!userbuf) {
 		memcpy(buf, (vaddr + offset), csize);
-		kunmap_atomic(vaddr, KM_PTE0);
+		kmap_atomic_pop(vaddr);
 	} else {
 		if (!kdump_buf_page) {
 			printk(KERN_WARNING "Kdump: Kdump buffer page not"
 				" allocated\n");
-			kunmap_atomic(vaddr, KM_PTE0);
+			kmap_atomic_pop(vaddr);
 			return -EFAULT;
 		}
 		copy_page(kdump_buf_page, vaddr);
-		kunmap_atomic(vaddr, KM_PTE0);
+		kmap_atomic_pop(vaddr);
 		if (copy_to_user(buf, (kdump_buf_page + offset), csize))
 			return -EFAULT;
 	}
Index: linux-2.6/arch/x86/kernel/crash_dump_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/crash_dump_64.c
+++ linux-2.6/arch/x86/kernel/crash_dump_64.c
@@ -24,7 +24,7 @@ unsigned long long elfcorehdr_addr = ELF
  *	otherwise @buf is in kernel address space, use memcpy().
  *
  * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
+ * in the current kernel. We stitch up a pte, similar to kmap_atomic_push.
  */
 ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 		size_t csize, unsigned long offset, int userbuf)
Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -429,7 +429,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
 
 #ifdef CONFIG_HIGHPTE
-	.kmap_atomic_pte = kmap_atomic,
+	.kmap_atomic_push_pte = kmap_atomic_push,
 #endif
 
 #if PAGETABLE_LEVELS >= 3
Index: linux-2.6/arch/x86/kernel/vmi_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmi_32.c
+++ linux-2.6/arch/x86/kernel/vmi_32.c
@@ -267,9 +267,9 @@ static void vmi_nop(void)
 }
 
 #ifdef CONFIG_HIGHPTE
-static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
+static void *vmi_kmap_atomic_push_pte(struct page *page, enum km_type type)
 {
-	void *va = kmap_atomic(page, type);
+	void *va = kmap_atomic_push(page, type);
 
 	/*
 	 * Internally, the VMI ROM must map virtual addresses to physical
@@ -780,7 +780,7 @@ static inline int __init activate_vmi(vo
 	vmi_ops.set_linear_mapping = vmi_get_function(VMI_CALL_SetLinearMapping);
 #ifdef CONFIG_HIGHPTE
 	if (vmi_ops.set_linear_mapping)
-		pv_mmu_ops.kmap_atomic_pte = vmi_kmap_atomic_pte;
+		pv_mmu_ops.kmap_atomic_push_pte = vmi_kmap_atomic_push_pte;
 #endif
 
 	/*
Index: linux-2.6/arch/x86/kvm/lapic.c
===================================================================
--- linux-2.6.orig/arch/x86/kvm/lapic.c
+++ linux-2.6/arch/x86/kvm/lapic.c
@@ -1179,9 +1179,9 @@ void kvm_lapic_sync_from_vapic(struct kv
 	if (!irqchip_in_kernel(vcpu->kvm) || !vcpu->arch.apic->vapic_addr)
 		return;
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page, KM_USER0);
+	vapic = kmap_atomic_push(vcpu->arch.apic->vapic_page);
 	data = *(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr));
-	kunmap_atomic(vapic, KM_USER0);
+	kmap_atomic_pop(vapic);
 
 	apic_set_tpr(vcpu->arch.apic, data & 0xff);
 }
@@ -1206,9 +1206,9 @@ void kvm_lapic_sync_to_vapic(struct kvm_
 		max_isr = 0;
 	data = (tpr & 0xff) | ((max_isr & 0xf0) << 8) | (max_irr << 24);
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page, KM_USER0);
+	vapic = kmap_atomic_push(vcpu->arch.apic->vapic_page);
 	*(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr)) = data;
-	kunmap_atomic(vapic, KM_USER0);
+	kmap_atomic_pop(vapic);
 }
 
 void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
Index: linux-2.6/arch/x86/kvm/paging_tmpl.h
===================================================================
--- linux-2.6.orig/arch/x86/kvm/paging_tmpl.h
+++ linux-2.6/arch/x86/kvm/paging_tmpl.h
@@ -88,9 +88,9 @@ static bool FNAME(cmpxchg_gpte)(struct k
 
 	page = gfn_to_page(kvm, table_gfn);
 
-	table = kmap_atomic(page, KM_USER0);
+	table = kmap_atomic_push(page);
 	ret = CMPXCHG(&table[index], orig_pte, new_pte);
-	kunmap_atomic(table, KM_USER0);
+	kmap_atomic_pop(table);
 
 	kvm_release_page_dirty(page);
 
Index: linux-2.6/arch/x86/kvm/svm.c
===================================================================
--- linux-2.6.orig/arch/x86/kvm/svm.c
+++ linux-2.6/arch/x86/kvm/svm.c
@@ -1397,7 +1397,7 @@ static void *nested_svm_map(struct vcpu_
 	if (is_error_page(page))
 		goto error;
 
-	return kmap_atomic(page, idx);
+	return kmap_atomic_push(page, idx);
 
 error:
 	kvm_release_page_clean(page);
@@ -1415,7 +1415,7 @@ static void nested_svm_unmap(void *addr,
 
 	page = kmap_atomic_to_page(addr);
 
-	kunmap_atomic(addr, idx);
+	kmap_atomic_pop(addr, idx);
 	kvm_release_page_dirty(page);
 }
 
@@ -1430,7 +1430,7 @@ static bool nested_svm_exit_handled_msr(
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return false;
 
-	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER0);
+	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm);
 
 	if (!msrpm)
 		goto out;
@@ -1458,7 +1458,7 @@ static bool nested_svm_exit_handled_msr(
 	ret = msrpm[t1] & ((1 << param) << t0);
 
 out:
-	nested_svm_unmap(msrpm, KM_USER0);
+	nested_svm_unmap(msrpm);
 
 	return ret;
 }
@@ -1584,7 +1584,7 @@ static int nested_svm_vmexit(struct vcpu
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
-	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb);
 	if (!nested_vmcb)
 		return 1;
 
@@ -1662,7 +1662,7 @@ static int nested_svm_vmexit(struct vcpu
 	/* Exit nested SVM mode */
 	svm->nested.vmcb = 0;
 
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(nested_vmcb);
 
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
@@ -1675,7 +1675,7 @@ static bool nested_svm_vmrun_msrpm(struc
 	u32 *nested_msrpm;
 	int i;
 
-	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER0);
+	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm);
 	if (!nested_msrpm)
 		return false;
 
@@ -1684,7 +1684,7 @@ static bool nested_svm_vmrun_msrpm(struc
 
 	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
 
-	nested_svm_unmap(nested_msrpm, KM_USER0);
+	nested_svm_unmap(nested_msrpm);
 
 	return true;
 }
@@ -1695,7 +1695,7 @@ static bool nested_svm_vmrun(struct vcpu
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax);
 	if (!nested_vmcb)
 		return false;
 
@@ -1814,7 +1814,7 @@ static bool nested_svm_vmrun(struct vcpu
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(nested_vmcb);
 
 	enable_gif(svm);
 
@@ -1847,12 +1847,12 @@ static int vmload_interception(struct vc
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax);
 	if (!nested_vmcb)
 		return 1;
 
 	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(nested_vmcb);
 
 	return 1;
 }
@@ -1867,12 +1867,12 @@ static int vmsave_interception(struct vc
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax);
 	if (!nested_vmcb)
 		return 1;
 
 	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(nested_vmcb);
 
 	return 1;
 }
Index: linux-2.6/arch/x86/kvm/x86.c
===================================================================
--- linux-2.6.orig/arch/x86/kvm/x86.c
+++ linux-2.6/arch/x86/kvm/x86.c
@@ -685,12 +685,12 @@ static void kvm_write_guest_time(struct 
 	 */
 	vcpu->hv_clock.version += 2;
 
-	shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
+	shared_kaddr = kmap_atomic_push(vcpu->time_page);
 
 	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
 	       sizeof(vcpu->hv_clock));
 
-	kunmap_atomic(shared_kaddr, KM_USER0);
+	kmap_atomic_pop(shared_kaddr);
 
 	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
 }
@@ -2668,9 +2668,9 @@ static int emulator_cmpxchg_emulated(uns
 
 		page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		set_64bit((u64 *)(kaddr + offset_in_page(gpa)), val);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		kvm_release_page_dirty(page);
 	}
 emul_write:
Index: linux-2.6/arch/x86/lib/usercopy_32.c
===================================================================
--- linux-2.6.orig/arch/x86/lib/usercopy_32.c
+++ linux-2.6/arch/x86/lib/usercopy_32.c
@@ -760,9 +760,9 @@ survive:
 				break;
 			}
 
-			maddr = kmap_atomic(pg, KM_USER0);
+			maddr = kmap_atomic_push(pg);
 			memcpy(maddr + offset, from, len);
-			kunmap_atomic(maddr, KM_USER0);
+			kmap_atomic_pop(maddr);
 			set_page_dirty_lock(pg);
 			put_page(pg);
 			up_read(&current->mm->mmap_sem);
Index: linux-2.6/arch/x86/mm/highmem_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/highmem_32.c
+++ linux-2.6/arch/x86/mm/highmem_32.c
@@ -20,14 +20,14 @@ void kunmap(struct page *page)
 }
 
 /*
- * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
+ * kmap_atomic_push/kmap_atomic_pop is significantly faster than kmap/kunmap because
  * no global lock is needed and because the kmap code must perform a global TLB
  * invalidation when the kmap pool wraps.
  *
  * However when holding an atomic kmap it is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  */
-void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
+void *kmap_atomic_push_prot(struct page *page, pgprot_t prot)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
@@ -38,9 +38,7 @@ void *kmap_atomic_prot(struct page *page
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic(type);
-
-	idx = type + KM_TYPE_NR*smp_processor_id();
+	idx = kmap_atomic_push_idx() + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
@@ -48,15 +46,15 @@ void *kmap_atomic_prot(struct page *page
 	return (void *)vaddr;
 }
 
-void *kmap_atomic(struct page *page, enum km_type type)
+void *kmap_atomic_push(struct page *page)
 {
-	return kmap_atomic_prot(page, type, kmap_prot);
+	return kmap_atomic_push_prot(page, kmap_prot);
 }
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void kmap_atomic_pop(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
+	enum fixed_addresses idx = kmap_atomic_pop_idx() + KM_TYPE_NR*smp_processor_id();
 
 	/*
 	 * Force other mappings to Oops if they'll try to access this pte
@@ -76,15 +74,30 @@ void kunmap_atomic(void *kvaddr, enum km
 	pagefault_enable();
 }
 
+void *kmap_atomic_push_prot_pfn(unsigned long pfn, pgprot_t prot)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+
+	pagefault_disable();
+
+	idx = kmap_atomic_push_idx() + KM_TYPE_NR * smp_processor_id();
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
+	arch_flush_lazy_mmu_mode();
+
+	return (void *)vaddr;
+}
+
 /*
- * This is the same as kmap_atomic() but can map memory that doesn't
+ * This is the same as kmap_atomic_push() but can map memory that doesn't
  * have a struct page associated with it.
  */
-void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
+void *kmap_atomic_push_pfn(unsigned long pfn)
 {
-	return kmap_atomic_prot_pfn(pfn, type, kmap_prot);
+	return kmap_atomic_push_prot_pfn(pfn, kmap_prot);
 }
-EXPORT_SYMBOL_GPL(kmap_atomic_pfn); /* temporarily in use by i915 GEM until vmap */
+EXPORT_SYMBOL_GPL(kmap_atomic_push_pfn); /* temporarily in use by i915 GEM until vmap */
 
 struct page *kmap_atomic_to_page(void *ptr)
 {
@@ -101,9 +114,9 @@ struct page *kmap_atomic_to_page(void *p
 
 EXPORT_SYMBOL(kmap);
 EXPORT_SYMBOL(kunmap);
-EXPORT_SYMBOL(kmap_atomic);
-EXPORT_SYMBOL(kunmap_atomic);
-EXPORT_SYMBOL(kmap_atomic_prot);
+EXPORT_SYMBOL(kmap_atomic_push);
+EXPORT_SYMBOL(kmap_atomic_pop);
+EXPORT_SYMBOL(kmap_atomic_push_prot);
 EXPORT_SYMBOL(kmap_atomic_to_page);
 
 void __init set_highmem_pages_init(void)
Index: linux-2.6/arch/x86/mm/iomap_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/iomap_32.c
+++ linux-2.6/arch/x86/mm/iomap_32.c
@@ -55,56 +55,26 @@ iomap_free(resource_size_t base, unsigne
 }
 EXPORT_SYMBOL_GPL(iomap_free);
 
-void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
-{
-	enum fixed_addresses idx;
-	unsigned long vaddr;
-
-	pagefault_disable();
-
-	debug_kmap_atomic(type);
-	idx = type + KM_TYPE_NR * smp_processor_id();
-	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
-	arch_flush_lazy_mmu_mode();
-
-	return (void *)vaddr;
-}
-
 /*
  * Map 'pfn' using fixed map 'type' and protections 'prot'
  */
-void *
-iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
+void *iomap_atomic_push_prot_pfn(unsigned long pfn, pgprot_t prot)
 {
-	/*
-	 * For non-PAT systems, promote PAGE_KERNEL_WC to PAGE_KERNEL_UC_MINUS.
-	 * PAGE_KERNEL_WC maps to PWT, which translates to uncached if the
-	 * MTRR is UC or WC.  UC_MINUS gets the real intention, of the
-	 * user, which is "WC if the MTRR is WC, UC if you can't do that."
-	 */
-	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
-		prot = PAGE_KERNEL_UC_MINUS;
+       /*
+        * For non-PAT systems, promote PAGE_KERNEL_WC to PAGE_KERNEL_UC_MINUS.
+        * PAGE_KERNEL_WC maps to PWT, which translates to uncached if the
+        * MTRR is UC or WC.  UC_MINUS gets the real intention, of the
+        * user, which is "WC if the MTRR is WC, UC if you can't do that."
+        */
+       if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
+               prot = PAGE_KERNEL_UC_MINUS;
 
-	return kmap_atomic_prot_pfn(pfn, type, prot);
+       return kmap_atomic_push_prot_pfn(pfn, prot);
 }
-EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
+EXPORT_SYMBOL_GPL(iomap_atomic_push_prot_pfn);
 
-void
-iounmap_atomic(void *kvaddr, enum km_type type)
+void iomap_atomic_pop(void *kvaddr)
 {
-	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
-
-	/*
-	 * Force other mappings to Oops if they'll try to access this pte
-	 * without first remap it.  Keeping stale mappings around is a bad idea
-	 * also, in case the page changes cacheability attributes or becomes
-	 * a protected page in a hypervisor.
-	 */
-	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
-		kpte_clear_flush(kmap_pte-idx, vaddr);
-
-	pagefault_enable();
+	kmap_atomic_pop(kvaddr);
 }
-EXPORT_SYMBOL_GPL(iounmap_atomic);
+EXPORT_SYMBOL_GPL(iomap_atomic_pop);
Index: linux-2.6/arch/x86/xen/mmu.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/mmu.c
+++ linux-2.6/arch/x86/xen/mmu.c
@@ -1428,7 +1428,7 @@ static void xen_pgd_free(struct mm_struc
 }
 
 #ifdef CONFIG_HIGHPTE
-static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
+static void *xen_kmap_atomic_push_pte(struct page *page, enum km_type type)
 {
 	pgprot_t prot = PAGE_KERNEL;
 
@@ -1440,7 +1440,7 @@ static void *xen_kmap_atomic_pte(struct 
 		       page_to_pfn(page), type,
 		       (unsigned long)pgprot_val(prot) & _PAGE_RW ? "WRITE" : "READ");
 
-	return kmap_atomic_prot(page, type, prot);
+	return kmap_atomic_push_prot(page, type, prot);
 }
 #endif
 
@@ -1903,7 +1903,7 @@ static const struct pv_mmu_ops xen_mmu_o
 	.release_pmd = xen_release_pmd_init,
 
 #ifdef CONFIG_HIGHPTE
-	.kmap_atomic_pte = xen_kmap_atomic_pte,
+	.kmap_atomic_push_pte = xen_kmap_atomic_push_pte,
 #endif
 
 #ifdef CONFIG_X86_64
Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c
+++ linux-2.6/block/blk-settings.c
@@ -125,7 +125,7 @@ EXPORT_SYMBOL(blk_set_default_limits);
  * Caveat:
  *    The driver that does this *must* be able to deal appropriately
  *    with buffers in "highmemory". This can be accomplished by either calling
- *    __bio_kmap_atomic() to get a temporary kernel mapping, or by calling
+ *    __bio_kmap_atomic_push() to get a temporary kernel mapping, or by calling
  *    blk_queue_bounce() to create a buffer in normal memory.
  **/
 void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
Index: linux-2.6/crypto/ahash.c
===================================================================
--- linux-2.6.orig/crypto/ahash.c
+++ linux-2.6/crypto/ahash.c
@@ -44,7 +44,7 @@ static int hash_walk_next(struct crypto_
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
-	walk->data = crypto_kmap(walk->pg, 0);
+	walk->data = kmap_atomic_push(walk->pg);
 	walk->data += offset;
 
 	if (offset & alignmask)
@@ -89,7 +89,7 @@ int crypto_hash_walk_done(struct crypto_
 		return nbytes;
 	}
 
-	crypto_kunmap(walk->data, 0);
+	kmap_atomic_pop(walk->data);
 	crypto_yield(walk->flags);
 
 	if (err)
Index: linux-2.6/crypto/async_tx/async_memcpy.c
===================================================================
--- linux-2.6.orig/crypto/async_tx/async_memcpy.c
+++ linux-2.6/crypto/async_tx/async_memcpy.c
@@ -78,13 +78,13 @@ async_memcpy(struct page *dest, struct p
 		/* wait for any prerequisite operations */
 		async_tx_quiesce(&submit->depend_tx);
 
-		dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
-		src_buf = kmap_atomic(src, KM_USER1) + src_offset;
+		dest_buf = kmap_atomic_push(dest) + dest_offset;
+		src_buf = kmap_atomic_push(src) + src_offset;
 
 		memcpy(dest_buf, src_buf, len);
 
-		kunmap_atomic(dest_buf, KM_USER0);
-		kunmap_atomic(src_buf, KM_USER1);
+		kmap_atomic_pop(src_buf);
+		kmap_atomic_pop(dest_buf);
 
 		async_tx_sync_epilog(submit);
 	}
Index: linux-2.6/crypto/blkcipher.c
===================================================================
--- linux-2.6.orig/crypto/blkcipher.c
+++ linux-2.6/crypto/blkcipher.c
@@ -41,22 +41,22 @@ static int blkcipher_walk_first(struct b
 
 static inline void blkcipher_map_src(struct blkcipher_walk *walk)
 {
-	walk->src.virt.addr = scatterwalk_map(&walk->in, 0);
+	walk->src.virt.addr = scatterwalk_map(&walk->in);
 }
 
 static inline void blkcipher_map_dst(struct blkcipher_walk *walk)
 {
-	walk->dst.virt.addr = scatterwalk_map(&walk->out, 1);
+	walk->dst.virt.addr = scatterwalk_map(&walk->out);
 }
 
 static inline void blkcipher_unmap_src(struct blkcipher_walk *walk)
 {
-	scatterwalk_unmap(walk->src.virt.addr, 0);
+	scatterwalk_unmap(walk->src.virt.addr);
 }
 
 static inline void blkcipher_unmap_dst(struct blkcipher_walk *walk)
 {
-	scatterwalk_unmap(walk->dst.virt.addr, 1);
+	scatterwalk_unmap(walk->dst.virt.addr);
 }
 
 /* Get a spot of the specified length that does not straddle a page.
@@ -89,9 +89,9 @@ static inline unsigned int blkcipher_don
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		blkcipher_unmap_dst(walk);
 	} else if (!(walk->flags & BLKCIPHER_WALK_PHYS)) {
-		blkcipher_unmap_src(walk);
 		if (walk->flags & BLKCIPHER_WALK_DIFF)
 			blkcipher_unmap_dst(walk);
+		blkcipher_unmap_src(walk);
 	}
 
 	scatterwalk_advance(&walk->in, n);
Index: linux-2.6/crypto/ccm.c
===================================================================
--- linux-2.6.orig/crypto/ccm.c
+++ linux-2.6/crypto/ccm.c
@@ -216,12 +216,12 @@ static void get_data_to_compute(struct c
 			scatterwalk_start(&walk, sg_next(walk.sg));
 			n = scatterwalk_clamp(&walk, len);
 		}
-		data_src = scatterwalk_map(&walk, 0);
+		data_src = scatterwalk_map(&walk);
 
 		compute_mac(tfm, data_src, n, pctx);
 		len -= n;
 
-		scatterwalk_unmap(data_src, 0);
+		scatterwalk_unmap(data_src);
 		scatterwalk_advance(&walk, n);
 		scatterwalk_done(&walk, 0, len);
 		if (len)
Index: linux-2.6/crypto/digest.c
===================================================================
--- linux-2.6.orig/crypto/digest.c
+++ linux-2.6/crypto/digest.c
@@ -54,7 +54,7 @@ static int update2(struct hash_desc *des
 			unsigned int bytes_from_page = min(l, ((unsigned int)
 							   (PAGE_SIZE)) - 
 							   offset);
-			char *src = crypto_kmap(pg, 0);
+			char *src = kmap_atomic_push(pg);
 			char *p = src + offset;
 
 			if (unlikely(offset & alignmask)) {
@@ -69,7 +69,7 @@ static int update2(struct hash_desc *des
 			}
 			tfm->__crt_alg->cra_digest.dia_update(tfm, p,
 							      bytes_from_page);
-			crypto_kunmap(src, 0);
+			kmap_atomic_pop(src);
 			crypto_yield(desc->flags);
 			offset = 0;
 			pg++;
Index: linux-2.6/crypto/scatterwalk.c
===================================================================
--- linux-2.6.orig/crypto/scatterwalk.c
+++ linux-2.6/crypto/scatterwalk.c
@@ -40,9 +40,9 @@ void scatterwalk_start(struct scatter_wa
 }
 EXPORT_SYMBOL_GPL(scatterwalk_start);
 
-void *scatterwalk_map(struct scatter_walk *walk, int out)
+void *scatterwalk_map(struct scatter_walk *walk)
 {
-	return crypto_kmap(scatterwalk_page(walk), out) +
+	return kmap_atomic_push(scatterwalk_page(walk)) +
 	       offset_in_page(walk->offset);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_map);
@@ -83,9 +83,9 @@ void scatterwalk_copychunks(void *buf, s
 		if (len_this_page > nbytes)
 			len_this_page = nbytes;
 
-		vaddr = scatterwalk_map(walk, out);
+		vaddr = scatterwalk_map(walk);
 		memcpy_dir(buf, vaddr, len_this_page, out);
-		scatterwalk_unmap(vaddr, out);
+		scatterwalk_unmap(vaddr);
 
 		scatterwalk_advance(walk, len_this_page);
 
Index: linux-2.6/crypto/shash.c
===================================================================
--- linux-2.6.orig/crypto/shash.c
+++ linux-2.6/crypto/shash.c
@@ -279,10 +279,10 @@ int shash_ahash_digest(struct ahash_requ
 	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
 		void *data;
 
-		data = crypto_kmap(sg_page(sg), 0);
+		data = kmap_atomic_push(sg_page(sg));
 		err = crypto_shash_digest(desc, data + offset, nbytes,
 					  req->result);
-		crypto_kunmap(data, 0);
+		kmap_atomic_pop(data);
 		crypto_yield(desc->flags);
 	} else
 		err = crypto_shash_init(desc) ?:
@@ -412,9 +412,9 @@ static int shash_compat_digest(struct ha
 
 		desc->flags = hdesc->flags;
 
-		data = crypto_kmap(sg_page(sg), 0);
+		data = kmap_atomic_push(sg_page(sg));
 		err = crypto_shash_digest(desc, data + offset, nbytes, out);
-		crypto_kunmap(data, 0);
+		kmap_atomic_pop(data);
 		crypto_yield(desc->flags);
 		goto out;
 	}
Index: linux-2.6/drivers/ata/libata-sff.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-sff.c
+++ linux-2.6/drivers/ata/libata-sff.c
@@ -879,13 +879,13 @@ static void ata_pio_sector(struct ata_qu
 
 		/* FIXME: use a bounce buffer */
 		local_irq_save(flags);
-		buf = kmap_atomic(page, KM_IRQ0);
+		buf = kmap_atomic_push(page);
 
 		/* do the actual data transfer */
 		ap->ops->sff_data_xfer(qc->dev, buf + offset, qc->sect_size,
 				       do_write);
 
-		kunmap_atomic(buf, KM_IRQ0);
+		kmap_atomic_pop(buf);
 		local_irq_restore(flags);
 	} else {
 		buf = page_address(page);
@@ -1017,13 +1017,13 @@ next_sg:
 
 		/* FIXME: use bounce buffer */
 		local_irq_save(flags);
-		buf = kmap_atomic(page, KM_IRQ0);
+		buf = kmap_atomic_push(page);
 
 		/* do the actual data transfer */
 		consumed = ap->ops->sff_data_xfer(dev,  buf + offset,
 								count, rw);
 
-		kunmap_atomic(buf, KM_IRQ0);
+		kmap_atomic_pop(buf);
 		local_irq_restore(flags);
 	} else {
 		buf = page_address(page);
Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -204,9 +204,9 @@ static void copy_to_brd(struct brd_devic
 	page = brd_lookup_page(brd, sector);
 	BUG_ON(!page);
 
-	dst = kmap_atomic(page, KM_USER1);
+	dst = kmap_atomic_push(page);
 	memcpy(dst + offset, src, copy);
-	kunmap_atomic(dst, KM_USER1);
+	kmap_atomic_pop(dst);
 
 	if (copy < n) {
 		src += copy;
@@ -215,9 +215,9 @@ static void copy_to_brd(struct brd_devic
 		page = brd_lookup_page(brd, sector);
 		BUG_ON(!page);
 
-		dst = kmap_atomic(page, KM_USER1);
+		dst = kmap_atomic_push(page);
 		memcpy(dst, src, copy);
-		kunmap_atomic(dst, KM_USER1);
+		kmap_atomic_pop(dst);
 	}
 }
 
@@ -235,9 +235,9 @@ static void copy_from_brd(void *dst, str
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	if (page) {
-		src = kmap_atomic(page, KM_USER1);
+		src = kmap_atomic_push(page);
 		memcpy(dst, src + offset, copy);
-		kunmap_atomic(src, KM_USER1);
+		kmap_atomic_pop(src);
 	} else
 		memset(dst, 0, copy);
 
@@ -247,9 +247,9 @@ static void copy_from_brd(void *dst, str
 		copy = n - copy;
 		page = brd_lookup_page(brd, sector);
 		if (page) {
-			src = kmap_atomic(page, KM_USER1);
+			src = kmap_atomic_push(page);
 			memcpy(dst, src, copy);
-			kunmap_atomic(src, KM_USER1);
+			kmap_atomic_pop(src);
 		} else
 			memset(dst, 0, copy);
 	}
@@ -271,7 +271,7 @@ static int brd_do_bvec(struct brd_device
 			goto out;
 	}
 
-	mem = kmap_atomic(page, KM_USER0);
+	mem = kmap_atomic_push(page);
 	if (rw == READ) {
 		copy_from_brd(mem + off, brd, sector, len);
 		flush_dcache_page(page);
@@ -279,7 +279,7 @@ static int brd_do_bvec(struct brd_device
 		flush_dcache_page(page);
 		copy_to_brd(brd, mem + off, sector, len);
 	}
-	kunmap_atomic(mem, KM_USER0);
+	kmap_atomic_pop(mem);
 
 out:
 	return err;
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c
+++ linux-2.6/drivers/block/loop.c
@@ -91,16 +91,16 @@ static int transfer_none(struct loop_dev
 			 struct page *loop_page, unsigned loop_off,
 			 int size, sector_t real_block)
 {
-	char *raw_buf = kmap_atomic(raw_page, KM_USER0) + raw_off;
-	char *loop_buf = kmap_atomic(loop_page, KM_USER1) + loop_off;
+	char *raw_buf = kmap_atomic_push(raw_page) + raw_off;
+	char *loop_buf = kmap_atomic_push(loop_page) + loop_off;
 
 	if (cmd == READ)
 		memcpy(loop_buf, raw_buf, size);
 	else
 		memcpy(raw_buf, loop_buf, size);
 
-	kunmap_atomic(raw_buf, KM_USER0);
-	kunmap_atomic(loop_buf, KM_USER1);
+	kmap_atomic_pop(loop_buf);
+	kmap_atomic_pop(raw_buf);
 	cond_resched();
 	return 0;
 }
@@ -110,8 +110,8 @@ static int transfer_xor(struct loop_devi
 			struct page *loop_page, unsigned loop_off,
 			int size, sector_t real_block)
 {
-	char *raw_buf = kmap_atomic(raw_page, KM_USER0) + raw_off;
-	char *loop_buf = kmap_atomic(loop_page, KM_USER1) + loop_off;
+	char *raw_buf = kmap_atomic_push(raw_page) + raw_off;
+	char *loop_buf = kmap_atomic_push(loop_page) + loop_off;
 	char *in, *out, *key;
 	int i, keysize;
 
@@ -128,8 +128,8 @@ static int transfer_xor(struct loop_devi
 	for (i = 0; i < size; i++)
 		*out++ = *in++ ^ key[(i & 511) % keysize];
 
-	kunmap_atomic(raw_buf, KM_USER0);
-	kunmap_atomic(loop_buf, KM_USER1);
+	kmap_atomic_pop(loop_buf);
+	kmap_atomic_pop(raw_buf);
 	cond_resched();
 	return 0;
 }
Index: linux-2.6/drivers/block/pktcdvd.c
===================================================================
--- linux-2.6.orig/drivers/block/pktcdvd.c
+++ linux-2.6/drivers/block/pktcdvd.c
@@ -1021,14 +1021,14 @@ static void pkt_copy_bio_data(struct bio
 
 	while (copy_size > 0) {
 		struct bio_vec *src_bvl = bio_iovec_idx(src_bio, seg);
-		void *vfrom = kmap_atomic(src_bvl->bv_page, KM_USER0) +
+		void *vfrom = kmap_atomic_push(src_bvl->bv_page) +
 			src_bvl->bv_offset + offs;
 		void *vto = page_address(dst_page) + dst_offs;
 		int len = min_t(int, copy_size, src_bvl->bv_len - offs);
 
 		BUG_ON(len < 0);
 		memcpy(vto, vfrom, len);
-		kunmap_atomic(vfrom, KM_USER0);
+		kmap_atomic_pop(vfrom);
 
 		seg++;
 		offs = 0;
@@ -1053,10 +1053,10 @@ static void pkt_make_local_copy(struct p
 	offs = 0;
 	for (f = 0; f < pkt->frames; f++) {
 		if (bvec[f].bv_page != pkt->pages[p]) {
-			void *vfrom = kmap_atomic(bvec[f].bv_page, KM_USER0) + bvec[f].bv_offset;
+			void *vfrom = kmap_atomic_push(bvec[f].bv_page) + bvec[f].bv_offset;
 			void *vto = page_address(pkt->pages[p]) + offs;
 			memcpy(vto, vfrom, CD_FRAMESIZE);
-			kunmap_atomic(vfrom, KM_USER0);
+			kmap_atomic_pop(vfrom);
 			bvec[f].bv_page = pkt->pages[p];
 			bvec[f].bv_offset = offs;
 		} else {
Index: linux-2.6/drivers/crypto/hifn_795x.c
===================================================================
--- linux-2.6.orig/drivers/crypto/hifn_795x.c
+++ linux-2.6/drivers/crypto/hifn_795x.c
@@ -1731,9 +1731,9 @@ static int ablkcipher_get(void *saddr, u
 	while (size) {
 		copy = min(srest, min(dst->length, size));
 
-		daddr = kmap_atomic(sg_page(dst), KM_IRQ0);
+		daddr = kmap_atomic_push(sg_page(dst));
 		memcpy(daddr + dst->offset + offset, saddr, copy);
-		kunmap_atomic(daddr, KM_IRQ0);
+		kmap_atomic_pop(daddr);
 
 		nbytes -= copy;
 		size -= copy;
@@ -1793,17 +1793,17 @@ static void hifn_process_ready(struct ab
 				continue;
 			}
 
-			saddr = kmap_atomic(sg_page(t), KM_SOFTIRQ0);
+			saddr = kmap_atomic_push(sg_page(t));
 
 			err = ablkcipher_get(saddr, &t->length, t->offset,
 					dst, nbytes, &nbytes);
 			if (err < 0) {
-				kunmap_atomic(saddr, KM_SOFTIRQ0);
+				kmap_atomic_pop(saddr);
 				break;
 			}
 
 			idx += err;
-			kunmap_atomic(saddr, KM_SOFTIRQ0);
+			kmap_atomic_pop(saddr);
 		}
 
 		ablkcipher_walk_exit(&rctx->walk);
Index: linux-2.6/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.orig/drivers/edac/edac_mc.c
+++ linux-2.6/drivers/edac/edac_mc.c
@@ -588,13 +588,13 @@ static void edac_mc_scrub_block(unsigned
 	if (PageHighMem(pg))
 		local_irq_save(flags);
 
-	virt_addr = kmap_atomic(pg, KM_BOUNCE_READ);
+	virt_addr = kmap_atomic_push(pg);
 
 	/* Perform architecture specific atomic scrub operation */
 	atomic_scrub(virt_addr + offset, size);
 
 	/* Unmap and complete */
-	kunmap_atomic(virt_addr, KM_BOUNCE_READ);
+	kmap_atomic_pop(virt_addr);
 
 	if (PageHighMem(pg))
 		local_irq_restore(flags);
Index: linux-2.6/drivers/gpu/drm/drm_cache.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/drm_cache.c
+++ linux-2.6/drivers/gpu/drm/drm_cache.c
@@ -40,10 +40,10 @@ drm_clflush_page(struct page *page)
 	if (unlikely(page == NULL))
 		return;
 
-	page_virtual = kmap_atomic(page, KM_USER0);
+	page_virtual = kmap_atomic_push(page);
 	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
 		clflush(page_virtual + i);
-	kunmap_atomic(page_virtual, KM_USER0);
+	kmap_atomic_pop(page_virtual);
 }
 
 static void drm_cache_flush_clflush(struct page *pages[],
@@ -86,10 +86,10 @@ drm_clflush_pages(struct page *pages[], 
 		if (unlikely(page == NULL))
 			continue;
 
-		page_virtual = kmap_atomic(page, KM_USER0);
+		page_virtual = kmap_atomic_push(page);
 		flush_dcache_range((unsigned long)page_virtual,
 				   (unsigned long)page_virtual + PAGE_SIZE);
-		kunmap_atomic(page_virtual, KM_USER0);
+		kmap_atomic_pop(page_virtual);
 	}
 #else
 	printk(KERN_ERR "Architecture has no drm_cache.c support\n");
Index: linux-2.6/drivers/gpu/drm/i915/i915_gem.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/i915/i915_gem.c
+++ linux-2.6/drivers/gpu/drm/i915/i915_gem.c
@@ -149,11 +149,11 @@ fast_shmem_read(struct page **pages,
 	char __iomem *vaddr;
 	int unwritten;
 
-	vaddr = kmap_atomic(pages[page_base >> PAGE_SHIFT], KM_USER0);
+	vaddr = kmap_atomic_push(pages[page_base >> PAGE_SHIFT]);
 	if (vaddr == NULL)
 		return -ENOMEM;
 	unwritten = __copy_to_user_inatomic(data, vaddr + page_offset, length);
-	kunmap_atomic(vaddr, KM_USER0);
+	kmap_atomic_pop(vaddr);
 
 	if (unwritten)
 		return -EFAULT;
@@ -179,20 +179,20 @@ slow_shmem_copy(struct page *dst_page,
 {
 	char *dst_vaddr, *src_vaddr;
 
-	dst_vaddr = kmap_atomic(dst_page, KM_USER0);
+	dst_vaddr = kmap_atomic_push(dst_page);
 	if (dst_vaddr == NULL)
 		return -ENOMEM;
 
-	src_vaddr = kmap_atomic(src_page, KM_USER1);
+	src_vaddr = kmap_atomic_push(src_page);
 	if (src_vaddr == NULL) {
-		kunmap_atomic(dst_vaddr, KM_USER0);
+		kmap_atomic_pop(dst_vaddr);
 		return -ENOMEM;
 	}
 
 	memcpy(dst_vaddr + dst_offset, src_vaddr + src_offset, length);
 
-	kunmap_atomic(src_vaddr, KM_USER1);
-	kunmap_atomic(dst_vaddr, KM_USER0);
+	kmap_atomic_pop(src_vaddr);
+	kmap_atomic_pop(dst_vaddr);
 
 	return 0;
 }
@@ -217,13 +217,13 @@ slow_shmem_bit17_copy(struct page *gpu_p
 					       cpu_page, cpu_offset, length);
 	}
 
-	gpu_vaddr = kmap_atomic(gpu_page, KM_USER0);
+	gpu_vaddr = kmap_atomic_push(gpu_page);
 	if (gpu_vaddr == NULL)
 		return -ENOMEM;
 
-	cpu_vaddr = kmap_atomic(cpu_page, KM_USER1);
+	cpu_vaddr = kmap_atomic_push(cpu_page);
 	if (cpu_vaddr == NULL) {
-		kunmap_atomic(gpu_vaddr, KM_USER0);
+		kmap_atomic_pop(gpu_vaddr);
 		return -ENOMEM;
 	}
 
@@ -249,8 +249,8 @@ slow_shmem_bit17_copy(struct page *gpu_p
 		length -= this_length;
 	}
 
-	kunmap_atomic(cpu_vaddr, KM_USER1);
-	kunmap_atomic(gpu_vaddr, KM_USER0);
+	kmap_atomic_pop(cpu_vaddr);
+	kmap_atomic_pop(gpu_vaddr);
 
 	return 0;
 }
@@ -558,11 +558,11 @@ slow_kernel_write(struct io_mapping *map
 	unsigned long unwritten;
 
 	dst_vaddr = io_mapping_map_atomic_wc(mapping, gtt_base);
-	src_vaddr = kmap_atomic(user_page, KM_USER1);
+	src_vaddr = kmap_atomic_push(user_page);
 	unwritten = __copy_from_user_inatomic_nocache(dst_vaddr + gtt_offset,
 						      src_vaddr + user_offset,
 						      length);
-	kunmap_atomic(src_vaddr, KM_USER1);
+	kmap_atomic_pop(src_vaddr);
 	io_mapping_unmap_atomic(dst_vaddr);
 	if (unwritten)
 		return -EFAULT;
@@ -578,11 +578,11 @@ fast_shmem_write(struct page **pages,
 	char __iomem *vaddr;
 	unsigned long unwritten;
 
-	vaddr = kmap_atomic(pages[page_base >> PAGE_SHIFT], KM_USER0);
+	vaddr = kmap_atomic_push(pages[page_base >> PAGE_SHIFT]);
 	if (vaddr == NULL)
 		return -ENOMEM;
 	unwritten = __copy_from_user_inatomic(vaddr + page_offset, data, length);
-	kunmap_atomic(vaddr, KM_USER0);
+	kmap_atomic_pop(vaddr);
 
 	if (unwritten)
 		return -EFAULT;
@@ -662,7 +662,7 @@ fail:
 
 /**
  * This is the fallback GTT pwrite path, which uses get_user_pages to pin
- * the memory and maps it using kmap_atomic for copying.
+ * the memory and maps it using kmap_atomic_push for copying.
  *
  * This code resulted in x11perf -rgb10text consuming about 10% more CPU
  * than using i915_gem_gtt_pwrite_fast on a G45 (32-bit).
@@ -836,7 +836,7 @@ fail_unlock:
 
 /**
  * This is the fallback shmem pwrite path, which uses get_user_pages to pin
- * the memory and maps it using kmap_atomic for copying.
+ * the memory and maps it using kmap_atomic_push for copying.
  *
  * This avoids taking mmap_sem for faulting on the user's address while the
  * struct_mutex is held.
@@ -4697,11 +4697,11 @@ void i915_gem_detach_phys_object(struct 
 	page_count = obj->size / PAGE_SIZE;
 
 	for (i = 0; i < page_count; i++) {
-		char *dst = kmap_atomic(obj_priv->pages[i], KM_USER0);
+		char *dst = kmap_atomic_push(obj_priv->pages[i]);
 		char *src = obj_priv->phys_obj->handle->vaddr + (i * PAGE_SIZE);
 
 		memcpy(dst, src, PAGE_SIZE);
-		kunmap_atomic(dst, KM_USER0);
+		kmap_atomic_pop(dst);
 	}
 	drm_clflush_pages(obj_priv->pages, page_count);
 	drm_agp_chipset_flush(dev);
@@ -4757,11 +4757,11 @@ i915_gem_attach_phys_object(struct drm_d
 	page_count = obj->size / PAGE_SIZE;
 
 	for (i = 0; i < page_count; i++) {
-		char *src = kmap_atomic(obj_priv->pages[i], KM_USER0);
+		char *src = kmap_atomic_push(obj_priv->pages[i]);
 		char *dst = obj_priv->phys_obj->handle->vaddr + (i * PAGE_SIZE);
 
 		memcpy(dst, src, PAGE_SIZE);
-		kunmap_atomic(src, KM_USER0);
+		kmap_atomic_pop(src);
 	}
 
 	i915_gem_object_put_pages(obj);
Index: linux-2.6/drivers/gpu/drm/i915/i915_gem_debug.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/i915/i915_gem_debug.c
+++ linux-2.6/drivers/gpu/drm/i915/i915_gem_debug.c
@@ -57,13 +57,13 @@ static void
 i915_gem_dump_page(struct page *page, uint32_t start, uint32_t end,
 		   uint32_t bias, uint32_t mark)
 {
-	uint32_t *mem = kmap_atomic(page, KM_USER0);
+	uint32_t *mem = kmap_atomic_push(page);
 	int i;
 	for (i = start; i < end; i += 4)
 		DRM_INFO("%08x: %08x%s\n",
 			  (int) (bias + i), mem[i / 4],
 			  (bias + i == mark) ? " ********" : "");
-	kunmap_atomic(mem, KM_USER0);
+	kmap_atomic_pop(mem);
 	/* give syslog time to catch up */
 	msleep(1);
 }
@@ -157,7 +157,7 @@ i915_gem_object_check_coherency(struct d
 	for (page = 0; page < obj->size / PAGE_SIZE; page++) {
 		int i;
 
-		backing_map = kmap_atomic(obj_priv->pages[page], KM_USER0);
+		backing_map = kmap_atomic_push(obj_priv->pages[page]);
 
 		if (backing_map == NULL) {
 			DRM_ERROR("failed to map backing page\n");
@@ -181,13 +181,13 @@ i915_gem_object_check_coherency(struct d
 				}
 			}
 		}
-		kunmap_atomic(backing_map, KM_USER0);
+		kmap_atomic_pop(backing_map);
 		backing_map = NULL;
 	}
 
  out:
 	if (backing_map != NULL)
-		kunmap_atomic(backing_map, KM_USER0);
+		kmap_atomic_pop(backing_map);
 	iounmap(gtt_mapping);
 
 	/* give syslog time to catch up */
Index: linux-2.6/drivers/gpu/drm/ttm/ttm_bo_util.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ linux-2.6/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -148,7 +148,7 @@ static int ttm_copy_io_ttm_page(struct t
 	src = (void *)((unsigned long)src + (page << PAGE_SHIFT));
 
 #ifdef CONFIG_X86
-	dst = kmap_atomic_prot(d, KM_USER0, prot);
+	dst = kmap_atomic_push_prot(d);
 #else
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		dst = vmap(&d, 1, 0, prot);
@@ -161,7 +161,7 @@ static int ttm_copy_io_ttm_page(struct t
 	memcpy_fromio(dst, src, PAGE_SIZE);
 
 #ifdef CONFIG_X86
-	kunmap_atomic(dst, KM_USER0);
+	kmap_atomic_pop(dst);
 #else
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		vunmap(dst);
@@ -184,7 +184,7 @@ static int ttm_copy_ttm_io_page(struct t
 
 	dst = (void *)((unsigned long)dst + (page << PAGE_SHIFT));
 #ifdef CONFIG_X86
-	src = kmap_atomic_prot(s, KM_USER0, prot);
+	src = kmap_atomic_push_prot(s);
 #else
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		src = vmap(&s, 1, 0, prot);
@@ -197,7 +197,7 @@ static int ttm_copy_ttm_io_page(struct t
 	memcpy_toio(dst, src, PAGE_SIZE);
 
 #ifdef CONFIG_X86
-	kunmap_atomic(src, KM_USER0);
+	kmap_atomic_pop(src);
 #else
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		vunmap(src);
Index: linux-2.6/drivers/gpu/drm/ttm/ttm_tt.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/ttm/ttm_tt.c
+++ linux-2.6/drivers/gpu/drm/ttm/ttm_tt.c
@@ -491,11 +491,11 @@ static int ttm_tt_swapin(struct ttm_tt *
 			goto out_err;
 
 		preempt_disable();
-		from_virtual = kmap_atomic(from_page, KM_USER0);
-		to_virtual = kmap_atomic(to_page, KM_USER1);
+		from_virtual = kmap_atomic_push(from_page);
+		to_virtual = kmap_atomic_push(to_page);
 		memcpy(to_virtual, from_virtual, PAGE_SIZE);
-		kunmap_atomic(to_virtual, KM_USER1);
-		kunmap_atomic(from_virtual, KM_USER0);
+		kmap_atomic_pop(to_virtual);
+		kmap_atomic_pop(from_virtual);
 		preempt_enable();
 		page_cache_release(from_page);
 	}
@@ -558,11 +558,11 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 			goto out_err;
 
 		preempt_disable();
-		from_virtual = kmap_atomic(from_page, KM_USER0);
-		to_virtual = kmap_atomic(to_page, KM_USER1);
+		from_virtual = kmap_atomic_push(from_page);
+		to_virtual = kmap_atomic_push(to_page);
 		memcpy(to_virtual, from_virtual, PAGE_SIZE);
-		kunmap_atomic(to_virtual, KM_USER1);
-		kunmap_atomic(from_virtual, KM_USER0);
+		kmap_atomic_pop(to_virtual);
+		kmap_atomic_pop(from_virtual);
 		preempt_enable();
 		set_page_dirty(to_page);
 		mark_page_accessed(to_page);
Index: linux-2.6/drivers/ide/ide-taskfile.c
===================================================================
--- linux-2.6.orig/drivers/ide/ide-taskfile.c
+++ linux-2.6/drivers/ide/ide-taskfile.c
@@ -252,7 +252,7 @@ void ide_pio_bytes(ide_drive_t *drive, s
 		if (page_is_high)
 			local_irq_save(flags);
 
-		buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
+		buf = kmap_atomic_push(page) + offset;
 
 		cmd->nleft -= nr_bytes;
 		cmd->cursg_ofs += nr_bytes;
@@ -268,7 +268,7 @@ void ide_pio_bytes(ide_drive_t *drive, s
 		else
 			hwif->tp_ops->input_data(drive, cmd, buf, nr_bytes);
 
-		kunmap_atomic(buf, KM_BIO_SRC_IRQ);
+		kmap_atomic_pop(buf);
 
 		if (page_is_high)
 			local_irq_restore(flags);
Index: linux-2.6/drivers/infiniband/ulp/iser/iser_memory.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/ulp/iser/iser_memory.c
+++ linux-2.6/drivers/infiniband/ulp/iser/iser_memory.c
@@ -129,11 +129,11 @@ static int iser_start_rdma_unaligned_sg(
 
 		p = mem;
 		for_each_sg(sgl, sg, data->size, i) {
-			from = kmap_atomic(sg_page(sg), KM_USER0);
+			from = kmap_atomic_push(sg_page(sg));
 			memcpy(p,
 			       from + sg->offset,
 			       sg->length);
-			kunmap_atomic(from, KM_USER0);
+			kmap_atomic_pop(from);
 			p += sg->length;
 		}
 	}
@@ -189,11 +189,11 @@ void iser_finalize_rdma_unaligned_sg(str
 
 		p = mem;
 		for_each_sg(sgl, sg, sg_size, i) {
-			to = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
+			to = kmap_atomic_push(sg_page(sg));
 			memcpy(to + sg->offset,
 			       p,
 			       sg->length);
-			kunmap_atomic(to, KM_SOFTIRQ0);
+			kmap_atomic_pop(to);
 			p += sg->length;
 		}
 	}
Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c
+++ linux-2.6/drivers/md/bitmap.c
@@ -494,14 +494,14 @@ void bitmap_update_sb(struct bitmap *bit
 		return;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = (bitmap_super_t *)kmap_atomic_push(bitmap->sb_page);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (bitmap->mddev->events < bitmap->events_cleared) {
 		/* rocking back to read-only */
 		bitmap->events_cleared = bitmap->mddev->events;
 		sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
 	}
-	kunmap_atomic(sb, KM_USER0);
+	kmap_atomic_pop(sb);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
 
@@ -512,7 +512,7 @@ void bitmap_print_sb(struct bitmap *bitm
 
 	if (!bitmap || !bitmap->sb_page)
 		return;
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = (bitmap_super_t *)kmap_atomic_push(bitmap->sb_page);
 	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
 	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
 	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
@@ -531,7 +531,7 @@ void bitmap_print_sb(struct bitmap *bitm
 	printk(KERN_DEBUG "     sync size: %llu KB\n",
 			(unsigned long long)le64_to_cpu(sb->sync_size)/2);
 	printk(KERN_DEBUG "max write behind: %d\n", le32_to_cpu(sb->write_behind));
-	kunmap_atomic(sb, KM_USER0);
+	kmap_atomic_pop(sb);
 }
 
 /* read the superblock from the bitmap file and initialize some bitmap fields */
@@ -560,7 +560,7 @@ static int bitmap_read_sb(struct bitmap 
 		return err;
 	}
 
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = (bitmap_super_t *)kmap_atomic_push(bitmap->sb_page);
 
 	chunksize = le32_to_cpu(sb->chunksize);
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep);
@@ -622,7 +622,7 @@ success:
 		bitmap->events_cleared = bitmap->mddev->events;
 	err = 0;
 out:
-	kunmap_atomic(sb, KM_USER0);
+	kmap_atomic_pop(sb);
 	if (err)
 		bitmap_print_sb(bitmap);
 	return err;
@@ -647,7 +647,7 @@ static int bitmap_mask_state(struct bitm
 		return 0;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = (bitmap_super_t *)kmap_atomic_push(bitmap->sb_page);
 	old = le32_to_cpu(sb->state) & bits;
 	switch (op) {
 		case MASK_SET: sb->state |= cpu_to_le32(bits);
@@ -656,7 +656,7 @@ static int bitmap_mask_state(struct bitm
 				break;
 		default: BUG();
 	}
-	kunmap_atomic(sb, KM_USER0);
+	kmap_atomic_pop(sb);
 	return old;
 }
 
@@ -824,12 +824,12 @@ static void bitmap_file_set_bit(struct b
 	bit = file_page_offset(chunk);
 
  	/* set the bit */
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	if (bitmap->flags & BITMAP_HOSTENDIAN)
 		set_bit(bit, kaddr);
 	else
 		ext2_set_bit(bit, kaddr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	PRINTK("set file bit %lu page %lu\n", bit, page->index);
 
 	/* record page number so it gets flushed to disk when unplug occurs */
@@ -995,10 +995,10 @@ static int bitmap_init_from_disk(struct 
 				 * if bitmap is out of date, dirty the
 			 	 * whole page and write it out
 				 */
-				paddr = kmap_atomic(page, KM_USER0);
+				paddr = kmap_atomic_push(page);
 				memset(paddr + offset, 0xff,
 				       PAGE_SIZE - offset);
-				kunmap_atomic(paddr, KM_USER0);
+				kmap_atomic_pop(paddr);
 				write_page(bitmap, page, 1);
 
 				ret = -EIO;
@@ -1006,12 +1006,12 @@ static int bitmap_init_from_disk(struct 
 					goto err;
 			}
 		}
-		paddr = kmap_atomic(page, KM_USER0);
+		paddr = kmap_atomic_push(page);
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			b = test_bit(bit, paddr);
 		else
 			b = ext2_test_bit(bit, paddr);
-		kunmap_atomic(paddr, KM_USER0);
+		kmap_atomic_pop(paddr);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
 			int needed = ((sector_t)(i+1) << (CHUNK_BLOCK_SHIFT(bitmap))
@@ -1145,10 +1145,10 @@ void bitmap_daemon_work(struct bitmap *b
 			if (bitmap->need_sync) {
 				bitmap_super_t *sb;
 				bitmap->need_sync = 0;
-				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+				sb = kmap_atomic_push(bitmap->sb_page);
 				sb->events_cleared =
 					cpu_to_le64(bitmap->events_cleared);
-				kunmap_atomic(sb, KM_USER0);
+				kmap_atomic_pop(sb);
 				write_page(bitmap, bitmap->sb_page, 1);
 			}
 			spin_lock_irqsave(&bitmap->lock, flags);
@@ -1175,12 +1175,12 @@ void bitmap_daemon_work(struct bitmap *b
 						  -1);
 
 				/* clear the bit */
-				paddr = kmap_atomic(page, KM_USER0);
+				paddr = kmap_atomic_push(page);
 				if (bitmap->flags & BITMAP_HOSTENDIAN)
 					clear_bit(file_page_offset(j), paddr);
 				else
 					ext2_clear_bit(file_page_offset(j), paddr);
-				kunmap_atomic(paddr, KM_USER0);
+				kmap_atomic_pop(paddr);
 			}
 		} else
 			j |= PAGE_COUNTER_MASK;
Index: linux-2.6/drivers/media/video/ivtv/ivtv-udma.c
===================================================================
--- linux-2.6.orig/drivers/media/video/ivtv/ivtv-udma.c
+++ linux-2.6/drivers/media/video/ivtv/ivtv-udma.c
@@ -57,9 +57,9 @@ int ivtv_udma_fill_sg_list (struct ivtv_
 			if (dma->bouncemap[map_offset] == NULL)
 				return -1;
 			local_irq_save(flags);
-			src = kmap_atomic(dma->map[map_offset], KM_BOUNCE_READ) + offset;
+			src = kmap_atomic_push(dma->map[map_offset]) + offset;
 			memcpy(page_address(dma->bouncemap[map_offset]) + offset, src, len);
-			kunmap_atomic(src, KM_BOUNCE_READ);
+			kmap_atomic_pop(src);
 			local_irq_restore(flags);
 			sg_set_page(&dma->SGlist[map_offset], dma->bouncemap[map_offset], len, offset);
 		}
Index: linux-2.6/drivers/memstick/host/jmb38x_ms.c
===================================================================
--- linux-2.6.orig/drivers/memstick/host/jmb38x_ms.c
+++ linux-2.6/drivers/memstick/host/jmb38x_ms.c
@@ -323,7 +323,7 @@ static int jmb38x_ms_transfer_data(struc
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + p_off;
+			buf = kmap_atomic_push(pg) + p_off;
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -339,7 +339,7 @@ static int jmb38x_ms_transfer_data(struc
 				 : jmb38x_ms_read_reg_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off, KM_BIO_SRC_IRQ);
+			kmap_atomic_pop(buf - p_off);
 			local_irq_restore(flags);
 		}
 
Index: linux-2.6/drivers/memstick/host/tifm_ms.c
===================================================================
--- linux-2.6.orig/drivers/memstick/host/tifm_ms.c
+++ linux-2.6/drivers/memstick/host/tifm_ms.c
@@ -209,7 +209,7 @@ static unsigned int tifm_ms_transfer_dat
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + p_off;
+			buf = kmap_atomic_push(pg) + p_off;
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -220,7 +220,7 @@ static unsigned int tifm_ms_transfer_dat
 			 : tifm_ms_read_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off, KM_BIO_SRC_IRQ);
+			kmap_atomic_pop(buf - p_off);
 			local_irq_restore(flags);
 		}
 
Index: linux-2.6/drivers/mmc/host/at91_mci.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/at91_mci.c
+++ linux-2.6/drivers/mmc/host/at91_mci.c
@@ -218,7 +218,7 @@ static inline void at91_mci_sg_to_dma(st
 
 		sg = &data->sg[i];
 
-		sgbuffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+		sgbuffer = kmap_atomic_push(sg_page(sg)) + sg->offset;
 		amount = min(size, sg->length);
 		size -= amount;
 
@@ -232,7 +232,7 @@ static inline void at91_mci_sg_to_dma(st
 			dmabuf += amount;
 		}
 
-		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
+		kmap_atomic_pop(sgbuffer);
 
 		if (size == 0)
 			break;
@@ -351,13 +351,13 @@ static void at91_mci_post_dma_read(struc
 			int index;
 
 			/* Swap the contents of the buffer */
-			buffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+			buffer = kmap_atomic_push(sg_page(sg)) + sg->offset;
 			pr_debug("buffer = %p, length = %d\n", buffer, sg->length);
 
 			for (index = 0; index < (sg->length / 4); index++)
 				buffer[index] = swab32(buffer[index]);
 
-			kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
+			kmap_atomic_pop(buffer);
 		}
 
 		flush_dcache_page(sg_page(sg));
Index: linux-2.6/drivers/mmc/host/mmci.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/mmci.c
+++ linux-2.6/drivers/mmc/host/mmci.c
@@ -327,7 +327,7 @@ static irqreturn_t mmci_pio_irq(int irq,
 		/*
 		 * Map the current scatter buffer.
 		 */
-		buffer = mmci_kmap_atomic(host, &flags) + host->sg_off;
+		buffer = mmci_kmap_atomic_push(host, &flags) + host->sg_off;
 		remain = host->sg_ptr->length - host->sg_off;
 
 		len = 0;
@@ -339,7 +339,7 @@ static irqreturn_t mmci_pio_irq(int irq,
 		/*
 		 * Unmap the buffer.
 		 */
-		mmci_kunmap_atomic(host, buffer, &flags);
+		mmci_kmap_atomic_pop(host, buffer, &flags);
 
 		host->sg_off += len;
 		host->size -= len;
Index: linux-2.6/drivers/mmc/host/mmci.h
===================================================================
--- linux-2.6.orig/drivers/mmc/host/mmci.h
+++ linux-2.6/drivers/mmc/host/mmci.h
@@ -195,16 +195,16 @@ static inline int mmci_next_sg(struct mm
 	return --host->sg_len;
 }
 
-static inline char *mmci_kmap_atomic(struct mmci_host *host, unsigned long *flags)
+static inline char *mmci_kmap_atomic_push(struct mmci_host *host, unsigned long *flags)
 {
 	struct scatterlist *sg = host->sg_ptr;
 
 	local_irq_save(*flags);
-	return kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+	return kmap_atomic_push(sg_page(sg)) + sg->offset;
 }
 
-static inline void mmci_kunmap_atomic(struct mmci_host *host, void *buffer, unsigned long *flags)
+static inline void mmci_kmap_atomic_pop(struct mmci_host *host, void *buffer, unsigned long *flags)
 {
-	kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
+	kmap_atomic_pop(buffer);
 	local_irq_restore(*flags);
 }
Index: linux-2.6/drivers/mmc/host/msm_sdcc.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/msm_sdcc.c
+++ linux-2.6/drivers/mmc/host/msm_sdcc.c
@@ -505,8 +505,8 @@ msmsdcc_pio_irq(int irq, void *dev_id)
 
 		/* Map the current scatter buffer */
 		local_irq_save(flags);
-		buffer = kmap_atomic(sg_page(host->pio.sg),
-				     KM_BIO_SRC_IRQ) + host->pio.sg->offset;
+		buffer = kmap_atomic_push(sg_page(host->pio.sg))
+			+ host->pio.sg->offset;
 		buffer += host->pio.sg_off;
 		remain = host->pio.sg->length - host->pio.sg_off;
 		len = 0;
@@ -516,7 +516,7 @@ msmsdcc_pio_irq(int irq, void *dev_id)
 			len = msmsdcc_pio_write(host, buffer, remain, status);
 
 		/* Unmap the buffer */
-		kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
+		kmap_atomic_pop(buffer);
 		local_irq_restore(flags);
 
 		host->pio.sg_off += len;
Index: linux-2.6/drivers/mmc/host/sdhci.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/sdhci.c
+++ linux-2.6/drivers/mmc/host/sdhci.c
@@ -364,15 +364,15 @@ static void sdhci_transfer_pio(struct sd
 	DBG("PIO transfer complete.\n");
 }
 
-static char *sdhci_kmap_atomic(struct scatterlist *sg, unsigned long *flags)
+static char *sdhci_kmap_atomic_push(struct scatterlist *sg, unsigned long *flags)
 {
 	local_irq_save(*flags);
-	return kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+	return kmap_atomic_push(sg_page(sg)) + sg->offset;
 }
 
-static void sdhci_kunmap_atomic(void *buffer, unsigned long *flags)
+static void sdhci_kmap_atomic_pop(void *buffer, unsigned long *flags)
 {
-	kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
+	kmap_atomic_pop(buffer);
 	local_irq_restore(*flags);
 }
 
@@ -437,10 +437,10 @@ static int sdhci_adma_table_pre(struct s
 		offset = (4 - (addr & 0x3)) & 0x3;
 		if (offset) {
 			if (data->flags & MMC_DATA_WRITE) {
-				buffer = sdhci_kmap_atomic(sg, &flags);
+				buffer = sdhci_kmap_atomic_push(sg, &flags);
 				WARN_ON(((long)buffer & PAGE_MASK) > (PAGE_SIZE - 3));
 				memcpy(align, buffer, offset);
-				sdhci_kunmap_atomic(buffer, &flags);
+				sdhci_kmap_atomic_pop(buffer, &flags);
 			}
 
 			desc[7] = (align_addr >> 24) & 0xff;
@@ -559,10 +559,10 @@ static void sdhci_adma_table_post(struct
 			if (sg_dma_address(sg) & 0x3) {
 				size = 4 - (sg_dma_address(sg) & 0x3);
 
-				buffer = sdhci_kmap_atomic(sg, &flags);
+				buffer = sdhci_kmap_atomic_push(sg, &flags);
 				WARN_ON(((long)buffer & PAGE_MASK) > (PAGE_SIZE - 3));
 				memcpy(buffer, align, size);
-				sdhci_kunmap_atomic(buffer, &flags);
+				sdhci_kmap_atomic_pop(buffer, &flags);
 
 				align += 4;
 			}
Index: linux-2.6/drivers/mmc/host/tifm_sd.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/tifm_sd.c
+++ linux-2.6/drivers/mmc/host/tifm_sd.c
@@ -117,7 +117,7 @@ static void tifm_sd_read_fifo(struct tif
 	unsigned char *buf;
 	unsigned int pos = 0, val;
 
-	buf = kmap_atomic(pg, KM_BIO_DST_IRQ) + off;
+	buf = kmap_atomic_push(pg) + off;
 	if (host->cmd_flags & DATA_CARRY) {
 		buf[pos++] = host->bounce_buf_data[0];
 		host->cmd_flags &= ~DATA_CARRY;
@@ -133,7 +133,7 @@ static void tifm_sd_read_fifo(struct tif
 		}
 		buf[pos++] = (val >> 8) & 0xff;
 	}
-	kunmap_atomic(buf - off, KM_BIO_DST_IRQ);
+	kmap_atomic_pop(buf - off);
 }
 
 static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
@@ -143,7 +143,7 @@ static void tifm_sd_write_fifo(struct ti
 	unsigned char *buf;
 	unsigned int pos = 0, val;
 
-	buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + off;
+	buf = kmap_atomic_push(pg) + off;
 	if (host->cmd_flags & DATA_CARRY) {
 		val = host->bounce_buf_data[0] | ((buf[pos++] << 8) & 0xff00);
 		writel(val, sock->addr + SOCK_MMCSD_DATA);
@@ -160,7 +160,7 @@ static void tifm_sd_write_fifo(struct ti
 		val |= (buf[pos++] << 8) & 0xff00;
 		writel(val, sock->addr + SOCK_MMCSD_DATA);
 	}
-	kunmap_atomic(buf - off, KM_BIO_SRC_IRQ);
+	kmap_atomic_pop(buf - off);
 }
 
 static void tifm_sd_transfer_data(struct tifm_sd *host)
@@ -211,13 +211,13 @@ static void tifm_sd_copy_page(struct pag
 			      struct page *src, unsigned int src_off,
 			      unsigned int count)
 {
-	unsigned char *src_buf = kmap_atomic(src, KM_BIO_SRC_IRQ) + src_off;
-	unsigned char *dst_buf = kmap_atomic(dst, KM_BIO_DST_IRQ) + dst_off;
+	unsigned char *src_buf = kmap_atomic_push(src) + src_off;
+	unsigned char *dst_buf = kmap_atomic_push(dst) + dst_off;
 
 	memcpy(dst_buf, src_buf, count);
 
-	kunmap_atomic(dst_buf - dst_off, KM_BIO_DST_IRQ);
-	kunmap_atomic(src_buf - src_off, KM_BIO_SRC_IRQ);
+	kmap_atomic_pop(dst_buf - dst_off);
+	kmap_atomic_pop(src_buf - src_off);
 }
 
 static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
Index: linux-2.6/drivers/mmc/host/tmio_mmc.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/tmio_mmc.c
+++ linux-2.6/drivers/mmc/host/tmio_mmc.c
@@ -170,7 +170,7 @@ static inline void tmio_mmc_pio_irq(stru
 		return;
 	}
 
-	buf = (unsigned short *)(tmio_mmc_kmap_atomic(host, &flags) +
+	buf = (unsigned short *)(tmio_mmc_kmap_atomic_push(host, &flags) +
 	      host->sg_off);
 
 	count = host->sg_ptr->length - host->sg_off;
@@ -188,7 +188,7 @@ static inline void tmio_mmc_pio_irq(stru
 
 	host->sg_off += count;
 
-	tmio_mmc_kunmap_atomic(host, &flags);
+	tmio_mmc_kmap_atomic_pop(host, &flags);
 
 	if (host->sg_off == host->sg_ptr->length)
 		tmio_mmc_next_sg(host);
Index: linux-2.6/drivers/mmc/host/tmio_mmc.h
===================================================================
--- linux-2.6.orig/drivers/mmc/host/tmio_mmc.h
+++ linux-2.6/drivers/mmc/host/tmio_mmc.h
@@ -200,19 +200,19 @@ static inline int tmio_mmc_next_sg(struc
 	return --host->sg_len;
 }
 
-static inline char *tmio_mmc_kmap_atomic(struct tmio_mmc_host *host,
+static inline char *tmio_mmc_kmap_atomic_push(struct tmio_mmc_host *host,
 	unsigned long *flags)
 {
 	struct scatterlist *sg = host->sg_ptr;
 
 	local_irq_save(*flags);
-	return kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+	return kmap_atomic_push(sg_page(sg)) + sg->offset;
 }
 
-static inline void tmio_mmc_kunmap_atomic(struct tmio_mmc_host *host,
+static inline void tmio_mmc_kmap_atomic_pop(struct tmio_mmc_host *host,
 	unsigned long *flags)
 {
-	kunmap_atomic(sg_page(host->sg_ptr), KM_BIO_SRC_IRQ);
+	kmap_atomic_pop(sg_page(host->sg_ptr));
 	local_irq_restore(*flags);
 }
 
Index: linux-2.6/drivers/net/cassini.c
===================================================================
--- linux-2.6.orig/drivers/net/cassini.c
+++ linux-2.6/drivers/net/cassini.c
@@ -102,8 +102,8 @@
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 
-#define cas_page_map(x)      kmap_atomic((x), KM_SKB_DATA_SOFTIRQ)
-#define cas_page_unmap(x)    kunmap_atomic((x), KM_SKB_DATA_SOFTIRQ)
+#define cas_page_map(x)      kmap_atomic_push((x))
+#define cas_page_unmap(x)    kmap_atomic_pop((x))
 #define CAS_NCPUS            num_online_cpus()
 
 #if defined(CONFIG_CASSINI_NAPI) && defined(HAVE_NETDEV_POLL)
Index: linux-2.6/drivers/net/e1000/e1000_main.c
===================================================================
--- linux-2.6.orig/drivers/net/e1000/e1000_main.c
+++ linux-2.6/drivers/net/e1000/e1000_main.c
@@ -3705,11 +3705,9 @@ static bool e1000_clean_jumbo_rx_irq(str
 				if (length <= copybreak &&
 				    skb_tailroom(skb) >= length) {
 					u8 *vaddr;
-					vaddr = kmap_atomic(buffer_info->page,
-					                    KM_SKB_DATA_SOFTIRQ);
+					vaddr = kmap_atomic_push(buffer_info->page);
 					memcpy(skb_tail_pointer(skb), vaddr, length);
-					kunmap_atomic(vaddr,
-					              KM_SKB_DATA_SOFTIRQ);
+					kmap_atomic_pop(vaddr);
 					/* re-use the page, so don't erase
 					 * buffer_info->page */
 					skb_put(skb, length);
Index: linux-2.6/drivers/net/e1000e/netdev.c
===================================================================
--- linux-2.6.orig/drivers/net/e1000e/netdev.c
+++ linux-2.6/drivers/net/e1000e/netdev.c
@@ -791,14 +791,14 @@ static bool e1000_clean_rx_irq_ps(struct
 
 			/*
 			 * there is no documentation about how to call
-			 * kmap_atomic, so we can't hold the mapping
+			 * kmap_atomic_push, so we can't hold the mapping
 			 * very long
 			 */
 			pci_dma_sync_single_for_cpu(pdev, ps_page->dma,
 				PAGE_SIZE, PCI_DMA_FROMDEVICE);
-			vaddr = kmap_atomic(ps_page->page, KM_SKB_DATA_SOFTIRQ);
+			vaddr = kmap_atomic_push(ps_page->page);
 			memcpy(skb_tail_pointer(skb), vaddr, l1);
-			kunmap_atomic(vaddr, KM_SKB_DATA_SOFTIRQ);
+			kmap_atomic_pop(vaddr);
 			pci_dma_sync_single_for_device(pdev, ps_page->dma,
 				PAGE_SIZE, PCI_DMA_FROMDEVICE);
 
@@ -991,12 +991,10 @@ static bool e1000_clean_jumbo_rx_irq(str
 				if (length <= copybreak &&
 				    skb_tailroom(skb) >= length) {
 					u8 *vaddr;
-					vaddr = kmap_atomic(buffer_info->page,
-					                   KM_SKB_DATA_SOFTIRQ);
+					vaddr = kmap_atomic_push(buffer_info->page);
 					memcpy(skb_tail_pointer(skb), vaddr,
 					       length);
-					kunmap_atomic(vaddr,
-					              KM_SKB_DATA_SOFTIRQ);
+					kmap_atomic_pop(vaddr);
 					/* re-use the page, so don't erase
 					 * buffer_info->page */
 					skb_put(skb, length);
Index: linux-2.6/drivers/scsi/arcmsr/arcmsr_hba.c
===================================================================
--- linux-2.6.orig/drivers/scsi/arcmsr/arcmsr_hba.c
+++ linux-2.6/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1370,7 +1370,7 @@ static int arcmsr_iop_message_xfer(struc
 						/* 4 bytes: Areca io control code */
 
 	sg = scsi_sglist(cmd);
-	buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+	buffer = kmap_atomic_push(sg_page(sg)) + sg->offset;
 	if (scsi_sg_count(cmd) > 1) {
 		retvalue = ARCMSR_MESSAGE_FAIL;
 		goto message_out;
@@ -1573,7 +1573,7 @@ static int arcmsr_iop_message_xfer(struc
 	}
 	message_out:
 	sg = scsi_sglist(cmd);
-	kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+	kmap_atomic_pop(buffer - sg->offset);
 	return retvalue;
 }
 
@@ -1618,11 +1618,11 @@ static void arcmsr_handle_virtual_comman
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
 
 		sg = scsi_sglist(cmd);
-		buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+		buffer = kmap_atomic_push(sg_page(sg)) + sg->offset;
 
 		memcpy(buffer, inqdata, sizeof(inqdata));
 		sg = scsi_sglist(cmd);
-		kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+		kmap_atomic_pop(buffer - sg->offset);
 
 		cmd->scsi_done(cmd);
 	}
Index: linux-2.6/drivers/scsi/cxgb3i/cxgb3i_pdu.c
===================================================================
--- linux-2.6.orig/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ linux-2.6/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -319,12 +319,11 @@ int cxgb3i_conn_init_pdu(struct iscsi_ta
 
 			/* data fits in the skb's headroom */
 			for (i = 0; i < tdata->nr_frags; i++, frag++) {
-				char *src = kmap_atomic(frag->page,
-							KM_SOFTIRQ0);
+				char *src = kmap_atomic_push(frag->page);
 
 				memcpy(dst, src+frag->page_offset, frag->size);
 				dst += frag->size;
-				kunmap_atomic(src, KM_SOFTIRQ0);
+				kmap_atomic_pop(src);
 			}
 			if (padlen) {
 				memset(dst, 0, padlen);
Index: linux-2.6/drivers/scsi/dc395x.c
===================================================================
--- linux-2.6.orig/drivers/scsi/dc395x.c
+++ linux-2.6/drivers/scsi/dc395x.c
@@ -2279,7 +2279,7 @@ static void data_in_phase0(struct Adapte
 				local_irq_save(flags);
 				/* Assumption: it's inside one page as it's at most 4 bytes and
 				   I just assume it's on a 4-byte boundary */
-				base = scsi_kmap_atomic_sg(scsi_sglist(srb->cmd),
+				base = scsi_kmap_atomic_push_sg(scsi_sglist(srb->cmd),
 							   srb->sg_count, &offset, &len);
 				virt = base + offset;
 
@@ -2322,7 +2322,7 @@ static void data_in_phase0(struct Adapte
 					DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
 				}
 
-				scsi_kunmap_atomic_sg(base);
+				scsi_kmap_atomic_pop_sg(base);
 				local_irq_restore(flags);
 			}
 			/*printk(" %08x", *(u32*)(bus_to_virt (addr))); */
@@ -2496,7 +2496,7 @@ static void data_io_transfer(struct Adap
 
 				local_irq_save(flags);
 				/* Again, max 4 bytes */
-				base = scsi_kmap_atomic_sg(scsi_sglist(srb->cmd),
+				base = scsi_kmap_atomic_push_sg(scsi_sglist(srb->cmd),
 							   srb->sg_count, &offset, &len);
 				virt = base + offset;
 
@@ -2511,7 +2511,7 @@ static void data_io_transfer(struct Adap
 					sg_subtract_one(srb);
 				}
 
-				scsi_kunmap_atomic_sg(base);
+				scsi_kmap_atomic_pop_sg(base);
 				local_irq_restore(flags);
 			}
 			if (srb->dcb->sync_period & WIDE_SYNC) {
@@ -3465,7 +3465,7 @@ static void srb_done(struct AdapterCtlBl
 		size_t offset = 0, len = sizeof(struct ScsiInqData);
 
 		local_irq_save(flags);
-		base = scsi_kmap_atomic_sg(sg, scsi_sg_count(cmd), &offset, &len);
+		base = scsi_kmap_atomic_push_sg(sg, scsi_sg_count(cmd), &offset, &len);
 		ptr = (struct ScsiInqData *)(base + offset);
 
 		if (!ckc_only && (cmd->result & RES_DID) == 0
@@ -3484,7 +3484,7 @@ static void srb_done(struct AdapterCtlBl
 			}
 		}
 
-		scsi_kunmap_atomic_sg(base);
+		scsi_kmap_atomic_pop_sg(base);
 		local_irq_restore(flags);
 	}
 
Index: linux-2.6/drivers/scsi/fcoe/fcoe.c
===================================================================
--- linux-2.6.orig/drivers/scsi/fcoe/fcoe.c
+++ linux-2.6/drivers/scsi/fcoe/fcoe.c
@@ -1159,10 +1159,9 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
 		len = frag->size;
 		while (len > 0) {
 			clen = min(len, PAGE_SIZE - (off & ~PAGE_MASK));
-			data = kmap_atomic(frag->page + (off >> PAGE_SHIFT),
-					   KM_SKB_DATA_SOFTIRQ);
+			data = kmap_atomic_push(frag->page + (off >> PAGE_SHIFT));
 			crc = crc32(crc, data + (off & ~PAGE_MASK), clen);
-			kunmap_atomic(data, KM_SKB_DATA_SOFTIRQ);
+			kmap_atomic_pop(data);
 			off += clen;
 			len -= clen;
 		}
@@ -1236,7 +1235,7 @@ int fcoe_xmit(struct fc_lport *lp, struc
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
-		cp = kmap_atomic(frag->page, KM_SKB_DATA_SOFTIRQ)
+		cp = kmap_atomic_push(frag->page)
 			+ frag->page_offset;
 	} else {
 		cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
@@ -1247,7 +1246,7 @@ int fcoe_xmit(struct fc_lport *lp, struc
 	cp->fcoe_crc32 = cpu_to_le32(~crc);
 
 	if (skb_is_nonlinear(skb)) {
-		kunmap_atomic(cp, KM_SKB_DATA_SOFTIRQ);
+		kmap_atomic_pop(cp);
 		cp = NULL;
 	}
 
Index: linux-2.6/drivers/scsi/gdth.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.c
+++ linux-2.6/drivers/scsi/gdth.c
@@ -2279,7 +2279,7 @@ static void gdth_next(gdth_ha_str *ha)
 
 /*
  * gdth_copy_internal_data() - copy to/from a buffer onto a scsi_cmnd's
- * buffers, kmap_atomic() as needed.
+ * buffers, kmap_atomic_push() as needed.
  */
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                                     char *buffer, ushort count)
@@ -2307,10 +2307,10 @@ static void gdth_copy_internal_data(gdth
                 return;
             }
             local_irq_save(flags);
-            address = kmap_atomic(sg_page(sl), KM_BIO_SRC_IRQ) + sl->offset;
+            address = kmap_atomic_push(sg_page(sl)) + sl->offset;
             memcpy(address, buffer, cpnow);
             flush_dcache_page(sg_page(sl));
-            kunmap_atomic(address, KM_BIO_SRC_IRQ);
+            kmap_atomic_pop(address);
             local_irq_restore(flags);
             if (cpsum == cpcount)
                 break;
Index: linux-2.6/drivers/scsi/ips.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ips.c
+++ linux-2.6/drivers/scsi/ips.c
@@ -1506,17 +1506,17 @@ static int ips_is_passthru(struct scsi_c
                 struct scatterlist *sg = scsi_sglist(SC);
                 char  *buffer;
 
-                /* kmap_atomic() ensures addressability of the user buffer.*/
+                /* kmap_atomic_push() ensures addressability of the user buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+                buffer = kmap_atomic_push(sg_page(sg)) + sg->offset;
                 if (buffer && buffer[0] == 'C' && buffer[1] == 'O' &&
                     buffer[2] == 'P' && buffer[3] == 'P') {
-                        kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+                        kmap_atomic_pop(buffer - sg->offset);
                         local_irq_restore(flags);
                         return 1;
                 }
-                kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+                kmap_atomic_pop(buffer - sg->offset);
                 local_irq_restore(flags);
 	}
 	return 0;
Index: linux-2.6/drivers/scsi/libfc/fc_fcp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libfc/fc_fcp.c
+++ linux-2.6/drivers/scsi/libfc/fc_fcp.c
@@ -377,8 +377,7 @@ static void fc_fcp_recv_data(struct fc_f
 		off = offset + sg->offset;
 		sg_bytes = min(sg_bytes, (size_t)
 			       (PAGE_SIZE - (off & ~PAGE_MASK)));
-		page_addr = kmap_atomic(sg_page(sg) + (off >> PAGE_SHIFT),
-					KM_SOFTIRQ0);
+		page_addr = kmap_atomic_push(sg_page(sg) + (off >> PAGE_SHIFT))
 		if (!page_addr)
 			break;		/* XXX panic? */
 
@@ -387,7 +386,7 @@ static void fc_fcp_recv_data(struct fc_f
 		memcpy((char *)page_addr + (off & ~PAGE_MASK), buf,
 		       sg_bytes);
 
-		kunmap_atomic(page_addr, KM_SOFTIRQ0);
+		kmap_atomic_pop(page_addr);
 		buf += sg_bytes;
 		offset += sg_bytes;
 		remaining -= sg_bytes;
@@ -559,12 +558,11 @@ static int fc_fcp_send_data(struct fc_fc
 			 */
 			sg_bytes = min(sg_bytes, (size_t) (PAGE_SIZE -
 							   (off & ~PAGE_MASK)));
-			page_addr = kmap_atomic(sg_page(sg) +
-						(off >> PAGE_SHIFT),
-						KM_SOFTIRQ0);
+			page_addr = kmap_atomic_push(sg_page(sg) +
+						(off >> PAGE_SHIFT));
 			memcpy(data, (char *)page_addr + (off & ~PAGE_MASK),
 			       sg_bytes);
-			kunmap_atomic(page_addr, KM_SOFTIRQ0);
+			kmap_atomic_pop(page_addr);
 			data += sg_bytes;
 		}
 		offset += sg_bytes;
Index: linux-2.6/drivers/scsi/libiscsi_tcp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libiscsi_tcp.c
+++ linux-2.6/drivers/scsi/libiscsi_tcp.c
@@ -131,14 +131,14 @@ static void iscsi_tcp_segment_map(struct
 	if (page_count(sg_page(sg)) >= 1 && !recv)
 		return;
 
-	segment->sg_mapped = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
+	segment->sg_mapped = kmap_atomic_push(sg_page(sg));
 	segment->data = segment->sg_mapped + sg->offset + segment->sg_offset;
 }
 
 void iscsi_tcp_segment_unmap(struct iscsi_segment *segment)
 {
 	if (segment->sg_mapped) {
-		kunmap_atomic(segment->sg_mapped, KM_SOFTIRQ0);
+		kmap_atomic_pop(segment->sg_mapped);
 		segment->sg_mapped = NULL;
 		segment->data = NULL;
 	}
Index: linux-2.6/drivers/scsi/libsas/sas_host_smp.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libsas/sas_host_smp.c
+++ linux-2.6/drivers/scsi/libsas/sas_host_smp.c
@@ -159,9 +159,9 @@ int sas_smp_host_handler(struct Scsi_Hos
 	}
 
 	local_irq_disable();
-	buf = kmap_atomic(bio_page(req->bio), KM_USER0) + bio_offset(req->bio);
+	buf = kmap_atomic_push(bio_page(req->bio)) + bio_offset(req->bio);
 	memcpy(req_data, buf, blk_rq_bytes(req));
-	kunmap_atomic(buf - bio_offset(req->bio), KM_USER0);
+	kmap_atomic_pop(buf - bio_offset(req->bio));
 	local_irq_enable();
 
 	if (req_data[0] != SMP_REQUEST)
@@ -260,10 +260,10 @@ int sas_smp_host_handler(struct Scsi_Hos
 	}
 
 	local_irq_disable();
-	buf = kmap_atomic(bio_page(rsp->bio), KM_USER0) + bio_offset(rsp->bio);
+	buf = kmap_atomic_push(bio_page(rsp->bio)) + bio_offset(rsp->bio);
 	memcpy(buf, resp_data, blk_rq_bytes(rsp));
 	flush_kernel_dcache_page(bio_page(rsp->bio));
-	kunmap_atomic(buf - bio_offset(rsp->bio), KM_USER0);
+	kmap_atomic_pop(buf - bio_offset(rsp->bio));
 	local_irq_enable();
 
  out:
Index: linux-2.6/drivers/scsi/megaraid.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid.c
+++ linux-2.6/drivers/scsi/megaraid.c
@@ -659,10 +659,10 @@ mega_build_cmd(adapter_t *adapter, Scsi_
 			struct scatterlist *sg;
 
 			sg = scsi_sglist(cmd);
-			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+			buf = kmap_atomic_push(sg_page(sg)) + sg->offset;
 
 			memset(buf, 0, cmd->cmnd[4]);
-			kunmap_atomic(buf - sg->offset, KM_IRQ0);
+			kmap_atomic_pop(buf - sg->offset);
 
 			cmd->result = (DID_OK << 16);
 			cmd->scsi_done(cmd);
Index: linux-2.6/drivers/scsi/mvsas/mv_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mvsas/mv_sas.c
+++ linux-2.6/drivers/scsi/mvsas/mv_sas.c
@@ -556,9 +556,9 @@ static int mvs_task_prep_smp(struct mvs_
 
 #if _MV_DUMP
 	/* copy cmd table */
-	from = kmap_atomic(sg_page(sg_req), KM_IRQ0);
+	from = kmap_atomic_push(sg_page(sg_req));
 	memcpy(buf_cmd, from + sg_req->offset, req_len);
-	kunmap_atomic(from, KM_IRQ0);
+	kmap_atomic_pop(from);
 #endif
 	return 0;
 
@@ -1849,11 +1849,11 @@ int mvs_slot_complete(struct mvs_info *m
 	case SAS_PROTOCOL_SMP: {
 			struct scatterlist *sg_resp = &task->smp_task.smp_resp;
 			tstat->stat = SAM_GOOD;
-			to = kmap_atomic(sg_page(sg_resp), KM_IRQ0);
+			to = kmap_atomic_push(sg_page(sg_resp));
 			memcpy(to + sg_resp->offset,
 				slot->response + sizeof(struct mvs_err_info),
 				sg_dma_len(sg_resp));
-			kunmap_atomic(to, KM_IRQ0);
+			kmap_atomic_pop(to);
 			break;
 		}
 
Index: linux-2.6/drivers/scsi/scsi_debug.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_debug.c
+++ linux-2.6/drivers/scsi/scsi_debug.c
@@ -1651,7 +1651,7 @@ static int prot_verify_read(struct scsi_
 	scsi_for_each_prot_sg(SCpnt, psgl, scsi_prot_sg_count(SCpnt), i) {
 		int len = min(psgl->length, resid);
 
-		paddr = kmap_atomic(sg_page(psgl), KM_IRQ0) + psgl->offset;
+		paddr = kmap_atomic_push(sg_page(psgl)) + psgl->offset;
 		memcpy(paddr, dif_storep + dif_offset(sector), len);
 
 		sector += len >> 3;
@@ -1661,7 +1661,7 @@ static int prot_verify_read(struct scsi_
 			sector = do_div(tmp_sec, sdebug_store_sectors);
 		}
 		resid -= len;
-		kunmap_atomic(paddr, KM_IRQ0);
+		kmap_atomic_pop(paddr);
 	}
 
 	dix_reads++;
@@ -1757,12 +1757,12 @@ static int prot_verify_write(struct scsi
 	BUG_ON(scsi_sg_count(SCpnt) == 0);
 	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
 
-	paddr = kmap_atomic(sg_page(psgl), KM_IRQ1) + psgl->offset;
+	paddr = kmap_atomic_push(sg_page(psgl)) + psgl->offset;
 	ppage_offset = 0;
 
 	/* For each data page */
 	scsi_for_each_sg(SCpnt, dsgl, scsi_sg_count(SCpnt), i) {
-		daddr = kmap_atomic(sg_page(dsgl), KM_IRQ0) + dsgl->offset;
+		daddr = kmap_atomic_push(sg_page(dsgl)) + dsgl->offset;
 
 		/* For each sector-sized chunk in data page */
 		for (j = 0 ; j < dsgl->length ; j += scsi_debug_sector_size) {
@@ -1771,10 +1771,10 @@ static int prot_verify_write(struct scsi
 			 * protection page advance to the next one
 			 */
 			if (ppage_offset >= psgl->length) {
-				kunmap_atomic(paddr, KM_IRQ1);
+				kmap_atomic_pop(paddr);
 				psgl = sg_next(psgl);
 				BUG_ON(psgl == NULL);
-				paddr = kmap_atomic(sg_page(psgl), KM_IRQ1)
+				paddr = kmap_atomic_push(sg_page(psgl))
 					+ psgl->offset;
 				ppage_offset = 0;
 			}
@@ -1836,10 +1836,10 @@ static int prot_verify_write(struct scsi
 			ppage_offset += sizeof(struct sd_dif_tuple);
 		}
 
-		kunmap_atomic(daddr, KM_IRQ0);
+		kmap_atomic_pop(daddr);
 	}
 
-	kunmap_atomic(paddr, KM_IRQ1);
+	kmap_atomic_pop(paddr);
 
 	dix_writes++;
 
@@ -1847,8 +1847,8 @@ static int prot_verify_write(struct scsi
 
 out:
 	dif_errors++;
-	kunmap_atomic(daddr, KM_IRQ0);
-	kunmap_atomic(paddr, KM_IRQ1);
+	kmap_atomic_pop(daddr);
+	kmap_atomic_pop(paddr);
 	return ret;
 }
 
@@ -1959,7 +1959,7 @@ static int resp_xdwriteread(struct scsi_
 
 	offset = 0;
 	for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
-		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
+		kaddr = (unsigned char *)kmap_atomic_push(sg_page(sg));
 		if (!kaddr)
 			goto out;
 
@@ -1967,7 +1967,7 @@ static int resp_xdwriteread(struct scsi_
 			*(kaddr + sg->offset + j) ^= *(buf + offset + j);
 
 		offset += sg->length;
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 	ret = 0;
 out:
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -2490,7 +2490,7 @@ scsi_target_unblock(struct device *dev)
 EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
 /**
- * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
+ * scsi_kmap_atomic_push_sg - find and atomically map an sg-elemnt
  * @sgl:	scatter-gather list
  * @sg_count:	number of segments in sg
  * @offset:	offset in bytes into sg, on return offset into the mapped area
@@ -2498,7 +2498,7 @@ EXPORT_SYMBOL_GPL(scsi_target_unblock);
  *
  * Returns virtual address of the start of the mapped page
  */
-void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
+void *scsi_kmap_atomic_push_sg(struct scatterlist *sgl, int sg_count,
 			  size_t *offset, size_t *len)
 {
 	int i;
@@ -2535,16 +2535,16 @@ void *scsi_kmap_atomic_sg(struct scatter
 	if (*len > sg_len)
 		*len = sg_len;
 
-	return kmap_atomic(page, KM_BIO_SRC_IRQ);
+	return kmap_atomic_push(page);
 }
-EXPORT_SYMBOL(scsi_kmap_atomic_sg);
+EXPORT_SYMBOL(scsi_kmap_atomic_push_sg);
 
 /**
- * scsi_kunmap_atomic_sg - atomically unmap a virtual address, previously mapped with scsi_kmap_atomic_sg
+ * scsi_kmap_atomic_pop_sg - atomically unmap a virtual address, previously mapped with scsi_kmap_atomic_push_sg
  * @virt:	virtual address to be unmapped
  */
-void scsi_kunmap_atomic_sg(void *virt)
+void scsi_kmap_atomic_pop_sg(void *virt)
 {
-	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
+	kmap_atomic_pop(virt);
 }
-EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
+EXPORT_SYMBOL(scsi_kmap_atomic_pop_sg);
Index: linux-2.6/drivers/scsi/sd_dif.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd_dif.c
+++ linux-2.6/drivers/scsi/sd_dif.c
@@ -458,7 +458,7 @@ int sd_dif_prepare(struct request *rq, s
 		virt = bio->bi_integrity->bip_sector & 0xffffffff;
 
 		bip_for_each_vec(iv, bio->bi_integrity, i) {
-			sdt = kmap_atomic(iv->bv_page, KM_USER0)
+			sdt = kmap_atomic_push(iv->bv_page)
 				+ iv->bv_offset;
 
 			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
@@ -471,14 +471,14 @@ int sd_dif_prepare(struct request *rq, s
 				phys++;
 			}
 
-			kunmap_atomic(sdt, KM_USER0);
+			kmap_atomic_pop(sdt);
 		}
 	}
 
 	return 0;
 
 error:
-	kunmap_atomic(sdt, KM_USER0);
+	kmap_atomic_pop(sdt);
 	sd_printk(KERN_ERR, sdkp, "%s: virt %u, phys %u, ref %u, app %4x\n",
 		  __func__, virt, phys, be32_to_cpu(sdt->ref_tag),
 		  be16_to_cpu(sdt->app_tag));
@@ -517,13 +517,13 @@ void sd_dif_complete(struct scsi_cmnd *s
 		virt = bio->bi_integrity->bip_sector & 0xffffffff;
 
 		bip_for_each_vec(iv, bio->bi_integrity, i) {
-			sdt = kmap_atomic(iv->bv_page, KM_USER0)
+			sdt = kmap_atomic_push(iv->bv_page)
 				+ iv->bv_offset;
 
 			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
 
 				if (sectors == 0) {
-					kunmap_atomic(sdt, KM_USER0);
+					kmap_atomic_pop(sdt);
 					return;
 				}
 
@@ -538,7 +538,7 @@ void sd_dif_complete(struct scsi_cmnd *s
 				sectors--;
 			}
 
-			kunmap_atomic(sdt, KM_USER0);
+			kmap_atomic_pop(sdt);
 		}
 	}
 }
Index: linux-2.6/drivers/scsi/tmscsim.c
===================================================================
--- linux-2.6.orig/drivers/scsi/tmscsim.c
+++ linux-2.6/drivers/scsi/tmscsim.c
@@ -912,10 +912,10 @@ din_1:
 		bval = DC390_read8 (ScsiFifo);	    /* get one residual byte */
 
 		local_irq_save(flags);
-		ptr = scsi_kmap_atomic_sg(pSRB->pSegmentList, pSRB->SGcount, &offset, &count);
+		ptr = scsi_kmap_atomic_push_sg(pSRB->pSegmentList, pSRB->SGcount, &offset, &count);
 		if (likely(ptr)) {
 			*(ptr + offset) = bval;
-			scsi_kunmap_atomic_sg(ptr);
+			scsi_kmap_atomic_pop_sg(ptr);
 		}
 		local_irq_restore(flags);
 		WARN_ON(!ptr);
Index: linux-2.6/drivers/staging/hv/RndisFilter.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/RndisFilter.c
+++ linux-2.6/drivers/staging/hv/RndisFilter.c
@@ -409,8 +409,8 @@ static int RndisFilterOnReceive(struct h
 		return -1;
 	}
 
-	rndisHeader = (struct rndis_message *)kmap_atomic(
-			pfn_to_page(Packet->PageBuffers[0].Pfn), KM_IRQ0);
+	rndisHeader = (struct rndis_message *)kmap_atomic_push(
+			pfn_to_page(Packet->PageBuffers[0].Pfn));
 
 	rndisHeader = (void *)((unsigned long)rndisHeader +
 			Packet->PageBuffers[0].Offset);
@@ -423,8 +423,7 @@ static int RndisFilterOnReceive(struct h
 	 * */
 #if 0
 	if (Packet->TotalDataBufferLength != rndisHeader->MessageLength) {
-		kunmap_atomic(rndisHeader - Packet->PageBuffers[0].Offset,
-			      KM_IRQ0);
+		kmap_atomic_pop(rndisHeader - Packet->PageBuffers[0].Offset);
 
 		DPRINT_ERR(NETVSC, "invalid rndis message? (expected %u "
 			   "bytes got %u)...dropping this message!",
@@ -448,7 +447,7 @@ static int RndisFilterOnReceive(struct h
 			sizeof(struct rndis_message) :
 			rndisHeader->MessageLength);
 
-	kunmap_atomic(rndisHeader - Packet->PageBuffers[0].Offset, KM_IRQ0);
+	kmap_atomic_pop(rndisHeader - Packet->PageBuffers[0].Offset);
 
 	DumpRndisMessage(&rndisMessage);
 
Index: linux-2.6/drivers/staging/hv/netvsc_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/netvsc_drv.c
+++ linux-2.6/drivers/staging/hv/netvsc_drv.c
@@ -334,7 +334,7 @@ static int netvsc_recv_callback(struct h
 	skb_reserve(skb, 2);
 	skb->dev = net;
 
-	/* for kmap_atomic */
+	/* for kmap_atomic_push */
 	local_irq_save(flags);
 
 	/*
@@ -342,16 +342,15 @@ static int netvsc_recv_callback(struct h
 	 * hv_netvsc_packet cannot be deallocated
 	 */
 	for (i = 0; i < packet->PageBufferCount; i++) {
-		data = kmap_atomic(pfn_to_page(packet->PageBuffers[i].Pfn),
-					       KM_IRQ1);
+		data = kmap_atomic_push(pfn_to_page(packet->PageBuffers[i].Pfn))
 		data = (void *)(unsigned long)data +
 				packet->PageBuffers[i].Offset;
 
 		memcpy(skb_put(skb, packet->PageBuffers[i].Length), data,
 		       packet->PageBuffers[i].Length);
 
-		kunmap_atomic((void *)((unsigned long)data -
-				       packet->PageBuffers[i].Offset), KM_IRQ1);
+		kmap_atomic_pop((void *)((unsigned long)data -
+				       packet->PageBuffers[i].Offset));
 	}
 
 	local_irq_restore(flags);
Index: linux-2.6/drivers/staging/hv/storvsc_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/storvsc_drv.c
+++ linux-2.6/drivers/staging/hv/storvsc_drv.c
@@ -525,15 +525,15 @@ static unsigned int copy_to_bounce_buffe
 	local_irq_save(flags);
 
 	for (i = 0; i < orig_sgl_count; i++) {
-		src_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
-				KM_IRQ0) + orig_sgl[i].offset;
+		src_addr = (unsigned long)kmap_atomic_push(sg_page((&orig_sgl[i])))
+			+ orig_sgl[i].offset;
 		src = src_addr;
 		srclen = orig_sgl[i].length;
 
 		ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE);
 
 		if (j == 0)
-			bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
+			bounce_addr = (unsigned long)kmap_atomic_push(sg_page((&bounce_sgl[j])));
 
 		while (srclen) {
 			/* assume bounce offset always == 0 */
@@ -550,19 +550,19 @@ static unsigned int copy_to_bounce_buffe
 
 			if (bounce_sgl[j].length == PAGE_SIZE) {
 				/* full..move to next entry */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				kmap_atomic_pop((void *)bounce_addr);
 				j++;
 
 				/* if we need to use another bounce buffer */
 				if (srclen || i != orig_sgl_count - 1)
-					bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
+					bounce_addr = (unsigned long)kmap_atomic_push(sg_page((&bounce_sgl[j])));
 			} else if (srclen == 0 && i == orig_sgl_count - 1) {
 				/* unmap the last bounce that is < PAGE_SIZE */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				kmap_atomic_pop((void *)bounce_addr);
 			}
 		}
 
-		kunmap_atomic((void *)(src_addr - orig_sgl[i].offset), KM_IRQ0);
+		kmap_atomic_pop((void *)(src_addr - orig_sgl[i].offset));
 	}
 
 	local_irq_restore(flags);
@@ -587,14 +587,14 @@ static unsigned int copy_from_bounce_buf
 	local_irq_save(flags);
 
 	for (i = 0; i < orig_sgl_count; i++) {
-		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
-					KM_IRQ0) + orig_sgl[i].offset;
+		dest_addr = (unsigned long)kmap_atomic_push(sg_page((&orig_sgl[i])))
+			+ orig_sgl[i].offset;
 		dest = dest_addr;
 		destlen = orig_sgl[i].length;
 		ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE);
 
 		if (j == 0)
-			bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
+			bounce_addr = (unsigned long)kmap_atomic_push(sg_page((&bounce_sgl[j])));
 
 		while (destlen) {
 			src = bounce_addr + bounce_sgl[j].offset;
@@ -610,20 +610,19 @@ static unsigned int copy_from_bounce_buf
 
 			if (bounce_sgl[j].offset == bounce_sgl[j].length) {
 				/* full */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				kmap_atomic_pop((void *)bounce_addr);
 				j++;
 
 				/* if we need to use another bounce buffer */
 				if (destlen || i != orig_sgl_count - 1)
-					bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
+					bounce_addr = (unsigned long)kmap_atomic_push(sg_page((&bounce_sgl[j])));
 			} else if (destlen == 0 && i == orig_sgl_count - 1) {
 				/* unmap the last bounce that is < PAGE_SIZE */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				kmap_atomic_pop((void *)bounce_addr);
 			}
 		}
 
-		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset),
-			      KM_IRQ0);
+		kmap_atomic_pop((void *)(dest_addr - orig_sgl[i].offset));
 	}
 
 	local_irq_restore(flags);
Index: linux-2.6/drivers/staging/pohmelfs/inode.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c
+++ linux-2.6/drivers/staging/pohmelfs/inode.c
@@ -614,11 +614,11 @@ static int pohmelfs_write_begin(struct f
 		}
 
 		if (len != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
+			void *kaddr = kmap_atomic_push(page);
 
 			memset(kaddr + start, 0, PAGE_CACHE_SIZE - start);
 			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 		}
 		SetPageUptodate(page);
 	}
@@ -644,11 +644,11 @@ static int pohmelfs_write_end(struct fil
 
 	if (copied != len) {
 		unsigned from = pos & (PAGE_CACHE_SIZE - 1);
-		void *kaddr = kmap_atomic(page, KM_USER0);
+		void *kaddr = kmap_atomic_push(page);
 
 		memset(kaddr + from + copied, 0, len - copied);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 
 	SetPageUptodate(page);
Index: linux-2.6/fs/afs/fsclient.c
===================================================================
--- linux-2.6.orig/fs/afs/fsclient.c
+++ linux-2.6/fs/afs/fsclient.c
@@ -363,10 +363,10 @@ static int afs_deliver_fs_fetch_data(str
 		_debug("extract data");
 		if (call->count > 0) {
 			page = call->reply3;
-			buffer = kmap_atomic(page, KM_USER0);
+			buffer = kmap_atomic_push(page);
 			ret = afs_extract_data(call, skb, last, buffer,
 					       call->count);
-			kunmap_atomic(buffer, KM_USER0);
+			kmap_atomic_pop(buffer);
 			switch (ret) {
 			case 0:		break;
 			case -EAGAIN:	return 0;
@@ -409,9 +409,9 @@ static int afs_deliver_fs_fetch_data(str
 	if (call->count < PAGE_SIZE) {
 		_debug("clear");
 		page = call->reply3;
-		buffer = kmap_atomic(page, KM_USER0);
+		buffer = kmap_atomic_push(page);
 		memset(buffer + call->count, 0, PAGE_SIZE - call->count);
-		kunmap_atomic(buffer, KM_USER0);
+		kmap_atomic_pop(buffer);
 	}
 
 	_leave(" = 0 [done]");
Index: linux-2.6/fs/afs/mntpt.c
===================================================================
--- linux-2.6.orig/fs/afs/mntpt.c
+++ linux-2.6/fs/afs/mntpt.c
@@ -172,9 +172,9 @@ static struct vfsmount *afs_mntpt_do_aut
 	if (PageError(page))
 		goto error;
 
-	buf = kmap_atomic(page, KM_USER0);
+	buf = kmap_atomic_push(page);
 	memcpy(devname, buf, size);
-	kunmap_atomic(buf, KM_USER0);
+	kmap_atomic_pop(buf);
 	page_cache_release(page);
 	page = NULL;
 
Index: linux-2.6/fs/aio.c
===================================================================
--- linux-2.6.orig/fs/aio.c
+++ linux-2.6/fs/aio.c
@@ -156,7 +156,7 @@ static int aio_setup_ring(struct kioctx 
 
 	info->nr = nr_events;		/* trusted copy */
 
-	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
+	ring = kmap_atomic_push(info->ring_pages[0]);
 	ring->nr = nr_events;	/* user copy */
 	ring->id = ctx->user_id;
 	ring->head = ring->tail = 0;
@@ -164,32 +164,32 @@ static int aio_setup_ring(struct kioctx 
 	ring->compat_features = AIO_RING_COMPAT_FEATURES;
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
 	ring->header_length = sizeof(struct aio_ring);
-	kunmap_atomic(ring, KM_USER0);
+	kmap_atomic_pop(ring);
 
 	return 0;
 }
 
 
 /* aio_ring_event: returns a pointer to the event at the given index from
- * kmap_atomic(, km).  Release the pointer with put_aio_ring_event();
+ * kmap_atomic_push(, km).  Release the pointer with put_aio_ring_event();
  */
 #define AIO_EVENTS_PER_PAGE	(PAGE_SIZE / sizeof(struct io_event))
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-#define aio_ring_event(info, nr, km) ({					\
+#define aio_ring_event(info, nr) ({					\
 	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
 	struct io_event *__event;					\
-	__event = kmap_atomic(						\
-			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE], km); \
+	__event = kmap_atomic_push(					\
+			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE]); \
 	__event += pos % AIO_EVENTS_PER_PAGE;				\
 	__event;							\
 })
 
-#define put_aio_ring_event(event, km) do {	\
+#define put_aio_ring_event(event) do {		\
 	struct io_event *__event = (event);	\
 	(void)__event;				\
-	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK), km); \
+	kmap_atomic_pop((void *)((unsigned long)__event & PAGE_MASK)); \
 } while(0)
 
 static void ctx_rcu_free(struct rcu_head *head)
@@ -451,13 +451,13 @@ static struct kiocb *__aio_get_req(struc
 	 * accept an event from this io.
 	 */
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
+	ring = kmap_atomic_push(ctx->ring_info.ring_pages[0]);
 	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
 		list_add(&req->ki_list, &ctx->active_reqs);
 		ctx->reqs_active++;
 		okay = 1;
 	}
-	kunmap_atomic(ring, KM_USER0);
+	kmap_atomic_pop(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
 
 	if (!okay) {
@@ -940,10 +940,10 @@ int aio_complete(struct kiocb *iocb, lon
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
-	ring = kmap_atomic(info->ring_pages[0], KM_IRQ1);
+	ring = kmap_atomic_push(info->ring_pages[0]);
 
 	tail = info->tail;
-	event = aio_ring_event(info, tail, KM_IRQ0);
+	event = aio_ring_event(info, tail);
 	if (++tail >= info->nr)
 		tail = 0;
 
@@ -964,8 +964,8 @@ int aio_complete(struct kiocb *iocb, lon
 	info->tail = tail;
 	ring->tail = tail;
 
-	put_aio_ring_event(event, KM_IRQ0);
-	kunmap_atomic(ring, KM_IRQ1);
+	put_aio_ring_event(event);
+	kmap_atomic_pop(ring);
 
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
 
@@ -1010,7 +1010,7 @@ static int aio_read_evt(struct kioctx *i
 	unsigned long head;
 	int ret = 0;
 
-	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
+	ring = kmap_atomic_push(info->ring_pages[0]);
 	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
 		 (unsigned long)ring->head, (unsigned long)ring->tail,
 		 (unsigned long)ring->nr);
@@ -1022,18 +1022,18 @@ static int aio_read_evt(struct kioctx *i
 
 	head = ring->head % info->nr;
 	if (head != ring->tail) {
-		struct io_event *evp = aio_ring_event(info, head, KM_USER1);
+		struct io_event *evp = aio_ring_event(info, head);
 		*ent = *evp;
 		head = (head + 1) % info->nr;
 		smp_mb(); /* finish reading the event before updatng the head */
 		ring->head = head;
 		ret = 1;
-		put_aio_ring_event(evp, KM_USER1);
+		put_aio_ring_event(evp);
 	}
 	spin_unlock(&info->ring_lock);
 
 out:
-	kunmap_atomic(ring, KM_USER0);
+	kmap_atomic_pop(ring);
 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
 	return ret;
Index: linux-2.6/fs/bio-integrity.c
===================================================================
--- linux-2.6.orig/fs/bio-integrity.c
+++ linux-2.6/fs/bio-integrity.c
@@ -354,7 +354,7 @@ static void bio_integrity_generate(struc
 	bix.sector_size = bi->sector_size;
 
 	bio_for_each_segment(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page, KM_USER0);
+		void *kaddr = kmap_atomic_push(bv->bv_page);
 		bix.data_buf = kaddr + bv->bv_offset;
 		bix.data_size = bv->bv_len;
 		bix.prot_buf = prot_buf;
@@ -368,7 +368,7 @@ static void bio_integrity_generate(struc
 		total += sectors * bi->tuple_size;
 		BUG_ON(total > bio->bi_integrity->bip_size);
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 }
 
@@ -495,7 +495,7 @@ static int bio_integrity_verify(struct b
 	bix.sector_size = bi->sector_size;
 
 	bio_for_each_segment(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page, KM_USER0);
+		void *kaddr = kmap_atomic_push(bv->bv_page);
 		bix.data_buf = kaddr + bv->bv_offset;
 		bix.data_size = bv->bv_len;
 		bix.prot_buf = prot_buf;
@@ -504,7 +504,7 @@ static int bio_integrity_verify(struct b
 		ret = bi->verify_fn(&bix);
 
 		if (ret) {
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 			return ret;
 		}
 
@@ -514,7 +514,7 @@ static int bio_integrity_verify(struct b
 		total += sectors * bi->tuple_size;
 		BUG_ON(total > bio->bi_integrity->bip_size);
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 
 	return ret;
Index: linux-2.6/fs/btrfs/compression.c
===================================================================
--- linux-2.6.orig/fs/btrfs/compression.c
+++ linux-2.6/fs/btrfs/compression.c
@@ -129,10 +129,10 @@ static int check_compressed_csum(struct 
 		page = cb->compressed_pages[i];
 		csum = ~(u32)0;
 
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		csum = btrfs_csum_data(root, kaddr, csum, PAGE_CACHE_SIZE);
 		btrfs_csum_final(csum, (char *)&csum);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 
 		if (csum != *cb_sum) {
 			printk(KERN_INFO "btrfs csum failed ino %lu "
@@ -529,10 +529,10 @@ static noinline int add_ra_bio_pages(str
 			if (zero_offset) {
 				int zeros;
 				zeros = PAGE_CACHE_SIZE - zero_offset;
-				userpage = kmap_atomic(page, KM_USER0);
+				userpage = kmap_atomic_push(page);
 				memset(userpage + zero_offset, 0, zeros);
 				flush_dcache_page(page);
-				kunmap_atomic(userpage, KM_USER0);
+				kmap_atomic_pop(userpage);
 			}
 		}
 
Index: linux-2.6/fs/btrfs/ctree.h
===================================================================
--- linux-2.6.orig/fs/btrfs/ctree.h
+++ linux-2.6/fs/btrfs/ctree.h
@@ -1195,17 +1195,17 @@ void btrfs_set_##name(struct extent_buff
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
 {									\
-	type *p = kmap_atomic(eb->first_page, KM_USER0);		\
+	type *p = kmap_atomic_push(eb->first_page);		\
 	u##bits res = le##bits##_to_cpu(p->member);			\
-	kunmap_atomic(p, KM_USER0);					\
+	kmap_atomic_pop(p);					\
 	return res;							\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    u##bits val)			\
 {									\
-	type *p = kmap_atomic(eb->first_page, KM_USER0);		\
+	type *p = kmap_atomic_push(eb->first_page);		\
 	p->member = cpu_to_le##bits(val);				\
-	kunmap_atomic(p, KM_USER0);					\
+	kmap_atomic_pop(p);					\
 }
 
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
Index: linux-2.6/fs/btrfs/extent_io.c
===================================================================
--- linux-2.6.orig/fs/btrfs/extent_io.c
+++ linux-2.6/fs/btrfs/extent_io.c
@@ -2023,20 +2023,20 @@ static int __extent_read_full_page(struc
 
 		if (zero_offset) {
 			iosize = PAGE_CACHE_SIZE - zero_offset;
-			userpage = kmap_atomic(page, KM_USER0);
+			userpage = kmap_atomic_push(page);
 			memset(userpage + zero_offset, 0, iosize);
 			flush_dcache_page(page);
-			kunmap_atomic(userpage, KM_USER0);
+			kmap_atomic_pop(userpage);
 		}
 	}
 	while (cur <= end) {
 		if (cur >= last_byte) {
 			char *userpage;
 			iosize = PAGE_CACHE_SIZE - page_offset;
-			userpage = kmap_atomic(page, KM_USER0);
+			userpage = kmap_atomic_push(page);
 			memset(userpage + page_offset, 0, iosize);
 			flush_dcache_page(page);
-			kunmap_atomic(userpage, KM_USER0);
+			kmap_atomic_pop(userpage);
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    GFP_NOFS);
 			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
@@ -2076,10 +2076,10 @@ static int __extent_read_full_page(struc
 		/* we've found a hole, just zero and go on */
 		if (block_start == EXTENT_MAP_HOLE) {
 			char *userpage;
-			userpage = kmap_atomic(page, KM_USER0);
+			userpage = kmap_atomic_push(page);
 			memset(userpage + page_offset, 0, iosize);
 			flush_dcache_page(page);
-			kunmap_atomic(userpage, KM_USER0);
+			kmap_atomic_pop(userpage);
 
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    GFP_NOFS);
@@ -2218,10 +2218,10 @@ static int __extent_writepage(struct pag
 	if (page->index == end_index) {
 		char *userpage;
 
-		userpage = kmap_atomic(page, KM_USER0);
+		userpage = kmap_atomic_push(page);
 		memset(userpage + pg_offset, 0,
 		       PAGE_CACHE_SIZE - pg_offset);
-		kunmap_atomic(userpage, KM_USER0);
+		kmap_atomic_pop(userpage);
 		flush_dcache_page(page);
 	}
 	pg_offset = 0;
@@ -2781,14 +2781,14 @@ int extent_prepare_write(struct extent_i
 		    (block_off_end > to || block_off_start < from)) {
 			void *kaddr;
 
-			kaddr = kmap_atomic(page, KM_USER0);
+			kaddr = kmap_atomic_push(page);
 			if (block_off_end > to)
 				memset(kaddr + to, 0, block_off_end - to);
 			if (block_off_start < from)
 				memset(kaddr + block_off_start, 0,
 				       from - block_off_start);
 			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 		}
 		if ((em->block_start != EXTENT_MAP_HOLE &&
 		     em->block_start != EXTENT_MAP_INLINE) &&
@@ -3479,9 +3479,9 @@ void read_extent_buffer(struct extent_bu
 		page = extent_buffer_page(eb, i);
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
-		kaddr = kmap_atomic(page, KM_USER1);
+		kaddr = kmap_atomic_push(page);
 		memcpy(dst, kaddr + offset, cur);
-		kunmap_atomic(kaddr, KM_USER1);
+		kmap_atomic_pop(kaddr);
 
 		dst += cur;
 		len -= cur;
@@ -3522,7 +3522,7 @@ int map_private_extent_buffer(struct ext
 	}
 
 	p = extent_buffer_page(eb, i);
-	kaddr = kmap_atomic(p, km);
+	kaddr = kmap_atomic_push(p, km);
 	*token = kaddr;
 	*map = kaddr + offset;
 	*map_len = PAGE_CACHE_SIZE - offset;
@@ -3555,7 +3555,7 @@ int map_extent_buffer(struct extent_buff
 
 void unmap_extent_buffer(struct extent_buffer *eb, char *token, int km)
 {
-	kunmap_atomic(token, km);
+	kmap_atomic_pop(token, km);
 }
 
 int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
@@ -3581,9 +3581,9 @@ int memcmp_extent_buffer(struct extent_b
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
 
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		ret = memcmp(ptr, kaddr + offset, cur);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		if (ret)
 			break;
 
@@ -3616,9 +3616,9 @@ void write_extent_buffer(struct extent_b
 		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
-		kaddr = kmap_atomic(page, KM_USER1);
+		kaddr = kmap_atomic_push(page);
 		memcpy(kaddr + offset, src, cur);
-		kunmap_atomic(kaddr, KM_USER1);
+		kmap_atomic_pop(kaddr);
 
 		src += cur;
 		len -= cur;
@@ -3647,9 +3647,9 @@ void memset_extent_buffer(struct extent_
 		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		memset(kaddr + offset, c, cur);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 
 		len -= cur;
 		offset = 0;
@@ -3680,9 +3680,9 @@ void copy_extent_buffer(struct extent_bu
 
 		cur = min(len, (unsigned long)(PAGE_CACHE_SIZE - offset));
 
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		read_extent_buffer(src, kaddr + offset, src_offset, cur);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 
 		src_offset += cur;
 		len -= cur;
@@ -3695,38 +3695,38 @@ static void move_pages(struct page *dst_
 		       unsigned long dst_off, unsigned long src_off,
 		       unsigned long len)
 {
-	char *dst_kaddr = kmap_atomic(dst_page, KM_USER0);
+	char *dst_kaddr = kmap_atomic_push(dst_page);
 	if (dst_page == src_page) {
 		memmove(dst_kaddr + dst_off, dst_kaddr + src_off, len);
 	} else {
-		char *src_kaddr = kmap_atomic(src_page, KM_USER1);
+		char *src_kaddr = kmap_atomic_push(src_page);
 		char *p = dst_kaddr + dst_off + len;
 		char *s = src_kaddr + src_off + len;
 
 		while (len--)
 			*--p = *--s;
 
-		kunmap_atomic(src_kaddr, KM_USER1);
+		kmap_atomic_pop(src_kaddr);
 	}
-	kunmap_atomic(dst_kaddr, KM_USER0);
+	kmap_atomic_pop(dst_kaddr);
 }
 
 static void copy_pages(struct page *dst_page, struct page *src_page,
 		       unsigned long dst_off, unsigned long src_off,
 		       unsigned long len)
 {
-	char *dst_kaddr = kmap_atomic(dst_page, KM_USER0);
+	char *dst_kaddr = kmap_atomic_push(dst_page);
 	char *src_kaddr;
 
 	if (dst_page != src_page)
-		src_kaddr = kmap_atomic(src_page, KM_USER1);
+		src_kaddr = kmap_atomic_push(src_page);
 	else
 		src_kaddr = dst_kaddr;
 
 	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
-	kunmap_atomic(dst_kaddr, KM_USER0);
+	kmap_atomic_pop(dst_kaddr);
 	if (dst_page != src_page)
-		kunmap_atomic(src_kaddr, KM_USER1);
+		kmap_atomic_pop(src_kaddr);
 }
 
 void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
Index: linux-2.6/fs/btrfs/file-item.c
===================================================================
--- linux-2.6.orig/fs/btrfs/file-item.c
+++ linux-2.6/fs/btrfs/file-item.c
@@ -409,13 +409,13 @@ int btrfs_csum_one_bio(struct btrfs_root
 			sums->bytenr = ordered->start;
 		}
 
-		data = kmap_atomic(bvec->bv_page, KM_USER0);
+		data = kmap_atomic_push(bvec->bv_page);
 		sector_sum->sum = ~(u32)0;
 		sector_sum->sum = btrfs_csum_data(root,
 						  data + bvec->bv_offset,
 						  sector_sum->sum,
 						  bvec->bv_len);
-		kunmap_atomic(data, KM_USER0);
+		kmap_atomic_pop(data);
 		btrfs_csum_final(sector_sum->sum,
 				 (char *)&sector_sum->sum);
 		sector_sum->bytenr = disk_bytenr;
@@ -787,12 +787,12 @@ next_sector:
 		int err;
 
 		if (eb_token)
-			unmap_extent_buffer(leaf, eb_token, KM_USER1);
+			unmap_extent_buffer(leaf, eb_token);
 		eb_token = NULL;
 		err = map_private_extent_buffer(leaf, (unsigned long)item,
 						csum_size,
 						&eb_token, &eb_map,
-						&map_start, &map_len, KM_USER1);
+						&map_start, &map_len);
 		if (err)
 			eb_token = NULL;
 	}
@@ -816,7 +816,7 @@ next_sector:
 		}
 	}
 	if (eb_token) {
-		unmap_extent_buffer(leaf, eb_token, KM_USER1);
+		unmap_extent_buffer(leaf, eb_token);
 		eb_token = NULL;
 	}
 	btrfs_mark_buffer_dirty(path->nodes[0]);
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c
+++ linux-2.6/fs/btrfs/inode.c
@@ -165,9 +165,9 @@ static noinline int insert_inline_extent
 			cur_size = min_t(unsigned long, compressed_size,
 				       PAGE_CACHE_SIZE);
 
-			kaddr = kmap_atomic(cpage, KM_USER0);
+			kaddr = kmap_atomic_push(cpage);
 			write_extent_buffer(leaf, kaddr, ptr, cur_size);
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 
 			i++;
 			ptr += cur_size;
@@ -179,10 +179,10 @@ static noinline int insert_inline_extent
 		page = find_get_page(inode->i_mapping,
 				     start >> PAGE_CACHE_SHIFT);
 		btrfs_set_file_extent_compression(leaf, ei, 0);
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		offset = start & (PAGE_CACHE_SIZE - 1);
 		write_extent_buffer(leaf, kaddr + offset, ptr, size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		page_cache_release(page);
 	}
 	btrfs_mark_buffer_dirty(leaf);
@@ -390,10 +390,10 @@ again:
 			 * sending it down to disk
 			 */
 			if (offset) {
-				kaddr = kmap_atomic(page, KM_USER0);
+				kaddr = kmap_atomic_push(page);
 				memset(kaddr + offset, 0,
 				       PAGE_CACHE_SIZE - offset);
-				kunmap_atomic(kaddr, KM_USER0);
+				kmap_atomic_pop(kaddr);
 			}
 			will_compress = 1;
 		}
@@ -1915,7 +1915,7 @@ static int btrfs_readpage_end_io_hook(st
 	} else {
 		ret = get_state_private(io_tree, start, &private);
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	if (ret)
 		goto zeroit;
 
@@ -1924,7 +1924,7 @@ static int btrfs_readpage_end_io_hook(st
 	if (csum != private)
 		goto zeroit;
 
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 good:
 	/* if the io failure tree for this inode is non-empty,
 	 * check to see if we've recovered from a failed IO
@@ -1941,7 +1941,7 @@ zeroit:
 	}
 	memset(kaddr + offset, 1, end - start + 1);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	if (private == 0)
 		return 0;
 	return -EIO;
@@ -4401,12 +4401,12 @@ static noinline int uncompress_inline(st
 	ret = btrfs_zlib_decompress(tmp, page, extent_offset,
 				    inline_size, max_size);
 	if (ret) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
+		char *kaddr = kmap_atomic_push(page);
 		unsigned long copy_size = min_t(u64,
 				  PAGE_CACHE_SIZE - pg_offset,
 				  max_size - extent_offset);
 		memset(kaddr + pg_offset, 0, copy_size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 	kfree(tmp);
 	return 0;
Index: linux-2.6/fs/btrfs/zlib.c
===================================================================
--- linux-2.6.orig/fs/btrfs/zlib.c
+++ linux-2.6/fs/btrfs/zlib.c
@@ -448,10 +448,10 @@ int btrfs_zlib_decompress_biovec(struct 
 			bytes = min(PAGE_CACHE_SIZE - pg_offset,
 				    PAGE_CACHE_SIZE - buf_offset);
 			bytes = min(bytes, working_bytes);
-			kaddr = kmap_atomic(page_out, KM_USER0);
+			kaddr = kmap_atomic_push(page_out);
 			memcpy(kaddr + pg_offset, workspace->buf + buf_offset,
 			       bytes);
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 			flush_dcache_page(page_out);
 
 			pg_offset += bytes;
@@ -604,9 +604,9 @@ int btrfs_zlib_decompress(unsigned char 
 			    PAGE_CACHE_SIZE - buf_offset);
 		bytes = min(bytes, bytes_left);
 
-		kaddr = kmap_atomic(dest_page, KM_USER0);
+		kaddr = kmap_atomic_push(dest_page);
 		memcpy(kaddr + pg_offset, workspace->buf + buf_offset, bytes);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 
 		pg_offset += bytes;
 		bytes_left -= bytes;
Index: linux-2.6/fs/cifs/file.c
===================================================================
--- linux-2.6.orig/fs/cifs/file.c
+++ linux-2.6/fs/cifs/file.c
@@ -1927,7 +1927,7 @@ static void cifs_copy_cache_pages(struct
 			continue;
 		}
 
-		target = kmap_atomic(page, KM_USER0);
+		target = kmap_atomic_push(page);
 
 		if (PAGE_CACHE_SIZE > bytes_read) {
 			memcpy(target, data, bytes_read);
@@ -1939,7 +1939,7 @@ static void cifs_copy_cache_pages(struct
 			memcpy(target, data, PAGE_CACHE_SIZE);
 			bytes_read -= PAGE_CACHE_SIZE;
 		}
-		kunmap_atomic(target, KM_USER0);
+		kmap_atomic_pop(target);
 
 		flush_dcache_page(page);
 		SetPageUptodate(page);
Index: linux-2.6/fs/ecryptfs/mmap.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/mmap.c
+++ linux-2.6/fs/ecryptfs/mmap.c
@@ -142,7 +142,7 @@ ecryptfs_copy_up_encrypted_with_header(s
 			/* This is a header extent */
 			char *page_virt;
 
-			page_virt = kmap_atomic(page, KM_USER0);
+			page_virt = kmap_atomic_push(page);
 			memset(page_virt, 0, PAGE_CACHE_SIZE);
 			/* TODO: Support more than one header extent */
 			if (view_extent_num == 0) {
@@ -150,7 +150,7 @@ ecryptfs_copy_up_encrypted_with_header(s
 					page_virt, page->mapping->host);
 				set_header_info(page_virt, crypt_stat);
 			}
-			kunmap_atomic(page_virt, KM_USER0);
+			kmap_atomic_pop(page_virt);
 			flush_dcache_page(page);
 			if (rc) {
 				printk(KERN_ERR "%s: Error reading xattr "
Index: linux-2.6/fs/ecryptfs/read_write.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/read_write.c
+++ linux-2.6/fs/ecryptfs/read_write.c
@@ -155,7 +155,7 @@ int ecryptfs_write(struct file *ecryptfs
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
+		ecryptfs_page_virt = kmap_atomic_push(ecryptfs_page);
 
 		/*
 		 * pos: where we're now writing, offset: where the request was
@@ -178,7 +178,7 @@ int ecryptfs_write(struct file *ecryptfs
 			       (data + data_offset), num_bytes);
 			data_offset += num_bytes;
 		}
-		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
+		kmap_atomic_pop(ecryptfs_page_virt);
 		flush_dcache_page(ecryptfs_page);
 		SetPageUptodate(ecryptfs_page);
 		unlock_page(ecryptfs_page);
@@ -337,11 +337,11 @@ int ecryptfs_read(char *data, loff_t off
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
+		ecryptfs_page_virt = kmap_atomic_push(ecryptfs_page);
 		memcpy((data + data_offset),
 		       ((char *)ecryptfs_page_virt + start_offset_in_page),
 		       num_bytes);
-		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
+		kmap_atomic_pop(ecryptfs_page_virt);
 		flush_dcache_page(ecryptfs_page);
 		SetPageUptodate(ecryptfs_page);
 		unlock_page(ecryptfs_page);
Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c
+++ linux-2.6/fs/exec.c
@@ -1177,13 +1177,13 @@ int remove_arg_zero(struct linux_binprm 
 			ret = -EFAULT;
 			goto out;
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 
 		for (; offset < PAGE_SIZE && kaddr[offset];
 				offset++, bprm->p++)
 			;
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		put_arg_page(page);
 
 		if (offset == PAGE_SIZE)
Index: linux-2.6/fs/exofs/dir.c
===================================================================
--- linux-2.6.orig/fs/exofs/dir.c
+++ linux-2.6/fs/exofs/dir.c
@@ -594,7 +594,7 @@ int exofs_make_empty(struct inode *inode
 		goto fail;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	de = (struct exofs_dir_entry *)kaddr;
 	de->name_len = 1;
 	de->rec_len = cpu_to_le16(EXOFS_DIR_REC_LEN(1));
@@ -608,7 +608,7 @@ int exofs_make_empty(struct inode *inode
 	de->inode_no = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, PARENT_DIR, sizeof(PARENT_DIR));
 	exofs_set_de_type(de, inode);
-	kunmap_atomic(page, KM_USER0);
+	kmap_atomic_pop(page);
 	err = exofs_commit_chunk(page, 0, chunk_size);
 fail:
 	page_cache_release(page);
Index: linux-2.6/fs/ext2/dir.c
===================================================================
--- linux-2.6.orig/fs/ext2/dir.c
+++ linux-2.6/fs/ext2/dir.c
@@ -637,7 +637,7 @@ int ext2_make_empty(struct inode *inode,
 		unlock_page(page);
 		goto fail;
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memset(kaddr, 0, chunk_size);
 	de = (struct ext2_dir_entry_2 *)kaddr;
 	de->name_len = 1;
@@ -652,7 +652,7 @@ int ext2_make_empty(struct inode *inode,
 	de->inode = cpu_to_le32(parent->i_ino);
 	memcpy (de->name, "..\0", 4);
 	ext2_set_de_type (de, inode);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	err = ext2_commit_chunk(page, 0, chunk_size);
 fail:
 	page_cache_release(page);
Index: linux-2.6/fs/fuse/dev.c
===================================================================
--- linux-2.6.orig/fs/fuse/dev.c
+++ linux-2.6/fs/fuse/dev.c
@@ -523,7 +523,7 @@ static void fuse_copy_init(struct fuse_c
 static void fuse_copy_finish(struct fuse_copy_state *cs)
 {
 	if (cs->mapaddr) {
-		kunmap_atomic(cs->mapaddr, KM_USER0);
+		kmap_atomic_pop(cs->mapaddr);
 		if (cs->write) {
 			flush_dcache_page(cs->pg);
 			set_page_dirty_lock(cs->pg);
@@ -559,7 +559,7 @@ static int fuse_copy_fill(struct fuse_co
 		return err;
 	BUG_ON(err != 1);
 	offset = cs->addr % PAGE_SIZE;
-	cs->mapaddr = kmap_atomic(cs->pg, KM_USER0);
+	cs->mapaddr = kmap_atomic_push(cs->pg);
 	cs->buf = cs->mapaddr + offset;
 	cs->len = min(PAGE_SIZE - offset, cs->seglen);
 	cs->seglen -= cs->len;
@@ -593,9 +593,9 @@ static int fuse_copy_page(struct fuse_co
 			  unsigned offset, unsigned count, int zeroing)
 {
 	if (page && zeroing && count < PAGE_SIZE) {
-		void *mapaddr = kmap_atomic(page, KM_USER1);
+		void *mapaddr = kmap_atomic_push(page);
 		memset(mapaddr, 0, PAGE_SIZE);
-		kunmap_atomic(mapaddr, KM_USER1);
+		kmap_atomic_pop(mapaddr);
 	}
 	while (count) {
 		if (!cs->len) {
@@ -604,10 +604,10 @@ static int fuse_copy_page(struct fuse_co
 				return err;
 		}
 		if (page) {
-			void *mapaddr = kmap_atomic(page, KM_USER1);
+			void *mapaddr = kmap_atomic_push(page);
 			void *buf = mapaddr + offset;
 			offset += fuse_copy_do(cs, &buf, &count);
-			kunmap_atomic(mapaddr, KM_USER1);
+			kmap_atomic_pop(mapaddr);
 		} else
 			offset += fuse_copy_do(cs, NULL, &count);
 	}
Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c
+++ linux-2.6/fs/fuse/file.c
@@ -1791,9 +1791,9 @@ long fuse_do_ioctl(struct file *file, un
 			goto out;
 
 		/* okay, copy in iovs and retry */
-		vaddr = kmap_atomic(pages[0], KM_USER0);
+		vaddr = kmap_atomic_push(pages[0]);
 		memcpy(page_address(iov_page), vaddr, transferred);
-		kunmap_atomic(vaddr, KM_USER0);
+		kmap_atomic_pop(vaddr);
 
 		in_iov = page_address(iov_page);
 		out_iov = in_iov + in_iovs;
Index: linux-2.6/fs/gfs2/aops.c
===================================================================
--- linux-2.6.orig/fs/gfs2/aops.c
+++ linux-2.6/fs/gfs2/aops.c
@@ -448,11 +448,11 @@ static int stuffed_readpage(struct gfs2_
 	if (error)
 		return error;
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode),
 	       ip->i_disksize);
 	memset(kaddr + ip->i_disksize, 0, PAGE_CACHE_SIZE - ip->i_disksize);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	flush_dcache_page(page);
 	brelse(dibh);
 	SetPageUptodate(page);
@@ -555,9 +555,9 @@ int gfs2_internal_read(struct gfs2_inode
 		page = read_cache_page(mapping, index, __gfs2_readpage, NULL);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
-		p = kmap_atomic(page, KM_USER0);
+		p = kmap_atomic_push(page);
 		memcpy(buf + copied, p + offset, amt);
-		kunmap_atomic(p, KM_USER0);
+		kmap_atomic_pop(p);
 		mark_page_accessed(page);
 		page_cache_release(page);
 		copied += amt;
@@ -799,11 +799,11 @@ static int gfs2_stuffed_write_end(struct
 	struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
 
 	BUG_ON((pos + len) > (dibh->b_size - sizeof(struct gfs2_dinode)));
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memcpy(buf + pos, kaddr + pos, copied);
 	memset(kaddr + pos + copied, 0, len - copied);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
Index: linux-2.6/fs/gfs2/lops.c
===================================================================
--- linux-2.6.orig/fs/gfs2/lops.c
+++ linux-2.6/fs/gfs2/lops.c
@@ -539,11 +539,11 @@ static void gfs2_check_magic(struct buff
 	__be32 *ptr;
 
 	clear_buffer_escaped(bh);
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(bh->b_page);
 	ptr = kaddr + bh_offset(bh);
 	if (*ptr == cpu_to_be32(GFS2_MAGIC))
 		set_buffer_escaped(bh);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
@@ -580,10 +580,10 @@ static void gfs2_write_blocks(struct gfs
 		if (buffer_escaped(bd->bd_bh)) {
 			void *kaddr;
 			bh1 = gfs2_log_get_buf(sdp);
-			kaddr = kmap_atomic(bd->bd_bh->b_page, KM_USER0);
+			kaddr = kmap_atomic_push(bd->bd_bh->b_page);
 			memcpy(bh1->b_data, kaddr + bh_offset(bd->bd_bh),
 			       bh1->b_size);
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 			*(__be32 *)bh1->b_data = 0;
 			clear_buffer_escaped(bd->bd_bh);
 			unlock_buffer(bd->bd_bh);
Index: linux-2.6/fs/gfs2/quota.c
===================================================================
--- linux-2.6.orig/fs/gfs2/quota.c
+++ linux-2.6/fs/gfs2/quota.c
@@ -699,14 +699,14 @@ static int gfs2_adjust_quota(struct gfs2
 
 	gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	ptr = kaddr + offset;
 	gfs2_quota_in(&qp, ptr);
 	qp.qu_value += change;
 	value = qp.qu_value;
 	gfs2_quota_out(&qp, ptr);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	err = 0;
 	qd->qd_qb.qb_magic = cpu_to_be32(GFS2_MAGIC);
 	qd->qd_qb.qb_value = cpu_to_be64(value);
Index: linux-2.6/fs/jbd/journal.c
===================================================================
--- linux-2.6.orig/fs/jbd/journal.c
+++ linux-2.6/fs/jbd/journal.c
@@ -322,7 +322,7 @@ repeat:
 		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
 	}
 
-	mapped_data = kmap_atomic(new_page, KM_USER0);
+	mapped_data = kmap_atomic_push(new_page);
 	/*
 	 * Check for escaping
 	 */
@@ -331,7 +331,7 @@ repeat:
 		need_copy_out = 1;
 		do_escape = 1;
 	}
-	kunmap_atomic(mapped_data, KM_USER0);
+	kmap_atomic_pop(mapped_data);
 
 	/*
 	 * Do we need to do a data copy?
@@ -348,9 +348,9 @@ repeat:
 		}
 
 		jh_in->b_frozen_data = tmp;
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic_push(new_page);
 		memcpy(tmp, mapped_data + new_offset, jh2bh(jh_in)->b_size);
-		kunmap_atomic(mapped_data, KM_USER0);
+		kmap_atomic_pop(mapped_data);
 
 		new_page = virt_to_page(tmp);
 		new_offset = offset_in_page(tmp);
@@ -362,9 +362,9 @@ repeat:
 	 * copying, we can finally do so.
 	 */
 	if (do_escape) {
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic_push(new_page);
 		*((unsigned int *)(mapped_data + new_offset)) = 0;
-		kunmap_atomic(mapped_data, KM_USER0);
+		kmap_atomic_pop(mapped_data);
 	}
 
 	set_bh_page(new_bh, new_page, new_offset);
Index: linux-2.6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd/transaction.c
+++ linux-2.6/fs/jbd/transaction.c
@@ -714,9 +714,9 @@ done:
 			    "Possible IO failure.\n");
 		page = jh2bh(jh)->b_page;
 		offset = ((unsigned long) jh2bh(jh)->b_data) & ~PAGE_MASK;
-		source = kmap_atomic(page, KM_USER0);
+		source = kmap_atomic_push(page);
 		memcpy(jh->b_frozen_data, source+offset, jh2bh(jh)->b_size);
-		kunmap_atomic(source, KM_USER0);
+		kmap_atomic_pop(source);
 	}
 	jbd_unlock_bh_state(bh);
 
Index: linux-2.6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd2/commit.c
+++ linux-2.6/fs/jbd2/commit.c
@@ -324,10 +324,10 @@ static __u32 jbd2_checksum_data(__u32 cr
 	char *addr;
 	__u32 checksum;
 
-	addr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic_push(page);
 	checksum = crc32_be(crc32_sum,
 		(void *)(addr + offset_in_page(bh->b_data)), bh->b_size);
-	kunmap_atomic(addr, KM_USER0);
+	kmap_atomic_pop(addr);
 
 	return checksum;
 }
Index: linux-2.6/fs/jbd2/journal.c
===================================================================
--- linux-2.6.orig/fs/jbd2/journal.c
+++ linux-2.6/fs/jbd2/journal.c
@@ -331,7 +331,7 @@ repeat:
 		triggers = jh_in->b_triggers;
 	}
 
-	mapped_data = kmap_atomic(new_page, KM_USER0);
+	mapped_data = kmap_atomic_push(new_page);
 	/*
 	 * Fire any commit trigger.  Do this before checking for escaping,
 	 * as the trigger may modify the magic offset.  If a copy-out
@@ -348,7 +348,7 @@ repeat:
 		need_copy_out = 1;
 		do_escape = 1;
 	}
-	kunmap_atomic(mapped_data, KM_USER0);
+	kmap_atomic_pop(mapped_data);
 
 	/*
 	 * Do we need to do a data copy?
@@ -365,9 +365,9 @@ repeat:
 		}
 
 		jh_in->b_frozen_data = tmp;
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic_push(new_page);
 		memcpy(tmp, mapped_data + new_offset, jh2bh(jh_in)->b_size);
-		kunmap_atomic(mapped_data, KM_USER0);
+		kmap_atomic_pop(mapped_data);
 
 		new_page = virt_to_page(tmp);
 		new_offset = offset_in_page(tmp);
@@ -386,9 +386,9 @@ repeat:
 	 * copying, we can finally do so.
 	 */
 	if (do_escape) {
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic_push(new_page);
 		*((unsigned int *)(mapped_data + new_offset)) = 0;
-		kunmap_atomic(mapped_data, KM_USER0);
+		kmap_atomic_pop(mapped_data);
 	}
 
 	set_bh_page(new_bh, new_page, new_offset);
Index: linux-2.6/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd2/transaction.c
+++ linux-2.6/fs/jbd2/transaction.c
@@ -724,9 +724,9 @@ done:
 			    "Possible IO failure.\n");
 		page = jh2bh(jh)->b_page;
 		offset = ((unsigned long) jh2bh(jh)->b_data) & ~PAGE_MASK;
-		source = kmap_atomic(page, KM_USER0);
+		source = kmap_atomic_push(page);
 		memcpy(jh->b_frozen_data, source+offset, jh2bh(jh)->b_size);
-		kunmap_atomic(source, KM_USER0);
+		kmap_atomic_pop(source);
 
 		/*
 		 * Now that the frozen data is saved off, we need to store
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -396,10 +396,10 @@ int simple_write_end(struct file *file, 
 
 	/* zero the stale part of the page if we did a short copy */
 	if (copied < len) {
-		void *kaddr = kmap_atomic(page, KM_USER0);
+		void *kaddr = kmap_atomic_push(page);
 		memset(kaddr + from + copied, 0, len - copied);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 
 	simple_commit_write(file, page, from, from+copied);
Index: linux-2.6/fs/minix/dir.c
===================================================================
--- linux-2.6.orig/fs/minix/dir.c
+++ linux-2.6/fs/minix/dir.c
@@ -347,7 +347,7 @@ int minix_make_empty(struct inode *inode
 		goto fail;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memset(kaddr, 0, PAGE_CACHE_SIZE);
 
 	if (sbi->s_version == MINIX_V3) {
@@ -367,7 +367,7 @@ int minix_make_empty(struct inode *inode
 		de->inode = dir->i_ino;
 		strcpy(de->name, "..");
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	err = dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
 fail:
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2893,9 +2893,9 @@ retry:
 	if (err)
 		goto fail;
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memcpy(kaddr, symname, len-1);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	err = pagecache_write_end(NULL, mapping, 0, len-1, len-1,
 							page, fsdata);
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c
+++ linux-2.6/fs/nfs/dir.c
@@ -1493,11 +1493,11 @@ static int nfs_symlink(struct inode *dir
 	if (!page)
 		return -ENOMEM;
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memcpy(kaddr, symname, pathlen);
 	if (pathlen < PAGE_SIZE)
 		memset(kaddr + pathlen, 0, PAGE_SIZE - pathlen);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	error = NFS_PROTO(dir)->symlink(dir, dentry, page, pathlen, &attr);
 	if (error != 0) {
Index: linux-2.6/fs/nfs/nfs2xdr.c
===================================================================
--- linux-2.6.orig/fs/nfs/nfs2xdr.c
+++ linux-2.6/fs/nfs/nfs2xdr.c
@@ -447,7 +447,7 @@ nfs_xdr_readdirres(struct rpc_rqst *req,
 	if (pglen > recvd)
 		pglen = recvd;
 	page = rcvbuf->pages;
-	kaddr = p = kmap_atomic(*page, KM_USER0);
+	kaddr = p = kmap_atomic_push(*page);
 	end = (__be32 *)((char *)p + pglen);
 	entry = p;
 
@@ -481,7 +481,7 @@ nfs_xdr_readdirres(struct rpc_rqst *req,
 		entry[1] = 1;
 	}
  out:
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	return nr;
  short_pkt:
 	/*
@@ -626,9 +626,9 @@ nfs_xdr_readlinkres(struct rpc_rqst *req
 	}
 
 	/* NULL terminate the string we got */
-	kaddr = (char *)kmap_atomic(rcvbuf->pages[0], KM_USER0);
+	kaddr = (char *)kmap_atomic_push(rcvbuf->pages[0]);
 	kaddr[len+rcvbuf->page_base] = '\0';
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	return 0;
 }
 
Index: linux-2.6/fs/nfs/nfs3xdr.c
===================================================================
--- linux-2.6.orig/fs/nfs/nfs3xdr.c
+++ linux-2.6/fs/nfs/nfs3xdr.c
@@ -537,7 +537,7 @@ nfs3_xdr_readdirres(struct rpc_rqst *req
 	if (pglen > recvd)
 		pglen = recvd;
 	page = rcvbuf->pages;
-	kaddr = p = kmap_atomic(*page, KM_USER0);
+	kaddr = p = kmap_atomic_push(*page);
 	end = (__be32 *)((char *)p + pglen);
 	entry = p;
 
@@ -595,7 +595,7 @@ nfs3_xdr_readdirres(struct rpc_rqst *req
 		entry[1] = 1;
 	}
  out:
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	return nr;
  short_pkt:
 	/*
@@ -859,9 +859,9 @@ nfs3_xdr_readlinkres(struct rpc_rqst *re
 	}
 
 	/* NULL terminate the string we got */
-	kaddr = (char*)kmap_atomic(rcvbuf->pages[0], KM_USER0);
+	kaddr = (char*)kmap_atomic_push(rcvbuf->pages[0]);
 	kaddr[len+rcvbuf->page_base] = '\0';
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	return 0;
 }
 
Index: linux-2.6/fs/nfs/nfs4proc.c
===================================================================
--- linux-2.6.orig/fs/nfs/nfs4proc.c
+++ linux-2.6/fs/nfs/nfs4proc.c
@@ -165,7 +165,7 @@ static void nfs4_setup_readdir(u64 cooki
 	 * when talking to the server, we always send cookie 0
 	 * instead of 1 or 2.
 	 */
-	start = p = kmap_atomic(*readdir->pages, KM_USER0);
+	start = p = kmap_atomic_push(*readdir->pages);
 	
 	if (cookie == 0) {
 		*p++ = xdr_one;                                  /* next */
@@ -193,7 +193,7 @@ static void nfs4_setup_readdir(u64 cooki
 
 	readdir->pgbase = (char *)p - (char *)start;
 	readdir->count -= readdir->pgbase;
-	kunmap_atomic(start, KM_USER0);
+	kmap_atomic_pop(start);
 }
 
 static int nfs4_wait_clnt_recover(struct nfs_client *clp)
Index: linux-2.6/fs/nfs/nfs4xdr.c
===================================================================
--- linux-2.6.orig/fs/nfs/nfs4xdr.c
+++ linux-2.6/fs/nfs/nfs4xdr.c
@@ -4098,7 +4098,7 @@ static int decode_readdir(struct xdr_str
 	xdr_read_pages(xdr, pglen);
 
 	BUG_ON(pglen + readdir->pgbase > PAGE_CACHE_SIZE);
-	kaddr = p = kmap_atomic(page, KM_USER0);
+	kaddr = p = kmap_atomic_push(page);
 	end = p + ((pglen + readdir->pgbase) >> 2);
 	entry = p;
 
@@ -4143,7 +4143,7 @@ static int decode_readdir(struct xdr_str
 		entry[1] = 1;
 	}
 out:
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	return 0;
 short_pkt:
 	/*
@@ -4160,7 +4160,7 @@ short_pkt:
 	if (nr)
 		goto out;
 err_unmap:
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	return -errno_NFSERR_IO;
 }
 
@@ -4202,9 +4202,9 @@ static int decode_readlink(struct xdr_st
 	 * and and null-terminate the text (the VFS expects
 	 * null-termination).
 	 */
-	kaddr = (char *)kmap_atomic(rcvbuf->pages[0], KM_USER0);
+	kaddr = (char *)kmap_atomic_push(rcvbuf->pages[0]);
 	kaddr[len+rcvbuf->page_base] = '\0';
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	return 0;
 out_overflow:
 	print_overflow_msg(__func__, xdr);
Index: linux-2.6/fs/nilfs2/cpfile.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/cpfile.c
+++ linux-2.6/fs/nilfs2/cpfile.c
@@ -218,11 +218,11 @@ int nilfs_cpfile_get_checkpoint(struct i
 								 kaddr, 1);
 		nilfs_mdt_mark_buffer_dirty(cp_bh);
 
-		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic_push(header_bh->b_page);
 		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
 						       kaddr);
 		le64_add_cpu(&header->ch_ncheckpoints, 1);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		nilfs_mdt_mark_buffer_dirty(header_bh);
 		nilfs_mdt_mark_dirty(cpfile);
 	}
@@ -313,7 +313,7 @@ int nilfs_cpfile_delete_checkpoints(stru
 			continue;
 		}
 
-		kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic_push(cp_bh->b_page);
 		cp = nilfs_cpfile_block_get_checkpoint(
 			cpfile, cno, cp_bh, kaddr);
 		nicps = 0;
@@ -332,7 +332,7 @@ int nilfs_cpfile_delete_checkpoints(stru
 			    (count = nilfs_cpfile_block_sub_valid_checkpoints(
 				    cpfile, cp_bh, kaddr, nicps)) == 0) {
 				/* make hole */
-				kunmap_atomic(kaddr, KM_USER0);
+				kmap_atomic_pop(kaddr);
 				brelse(cp_bh);
 				ret = nilfs_cpfile_delete_checkpoint_block(
 					cpfile, cno);
@@ -344,18 +344,18 @@ int nilfs_cpfile_delete_checkpoints(stru
 			}
 		}
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		brelse(cp_bh);
 	}
 
 	if (tnicps > 0) {
-		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic_push(header_bh->b_page);
 		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
 						       kaddr);
 		le64_add_cpu(&header->ch_ncheckpoints, -(u64)tnicps);
 		nilfs_mdt_mark_buffer_dirty(header_bh);
 		nilfs_mdt_mark_dirty(cpfile);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 
 	brelse(header_bh);
@@ -403,7 +403,7 @@ static ssize_t nilfs_cpfile_do_get_cpinf
 			continue; /* skip hole */
 		}
 
-		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		kaddr = kmap_atomic_push(bh->b_page);
 		cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
 		for (i = 0; i < ncps && n < nci; i++, cp = (void *)cp + cpsz) {
 			if (!nilfs_checkpoint_invalid(cp)) {
@@ -413,7 +413,7 @@ static ssize_t nilfs_cpfile_do_get_cpinf
 				n++;
 			}
 		}
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		brelse(bh);
 	}
 
@@ -446,10 +446,10 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 		ret = nilfs_cpfile_get_header_block(cpfile, &bh);
 		if (ret < 0)
 			goto out;
-		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		kaddr = kmap_atomic_push(bh->b_page);
 		header = nilfs_cpfile_block_get_header(cpfile, bh, kaddr);
 		curr = le64_to_cpu(header->ch_snapshot_list.ssl_next);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		brelse(bh);
 		if (curr == 0) {
 			ret = 0;
@@ -467,7 +467,7 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 			ret = 0; /* No snapshots (started from a hole block) */
 		goto out;
 	}
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(bh->b_page);
 	while (n < nci) {
 		cp = nilfs_cpfile_block_get_checkpoint(cpfile, curr, bh, kaddr);
 		curr = ~(__u64)0; /* Terminator */
@@ -483,7 +483,7 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 
 		next_blkoff = nilfs_cpfile_get_blkoff(cpfile, next);
 		if (curr_blkoff != next_blkoff) {
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 			brelse(bh);
 			ret = nilfs_cpfile_get_checkpoint_block(cpfile, next,
 								0, &bh);
@@ -491,12 +491,12 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 				WARN_ON(ret == -ENOENT);
 				goto out;
 			}
-			kaddr = kmap_atomic(bh->b_page, KM_USER0);
+			kaddr = kmap_atomic_push(bh->b_page);
 		}
 		curr = next;
 		curr_blkoff = next_blkoff;
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	brelse(bh);
 	*cnop = curr;
 	ret = n;
@@ -587,24 +587,24 @@ static int nilfs_cpfile_set_snapshot(str
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
 	if (ret < 0)
 		goto out_sem;
-	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(cp_bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
 	if (nilfs_checkpoint_invalid(cp)) {
 		ret = -ENOENT;
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		goto out_cp;
 	}
 	if (nilfs_checkpoint_snapshot(cp)) {
 		ret = 0;
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		goto out_cp;
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
 	if (ret < 0)
 		goto out_cp;
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(header_bh->b_page);
 	header = nilfs_cpfile_block_get_header(cpfile, header_bh, kaddr);
 	list = &header->ch_snapshot_list;
 	curr_bh = header_bh;
@@ -616,13 +616,13 @@ static int nilfs_cpfile_set_snapshot(str
 		prev_blkoff = nilfs_cpfile_get_blkoff(cpfile, prev);
 		curr = prev;
 		if (curr_blkoff != prev_blkoff) {
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 			brelse(curr_bh);
 			ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr,
 								0, &curr_bh);
 			if (ret < 0)
 				goto out_header;
-			kaddr = kmap_atomic(curr_bh->b_page, KM_USER0);
+			kaddr = kmap_atomic_push(curr_bh->b_page);
 		}
 		curr_blkoff = prev_blkoff;
 		cp = nilfs_cpfile_block_get_checkpoint(
@@ -630,7 +630,7 @@ static int nilfs_cpfile_set_snapshot(str
 		list = &cp->cp_snapshot_list;
 		prev = le64_to_cpu(list->ssl_prev);
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	if (prev != 0) {
 		ret = nilfs_cpfile_get_checkpoint_block(cpfile, prev, 0,
@@ -642,29 +642,29 @@ static int nilfs_cpfile_set_snapshot(str
 		get_bh(prev_bh);
 	}
 
-	kaddr = kmap_atomic(curr_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(curr_bh->b_page);
 	list = nilfs_cpfile_block_get_snapshot_list(
 		cpfile, curr, curr_bh, kaddr);
 	list->ssl_prev = cpu_to_le64(cno);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
-	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(cp_bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
 	cp->cp_snapshot_list.ssl_next = cpu_to_le64(curr);
 	cp->cp_snapshot_list.ssl_prev = cpu_to_le64(prev);
 	nilfs_checkpoint_set_snapshot(cp);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
-	kaddr = kmap_atomic(prev_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(prev_bh->b_page);
 	list = nilfs_cpfile_block_get_snapshot_list(
 		cpfile, prev, prev_bh, kaddr);
 	list->ssl_next = cpu_to_le64(cno);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(header_bh->b_page);
 	header = nilfs_cpfile_block_get_header(cpfile, header_bh, kaddr);
 	le64_add_cpu(&header->ch_nsnapshots, 1);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_mdt_mark_buffer_dirty(prev_bh);
 	nilfs_mdt_mark_buffer_dirty(curr_bh);
@@ -705,23 +705,23 @@ static int nilfs_cpfile_clear_snapshot(s
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
 	if (ret < 0)
 		goto out_sem;
-	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(cp_bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
 	if (nilfs_checkpoint_invalid(cp)) {
 		ret = -ENOENT;
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		goto out_cp;
 	}
 	if (!nilfs_checkpoint_snapshot(cp)) {
 		ret = 0;
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		goto out_cp;
 	}
 
 	list = &cp->cp_snapshot_list;
 	next = le64_to_cpu(list->ssl_next);
 	prev = le64_to_cpu(list->ssl_prev);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
 	if (ret < 0)
@@ -745,29 +745,29 @@ static int nilfs_cpfile_clear_snapshot(s
 		get_bh(prev_bh);
 	}
 
-	kaddr = kmap_atomic(next_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(next_bh->b_page);
 	list = nilfs_cpfile_block_get_snapshot_list(
 		cpfile, next, next_bh, kaddr);
 	list->ssl_prev = cpu_to_le64(prev);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
-	kaddr = kmap_atomic(prev_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(prev_bh->b_page);
 	list = nilfs_cpfile_block_get_snapshot_list(
 		cpfile, prev, prev_bh, kaddr);
 	list->ssl_next = cpu_to_le64(next);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
-	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(cp_bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
 	cp->cp_snapshot_list.ssl_next = cpu_to_le64(0);
 	cp->cp_snapshot_list.ssl_prev = cpu_to_le64(0);
 	nilfs_checkpoint_clear_snapshot(cp);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(header_bh->b_page);
 	header = nilfs_cpfile_block_get_header(cpfile, header_bh, kaddr);
 	le64_add_cpu(&header->ch_nsnapshots, -1);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_mdt_mark_buffer_dirty(next_bh);
 	nilfs_mdt_mark_buffer_dirty(prev_bh);
@@ -824,13 +824,13 @@ int nilfs_cpfile_is_snapshot(struct inod
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
 	if (ret < 0)
 		goto out;
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
 	if (nilfs_checkpoint_invalid(cp))
 		ret = -ENOENT;
 	else
 		ret = nilfs_checkpoint_snapshot(cp);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	brelse(bh);
 
  out:
@@ -916,12 +916,12 @@ int nilfs_cpfile_get_stat(struct inode *
 	ret = nilfs_cpfile_get_header_block(cpfile, &bh);
 	if (ret < 0)
 		goto out_sem;
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(bh->b_page);
 	header = nilfs_cpfile_block_get_header(cpfile, bh, kaddr);
 	cpstat->cs_cno = nilfs_mdt_cno(cpfile);
 	cpstat->cs_ncps = le64_to_cpu(header->ch_ncheckpoints);
 	cpstat->cs_nsss = le64_to_cpu(header->ch_nsnapshots);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	brelse(bh);
 
  out_sem:
Index: linux-2.6/fs/nilfs2/dat.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/dat.c
+++ linux-2.6/fs/nilfs2/dat.c
@@ -74,13 +74,13 @@ void nilfs_dat_commit_alloc(struct inode
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MAX);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_palloc_commit_alloc_entry(dat, req);
 	nilfs_dat_commit_entry(dat, req);
@@ -97,13 +97,13 @@ void nilfs_dat_commit_free(struct inode 
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
 	nilfs_palloc_commit_free_entry(dat, req);
@@ -124,12 +124,12 @@ void nilfs_dat_commit_start(struct inode
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(nilfs_mdt_cno(dat));
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
 }
@@ -148,12 +148,12 @@ int nilfs_dat_prepare_end(struct inode *
 		return ret;
 	}
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	if (blocknr == 0) {
 		ret = nilfs_palloc_prepare_free_entry(dat, req);
@@ -174,7 +174,7 @@ void nilfs_dat_commit_end(struct inode *
 	sector_t blocknr;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	end = start = le64_to_cpu(entry->de_start);
@@ -184,7 +184,7 @@ void nilfs_dat_commit_end(struct inode *
 	}
 	entry->de_end = cpu_to_le64(end);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	if (blocknr == 0)
 		nilfs_dat_commit_free(dat, req);
@@ -199,12 +199,12 @@ void nilfs_dat_abort_end(struct inode *d
 	sector_t blocknr;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	if (start == nilfs_mdt_cno(dat) && blocknr == 0)
 		nilfs_palloc_abort_free_entry(dat, req);
@@ -317,20 +317,20 @@ int nilfs_dat_move(struct inode *dat, __
 	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
 	if (ret < 0)
 		return ret;
-	kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	if (unlikely(entry->de_blocknr == cpu_to_le64(0))) {
 		printk(KERN_CRIT "%s: vbn = %llu, [%llu, %llu)\n", __func__,
 		       (unsigned long long)vblocknr,
 		       (unsigned long long)le64_to_cpu(entry->de_start),
 		       (unsigned long long)le64_to_cpu(entry->de_end));
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		brelse(entry_bh);
 		return -EINVAL;
 	}
 	WARN_ON(blocknr == 0);
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_mdt_mark_buffer_dirty(entry_bh);
 	nilfs_mdt_mark_dirty(dat);
@@ -371,7 +371,7 @@ int nilfs_dat_translate(struct inode *da
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	blocknr = le64_to_cpu(entry->de_blocknr);
 	if (blocknr == 0) {
@@ -382,7 +382,7 @@ int nilfs_dat_translate(struct inode *da
 		*blocknrp = blocknr;
 
  out:
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	brelse(entry_bh);
 	return ret;
 }
@@ -403,7 +403,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode
 						   0, &entry_bh);
 		if (ret < 0)
 			return ret;
-		kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic_push(entry_bh->b_page);
 		/* last virtual block number in this block */
 		first = vinfo->vi_vblocknr;
 		do_div(first, entries_per_block);
@@ -419,7 +419,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode
 			vinfo->vi_end = le64_to_cpu(entry->de_end);
 			vinfo->vi_blocknr = le64_to_cpu(entry->de_blocknr);
 		}
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		brelse(entry_bh);
 	}
 
Index: linux-2.6/fs/nilfs2/dir.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/dir.c
+++ linux-2.6/fs/nilfs2/dir.c
@@ -624,7 +624,7 @@ int nilfs_make_empty(struct inode *inode
 		unlock_page(page);
 		goto fail;
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memset(kaddr, 0, chunk_size);
 	de = (struct nilfs_dir_entry *)kaddr;
 	de->name_len = 1;
@@ -639,7 +639,7 @@ int nilfs_make_empty(struct inode *inode
 	de->inode = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, "..\0", 4);
 	nilfs_set_de_type(de, inode);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	err = nilfs_commit_chunk(page, mapping, 0, chunk_size);
 fail:
 	page_cache_release(page);
Index: linux-2.6/fs/nilfs2/ifile.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/ifile.c
+++ linux-2.6/fs/nilfs2/ifile.c
@@ -111,11 +111,11 @@ int nilfs_ifile_delete_inode(struct inod
 		return ret;
 	}
 
-	kaddr = kmap_atomic(req.pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(req.pr_entry_bh->b_page);
 	raw_inode = nilfs_palloc_block_get_entry(ifile, req.pr_entry_nr,
 						 req.pr_entry_bh, kaddr);
 	raw_inode->i_flags = 0;
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_mdt_mark_buffer_dirty(req.pr_entry_bh);
 	brelse(req.pr_entry_bh);
Index: linux-2.6/fs/nilfs2/mdt.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/mdt.c
+++ linux-2.6/fs/nilfs2/mdt.c
@@ -57,12 +57,12 @@ nilfs_mdt_insert_new_block(struct inode 
 
 	set_buffer_mapped(bh);
 
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(bh->b_page);
 	memset(kaddr + bh_offset(bh), 0, 1 << inode->i_blkbits);
 	if (init_block)
 		init_block(inode, bh, kaddr);
 	flush_dcache_page(bh->b_page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	set_buffer_uptodate(bh);
 	nilfs_mark_buffer_dirty(bh);
Index: linux-2.6/fs/nilfs2/page.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/page.c
+++ linux-2.6/fs/nilfs2/page.c
@@ -153,11 +153,11 @@ void nilfs_copy_buffer(struct buffer_hea
 	struct page *spage = sbh->b_page, *dpage = dbh->b_page;
 	struct buffer_head *bh;
 
-	kaddr0 = kmap_atomic(spage, KM_USER0);
-	kaddr1 = kmap_atomic(dpage, KM_USER1);
+	kaddr0 = kmap_atomic_push(spage);
+	kaddr1 = kmap_atomic_push(dpage);
 	memcpy(kaddr1 + bh_offset(dbh), kaddr0 + bh_offset(sbh), sbh->b_size);
-	kunmap_atomic(kaddr1, KM_USER1);
-	kunmap_atomic(kaddr0, KM_USER0);
+	kmap_atomic_pop(kaddr1);
+	kmap_atomic_pop(kaddr0);
 
 	dbh->b_state = sbh->b_state & NILFS_BUFFER_INHERENT_BITS;
 	dbh->b_blocknr = sbh->b_blocknr;
Index: linux-2.6/fs/nilfs2/recovery.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/recovery.c
+++ linux-2.6/fs/nilfs2/recovery.c
@@ -494,9 +494,9 @@ static int nilfs_recovery_copy_block(str
 	if (unlikely(!bh_org))
 		return -EIO;
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memcpy(kaddr + bh_offset(bh_org), bh_org->b_data, bh_org->b_size);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	brelse(bh_org);
 	return 0;
 }
Index: linux-2.6/fs/nilfs2/segbuf.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/segbuf.c
+++ linux-2.6/fs/nilfs2/segbuf.c
@@ -212,9 +212,9 @@ void nilfs_segbuf_fill_in_data_crc(struc
 		crc = crc32_le(crc, bh->b_data, bh->b_size);
 	}
 	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
-		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		kaddr = kmap_atomic_push(bh->b_page);
 		crc = crc32_le(crc, kaddr + bh_offset(bh), bh->b_size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 	raw_sum->ss_datasum = cpu_to_le32(crc);
 }
Index: linux-2.6/fs/nilfs2/segment.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/segment.c
+++ linux-2.6/fs/nilfs2/segment.c
@@ -1699,7 +1699,7 @@ nilfs_copy_replace_page_buffers(struct p
 		return -ENOMEM;
 
 	bh2 = page_buffers(clone_page);
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	do {
 		if (list_empty(&bh->b_assoc_buffers))
 			continue;
@@ -1710,7 +1710,7 @@ nilfs_copy_replace_page_buffers(struct p
 		list_replace(&bh->b_assoc_buffers, &bh2->b_assoc_buffers);
 		list_add_tail(&bh->b_assoc_buffers, out);
 	} while (bh = bh->b_this_page, bh2 = bh2->b_this_page, bh != head);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	if (!TestSetPageWriteback(clone_page))
 		inc_zone_page_state(clone_page, NR_WRITEBACK);
Index: linux-2.6/fs/nilfs2/sufile.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/sufile.c
+++ linux-2.6/fs/nilfs2/sufile.c
@@ -100,11 +100,11 @@ static void nilfs_sufile_mod_counter(str
 	struct nilfs_sufile_header *header;
 	void *kaddr;
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	le64_add_cpu(&header->sh_ncleansegs, ncleanadd);
 	le64_add_cpu(&header->sh_ndirtysegs, ndirtyadd);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_mdt_mark_buffer_dirty(header_bh);
 }
@@ -269,11 +269,11 @@ int nilfs_sufile_alloc(struct inode *suf
 	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
 	if (ret < 0)
 		goto out_sem;
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(header_bh->b_page);
 	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
 	ncleansegs = le64_to_cpu(header->sh_ncleansegs);
 	last_alloc = le64_to_cpu(header->sh_last_alloc);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nsegments = nilfs_sufile_get_nsegments(sufile);
 	segnum = last_alloc + 1;
@@ -288,7 +288,7 @@ int nilfs_sufile_alloc(struct inode *suf
 							   &su_bh);
 		if (ret < 0)
 			goto out_header;
-		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic_push(su_bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum, su_bh, kaddr);
 
@@ -299,15 +299,15 @@ int nilfs_sufile_alloc(struct inode *suf
 				continue;
 			/* found a clean segment */
 			nilfs_segment_usage_set_dirty(su);
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 
-			kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+			kaddr = kmap_atomic_push(header_bh->b_page);
 			header = nilfs_sufile_block_get_header(
 				sufile, header_bh, kaddr);
 			le64_add_cpu(&header->sh_ncleansegs, -1);
 			le64_add_cpu(&header->sh_ndirtysegs, 1);
 			header->sh_last_alloc = cpu_to_le64(segnum);
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 
 			nilfs_mdt_mark_buffer_dirty(header_bh);
 			nilfs_mdt_mark_buffer_dirty(su_bh);
@@ -317,7 +317,7 @@ int nilfs_sufile_alloc(struct inode *suf
 			goto out_header;
 		}
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		brelse(su_bh);
 	}
 
@@ -339,16 +339,16 @@ void nilfs_sufile_do_cancel_free(struct 
 	struct nilfs_segment_usage *su;
 	void *kaddr;
 
-	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (unlikely(!nilfs_segment_usage_clean(su))) {
 		printk(KERN_WARNING "%s: segment %llu must be clean\n",
 		       __func__, (unsigned long long)segnum);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		return;
 	}
 	nilfs_segment_usage_set_dirty(su);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_sufile_mod_counter(header_bh, -1, 1);
 	nilfs_mdt_mark_buffer_dirty(su_bh);
@@ -363,11 +363,11 @@ void nilfs_sufile_do_scrap(struct inode 
 	void *kaddr;
 	int clean, dirty;
 
-	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (su->su_flags == cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY) &&
 	    su->su_nblocks == cpu_to_le32(0)) {
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		return;
 	}
 	clean = nilfs_segment_usage_clean(su);
@@ -377,7 +377,7 @@ void nilfs_sufile_do_scrap(struct inode 
 	su->su_lastmod = cpu_to_le64(0);
 	su->su_nblocks = cpu_to_le32(0);
 	su->su_flags = cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
 	nilfs_mdt_mark_buffer_dirty(su_bh);
@@ -392,12 +392,12 @@ void nilfs_sufile_do_free(struct inode *
 	void *kaddr;
 	int sudirty;
 
-	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_clean(su)) {
 		printk(KERN_WARNING "%s: segment %llu is already clean\n",
 		       __func__, (unsigned long long)segnum);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		return;
 	}
 	WARN_ON(nilfs_segment_usage_error(su));
@@ -405,7 +405,7 @@ void nilfs_sufile_do_free(struct inode *
 
 	sudirty = nilfs_segment_usage_dirty(su);
 	nilfs_segment_usage_set_clean(su);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	nilfs_mdt_mark_buffer_dirty(su_bh);
 
 	nilfs_sufile_mod_counter(header_bh, 1, sudirty ? (u64)-1 : 0);
@@ -514,7 +514,7 @@ int nilfs_sufile_get_stat(struct inode *
 	if (ret < 0)
 		goto out_sem;
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(header_bh->b_page);
 	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
 	sustat->ss_nsegs = nilfs_sufile_get_nsegments(sufile);
 	sustat->ss_ncleansegs = le64_to_cpu(header->sh_ncleansegs);
@@ -524,7 +524,7 @@ int nilfs_sufile_get_stat(struct inode *
 	spin_lock(&nilfs->ns_last_segment_lock);
 	sustat->ss_prot_seq = nilfs->ns_prot_seq;
 	spin_unlock(&nilfs->ns_last_segment_lock);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	brelse(header_bh);
 
  out_sem:
@@ -567,15 +567,15 @@ void nilfs_sufile_do_set_error(struct in
 	void *kaddr;
 	int suclean;
 
-	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic_push(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_error(su)) {
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		return;
 	}
 	suclean = nilfs_segment_usage_clean(su);
 	nilfs_segment_usage_set_error(su);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	if (suclean)
 		nilfs_sufile_mod_counter(header_bh, -1, 0);
@@ -635,7 +635,7 @@ ssize_t nilfs_sufile_get_suinfo(struct i
 			continue;
 		}
 
-		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic_push(su_bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum, su_bh, kaddr);
 		for (j = 0; j < n;
@@ -648,7 +648,7 @@ ssize_t nilfs_sufile_get_suinfo(struct i
 				si->sui_flags |=
 					(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
 		}
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		brelse(su_bh);
 	}
 	ret = nsegs;
Index: linux-2.6/fs/ntfs/ChangeLog
===================================================================
--- linux-2.6.orig/fs/ntfs/ChangeLog
+++ linux-2.6/fs/ntfs/ChangeLog
@@ -952,7 +952,7 @@ ToDo/Notes:
 	- Pages are no longer kmapped by mm/filemap.c::generic_file_write()
 	  around calls to ->{prepare,commit}_write.  Adapt NTFS appropriately
 	  in fs/ntfs/aops.c::ntfs_prepare_nonresident_write() by using
-	  kmap_atomic(KM_USER0).
+	  kmap_atomic_push(KM_USER0).
 
 2.1.0 - First steps towards write support: implement file overwrite.
 
@@ -1579,7 +1579,7 @@ tng-0.0.4 - Big changes, getting in line
 	- Make ntfs_volume be allocated via kmalloc() instead of using a slab
 	  cache. There are too little ntfs_volume structures at any one time
 	  to justify a private slab cache.
-	- Fix bogus kmap() use in async io completion. Now use kmap_atomic().
+	- Fix bogus kmap() use in async io completion. Now use kmap_atomic_push().
 	  Use KM_BIO_IRQ on advice from IRC/kernel...
 	- Use ntfs_map_page() in map_mft_record() and create ->readpage method
 	  for reading $MFT (ntfs_mft_readpage). In the process create dedicated
Index: linux-2.6/fs/ntfs/aops.c
===================================================================
--- linux-2.6.orig/fs/ntfs/aops.c
+++ linux-2.6/fs/ntfs/aops.c
@@ -93,11 +93,11 @@ static void ntfs_end_buffer_async_read(s
 			if (file_ofs < init_size)
 				ofs = init_size - file_ofs;
 			local_irq_save(flags);
-			kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
+			kaddr = kmap_atomic_push(page);
 			memset(kaddr + bh_offset(bh) + ofs, 0,
 					bh->b_size - ofs);
 			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
+			kmap_atomic_pop(kaddr);
 			local_irq_restore(flags);
 		}
 	} else {
@@ -146,11 +146,11 @@ static void ntfs_end_buffer_async_read(s
 		/* Should have been verified before we got here... */
 		BUG_ON(!recs);
 		local_irq_save(flags);
-		kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
+		kaddr = kmap_atomic_push(page);
 		for (i = 0; i < recs; i++)
 			post_read_mst_fixup((NTFS_RECORD*)(kaddr +
 					i * rec_size), rec_size);
-		kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
+		kmap_atomic_pop(kaddr);
 		local_irq_restore(flags);
 		flush_dcache_page(page);
 		if (likely(page_uptodate && !PageError(page)))
@@ -503,7 +503,7 @@ retry_readpage:
 		/* Race with shrinking truncate. */
 		attr_len = i_size;
 	}
-	addr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic_push(page);
 	/* Copy the data to the page. */
 	memcpy(addr, (u8*)ctx->attr +
 			le16_to_cpu(ctx->attr->data.resident.value_offset),
@@ -511,7 +511,7 @@ retry_readpage:
 	/* Zero the remainder of the page. */
 	memset(addr + attr_len, 0, PAGE_CACHE_SIZE - attr_len);
 	flush_dcache_page(page);
-	kunmap_atomic(addr, KM_USER0);
+	kmap_atomic_pop(addr);
 put_unm_err_out:
 	ntfs_attr_put_search_ctx(ctx);
 unm_err_out:
@@ -745,14 +745,14 @@ lock_retry_remap:
 			unsigned long *bpos, *bend;
 
 			/* Check if the buffer is zero. */
-			kaddr = kmap_atomic(page, KM_USER0);
+			kaddr = kmap_atomic_push(page);
 			bpos = (unsigned long *)(kaddr + bh_offset(bh));
 			bend = (unsigned long *)((u8*)bpos + blocksize);
 			do {
 				if (unlikely(*bpos))
 					break;
 			} while (likely(++bpos < bend));
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 			if (bpos == bend) {
 				/*
 				 * Buffer is zero and sparse, no need to write
@@ -1494,14 +1494,14 @@ retry_writepage:
 		/* Shrinking cannot fail. */
 		BUG_ON(err);
 	}
-	addr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic_push(page);
 	/* Copy the data from the page to the mft record. */
 	memcpy((u8*)ctx->attr +
 			le16_to_cpu(ctx->attr->data.resident.value_offset),
 			addr, attr_len);
 	/* Zero out of bounds area in the page cache page. */
 	memset(addr + attr_len, 0, PAGE_CACHE_SIZE - attr_len);
-	kunmap_atomic(addr, KM_USER0);
+	kmap_atomic_pop(addr);
 	flush_dcache_page(page);
 	flush_dcache_mft_record_page(ctx->ntfs_ino);
 	/* We are done with the page. */
Index: linux-2.6/fs/ntfs/attrib.c
===================================================================
--- linux-2.6.orig/fs/ntfs/attrib.c
+++ linux-2.6/fs/ntfs/attrib.c
@@ -1655,12 +1655,12 @@ int ntfs_attr_make_non_resident(ntfs_ino
 	attr_size = le32_to_cpu(a->data.resident.value_length);
 	BUG_ON(attr_size != data_size);
 	if (page && !PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		memcpy(kaddr, (u8*)a +
 				le16_to_cpu(a->data.resident.value_offset),
 				attr_size);
 		memset(kaddr + attr_size, 0, PAGE_CACHE_SIZE - attr_size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 	}
@@ -1805,9 +1805,9 @@ undo_err_out:
 			sizeof(a->data.resident.reserved));
 	/* Copy the data from the page back to the attribute value. */
 	if (page) {
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		memcpy((u8*)a + mp_ofs, kaddr, attr_size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 	/* Setup the allocated size in the ntfs inode in case it changed. */
 	write_lock_irqsave(&ni->size_lock, flags);
@@ -2539,10 +2539,10 @@ int ntfs_attr_set(ntfs_inode *ni, const 
 		size = PAGE_CACHE_SIZE;
 		if (idx == end)
 			size = end_ofs;
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		memset(kaddr + start_ofs, val, size - start_ofs);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		set_page_dirty(page);
 		page_cache_release(page);
 		balance_dirty_pages_ratelimited(mapping);
@@ -2560,10 +2560,10 @@ int ntfs_attr_set(ntfs_inode *ni, const 
 					"page (index 0x%lx).", idx);
 			return -ENOMEM;
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		memset(kaddr, val, PAGE_CACHE_SIZE);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		/*
 		 * If the page has buffers, mark them uptodate since buffer
 		 * state and not page state is definitive in 2.6 kernels.
@@ -2597,10 +2597,10 @@ int ntfs_attr_set(ntfs_inode *ni, const 
 					"(error, index 0x%lx).", idx);
 			return PTR_ERR(page);
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		memset(kaddr, val, end_ofs);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		set_page_dirty(page);
 		page_cache_release(page);
 		balance_dirty_pages_ratelimited(mapping);
Index: linux-2.6/fs/ntfs/file.c
===================================================================
--- linux-2.6.orig/fs/ntfs/file.c
+++ linux-2.6/fs/ntfs/file.c
@@ -715,7 +715,7 @@ map_buffer_cached:
 				u8 *kaddr;
 				unsigned pofs;
 					
-				kaddr = kmap_atomic(page, KM_USER0);
+				kaddr = kmap_atomic_push(page);
 				if (bh_pos < pos) {
 					pofs = bh_pos & ~PAGE_CACHE_MASK;
 					memset(kaddr + pofs, 0, pos - bh_pos);
@@ -724,7 +724,7 @@ map_buffer_cached:
 					pofs = end & ~PAGE_CACHE_MASK;
 					memset(kaddr + pofs, 0, bh_end - end);
 				}
-				kunmap_atomic(kaddr, KM_USER0);
+				kmap_atomic_pop(kaddr);
 				flush_dcache_page(page);
 			}
 			continue;
@@ -1298,9 +1298,9 @@ static inline size_t ntfs_copy_from_user
 		len = PAGE_CACHE_SIZE - ofs;
 		if (len > bytes)
 			len = bytes;
-		addr = kmap_atomic(*pages, KM_USER0);
+		addr = kmap_atomic_push(*pages);
 		left = __copy_from_user_inatomic(addr + ofs, buf, len);
-		kunmap_atomic(addr, KM_USER0);
+		kmap_atomic_pop(addr);
 		if (unlikely(left)) {
 			/* Do it the slow way. */
 			addr = kmap(*pages);
@@ -1413,10 +1413,10 @@ static inline size_t ntfs_copy_from_user
 		len = PAGE_CACHE_SIZE - ofs;
 		if (len > bytes)
 			len = bytes;
-		addr = kmap_atomic(*pages, KM_USER0);
+		addr = kmap_atomic_push(*pages);
 		copied = __ntfs_copy_from_user_iovec_inatomic(addr + ofs,
 				*iov, *iov_ofs, len);
-		kunmap_atomic(addr, KM_USER0);
+		kmap_atomic_pop(addr);
 		if (unlikely(copied != len)) {
 			/* Do it the slow way. */
 			addr = kmap(*pages);
@@ -1703,7 +1703,7 @@ static int ntfs_commit_pages_after_write
 	BUG_ON(end > le32_to_cpu(a->length) -
 			le16_to_cpu(a->data.resident.value_offset));
 	kattr = (u8*)a + le16_to_cpu(a->data.resident.value_offset);
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	/* Copy the received data from the page to the mft record. */
 	memcpy(kattr + pos, kaddr + pos, bytes);
 	/* Update the attribute length if necessary. */
@@ -1725,7 +1725,7 @@ static int ntfs_commit_pages_after_write
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	/* Update initialized_size/i_size if necessary. */
 	read_lock_irqsave(&ni->size_lock, flags);
 	initialized_size = ni->initialized_size;
Index: linux-2.6/fs/ntfs/super.c
===================================================================
--- linux-2.6.orig/fs/ntfs/super.c
+++ linux-2.6/fs/ntfs/super.c
@@ -2489,7 +2489,7 @@ static s64 get_nr_free_clusters(ntfs_vol
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = (u32*)kmap_atomic_push(page);
 		/*
 		 * For each 4 bytes, subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
@@ -2499,7 +2499,7 @@ static s64 get_nr_free_clusters(ntfs_vol
 		 */
 	  	for (i = 0; i < PAGE_CACHE_SIZE / 4; i++)
 			nr_free -= (s64)hweight32(kaddr[i]);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		page_cache_release(page);
 	}
 	ntfs_debug("Finished reading $Bitmap, last index = 0x%lx.", index - 1);
@@ -2560,7 +2560,7 @@ static unsigned long __get_nr_free_mft_r
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = (u32*)kmap_atomic_push(page);
 		/*
 		 * For each 4 bytes, subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
@@ -2570,7 +2570,7 @@ static unsigned long __get_nr_free_mft_r
 		 */
 	  	for (i = 0; i < PAGE_CACHE_SIZE / 4; i++)
 			nr_free -= (s64)hweight32(kaddr[i]);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		page_cache_release(page);
 	}
 	ntfs_debug("Finished reading $MFT/$BITMAP, last index = 0x%lx.",
Index: linux-2.6/fs/ocfs2/aops.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/aops.c
+++ linux-2.6/fs/ocfs2/aops.c
@@ -101,7 +101,7 @@ static int ocfs2_symlink_get_block(struc
 		 * copy, the data is still good. */
 		if (buffer_jbd(buffer_cache_bh)
 		    && ocfs2_inode_is_new(inode)) {
-			kaddr = kmap_atomic(bh_result->b_page, KM_USER0);
+			kaddr = kmap_atomic_push(bh_result->b_page);
 			if (!kaddr) {
 				mlog(ML_ERROR, "couldn't kmap!\n");
 				goto bail;
@@ -109,7 +109,7 @@ static int ocfs2_symlink_get_block(struc
 			memcpy(kaddr + (bh_result->b_size * iblock),
 			       buffer_cache_bh->b_data,
 			       bh_result->b_size);
-			kunmap_atomic(kaddr, KM_USER0);
+			kmap_atomic_pop(kaddr);
 			set_buffer_uptodate(bh_result);
 		}
 		brelse(buffer_cache_bh);
@@ -237,13 +237,13 @@ int ocfs2_read_inline_data(struct inode 
 		return -EROFS;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	if (size)
 		memcpy(kaddr, di->id2.i_data.id_data, size);
 	/* Clear the remaining part of the page */
 	memset(kaddr + size, 0, PAGE_CACHE_SIZE - size);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	SetPageUptodate(page);
 
@@ -748,7 +748,7 @@ static void ocfs2_clear_page_regions(str
 
 	ocfs2_figure_cluster_boundaries(osb, cpos, &cluster_start, &cluster_end);
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 
 	if (from || to) {
 		if (from > cluster_start)
@@ -759,7 +759,7 @@ static void ocfs2_clear_page_regions(str
 		memset(kaddr + cluster_start, 0, cluster_end - cluster_start);
 	}
 
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 /*
@@ -1907,9 +1907,9 @@ static void ocfs2_write_end_inline(struc
 		}
 	}
 
-	kaddr = kmap_atomic(wc->w_target_page, KM_USER0);
+	kaddr = kmap_atomic_push(wc->w_target_page);
 	memcpy(di->id2.i_data.id_data + pos, kaddr + pos, *copied);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	mlog(0, "Data written to inode at offset %llu. "
 	     "id_count = %u, copied = %u, i_dyn_features = 0x%x\n",
Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c
+++ linux-2.6/fs/pipe.c
@@ -217,7 +217,7 @@ void *generic_pipe_buf_map(struct pipe_i
 {
 	if (atomic) {
 		buf->flags |= PIPE_BUF_FLAG_ATOMIC;
-		return kmap_atomic(buf->page, KM_USER0);
+		return kmap_atomic_push(buf->page);
 	}
 
 	return kmap(buf->page);
@@ -237,7 +237,7 @@ void generic_pipe_buf_unmap(struct pipe_
 {
 	if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
 		buf->flags &= ~PIPE_BUF_FLAG_ATOMIC;
-		kunmap_atomic(map_data, KM_USER0);
+		kmap_atomic_pop(map_data);
 	} else
 		kunmap(buf->page);
 }
@@ -546,14 +546,14 @@ redo1:
 			iov_fault_in_pages_read(iov, chars);
 redo2:
 			if (atomic)
-				src = kmap_atomic(page, KM_USER0);
+				src = kmap_atomic_push(page);
 			else
 				src = kmap(page);
 
 			error = pipe_iov_copy_from_user(src, iov, chars,
 							atomic);
 			if (atomic)
-				kunmap_atomic(src, KM_USER0);
+				kmap_atomic_pop(src);
 			else
 				kunmap(page);
 
Index: linux-2.6/fs/reiserfs/stree.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/stree.c
+++ linux-2.6/fs/reiserfs/stree.c
@@ -1247,12 +1247,12 @@ int reiserfs_delete_item(struct reiserfs
 		 ** -clm
 		 */
 
-		data = kmap_atomic(un_bh->b_page, KM_USER0);
+		data = kmap_atomic_push(un_bh->b_page);
 		off = ((le_ih_k_offset(&s_ih) - 1) & (PAGE_CACHE_SIZE - 1));
 		memcpy(data + off,
 		       B_I_PITEM(PATH_PLAST_BUFFER(path), &s_ih),
 		       ret_value);
-		kunmap_atomic(data, KM_USER0);
+		kmap_atomic_pop(data);
 	}
 	/* Perform balancing after all resources have been collected at once. */
 	do_balance(&s_del_balance, NULL, NULL, M_DELETE);
Index: linux-2.6/fs/reiserfs/tail_conversion.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/tail_conversion.c
+++ linux-2.6/fs/reiserfs/tail_conversion.c
@@ -128,9 +128,9 @@ int direct2indirect(struct reiserfs_tran
 	if (up_to_date_bh) {
 		unsigned pgoff =
 		    (tail_offset + total_tail - 1) & (PAGE_CACHE_SIZE - 1);
-		char *kaddr = kmap_atomic(up_to_date_bh->b_page, KM_USER0);
+		char *kaddr = kmap_atomic_push(up_to_date_bh->b_page);
 		memset(kaddr + pgoff, 0, blk_size - total_tail);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 	}
 
 	REISERFS_I(inode)->i_first_direct_byte = U32_MAX;
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c
+++ linux-2.6/fs/splice.c
@@ -709,11 +709,11 @@ int pipe_to_file(struct pipe_inode_info 
 		 * Careful, ->map() uses KM_USER0!
 		 */
 		char *src = buf->ops->map(pipe, buf, 1);
-		char *dst = kmap_atomic(page, KM_USER1);
+		char *dst = kmap_atomic_push(page);
 
 		memcpy(dst + offset, src + buf->offset, this_len);
 		flush_dcache_page(page);
-		kunmap_atomic(dst, KM_USER1);
+		kmap_atomic_pop(dst);
 		buf->ops->unmap(pipe, buf, src);
 	}
 	ret = pagecache_write_end(file, mapping, sd->pos, this_len, this_len,
Index: linux-2.6/fs/squashfs/file.c
===================================================================
--- linux-2.6.orig/fs/squashfs/file.c
+++ linux-2.6/fs/squashfs/file.c
@@ -465,10 +465,10 @@ static int squashfs_readpage(struct file
 		if (PageUptodate(push_page))
 			goto skip_page;
 
-		pageaddr = kmap_atomic(push_page, KM_USER0);
+		pageaddr = kmap_atomic_push(push_page);
 		squashfs_copy_data(pageaddr, buffer, offset, avail);
 		memset(pageaddr + avail, 0, PAGE_CACHE_SIZE - avail);
-		kunmap_atomic(pageaddr, KM_USER0);
+		kmap_atomic_pop(pageaddr);
 		flush_dcache_page(push_page);
 		SetPageUptodate(push_page);
 skip_page:
@@ -485,9 +485,9 @@ skip_page:
 error_out:
 	SetPageError(page);
 out:
-	pageaddr = kmap_atomic(page, KM_USER0);
+	pageaddr = kmap_atomic_push(page);
 	memset(pageaddr, 0, PAGE_CACHE_SIZE);
-	kunmap_atomic(pageaddr, KM_USER0);
+	kmap_atomic_pop(pageaddr);
 	flush_dcache_page(page);
 	if (!PageError(page))
 		SetPageUptodate(page);
Index: linux-2.6/fs/squashfs/symlink.c
===================================================================
--- linux-2.6.orig/fs/squashfs/symlink.c
+++ linux-2.6/fs/squashfs/symlink.c
@@ -76,7 +76,7 @@ static int squashfs_symlink_readpage(str
 	/*
 	 * Read length bytes from symlink metadata.  Squashfs_read_metadata
 	 * is not used here because it can sleep and we want to use
-	 * kmap_atomic to map the page.  Instead call the underlying
+	 * kmap_atomic_push to map the page.  Instead call the underlying
 	 * squashfs_cache_get routine.  As length bytes may overlap metadata
 	 * blocks, we may need to call squashfs_cache_get multiple times.
 	 */
@@ -90,14 +90,14 @@ static int squashfs_symlink_readpage(str
 			goto error_out;
 		}
 
-		pageaddr = kmap_atomic(page, KM_USER0);
+		pageaddr = kmap_atomic_push(page);
 		copied = squashfs_copy_data(pageaddr + bytes, entry, offset,
 								length - bytes);
 		if (copied == length - bytes)
 			memset(pageaddr + length, 0, PAGE_CACHE_SIZE - length);
 		else
 			block = entry->next_index;
-		kunmap_atomic(pageaddr, KM_USER0);
+		kmap_atomic_pop(pageaddr);
 		squashfs_cache_put(entry);
 	}
 
Index: linux-2.6/fs/ubifs/file.c
===================================================================
--- linux-2.6.orig/fs/ubifs/file.c
+++ linux-2.6/fs/ubifs/file.c
@@ -1033,10 +1033,10 @@ static int ubifs_writepage(struct page *
 	 * the page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memset(kaddr + len, 0, PAGE_CACHE_SIZE - len);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	if (i_size > synced_i_size) {
 		err = inode->i_sb->s_op->write_inode(inode, 1);
Index: linux-2.6/fs/udf/file.c
===================================================================
--- linux-2.6.orig/fs/udf/file.c
+++ linux-2.6/fs/udf/file.c
@@ -88,10 +88,10 @@ static int udf_adinicb_write_end(struct 
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr + offset,
 		kaddr + offset, copied);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
 }
Index: linux-2.6/include/crypto/scatterwalk.h
===================================================================
--- linux-2.6.orig/include/crypto/scatterwalk.h
+++ linux-2.6/include/crypto/scatterwalk.h
@@ -25,28 +25,6 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 
-static inline enum km_type crypto_kmap_type(int out)
-{
-	enum km_type type;
-
-	if (in_softirq())
-		type = out * (KM_SOFTIRQ1 - KM_SOFTIRQ0) + KM_SOFTIRQ0;
-	else
-		type = out * (KM_USER1 - KM_USER0) + KM_USER0;
-
-	return type;
-}
-
-static inline void *crypto_kmap(struct page *page, int out)
-{
-	return kmap_atomic(page, crypto_kmap_type(out));
-}
-
-static inline void crypto_kunmap(void *vaddr, int out)
-{
-	kunmap_atomic(vaddr, crypto_kmap_type(out));
-}
-
 static inline void crypto_yield(u32 flags)
 {
 	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
@@ -106,15 +84,16 @@ static inline struct page *scatterwalk_p
 	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
 }
 
-static inline void scatterwalk_unmap(void *vaddr, int out)
-{
-	crypto_kunmap(vaddr, out);
-}
-
 void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg);
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out);
-void *scatterwalk_map(struct scatter_walk *walk, int out);
+void *scatterwalk_map(struct scatter_walk *walk);
+
+static inline void scatterwalk_unmap(void *vaddr)
+{
+	kmap_atomic_pop(vaddr);
+}
+
 void scatterwalk_done(struct scatter_walk *walk, int out, int more);
 
 void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
Index: linux-2.6/include/linux/bio.h
===================================================================
--- linux-2.6.orig/include/linux/bio.h
+++ linux-2.6/include/linux/bio.h
@@ -246,11 +246,11 @@ static inline int bio_has_allocated_vec(
  * permanent PIO fall back, user is probably better off disabling highmem
  * I/O completely on that queue (see ide-dma for example)
  */
-#define __bio_kmap_atomic(bio, idx, kmtype)				\
-	(kmap_atomic(bio_iovec_idx((bio), (idx))->bv_page, kmtype) +	\
+#define __bio_kmap_atomic_push(bio, idx, kmtype)				\
+	(kmap_atomic_push(bio_iovec_idx((bio), (idx))->bv_page, kmtype) +	\
 		bio_iovec_idx((bio), (idx))->bv_offset)
 
-#define __bio_kunmap_atomic(addr, kmtype) kunmap_atomic(addr, kmtype)
+#define __bio_kmap_atomic_pop(addr, kmtype) kmap_atomic_pop(addr, kmtype)
 
 /*
  * merge helpers etc
@@ -463,7 +463,7 @@ static __always_inline char *bvec_kmap_i
 	 * balancing is a lot nicer this way
 	 */
 	local_irq_save(*flags);
-	addr = (unsigned long) kmap_atomic(bvec->bv_page, KM_BIO_SRC_IRQ);
+	addr = (unsigned long) kmap_atomic_push(bvec->bv_page);
 
 	BUG_ON(addr & ~PAGE_MASK);
 
@@ -475,7 +475,7 @@ static __always_inline void bvec_kunmap_
 {
 	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
 
-	kunmap_atomic((void *) ptr, KM_BIO_SRC_IRQ);
+	kmap_atomic_pop((void *) ptr);
 	local_irq_restore(*flags);
 }
 
Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h
+++ linux-2.6/include/linux/highmem.h
@@ -21,17 +21,25 @@ static inline void flush_kernel_dcache_p
 
 #include <asm/kmap_types.h>
 
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+DECLARE_PER_CPU(int, __kmap_atomic_depth);
 
-void debug_kmap_atomic(enum km_type type);
-
-#else
-
-static inline void debug_kmap_atomic(enum km_type type)
+static inline int kmap_atomic_push_idx(void)
 {
+	int idx = __get_cpu_var(__kmap_atomic_depth)++;
+#ifdef CONFIG_DEBUG_HIGHMEM
+	BUG_ON(idx > KM_TYPE_NR);
+#endif
+	return idx;
 }
 
+static inline int kmap_atomic_pop_idx(void)
+{
+	int idx = --__get_cpu_var(__kmap_atomic_depth);
+#ifdef CONFIG_DEBUG_HIGHMEM
+	BUG_ON(idx < 0);
 #endif
+	return idx;
+}
 
 #ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
@@ -59,18 +67,18 @@ static inline void kunmap(struct page *p
 {
 }
 
-static inline void *kmap_atomic(struct page *page, enum km_type idx)
+static inline void *kmap_atomic_push(struct page *page)
 {
 	pagefault_disable();
 	return page_address(page);
 }
-#define kmap_atomic_prot(page, idx, prot)	kmap_atomic(page, idx)
+#define kmap_atomic_push_prot(page, prot)	kmap_atomic_push(page)
 
-#define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
-#define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
+#define kmap_atomic_pop(addr)		do { pagefault_enable(); } while (0)
+#define kmap_atomic_push_pfn(pfn)	kmap_atomic_push(pfn_to_page(pfn))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
 
-#define kmap_flush_unused()	do {} while(0)
+#define kmap_flush_unused()		do {} while(0)
 #endif
 
 #endif /* CONFIG_HIGHMEM */
@@ -79,9 +87,9 @@ static inline void *kmap_atomic(struct p
 #ifndef clear_user_highpage
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *addr = kmap_atomic(page, KM_USER0);
+	void *addr = kmap_atomic_push(page);
 	clear_user_page(addr, vaddr, page);
-	kunmap_atomic(addr, KM_USER0);
+	kmap_atomic_pop(addr);
 }
 #endif
 
@@ -132,16 +140,16 @@ alloc_zeroed_user_highpage_movable(struc
 
 static inline void clear_highpage(struct page *page)
 {
-	void *kaddr = kmap_atomic(page, KM_USER0);
+	void *kaddr = kmap_atomic_push(page);
 	clear_page(kaddr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 }
 
 static inline void zero_user_segments(struct page *page,
 	unsigned start1, unsigned end1,
 	unsigned start2, unsigned end2)
 {
-	void *kaddr = kmap_atomic(page, KM_USER0);
+	void *kaddr = kmap_atomic_push(page);
 
 	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);
 
@@ -151,7 +159,7 @@ static inline void zero_user_segments(st
 	if (end2 > start2)
 		memset(kaddr + start2, 0, end2 - start2);
 
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 	flush_dcache_page(page);
 }
 
@@ -180,11 +188,11 @@ static inline void copy_user_highpage(st
 {
 	char *vfrom, *vto;
 
-	vfrom = kmap_atomic(from, KM_USER0);
-	vto = kmap_atomic(to, KM_USER1);
+	vfrom = kmap_atomic_push(from);
+	vto = kmap_atomic_push(to);
 	copy_user_page(vto, vfrom, vaddr, to);
-	kunmap_atomic(vfrom, KM_USER0);
-	kunmap_atomic(vto, KM_USER1);
+	kmap_atomic_pop(vfrom);
+	kmap_atomic_pop(vto);
 }
 
 #endif
@@ -193,11 +201,11 @@ static inline void copy_highpage(struct 
 {
 	char *vfrom, *vto;
 
-	vfrom = kmap_atomic(from, KM_USER0);
-	vto = kmap_atomic(to, KM_USER1);
+	vfrom = kmap_atomic_push(from);
+	vto = kmap_atomic_push(to);
 	copy_page(vto, vfrom);
-	kunmap_atomic(vfrom, KM_USER0);
-	kunmap_atomic(vto, KM_USER1);
+	kmap_atomic_pop(vfrom);
+	kmap_atomic_pop(vto);
 }
 
 #endif /* _LINUX_HIGHMEM_H */
Index: linux-2.6/include/linux/io-mapping.h
===================================================================
--- linux-2.6.orig/include/linux/io-mapping.h
+++ linux-2.6/include/linux/io-mapping.h
@@ -82,17 +82,18 @@ io_mapping_map_atomic_wc(struct io_mappi
 {
 	resource_size_t phys_addr;
 	unsigned long pfn;
+	pgprot_t prot = mapping->prot;
 
 	BUG_ON(offset >= mapping->size);
 	phys_addr = mapping->base + offset;
 	pfn = (unsigned long) (phys_addr >> PAGE_SHIFT);
-	return iomap_atomic_prot_pfn(pfn, KM_USER0, mapping->prot);
+	return iomap_atomic_push_prot_pfn(pfn, prot);
 }
 
 static inline void
 io_mapping_unmap_atomic(void *vaddr)
 {
-	iounmap_atomic(vaddr, KM_USER0);
+	iomap_atomic_pop(vaddr);
 }
 
 static inline void *
Index: linux-2.6/include/linux/scatterlist.h
===================================================================
--- linux-2.6.orig/include/linux/scatterlist.h
+++ linux-2.6/include/linux/scatterlist.h
@@ -241,7 +241,7 @@ size_t sg_copy_to_buffer(struct scatterl
  * continue later (e.g. at the next interrupt).
  */
 
-#define SG_MITER_ATOMIC		(1 << 0)	 /* use kmap_atomic */
+#define SG_MITER_ATOMIC		(1 << 0)	 /* use kmap_atomic_push */
 #define SG_MITER_TO_SG		(1 << 1)	/* flush back to phys on unmap */
 #define SG_MITER_FROM_SG	(1 << 2)	/* nop */
 
Index: linux-2.6/include/scsi/scsi_cmnd.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_cmnd.h
+++ linux-2.6/include/scsi/scsi_cmnd.h
@@ -138,9 +138,9 @@ extern void __scsi_put_command(struct Sc
 			       struct device *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
-extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
+extern void *scsi_kmap_atomic_push_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
-extern void scsi_kunmap_atomic_sg(void *virt);
+extern void scsi_kmap_atomic_pop_sg(void *virt);
 
 extern int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask);
 extern void scsi_release_buffers(struct scsi_cmnd *cmd);
Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -975,20 +975,20 @@ static void copy_data_page(unsigned long
 	s_page = pfn_to_page(src_pfn);
 	d_page = pfn_to_page(dst_pfn);
 	if (PageHighMem(s_page)) {
-		src = kmap_atomic(s_page, KM_USER0);
-		dst = kmap_atomic(d_page, KM_USER1);
+		src = kmap_atomic_push(s_page);
+		dst = kmap_atomic_push(d_page);
 		do_copy_page(dst, src);
-		kunmap_atomic(src, KM_USER0);
-		kunmap_atomic(dst, KM_USER1);
+		kmap_atomic_pop(src);
+		kmap_atomic_pop(dst);
 	} else {
 		if (PageHighMem(d_page)) {
 			/* Page pointed to by src may contain some kernel
-			 * data modified by kmap_atomic()
+			 * data modified by kmap_atomic_push()
 			 */
 			safe_copy_page(buffer, s_page);
-			dst = kmap_atomic(d_page, KM_USER0);
+			dst = kmap_atomic_push(d_page);
 			memcpy(dst, buffer, PAGE_SIZE);
-			kunmap_atomic(dst, KM_USER0);
+			kmap_atomic_pop(dst);
 		} else {
 			safe_copy_page(page_address(d_page), s_page);
 		}
@@ -1654,9 +1654,9 @@ int snapshot_read_next(struct snapshot_h
 				 */
 				void *kaddr;
 
-				kaddr = kmap_atomic(page, KM_USER0);
+				kaddr = kmap_atomic_push(page);
 				memcpy(buffer, kaddr, PAGE_SIZE);
-				kunmap_atomic(kaddr, KM_USER0);
+				kmap_atomic_pop(kaddr);
 				handle->buffer = buffer;
 			} else {
 				handle->buffer = page_address(page);
@@ -1947,9 +1947,9 @@ static void copy_last_highmem_page(void)
 	if (last_highmem_page) {
 		void *dst;
 
-		dst = kmap_atomic(last_highmem_page, KM_USER0);
+		dst = kmap_atomic_push(last_highmem_page);
 		memcpy(dst, buffer, PAGE_SIZE);
-		kunmap_atomic(dst, KM_USER0);
+		kmap_atomic_pop(dst);
 		last_highmem_page = NULL;
 	}
 }
@@ -2248,13 +2248,13 @@ swap_two_pages_data(struct page *p1, str
 {
 	void *kaddr1, *kaddr2;
 
-	kaddr1 = kmap_atomic(p1, KM_USER0);
-	kaddr2 = kmap_atomic(p2, KM_USER1);
+	kaddr1 = kmap_atomic_push(p1);
+	kaddr2 = kmap_atomic_push(p2);
 	memcpy(buf, kaddr1, PAGE_SIZE);
 	memcpy(kaddr1, kaddr2, PAGE_SIZE);
 	memcpy(kaddr2, buf, PAGE_SIZE);
-	kunmap_atomic(kaddr1, KM_USER0);
-	kunmap_atomic(kaddr2, KM_USER1);
+	kmap_atomic_pop(kaddr1);
+	kmap_atomic_pop(kaddr2);
 }
 
 /**
Index: linux-2.6/lib/scatterlist.c
===================================================================
--- linux-2.6.orig/lib/scatterlist.c
+++ linux-2.6/lib/scatterlist.c
@@ -366,7 +366,7 @@ bool sg_miter_next(struct sg_mapping_ite
 	miter->consumed = miter->length;
 
 	if (miter->__flags & SG_MITER_ATOMIC)
-		miter->addr = kmap_atomic(miter->page, KM_BIO_SRC_IRQ) + off;
+		miter->addr = kmap_atomic_push(miter->page) + off;
 	else
 		miter->addr = kmap(miter->page) + off;
 
@@ -400,7 +400,7 @@ void sg_miter_stop(struct sg_mapping_ite
 
 		if (miter->__flags & SG_MITER_ATOMIC) {
 			WARN_ON(!irqs_disabled());
-			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
+			kmap_atomic_pop(miter->addr);
 		} else
 			kunmap(miter->page);
 
Index: linux-2.6/lib/swiotlb.c
===================================================================
--- linux-2.6.orig/lib/swiotlb.c
+++ linux-2.6/lib/swiotlb.c
@@ -306,13 +306,12 @@ static void swiotlb_bounce(phys_addr_t p
 			sz = min_t(size_t, PAGE_SIZE - offset, size);
 
 			local_irq_save(flags);
-			buffer = kmap_atomic(pfn_to_page(pfn),
-					     KM_BOUNCE_READ);
+			buffer = kmap_atomic_push(pfn_to_page(pfn));
 			if (dir == DMA_TO_DEVICE)
 				memcpy(dma_addr, buffer + offset, sz);
 			else
 				memcpy(buffer + offset, dma_addr, sz);
-			kunmap_atomic(buffer, KM_BOUNCE_READ);
+			kmap_atomic_pop(buffer);
 			local_irq_restore(flags);
 
 			size -= sz;
Index: linux-2.6/mm/bounce.c
===================================================================
--- linux-2.6.orig/mm/bounce.c
+++ linux-2.6/mm/bounce.c
@@ -50,9 +50,9 @@ static void bounce_copy_vec(struct bio_v
 	unsigned char *vto;
 
 	local_irq_save(flags);
-	vto = kmap_atomic(to->bv_page, KM_BOUNCE_READ);
+	vto = kmap_atomic_push(to->bv_page);
 	memcpy(vto + to->bv_offset, vfrom, to->bv_len);
-	kunmap_atomic(vto, KM_BOUNCE_READ);
+	kmap_atomic_pop(vto);
 	local_irq_restore(flags);
 }
 
Index: linux-2.6/mm/debug-pagealloc.c
===================================================================
--- linux-2.6.orig/mm/debug-pagealloc.c
+++ linux-2.6/mm/debug-pagealloc.c
@@ -24,7 +24,7 @@ static void poison_highpage(struct page 
 	 * Page poisoning for highmem pages is not implemented.
 	 *
 	 * This can be called from interrupt contexts.
-	 * So we need to create a new kmap_atomic slot for this
+	 * So we need to create a new kmap_atomic_push slot for this
 	 * application and it will need interrupt protection.
 	 */
 }
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -1205,10 +1205,10 @@ int file_read_actor(read_descriptor_t *d
 	 * taking the kmap.
 	 */
 	if (!fault_in_pages_writeable(desc->arg.buf, size)) {
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		left = __copy_to_user_inatomic(desc->arg.buf,
 						kaddr + offset, size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		if (left == 0)
 			goto success;
 	}
@@ -1854,7 +1854,7 @@ size_t iov_iter_copy_from_user_atomic(st
 	size_t copied;
 
 	BUG_ON(!in_atomic());
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic_push(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
 		char __user *buf = i->iov->iov_base + i->iov_offset;
@@ -1864,7 +1864,7 @@ size_t iov_iter_copy_from_user_atomic(st
 		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
 						i->iov, i->iov_offset, bytes);
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kmap_atomic_pop(kaddr);
 
 	return copied;
 }
Index: linux-2.6/mm/highmem.c
===================================================================
--- linux-2.6.orig/mm/highmem.c
+++ linux-2.6/mm/highmem.c
@@ -38,6 +38,9 @@
  */
 #ifdef CONFIG_HIGHMEM
 
+DEFINE_PER_CPU(int, __kmap_atomic_depth);
+EXPORT_PER_CPU_SYMBOL_GPL(__kmap_atomic_depth);
+
 unsigned long totalhigh_pages __read_mostly;
 EXPORT_SYMBOL(totalhigh_pages);
 
@@ -421,48 +424,3 @@ void __init page_address_init(void)
 }
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
-
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
-
-void debug_kmap_atomic(enum km_type type)
-{
-	static unsigned warn_count = 10;
-
-	if (unlikely(warn_count == 0))
-		return;
-
-	if (unlikely(in_interrupt())) {
-		if (in_irq()) {
-			if (type != KM_IRQ0 && type != KM_IRQ1 &&
-			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
-			    type != KM_BOUNCE_READ) {
-				WARN_ON(1);
-				warn_count--;
-			}
-		} else if (!irqs_disabled()) {	/* softirq */
-			if (type != KM_IRQ0 && type != KM_IRQ1 &&
-			    type != KM_SOFTIRQ0 && type != KM_SOFTIRQ1 &&
-			    type != KM_SKB_SUNRPC_DATA &&
-			    type != KM_SKB_DATA_SOFTIRQ &&
-			    type != KM_BOUNCE_READ) {
-				WARN_ON(1);
-				warn_count--;
-			}
-		}
-	}
-
-	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
-			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
-		if (!irqs_disabled()) {
-			WARN_ON(1);
-			warn_count--;
-		}
-	} else if (type == KM_SOFTIRQ0 || type == KM_SOFTIRQ1) {
-		if (irq_count() == 0 && !irqs_disabled()) {
-			WARN_ON(1);
-			warn_count--;
-		}
-	}
-}
-
-#endif
Index: linux-2.6/mm/ksm.c
===================================================================
--- linux-2.6.orig/mm/ksm.c
+++ linux-2.6/mm/ksm.c
@@ -590,9 +590,9 @@ error:
 static u32 calc_checksum(struct page *page)
 {
 	u32 checksum;
-	void *addr = kmap_atomic(page, KM_USER0);
+	void *addr = kmap_atomic_push(page);
 	checksum = jhash2(addr, PAGE_SIZE / 4, 17);
-	kunmap_atomic(addr, KM_USER0);
+	kmap_atomic_pop(addr);
 	return checksum;
 }
 
@@ -601,11 +601,11 @@ static int memcmp_pages(struct page *pag
 	char *addr1, *addr2;
 	int ret;
 
-	addr1 = kmap_atomic(page1, KM_USER0);
-	addr2 = kmap_atomic(page2, KM_USER1);
+	addr1 = kmap_atomic_push(page1);
+	addr2 = kmap_atomic_push(page2);
 	ret = memcmp(addr1, addr2, PAGE_SIZE);
-	kunmap_atomic(addr2, KM_USER1);
-	kunmap_atomic(addr1, KM_USER0);
+	kmap_atomic_pop(addr2);
+	kmap_atomic_pop(addr1);
 	return ret;
 }
 
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -1947,7 +1947,7 @@ static inline void cow_user_page(struct 
 	 * fails, we just zero-fill it. Live with it.
 	 */
 	if (unlikely(!src)) {
-		void *kaddr = kmap_atomic(dst, KM_USER0);
+		void *kaddr = kmap_atomic_push(dst);
 		void __user *uaddr = (void __user *)(va & PAGE_MASK);
 
 		/*
@@ -1958,7 +1958,7 @@ static inline void cow_user_page(struct 
 		 */
 		if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE))
 			memset(kaddr, 0, PAGE_SIZE);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		flush_dcache_page(dst);
 	} else
 		copy_user_highpage(dst, src, va, vma);
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -141,17 +141,17 @@ static inline void shmem_dir_free(struct
 
 static struct page **shmem_dir_map(struct page *page)
 {
-	return (struct page **)kmap_atomic(page, KM_USER0);
+	return (struct page **)kmap_atomic_push(page);
 }
 
 static inline void shmem_dir_unmap(struct page **dir)
 {
-	kunmap_atomic(dir, KM_USER0);
+	kmap_atomic_pop(dir);
 }
 
 static swp_entry_t *shmem_swp_map(struct page *page)
 {
-	return (swp_entry_t *)kmap_atomic(page, KM_USER1);
+	return (swp_entry_t *)kmap_atomic_push(page);
 }
 
 static inline void shmem_swp_balance_unmap(void)
@@ -160,15 +160,15 @@ static inline void shmem_swp_balance_unm
 	 * When passing a pointer to an i_direct entry, to code which
 	 * also handles indirect entries and so will shmem_swp_unmap,
 	 * we must arrange for the preempt count to remain in balance.
-	 * What kmap_atomic of a lowmem page does depends on config
-	 * and architecture, so pretend to kmap_atomic some lowmem page.
+	 * What kmap_atomic_push of a lowmem page does depends on config
+	 * and architecture, so pretend to kmap_atomic_push some lowmem page.
 	 */
-	(void) kmap_atomic(ZERO_PAGE(0), KM_USER1);
+	(void) kmap_atomic_push(ZERO_PAGE(0));
 }
 
 static inline void shmem_swp_unmap(swp_entry_t *entry)
 {
-	kunmap_atomic(entry, KM_USER1);
+	kmap_atomic_pop(entry);
 }
 
 static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
@@ -1974,9 +1974,9 @@ static int shmem_symlink(struct inode *d
 		}
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic_push(page);
 		memcpy(kaddr, symname, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		kmap_atomic_pop(kaddr);
 		set_page_dirty(page);
 		unlock_page(page);
 		page_cache_release(page);
Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -1673,9 +1673,9 @@ static int aligned_vread(char *buf, char
 			 * we can expect USER0 is not used (see vread/vwrite's
 			 * function description)
 			 */
-			void *map = kmap_atomic(p, KM_USER0);
+			void *map = kmap_atomic_push(p);
 			memcpy(buf, map + offset, length);
-			kunmap_atomic(map, KM_USER0);
+			kmap_atomic_pop(map);
 		} else
 			memset(buf, 0, length);
 
@@ -1712,9 +1712,9 @@ static int aligned_vwrite(char *buf, cha
 			 * we can expect USER0 is not used (see vread/vwrite's
 			 * function description)
 			 */
-			void *map = kmap_atomic(p, KM_USER0);
+			void *map = kmap_atomic_push(p);
 			memcpy(map + offset, buf, length);
-			kunmap_atomic(map, KM_USER0);
+			kmap_atomic_pop(map);
 		}
 		addr += length;
 		buf += length;
Index: linux-2.6/net/core/kmap_skb.h
===================================================================
--- linux-2.6.orig/net/core/kmap_skb.h
+++ linux-2.6/net/core/kmap_skb.h
@@ -7,12 +7,12 @@ static inline void *kmap_skb_frag(const 
 
 	local_bh_disable();
 #endif
-	return kmap_atomic(frag->page, KM_SKB_DATA_SOFTIRQ);
+	return kmap_atomic_push(frag->page);
 }
 
 static inline void kunmap_skb_frag(void *vaddr)
 {
-	kunmap_atomic(vaddr, KM_SKB_DATA_SOFTIRQ);
+	kmap_atomic_pop(vaddr);
 #ifdef CONFIG_HIGHMEM
 	local_bh_enable();
 #endif
Index: linux-2.6/net/rds/ib_recv.c
===================================================================
--- linux-2.6.orig/net/rds/ib_recv.c
+++ linux-2.6/net/rds/ib_recv.c
@@ -577,11 +577,11 @@ static struct rds_header *rds_ib_get_hea
 	        return hdr_buff;
 
 	if (data_len <= (RDS_FRAG_SIZE - sizeof(struct rds_header))) {
-		addr = kmap_atomic(recv->r_frag->f_page, KM_SOFTIRQ0);
+		addr = kmap_atomic_push(recv->r_frag->f_page);
 		memcpy(hdr_buff,
 		       addr + recv->r_frag->f_offset + data_len,
 		       sizeof(struct rds_header));
-		kunmap_atomic(addr, KM_SOFTIRQ0);
+		kmap_atomic_pop(addr);
 		return hdr_buff;
 	}
 
@@ -589,10 +589,10 @@ static struct rds_header *rds_ib_get_hea
 
 	memmove(hdr_buff + misplaced_hdr_bytes, hdr_buff, misplaced_hdr_bytes);
 
-	addr = kmap_atomic(recv->r_frag->f_page, KM_SOFTIRQ0);
+	addr = kmap_atomic_push(recv->r_frag->f_page);
 	memcpy(hdr_buff, addr + recv->r_frag->f_offset + data_len,
 	       sizeof(struct rds_header) - misplaced_hdr_bytes);
-	kunmap_atomic(addr, KM_SOFTIRQ0);
+	kmap_atomic_pop(addr);
 	return hdr_buff;
 }
 
@@ -637,7 +637,7 @@ static void rds_ib_cong_recv(struct rds_
 		to_copy = min(RDS_FRAG_SIZE - frag_off, PAGE_SIZE - map_off);
 		BUG_ON(to_copy & 7); /* Must be 64bit aligned. */
 
-		addr = kmap_atomic(frag->f_page, KM_SOFTIRQ0);
+		addr = kmap_atomic_push(frag->f_page);
 
 		src = addr + frag_off;
 		dst = (void *)map->m_page_addrs[map_page] + map_off;
@@ -647,7 +647,7 @@ static void rds_ib_cong_recv(struct rds_
 			uncongested |= ~(*src) & *dst;
 			*dst++ = *src++;
 		}
-		kunmap_atomic(addr, KM_SOFTIRQ0);
+		kmap_atomic_pop(addr);
 
 		copied += to_copy;
 
Index: linux-2.6/net/rds/info.c
===================================================================
--- linux-2.6.orig/net/rds/info.c
+++ linux-2.6/net/rds/info.c
@@ -102,7 +102,7 @@ EXPORT_SYMBOL_GPL(rds_info_deregister_fu
 void rds_info_iter_unmap(struct rds_info_iterator *iter)
 {
 	if (iter->addr != NULL) {
-		kunmap_atomic(iter->addr, KM_USER0);
+		kmap_atomic_pop(iter->addr);
 		iter->addr = NULL;
 	}
 }
@@ -117,7 +117,7 @@ void rds_info_copy(struct rds_info_itera
 
 	while (bytes) {
 		if (iter->addr == NULL)
-			iter->addr = kmap_atomic(*iter->pages, KM_USER0);
+			iter->addr = kmap_atomic_push(*iter->pages);
 
 		this = min(bytes, PAGE_SIZE - iter->offset);
 
@@ -132,7 +132,7 @@ void rds_info_copy(struct rds_info_itera
 		iter->offset += this;
 
 		if (iter->offset == PAGE_SIZE) {
-			kunmap_atomic(iter->addr, KM_USER0);
+			kmap_atomic_pop(iter->addr);
 			iter->addr = NULL;
 			iter->offset = 0;
 			iter->pages++;
Index: linux-2.6/net/rds/iw_recv.c
===================================================================
--- linux-2.6.orig/net/rds/iw_recv.c
+++ linux-2.6/net/rds/iw_recv.c
@@ -596,7 +596,7 @@ static void rds_iw_cong_recv(struct rds_
 		to_copy = min(RDS_FRAG_SIZE - frag_off, PAGE_SIZE - map_off);
 		BUG_ON(to_copy & 7); /* Must be 64bit aligned. */
 
-		addr = kmap_atomic(frag->f_page, KM_SOFTIRQ0);
+		addr = kmap_atomic_push(frag->f_page);
 
 		src = addr + frag_off;
 		dst = (void *)map->m_page_addrs[map_page] + map_off;
@@ -606,7 +606,7 @@ static void rds_iw_cong_recv(struct rds_
 			uncongested |= ~(*src) & *dst;
 			*dst++ = *src++;
 		}
-		kunmap_atomic(addr, KM_SOFTIRQ0);
+		kmap_atomic_pop(addr);
 
 		copied += to_copy;
 
Index: linux-2.6/net/rds/page.c
===================================================================
--- linux-2.6.orig/net/rds/page.c
+++ linux-2.6/net/rds/page.c
@@ -61,12 +61,12 @@ int rds_page_copy_user(struct page *page
 	else
 		rds_stats_add(s_copy_from_user, bytes);
 
-	addr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic_push(page);
 	if (to_user)
 		ret = __copy_to_user_inatomic(ptr, addr + offset, bytes);
 	else
 		ret = __copy_from_user_inatomic(addr + offset, ptr, bytes);
-	kunmap_atomic(addr, KM_USER0);
+	kmap_atomic_pop(addr);
 
 	if (ret) {
 		addr = kmap(page);
Index: linux-2.6/net/sunrpc/auth_gss/gss_krb5_wrap.c
===================================================================
--- linux-2.6.orig/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ linux-2.6/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -56,9 +56,9 @@ gss_krb5_remove_padding(struct xdr_buf *
 					>>PAGE_CACHE_SHIFT;
 		unsigned int offset = (buf->page_base + len - 1)
 					& (PAGE_CACHE_SIZE - 1);
-		ptr = kmap_atomic(buf->pages[last], KM_USER0);
+		ptr = kmap_atomic_push(buf->pages[last]);
 		pad = *(ptr + offset);
-		kunmap_atomic(ptr, KM_USER0);
+		kmap_atomic_pop(ptr);
 		goto out;
 	} else
 		len -= buf->page_len;
Index: linux-2.6/net/sunrpc/socklib.c
===================================================================
--- linux-2.6.orig/net/sunrpc/socklib.c
+++ linux-2.6/net/sunrpc/socklib.c
@@ -112,7 +112,7 @@ ssize_t xdr_partial_copy_from_skb(struct
 		}
 
 		len = PAGE_CACHE_SIZE;
-		kaddr = kmap_atomic(*ppage, KM_SKB_SUNRPC_DATA);
+		kaddr = kmap_atomic_push(*ppage);
 		if (base) {
 			len -= base;
 			if (pglen < len)
@@ -125,7 +125,7 @@ ssize_t xdr_partial_copy_from_skb(struct
 			ret = copy_actor(desc, kaddr, len);
 		}
 		flush_dcache_page(*ppage);
-		kunmap_atomic(kaddr, KM_SKB_SUNRPC_DATA);
+		kmap_atomic_pop(kaddr);
 		copied += ret;
 		if (ret != len || !desc->count)
 			goto out;
Index: linux-2.6/net/sunrpc/xdr.c
===================================================================
--- linux-2.6.orig/net/sunrpc/xdr.c
+++ linux-2.6/net/sunrpc/xdr.c
@@ -214,12 +214,12 @@ _shift_data_right_pages(struct page **pa
 		pgto_base -= copy;
 		pgfrom_base -= copy;
 
-		vto = kmap_atomic(*pgto, KM_USER0);
-		vfrom = kmap_atomic(*pgfrom, KM_USER1);
+		vto = kmap_atomic_push(*pgto);
+		vfrom = kmap_atomic_push(*pgfrom);
 		memmove(vto + pgto_base, vfrom + pgfrom_base, copy);
 		flush_dcache_page(*pgto);
-		kunmap_atomic(vfrom, KM_USER1);
-		kunmap_atomic(vto, KM_USER0);
+		kmap_atomic_pop(vfrom);
+		kmap_atomic_pop(vto);
 
 	} while ((len -= copy) != 0);
 }
@@ -249,9 +249,9 @@ _copy_to_pages(struct page **pages, size
 		if (copy > len)
 			copy = len;
 
-		vto = kmap_atomic(*pgto, KM_USER0);
+		vto = kmap_atomic_push(*pgto);
 		memcpy(vto + pgbase, p, copy);
-		kunmap_atomic(vto, KM_USER0);
+		kmap_atomic_pop(vto);
 
 		len -= copy;
 		if (len == 0)
@@ -293,9 +293,9 @@ _copy_from_pages(char *p, struct page **
 		if (copy > len)
 			copy = len;
 
-		vfrom = kmap_atomic(*pgfrom, KM_USER0);
+		vfrom = kmap_atomic_push(*pgfrom);
 		memcpy(p, vfrom + pgbase, copy);
-		kunmap_atomic(vfrom, KM_USER0);
+		kmap_atomic_pop(vfrom);
 
 		pgbase += copy;
 		if (pgbase == PAGE_CACHE_SIZE) {
Index: linux-2.6/net/sunrpc/xprtrdma/rpc_rdma.c
===================================================================
--- linux-2.6.orig/net/sunrpc/xprtrdma/rpc_rdma.c
+++ linux-2.6/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -334,13 +334,12 @@ rpcrdma_inline_pullup(struct rpc_rqst *r
 			curlen = copy_len;
 		dprintk("RPC:       %s: page %d destp 0x%p len %d curlen %d\n",
 			__func__, i, destp, copy_len, curlen);
-		srcp = kmap_atomic(rqst->rq_snd_buf.pages[i],
-					KM_SKB_SUNRPC_DATA);
+		srcp = kmap_atomic_push(rqst->rq_snd_buf.pages[i])
 		if (i == 0)
 			memcpy(destp, srcp+rqst->rq_snd_buf.page_base, curlen);
 		else
 			memcpy(destp, srcp, curlen);
-		kunmap_atomic(srcp, KM_SKB_SUNRPC_DATA);
+		kmap_atomic_pop(srcp);
 		rqst->rq_svec[0].iov_len += curlen;
 		destp += curlen;
 		copy_len -= curlen;
@@ -635,15 +634,14 @@ rpcrdma_inline_fixup(struct rpc_rqst *rq
 			dprintk("RPC:       %s: page %d"
 				" srcp 0x%p len %d curlen %d\n",
 				__func__, i, srcp, copy_len, curlen);
-			destp = kmap_atomic(rqst->rq_rcv_buf.pages[i],
-						KM_SKB_SUNRPC_DATA);
+			destp = kmap_atomic_push(rqst->rq_rcv_buf.pages[i]);
 			if (i == 0)
 				memcpy(destp + rqst->rq_rcv_buf.page_base,
 						srcp, curlen);
 			else
 				memcpy(destp, srcp, curlen);
 			flush_dcache_page(rqst->rq_rcv_buf.pages[i]);
-			kunmap_atomic(destp, KM_SKB_SUNRPC_DATA);
+			kmap_atomic_pop(destp);
 			srcp += curlen;
 			copy_len -= curlen;
 			if (copy_len == 0)


