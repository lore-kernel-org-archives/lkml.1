Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZFFOhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZFFOhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 10:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZFFOh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 10:37:27 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40269 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZFFOh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 10:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JiDRM3gyoAufSzKRR7KKC9zHdBCB97LmRBqjsHCjCbsAF3nC6w9mfOrgwpls+FBPRP
         c17c8PJR38sFc4Iu0VYVL0Qeg5HoqWf9AYj0t3GuZzpacx/rpSroZ1VP1E8oICS6IM1B
         NEvPNmbXrjOCQHHvB5ZWOrKKNq/x89n68/Irw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tracing/branch-tracer: PROFILE_BRANCHES_PER_CPU must depend on SMP
Date: Sat,  6 Jun 2009 16:37:23 +0200
Message-Id: <1244299043-7613-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090606073128.GA7321@elte.hu>
References: <20090606073128.GA7321@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull this fixlet, made against tip:tracing/branch-tracer.
It fixes a build failure you've reported recently.

Thanks.

The following changes since commit e482f8395f215e0ad6557b2722cd9b9b308035c4:
  Steven Rostedt (1):
        tracing/branch-profiler: add option to profile branches per cpu

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/branch-tracer

Frederic Weisbecker (1):
      tracing/branch-tracer: PROFILE_BRANCHES_PER_CPU must depend on SMP

 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---

>From cb0473e6be6f68fbf7ddc95c9c3ff7610b8598ca Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 6 Jun 2009 16:24:33 +0200
Subject: [PATCH] tracing/branch-tracer: PROFILE_BRANCHES_PER_CPU must depend on SMP
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

While enabling the per cpu branch tracing in a non SMP config,
we get the following build failure:

kernel/trace/trace_branch.c: In function ‘branch_profiler’:
kernel/trace/trace_branch.c:353: error: implicit declaration of function ‘SHIFT_PERCPU_PTR’
kernel/trace/trace_branch.c:353: error: implicit declaration of function ‘per_cpu_offset’
kernel/trace/trace_branch.c:353: error: invalid type argument of ‘->’ (have ‘int’)
kernel/trace/trace_branch.c: In function ‘calculate_stat’:
kernel/trace/trace_branch.c:364: error: invalid type argument of ‘unary *’ (have ‘int’)
kernel/trace/trace_branch.c:366: error: invalid type argument of ‘->’ (have ‘int’)
kernel/trace/trace_branch.c:367: error: invalid type argument of ‘->’ (have ‘int’)

This is because the branch tracer uses per cpu internals that are not
supported on !CONFIG_SMP case.

To fix it we just need to disable the per cpu branch tracing in
!CONFIG_SMP case.

[ Impact: fix a build failure with the branch tracer ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 309a264..0efbcc5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -285,7 +285,7 @@ endchoice
 
 config PROFILE_BRANCHES_PER_CPU
 	bool "Profile branches on a per cpu basis"
-	depends on PROFILE_ALL_BRANCHES
+	depends on PROFILE_ALL_BRANCHES && SMP
 	help
 	  When profiling all branches, the system can take a big cache line
 	  bouncing hit. On boxes with lots of CPUs, this can slow the system
-- 
1.6.2.3

