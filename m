Return-Path: <linux-kernel-owner+w=401wt.eu-S1759094AbZDWHqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094AbZDWHqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbZDWHby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:31:54 -0400
Received: from sous-sol.org ([216.99.217.87]:50659 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756801AbZDWHbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:31:53 -0400
Message-Id: <20090423072708.040528468@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Peter Lojkin <ia6432@inbox.ru>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 058/100] posix-timers: fix RLIMIT_CPU && setitimer(CPUCLOCK_PROF)
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=posix-timers-fix-rlimit_cpu-setitimer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Oleg Nesterov <oleg@redhat.com>

upstream commit: 8f2e586567b1bad72dac7c3810fe9a2ef7117506

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
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Lojkin <ia6432@inbox.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: stable@kernel.org
LKML-Reference: <20090327000610.GA10108@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 kernel/posix-cpu-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -18,7 +18,7 @@ void update_rlimit_cpu(unsigned long rli
 
 	cputime = secs_to_cputime(rlim_new);
 	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
-	    cputime_lt(current->signal->it_prof_expires, cputime)) {
+	    cputime_gt(current->signal->it_prof_expires, cputime)) {
 		spin_lock_irq(&current->sighand->siglock);
 		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
 		spin_unlock_irq(&current->sighand->siglock);

