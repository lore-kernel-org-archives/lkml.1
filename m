Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZKWKSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZKWKSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbZKWKSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:18:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489AbZKWKSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:18:48 -0500
Date: Mon, 23 Nov 2009 11:16:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] cputime: avoid do_sys_times() races with __exit_signal()
Message-ID: <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
References: <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com> <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When process exit in the middle of thread_group_cputime() loop, {u,s}time
values will be accounted twice. One time - in all threads loop, second - in
__exit_signal(). This make sys_times() return values bigger then they
are in real. Next consecutive call to sys_times() can return correct values,
so we have {u,s}time decrease.

To fix use sighand->siglock in do_sys_times().

This is partial fix for problem of utime/stime values decreasing described
in this thread:

http://lkml.org/lkml/2009/11/3/522

To fully fix the problem, we need second fix for mishmash between
task_{u,s}time() and tsk->{u,s}time. It's not clear now how this mishmash
should be fixed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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

