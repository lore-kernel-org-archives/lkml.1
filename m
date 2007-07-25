Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbXGYUrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbXGYUrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbXGYUrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:47:36 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:31530 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757937AbXGYUrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:47:35 -0400
Date: Wed, 25 Jul 2007 14:55:01 -0600
From: dougthompson@xmission.com
To: greg@kroah.com, ralf@linux-mips.org, egor@pasemi.com,
       dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/4] include asm-mips add missing edac h file
Message-ID: <46a7b8a5.iyNdV9o+A3Vzog2D%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.h>

EDAC has a foundation to perform software memory scrubbing, but it
requires a per architecture (atomic_scrub) function for performing an atomic
update operation.  Under X86, this is done with a 

lock:  add  [addr],0

in the file asm-x86/edac.h

This patch provides the MIPS arch with that atomic function, atomic_scrub() in

asm-mips/edac.h

Cc:             Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc:		Ralf Baechle <ralf@linux-mips.org>
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 edac.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux-2.6.23-rc1/include/asm-mips/edac.h
===================================================================
--- /dev/null
+++ linux-2.6.23-rc1/include/asm-mips/edac.h
@@ -0,0 +1,35 @@
+#ifndef ASM_EDAC_H
+#define ASM_EDAC_H
+
+/* ECC atomic, DMA, SMP and interrupt safe scrub function */
+
+static __inline__ void atomic_scrub(void *va, u32 size)
+{
+	unsigned long *virt_addr = va;
+	unsigned long temp;
+	u32 i;
+
+	for (i = 0; i < size / sizeof(unsigned long); i++, virt_addr++) {
+
+		/*
+		 * Very carefully read and write to memory atomically
+		 * so we are interrupt, DMA and SMP safe.
+		 *
+		 * Intel: asm("lock; addl $0, %0"::"m"(*virt_addr));
+		 */
+
+		__asm__ __volatile__ (
+		"       .set    mips3                                   \n"
+		"1:     ll      %0, %1          # atomic_add            \n"
+		"       ll      %0, %1          # atomic_add            \n"
+		"       addu    %0, $0                                  \n"
+		"       sc      %0, %1                                  \n"
+		"       beqz    %0, 1b                                  \n"
+		"       .set    mips0                                   \n"
+		: "=&r" (temp), "=m" (*virt_addr)
+		: "m" (*virt_addr));
+
+	}
+}
+
+#endif
