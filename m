Return-Path: <linux-kernel-owner+w=401wt.eu-S1765123AbZAQQXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765123AbZAQQXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763658AbZAQQX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:23:28 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:24031 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763378AbZAQQX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:23:27 -0500
X-BigFish: VPS-6(zz936eQzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KDMIUC-04-0JB-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] oprofile: fix uninitialized use of struct op_entry
Date: Sat, 17 Jan 2009 17:13:27 +0100
Message-ID: <1232208807-26699-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1
X-OriginalArrivalTime: 17 Jan 2009 16:23:03.0835 (UTC) FILETIME=[DF5E36B0:01C978BF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of losing samples struct op_entry could have been used
uninitialized causing e.g. a wrong preemtion count or NULL pointer
access. This patch fixes this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |    5 +++++
 drivers/oprofile/cpu_buffer.h |    7 +++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 2e03b6d..e76d715 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -393,16 +393,21 @@ oprofile_write_reserve(struct op_entry *entry, struct pt_regs * const regs,
 	return;
 
 fail:
+	entry->event = NULL;
 	cpu_buf->sample_lost_overflow++;
 }
 
 int oprofile_add_data(struct op_entry *entry, unsigned long val)
 {
+	if (!entry->event)
+		return 0;
 	return op_cpu_buffer_add_data(entry, val);
 }
 
 int oprofile_write_commit(struct op_entry *entry)
 {
+	if (!entry->event)
+		return -EINVAL;
 	return op_cpu_buffer_write_commit(entry);
 }
 
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 63f81c4..272995d 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -66,6 +66,13 @@ static inline void op_cpu_buffer_reset(int cpu)
 	cpu_buf->last_task = NULL;
 }
 
+/*
+ * op_cpu_buffer_add_data() and op_cpu_buffer_write_commit() may be
+ * called only if op_cpu_buffer_write_reserve() did not return NULL or
+ * entry->event != NULL, otherwise entry->size or entry->event will be
+ * used uninitialized.
+ */
+
 struct op_sample
 *op_cpu_buffer_write_reserve(struct op_entry *entry, unsigned long size);
 int op_cpu_buffer_write_commit(struct op_entry *entry);
-- 
1.6.1


