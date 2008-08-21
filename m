Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbYHUOcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbYHUOcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbYHUOb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:31:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54336 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828AbYHUObz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:31:55 -0400
Date: Thu, 21 Aug 2008 10:31:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v2] ftrace: warn on failure to disable mcount callers
In-Reply-To: <20080821084418.GJ28386@elte.hu>
Message-ID: <alpine.DEB.1.10.0808211030300.20825@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808201237210.27481@gandalf.stny.rr.com> <20080821084418.GJ28386@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Aug 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +			pr_info("WARNING: ftrace faulted on modifying ");
> > +			print_ip_sym(ip);
> 
> please use the WARN() API, so that it gets picked up by automation.
> 
> 	Ingo
> 

[
  Added WARN_ON as requested above.
]


With the recent updates to ftrace, there should not be any failures when
modifying the code. If there is, then we need to warn about it.

This patch has a cleaned up version of the code that I used to discover
that the weak symbols were causing failures. 

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-08-20 21:58:19.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-08-21 10:19:09.000000000 -0400
@@ -574,6 +574,16 @@ static void ftrace_shutdown_replenish(vo
 	ftrace_pages->next = (void *)get_zeroed_page(GFP_KERNEL);
 }
 
+static void print_ip_ins(const char *fmt, unsigned char *p)
+{
+	int i;
+
+	printk(KERN_CONT "%s", fmt);
+
+	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
+		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
+}
+
 static int
 ftrace_code_disable(struct dyn_ftrace *rec)
 {
@@ -588,6 +598,23 @@ ftrace_code_disable(struct dyn_ftrace *r
 
 	failed = ftrace_modify_code(ip, call, nop);
 	if (failed) {
+		switch (failed) {
+		case 1:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace faulted on modifying ");
+			print_ip_sym(ip);
+			break;
+		case 2:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace failed to modify ");
+			print_ip_sym(ip);
+			print_ip_ins(" expected: ", call);
+			print_ip_ins(" actual: ", (unsigned char *)ip);
+			print_ip_ins(" replace: ", nop);
+			printk(KERN_CONT "\n");
+			break;
+		}
+
 		rec->flags |= FTRACE_FL_FAILED;
 		return 0;
 	}
