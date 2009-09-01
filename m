Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZIAPqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZIAPqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 11:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZIAPqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 11:46:23 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:45445 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbZIAPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 11:46:23 -0400
Date: Tue, 1 Sep 2009 17:38:23 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-cris-kernel <linux-cris-kernel@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cris: convert to asm-generic/hardirq.h
Message-ID: <20090901153823.GR18552@axis.com>
References: <20090804144952.GC20487@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804144952.GC20487@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 04:49:52PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/arch/cris/include/asm/hardirq.h
> ===================================================================
> --- linux-2.6.orig/arch/cris/include/asm/hardirq.h	2009-07-27 14:32:58.267148765 +0200
> +++ linux-2.6/arch/cris/include/asm/hardirq.h	2009-07-27 14:55:19.652910119 +0200
> @@ -2,16 +2,6 @@
>  #define __ASM_HARDIRQ_H
>  
>  #include <asm/irq.h>
> -#include <linux/threads.h>
> -#include <linux/cache.h>
> -
> -typedef struct {
> -	unsigned int __softirq_pending;
> -} ____cacheline_aligned irq_cpustat_t;
> -
> -#include <linux/irq_cpustat.h> /* Standard mappings for irq_cpustat_t above */
> -
> -void ack_bad_irq(unsigned int irq);
>  
>  #define HARDIRQ_BITS	8
>  
> @@ -24,4 +14,6 @@ void ack_bad_irq(unsigned int irq);
>  # error HARDIRQ_BITS is too low!
>  #endif
>  
> +#include <asm-generic/hardirq.h>
> +
>  #endif /* __ASM_HARDIRQ_H */
> Index: linux-2.6/arch/cris/kernel/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/cris/kernel/irq.c	2009-07-27 14:53:45.590898928 +0200
> +++ linux-2.6/arch/cris/kernel/irq.c	2009-07-27 14:54:58.635901441 +0200
> @@ -38,11 +38,6 @@
>  
>  #include <asm/io.h>
>  
> -void ack_bad_irq(unsigned int irq)
> -{
> -	printk("unexpected IRQ trap at vector %02x\n", irq);
> -}
> -
>  int show_interrupts(struct seq_file *p, void *v)
>  {
>  	int i = *(loff_t *) v, j;


Thanks! I found that the above change was not enough since CRIS had
some extra (incorrect) prototypes for setup_irq that caused compile
errors, so I've added the the following patch to the cris-tree:

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] CRIS: convert to asm-generic/hardirq.h

Convert CRIS to use asm-generic/hardirq.h
Also remove unneeded (incorrect) prototypes for setup_irq().

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/kernel/time.c |    1 -
 arch/cris/arch-v32/kernel/smp.c  |    2 --
 arch/cris/arch-v32/kernel/time.c |    1 -
 arch/cris/include/asm/hardirq.h  |   12 ++----------
 arch/cris/kernel/irq.c           |    5 -----
 5 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 2b73c7a..31ca141 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -28,7 +28,6 @@
 
 extern void update_xtime_from_cmos(void);
 extern int set_rtc_mmss(unsigned long nowtime);
-extern int setup_irq(int, struct irqaction *);
 extern int have_rtc;
 
 unsigned long get_ns_in_jiffie(void)
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index d2a3ff8..058addd 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -52,8 +52,6 @@ static struct mm_struct* flush_mm;
 static struct vm_area_struct* flush_vma;
 static unsigned long flush_addr;
 
-extern int setup_irq(int, struct irqaction *);
-
 /* Mode registers */
 static unsigned long irq_regs[NR_CPUS] = {
   regi_irq,
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index 65633d0..b1920d8 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -46,7 +46,6 @@ unsigned long timer_regs[NR_CPUS] =
 
 extern void update_xtime_from_cmos(void);
 extern int set_rtc_mmss(unsigned long nowtime);
-extern int setup_irq(int, struct irqaction *);
 extern int have_rtc;
 
 #ifdef CONFIG_CPU_FREQ
diff --git a/arch/cris/include/asm/hardirq.h b/arch/cris/include/asm/hardirq.h
index 74178ad..17bb12d 100644
--- a/arch/cris/include/asm/hardirq.h
+++ b/arch/cris/include/asm/hardirq.h
@@ -2,16 +2,6 @@
 #define __ASM_HARDIRQ_H
 
 #include <asm/irq.h>
-#include <linux/threads.h>
-#include <linux/cache.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h> /* Standard mappings for irq_cpustat_t above */
-
-void ack_bad_irq(unsigned int irq);
 
 #define HARDIRQ_BITS	8
 
@@ -24,4 +14,6 @@ void ack_bad_irq(unsigned int irq);
 # error HARDIRQ_BITS is too low!
 #endif
 
+#include <asm-generic/hardirq.h>
+
 #endif /* __ASM_HARDIRQ_H */
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index 7f642fc..0ca7d98 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -38,11 +38,6 @@
 
 #include <asm/io.h>
 
-void ack_bad_irq(unsigned int irq)
-{
-	printk("unexpected IRQ trap at vector %02x\n", irq);
-}
-
 int show_interrupts(struct seq_file *p, void *v)
 {
 	int i = *(loff_t *) v, j;
-- 
1.6.1

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
