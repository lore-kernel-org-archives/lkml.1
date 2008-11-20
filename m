Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYKTRBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYKTRBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYKTRBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:01:32 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:3507 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbYKTRBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:01:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vTl/OQsnqBULctCOSR2J+J2juqb8Aaaobw3B3Osczx7qRNpga96ooDH+I4FVHSBAoR
         CHJAZQm3MM3OBYogILH9/RamUq9vhVCLi5BBCYmJ2iWnpVxgVtTILQ+JhpBfiGTUcrEe
         Ty7M1mHXKutoN7QaMDns/xN5RbY3ppcjGrwAI=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix arch/x86/kernel/cpu/mtrr/main.c build warning
Date: Thu, 20 Nov 2008 11:03:21 -0700
Message-Id: <1227204203-32112-1-git-send-email-aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix
arch/x86/kernel/cpu/mtrr/main.c: In function 'mtrr_bp_init':
arch/x86/kernel/cpu/mtrr/main.c:1364: warning: 'gran_base' may be used uninitialized in this function

gran_base is only used within the if (debug_print) sections of the for loop, so combine both sections
and move the declaration to within if (debug_print). The overhead of to_size_factor may be a consideration
but the compiler should be able to optimize out the multiple calls.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index c091d06..b751e3a 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1360,20 +1360,16 @@ static int __init mtrr_cleanup(unsigned address_bits)
 	memset(min_loss_pfn, 0xff, sizeof(min_loss_pfn));
 	memset(result, 0, sizeof(result));
 	for (gran_size = (1ULL<<16); gran_size < (1ULL<<32); gran_size <<= 1) {
-		char gran_factor;
-		unsigned long gran_base;
-
-		if (debug_print)
-			gran_base = to_size_factor(gran_size >> 10, &gran_factor);
 
 		for (chunk_size = gran_size; chunk_size < (1ULL<<32);
 		     chunk_size <<= 1) {
 			int num_reg;
 
 			if (debug_print) {
-				char chunk_factor;
-				unsigned long chunk_base;
+				char gran_factor, chunk_factor;
+				unsigned long gran_base, chunk_base;
 
+				gran_base = to_size_factor(gran_size >> 10, &gran_factor);
 				chunk_base = to_size_factor(chunk_size>>10, &chunk_factor),
 				printk(KERN_INFO "\n");
 				printk(KERN_INFO "gran_size: %ld%c   chunk_size: %ld%c \n",
-- 
1.5.6.4

