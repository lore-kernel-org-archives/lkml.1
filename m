Return-Path: <linux-kernel-owner+w=401wt.eu-S1751265AbZKJKrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbZKJKrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZKJKrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:47:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZKJKrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:47:19 -0500
Date: Tue, 10 Nov 2009 11:44:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: utime/stime decreasing on thread exit
Message-ID: <20091110104452.GB2391@dhcp-lab-161.englab.brq.redhat.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com> <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop> <20091109172020.GA7751@redhat.com> <1257787903.4108.345.camel@laptop> <20091109192355.GA13724@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109192355.GA13724@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 08:23:55PM +0100, Oleg Nesterov wrote:
> On 11/09, Peter Zijlstra wrote:
> >
> > On Mon, 2009-11-09 at 18:20 +0100, Oleg Nesterov wrote:
> >
> > > Stanislaw has already sent the patch, but I don't know what happened
> > > with this patch:
> > >
> > > 	[PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with __exit_signal()
> > > 	http://marc.info/?l=linux-kernel&m=124505545131145

I did not resubmit it enough times :) But I didn't thought it worth to,
since performance can be degraded.

> > That patch has the siglock in the function calling
> > thread_group_cputime(), the 22 code had it near the loop proper, which
> > to me seems a more sensible thing, since there could be more callers,
> > no?
> 
> Well, we can't take ->siglock in thread_group_cputime(), sometimes it
> is called under ->siglock. do_task_stat(), get_cpu_itimer() at least.
> 
> IIRC, Stanislaw verified other callers have no problems with this helper.

Actually I didn't. Try to do now. 

Most calls are done with sighand or tasklist lock taken, except 

Cscope tag: thread_group_cputime
   #   line  filename / context / line
   1   1353  fs/binfmt_elf.c <<fill_prstatus>>
             thread_group_cputime(p, &cputime);
   2   1403  fs/binfmt_elf_fdpic.c <<fill_prstatus>>
             thread_group_cputime(p, &cputime);
  10    129  mm/oom_kill.c <<badness>>
             thread_group_cputime(p, &task_time);

I do not think in case 1 and 2 lock is needed since it seems to be core dump
with all threads dead. Not sure about 10 - oom killer.

One other exception is: 
fastpath_timer_check() -> thread_group_cputimer() -> thread_group_cputime()

We can solve this like that:

--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1375,13 +1375,8 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	}
 
 	sig = tsk->signal;
-	if (!task_cputime_zero(&sig->cputime_expires)) {
-		struct task_cputime group_sample;
-
-		thread_group_cputimer(tsk, &group_sample);
-		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
-			return 1;
-	}
+	if (!task_cputime_zero(&sig->cputime_expires))
+		return 1;
 
 	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
 }

Or stay with task_cputime_expired() but only if cputimer is currently running.

Cheers
Stanislaw
