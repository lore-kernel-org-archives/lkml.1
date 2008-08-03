Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYHCDAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYHCDAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYHCDAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:00:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYHCDAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ECc5JdvcDB4Px5GVA4PYERvdA82AxmNKXoTlQ+zFXUpjbVaML+sKa/rI23qK7QrcY6
         aTLoYk7SaNWnuLOB2G4sKWi4ewbzx858hLhTa9ZJbjr7XIy6XpAyoMwiGZ6ivhjaYd0Y
         NhaupO6/ubkiOHiBgm+00/BXCWSRlTaCR1T+w=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 01/25] x86: 64bit support more than 256 irq v2
Date: Sat,  2 Aug 2008 19:59:01 -0700
Message-Id: <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
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

v2: change NR_IRQS to 1024

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
---
 include/asm-x86/irq_vectors.h |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index 646d59f..0817a19 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -113,28 +113,22 @@
 
 # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
 
-#  define NR_IRQS		224
-
-#  if (224 >= 32 * NR_CPUS)
-#   define NR_IRQ_VECTORS	NR_IRQS
-#  else
-#   define NR_IRQ_VECTORS	(32 * NR_CPUS)
-#  endif
+#define NR_IRQS			1024
 
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
-- 
1.5.4.5

