Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0CDEzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:55:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:57148 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab0CDEzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:55:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,579,1262592000"; 
   d="scan'208";a="601166566"
Subject: [GIT PULL] dmaengine/async_tx update for 2.6.34
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 21:53:51 -0700
Message-ID: <1267678431.19777.27.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from: 

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive:

1/ Some reworks of the fsldma and coh dma drivers.  The fsldma fixes
have been tested to enable async_tx operation chaining.
2/ A dma driver for the new mpc512x platform (base support for this
platform already merged through the powerpc tree).
3/ Interrupt coalescing and cleanups for the ioat driver
4/ Fixes for dmatest's RAID functionality
5/ Other random cleanups and fixes

All but the coh and ioat changes have spent time in -next.  The coh
rework was recently broken up into a series of 5 patches.  The ioat
changes have seen testing on an internal validation tree, but were
cherry-picked to this branch for release.

Thanks,
Dan

Anatolij Gustschin (1):
      dmatest: correct raid6 PQ test

Dan Williams (8):
      dmatest: fix handling of an even number of xor_sources
      ioat3: cleanup, don't enable DCA completion writes
      ioat3: use ioat2_quiesce()
      ioat2: kill pending flag
      ioat: close potential BUG_ON race in the descriptor cleanup path
      ioat3: interrupt coalescing
      ioat: cleanup ->timer_fn() and ->cleanup_fn() prototypes
      Merge branch 'coh' into dmaengine

Ira Snyder (8):
      fsldma: reduce kernel text size
      fsldma: remove unused structure members
      fsldma: rename struct fsl_dma_chan to struct fsldma_chan
      fsldma: rename dest to dst for uniformity
      fsldma: clean up the OF subsystem routines
      fsldma: simplify IRQ probing and handling
      fsldma: rename fsl_chan to chan
      fsldma: major cleanups and fixes

Linus Walleij (6):
      Debugging options for the DMA engine subsystem
      DMAENGINE: COH 901 318 cleanups
      DMAENGINE: COH 901 318 descriptor pool refactoring
      DMAENGINE: COH 901 318 remove irq counting
      DMAENGINE: COH 901 318 configure channel direction
      DMAENGINE: COH 901 318 lli sg offset fix

Márton Németh (1):
      dma: make Open Firmware device id constant

Piotr Ziecik (1):
      dma: Add MPC512x DMA driver

Roel Kluin (2):
      dma: cases IPU_PIX_FMT_BGRA32, BGR32 and ABGR32 are the same in ipu_ch_param_set_size()
      iop-adma: redundant/wrong tests in iop_*_count()?

Steven J. Magnani (2):
      fsldma: Fix cookie issues
      fsldma: Fix cookie issues

 Documentation/powerpc/dts-bindings/fsl/dma.txt |    8 +
 arch/arm/include/asm/hardware/iop3xx-adma.h    |   12 +-
 arch/arm/mach-u300/include/mach/coh901318.h    |    2 +-
 drivers/dma/Kconfig                            |   23 +
 drivers/dma/Makefile                           |    8 +
 drivers/dma/coh901318.c                        |  182 ++--
 drivers/dma/coh901318_lli.c                    |   23 +-
 drivers/dma/dmatest.c                          |    8 +-
 drivers/dma/fsldma.c                           | 1177 +++++++++++++-----------
 drivers/dma/fsldma.h                           |   35 +-
 drivers/dma/ioat/dma.c                         |   46 +-
 drivers/dma/ioat/dma.h                         |   11 +-
 drivers/dma/ioat/dma_v2.c                      |   70 +-
 drivers/dma/ioat/dma_v2.h                      |    6 +-
 drivers/dma/ioat/dma_v3.c                      |   64 +-
 drivers/dma/ioat/registers.h                   |    2 +-
 drivers/dma/ipu/ipu_idmac.c                    |   15 +-
 drivers/dma/mpc512x_dma.c                      |  800 ++++++++++++++++
 drivers/dma/ppc4xx/adma.c                      |    2 +-
 include/linux/dmaengine.h                      |    2 +
 20 files changed, 1717 insertions(+), 779 deletions(-)
 create mode 100644 drivers/dma/mpc512x_dma.c

commit 272ca655090978bdaa2630fc44fb2c03da5576fd
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Wed Jan 6 13:33:59 2010 +0000

    fsldma: reduce kernel text size
    
    Some of the functions are written in a way where they use multiple reads
    and writes where a single read/write pair could suffice. This shrinks the
    kernel text size measurably, while making the functions easier to
    understand.
    
    add/remove: 0/0 grow/shrink: 1/4 up/down: 4/-196 (-192)
    function                                     old     new   delta
    fsl_chan_set_request_count                   120     124      +4
    dma_halt                                     300     272     -28
    fsl_chan_set_src_loop_size                   208     156     -52
    fsl_chan_set_dest_loop_size                  208     156     -52
    fsl_chan_xfer_ld_queue                       500     436     -64
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4ce0e953f6286777452bf07c83056342d6b9b257
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Wed Jan 6 13:34:00 2010 +0000

    fsldma: remove unused structure members
    
    Remove some unused members from the fsldma data structures. A few trivial
    uses of struct resource were converted to use the stack rather than keeping
    the memory allocated for the lifetime of the driver.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a4f56d4b103d4e5d1a59a9118db0185a6bd1a83b
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Wed Jan 6 13:34:01 2010 +0000

    fsldma: rename struct fsl_dma_chan to struct fsldma_chan
    
    This is the beginning of a cleanup which will change all instances of
    "fsl_dma" to "fsldma" to match the name of the driver itself.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 738f5f7e1ae876448cb7d9c82bea258b69386647
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Wed Jan 6 13:34:02 2010 +0000

    fsldma: rename dest to dst for uniformity
    
    Most functions in the standard library use "dst" as a parameter, rather
    than "dest". This renames all use of "dest" to "dst" to match the usual
    convention.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e7a29151de1bd52081f27f149b68074fac0323be
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Wed Jan 6 13:34:03 2010 +0000

    fsldma: clean up the OF subsystem routines
    
    This fixes some errors in the cleanup paths of the OF subsystem, including
    missing checks for ioremap failing. Also, some variables were renamed for
    brevity.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d3f620b2c4fecdc8e060b70e8d92d29fc01c6126
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Wed Jan 6 13:34:04 2010 +0000

    fsldma: simplify IRQ probing and handling
    
    The IRQ probing is needlessly complex. All off the 83xx device trees in
    arch/powerpc/boot/dts/ specify 5 interrupts per DMA controller: one for the
    controller, and one for each channel. These interrupts are all attached to
    the same IRQ line.
    
    This causes an interesting situation if two channels interrupt at the same
    time. The per-controller handler will handle the first channel, and the
    per-channel handler will handle the remaining channels.
    
    Instead of this mess, we fix the bug in the per-controller handler, and
    make it handle all channels that generated an interrupt. When a
    per-controller handler is specified in the device tree, we prefer to use
    the shared handler instead of the per-channel handler.
    
    The 85xx/86xx controllers do not have a per-controller interrupt, and
    instead use a per-channel interrupt. This behavior has not been changed.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a1c03319018061304be28d131073ac13a5cb86fb
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Wed Jan 6 13:34:05 2010 +0000

    fsldma: rename fsl_chan to chan
    
    The name fsl_chan seems too long, so it has been shortened to chan. There
    are only a few places where the higher level "struct dma_chan *chan" name
    conflicts. These have been changed to "struct dma_chan *dchan" instead.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9c3a50b7d7ec45da34e73cac66cde12dd6092dd8
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Wed Jan 6 13:34:06 2010 +0000

    fsldma: major cleanups and fixes
    
    Fix locking. Use two queues in the driver, one for pending transacions, and
    one for transactions which are actually running on the hardware. Call
    dma_run_dependencies() on descriptor cleanup so that the async_tx API works
    correctly.
    
    There are a number of places throughout the code where lists of descriptors
    are freed in a loop. Create functions to handle this, and use them instead
    of open-coding the loop each time.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4b1cf1facca31b7db2a61d8aa2ba40d5a93a0957
Author: Márton Németh <nm127@freemail.hu>
Date:   Tue Feb 2 23:41:06 2010 -0700

    dma: make Open Firmware device id constant
    
    The match_table field of the struct of_device_id is constant in <linux/of_platform.h>
    so it is worth to make the initialization data also constant.
    
    The semantic match that finds this kind of pattern is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @r@
    disable decl_init,const_decl_init;
    identifier I1, I2, x;
    @@
    	struct I1 {
    	  ...
    	  const struct I2 *x;
    	  ...
    	};
    @s@
    identifier r.I1, y;
    identifier r.x, E;
    @@
    	struct I1 y = {
    	  .x = E,
    	};
    @c@
    identifier r.I2;
    identifier s.E;
    @@
    	const struct I2 E[] = ... ;
    @depends on !c@
    identifier r.I2;
    identifier s.E;
    @@
    +	const
    	struct I2 E[] = ...;
    // </smpl>
    
    Signed-off-by: Márton Németh <nm127@freemail.hu>
    Cc: Julia Lawall <julia@diku.dk>
    Cc: cocci@diku.dk
    [dan.j.williams@intel.com: resolved conflict with recent fsldma updates]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9ad7bd2944bd979ef4877cd439719be44c5f3b47
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Wed Jan 20 01:25:56 2010 +0100

    dma: cases IPU_PIX_FMT_BGRA32, BGR32 and ABGR32 are the same in ipu_ch_param_set_size()
    
    In these cases the same statements are executed.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6ca3a7a96e91b1aa8c704153c992b191d35b5747
Author: Steven J. Magnani <steve@digidescorp.com>
Date:   Thu Feb 25 13:39:30 2010 -0600

    fsldma: Fix cookie issues
    
    fsl_dma_tx_submit() only sets the cookie on the first descriptor of a
    transaction. It should set the cookie on all.
    
    Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
    Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 76bd061f5c7b7550cdaed68ad6219ea7cee288fc
Author: Steven J. Magnani <steve@digidescorp.com>
Date:   Sun Feb 28 22:18:16 2010 -0700

    fsldma: Fix cookie issues
    
    fsl_dma_update_completed_cookie() appears to calculate the last completed
    cookie incorrectly in the corner case where DMA on cookie 1 is in progress
    just following a cookie wrap.
    
    Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
    Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
    [dan.j.williams@intel.com: fix an integer overflow warning with INT_MAX]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 94de648d72c8bc833590523f22386d4babbea988
Author: Anatolij Gustschin <agust@denx.de>
Date:   Mon Feb 15 22:35:23 2010 +0100

    dmatest: correct raid6 PQ test
    
    The number of PQ sources specified by module parameter "pq_sources"
    is always forced odd to fit into dmatest's destination verificaton
    scheme. But number of PQ sources and coefficients as passed to the
    driver's prep_dma_pq() is not adjusted accordingly.
    
    Fix it now to get correct PQ testing results in the case passed
    "pq_sources" parameter is even.
    
    Signed-off-by: Anatolij Gustschin <agust@denx.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 67b9124f734b22b30d9adf18c39fe795e2901070
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Feb 28 22:20:18 2010 -0700

    dmatest: fix handling of an even number of xor_sources
    
    Just like commit ac5d73fc, we need to be careful to use 'src_cnt' as it
    contains the fixed up number of xor sources (forced odd) to meet dmatest's
    data verification scheme.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f1acb878b6070941e844dfc4ca1b3b9e5a70426c
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Sat Feb 13 15:54:03 2010 +0100

    iop-adma: redundant/wrong tests in iop_*_count()?
    
    When we reach the loop, len is at least 1, we only stay in the loop when
    len is at least MAX_BYTE_COUNT + 1, MAX_BYTE_COUNT is subtracted in each
    iteration. So when we leave the loop, or didn't take it, len is at least 1.
    Testing whether len is non-zero appears redundant.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6c664a8915f5341c2e7f1df0bb4b9b4a88f6ad77
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Tue Feb 9 22:34:54 2010 +0100

    Debugging options for the DMA engine subsystem
    
    This adds Kconfig options for DEBUG and VERBOSE_DEBUG to the DMA
    engine subsystem, I got tired of editing the Makefile manually
    each time I want to debug things in here, modelled this on the
    debug switches for other subsystems and works like a charm when
    working on our DMA engines.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0fb6f739bb612bc989d295056877374b749e721b
Author: Piotr Ziecik <kosmo@semihalf.com>
Date:   Fri Feb 5 03:42:52 2010 +0000

    dma: Add MPC512x DMA driver
    
    Adds initial version of MPC512x DMA driver.
    Only memory to memory transfers are currenly supported.
    
    Signed-off-by: Piotr Ziecik <kosmo@semihalf.com>
    Signed-off-by: Wolfgang Denk <wd@denx.de>
    Signed-off-by: Anatolij Gustschin <agust@denx.de>
    Cc: John Rigby <jcrigby@gmail.com>
    Acked-by: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 848ad121240f539e14a59eddd69e164aea9560b2
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Tue Mar 2 14:17:15 2010 -0700

    DMAENGINE: COH 901 318 cleanups
    
    This cleans up the some debug code that was not working in the
    COH 901 318 driver, adds some helpful comments and rearrange the
    code a bit.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b87108a772e001af3fa79f9cfd87b190375f47a2
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Tue Mar 2 14:17:20 2010 -0700

    DMAENGINE: COH 901 318 descriptor pool refactoring
    
    This centralize some spread-out initialization of descriptors into
    one function and cleans up the error paths.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0b58828c923e57f1bfbbd2c4277ceb60666314fa
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Tue Mar 2 14:17:44 2010 -0700

    DMAENGINE: COH 901 318 remove irq counting
    
    This removes the pointless irq counting for the COH 901 318, as
    it turns out the hardware will only ever fire one IRQ for a linked
    list anyway. In the process also a missing spinlock was introduced.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 516fd4305e5f5718475e81fe5c17c95888a8157b
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Tue Mar 2 20:12:46 2010 +0100

    DMAENGINE: COH 901 318 configure channel direction
    
    This makes the COH 901 318 configure channel direction (to or from
    device) dynamically, instead of being passed in from the platform
    data. This was necessary in order to get the MMC/SD-card channel
    bidirectional (all other channels on the U300 were either RX or
    TX but this one was both). This also sets memcpy() alignent to
    even 2^2 (32bit) boundaries, which makes the memcpy() stress tests
    start working.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 56a5d3cf21c71963c8fc506e9b9d3f71641d9c71
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Tue Mar 2 20:12:56 2010 +0100

    DMAENGINE: COH 901 318 lli sg offset fix
    
    This makes the COH 901 318 respect the scatter offset field by using
    the sg_phys() rather than the sg_dma_address() so we get a pointer
    to the actual data we want to send rather than the beginning of the
    buffer. Also initialize the lli:s a bit more thoroughly.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 773d9e2d8dbf02cfaf65786cf9100eef02c9fda4
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 3 11:47:42 2010 -0700

    ioat3: cleanup, don't enable DCA completion writes
    
    We already disallow raid operations while DCA is globally enabled, so
    having it locally enabled is a nop and confusing when reading the code.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b372ec2d900a5b50e47ef9e9624536ad146236be
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 3 11:47:42 2010 -0700

    ioat3: use ioat2_quiesce()
    
    Replace open coded ioat2_quiesce() call in ioat3_restart_channel
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 281befa5592b0c5f9a3856b5666c62ac66d3d9ee
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 3 11:47:43 2010 -0700

    ioat2: kill pending flag
    
    The pending == 2 case no longer exists in the driver so, we can use
    ioat2_ring_pending() outside the lock to determine if there might be any
    descriptors in the ring that the hardware has not seen.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit aa75db0080603bae27961c0502812dfd0f522bb3
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 3 21:21:10 2010 -0700

    ioat: close potential BUG_ON race in the descriptor cleanup path
    
    Since ioat_cleanup_preamble() and the update of the last completed
    descriptor are not synchronized there is a chance that two cleanup threads
    can see descriptors to clean.  If the first cleans up all pending
    descriptors then the second will trigger the BUG_ON.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b9cc98697d1ca35a86bbb708acc6d93993c28f0f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 3 21:21:13 2010 -0700

    ioat3: interrupt coalescing
    
    The hardware automatically disables further interrupts after each event
    until rearmed.  This allows a delay to be injected between the occurence
    of the interrupt and the running of the cleanup routine.  The delay is
    scaled by the descriptor backlog and then written to the INTRDELAY
    register which specifies the number of microseconds to hold off
    interrupt delivery after an interrupt event occurs.  According to
    powertop this reduces the interrupt rate from ~5000 intr/s to ~150
    intr/s per without affecting throughput (simple dd to a raid6 array).
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit aa4d72ae946a4fa40486b871717778734184fa29
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 3 21:21:13 2010 -0700

    ioat: cleanup ->timer_fn() and ->cleanup_fn() prototypes
    
    If the calling convention of ->timer_fn() and ->cleanup_fn() are unified
    across hardware versions we can drop parameters to ioat_init_channel() and
    unify ioat_is_dma_complete() implementations.
    
    Both ->timer_fn() and ->cleanup_fn() are modified to expect a struct
    dma_chan pointer.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit dd58ffcf5a5352fc10820c8ffbcd5fed416a2c3a
Merge: aa4d72a 56a5d3c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 3 21:22:21 2010 -0700

    Merge branch 'coh' into dmaengine


