Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbZKDJcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbZKDJcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZKDJcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:32:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57239 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZKDJcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:32:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
Cc: kosaki.motohiro@jp.fujitsu.com, Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, David Rientjes <rientjes@cs.washington.edu>
In-Reply-To: <20091103222432.4a94bd8f.akpm@linux-foundation.org>
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com> <20091103222432.4a94bd8f.akpm@linux-foundation.org>
Message-Id: <20091104182238.54CB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  4 Nov 2009 18:32:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2 Nov 2009 13:29:29 -0800 Justin Mattock <justinmattock@gmail.com> wrote:
> 
> > Hello,
> > I'm not sure how to handle this,
> > while compiling firefox-3.6b1.source
> > I get this with the default compiling options,
> > as well as custom:
> > 
> > ...
> >
> > active_anon:2360492kB inactive_anon:590196kB active_file:84kB
> 
> 2.8GB of anonymous memory
> 
> > [  532.942508] Free swap  = 0kB
> > [  532.942510] Total swap = 431632kB
> 
> 430MB of swap, all used up.
> 
> That's a genuine OOM.  Something (presumably cc1plus) has consumed
> waaaay too much memory, quite possibly leaked it.
> 
> It would help if the oom-killer were to print some information about
> the oom-killed process's memory footprint.
> 


How about this?

========
Subject: [PATCH] oom: show vsz and rss information of the killed process

In typical oom anylysis scenario, we frequently want to know the killed
process has memory leak or not at first step.
This patch add vsz and rss information to oom log for helping its
analysis. It save much times of debugging guys.

example:
===================================================================
rsyslogd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
Pid: 1308, comm: rsyslogd Not tainted 2.6.32-rc6 #24
Call Trace:
[<ffffffff8132e35b>] ?_spin_unlock+0x2b/0x40
[<ffffffff810f186e>] oom_kill_process+0xbe/0x2b0

(snip)

492283 pages non-shared
Out of memory: kill process 2341 (memhog) score 527276 or a child
Killed process 2341 (memhog) vsz:1054552kB, anon-rss:970588kB, file-rss:4kB
===========================================================================
                             ^
                             |
                            here

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ea2147d..498e6f6 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -337,6 +337,8 @@ static void dump_tasks(const struct mem_cgroup *mem)
 	} while_each_thread(g, p);
 }
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
 /*
  * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
@@ -356,9 +358,16 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
 		return;
 	}
 
-	if (verbose)
-		printk(KERN_ERR "Killed process %d (%s)\n",
-				task_pid_nr(p), p->comm);
+	if (verbose) {
+		task_lock(p);
+		printk(KERN_ERR "Killed process %d (%s) "
+		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
+		       task_pid_nr(p), p->comm,
+		       K(p->mm->total_vm),
+		       K(get_mm_counter(p->mm, anon_rss)),
+		       K(get_mm_counter(p->mm, file_rss)));
+		task_unlock(p);
+	}
 
 	/*
 	 * We give our sacrificial lamb high priority and access to
-- 
1.6.2.5



