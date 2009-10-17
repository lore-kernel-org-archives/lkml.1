Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZJQJ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZJQJ6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZJQJ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:58:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:40343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZJQJ6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:58:14 -0400
Date: Sat, 17 Oct 2009 09:57:44 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090827172325.8246.40000.stgit@localhost.localdomain>
References: <20090827172325.8246.40000.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes/x86-64: Fix to move common_interrupt to .kprobes.text
Message-ID: <tip-8222d718b3ad3ae49c48f69ae4b6a1128c9a92cf@git.kernel.org>
Git-Commit-ID: 8222d718b3ad3ae49c48f69ae4b6a1128c9a92cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:57:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8222d718b3ad3ae49c48f69ae4b6a1128c9a92cf
Gitweb:     http://git.kernel.org/tip/8222d718b3ad3ae49c48f69ae4b6a1128c9a92cf
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 27 Aug 2009 13:23:25 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 30 Aug 2009 03:08:27 +0200

kprobes/x86-64: Fix to move common_interrupt to .kprobes.text

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
