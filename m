Return-Path: <linux-kernel-owner+w=401wt.eu-S965338AbXDIUj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338AbXDIUj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965574AbXDIUj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:39:56 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:52265 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965338AbXDIUjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:39:55 -0400
X-Greylist: delayed 2739 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Apr 2007 16:39:55 EDT
Date: Mon, 9 Apr 2007 12:56:27 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] Pad irq_desc to internode cacheline size
Message-ID: <20070409195356.GA5275@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We noticed a drop in n/w performance due to the irq_desc being cacheline
aligned rather than internode aligned.  We see 50% of expected performance
when two e1000 nics local to two different nodes have consecutive irq
descriptors allocated, due to false sharing.

Note that this patch does away with cacheline padding for the UP case, as it
does not seem useful for UP configurations.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>

Index: linux-2.6.21-rc5/include/linux/irq.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/irq.h	2007-04-09 10:16:23.560848473 -0700
+++ linux-2.6.21-rc5/include/linux/irq.h	2007-04-09 10:16:45.401177929 -0700
@@ -175,7 +175,7 @@ struct irq_desc {
 	struct proc_dir_entry	*dir;
 #endif
 	const char		*name;
-} ____cacheline_aligned;
+} ____cacheline_internodealigned_in_smp;
 
 extern struct irq_desc irq_desc[NR_IRQS];
 
Index: linux-2.6.21-rc5/kernel/irq/handle.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/irq/handle.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.21-rc5/kernel/irq/handle.c	2007-04-09 12:26:40.473326023 -0700
@@ -48,7 +48,7 @@ handle_bad_irq(unsigned int irq, struct 
  *
  * Controller mappings for all interrupt sources:
  */
-struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned = {
+struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
 		.chip = &no_irq_chip,
