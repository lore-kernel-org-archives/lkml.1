Return-Path: <linux-kernel-owner+w=401wt.eu-S1751289AbZKMMQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbZKMMQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 07:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZKMMQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 07:16:08 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:58433 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZKMMQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:16:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PnPoFPtnmJWCTG6kYuT/e3FsHdBEnL2BzguQOskIhx+dA1++Ei3YUldGx8PBsHbAXs
         S8FXhoun7u16ruOEX/njXLo7vJQOIUr/OFCFyr8518D9P6n7xGEIIP+RHVL7f+SLTOu6
         3Yihon+NUJ9Vm9nbV7n21ijqektSLpEYjYtE8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH] hw-breakpoints: Provide an off-case for counter_arch_bp()
Date: Fri, 13 Nov 2009 13:16:15 +0100
Message-Id: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an arch doesn't support the hw breakpoints, counter_arch_bp() has
no off case to cover the missing breakpoint info structure from the
perf event. The result is a build error in non-x86 configs.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/hw_breakpoint.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 7eba9b9..18710e0 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -16,11 +16,6 @@ enum {
 	HW_BREAKPOINT_X = 4,
 };
 
-static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
-{
-	return &bp->hw.info;
-}
-
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
@@ -83,6 +78,11 @@ extern void release_bp_slot(struct perf_event *bp);
 
 extern void flush_ptrace_hw_breakpoint(struct task_struct *tsk);
 
+static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
+{
+	return &bp->hw.info;
+}
+
 #else /* !CONFIG_HAVE_HW_BREAKPOINT */
 
 static inline struct perf_event *
@@ -126,6 +126,11 @@ static inline void release_bp_slot(struct perf_event *bp) 		{ }
 
 static inline void flush_ptrace_hw_breakpoint(struct task_struct *tsk)	{ }
 
+static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
 #endif /* _LINUX_HW_BREAKPOINT_H */
-- 
1.6.2.3

