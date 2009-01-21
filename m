Return-Path: <linux-kernel-owner+w=401wt.eu-S1763843AbZAUIsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763843AbZAUIsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932165AbZAUIqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:38084 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbZAUIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:40 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] x86: set %fs to __KERNEL_PERCPU unconditionally for x86_32
Date: Wed, 21 Jan 2009 17:46:12 +0900
Message-Id: <1232527578-1960-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Impact: cleanup

%fs is currently set to __KERNEL_DS at boot, and conditionally
switched to __KERNEL_PERCPU for secondary cpus.  Instead, initialize
GDT_ENTRY_PERCPU to the same attributes as GDT_ENTRY_KERNEL_DS and
set %fs to __KERNEL_PERCPU unconditionally.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
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
1.6.0.2

