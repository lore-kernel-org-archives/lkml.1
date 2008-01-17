Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbYAQVm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbYAQVm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757788AbYAQVlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:21 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44746 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbYAQVlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:20 -0500
Date: Thu, 17 Jan 2008 16:40:45 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: John Reiser <jreiser@BitWagon.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/20] UML - Remove map_cb
Message-ID: <20080117214045.GA6757@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Reiser noticed that a physical memory region was being mapped twice.

This patch fixes that, and it inlines the responsible function, as
that had only one caller.

Cc: John Reiser <jreiser@BitWagon.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/mem.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux-2.6.22/arch/um/kernel/mem.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/mem.c	2008-01-02 11:44:36.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/mem.c	2008-01-02 12:08:45.000000000 -0500
@@ -36,11 +36,6 @@ int kmalloc_ok = 0;
 /* Used during early boot */
 static unsigned long brk_end;
 
-static void map_cb(void *unused)
-{
-	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
-}
-
 #ifdef CONFIG_HIGHMEM
 static void setup_highmem(unsigned long highmem_start,
 			  unsigned long highmem_len)
@@ -68,8 +63,7 @@ void __init mem_init(void)
 	 * to be turned on.
 	 */
 	brk_end = (unsigned long) UML_ROUND_UP(sbrk(0));
-	map_cb(NULL);
-	initial_thread_cb(map_cb, NULL);
+	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
 	free_bootmem(__pa(brk_end), uml_reserved - brk_end);
 	uml_reserved = brk_end;
 
