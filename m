Return-Path: <linux-kernel-owner+w=401wt.eu-S936049AbYBCDA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936049AbYBCDA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 22:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940AbYBCDAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 22:00:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:6479 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbYBCDAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 22:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qX+Q+54lTEz+H6gUC5dEcRho6sMex+XN5+nTuT/Zz1n3LQHRScjs0LKpWwE1dfxn015s6HX48hDFf93d8hu4W+K7CziXeiratZxQTSl9faTTUacBDBMtR/8Hrc4LzOhPGT2iCa2MqxJy6LShSKIPskw5o2bpdUVDgcJ1Nw9m46g=
Subject: [PATCH 2/2] kprobe: remove preempt_enable/disable from
	kprobe_handle_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 02 Feb 2008 19:00:26 -0800
Message-Id: <1202007626.1844.46.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the preempt_disable/enable pair around kprobe_running
which was originally added to avoid the assertion from smp_processor_id
which would be hit an asertion if preemption was enabled.

Kprobes can not be running if we are preemptible, so test explicitly
for preemption and bail out before hitting kprobe_running().

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/kprobes.h |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index e5ecb1e..e099426 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -213,19 +213,16 @@ static inline struct kprobe *kprobe_running(void)
 	return (__get_cpu_var(current_kprobe));
 }
 
+/*
+ * If it is a kprobe pagefault we can not be preemptible so return before
+ * calling kprobe_running() as it will assert on smp_processor_id if
+ * preemption is enabled.
+ */
 static inline int kprobe_handle_fault(struct pt_regs *regs, int trapnr)
 {
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, trapnr))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
+	if (!user_mode(regs) && !preemptible() && kprobe_running())
+		return kprobe_fault_handler(regs, trapnr);
+	return 0;
 }
 
 static inline void reset_current_kprobe(void)
-- 
1.5.4.rc4.1142.gf5a97

