Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbZATNQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbZATNQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbZATNPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:15:51 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:20932 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbZATNPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:15:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ejf6XL4oZH1w4E4x5rUYnCLblyluFHn5A/WXN+PSyW6mRPycFY3XJGs7cBd1IJN0Ey
         X+nyDwPgkUgvvHuy9Pxo4hJjyJy/WHzSEMgX7Tcn2fG2GPtbjzI63985tOu7UVhsT6Cg
         dG5Q0erzeFHxJy5rvSZ4rIsFQxsT3uPN0OAsw=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 3/6] x86-32: Set %fs to __KERNEL_PERCPU unconditionally
Date: Tue, 20 Jan 2009 08:15:42 -0500
Message-Id: <1232457345-12366-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%fs is currently set to __KERNEL_DS at boot, and conditionally
switched to __KERNEL_PERCPU for secondary cpus.  Instead, initialize
GDT_ENTRY_PERCPU to the same attributes as GDT_ENTRY_KERNEL_DS and
set %fs to __KERNEL_PERCPU unconditionally.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/head_32.S    |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a8f0ded..fbebbce 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -111,7 +111,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_APMBIOS_BASE+2] = { { { 0x0000ffff, 0x00409200 } } },
 
 	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
-	[GDT_ENTRY_PERCPU] = { { { 0x00000000, 0x00000000 } } },
+	[GDT_ENTRY_PERCPU] = { { { 0x0000ffff, 0x00cf9200 } } },
 #endif
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index e835b4e..24c0e5c 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -429,12 +429,14 @@ is386:	movl $2,%ecx		# set MP
 	ljmp $(__KERNEL_CS),$1f
 1:	movl $(__KERNEL_DS),%eax	# reload all the segment registers
 	movl %eax,%ss			# after changing gdt.
-	movl %eax,%fs			# gets reset once there's real percpu
 
 	movl $(__USER_DS),%eax		# DS/ES contains default USER segment
 	movl %eax,%ds
 	movl %eax,%es
 
+	movl $(__KERNEL_PERCPU), %eax
+	movl %eax,%fs			# set this cpu's percpu
+
 	xorl %eax,%eax			# Clear GS and LDT
 	movl %eax,%gs
 	lldt %ax
@@ -446,8 +448,6 @@ is386:	movl $2,%ecx		# set MP
 	movb $1, ready
 	cmpb $0,%cl		# the first CPU calls start_kernel
 	je   1f
-	movl $(__KERNEL_PERCPU), %eax
-	movl %eax,%fs		# set this cpu's percpu
 	movl (stack_start), %esp
 1:
 #endif /* CONFIG_SMP */
-- 
1.6.1

