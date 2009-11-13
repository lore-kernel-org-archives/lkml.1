Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZKMMoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZKMMoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 07:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZKMMoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 07:44:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZKMMoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:44:09 -0500
Date: Fri, 13 Nov 2009 13:42:37 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>
Subject: [PATCH] sys_times: fix utime/stime decreasing on thread exit
Message-ID: <20091113124235.GA26815@dhcp-lab-161.englab.brq.redhat.com>
References: <4AF8FE76.406@jp.fujitsu.com> <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com> <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we have lots of exiting thread, two consecutive calls to sys_times()
can show utime/stime values decrease. This can be showed by program
provided in this thread:

http://lkml.org/lkml/2009/11/3/522

We have two bugs related with this problem, both need to be fixed to make
issue gone.

Problem 1) Races between thread_group_cputime() and __exit_signal()

When process exit in the middle of thread_group_cputime() loop, {u,s}time
values will be accounted twice. One time - in all threads loop, second - in
__exit_signal(). This make sys_times() return values bigger then they
are in real. Next consecutive call to sys_times() return correct values,
so we have {u,s}time decrease.

To fix use sighand->siglock in do_sys_times().

Problem 2) Using adjusted stime/utime values in __exit_signal()

Adjusted task_{u,s}time() functions can return smaller values then
corresponding tsk->{s,u}time. So when thread exit, thread {u/s}times
values accumulated in signal->{s,u}time can be smaller then
tsk->{u,s}times previous accounted in thread_group_cputime() loop.
Hence two consecutive sys_times() calls can show decrease.

To fix we use pure tsk->{u,s}time values in __exit_signal(). This mean
reverting:

commit 49048622eae698e5c4ae61f7e71200f265ccc529
Author: Balbir Singh <balbir@linux.vnet.ibm.com>
Date:   Fri Sep 5 18:12:23 2008 +0200

    sched: fix process time monotonicity

which is also fix for some utime/stime decreasing issues. However
I _believe_ issues which want to be fixed in this commit, was caused
by Problem 1) and this patch not make them happen again.

Patch was heavily inspired by Hidetoshi and Peter.

Reported-by: Spencer Candland <spencer@bluehost.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/exit.c |    6 +++---
 kernel/sys.c  |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index f7864ac..b0a28a5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -110,9 +110,9 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, task_utime(tsk));
-		sig->stime = cputime_add(sig->stime, task_stime(tsk));
-		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
+		sig->utime = cputime_add(sig->utime, tsk->utime);
+		sig->stime = cputime_add(sig->stime, tsk->stime);
+		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
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
-- 
1.6.2.5

