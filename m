Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZKSSUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZKSSUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZKSSUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:20:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZKSSUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:20:46 -0500
Date: Thu, 19 Nov 2009 19:17:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Spencer Candland <spencer@bluehost.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
Message-ID: <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com>
References: <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258464288.7816.305.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 02:24:48PM +0100, Peter Zijlstra wrote:
> > Seems issue reported then was exactly the same as reported now by
> > you. Looks like commit 49048622eae698e5c4ae61f7e71200f265ccc529 just
> > make probability of bug smaller and you did not note it until now.  
> > 
> > Could you please test this patch, if it solve all utime decrease
> > problems for you:
> > 
> > http://patchwork.kernel.org/patch/59795/
> > 
> > If you confirm it work, I think we should apply it. Otherwise
> > we need to go to propagate task_{u,s}time everywhere, which is not
> > (my) preferred solution.
> 
> That patch will create another issue, it will allow a process to hide
> from top by arranging to never run when the tick hits.

What about that?

diff --git a/kernel/sched.c b/kernel/sched.c
index 1f8d028..9db1cbc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5194,7 +5194,7 @@ cputime_t task_utime(struct task_struct *p)
 	}
 	utime = (cputime_t)temp;
 
-	p->prev_utime = max(p->prev_utime, utime);
+	p->prev_utime = max(p->prev_utime, max(p->utime, utime));
 	return p->prev_utime;
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index ce17760..8be5b75 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -914,8 +914,8 @@ void do_sys_times(struct tms *tms)
 	struct task_cputime cputime;
 	cputime_t cutime, cstime;
 
-	thread_group_cputime(current, &cputime);
 	spin_lock_irq(&current->sighand->siglock);
+	thread_group_cputime(current, &cputime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);

It's on top of Hidetoshi patch and fix utime decrease problem 
on my system. 

Are we not doing something nasty here?

        cputime_t utime = p->utime, total = utime + p->stime;
        u64 temp;

        /*
         * Use CFS's precise accounting:
         */
        temp = (u64)nsecs_to_cputime(p->se.sum_exec_runtime);

        if (total) {
                temp *= utime;
                do_div(temp, total);
        }
	utime = (cputime_t)temp;

Stanislaw
