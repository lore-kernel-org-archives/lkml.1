Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZIVTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZIVTik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZIVTii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:38:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:6632 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZIVTig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TkxRPEPUYEqg/uM5uYysr2C7UzEY6u9m5G9ddRL/0d4aiRySvUpEsjSx9Z8afldL1S
         MPO3qxa7t8O34EaPKwWrYOPpaoYd0Nnk5+r2KXfRZ3JCBXqP1EU8lX/VNW52zD7H5eYG
         C4Z6Sp3JFLFP1mo0G+9raLEZt7bBTJzB6BBFA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/24] kprobes/x86-64: Fix to move common_interrupt to .kprobes.text
Date: Tue, 22 Sep 2009 21:38:03 +0200
Message-Id: <1253648302-5771-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Since nmi, debug and int3 returns to irq_return inside common_interrupt,
probing this function will cause int3-loop, so it should be marked
as __kprobes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090827172325.8246.40000.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/entry_64.S |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c251be7..36e2ef5 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -809,6 +809,10 @@ END(interrupt)
 	call \func
 	.endm
 
+/*
+ * Interrupt entry/exit should be protected against kprobes
+ */
+	.pushsection .kprobes.text, "ax"
 	/*
 	 * The interrupt stubs push (~vector+0x80) onto the stack and
 	 * then jump to common_interrupt.
@@ -947,6 +951,10 @@ ENTRY(retint_kernel)
 
 	CFI_ENDPROC
 END(common_interrupt)
+/*
+ * End of kprobes section
+ */
+       .popsection
 
 /*
  * APIC interrupts.
-- 
1.6.2.3

