Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYLIW6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYLIW6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYLIW6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:58:46 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:47131 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYLIW6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:58:45 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 17:58:44 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=sAYtdt9AbPDOD8UBUnoCgZy89Tg16dS3UU+ZsbE5jpSUnOIAQRWyNOz+PY+xZ59L0u
         LqBe5mG/7tRBK1mABJ5CbsvRAFv1b99mCLAzcKR7oqCKWubHACsg4QWjpgqkgy5OBj0/
         QPXUYdnrjsEwVDHGfgOPBhHNvkqvqbz8RKSf8=
Message-ID: <493EF6DC.10207@gmail.com>
Date: Tue, 09 Dec 2008 23:53:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/function-graph-tracer: add a new .irqentry.text
 section
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Let the function-graph-tracer aware of the irq entrypoints

Add a new .irqentry.text section to store the irq entrypoints functions
inside the same section. This way, the tracer will be able to signal
an interrupts triggering on output by recognizing these entrypoints.

Also, make this section recordable for dynamic tracing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/vmlinux_64.lds.S  |    1 +
 include/asm-generic/vmlinux.lds.h |   10 ++++++++++
 scripts/recordmcount.pl           |    1 +
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 46e0544..1a614c0 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -35,6 +35,7 @@ SECTIONS
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
+	IRQENTRY_TEXT
 	*(.fixup)
 	*(.gnu.warning)
 	_etext = .;		/* End of text section */
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 30536c3..acb72d8 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -288,6 +288,16 @@
 		*(.kprobes.text)					\
 		VMLINUX_SYMBOL(__kprobes_text_end) = .;
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+#define IRQENTRY_TEXT							\
+		ALIGN_FUNCTION();					\
+		VMLINUX_SYMBOL(__irqentry_text_start) = .;		\
+		*(.irqentry.text)					\
+		VMLINUX_SYMBOL(__irqentry_text_end) = .;
+#else
+#define IRQENTRY_TEXT
+#endif
+
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(.head.text)
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 0b1dc9f..fe83141 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -114,6 +114,7 @@ my %text_sections = (
      ".text" => 1,
      ".sched.text" => 1,
      ".spinlock.text" => 1,
+     ".irqentry.text" => 1,
 );
 
 $objdump = "objdump" if ((length $objdump) == 0);
-- 
1.6.0.4

