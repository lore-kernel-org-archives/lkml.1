Return-Path: <linux-kernel-owner+w=401wt.eu-S1763224AbZAGW6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763224AbZAGW6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZAGW57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:57:59 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:3599 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751AbZAGW56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:57:58 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KD4IG5-02-ZH4-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/9] oprofile: add op_cpu_buffer_add_data()
Date: Wed, 7 Jan 2009 23:45:20 +0100
Message-ID: <1231368325-19246-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0476 (UTC) FILETIME=[5B30F2C0:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used to attach data to a sample. It returns the
remaining free buffer size that has been reserved with
op_cpu_buffer_write_reserve().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |    2 +-
 drivers/oprofile/cpu_buffer.h |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index e859d23..1b65907 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -258,7 +258,7 @@ op_add_code(struct oprofile_cpu_buffer *cpu_buf, unsigned long backtrace,
 	sample->event = flags;
 
 	if (size)
-		sample->data[0] = (unsigned long)task;
+		op_cpu_buffer_add_data(&entry, (unsigned long)task);
 
 	op_cpu_buffer_write_commit(&entry);
 
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index e634dcf..e178dd2 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -78,6 +78,18 @@ int op_cpu_buffer_write_commit(struct op_entry *entry);
 struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu);
 unsigned long op_cpu_buffer_entries(int cpu);
 
+/* returns the remaining free size of data in the entry */
+static inline
+int op_cpu_buffer_add_data(struct op_entry *entry, unsigned long val)
+{
+	if (!entry->size)
+		return 0;
+	*entry->data = val;
+	entry->size--;
+	entry->data++;
+	return entry->size;
+}
+
 /* extra data flags */
 #define KERNEL_CTX_SWITCH	(1UL << 0)
 #define IS_KERNEL		(1UL << 1)
-- 
1.6.0.1


