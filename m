Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZKSQM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZKSQM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZKSQM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:12:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbZKSQM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:12:28 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Haley <aph@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <4B0567E0.5080803@redhat.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <4B0567E0.5080803@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 11:12:32 -0500
Message-Id: <1258647152.22249.506.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 15:44 +0000, Andrew Haley wrote:

> We're aligning the stack properly, as per the ABI requirements.  Can't
> you just fix the tracer?

Unfortunately, this is the only fix we have:

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b416512..cd39064 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -143,7 +143,6 @@ config FUNCTION_GRAPH_TRACER
 	bool "Kernel Function Graph Tracer"
 	depends on HAVE_FUNCTION_GRAPH_TRACER
 	depends on FUNCTION_TRACER
-	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
 	default y
 	help
 	  Enable the kernel to trace a function at both its return
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 45e6c01..50c2251 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1070,6 +1070,11 @@ static __init int init_graph_trace(void)
 {
 	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
 
+#if defined(CONFIG_X86_32 && __GNUC__ >= 4 && __GNUC_MINOR__ >= 4)
+	pr_info("WARNING: GCC 4.4.X breaks the function graph tracer on i686.\n"
+		"         The function graph tracer will be disabled.\n");
+	return -1;
+#endif
 	return register_tracer(&graph_trace);
 }
 
-- Steve


