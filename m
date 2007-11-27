Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbXK0MI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbXK0MI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXK0MIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:08:49 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63928 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753714AbXK0MIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:08:48 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hirokazu Takata <takata@linux-m32r.org>,
       Roland McGrath <roland@redhat.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] ptrace: Call arch_ptrace_attach() when request=PTRACE_TRACEME
Date: Tue, 27 Nov 2007 13:08:11 +0100
Message-Id: <1196165291-1468-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arch_ptrace_attach() is a hook that allows the architecture to do
book-keeping after a ptrace attach. This patch adds a call to this
hook when handling a PTRACE_TRACEME request as well.

Currently only one architecture, m32r, implements this hook. When
called, it initializes a number of debug trap slots in the ptraced
task's thread struct, and it looks to me like this is the right thing
to do after a PTRACE_TRACEME request as well, not only after
PTRACE_ATTACH. Please correct me if I'm wrong.

I want to use this hook on AVR32 to turn the debugging hardware on
when a process is actually being debugged and keep it off otherwise.
To be able to do this, I need to intercept PTRACE_TRACEME and
PTRACE_ATTACH, as well as PTRACE_DETACH and thread exit. The latter
two can be handled by existing hooks.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 kernel/ptrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 7c76f2f..44e18a8 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -470,6 +470,8 @@ asmlinkage long sys_ptrace(long request, long pid, long addr, long data)
 	lock_kernel();
 	if (request == PTRACE_TRACEME) {
 		ret = ptrace_traceme();
+		if (!ret)
+			arch_ptrace_attach(current);
 		goto out;
 	}
 
-- 
1.5.3.4

