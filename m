Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYIHL5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYIHL5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 07:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYIHL5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 07:57:07 -0400
Received: from ozlabs.org ([203.10.76.45]:56942 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYIHL5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 07:57:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Message-ID: <18629.4872.843131.680579@cargo.ozlabs.ibm.com>
Date: Mon, 8 Sep 2008 21:56:56 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

There is one commit there from Hugh Dickins that fixes a build
problem, plus three from the Cell guys fixing a couple of races and a
reference count leak in arch/powerpc/platforms/cell/spufs/sched.c.
The reference count leak is a regression from 2.6.26, and the races
can apparently lead to an unkillable process (looping in the kernel)
or to a panic.

Thanks,
Paul.

 arch/powerpc/boot/Makefile                |    2 +-
 arch/powerpc/platforms/cell/spufs/sched.c |   29 +++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 7 deletions(-)

commit 4ff23fa93011e2367fea056e72c92709178972d9
Author: Hugh Dickins <hugh@veritas.com>
Date:   Sun Sep 7 00:35:48 2008 +0100

    powerpc: Fix rare boot build breakage
    
    A make -j20 powerpc kernel build broke a couple of months ago saying:
    In file included from arch/powerpc/boot/gunzip_util.h:13,
                     from arch/powerpc/boot/prpmc2800.c:21:
    arch/powerpc/boot/zlib.h:85: error: expected ?:?, ?,?, ?;?, ?}? or ?__attribute__? before ?*? token
    arch/powerpc/boot/zlib.h:630: warning: type defaults to ?int? in declaration of ?Byte?
    arch/powerpc/boot/zlib.h:630: error: expected ?;?, ?,? or ?)? before ?*? token
    
    It happened again yesterday: too rare for me to confirm the fix, but
    it looks like the list of dependants on gunzip_util.h was incomplete.
    
    Signed-off-by: Hugh Dickins <hugh@veritas.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit b2e601d14deb2083e2a537b47869ab3895d23a28
Author: Andre Detsch <adetsch@br.ibm.com>
Date:   Thu Sep 4 21:16:27 2008 +0000

    powerpc/spufs: Fix possible scheduling of a context to multiple SPEs
    
    We currently have a race when scheduling a context to a SPE -
    after we have found a runnable context in spusched_tick, the same
    context may have been scheduled by spu_activate().
    
    This may result in a panic if we try to unschedule a context that has
    been freed in the meantime.
    
    This change exits spu_schedule() if the context has already been
    scheduled, so we don't end up scheduling it twice.
    
    Signed-off-by: Andre Detsch <adetsch@br.ibm.com>
    Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

commit b65fe0356b5b732d7e1e0224c6a1cf2eb5255984
Author: Jeremy Kerr <jk@ozlabs.org>
Date:   Thu Sep 4 15:02:47 2008 +1000

    powerpc/spufs: Fix race for a free SPU
    
    We currently have a race for a free SPE. With one thread doing a
    spu_yield(), and another doing a spu_activate():
    
    thread 1				thread 2
    spu_yield(oldctx)			spu_activate(ctx)
      __spu_deactivate(oldctx)
      spu_unschedule(oldctx, spu)
      spu->alloc_state = SPU_FREE
    					spu = spu_get_idle(ctx)
    					    - searches for a SPE in
    					      state SPU_FREE, gets
    					      the context just
    					      freed by thread 1
    					spu_schedule(ctx, spu)
    					  spu->alloc_state = SPU_USED
    spu_schedule(newctx, spu)
      - assumes spu is still free
      - tries to schedule context on
        already-used spu
    
    This change introduces a 'free_spu' flag to spu_unschedule, to indicate
    whether or not the function should free the spu after descheduling the
    context. We only set this flag if we're not going to re-schedule
    another context on this SPU.
    
    Add a comment to document this behaviour.
    
    Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

commit 9f43e3914dceb0f8191875b3cdf4325b48d0d70a
Author: Jeremy Kerr <jk@ozlabs.org>
Date:   Tue Sep 2 11:57:09 2008 +1000

    powerpc/spufs: Fix multiple get_spu_context()
    
    Commit 8d5636fbca202f61fdb808fc9e20c0142291d802 introduced a reference
    count on SPU contexts during find_victim, but this may cause a leak in
    the reference count if we later find a better contender for a context to
    unschedule.
    
    Change the reference to after we've found our victim context, so we
    don't do the extra get_spu_context().
    
    Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
