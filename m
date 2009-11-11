Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbZKKVgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbZKKVgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbZKKVgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:36:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759239AbZKKVgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:36:52 -0500
Date: Wed, 11 Nov 2009 22:31:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ptrace: introduce user_single_step_siginfo() helper
Message-ID: <20091111213155.GA10647@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Roland.

Currently there is no way to synthesize a single-stepping trap in the
arch-independent manner. This patch adds the default helper which fills
siginfo_t, arch/ can can override it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---

 include/linux/ptrace.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- TH/include/linux/ptrace.h~1_DEFAULT_HELPER	2009-11-10 01:03:24.000000000 +0100
+++ TH/include/linux/ptrace.h	2009-11-10 21:31:25.000000000 +0100
@@ -273,6 +273,18 @@ static inline void user_enable_block_ste
 }
 #endif	/* arch_has_block_step */
 
+#ifdef ARCH_HAS_USER_SINGLE_STEP_INFO
+extern void user_single_step_siginfo(struct task_struct *tsk,
+				struct pt_regs *regs, siginfo_t *info);
+#else
+static inline void user_single_step_siginfo(struct task_struct *tsk,
+				struct pt_regs *regs, siginfo_t *info)
+{
+	memset(info, 0, sizeof(*info));
+	info->si_signo = SIGTRAP;
+}
+#endif
+
 #ifndef arch_ptrace_stop_needed
 /**
  * arch_ptrace_stop_needed - Decide whether arch_ptrace_stop() should be called

