Return-Path: <linux-kernel-owner+w=401wt.eu-S1163372AbXD1SAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163372AbXD1SAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163360AbXD1R7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:59:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:38946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163338AbXD1R6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:55 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [7/22] x86_64: cleanup segments
Message-Id: <20070428175853.EF2B5151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:58:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


Move __KERNEL32_CS up into the unused gdt entry.  __KERNEL32_CS is
used when entering the kernel so putting it first is useful when
trying to keep boot gdt sizes to a minimum.

Set the accessed bit on all gdt entries.  We don't care
so there is no need for the cpu to burn the extra cycles,
and it potentially allows the pages to be immutable.  Plus
it is confusing when debugging and your gdt entries mysteriously
change.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/head.S    |   12 ++++++------
 include/asm-x86_64/segment.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux/arch/x86_64/kernel/head.S
===================================================================
--- linux.orig/arch/x86_64/kernel/head.S
+++ linux/arch/x86_64/kernel/head.S
@@ -362,13 +362,13 @@ gdt:
 	
 ENTRY(cpu_gdt_table)
 	.quad	0x0000000000000000	/* NULL descriptor */
+	.quad	0x00cf9b000000ffff	/* __KERNEL32_CS */
+	.quad	0x00af9b000000ffff	/* __KERNEL_CS */
+	.quad	0x00cf93000000ffff	/* __KERNEL_DS */
+	.quad	0x00cffb000000ffff	/* __USER32_CS */
+	.quad	0x00cff3000000ffff	/* __USER_DS, __USER32_DS  */
+	.quad	0x00affb000000ffff	/* __USER_CS */
 	.quad	0x0			/* unused */
-	.quad	0x00af9a000000ffff	/* __KERNEL_CS */
-	.quad	0x00cf92000000ffff	/* __KERNEL_DS */
-	.quad	0x00cffa000000ffff	/* __USER32_CS */
-	.quad	0x00cff2000000ffff	/* __USER_DS, __USER32_DS  */		
-	.quad	0x00affa000000ffff	/* __USER_CS */
-	.quad	0x00cf9a000000ffff	/* __KERNEL32_CS */
 	.quad	0,0			/* TSS */
 	.quad	0,0			/* LDT */
 	.quad   0,0,0			/* three TLS descriptors */ 
Index: linux/include/asm-x86_64/segment.h
===================================================================
--- linux.orig/include/asm-x86_64/segment.h
+++ linux/include/asm-x86_64/segment.h
@@ -6,7 +6,7 @@
 #define __KERNEL_CS	0x10
 #define __KERNEL_DS	0x18
 
-#define __KERNEL32_CS   0x38
+#define __KERNEL32_CS   0x08
 
 /* 
  * we cannot use the same code segment descriptor for user and kernel
