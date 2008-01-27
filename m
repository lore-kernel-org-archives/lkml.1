Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbYA0JLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbYA0JLD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbYA0JKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:10:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:35168 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbYA0JKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=LbI9y1jlzcVcv68csacsVfCP4RoyjgyvBdyM9T2mn/Dgd4Rj2ioajaTftJGU2Aubfl3iylvJ1fyAg0zeHA0AAHk8++9wC1hOXnYRfTDv83NYWd2mClPWy97R3AhdKJ0Pq5jRZIIQ4m0O9nfexc9Ln3/jY26lhq5nmzxcqjh6DxI=
Message-ID: <479C4A4F.10604@gmail.com>
Date: Sun, 27 Jan 2008 14:39:35 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: jkenisto@us.ibm.com, ananth@in.ibm.com,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] x86: WARN_ON breakpoints from .kprobes.text section
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Identify breakpoints in .kprobes.text section. These certainly aren't kprobe traps. However, we make an exception for the breakpoint hardcoded into jprobe_return.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 45f2949..f3d13d0 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -961,6 +961,7 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
 {
 	struct die_args *args = data;
+	unsigned long addr = kprobe_bkpt_addr(args->regs);
 	int ret = NOTIFY_DONE;
 
 	if (args->regs && user_mode_vm(args->regs))
@@ -968,7 +969,14 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 
 	switch (val) {
 	case DIE_INT3:
-		if (kprobe_handler(args->regs))
+		if (in_kprobes_functions(addr) &&
+		    !is_jprobe_bkpt((u8 *)addr)) {
+			/* A breakpoint has made it's way to the .kprobes.text
+			 * section (excluding jprobe_return). This could be
+			 * due to an external debugger. */
+			WARN_ON(1);
+			
+		} else if (kprobe_handler(args->regs))
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
