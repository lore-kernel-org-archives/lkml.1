Return-Path: <linux-kernel-owner+w=401wt.eu-S1030735AbXDMVuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030735AbXDMVuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030819AbXDMVuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:50:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:58927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030735AbXDMVuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:50:04 -0400
Date: Fri, 13 Apr 2007 14:49:57 -0700
Message-Id: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: For debugging, make the initial page table setup less forgiving.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We just discovered that the accounting for initial memory usage
(head.S: INIT_MAP_BEYOND_END) has been way, way off for a very long
time.  This patch makes the initial page table not round up to the
nearest 4M boundary, but instead stop dead (and zero the rest of the
final page table) as soon as it hits the configured limit.

This patch is intended as a debugging aid.  If it goes into the
kernel, it should go in at the very beginning of a review cycle, as it
may very well expose real failures (without Jeremy's patch to fix the
accounting, it *will* crash.)

Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
index 3fa7f93..db6735a 100644
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -131,15 +131,27 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
 	addl $4,%edx
 	movl $1024, %ecx
+	/*
+	 * End condition: we must map up to and including
+	 * INIT_MAP_BEYOND_END bytes beyond the end of our
+	 * own page tables; 0x1000 is the size of the page
+	 * table were about to write, and +0x007 is the
+	 * attribute bits.
+	 */
+	leal (INIT_MAP_BEYOND_END+0x1000+0x007)(%edi),%ebp
 11:
 	stosl
 	addl $0x1000,%eax
-	loop 11b
-	/* End condition: we must map up to and including INIT_MAP_BEYOND_END */
-	/* bytes beyond the end of our own page tables; the +0x007 is the attribute bits */
-	leal (INIT_MAP_BEYOND_END+0x007)(%edi),%ebp
 	cmpl %ebp,%eax
-	jb 10b
+	jae 12f
+	loop 11b
+	jmp 10b
+12:
+	/* Clear the remainder of the last page table */
+	decl %ecx
+	xorl %eax,%eax
+	rep; stosl
+	
 	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
 
 	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
