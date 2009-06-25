Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZFYKLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZFYKLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFYKLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:11:46 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:41352 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZFYKLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:11:45 -0400
Date: Thu, 25 Jun 2009 12:11:47 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] gcov: fix __ctors_start alignment
Message-ID: <20090625101147.GB5051@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The ctors section for each object file is eight byte aligned (on 64 bit).
However the __ctors_start symbol starts at an arbitrary address dependent
on the size of the previous sections.
Therefore the linker may add some zeroes after __ctors_start to make sure
the ctors contents are properly aligned. However the extra zeroes at the
beginning aren't expected by the code. When walking the functions pointers
contained in there and extra zeroes are added this may result in random
jumps.
So make sure that the __ctors_start symbol is always aligned as well.

Fixes this crash on an allyesconfig on s390:

[    0.582482] Kernel BUG at 0000000000000012 [verbose debug info unavailable] 
[    0.582489] illegal operation: 0001 [#1] SMP DEBUG_PAGEALLOC 
[    0.582496] Modules linked in: 
[    0.582501] CPU: 0 Tainted: G        W  2.6.31-rc1-dirty #273 
[    0.582506] Process swapper (pid: 1, task: 000000003f218000, ksp: 000000003f2238e8) 
[    0.582510] Krnl PSW : 0704200180000000 0000000000000012 (0x12) 
[    0.582518]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3 
[    0.582524] Krnl GPRS: 0000000000036727 0000000000000010 0000000000000001 0000000000000001 
[    0.582529]            00000000001dfefa 0000000000000000 0000000000000000 0000000000000040 
[    0.582534]            0000000001fff0f0 0000000001790628 0000000002296048 0000000002296048 
[    0.582540]            00000000020c438e 0000000001786000 0000000002014a66 000000003f223e60 
[    0.582553] Krnl Code:>0000000000000012: 0000                unknown 
[    0.582559]            0000000000000014: 0000                unknown 
[    0.582564]            0000000000000016: 0000                unknown 
[    0.582570]            0000000000000018: 0000                unknown 
[    0.582575]            000000000000001a: 0000                unknown 
[    0.582580]            000000000000001c: 0000                unknown 
[    0.582585]            000000000000001e: 0000                unknown 
[    0.582591]            0000000000000020: 0000                unknown 
[    0.582596] Call Trace: 
[    0.582599] ([<0000000002014a46>] kernel_init+0x622/0x7a0) 
[    0.582607]  [<0000000000113e22>] kernel_thread_starter+0x6/0xc 
[    0.582615]  [<0000000000113e1c>] kernel_thread_starter+0x0/0xc 
[    0.582621] INFO: lockdep is turned off. 
[    0.582624] Last Breaking-Event-Address: 
[    0.582627]  [<0000000002014a64>] kernel_init+0x640/0x7a0 

Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/asm-generic/vmlinux.lds.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6/include/asm-generic/vmlinux.lds.h
@@ -441,7 +441,8 @@
 	}
 
 #ifdef CONFIG_CONSTRUCTORS
-#define KERNEL_CTORS()	VMLINUX_SYMBOL(__ctors_start) = .; \
+#define KERNEL_CTORS()	. = ALIGN(8);			   \
+			VMLINUX_SYMBOL(__ctors_start) = .; \
 			*(.ctors)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
