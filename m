Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbZDXJSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbZDXJSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZDXJS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:18:28 -0400
Received: from mx1.emlix.com ([193.175.82.87]:42506 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbZDXJS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:18:27 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Piet Delaney <pdelaney@tensilica.com>, Marc Gauthier <marc@tensilica.com>,
       Maxim Grigoriev <maxim@tensilica.com>, linux-kernel@vger.kernel.org,
       linux-xtensa@linux-xtensa.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH v2] xtensa: implement PTRACE_PEEKUSER addresses for nommu
Date: Fri, 24 Apr 2009 11:18:22 +0200
Message-Id: <1240564702-11796-1-git-send-email-dg@emlix.com>
In-Reply-To: <1237978628-23746-1-git-send-email-dg@emlix.com>
References: <1237978628-23746-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On nommu gdbserver needs to be able to look up where the currently
debugged application has been relocated. Based on the Blackfin
implementation, this introduces three "addresses" PT_TEXT_ADDR,
PT_DATA_ADDR, and PT_TEXT_END_ADDR for PTRACE_PEEKUSER.

Changes compared to v1:

- changed PT_*_ADDR constants from 0x300..0x302 to 0xF000..0xF002

The range 0x300..0x3FF has been reserved by Tensilica for TIE user
registers. 0xF000..0xFFFF is free for 3rd-party debuggers, so use
that range instead. See xtensa-libdb-macros.h for details.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/include/asm/ptrace.h |    4 ++++
 arch/xtensa/kernel/ptrace.c      |   12 ++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/include/asm/ptrace.h b/arch/xtensa/include/asm/ptrace.h
index 905e1e6..85851f4 100644
--- a/arch/xtensa/include/asm/ptrace.h
+++ b/arch/xtensa/include/asm/ptrace.h
@@ -66,6 +66,10 @@
 
 #define SYSCALL_NR	0x00ff
 
+#define PT_TEXT_ADDR	0xF000
+#define PT_DATA_ADDR	0xF001
+#define PT_TEXT_END_ADDR	0xF002
+
 /* Other PTRACE_ values defined in <linux/ptrace.h> using values 0-9,16,17,24 */
 
 #define PTRACE_GETREGS		12
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 9486882..82f3620 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -211,6 +211,18 @@ int ptrace_peekusr(struct task_struct *child, long regno, long __user *ret)
 			tmp = regs->syscall;
 			break;
 
+		case PT_TEXT_ADDR:
+			tmp = child->mm->start_code;
+			break;
+
+		case PT_DATA_ADDR:
+			tmp = child->mm->start_data;
+			break;
+
+		case PT_TEXT_END_ADDR:
+			tmp = child->mm->end_code;
+			break;
+
 		default:
 			return -EIO;
 	}
-- 
1.6.1.3

