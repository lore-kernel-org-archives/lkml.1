Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZCWTjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZCWTjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCWTjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:39:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36454 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZCWTjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:39:04 -0400
Date: Mon, 23 Mar 2009 20:34:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Lojkin <ia6432@inbox.ru>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Peter Zijlstra <peterz@infradead.org>, rjw@sisk.pl,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH, for 2.6.29] BUG 12911: fix RLIMIT_CPU && fork()
Message-ID: <20090323193411.GA17514@redhat.com>
References: <20090322201436.GA12838@redhat.com> <E1LlVpr-0000Rv-00.ia6432-inbox-ru@f62.mail.ru> <20090322231111.GA21775@redhat.com> <20090323164341.GA1304@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323164341.GA1304@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See http://bugzilla.kernel.org/show_bug.cgi?id=12911

copy_signal() copies signal->rlim, but RLIMIT_CPU is "lost". Because
posix_cpu_timers_init_group() sets cputime_expires.prof_exp = 0 and thus
fastpath_timer_check() returns false unless we have other cpu timers.

This is the minimal fix for 2.6.29 (tested) and 2.6.28. The patch is not
optimal, we need further cleanups here. With this patch update_rlimit_cpu()
is not really needed, but I don't think it should be removed.

The proper fix (I think) is:

	- set_process_cpu_timer() should just start the cputimer->running
	  logic (it does), no need to change cputime_expires.xxx_exp

	- posix_cpu_timers_init_group() should set ->running when needed

	- fastpath_timer_check() can check ->running instead of
	  task_cputime_zero(signal->cputime_expires)

Reported-by: Peter Lojkin <ia6432@inbox.ru>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1370,7 +1370,8 @@ static inline int fastpath_timer_check(s
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
-	return 0;
+
+	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
 }
 
 /*

