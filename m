Return-Path: <linux-kernel-owner+w=401wt.eu-S933513AbZINUIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbZINUIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbZINUIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54027 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089AbZINUI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 16/72] Blackfin: convert ptrace to new memory functions
Date: Mon, 14 Sep 2009 16:07:20 -0400
Message-Id: <1252958896-25150-17-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a Blackfin memory function to figure out how to properly
access the different regions, drop the custom memory range checks in our
ptrace code and use that.  It makes the code nicer and fixes bugs where
the ptrace logic wasn't handling all the different regions.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ptrace.c |  129 +++++++++++++++++++++++------------------
 1 files changed, 72 insertions(+), 57 deletions(-)

diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 6a387ee..271d7c6 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -206,6 +206,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
+	void *paddr = (void *)addr;
 
 	switch (request) {
 		/* when I and D space are separate, these will need to be fixed. */
@@ -215,42 +216,49 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_PEEKTEXT:	/* read word at location addr. */
 		{
 			unsigned long tmp = 0;
-			int copied;
+			int copied = 0, to_copy = sizeof(tmp);
 
 			ret = -EIO;
-			pr_debug("ptrace: PEEKTEXT at addr 0x%08lx + %ld\n", addr, sizeof(data));
-			if (is_user_addr_valid(child, addr, sizeof(tmp)) < 0)
+			pr_debug("ptrace: PEEKTEXT at addr 0x%08lx + %i\n", addr, to_copy);
+			if (is_user_addr_valid(child, addr, to_copy) < 0)
 				break;
 			pr_debug("ptrace: user address is valid\n");
 
-			if (L1_CODE_LENGTH != 0 && addr >= get_l1_code_start()
-			    && addr + sizeof(tmp) <= get_l1_code_start() + L1_CODE_LENGTH) {
-				safe_dma_memcpy (&tmp, (const void *)(addr), sizeof(tmp));
-				copied = sizeof(tmp);
-
-			} else if (L1_DATA_A_LENGTH != 0 && addr >= L1_DATA_A_START
-			    && addr + sizeof(tmp) <= L1_DATA_A_START + L1_DATA_A_LENGTH) {
-				memcpy(&tmp, (const void *)(addr), sizeof(tmp));
-				copied = sizeof(tmp);
-
-			} else if (L1_DATA_B_LENGTH != 0 && addr >= L1_DATA_B_START
-			    && addr + sizeof(tmp) <= L1_DATA_B_START + L1_DATA_B_LENGTH) {
-				memcpy(&tmp, (const void *)(addr), sizeof(tmp));
-				copied = sizeof(tmp);
-
-			} else if (addr >= FIXED_CODE_START
-			    && addr + sizeof(tmp) <= FIXED_CODE_END) {
-				copy_from_user_page(0, 0, 0, &tmp, (const void *)(addr), sizeof(tmp));
-				copied = sizeof(tmp);
-
-			} else
+			switch (bfin_mem_access_type(addr, to_copy)) {
+			case BFIN_MEM_ACCESS_CORE:
+			case BFIN_MEM_ACCESS_CORE_ONLY:
 				copied = access_process_vm(child, addr, &tmp,
-							   sizeof(tmp), 0);
+				                           to_copy, 0);
+				if (copied)
+					break;
+
+				/* hrm, why didn't that work ... maybe no mapping */
+				if (addr >= FIXED_CODE_START &&
+				    addr + to_copy <= FIXED_CODE_END) {
+					copy_from_user_page(0, 0, 0, &tmp, paddr, to_copy);
+					copied = to_copy;
+				} else if (addr >= BOOT_ROM_START) {
+					memcpy(&tmp, paddr, to_copy);
+					copied = to_copy;
+				}
 
-			pr_debug("ptrace: copied size %d [0x%08lx]\n", copied, tmp);
-			if (copied != sizeof(tmp))
 				break;
-			ret = put_user(tmp, datap);
+			case BFIN_MEM_ACCESS_DMA:
+				if (safe_dma_memcpy(&tmp, paddr, to_copy))
+					copied = to_copy;
+				break;
+			case BFIN_MEM_ACCESS_ITEST:
+				if (isram_memcpy(&tmp, paddr, to_copy))
+					copied = to_copy;
+				break;
+			default:
+				copied = 0;
+				break;
+			}
+
+			pr_debug("ptrace: copied size %d [0x%08lx]\n", copied, tmp);
+			if (copied == to_copy)
+				ret = put_user(tmp, datap);
 			break;
 		}
 
@@ -294,43 +302,50 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		/* fall through */
 	case PTRACE_POKETEXT:	/* write the word at location addr. */
 		{
-			int copied;
+			int copied = 0, to_copy = sizeof(data);
 
 			ret = -EIO;
-			pr_debug("ptrace: POKETEXT at addr 0x%08lx + %ld bytes %lx\n",
-			         addr, sizeof(data), data);
-			if (is_user_addr_valid(child, addr, sizeof(data)) < 0)
+			pr_debug("ptrace: POKETEXT at addr 0x%08lx + %i bytes %lx\n",
+			         addr, to_copy, data);
+			if (is_user_addr_valid(child, addr, to_copy) < 0)
 				break;
 			pr_debug("ptrace: user address is valid\n");
 
-			if (L1_CODE_LENGTH != 0 && addr >= get_l1_code_start()
-			    && addr + sizeof(data) <= get_l1_code_start() + L1_CODE_LENGTH) {
-				safe_dma_memcpy ((void *)(addr), &data, sizeof(data));
-				copied = sizeof(data);
-
-			} else if (L1_DATA_A_LENGTH != 0 && addr >= L1_DATA_A_START
-			    && addr + sizeof(data) <= L1_DATA_A_START + L1_DATA_A_LENGTH) {
-				memcpy((void *)(addr), &data, sizeof(data));
-				copied = sizeof(data);
-
-			} else if (L1_DATA_B_LENGTH != 0 && addr >= L1_DATA_B_START
-			    && addr + sizeof(data) <= L1_DATA_B_START + L1_DATA_B_LENGTH) {
-				memcpy((void *)(addr), &data, sizeof(data));
-				copied = sizeof(data);
-
-			} else if (addr >= FIXED_CODE_START
-			    && addr + sizeof(data) <= FIXED_CODE_END) {
-				copy_to_user_page(0, 0, 0, (void *)(addr), &data, sizeof(data));
-				copied = sizeof(data);
-
-			} else
+			switch (bfin_mem_access_type(addr, to_copy)) {
+			case BFIN_MEM_ACCESS_CORE:
+			case BFIN_MEM_ACCESS_CORE_ONLY:
 				copied = access_process_vm(child, addr, &data,
-							   sizeof(data), 1);
+				                           to_copy, 0);
+				if (copied)
+					break;
+
+				/* hrm, why didn't that work ... maybe no mapping */
+				if (addr >= FIXED_CODE_START &&
+				    addr + to_copy <= FIXED_CODE_END) {
+					copy_to_user_page(0, 0, 0, paddr, &data, to_copy);
+					copied = to_copy;
+				} else if (addr >= BOOT_ROM_START) {
+					memcpy(paddr, &data, to_copy);
+					copied = to_copy;
+				}
 
-			pr_debug("ptrace: copied size %d\n", copied);
-			if (copied != sizeof(data))
 				break;
-			ret = 0;
+			case BFIN_MEM_ACCESS_DMA:
+				if (safe_dma_memcpy(paddr, &data, to_copy))
+					copied = to_copy;
+				break;
+			case BFIN_MEM_ACCESS_ITEST:
+				if (isram_memcpy(paddr, &data, to_copy))
+					copied = to_copy;
+				break;
+			default:
+				copied = 0;
+				break;
+			}
+
+			pr_debug("ptrace: copied size %d\n", copied);
+			if (copied == to_copy)
+				ret = 0;
 			break;
 		}
 
-- 
1.6.4.2

