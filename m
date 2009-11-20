Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZKTMgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZKTMgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZKTMgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:36:00 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:54320 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZKTMf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WoSgjgTS5Jron125QJF+BZYP5DsYVJDgn7IWtOGh7/IeIq7crmO5bd096N0Vte4ntx
         dA0zAHPTuN0ym/PLNN0O5a211zJ3NiZ6URUTCFMJJz71otQpgXb+e0SVHXHG0i2TFBWy
         FPUJzz1naplJazExnRezHew1OmWtAwNMqViRU=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org
Cc: Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       Wu Zhangjin <wuzhangjin@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: [PATCH v9 09/10] tracing: reserve $12(t0) for mcount-ra-address of gcc 4.5
Date: Fri, 20 Nov 2009 20:34:37 +0800
Message-Id: <76ddc2b8164e0e2f239ddd81ef1ef6a241540004.1258719323.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <16e57c64d806acc5fc3440370aa0ff97a5db7dc3.1258719323.git.wuzhangjin@gmail.com>
References: <adf867c5a6864fa196c667d3f09a6a694f3903c5.1258719323.git.wuzhangjin@gmail.com>
 <51e30436a435480f1f0dec146a82f2b250900690.1258719323.git.wuzhangjin@gmail.com>
 <267c0824194b659b46fc038ba43492df30369fec.1258719323.git.wuzhangjin@gmail.com>
 <6a25a6132d64830bbd7339fe8b3841a51d02ac6d.1258719323.git.wuzhangjin@gmail.com>
 <2ffd3ecb5f0c96b43150968ce270dee71f6afdb8.1258719323.git.wuzhangjin@gmail.com>
 <2276758e661b2b2362432851003df1d7c99d6cc0.1258719323.git.wuzhangjin@gmail.com>
 <c08257b0ef370f6e04ff9719bf7499bae28c70f4.1258719323.git.wuzhangjin@gmail.com>
 <16e57c64d806acc5fc3440370aa0ff97a5db7dc3.1258719323.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258719323.git.wuzhangjin@gmail.com>
References: <cover.1258719323.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

A new option -mmcount-ra-address for gcc 4.5 have been sent by David
Daney <ddaney@caviumnetworks.com> in the thread "MIPS: Add option to
pass return address location to _mcount", which help to record the
location of the return address(ra) for the function graph tracer of MIPS
to hijack the return address easier and safer. that option used the
$12(t0) register by default, so, we reserve it for it, and use t1,t2,t3
instead of t0,t1,t2.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/kernel/mcount.S |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index bdfef2c..522e91c 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -65,8 +65,8 @@ NESTED(ftrace_caller, PT_SIZE, ra)
 _mcount:
 	b	ftrace_stub
 	 nop
-	lw	t0, function_trace_stop
-	bnez	t0, ftrace_stub
+	lw	t1, function_trace_stop
+	bnez	t1, ftrace_stub
 	 nop
 
 	MCOUNT_SAVE_REGS
@@ -93,21 +93,21 @@ ftrace_stub:
 #else	/* ! CONFIG_DYNAMIC_FTRACE */
 
 NESTED(_mcount, PT_SIZE, ra)
-	lw	t0, function_trace_stop
-	bnez	t0, ftrace_stub
+	lw	t1, function_trace_stop
+	bnez	t1, ftrace_stub
 	 nop
-	PTR_LA	t0, ftrace_stub
-	PTR_L	t1, ftrace_trace_function /* Prepare t1 for (1) */
-	bne	t0, t1, static_trace
+	PTR_LA	t1, ftrace_stub
+	PTR_L	t2, ftrace_trace_function /* Prepare t2 for (1) */
+	bne	t1, t2, static_trace
 	 nop
 
 #ifdef	CONFIG_FUNCTION_GRAPH_TRACER
-	PTR_L	t2, ftrace_graph_return
-	bne	t0, t2, ftrace_graph_caller
+	PTR_L	t3, ftrace_graph_return
+	bne	t1, t3, ftrace_graph_caller
 	 nop
-	PTR_LA	t0, ftrace_graph_entry_stub
-	PTR_L	t2, ftrace_graph_entry
-	bne	t0, t2, ftrace_graph_caller
+	PTR_LA	t1, ftrace_graph_entry_stub
+	PTR_L	t3, ftrace_graph_entry
+	bne	t1, t3, ftrace_graph_caller
 	 nop
 #endif
 	b	ftrace_stub
@@ -117,7 +117,7 @@ static_trace:
 	MCOUNT_SAVE_REGS
 
 	move	a0, ra		/* arg1: next ip, selfaddr */
-	jalr	t1	/* (1) call *ftrace_trace_function */
+	jalr	t2		/* (1) call *ftrace_trace_function */
 	 move	a1, AT		/* arg2: the caller's next ip, parent */
 
 	MCOUNT_RESTORE_REGS
-- 
1.6.2.1

