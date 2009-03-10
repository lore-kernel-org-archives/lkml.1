Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZCJH5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZCJH5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 03:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZCJH43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 03:56:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:56888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbZCJH40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 03:56:26 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: Tejun Heo <tj@kernel.org>, Pat Gefre <pfg@sgi.com>
Subject: [PATCH 1/5] linker script: define __per_cpu_load on all SMP capable archs
Date: Tue, 10 Mar 2009 16:53:47 +0900
Message-Id: <1236671631-9305-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236671631-9305-1-git-send-email-tj@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 07:53:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: __per_cpu_load available on all SMP capable archs

Percpu now requires three symbols to be defined - __per_cpu_load,
__per_cpu_start and __per_cpu_end.  There were three archs which
didn't have it.  Update them as follows.

* powerpc: can use generic PERCPU() macro.  Compile tested for
  powerpc32, compile/boot tested for powerpc64.

* ia64: can use generic PERCPU_VADDR() macro.  __phys_per_cpu_start is
  identical to __per_cpu_load.  Compile tested and symbol table looks
  identical after the change except for the additional __per_cpu_load.

* arm: added explicit __per_cpu_load definition.  Currently uses
  unified .init output section so can't use the generic macro.  Dunno
  whether the unified .init ouput section is required by arch
  peculiarity so I left it alone.  Please break it up and use PERCPU()
  if possible.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pat Gefre <pfg@sgi.com>
Cc: Russell King <rmk@arm.linux.org.uk>
---
 arch/arm/kernel/vmlinux.lds.S     |    1 +
 arch/ia64/kernel/vmlinux.lds.S    |   12 ++----------
 arch/powerpc/kernel/vmlinux.lds.S |    9 +--------
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 85598f7..1602373 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -64,6 +64,7 @@ SECTIONS
 		__initramfs_end = .;
 #endif
 		. = ALIGN(4096);
+		__per_cpu_load = .;
 		__per_cpu_start = .;
 			*(.data.percpu.page_aligned)
 			*(.data.percpu)
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index f45e4e5..3765efc 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -213,17 +213,9 @@ SECTIONS
         { *(.data.cacheline_aligned) }
 
   /* Per-cpu data: */
-  percpu : { } :percpu
   . = ALIGN(PERCPU_PAGE_SIZE);
-  __phys_per_cpu_start = .;
-  .data.percpu PERCPU_ADDR : AT(__phys_per_cpu_start - LOAD_OFFSET)
-	{
-		__per_cpu_start = .;
-		*(.data.percpu.page_aligned)
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
-		__per_cpu_end = .;
-	}
+  PERCPU_VADDR(PERCPU_ADDR, :percpu)
+  __phys_per_cpu_start = __per_cpu_load;
   . = __phys_per_cpu_start + PERCPU_PAGE_SIZE;	/* ensure percpu data fits
   						 * into percpu page size
 						 */
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 295ccc5..67f07f4 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -181,14 +181,7 @@ SECTIONS
 		__initramfs_end = .;
 	}
 #endif
-	. = ALIGN(PAGE_SIZE);
-	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
-		__per_cpu_start = .;
-		*(.data.percpu.page_aligned)
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
-		__per_cpu_end = .;
-	}
+	PERCPU(PAGE_SIZE)
 
 	. = ALIGN(8);
 	.machine.desc : AT(ADDR(.machine.desc) - LOAD_OFFSET) {
-- 
1.6.0.2

