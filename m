Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYHZR70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYHZR70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbYHZR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:59:00 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:51062 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758571AbYHZR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:58:59 -0400
Date: Tue, 26 Aug 2008 21:58:55 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Walker <dwalker@mvista.com>, Timur Tabi <timur@freescale.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH -rt] powerpc/qeic: fix sleeping in atomic context
Message-ID: <20080826175855.GA9853@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cascade interrupts do not use threads, thus handlers are called
with interrupts disabled. This means that we must not grab regular
spinlocks, since they might sleep:

BUG: sleeping function called from invalid context swapper(0) at kernel/rtmutex.c:743
in_atomic():1 [00010002], irqs_disabled():1
Call Trace:
[c0353e00] [c0008a04] show_stack+0x4c/0x1ac (unreliable)
[c0353e40] [c001ca18] __might_sleep+0xc0/0x108
[c0353e50] [c0254218] __rt_spin_lock+0x30/0xa0
[c0353e60] [c0018238] qe_ic_mask_irq+0x58/0xc4
[c0353e80] [c0057bc8] handle_level_irq+0x40/0x178
[c0353ea0] [c001a5c0] qe_ic_cascade_low_ipic+0x50/0x68
[c0353eb0] [c00066d0] do_IRQ+0x9c/0xc0
[c0353ec0] [c001167c] ret_from_except+0x0/0x14
--- Exception: 501 at cpu_idle+0xa0/0x104
    LR = cpu_idle+0xa0/0x104
[c0353f80] [c0009b5c] cpu_idle+0x50/0x104 (unreliable)
[c0353fa0] [c0256088] _etext+0x88/0x9c
[c0353fc0] [c0304af8] start_kernel+0x1c4/0x244
[c0353ff0] [00003438] 0x3438

To fix the issue we should use raw spin lock.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

Note, the patch is for -rt tree only.

 arch/powerpc/sysdev/qe_lib/qe_ic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index f59444d..a30169c 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -33,7 +33,7 @@
 
 #include "qe_ic.h"
 
-static DEFINE_SPINLOCK(qe_ic_lock);
+static DEFINE_RAW_SPINLOCK(qe_ic_lock);
 
 static struct qe_ic_info qe_ic_info[] = {
 	[1] = {
-- 
1.5.6.3
