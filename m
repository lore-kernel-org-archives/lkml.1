Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZLaCwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZLaCwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZLaCwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:52:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:56203 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZLaCw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ja5jsw+E7ATVg95d1WV4u1IpdWoOq0rEgRNP7ZYfPYHk+bCulRt/atZy63kMtjOqj0
         RtI+maRQee7w9Fs6JRIZBUNXHOtP0by1xlB9PDkQjg3TNO3dTVIMXsQ1E6MyCrLv5p0r
         JJHTQ30OAmFpgo/MU/kFCYZ0FgOALem4ZyWcg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Stop stack frame walking off kernel addresses boundaries
Date: Thu, 31 Dec 2009 03:52:25 +0100
Message-Id: <1262227945-27014-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While processing kernel perf callchains, an bad entry can be
considered as a valid stack pointer but not as a kernel address.

In this case, we hang in an endless loop. This can happen in an
x86-32 kernel after processing the last entry in a kernel
stacktrace.

Just stop the stack frame walking after we encounter an invalid
kernel address.

This fixes a hard lockup in x86-32.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/x86/kernel/dumpstack.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c56bc28..6d81755 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -123,13 +123,15 @@ print_context_stack_bp(struct thread_info *tinfo,
 	while (valid_stack_ptr(tinfo, ret_addr, sizeof(*ret_addr), end)) {
 		unsigned long addr = *ret_addr;
 
-		if (__kernel_text_address(addr)) {
-			ops->address(data, addr, 1);
-			frame = frame->next_frame;
-			ret_addr = &frame->return_address;
-			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
-		}
+		if (!__kernel_text_address(addr))
+			break;
+
+		ops->address(data, addr, 1);
+		frame = frame->next_frame;
+		ret_addr = &frame->return_address;
+		print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 	}
+
 	return (unsigned long)frame;
 }
 EXPORT_SYMBOL_GPL(print_context_stack_bp);
-- 
1.6.2.3

