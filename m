Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYJCG2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYJCG2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 02:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYJCG2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 02:28:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:28649 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYJCG2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 02:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jSlgDlMQzpyZhJeN+CmdacTgbVr/qx8H6IYIEUKCdVnkHpTp9R1/tSUBl+84Va2dgX
         J8XKgFLPS9itLe6WgoJBc+iEyIpJh2Sgbocc0psOKP7Y0r5KSFUTL+l/wE1tU3Mw0RrA
         FDF+FzRQW8IRNuEmTY7zPJJjP1lf3VB9O3Ogs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: mtrr_cleanup print out var mtrr before change it
Date: Thu,  2 Oct 2008 23:26:59 -0700
Message-Id: <1223015219-25223-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/main.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1211,13 +1211,14 @@ static unsigned long __initdata min_loss
 static int __init mtrr_cleanup(unsigned address_bits)
 {
 	unsigned long extra_remove_base, extra_remove_size;
-	unsigned long i, base, size, def, dummy;
+	unsigned long base, size, def, dummy;
 	mtrr_type type;
 	int nr_range, nr_range_new;
 	u64 chunk_size, gran_size;
 	unsigned long range_sums, range_sums_new;
 	int index_good;
 	int num_reg_good;
+	int i;
 
 	/* extra one for all 0 */
 	int num[MTRR_NUM_TYPES + 1];
@@ -1259,6 +1260,28 @@ static int __init mtrr_cleanup(unsigned
 		num_var_ranges - num[MTRR_NUM_TYPES])
 		return 0;
 
+	/* print orignal var mtrr at first */
+	printk(KERN_DEBUG "original variable MTRRs\n");
+	for (i = 0; i < num_var_ranges; i++) {
+		char start_factor = 'K', size_factor = 'K';
+		unsigned long start_base, size_base;
+
+		size_base = range_state[i].size_pfn<<(PAGE_SHIFT - 10);
+		if (!size_base)
+			continue;
+
+		size_base = to_size_factor(size_base, &size_factor),
+		start_base = range_state[i].base_pfn<<(PAGE_SHIFT - 10);
+		start_base = to_size_factor(start_base, &start_factor),
+
+		printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
+			i, start_base, start_factor,
+			size_base, size_factor,
+			(type == MTRR_TYPE_UNCACHABLE)?"UC":
+			    ((type == MTRR_TYPE_WRBACK)?"WB":"Other")
+			);
+	}
+
 	memset(range, 0, sizeof(range));
 	extra_remove_size = 0;
 	extra_remove_base = 1 << (32 - PAGE_SHIFT);
