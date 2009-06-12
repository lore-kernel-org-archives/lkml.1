Return-Path: <linux-kernel-owner+w=401wt.eu-S1764717AbZFLNGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764717AbZFLNGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762815AbZFLNAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:00:11 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:32484 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763150AbZFLNAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:00:09 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j)
X-FB-SS: 5,13,
X-WSS-ID: 0KL4MQQ-03-HWD-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 23/23] x86/oprofile: introduce oprofile_add_data64()
Date: Fri, 12 Jun 2009 14:35:40 +0200
Message-ID: <1244810140-20595-24-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:09.0311 (UTC) FILETIME=[935580F0:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IBS implemention writes 64 bit register values to the cpu buffer
by writing two 32 values using oprofile_add_data(). This patch
introduces oprofile_add_data64() to write a single 64 bit value to the
buffer.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   27 +++++++++------------------
 drivers/oprofile/cpu_buffer.c    |   15 +++++++++++++++
 include/linux/oprofile.h         |    1 +
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 6493ef7..cc93046 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -140,13 +140,10 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 			rdmsrl(MSR_AMD64_IBSFETCHLINAD, val);
 			oprofile_write_reserve(&entry, regs, val,
 					       IBS_FETCH_CODE, IBS_FETCH_SIZE);
-			oprofile_add_data(&entry, (u32)val);
-			oprofile_add_data(&entry, (u32)(val >> 32));
-			oprofile_add_data(&entry, (u32)ctl);
-			oprofile_add_data(&entry, (u32)(ctl >> 32));
+			oprofile_add_data64(&entry, val);
+			oprofile_add_data64(&entry, ctl);
 			rdmsrl(MSR_AMD64_IBSFETCHPHYSAD, val);
-			oprofile_add_data(&entry, (u32)val);
-			oprofile_add_data(&entry, (u32)(val >> 32));
+			oprofile_add_data64(&entry, val);
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
@@ -162,23 +159,17 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 			rdmsrl(MSR_AMD64_IBSOPRIP, val);
 			oprofile_write_reserve(&entry, regs, val,
 					       IBS_OP_CODE, IBS_OP_SIZE);
-			oprofile_add_data(&entry, (u32)val);
-			oprofile_add_data(&entry, (u32)(val >> 32));
+			oprofile_add_data64(&entry, val);
 			rdmsrl(MSR_AMD64_IBSOPDATA, val);
-			oprofile_add_data(&entry, (u32)val);
-			oprofile_add_data(&entry, (u32)(val >> 32));
+			oprofile_add_data64(&entry, val);
 			rdmsrl(MSR_AMD64_IBSOPDATA2, val);
-			oprofile_add_data(&entry, (u32)val);
-			oprofile_add_data(&entry, (u32)(val >> 32));
+			oprofile_add_data64(&entry, val);
 			rdmsrl(MSR_AMD64_IBSOPDATA3, val);
-			oprofile_add_data(&entry, (u32)val);
-			oprofile_add_data(&entry, (u32)(val >> 32));
+			oprofile_add_data64(&entry, val);
 			rdmsrl(MSR_AMD64_IBSDCLINAD, val);
-			oprofile_add_data(&entry, (u32)val);
-			oprofile_add_data(&entry, (u32)(val >> 32));
+			oprofile_add_data64(&entry, val);
 			rdmsrl(MSR_AMD64_IBSDCPHYSAD, val);
-			oprofile_add_data(&entry, (u32)val);
-			oprofile_add_data(&entry, (u32)(val >> 32));
+			oprofile_add_data64(&entry, val);
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 50640cc..a7aae24 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -406,6 +406,21 @@ int oprofile_add_data(struct op_entry *entry, unsigned long val)
 	return op_cpu_buffer_add_data(entry, val);
 }
 
+int oprofile_add_data64(struct op_entry *entry, u64 val)
+{
+	if (!entry->event)
+		return 0;
+	if (op_cpu_buffer_get_size(entry) < 2)
+		/*
+		 * the function returns 0 to indicate a too small
+		 * buffer, even if there is some space left
+		 */
+		return 0;
+	if (!op_cpu_buffer_add_data(entry, (u32)val))
+		return 0;
+	return op_cpu_buffer_add_data(entry, (u32)(val >> 32));
+}
+
 int oprofile_write_commit(struct op_entry *entry)
 {
 	if (!entry->event)
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index dbbe2db..d68d2ed 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -179,6 +179,7 @@ void oprofile_write_reserve(struct op_entry *entry,
 			    struct pt_regs * const regs,
 			    unsigned long pc, int code, int size);
 int oprofile_add_data(struct op_entry *entry, unsigned long val);
+int oprofile_add_data64(struct op_entry *entry, u64 val);
 int oprofile_write_commit(struct op_entry *entry);
 
 #endif /* OPROFILE_H */
-- 
1.6.3.1


