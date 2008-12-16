Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYLPEng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYLPEng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 23:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYLPEn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 23:43:28 -0500
Received: from ozlabs.org ([203.10.76.45]:39972 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYLPEn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 23:43:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18759.12762.378824.798150@cargo.ozlabs.ibm.com>
Date: Tue, 16 Dec 2008 15:43:06 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get three more commits that fix bugs causing kernel crashes on
powerpc.

Thanks,
Paul.

 arch/powerpc/mm/hugetlbpage.c          |    3 +++
 arch/powerpc/mm/numa.c                 |   16 +++++++++++-----
 arch/powerpc/platforms/cell/axon_msi.c |    3 +++
 3 files changed, 17 insertions(+), 5 deletions(-)

commit 23e0e8afafd9ac065d81506524adf3339584044b
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Dec 12 09:19:50 2008 +0000

    powerpc/cell/axon-msi: Fix MSI after kexec
    
    Commit d015fe995 'powerpc/cell/axon-msi: Retry on missing interrupt'
    has turned a rare failure to kexec on QS22 into a reproducible
    error, which we have now analysed.
    
    The problem is that after a kexec, the MSIC hardware still points
    into the middle of the old ring buffer.  We set up the ring buffer
    during reboot, but not the offset into it.  On older kernels, this
    would cause a storm of thousands of spurious interrupts after a
    kexec, which would most of the time get dropped silently.
    
    With the new code, we time out on each interrupt, waiting for
    it to become valid.  If more interrupts come in that we time
    out on, this goes on indefinitely, which eventually leads to
    a hard crash.
    
    The solution in this commit is to read the current offset from
    the MSIC when reinitializing it.  This now works correctly, as
    expected.
    
    Reported-by: Dirk Herrendoerfer <d.herrendoerfer@de.ibm.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Michael Ellerman <michael@ellerman.id.au>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit a4c74ddd5ea3db53fc73d29c222b22656a7d05be
Author: Dave Hansen <dave@linux.vnet.ibm.com>
Date:   Thu Dec 11 08:36:06 2008 +0000

    powerpc: Fix bootmem reservation on uninitialized node
    
    careful_allocation() was calling into the bootmem allocator for
    nodes which had not been fully initialized and caused a previous
    bug:  http://patchwork.ozlabs.org/patch/10528/  So, I merged a
    few broken out loops in do_init_bootmem() to fix it.  That changed
    the code ordering.
    
    I think this bug is triggered by having reserved areas for a node
    which are spanned by another node's contents.  In the
    mark_reserved_regions_for_nid() code, we attempt to reserve the
    area for a node before we have allocated the NODE_DATA() for that
    nid.  We do this since I reordered that loop.  I suck.
    
    This is causing crashes at bootup on some systems, as reported
    by Jon Tollefson.
    
    This may only present on some systems that have 16GB pages
    reserved.  But, it can probably happen on any system that is
    trying to reserve large swaths of memory that happen to span other
    nodes' contents.
    
    This commit ensures that we do not touch bootmem for any node which
    has not been initialized, and also removes a compile warning about
    an unused variable.
    
    Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 48f797de550d39ea35552646c34149991362ff7f
Author: Brian King <brking@linux.vnet.ibm.com>
Date:   Thu Dec 4 04:07:54 2008 +0000

    powerpc: Check for valid hugepage size in hugetlb_get_unmapped_area
    
    It looks like most of the hugetlb code is doing the correct thing if
    hugepages are not supported, but the mmap code is not.  If we get into
    the mmap code when hugepages are not supported, such as in an LPAR
    which is running Active Memory Sharing, we can oops the kernel.  This
    fixes the oops being seen in this path.
    
    oops: Kernel access of bad area, sig: 11 [#1]
    SMP NR_CPUS=1024 NUMA pSeries
    Modules linked in: nfs(N) lockd(N) nfs_acl(N) sunrpc(N) ipv6(N) fuse(N) loop(N)
    dm_mod(N) sg(N) ibmveth(N) sd_mod(N) crc_t10dif(N) ibmvscsic(N)
    scsi_transport_srp(N) scsi_tgt(N) scsi_mod(N)
    Supported: No
    NIP: c000000000038d60 LR: c00000000003945c CTR: c0000000000393f0
    REGS: c000000077e7b830 TRAP: 0300   Tainted: G
    (2.6.27.5-bz50170-2-ppc64)
    MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 44000448  XER: 20000001
    DAR: c000002000af90a8, DSISR: 0000000040000000
    TASK = c00000007c1b8600[4019] 'hugemmap01' THREAD: c000000077e78000 CPU: 6
    GPR00: 0000001fffffffe0 c000000077e7bab0 c0000000009a4e78 0000000000000000
    GPR04: 0000000000010000 0000000000000001 00000000ffffffff 0000000000000001
    GPR08: 0000000000000000 c000000000af90c8 0000000000000001 0000000000000000
    GPR12: 000000000000003f c000000000a73880 0000000000000000 0000000000000000
    GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000010000
    GPR20: 0000000000000000 0000000000000003 0000000000010000 0000000000000001
    GPR24: 0000000000000003 0000000000000000 0000000000000001 ffffffffffffffb5
    GPR28: c000000077ca2e80 0000000000000000 c00000000092af78 0000000000010000
    NIP [c000000000038d60] .slice_get_unmapped_area+0x6c/0x4e0
    LR [c00000000003945c] .hugetlb_get_unmapped_area+0x6c/0x80
    Call Trace:
    [c000000077e7bbc0] [c00000000003945c] .hugetlb_get_unmapped_area+0x6c/0x80
    [c000000077e7bc30] [c000000000107e30] .get_unmapped_area+0x64/0xd8
    [c000000077e7bcb0] [c00000000010b140] .do_mmap_pgoff+0x140/0x420
    [c000000077e7bd80] [c00000000000bf5c] .sys_mmap+0xc4/0x140
    [c000000077e7be30] [c0000000000086b4] syscall_exit+0x0/0x40
    Instruction dump:
    fac1ffb0 fae1ffb8 fb01ffc0 fb21ffc8 fb41ffd0 fb61ffd8 fb81ffe0 fbc1fff0
    fbe1fff8 f821fef1 f8c10158 f8e10160 <7d49002e> f9010168 e92d01b0 eb4902b0
    
    Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>
