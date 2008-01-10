Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbYAJApk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbYAJApk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYAJApG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:45:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:20788 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbYAJApC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:45:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PjiNiXldDff4b0+wtffaOTSVbGVXQTrtZ3ycHWD3xPrbUYMlI+NDMttuJj4t52Lvs+AHEjoMO6wB+K0OOcLs/wEvp9Bkz8a069C5xxAdA3MvxWDBrjt4nP678GwpoKmTaOK6sn+rE2d7kVLIjiQyhGX7jSew1JzwT0l1FIVL/gQ=
Subject: [PATCH 2/2] kprobe: remove preempt_enable/disable from
	kprobe_handle_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       David Wilder <dwilder@us.ibm.com>, jkenisto@us.ibm.com
In-Reply-To: <20080109231620.GA9002@osiris.ibm.com>
References: <1199737486.7666.12.camel@brick>
	 <18307.64807.204087.375733@cargo.ozlabs.ibm.com>
	 <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick>
	 <20080109061408.GA9486@osiris.ibm.com> <1199859742.6424.44.camel@brick>
	 <1199916062.6424.60.camel@brick>  <20080109231620.GA9002@osiris.ibm.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 16:45:00 -0800
Message-Id: <1199925900.6424.86.camel@brick>
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
index c01e320..e61607a 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -204,19 +204,16 @@ static inline struct kprobe *kprobe_running(void)
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
1.5.4.rc2.1164.g6451

