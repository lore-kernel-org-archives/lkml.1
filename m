Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbZKXUJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbZKXUJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932794AbZKXUJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:09:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829AbZKXUHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:07:04 -0500
Date: Tue, 24 Nov 2009 21:01:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: [RFC,PATCH 03/14] ptrace: introduce user_single_step_siginfo()
	helper
Message-ID: <20091124200138.GA5764@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(already in mm: ptrace-introduce-user_single_step_siginfo-helper.patch)

Suggested by Roland.

Currently there is no way to synthesize a single-stepping trap in the
arch-independent manner. This patch adds the default helper which fills
siginfo_t, arch/ can can override it.

Architetures which implement user_enable_single_step() should add
user_single_step_siginfo() also.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---

 include/linux/ptrace.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- V1/include/linux/ptrace.h~3_DEFAULT_HELPER	2009-11-24 19:50:39.000000000 +0100
+++ V1/include/linux/ptrace.h	2009-11-24 19:51:28.000000000 +0100
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

