Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbZC0AMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbZC0AMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbZC0AKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:10:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44012 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbZC0AKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:10:39 -0400
Date: Fri, 27 Mar 2009 01:06:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Lojkin <ia6432@inbox.ru>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 2/2] posix-timers: fix RLIMIT_CPU &&
	setitimer(CPUCLOCK_PROF)
Message-ID: <20090327000610.GA10108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update_rlimit_cpu() tries to optimize out set_process_cpu_timer() in case
when we already have CPUCLOCK_PROF timer which should expire first. But it
uses cputime_lt() instead of cputime_gt().

Test case:

	int main(void)
	{
		struct itimerval it = {
			.it_value = { .tv_sec = 1000 },
		};

		assert(!setitimer(ITIMER_PROF, &it, NULL));

		struct rlimit rl = {
			.rlim_cur = 1,
			.rlim_max = 1,
		};

		assert(!setrlimit(RLIMIT_CPU, &rl));

		for (;;)
			;

		return 0;
	}

Without this patch, the task is not killed as RLIMIT_CPU demands.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29/kernel/posix-cpu-timers.c~2_UPDATE_RLIM	2009-03-23 18:13:57.000000000 +0100
+++ 6.29/kernel/posix-cpu-timers.c	2009-03-27 00:45:31.000000000 +0100
@@ -18,7 +18,7 @@ void update_rlimit_cpu(unsigned long rli
 
 	cputime = secs_to_cputime(rlim_new);
 	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
-	    cputime_lt(current->signal->it_prof_expires, cputime)) {
+	    cputime_gt(current->signal->it_prof_expires, cputime)) {
 		spin_lock_irq(&current->sighand->siglock);
 		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
 		spin_unlock_irq(&current->sighand->siglock);

