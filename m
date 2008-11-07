Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYKGSi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYKGSi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYKGSiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:38:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:44239 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYKGSiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:38:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=qOFqTMjuD/svEr8OotmhDrNy24SLBu/7GtA9wkrk3BuR+ky7U5CElDGhC/PyyOPrf
	vEKHj/8MgMdKBdVg7RFoQ==
MIME-Version: 1.0
In-Reply-To: <20081107083249.GD4435@elte.hu>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com>
	 <20081107004824.GA28780@x200.localdomain>
	 <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu>
	 <20081107082003.GA15800@x200.localdomain>
	 <20081107083249.GD4435@elte.hu>
Date: Fri, 7 Nov 2008 10:38:04 -0800
Message-ID: <b040c32a0811071038g5e6faba6n55b22e52e1d2ea98@mail.gmail.com>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 12:32 AM, Ingo Molnar <mingo@elte.hu> wrote:
> oh well - Ken, could you please switch it to seqfiles?

On Fri, Nov 7, 2008 at 12:49 AM, Alexey Dobriyan wrote:
> Or you can do all of this in ->show(), without start/next/stop:
>
>        for (i = 0; i < N; i++)
>                seq_printf(m, "[<%p>] %pS\n", x, x);

Here is a patch convert to seq_file using proc_single_show() helper.
I don't see it to be any superior than what was before using
snprintf().  seq_read also allocate one page for printf buffer, so
functionally it is the same (perhaps a little bit better because it
can use the whole page, compare to PROC_BLOCK_SIZE currently).  Ingo,
it's your call whether to merge this patch or not.

I also agree that using full blown seqfile start/show/stop won't add
value because most valuable stack at the top are already printed.


Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 805e514..6d294a4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -351,11 +351,12 @@ static int proc_pid_wchan

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
@@ -375,15 +376,12 @@ static int proc_pid_stack
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

@@ -2537,7 +2535,7 @@ static const struct pid_entry tgid_base_stuff[]
 	INF("wchan",      S_IRUGO, pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	INF("stack",      S_IRUSR, pid_stack),
+	ONE("stack",      S_IRUSR, pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, pid_schedstat),
