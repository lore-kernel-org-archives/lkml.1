Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0CBVlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:41:50 -0500
Received: from [206.15.93.42] ([206.15.93.42]:17094 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752938Ab0CBVlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:41:49 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/dt3155: sparse cleanup of allocator code
Date: Tue, 2 Mar 2010 14:41:43 -0700
Cc: greg@kroah.com, ss@aao.gov.au
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003021441.43322.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up the worst of the sparse issues in the allocator code.

1) include allocator.h for exported function prototypes
2) fix the return type for allocator_free_dma
3) fix the 2nd parameter type for allocator_allocate_dma
4) make all the local variables static
5) change the "remapped" variable in allocator_init to a void __iomem *

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Scott Smedley <ss@aao.gov.au>

---

I'm not sure how to handle the strcpy/strcmp using "remapped". It is
setup with ioremap and released with iounmap so it should be a
void __iomem *. But, using that in strcpy/strcmp results in a "cast
removes address space of expression" sparse warning.

diff --git a/drivers/staging/dt3155/allocator.c b/drivers/staging/dt3155/allocator.c
index c74234c..53c5069 100644
--- a/drivers/staging/dt3155/allocator.c
+++ b/drivers/staging/dt3155/allocator.c
@@ -58,6 +58,8 @@
 
 #include <asm/page.h>
 
+#include "allocator.h"
+
 /*#define ALL_DEBUG*/
 #define ALL_MSG "allocator: "
 
@@ -83,9 +85,9 @@
 /*#define PDEBUGG(fmt, args...) printk( KERN_DEBUG ALL_MSG fmt, ## args)*/
 
 
-int allocator_himem = 1; /* 0 = probe, pos. = megs, neg. = disable   */
-int allocator_step = 1;  /* This is the step size in MB              */
-int allocator_probe = 1; /* This is a flag -- 1=probe, 0=don't probe */
+static int allocator_himem = 1; /* 0 = probe, pos. = megs, neg. = disable   */
+static int allocator_step = 1;  /* This is the step size in MB              */
+static int allocator_probe = 1; /* This is a flag -- 1=probe, 0=don't probe */
 
 static unsigned long allocator_buffer;		/* physical address */
 static unsigned long allocator_buffer_size;	/* kilobytes */
@@ -101,7 +103,7 @@ struct allocator_struct {
 	struct allocator_struct *next;
 };
 
-struct allocator_struct *allocator_list;
+static struct allocator_struct *allocator_list;
 
 
 #ifdef ALL_DEBUG
@@ -124,7 +126,7 @@ static int dump_list(void)
  * be used straight ahead for DMA, but needs remapping for program use).
  */
 
-unsigned long allocator_allocate_dma(unsigned long kilobytes, int prio)
+unsigned long allocator_allocate_dma(unsigned long kilobytes, gfp_t flags)
 {
 	struct allocator_struct *ptr = allocator_list, *newptr;
 	unsigned long bytes = kilobytes << 10;
@@ -147,7 +149,7 @@ unsigned long allocator_allocate_dma(unsigned long kilobytes, int prio)
 		PDEBUG("alloc failed\n");
 		return 0; /* end of list */
 	}
-	newptr = kmalloc(sizeof(struct allocator_struct), prio);
+	newptr = kmalloc(sizeof(struct allocator_struct), flags);
 	if (!newptr)
 		return 0;
 
@@ -198,7 +200,7 @@ int allocator_free_dma(unsigned long address)
 int allocator_init(u32 *allocator_max)
 {
 	/* check how much free memory is there */
-	void *remapped;
+	void __iomem *remapped;
 	unsigned long max;
 	unsigned long trial_size = allocator_himem<<20;
 	unsigned long last_trial = 0;
@@ -227,7 +229,7 @@ int allocator_init(u32 *allocator_max)
 			if (strcmp((char *)(remapped)+i, test_string))
 				break;
 			}
-		iounmap((void *)remapped);
+		iounmap(remapped);
 		schedule();
 		last_trial = trial_size;
 		if (i == trial_size)
diff --git a/drivers/staging/dt3155/allocator.h b/drivers/staging/dt3155/allocator.h
index bdf3268..425b70f 100644
--- a/drivers/staging/dt3155/allocator.h
+++ b/drivers/staging/dt3155/allocator.h
@@ -22,7 +22,7 @@
  *
  */
 
-void allocator_free_dma(unsigned long address);
-unsigned long allocator_allocate_dma(unsigned long kilobytes, int priority);
+int allocator_free_dma(unsigned long address);
+unsigned long allocator_allocate_dma(unsigned long kilobytes, gfp_t flags);
 int allocator_init(u32 *);
 void allocator_cleanup(void);
