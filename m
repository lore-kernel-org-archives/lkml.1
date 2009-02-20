Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZBTQmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZBTQmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZBTQkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:40:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40894 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbZBTQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:40:48 -0500
Message-Id: <20090220164046.019184471@goodmis.org>
References: <20090220163846.709775139@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 20 Feb 2009 11:38:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] ftrace: immediately stop code modification if failure is detected
Content-Disposition: inline; filename=0003-ftrace-immediately-stop-code-modification-if-failur.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to prevent NMI lockup

If the page fault handler produces a WARN_ON in the modifying of
text, and the system is setup to have a high frequency of NMIs,
we can lock up the system on a failure to modify code.

The modifying of code with NMIs allows all NMIs to modify the code
if it is about to run. This prevents a modifier on one CPU from
modifying code running in NMI context on another CPU. The modifying
is done through stop_machine, so only NMIs must be considered.

But if the write causes the page fault handler to produce a warning,
the print can slow it down enough that as soon as it is done
it will take another NMI before going back to the process context.
The new NMI will perform the write again causing another print and
this will hang the box.

This patch turns off the writing as soon as a failure is detected
and does not wait for it to be turned off by the process context.
This will keep NMIs from getting stuck in this back and forth
of print outs.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index aa0e559..c9ba2f9 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -131,6 +131,10 @@ static void ftrace_mod_code(void)
 	 */
 	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
 					     MCOUNT_INSN_SIZE);
+
+	/* if we fail, then kill any new writers */
+	if (mod_code_status)
+		mod_code_write = 0;
 }
 
 void ftrace_nmi_enter(void)
-- 
1.5.6.5

-- 
