Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbYKHMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbYKHMLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYKHMLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:11:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39582 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYKHMLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:11:07 -0500
Date: Sat, 8 Nov 2008 13:10:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081108121054.GG8354@elte.hu>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <b040c32a0811071038g5e6faba6n55b22e52e1d2ea98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811071038g5e6faba6n55b22e52e1d2ea98@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> On Fri, Nov 7, 2008 at 12:32 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > oh well - Ken, could you please switch it to seqfiles?
> 
> On Fri, Nov 7, 2008 at 12:49 AM, Alexey Dobriyan wrote:
> > Or you can do all of this in ->show(), without start/next/stop:
> >
> >        for (i = 0; i < N; i++)
> >                seq_printf(m, "[<%p>] %pS\n", x, x);
> 
> Here is a patch convert to seq_file using proc_single_show() helper. 
> I don't see it to be any superior than what was before using 
> snprintf().  seq_read also allocate one page for printf buffer, so 
> functionally it is the same (perhaps a little bit better because it 
> can use the whole page, compare to PROC_BLOCK_SIZE currently).  
> Ingo, it's your call whether to merge this patch or not.
> 
> I also agree that using full blown seqfile start/show/stop won't add 
> value because most valuable stack at the top are already printed.

Well, it removes 2 lines of code and makes the iteration slightly more 
resilient (as there's no 'ret' value to be maintained anymore), so 
i've applied your patch to tip/core/stacktrace - thanks Ken! (see the 
commit below)

Sidenote: it would still be nice if the procfs folks converted the 
old-style code there to the new seqfile APIs, before requiring 
everyone _else_ to follow those guidelines?

	Ingo

----------------->
>From 35f0b5fd7fab907a1119eaa614d9b24e5e225755 Mon Sep 17 00:00:00 2001
From: Ken Chen <kenchen@google.com>
Date: Fri, 7 Nov 2008 10:38:04 -0800
Subject: [PATCH] stacktrace: convert /proc/<pid>/stack to seqfiles

Here is a patch convert to seq_file using proc_single_show() helper.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/base.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 805e514..6d294a4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -351,11 +351,12 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 
 #define MAX_STACK_TRACE_DEPTH	64
 
-static int proc_pid_stack(struct task_struct *task, char *buffer)
+static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
+			  struct pid *pid, struct task_struct *task)
 {
 	struct stack_trace trace;
 	unsigned long *entries;
-	int i, len = 0;
+	int i;
 
 	entries = kmalloc(sizeof(*entries)*MAX_STACK_TRACE_DEPTH, GFP_KERNEL);
 	if (!entries)
@@ -375,15 +376,12 @@ static int proc_pid_stack(struct task_struct *task, char *buffer)
 	read_unlock(&tasklist_lock);
 
 	for (i = 0; i < trace.nr_entries; i++) {
-		len += snprintf(buffer + len, PROC_BLOCK_SIZE - len,
-				"[<%p>] %pS\n",
-				(void *)entries[i], (void *)entries[i]);
-		if (!len)
-			break;
+		seq_printf(m, "[<%p>] %pS\n",
+			   (void *)entries[i], (void *)entries[i]);
 	}
 	kfree(entries);
 
-	return len;
+	return 0;
 }
 #endif
 
@@ -2537,7 +2535,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("wchan",      S_IRUGO, pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	INF("stack",      S_IRUSR, pid_stack),
+	ONE("stack",      S_IRUSR, pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, pid_schedstat),
