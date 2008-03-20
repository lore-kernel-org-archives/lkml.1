Return-Path: <linux-kernel-owner+w=401wt.eu-S936075AbYCTAqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936075AbYCTAqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967901AbYCTAoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:44:37 -0400
Received: from ozlabs.org ([203.10.76.45]:52108 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965250AbYCTAoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:44:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18401.45889.408319.694612@cargo.ozlabs.ibm.com>
Date: Thu, 20 Mar 2008 11:43:45 +1100
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please do:

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get some more bug-fixes and a defconfig update for various powerpc
platforms.  The defconfig update only updates 9 of the defconfigs but
still dominates the diffstat, since the bug-fixes are all fairly
small.

Thanks,
Paul.

 arch/powerpc/boot/Makefile             |    4 -
 arch/powerpc/boot/wrapper              |    4 -
 arch/powerpc/configs/cell_defconfig    |  141 ++++++++++++++---------
 arch/powerpc/configs/celleb_defconfig  |  117 ++++++++++++-------
 arch/powerpc/configs/chrp32_defconfig  |  165 +++++++++++----------------
 arch/powerpc/configs/g5_defconfig      |  137 ++++++++++++++--------
 arch/powerpc/configs/iseries_defconfig |   99 +++++++++++-----
 arch/powerpc/configs/pmac32_defconfig  |  195 ++++++++++++++++++++------------
 arch/powerpc/configs/ppc64_defconfig   |  169 +++++++++++++++++-----------
 arch/powerpc/configs/ps3_defconfig     |  103 ++++++++++-------
 arch/powerpc/configs/pseries_defconfig |  136 +++++++++++++---------
 arch/powerpc/kernel/process.c          |    6 +
 arch/powerpc/kernel/ptrace.c           |   10 +-
 arch/powerpc/mm/slb.c                  |    6 +
 arch/powerpc/platforms/cell/iommu.c    |   41 ++++---
 arch/powerpc/platforms/cell/setup.c    |   36 ++++++
 16 files changed, 835 insertions(+), 534 deletions(-)

commit 93ce4e2d2d7404e80d5612fb1cc13d4aad5e42fc
Author: Paul Mackerras <paulus@samba.org>
Date:   Thu Mar 20 11:21:32 2008 +1100

    [POWERPC] Update some defconfigs
    
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit ebf3a6509299e46c531f88ee727372bd95cf542a
Author: Michael Ellerman <michael@ellerman.id.au>
Date:   Wed Mar 19 17:10:55 2008 +1100

    [POWERPC] Hide resources on Axon PCIE root complex nodes
    
    The PCI bridge representing the PCIE root complex on Axon, contains
    device BARs for a memory range and ROM that define inbound accesses.
    This confuses the kernel resource management code -- the resources
    need to be hidden when Axon is a host bridge.
    
    Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
    Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 3a4295d101d9654ca909b64c786f9da6ca1bf37a
Author: Michael Ellerman <michael@ellerman.id.au>
Date:   Fri Mar 14 16:47:39 2008 +1100

    [POWERPC] Fix cell IOMMU code to cope with empty dma-ranges and non-PCI devices
    
    The cell IOMMU code to parse the dma-ranges properties, used for the fixed
    mapping, was broken in two ways for some devices.
    
    Firstly it didn't cope with empty dma-ranges properties. An empty property
    implies no translation so can be safely skipped.
    
    The code also wrongly assumed it would be looking at PCI devices, and hard
    coded the number of address and size cells.
    
    Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit a72a6f53ddb95723960bb64c011457e9739941d7
Author: Paul Gortmaker <paul.gortmaker@windriver.com>
Date:   Tue Mar 18 16:13:10 2008 +1100

    [POWERPC] Fix build failure for tqm8540 and sbc85xx defconfigs
    
    The wrapper script didn't have entries for the TQM8540 board and the
    SBC8548 or SBC8560 boards.  I've assumed that the TQM8540 console is
    8250 based and not CPM based by looking at its defconfig.  There was
    also a trailing * on the TQM8555 entry that I removed too.
    
    Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 44387e9ff25267c78a99229aca55ed750e9174c7
Author: Anton Blanchard <anton@samba.org>
Date:   Mon Mar 17 15:27:09 2008 +1100

    [POWERPC] Fix PMU + soft interrupt disable bug
    
    Since the PMU is an NMI now, it can come at any time we are only soft
    disabled.  We must hard disable around the two places we allow the kernel
    stack SLB and r1 to go out of sync.  Otherwise the PMU exception can
    force a kernel stack SLB into another slot, which can lead to it
    getting evicted, which can lead to a nasty unrecoverable SLB miss
    in the exception entry code.
    
    Signed-off-by: Anton Blanchard <anton@samba.org>
    Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Acked-by: Olof Johansson <olof@lixom.net>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit c2372eb9bcafdd149b26987a8c25bbed92fd2775
Author: Roland McGrath <roland@redhat.com>
Date:   Thu Mar 13 19:25:35 2008 +1100

    [POWERPC] user_regset PTRACE_SETREGS regression fix
    
    The PTRACE_SETREGS request was only recently added on powerpc,
    and gdb does not use it.  So it slipped through without getting
    all the testing it should have had.
    
    The user_regset changes had a simple bug in storing to all of
    the 32-bit general registers block on 64-bit kernels.  This bug
    only comes up with PTRACE_SETREGS, not PPC_PTRACE_SETREGS.
    It causes a BUG_ON to hit, so this fix needs to go in ASAP.
    
    Signed-off-by: Roland McGrath <roland@redhat.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>
