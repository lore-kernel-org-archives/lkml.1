Return-Path: <linux-kernel-owner+w=401wt.eu-S933087AbXBLHi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087AbXBLHi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964781AbXBLHig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106AbXBLHiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:19 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [30/39] x86_64: Check return value of putreg in PTRACE_SETREGS
Message-Id: <20070212073818.54F0913D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This means if an illegal value is set for the segment registers there
ptrace will error out now with an errno instead of silently ignoring
it.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/ptrace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/ptrace.c
===================================================================
--- linux.orig/arch/x86_64/kernel/ptrace.c
+++ linux/arch/x86_64/kernel/ptrace.c
@@ -536,8 +536,12 @@ long arch_ptrace(struct task_struct *chi
 		}
 		ret = 0;
 		for (ui = 0; ui < sizeof(struct user_regs_struct); ui += sizeof(long)) {
-			ret |= __get_user(tmp, (unsigned long __user *) data);
-			putreg(child, ui, tmp);
+			ret = __get_user(tmp, (unsigned long __user *) data);
+			if (ret)
+				break;
+			ret = putreg(child, ui, tmp);
+			if (ret)
+				break;
 			data += sizeof(long);
 		}
 		break;
