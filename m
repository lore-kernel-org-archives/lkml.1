Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYKLVtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYKLVtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYKLVtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:49:31 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:32487 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbYKLVta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:49:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=cI74bNFH6XVht9ArT1KRXRWmY3hseAwUn/mbm+EePrFK/t8OyPXgqMysbW3+M/VxXh
         jHXlZX7V0GtxImF+JFh61ubFQ6fvAnB7VB5xqT5Y5USZreqb/mSjSoxjMjwd+wv7v5Lh
         Hz8aX+kZ7n9HUagcd3ovlajv3jmj+4CD8ZS20=
Message-ID: <491B4F63.3090909@gmail.com>
Date: Wed, 12 Nov 2008 22:49:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return
 by registers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Optimize a bit the function return tracer

This patch changes the calling convention of prepare_ftrace_return
to pass its arguments by register. This will optimize it a bit and
prepare it to support dynamic tracing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S |    5 +----
 arch/x86/kernel/ftrace.c   |    1 -
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 9a0ac85..f976211 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1217,12 +1217,9 @@ trace_return:
 	pushl %eax
 	pushl %ecx
 	pushl %edx
-	movl 0xc(%esp), %eax
-	pushl %eax
+	movl 0xc(%esp), %edx
 	lea 0x4(%ebp), %eax
-	pushl %eax
 	call prepare_ftrace_return
-	addl $8, %esp
 	popl %edx
 	popl %ecx
 	popl %eax
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1db0e12..fe83273 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -95,7 +95,6 @@ unsigned long ftrace_return_to_handler(void)
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
  */
-asmlinkage
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 {
 	unsigned long old;
-- 
1.5.2.5
