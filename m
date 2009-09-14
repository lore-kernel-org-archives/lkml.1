Return-Path: <linux-kernel-owner+w=401wt.eu-S933821AbZINUUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbZINUUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932550AbZINUT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:19:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54056 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933502AbZINUIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 26/72] Blackfin: add support for common FDPIC ptrace requests
Date: Mon, 14 Sep 2009 16:07:30 -0400
Message-Id: <1252958896-25150-27-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FDPIC arches support a standard set of ptrace requests so rather than
define our own custom API, hook up those requests for common code to
leverage.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ptrace.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 271d7c6..30f4828 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -285,9 +285,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				tmp = child->mm->start_data;
 #ifdef CONFIG_BINFMT_ELF_FDPIC
 			} else if (addr == (sizeof(struct pt_regs) + 12)) {
-				tmp = child->mm->context.exec_fdpic_loadmap;
+				goto case_PTRACE_GETFDPIC_EXEC;
 			} else if (addr == (sizeof(struct pt_regs) + 16)) {
-				tmp = child->mm->context.interp_fdpic_loadmap;
+				goto case_PTRACE_GETFDPIC_INTERP;
 #endif
 			} else {
 				tmp = get_reg(child, addr);
@@ -296,6 +296,28 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 		}
 
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	case PTRACE_GETFDPIC: {
+		unsigned long tmp = 0;
+
+		switch (addr) {
+		case_PTRACE_GETFDPIC_EXEC:
+		case PTRACE_GETFDPIC_EXEC:
+			tmp = child->mm->context.exec_fdpic_loadmap;
+			break;
+		case_PTRACE_GETFDPIC_INTERP:
+		case PTRACE_GETFDPIC_INTERP:
+			tmp = child->mm->context.interp_fdpic_loadmap;
+			break;
+		default:
+			break;
+		}
+
+		ret = put_user(tmp, datap);
+		break;
+	}
+#endif
+
 		/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKEDATA:
 		pr_debug("ptrace: PTRACE_PEEKDATA\n");
-- 
1.6.4.2

