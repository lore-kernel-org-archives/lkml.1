Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZDNJlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZDNJlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZDNJjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:39:46 -0400
Received: from mx1.emlix.com ([193.175.82.87]:53026 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbZDNJjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:39:42 -0400
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 07/12] xtensa: implement PTRACE_PEEKUSER addresses for nommu
Date: Tue, 14 Apr 2009 11:41:15 +0200
Message-Id: <1239702080-14355-8-git-send-email-jw@emlix.com>
In-Reply-To: <1239702080-14355-1-git-send-email-jw@emlix.com>
References: <1239702080-14355-1-git-send-email-jw@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Glöckner <dg@emlix.com>

On nommu gdbserver needs to be able to look up where the currently
debugged application has been relocated. Based on the Blackfin
implementation, this introduces three "addresses" PT_TEXT_ADDR,
PT_DATA_ADDR, and PT_TEXT_END_ADDR for PTRACE_PEEKUSER.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/include/asm/ptrace.h |    4 ++++
 arch/xtensa/kernel/ptrace.c      |   12 ++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/include/asm/ptrace.h b/arch/xtensa/include/asm/ptrace.h
index 905e1e6..8f4fbf3 100644
--- a/arch/xtensa/include/asm/ptrace.h
+++ b/arch/xtensa/include/asm/ptrace.h
@@ -66,6 +66,10 @@
 
 #define SYSCALL_NR	0x00ff
 
+#define PT_TEXT_ADDR	0x0300
+#define PT_DATA_ADDR	0x0301
+#define PT_TEXT_END_ADDR	0x0302
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
1.6.2.107.ge47ee

