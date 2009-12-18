Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZLRBRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZLRBRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZLRBRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:17:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZLRBRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:17:36 -0500
Date: Fri, 18 Dec 2009 02:11:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: [PATCH 2/7] tracehooks: check PT_PTRACED before reporting the
	single-step
Message-ID: <20091218011124.GA29545@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation for utrace-ptrace.

tracehook_report_syscall_exit() and tracehook_signal_handler() assume
that only ptrace can set TIF_SINGLESTEP. Currently this is true but we
are going to change this, the stepping logic will be moved into utrace
layer.

Change this code to check PT_PTRACED, ptrace-utrace doesn't set it.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/tracehook.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- V1/include/linux/tracehook.h~2_SIGNAL_HANDLER_CK_PTRACE	2009-12-18 00:38:09.000000000 +0100
+++ V1/include/linux/tracehook.h	2009-12-18 00:45:42.000000000 +0100
@@ -134,7 +134,7 @@ static inline __must_check int tracehook
  */
 static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 {
-	if (step) {
+	if (step && (task_ptrace(current) & PT_PTRACED)) {
 		siginfo_t info;
 		user_single_step_siginfo(current, regs, &info);
 		force_sig_info(SIGTRAP, &info, current);
@@ -386,7 +386,7 @@ static inline void tracehook_signal_hand
 					    const struct k_sigaction *ka,
 					    struct pt_regs *regs, int stepping)
 {
-	if (stepping)
+	if (stepping && (task_ptrace(current) & PT_PTRACED))
 		ptrace_notify(SIGTRAP);
 }
 

