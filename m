Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZFRWxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZFRWxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbZFRWws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:52:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59166 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbZFRWwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:52:47 -0400
Message-Id: <20090618225248.476090968@goodmis.org>
References: <20090618224409.916725341@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 18 Jun 2009 18:44:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] function-graph: disable when both x86_32 and optimize for size are configured
Content-Disposition: inline; filename=0001-function-graph-disable-when-both-x86_32-and-optimize.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

On x86_32, when optimize for size is set, gcc may align the frame pointer
and make a copy of the the return address inside the stack frame.
The return address that is located in the stack frame may not be
the one used to return to the calling function. This will break the
function graph tracer.

The function graph tracer replaces the return address with a jump to a hook
function that can trace the exit of the function. If it only replaces
a copy, then the hook will not be called when the function returns.
Worse yet, when the parent function returns, the function graph tracer
will return back to the location of the child function which will
easily crash the kernel with weird results.

To see the problem, when i386 is compiled with -Os we get:

c106be03:       57                      push   %edi
c106be04:       8d 7c 24 08             lea    0x8(%esp),%edi
c106be08:       83 e4 e0                and    $0xffffffe0,%esp
c106be0b:       ff 77 fc                pushl  0xfffffffc(%edi)
c106be0e:       55                      push   %ebp
c106be0f:       89 e5                   mov    %esp,%ebp
c106be11:       57                      push   %edi
c106be12:       56                      push   %esi
c106be13:       53                      push   %ebx
c106be14:       81 ec 8c 00 00 00       sub    $0x8c,%esp
c106be1a:       e8 f5 57 fb ff          call   c1021614 <mcount>

When it is compiled with -O2 instead we get:

c10896f0:       55                      push   %ebp
c10896f1:       89 e5                   mov    %esp,%ebp
c10896f3:       83 ec 28                sub    $0x28,%esp
c10896f6:       89 5d f4                mov    %ebx,0xfffffff4(%ebp)
c10896f9:       89 75 f8                mov    %esi,0xfffffff8(%ebp)
c10896fc:       89 7d fc                mov    %edi,0xfffffffc(%ebp)
c10896ff:       e8 d0 08 fa ff          call   c1029fd4 <mcount>

The compile with -Os will align the stack pointer then set up the
frame pointer (%ebp), and it copies the return address back into
the stack frame. The change to the return address in mcount is done
to the copy and not the real place holder of the return address.

Then compile with -O2 sets up the frame pointer first, this makes
the change to the return address by mcount affect where the function
will jump on exit.

Reported-by: Jake Edge <jake@lwn.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 4a13e5a..1eac852 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -121,6 +121,7 @@ config FUNCTION_GRAPH_TRACER
 	bool "Kernel Function Graph Tracer"
 	depends on HAVE_FUNCTION_GRAPH_TRACER
 	depends on FUNCTION_TRACER
+	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
 	default y
 	help
 	  Enable the kernel to trace a function at both its return
-- 
1.6.3.1

-- 
