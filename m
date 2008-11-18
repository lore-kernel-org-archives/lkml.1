Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbYKRJEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbYKRJEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYKRJDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:03:55 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:50304 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYKRJDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:03:46 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62693723"
From: Bryan Wu <cooloney@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Graf Yang <graf.yang@analog.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/5] Blackfin arch: SMP supporting patchset: BF561 related code
Date: Tue, 18 Nov 2008 17:05:04 +0800
Message-Id: <1226999108-13839-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Blackfin dual core BF561 processor can support SMP like features.
https://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like

In this patch, we provide SMP extend to BF561 kernel code

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mach-bf561/Kconfig                 |    6 +-
 arch/blackfin/mach-bf561/Makefile                |    1 +
 arch/blackfin/mach-bf561/atomic.S                |  954 ++++++++++++++++++++++
 arch/blackfin/mach-bf561/include/mach/blackfin.h |    4 +
 arch/blackfin/mach-bf561/include/mach/defBF561.h |    3 +
 arch/blackfin/mach-bf561/include/mach/mem_map.h  |  120 +++
 arch/blackfin/mach-bf561/include/mach/smp.h      |   22 +
 arch/blackfin/mach-bf561/secondary.S             |  215 +++++
 arch/blackfin/mach-bf561/smp.c                   |  182 ++++
 9 files changed, 1504 insertions(+), 3 deletions(-)
 create mode 100644 arch/blackfin/mach-bf561/atomic.S
 create mode 100644 arch/blackfin/mach-bf561/include/mach/smp.h
 create mode 100644 arch/blackfin/mach-bf561/secondary.S
 create mode 100644 arch/blackfin/mach-bf561/smp.c

diff --git a/arch/blackfin/mach-bf561/Kconfig b/arch/blackfin/mach-bf561/Kconfig
index 3f48954..5d56438 100644
--- a/arch/blackfin/mach-bf561/Kconfig
+++ b/arch/blackfin/mach-bf561/Kconfig
@@ -4,9 +4,9 @@ source "arch/blackfin/mach-bf561/boards/Kconfig"
 
 menu "BF561 Specific Configuration"
 
-comment "Core B Support"
+if (!SMP)
 
-menu "Core B Support"
+comment "Core B Support"
 
 config BF561_COREB
 	bool "Enable Core B support"
@@ -25,7 +25,7 @@ config BF561_COREB_RESET
 	  0 is set, and will reset PC to 0xff600000 when
 	  COREB_SRAM_INIT is cleared.
 
-endmenu
+endif
 
 comment "Interrupt Priority Assignment"
 
diff --git a/arch/blackfin/mach-bf561/Makefile b/arch/blackfin/mach-bf561/Makefile
index f39235a..c37f00c 100644
--- a/arch/blackfin/mach-bf561/Makefile
+++ b/arch/blackfin/mach-bf561/Makefile
@@ -7,3 +7,4 @@ extra-y := head.o
 obj-y := ints-priority.o dma.o
 
 obj-$(CONFIG_BF561_COREB) += coreb.o
+obj-$(CONFIG_SMP)  += smp.o secondary.o atomic.o
diff --git a/arch/blackfin/mach-bf561/atomic.S b/arch/blackfin/mach-bf561/atomic.S
new file mode 100644
index 0000000..d5c4fd8
--- /dev/null
+++ b/arch/blackfin/mach-bf561/atomic.S
@@ -0,0 +1,954 @@
+/*
+ * File:         arch/blackfin/mach-bf561/atomic.S
+ * Author:       Philippe Gerum <rpm@xenomai.org>
+ *
+ *               Copyright 2007 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/linkage.h>
+#include <asm/blackfin.h>
+#include <asm/cache.h>
+#include <asm/asm-offsets.h>
+#include <asm/rwlock.h>
+#include <asm/cplb.h>
+
+.text
+
+.macro coreslot_loadaddr
+	p0.l = _corelock;
+	p0.h = _corelock;
+.endm
+
+.macro do_ssync
+#if defined(ANOMALY_05000312) || defined(ANOMALY_05000244)
+	cli r2;
+#ifdef ANOMALY_05000244
+	nop;
+	nop;
+#endif
+	ssync;
+	sti r2;
+#else
+	ssync;
+#endif
+.endm
+
+.macro do_csync
+#if defined(ANOMALY_05000312) || defined(ANOMALY_05000244)
+	cli r2;
+#ifdef ANOMALY_05000244
+	nop;
+	nop;
+#endif
+	csync;
+	sti r2;
+#else
+	csync;
+#endif
+.endm
+
+.macro idlelize
+	do_ssync;
+.endm
+
+.align 2
+
+/*
+ * r0 = address of atomic data to flush and invalidate (32bit).
+ *
+ * Clear interrupts and return the old mask.
+ * We assume that no atomic data can span cachelines.
+ *
+ * Clobbers: r2:0, p0
+ */
+_get_core_lock:
+
+	r1 = -L1_CACHE_BYTES;
+	r1 = r0 & r1;
+	cli r0;
+	coreslot_loadaddr;
+.Lretry_corelock:
+	testset (p0);
+	if cc jump .Ldone_corelock;
+	idlelize;
+	jump .Lretry_corelock
+.Ldone_corelock:
+	p0 = r1;
+	do_csync;
+	flushinv[p0];
+	do_ssync;
+	rts;
+
+/*
+ * r0 = address of atomic data in uncacheable memory region (32bit).
+ *
+ * Clear interrupts and return the old mask.
+ *
+ * Clobbers: r0, p0
+ */
+_get_core_lock_noflush:
+
+	cli r0;
+	coreslot_loadaddr;
+.Lretry_corelock_noflush:
+	testset (p0);
+	if cc jump .Ldone_corelock_noflush;
+	idlelize;
+	jump .Lretry_corelock_noflush
+.Ldone_corelock_noflush:
+	rts;
+
+/*
+ * r0 = interrupt mask to restore.
+ * r1 = address of atomic data to flush and invalidate (32bit).
+ *
+ * Interrupts are masked on entry (see _get_core_lock).
+ * Clobbers: r2:0, p0
+ */
+_put_core_lock:
+
+	/* Write-through cache assumed, so no flush needed here. */
+	coreslot_loadaddr;
+	r1 = 0;
+	[p0] = r1;
+	do_ssync;
+	sti r0;
+	rts;
+
+#ifdef __ARCH_SYNC_CORE_DCACHE
+
+ENTRY(___raw_smp_mark_barrier_asm)
+
+	[--sp] = rets;
+	[--sp] = ( r7:5 );
+	[--sp] = r0;
+	[--sp] = p1;
+	[--sp] = p0;
+	call _get_core_lock_noflush;
+
+	/*
+	 * Calculate current core mask
+	 */
+	GET_CPUID(p1, r7);
+	r6 = 1;
+	r6 <<= r7;
+
+	/*
+	 * Set bit of other cores in barrier mask. Don't change current core bit.
+	 */
+	p1.l = _barrier_mask;
+	p1.h = _barrier_mask;
+	r7 = [p1];
+	r5 = r7 & r6;
+	r7 = ~r6;
+	cc = r5 == 0;
+	if cc jump 1f;
+	r7 = r7 | r6;
+1:
+	[p1] = r7;
+	do_ssync;
+
+	call _put_core_lock;
+	p0 = [sp++];
+	p1 = [sp++];
+	r0 = [sp++];
+	( r7:5 ) = [sp++];
+	rets = [sp++];
+	rts;
+
+ENTRY(___raw_smp_check_barrier_asm)
+
+	[--sp] = rets;
+	[--sp] = ( r7:5 );
+	[--sp] = r0;
+	[--sp] = p1;
+	[--sp] = p0;
+	call _get_core_lock_noflush;
+
+	/*
+	 * Calculate current core mask
+	 */
+	GET_CPUID(p1, r7);
+	r6 = 1;
+	r6 <<= r7;
+
+	/*
+	 * Clear current core bit in barrier mask if it is set.
+	 */
+	p1.l = _barrier_mask;
+	p1.h = _barrier_mask;
+	r7 = [p1];
+	r5 = r7 & r6;
+	cc = r5 == 0;
+	if cc jump 1f;
+	r6 = ~r6;
+	r7 = r7 & r6;
+	[p1] = r7;
+	do_ssync;
+
+	call _put_core_lock;
+
+	/*
+	 * Invalidate the entire D-cache of current core.
+	 */
+	sp += -12;
+	call _resync_core_dcache
+	sp += 12;
+	jump 2f;
+1:
+	call _put_core_lock;
+2:
+	p0 = [sp++];
+	p1 = [sp++];
+	r0 = [sp++];
+	( r7:5 ) = [sp++];
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = irqflags
+ * r1 = address of atomic data
+ *
+ * Clobbers: r2:0, p1:0
+ */
+_start_lock_coherent:
+
+	[--sp] = rets;
+	[--sp] = ( r7:6 );
+	r7 = r0;
+	p1 = r1;
+
+	/*
+	 * Determine whether the atomic data was previously
+	 * owned by another CPU (=r6).
+	 */
+	GET_CPUID(p0, r2);
+	r1 = 1;
+	r1 <<= r2;
+	r2 = ~r1;
+
+	r1 = [p1];
+	r1 >>= 28;   /* CPU fingerprints are stored in the high nibble. */
+	r6 = r1 & r2;
+	r1 = [p1];
+	r1 <<= 4;
+	r1 >>= 4;
+	[p1] = r1;
+
+	/*
+	 * Release the core lock now, but keep IRQs disabled while we are
+	 * performing the remaining housekeeping chores for the current CPU.
+	 */
+	coreslot_loadaddr;
+	r1 = 0;
+	[p0] = r1;
+
+	/*
+	 * If another CPU has owned the same atomic section before us,
+	 * then our D-cached copy of the shared data protected by the
+	 * current spin/write_lock may be obsolete.
+	 */
+	cc = r6 == 0;
+	if cc jump .Lcache_synced
+
+	/*
+	 * Invalidate the entire D-cache of the current core.
+	 */
+	sp += -12;
+	call _resync_core_dcache
+	sp += 12;
+
+.Lcache_synced:
+	do_ssync;
+	sti r7;
+	( r7:6 ) = [sp++];
+	rets = [sp++];
+	rts
+
+/*
+ * r0 = irqflags
+ * r1 = address of atomic data
+ *
+ * Clobbers: r2:0, p1:0
+ */
+_end_lock_coherent:
+
+	p1 = r1;
+	GET_CPUID(p0, r2);
+	r2 += 28;
+	r1 = 1;
+	r1 <<= r2;
+	r2 = [p1];
+	r2 = r1 | r2;
+	[p1] = r2;
+	r1 = p1;
+	jump _put_core_lock;
+
+#endif /* __ARCH_SYNC_CORE_DCACHE */
+
+/*
+ * r0 = &spinlock->lock
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_spin_is_locked_asm)
+
+	p1 = r0;
+	[--sp] = rets;
+	call _get_core_lock;
+	r3 = [p1];
+	cc = bittst( r3, 0 );
+	r3 = cc;
+	r1 = p1;
+	call _put_core_lock;
+	rets = [sp++];
+	r0 = r3;
+	rts;
+
+/*
+ * r0 = &spinlock->lock
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_spin_lock_asm)
+
+	p1 = r0;
+	[--sp] = rets;
+.Lretry_spinlock:
+	call _get_core_lock;
+	r1 = p1;
+	r2 = [p1];
+	cc = bittst( r2, 0 );
+	if cc jump .Lbusy_spinlock
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	r3 = p1;
+	bitset ( r2, 0 ); /* Raise the lock bit. */
+	[p1] = r2;
+	call _start_lock_coherent
+#else
+	r2 = 1;
+	[p1] = r2;
+	call _put_core_lock;
+#endif
+	rets = [sp++];
+	rts;
+
+.Lbusy_spinlock:
+	/* We don't touch the atomic area if busy, so that flush
+	   will behave like nop in _put_core_lock. */
+	call _put_core_lock;
+	idlelize;
+	r0 = p1;
+	jump .Lretry_spinlock
+
+/*
+ * r0 = &spinlock->lock
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_spin_trylock_asm)
+
+	p1 = r0;
+	[--sp] = rets;
+	call _get_core_lock;
+	r1 = p1;
+	r3 = [p1];
+	cc = bittst( r3, 0 );
+	if cc jump .Lfailed_trylock
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	bitset ( r3, 0 ); /* Raise the lock bit. */
+	[p1] = r3;
+	call _start_lock_coherent
+#else
+	r2 = 1;
+	[p1] = r2;
+	call _put_core_lock;
+#endif
+	r0 = 1;
+	rets = [sp++];
+	rts;
+.Lfailed_trylock:
+	call _put_core_lock;
+	r0 = 0;
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = &spinlock->lock
+ *
+ * Clobbers: r2:0, p1:0
+ */
+
+ENTRY(___raw_spin_unlock_asm)
+
+	p1 = r0;
+	[--sp] = rets;
+	call _get_core_lock;
+	r2 = [p1];
+	bitclr ( r2, 0 );
+	[p1] = r2;
+	r1 = p1;
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	call _end_lock_coherent
+#else
+	call _put_core_lock;
+#endif
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = &rwlock->lock
+ *
+ * Clobbers: r2:0, p1:0
+ */
+ENTRY(___raw_read_lock_asm)
+
+	p1 = r0;
+	[--sp] = rets;
+	call _get_core_lock;
+.Lrdlock_try:
+	r1 = [p1];
+	r1 += -1;
+	[p1] = r1;
+	cc = r1 < 0;
+	if cc jump .Lrdlock_failed
+	r1 = p1;
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	call _start_lock_coherent
+#else
+	call _put_core_lock;
+#endif
+	rets = [sp++];
+	rts;
+
+.Lrdlock_failed:
+	r1 += 1;
+	[p1] = r1;
+.Lrdlock_wait:
+	r1 = p1;
+	call _put_core_lock;
+	idlelize;
+	r0 = p1;
+	call _get_core_lock;
+	r1 = [p1];
+	cc = r1 < 2;
+	if cc jump .Lrdlock_wait;
+	jump .Lrdlock_try
+
+/*
+ * r0 = &rwlock->lock
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_read_trylock_asm)
+
+	p1 = r0;
+	[--sp] = rets;
+	call _get_core_lock;
+	r1 = [p1];
+	cc = r1 <= 0;
+	if cc jump .Lfailed_tryrdlock;
+	r1 += -1;
+	[p1] = r1;
+	r1 = p1;
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	call _start_lock_coherent
+#else
+	call _put_core_lock;
+#endif
+	rets = [sp++];
+	r0 = 1;
+	rts;
+.Lfailed_tryrdlock:
+	r1 = p1;
+	call _put_core_lock;
+	rets = [sp++];
+	r0 = 0;
+	rts;
+
+/*
+ * r0 = &rwlock->lock
+ *
+ * Note: Processing controlled by a reader lock should not have
+ * any side-effect on cache issues with the other core, so we
+ * just release the core lock and exit (no _end_lock_coherent).
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_read_unlock_asm)
+
+	p1 = r0;
+	[--sp] = rets;
+	call _get_core_lock;
+	r1 = [p1];
+	r1 += 1;
+	[p1] = r1;
+	r1 = p1;
+	call _put_core_lock;
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = &rwlock->lock
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_write_lock_asm)
+
+	p1 = r0;
+	r3.l = lo(RW_LOCK_BIAS);
+	r3.h = hi(RW_LOCK_BIAS);
+	[--sp] = rets;
+	call _get_core_lock;
+.Lwrlock_try:
+	r1 = [p1];
+	r1 = r1 - r3;
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	r2 = r1;
+	r2 <<= 4;
+	r2 >>= 4;
+	cc = r2 == 0;
+#else
+	cc = r1 == 0;
+#endif
+	if !cc jump .Lwrlock_wait
+	[p1] = r1;
+	r1 = p1;
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	call _start_lock_coherent
+#else
+	call _put_core_lock;
+#endif
+	rets = [sp++];
+	rts;
+
+.Lwrlock_wait:
+	r1 = p1;
+	call _put_core_lock;
+	idlelize;
+	r0 = p1;
+	call _get_core_lock;
+	r1 = [p1];
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	r1 <<= 4;
+	r1 >>= 4;
+#endif
+	cc = r1 == r3;
+	if !cc jump .Lwrlock_wait;
+	jump .Lwrlock_try
+
+/*
+ * r0 = &rwlock->lock
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_write_trylock_asm)
+
+	p1 = r0;
+	[--sp] = rets;
+	call _get_core_lock;
+	r1 = [p1];
+	r2.l = lo(RW_LOCK_BIAS);
+	r2.h = hi(RW_LOCK_BIAS);
+	cc = r1 == r2;
+	if !cc jump .Lfailed_trywrlock;
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	r1 >>= 28;
+	r1 <<= 28;
+#else
+	r1 = 0;
+#endif
+	[p1] = r1;
+	r1 = p1;
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	call _start_lock_coherent
+#else
+	call _put_core_lock;
+#endif
+	rets = [sp++];
+	r0 = 1;
+	rts;
+
+.Lfailed_trywrlock:
+	r1 = p1;
+	call _put_core_lock;
+	rets = [sp++];
+	r0 = 0;
+	rts;
+
+/*
+ * r0 = &rwlock->lock
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_write_unlock_asm)
+
+	p1 = r0;
+	r3.l = lo(RW_LOCK_BIAS);
+	r3.h = hi(RW_LOCK_BIAS);
+	[--sp] = rets;
+	call _get_core_lock;
+	r1 = [p1];
+	r1 = r1 + r3;
+	[p1] = r1;
+	r1 = p1;
+#ifdef __ARCH_SYNC_CORE_DCACHE
+	call _end_lock_coherent
+#else
+	call _put_core_lock;
+#endif
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = ptr
+ * r1 = value
+ *
+ * Add a signed value to a 32bit word and return the new value atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_atomic_update_asm)
+
+	p1 = r0;
+	r3 = r1;
+	[--sp] = rets;
+	call _get_core_lock;
+	r2 = [p1];
+	r3 = r3 + r2;
+	[p1] = r3;
+	r1 = p1;
+	call _put_core_lock;
+	r0 = r3;
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = ptr
+ * r1 = mask
+ *
+ * Clear the mask bits from a 32bit word and return the old 32bit value
+ * atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_atomic_clear_asm)
+
+	p1 = r0;
+	r3 = ~r1;
+	[--sp] = rets;
+	call _get_core_lock;
+	r2 = [p1];
+	r3 = r2 & r3;
+	[p1] = r3;
+	r3 = r2;
+	r1 = p1;
+	call _put_core_lock;
+	r0 = r3;
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = ptr
+ * r1 = mask
+ *
+ * Set the mask bits into a 32bit word and return the old 32bit value
+ * atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_atomic_set_asm)
+
+	p1 = r0;
+	r3 = r1;
+	[--sp] = rets;
+	call _get_core_lock;
+	r2 = [p1];
+	r3 = r2 | r3;
+	[p1] = r3;
+	r3 = r2;
+	r1 = p1;
+	call _put_core_lock;
+	r0 = r3;
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = ptr
+ * r1 = mask
+ *
+ * XOR the mask bits with a 32bit word and return the old 32bit value
+ * atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_atomic_xor_asm)
+
+	p1 = r0;
+	r3 = r1;
+	[--sp] = rets;
+	call _get_core_lock;
+	r2 = [p1];
+	r3 = r2 ^ r3;
+	[p1] = r3;
+	r3 = r2;
+	r1 = p1;
+	call _put_core_lock;
+	r0 = r3;
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = ptr
+ * r1 = mask
+ *
+ * Perform a logical AND between the mask bits and a 32bit word, and
+ * return the masked value. We need this on this architecture in
+ * order to invalidate the local cache before testing.
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_atomic_test_asm)
+
+	p1 = r0;
+	r3 = r1;
+	r1 = -L1_CACHE_BYTES;
+	r1 = r0 & r1;
+	p0 = r1;
+	flushinv[p0];
+	do_ssync;
+	r0 = [p1];
+	r0 = r0 & r3;
+	rts;
+
+/*
+ * r0 = ptr
+ * r1 = value
+ *
+ * Swap *ptr with value and return the old 32bit value atomically.
+ * Clobbers: r3:0, p1:0
+ */
+#define	__do_xchg(src, dst) 		\
+	p1 = r0;			\
+	r3 = r1;			\
+	[--sp] = rets;			\
+	call _get_core_lock;		\
+	r2 = src;			\
+	dst = r3;			\
+	r3 = r2;			\
+	r1 = p1;			\
+	call _put_core_lock;		\
+	r0 = r3;			\
+	rets = [sp++];			\
+	rts;
+
+ENTRY(___raw_xchg_1_asm)
+
+	__do_xchg(b[p1] (z), b[p1])
+
+ENTRY(___raw_xchg_2_asm)
+
+	__do_xchg(w[p1] (z), w[p1])
+
+ENTRY(___raw_xchg_4_asm)
+
+	__do_xchg([p1], [p1])
+
+/*
+ * r0 = ptr
+ * r1 = new
+ * r2 = old
+ *
+ * Swap *ptr with new if *ptr == old and return the previous *ptr
+ * value atomically.
+ *
+ * Clobbers: r3:0, p1:0
+ */
+#define	__do_cmpxchg(src, dst) 		\
+	[--sp] = rets;			\
+	[--sp] = r4;			\
+	p1 = r0;			\
+	r3 = r1;			\
+	r4 = r2;			\
+	call _get_core_lock;		\
+	r2 = src;			\
+	cc = r2 == r4;			\
+	if !cc jump 1f;			\
+	dst = r3;			\
+     1: r3 = r2;			\
+	r1 = p1;			\
+	call _put_core_lock;		\
+	r0 = r3;			\
+	r4 = [sp++];			\
+	rets = [sp++];			\
+	rts;
+
+ENTRY(___raw_cmpxchg_1_asm)
+
+	__do_cmpxchg(b[p1] (z), b[p1])
+
+ENTRY(___raw_cmpxchg_2_asm)
+
+	__do_cmpxchg(w[p1] (z), w[p1])
+
+ENTRY(___raw_cmpxchg_4_asm)
+
+	__do_cmpxchg([p1], [p1])
+
+/*
+ * r0 = ptr
+ * r1 = bitnr
+ *
+ * Set a bit in a 32bit word and return the old 32bit value atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_bit_set_asm)
+
+	r2 = r1;
+	r1 = 1;
+	r1 <<= r2;
+	jump ___raw_atomic_set_asm
+
+/*
+ * r0 = ptr
+ * r1 = bitnr
+ *
+ * Clear a bit in a 32bit word and return the old 32bit value atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_bit_clear_asm)
+
+	r2 = r1;
+	r1 = 1;
+	r1 <<= r2;
+	jump ___raw_atomic_clear_asm
+
+/*
+ * r0 = ptr
+ * r1 = bitnr
+ *
+ * Toggle a bit in a 32bit word and return the old 32bit value atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_bit_toggle_asm)
+
+	r2 = r1;
+	r1 = 1;
+	r1 <<= r2;
+	jump ___raw_atomic_xor_asm
+
+/*
+ * r0 = ptr
+ * r1 = bitnr
+ *
+ * Test-and-set a bit in a 32bit word and return the old bit value atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_bit_test_set_asm)
+
+	[--sp] = rets;
+	[--sp] = r1;
+	call ___raw_bit_set_asm
+	r1 = [sp++];
+	r2 = 1;
+	r2 <<= r1;
+	r0 = r0 & r2;
+	cc = r0 == 0;
+	if cc jump 1f
+	r0 = 1;
+1:
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = ptr
+ * r1 = bitnr
+ *
+ * Test-and-clear a bit in a 32bit word and return the old bit value atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_bit_test_clear_asm)
+
+	[--sp] = rets;
+	[--sp] = r1;
+	call ___raw_bit_clear_asm
+	r1 = [sp++];
+	r2 = 1;
+	r2 <<= r1;
+	r0 = r0 & r2;
+	cc = r0 == 0;
+	if cc jump 1f
+	r0 = 1;
+1:
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = ptr
+ * r1 = bitnr
+ *
+ * Test-and-toggle a bit in a 32bit word,
+ * and return the old bit value atomically.
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_bit_test_toggle_asm)
+
+	[--sp] = rets;
+	[--sp] = r1;
+	call ___raw_bit_toggle_asm
+	r1 = [sp++];
+	r2 = 1;
+	r2 <<= r1;
+	r0 = r0 & r2;
+	cc = r0 == 0;
+	if cc jump 1f
+	r0 = 1;
+1:
+	rets = [sp++];
+	rts;
+
+/*
+ * r0 = ptr
+ * r1 = bitnr
+ *
+ * Test a bit in a 32bit word and return its value.
+ * We need this on this architecture in order to invalidate
+ * the local cache before testing.
+ *
+ * Clobbers: r3:0, p1:0
+ */
+ENTRY(___raw_bit_test_asm)
+
+	r2 = r1;
+	r1 = 1;
+	r1 <<= r2;
+	jump ___raw_atomic_test_asm
+
+/*
+ * r0 = ptr
+ *
+ * Fetch and return an uncached 32bit value.
+ *
+ * Clobbers: r2:0, p1:0
+ */
+ENTRY(___raw_uncached_fetch_asm)
+
+	p1 = r0;
+	r1 = -L1_CACHE_BYTES;
+	r1 = r0 & r1;
+	p0 = r1;
+	flushinv[p0];
+	do_ssync;
+	r0 = [p1];
+	rts;
diff --git a/arch/blackfin/mach-bf561/include/mach/blackfin.h b/arch/blackfin/mach-bf561/include/mach/blackfin.h
index 0ea8666..f79f662 100644
--- a/arch/blackfin/mach-bf561/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf561/include/mach/blackfin.h
@@ -66,8 +66,12 @@
 
 #define bfin_read_SIC_IMASK(x)		bfin_read32(SICA_IMASK0 + (x << 2))
 #define bfin_write_SIC_IMASK(x, val)	bfin_write32((SICA_IMASK0 + (x << 2)), val)
+#define bfin_read_SICB_IMASK(x)		bfin_read32(SICB_IMASK0 + (x << 2))
+#define bfin_write_SICB_IMASK(x, val)	bfin_write32((SICB_IMASK0 + (x << 2)), val)
 #define bfin_read_SIC_ISR(x)		bfin_read32(SICA_ISR0 + (x << 2))
 #define bfin_write_SIC_ISR(x, val)	bfin_write32((SICA_ISR0 + (x << 2)), val)
+#define bfin_read_SICB_ISR(x)		bfin_read32(SICB_ISR0 + (x << 2))
+#define bfin_write_SICB_ISR(x, val)	bfin_write32((SICB_ISR0 + (x << 2)), val)
 
 #define BFIN_UART_NR_PORTS      1
 
diff --git a/arch/blackfin/mach-bf561/include/mach/defBF561.h b/arch/blackfin/mach-bf561/include/mach/defBF561.h
index 4eca202..d7c5097 100644
--- a/arch/blackfin/mach-bf561/include/mach/defBF561.h
+++ b/arch/blackfin/mach-bf561/include/mach/defBF561.h
@@ -912,6 +912,9 @@
 #define ACTIVE_PLLDISABLED	0x0004	/* Processor In Active Mode With PLL Disabled   */
 #define	PLL_LOCKED			0x0020	/* PLL_LOCKCNT Has Been Reached                                 */
 
+/* SICA_SYSCR Masks */
+#define COREB_SRAM_INIT		0x0020
+
 /* SWRST Mask */
 #define SYSTEM_RESET           0x0007	/* Initiates a system software reset */
 #define DOUBLE_FAULT_A         0x0008	/* Core A Double Fault Causes Reset */
diff --git a/arch/blackfin/mach-bf561/include/mach/mem_map.h b/arch/blackfin/mach-bf561/include/mach/mem_map.h
index f1d4c06..488c3bd 100644
--- a/arch/blackfin/mach-bf561/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf561/include/mach/mem_map.h
@@ -85,4 +85,124 @@
 #define L1_SCRATCH_START	COREA_L1_SCRATCH_START
 #define L1_SCRATCH_LENGTH	0x1000
 
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_SMP
+
+#define get_l1_scratch_start_cpu(cpu)				\
+	({ unsigned long __addr;				\
+	   __addr = (cpu) ? COREB_L1_SCRATCH_START : COREA_L1_SCRATCH_START;\
+	   __addr; })
+
+#define get_l1_code_start_cpu(cpu)				\
+	({ unsigned long __addr;				\
+	   __addr = (cpu) ? COREB_L1_CODE_START : COREA_L1_CODE_START;	\
+	   __addr; })
+
+#define get_l1_data_a_start_cpu(cpu)				\
+	({ unsigned long __addr;				\
+	   __addr = (cpu) ? COREB_L1_DATA_A_START : COREA_L1_DATA_A_START;\
+	   __addr; })
+
+#define get_l1_data_b_start_cpu(cpu)				\
+	({ unsigned long __addr;				\
+	   __addr = (cpu) ? COREB_L1_DATA_B_START : COREA_L1_DATA_B_START;\
+	   __addr; })
+
+#define get_l1_scratch_start()	get_l1_scratch_start_cpu(blackfin_core_id())
+#define get_l1_code_start()	get_l1_code_start_cpu(blackfin_core_id())
+#define get_l1_data_a_start()	get_l1_data_a_start_cpu(blackfin_core_id())
+#define get_l1_data_b_start()	get_l1_data_b_start_cpu(blackfin_core_id())
+
+#else /* !CONFIG_SMP */
+#define get_l1_scratch_start_cpu(cpu)	L1_SCRATCH_START
+#define get_l1_code_start_cpu(cpu)	L1_CODE_START
+#define get_l1_data_a_start_cpu(cpu)	L1_DATA_A_START
+#define get_l1_data_b_start_cpu(cpu)	L1_DATA_B_START
+#define get_l1_scratch_start()		L1_SCRATCH_START
+#define get_l1_code_start()		L1_CODE_START
+#define get_l1_data_a_start()		L1_DATA_A_START
+#define get_l1_data_b_start()		L1_DATA_B_START
+#endif /* !CONFIG_SMP */
+
+#else /* __ASSEMBLY__ */
+
+/*
+ * The following macros both return the address of the PDA for the
+ * current core.
+ *
+ * In its first safe (and hairy) form, the macro neither clobbers any
+ * register aside of the output Preg, nor uses the stack, since it
+ * could be called with an invalid stack pointer, or the current stack
+ * space being uncovered by any CPLB (e.g. early exception handling).
+ *
+ * The constraints on the second form are a bit relaxed, and the code
+ * is allowed to use the specified Dreg for determining the PDA
+ * address to be returned into Preg.
+ */
+#ifdef CONFIG_SMP
+#define GET_PDA_SAFE(preg)		\
+	preg.l = lo(DSPID);		\
+	preg.h = hi(DSPID);		\
+	preg = [preg];			\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	preg = preg << 2;		\
+	if cc jump 2f;			\
+	cc = preg == 0x0;		\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;		\
+	if !cc jump 3f;			\
+1:					\
+	/* preg = 0x0; */		\
+	cc = !cc; /* restore cc to 0 */	\
+	jump 4f;			\
+2:					\
+	cc = preg == 0x0;		\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;		\
+	if cc jump 4f;			\
+	/* preg = 0x1000000; */		\
+	cc = !cc; /* restore cc to 1 */	\
+3:					\
+	preg = [preg];			\
+4:
+
+#define GET_PDA(preg, dreg)		\
+	preg.l = lo(DSPID);		\
+	preg.h = hi(DSPID);		\
+	dreg = [preg];			\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;		\
+	cc = bittst(dreg, 0);		\
+	if !cc jump 1f;			\
+	preg = [preg];			\
+1:					\
+
+#define GET_CPUID(preg, dreg)		\
+	preg.l = lo(DSPID);		\
+	preg.h = hi(DSPID);		\
+	dreg = [preg];			\
+	dreg = ROT dreg BY -1;		\
+	dreg = CC;
+
+#else
+#define GET_PDA_SAFE(preg)		\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;
+
+#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
+#endif /* CONFIG_SMP */
+
+#endif /* __ASSEMBLY__ */
+
 #endif				/* _MEM_MAP_533_H_ */
diff --git a/arch/blackfin/mach-bf561/include/mach/smp.h b/arch/blackfin/mach-bf561/include/mach/smp.h
new file mode 100644
index 0000000..f9e65eb
--- /dev/null
+++ b/arch/blackfin/mach-bf561/include/mach/smp.h
@@ -0,0 +1,22 @@
+#ifndef _MACH_BF561_SMP
+#define _MACH_BF561_SMP
+
+struct task_struct;
+
+void platform_init_cpus(void);
+
+void platform_prepare_cpus(unsigned int max_cpus);
+
+int platform_boot_secondary(unsigned int cpu, struct task_struct *idle);
+
+void platform_secondary_init(unsigned int cpu);
+
+void platform_request_ipi(int (*handler)(int, void *));
+
+void platform_send_ipi(cpumask_t callmap);
+
+void platform_send_ipi_cpu(unsigned int cpu);
+
+void platform_clear_ipi(unsigned int cpu);
+
+#endif /* !_MACH_BF561_SMP */
diff --git a/arch/blackfin/mach-bf561/secondary.S b/arch/blackfin/mach-bf561/secondary.S
new file mode 100644
index 0000000..3532404
--- /dev/null
+++ b/arch/blackfin/mach-bf561/secondary.S
@@ -0,0 +1,215 @@
+/*
+ * File:         arch/blackfin/mach-bf561/secondary.S
+ * Based on:     arch/blackfin/mach-bf561/head.S
+ * Author:       Philippe Gerum <rpm@xenomai.org>
+ *
+ *               Copyright 2007 Analog Devices Inc.
+ *
+ * Description:  BF561 coreB bootstrap file
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/blackfin.h>
+#include <asm/asm-offsets.h>
+
+__INIT
+
+/* Lay the initial stack into the L1 scratch area of Core B */
+#define INITIAL_STACK	0xFF701000
+
+ENTRY(_coreb_trampoline_start)
+	/* Set the SYSCFG register */
+	R0 = 0x36;
+	SYSCFG = R0; /*Enable Cycle Counter and Nesting Of Interrupts(3rd Bit)*/
+	R0 = 0;
+
+	/*Clear Out All the data and pointer  Registers*/
+	R1 = R0;
+	R2 = R0;
+	R3 = R0;
+	R4 = R0;
+	R5 = R0;
+	R6 = R0;
+	R7 = R0;
+
+	P0 = R0;
+	P1 = R0;
+	P2 = R0;
+	P3 = R0;
+	P4 = R0;
+	P5 = R0;
+
+	LC0 = r0;
+	LC1 = r0;
+	L0 = r0;
+	L1 = r0;
+	L2 = r0;
+	L3 = r0;
+
+	/* Clear Out All the DAG Registers*/
+	B0 = r0;
+	B1 = r0;
+	B2 = r0;
+	B3 = r0;
+
+	I0 = r0;
+	I1 = r0;
+	I2 = r0;
+	I3 = r0;
+
+	M0 = r0;
+	M1 = r0;
+	M2 = r0;
+	M3 = r0;
+
+	/* Turn off the icache */
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
+	R1 = [p0];
+	R0 = ~ENICPLB;
+	R0 = R0 & R1;
+
+	/* Anomaly 05000125 */
+#ifdef ANOMALY_05000125
+	CLI R2;
+	SSYNC;
+#endif
+	[p0] = R0;
+	SSYNC;
+#ifdef ANOMALY_05000125
+	STI R2;
+#endif
+
+	/* Turn off the dcache */
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
+	R1 = [p0];
+	R0 = ~ENDCPLB;
+	R0 = R0 & R1;
+
+	/* Anomaly 05000125 */
+#ifdef ANOMALY_05000125
+	CLI R2;
+	SSYNC;
+#endif
+	[p0] = R0;
+	SSYNC;
+#ifdef ANOMALY_05000125
+	STI R2;
+#endif
+
+	/* in case of double faults, save a few things */
+	p0.l = _init_retx_coreb;
+	p0.h = _init_retx_coreb;
+	R0 = RETX;
+	[P0] = R0;
+
+#ifdef CONFIG_DEBUG_DOUBLEFAULT
+	/* Only save these if we are storing them,
+	 * This happens here, since L1 gets clobbered
+	 * below
+	 */
+	GET_PDA(p0, r0);
+	r7 = [p0 + PDA_RETX];
+	p1.l = _init_saved_retx_coreb;
+	p1.h = _init_saved_retx_coreb;
+	[p1] = r7;
+
+	r7 = [p0 + PDA_DCPLB];
+	p1.l = _init_saved_dcplb_fault_addr_coreb;
+	p1.h = _init_saved_dcplb_fault_addr_coreb;
+	[p1] = r7;
+
+	r7 = [p0 + PDA_ICPLB];
+	p1.l = _init_saved_icplb_fault_addr_coreb;
+	p1.h = _init_saved_icplb_fault_addr_coreb;
+	[p1] = r7;
+
+	r7 = [p0 + PDA_SEQSTAT];
+	p1.l = _init_saved_seqstat_coreb;
+	p1.h = _init_saved_seqstat_coreb;
+	[p1] = r7;
+#endif
+
+	/* Initialize stack pointer */
+	sp.l = lo(INITIAL_STACK);
+	sp.h = hi(INITIAL_STACK);
+	fp = sp;
+	usp = sp;
+
+	/* This section keeps the processor in supervisor mode
+	 * during core B startup.  Branches to the idle task.
+	 */
+
+	/* EVT15 = _real_start */
+
+	p0.l = lo(EVT15);
+	p0.h = hi(EVT15);
+	p1.l = _coreb_start;
+	p1.h = _coreb_start;
+	[p0] = p1;
+	csync;
+
+	p0.l = lo(IMASK);
+	p0.h = hi(IMASK);
+	p1.l = IMASK_IVG15;
+	p1.h = 0x0;
+	[p0] = p1;
+	csync;
+
+	raise 15;
+	p0.l = .LWAIT_HERE;
+	p0.h = .LWAIT_HERE;
+	reti = p0;
+#if defined(ANOMALY_05000281)
+	nop; nop; nop;
+#endif
+	rti;
+
+.LWAIT_HERE:
+	jump .LWAIT_HERE;
+
+.align 4
+ENTRY(_coreb_trampoline_end)
+
+ENTRY(_coreb_start)
+	[--sp] = reti;
+
+	p0.l = lo(WDOGB_CTL);
+	p0.h = hi(WDOGB_CTL);
+	r0 = 0xAD6(z);
+	w[p0] = r0;	/* Clear the watchdog. */
+	ssync;
+
+	/*
+	 * switch to IDLE stack.
+	 */
+	p0.l = _secondary_stack;
+	p0.h = _secondary_stack;
+	sp = [p0];
+	usp = sp;
+	fp = sp;
+	sp += -12;
+	call _init_pda
+	sp += 12;
+	call _secondary_start_kernel;
+.L_exit:
+	jump.s	.L_exit;
+
+__FINIT
diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
new file mode 100644
index 0000000..ba21051
--- /dev/null
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -0,0 +1,182 @@
+/*
+ * File:         arch/blackfin/mach-bf561/smp.c
+ * Author:       Philippe Gerum <rpm@xenomai.org>
+ *
+ *               Copyright 2007 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <asm/smp.h>
+#include <asm/dma.h>
+
+#define COREB_SRAM_BASE  0xff600000
+#define COREB_SRAM_SIZE  0x4000
+
+extern char coreb_trampoline_start, coreb_trampoline_end;
+
+static DEFINE_SPINLOCK(boot_lock);
+
+static cpumask_t cpu_callin_map;
+
+/*
+ * platform_init_cpus() - Tell the world about how many cores we
+ * have. This is called while setting up the architecture support
+ * (setup_arch()), so don't be too demanding here with respect to
+ * available kernel services.
+ */
+
+void __init platform_init_cpus(void)
+{
+	cpu_set(0, cpu_possible_map); /* CoreA */
+	cpu_set(1, cpu_possible_map); /* CoreB */
+}
+
+void __init platform_prepare_cpus(unsigned int max_cpus)
+{
+	int len;
+
+	len = &coreb_trampoline_end - &coreb_trampoline_start + 1;
+
+	if (len > COREB_SRAM_SIZE) {
+		/* Paranoid. */
+		printk(KERN_ERR "Bootstrap code size (%d) > CoreB SRAM (%d).\n",
+		       len, COREB_SRAM_SIZE);
+		return;
+	}
+
+	dma_memcpy((void *)COREB_SRAM_BASE, &coreb_trampoline_start, len);
+
+	/* Both cores ought to be present on a bf561! */
+	cpu_set(0, cpu_present_map); /* CoreA */
+	cpu_set(1, cpu_present_map); /* CoreB */
+
+	printk(KERN_INFO "CoreB bootstrap code to SRAM %p via DMA.\n", (void *)COREB_SRAM_BASE);
+}
+
+int __init setup_profiling_timer(unsigned int multiplier) /* not supported */
+{
+	return -EINVAL;
+}
+
+void __cpuinit platform_secondary_init(unsigned int cpu)
+{
+	local_irq_disable();
+
+	/* Clone setup for peripheral interrupt sources from CoreA. */
+	bfin_write_SICB_IMASK0(bfin_read_SICA_IMASK0());
+	bfin_write_SICB_IMASK1(bfin_read_SICA_IMASK1());
+	SSYNC();
+
+	/* Clone setup for IARs from CoreA. */
+	bfin_write_SICB_IAR0(bfin_read_SICA_IAR0());
+	bfin_write_SICB_IAR1(bfin_read_SICA_IAR1());
+	bfin_write_SICB_IAR2(bfin_read_SICA_IAR2());
+	bfin_write_SICB_IAR3(bfin_read_SICA_IAR3());
+	bfin_write_SICB_IAR4(bfin_read_SICA_IAR4());
+	bfin_write_SICB_IAR5(bfin_read_SICA_IAR5());
+	bfin_write_SICB_IAR6(bfin_read_SICA_IAR6());
+	bfin_write_SICB_IAR7(bfin_read_SICA_IAR7());
+	SSYNC();
+
+	local_irq_enable();
+
+	/* Calibrate loops per jiffy value. */
+	calibrate_delay();
+
+	/* Store CPU-private information to the cpu_data array. */
+	bfin_setup_cpudata(cpu);
+
+	/* We are done with local CPU inits, unblock the boot CPU. */
+	cpu_set(cpu, cpu_callin_map);
+	spin_lock(&boot_lock);
+	spin_unlock(&boot_lock);
+}
+
+int __cpuinit platform_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long timeout;
+
+	if ((bfin_read_SICA_SYSCR() & COREB_SRAM_INIT) == 0)
+		return -EBUSY;	/* CoreB already running?! */
+
+	printk(KERN_INFO "Booting Core B.\n");
+
+	spin_lock(&boot_lock);
+
+	/* Kick CoreB, which should start execution from CORE_SRAM_BASE. */
+	SSYNC();
+	bfin_write_SICA_SYSCR(bfin_read_SICA_SYSCR() & ~COREB_SRAM_INIT);
+	SSYNC();
+
+	timeout = jiffies + 1 * HZ;
+	while (time_before(jiffies, timeout)) {
+		if (cpu_isset(cpu, cpu_callin_map))
+			break;
+		udelay(100);
+		barrier();
+	}
+
+	spin_unlock(&boot_lock);
+
+	return cpu_isset(cpu, cpu_callin_map) ? 0 : -ENOSYS;
+}
+
+void platform_request_ipi(irq_handler_t handler)
+{
+	int ret;
+
+	ret = request_irq(IRQ_SUPPLE_0, handler, IRQF_DISABLED,
+			  "SMP interrupt", handler);
+	if (ret)
+		panic("Cannot request supplemental interrupt 0 for IPI service\n");
+}
+
+void platform_send_ipi(cpumask_t callmap)
+{
+	unsigned int cpu;
+
+	for_each_cpu_mask(cpu, callmap) {
+		if (likely(cpu < 2)) {
+			SSYNC();
+			bfin_write_SICB_SYSCR(bfin_read_SICB_SYSCR() | (1 << (6 + cpu)));
+			SSYNC();
+		}
+	}
+}
+
+void platform_send_ipi_cpu(unsigned int cpu)
+{
+
+	if (likely(cpu < 2)) {
+		SSYNC();
+		bfin_write_SICB_SYSCR(bfin_read_SICB_SYSCR() | (1 << (6 + cpu)));
+		SSYNC();
+	}
+}
+
+void platform_clear_ipi(unsigned int cpu)
+{
+	if (likely(cpu < 2)) {
+		SSYNC();
+		bfin_write_SICB_SYSCR(bfin_read_SICB_SYSCR() | (1 << (10 + cpu)));
+		SSYNC();
+	}
+}
-- 
1.5.6.3
