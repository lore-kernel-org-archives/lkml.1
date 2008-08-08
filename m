Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYHHAie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYHHAie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYHHAi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:38:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYHHAiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:38:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: "Eduardo Habkost <ehabkost@redhat.com>Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] tracehook: fix CLONE_PTRACE
In-Reply-To: Eduardo Habkost's message of  Thursday, 7 August 2008 19:24:34 -0300 <20080807222434.GC7957@blackpad>
References: <20080807222434.GC7957@blackpad>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080808003749.6864C15429D@magilla.localdomain>
Date: Thu,  7 Aug 2008 17:37:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 685d87f7ccc649ab92b55e18e507a65d0e694eb9:
  Linus Torvalds (1):
        Revert "pcm_native.c: remove unused label"

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git tracehook

Roland McGrath (1):
      tracehook: fix CLONE_PTRACE

 include/linux/ptrace.h    |    2 +-
 include/linux/tracehook.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Thanks,
Roland

---
[PATCH] tracehook: fix CLONE_PTRACE

In the change in commit 09a05394fe2448a4139b014936330af23fa7ec83, I
overlooked two nits in the logic and this broke using CLONE_PTRACE
when PTRACE_O_TRACE* are not being used.

A parent that is itself traced at all but not using PTRACE_O_TRACE*,
using CLONE_PTRACE would have its new child fail to be traced.

A parent that is not itself traced at all that uses CLONE_PTRACE
(which should be a no-op in this case) would confuse the bookkeeping
and lead to a crash at exit time.

This restores the missing checks and fixes both failure modes.

Reported-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/ptrace.h    |    2 +-
 include/linux/tracehook.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index fd31756..ea7416c 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -172,7 +172,7 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
 	child->ptrace = 0;
 	if (unlikely(ptrace)) {
 		child->ptrace = current->ptrace;
-		__ptrace_link(child, current->parent);
+		ptrace_link(child, current->parent);
 	}
 }
 
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index ab3ef7a..b48d819 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -280,7 +280,7 @@ static inline void tracehook_report_clone(int trace, struct pt_regs *regs,
 					  unsigned long clone_flags,
 					  pid_t pid, struct task_struct *child)
 {
-	if (unlikely(trace)) {
+	if (unlikely(trace) || unlikely(clone_flags & CLONE_PTRACE)) {
 		/*
 		 * The child starts up with an immediate SIGSTOP.
 		 */
