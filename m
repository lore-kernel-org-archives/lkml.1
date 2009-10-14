Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbZJNDFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbZJNDFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759648AbZJNDFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:05:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759705AbZJNDFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:05:19 -0400
Message-Id: <20091014030320.919242935@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Oct 2009 23:02:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] [PATCH 1/2] powerpc/ftrace: show real return addresses in modules
References: <20091014030225.271734317@goodmis.org>
Content-Disposition: inline; filename=0001-powerpc-ftrace-show-real-return-addresses-in-modules.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When the function graph tracer is enabled, it replaces the return address
with a hook back to the tracer. This makes back traces see the hook instead
of the actual return address.

The current code also shows the real address by checking if the return
address jumps to the return_to_handler. If it is, is also prints out
the saved real return address.

On powerpc64, some modules may return to mod_return_to_handler, which
is not checked. This patch will also show the real address if a return
is to mod_return_to_handler as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/kernel/process.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 1168c5f..2ec1eae 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1016,9 +1016,13 @@ void show_stack(struct task_struct *tsk, unsigned long *stack)
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	int curr_frame = current->curr_ret_stack;
 	extern void return_to_handler(void);
-	unsigned long addr = (unsigned long)return_to_handler;
+	unsigned long rth = (unsigned long)return_to_handler;
+	unsigned long mrth = -1;
 #ifdef CONFIG_PPC64
-	addr = *(unsigned long*)addr;
+	extern void mod_return_to_handler(void);
+	rth = *(unsigned long *)rth;
+	mrth = (unsigned long)mod_return_to_handler;
+	mrth = *(unsigned long *)mrth;
 #endif
 #endif
 
@@ -1044,7 +1048,7 @@ void show_stack(struct task_struct *tsk, unsigned long *stack)
 		if (!firstframe || ip != lr) {
 			printk("["REG"] ["REG"] %pS", sp, ip, (void *)ip);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-			if (ip == addr && curr_frame >= 0) {
+			if ((ip == rth || ip == mrth) && curr_frame >= 0) {
 				printk(" (%pS)",
 				       (void *)current->ret_stack[curr_frame].ret);
 				curr_frame--;
-- 
1.6.3.3


