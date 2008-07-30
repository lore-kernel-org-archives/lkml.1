Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYG3VL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYG3VL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbYG3VJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:09:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:17437 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbYG3VJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ek7CsZNmCtzNnK8bhAEHovNX8hJkSsJmIFwSQf7xGUfZYGz8W95QmhSGw9p0vJyFAO
         TygJHP8rdsIRHKADhkHvYGVGI0FH3Ea25j1XBMctN3MC0jLxMOWpUks7jPZsKr3hYYHO
         HzSHtaW5fhjrEa03SG976qIW4SUcno9RE28zs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/7] x86: 64bit support more than 256 irq v1
Date: Wed, 30 Jul 2008 12:27:45 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807300311.48510.yhlu.kernel@gmail.com> <200807301210.31511.yhlu.kernel@gmail.com>
In-Reply-To: <200807301210.31511.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807301227.45947.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dhaval Giani got:
kernel BUG at arch/x86/kernel/io_apic_64.c:357!
invalid opcode: 0000 [1] SMP
CPU 24
...

his system (x3950) has 8 ioapic, irq > 256

caused by
        commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
        Author: Thomas Gleixner <tglx@linutronix.de>
        Date:   Fri May 2 20:10:09 2008 +0200

           x86: unify interrupt vector defines

           The interrupt vector defines are copied 4 times around with minimal
           differences. Move them all into asm-x86/irq_vectors.h

because 64bit allow same vector for different cpu to serve different irq

need to create that array dynamically later

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 include/asm-x86/irq_vectors.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)
Index: linux-2.6/include/asm-x86/irq_vectors.h
===================================================================
--- linux-2.6.orig/include/asm-x86/irq_vectors.h
+++ linux-2.6/include/asm-x86/irq_vectors.h
@@ -113,28 +113,26 @@
 
 # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
 
+#ifdef CONFIG_X86_64
+#  define NR_IRQS		(32 * NR_CPUS + 224)
+#else
 #  define NR_IRQS		224
-
-#  if (224 >= 32 * NR_CPUS)
-#   define NR_IRQ_VECTORS	NR_IRQS
-#  else
-#   define NR_IRQ_VECTORS	(32 * NR_CPUS)
-#  endif
+#endif
 
 # else /* IO_APIC || PARAVIRT */
 
 #  define NR_IRQS		16
-#  define NR_IRQ_VECTORS	NR_IRQS
 
 # endif
 
 #else /* !VISWS && !VOYAGER */
 
 # define NR_IRQS		224
-# define NR_IRQ_VECTORS		NR_IRQS
 
 #endif /* VISWS */
 
+#define NR_IRQ_VECTORS		NR_IRQS
+
 /* Voyager specific defines */
 /* These define the CPIs we use in linux */
 #define VIC_CPI_LEVEL0			0
