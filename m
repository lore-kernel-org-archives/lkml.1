Return-Path: <linux-kernel-owner+w=401wt.eu-S933893AbZDHQL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbZDHQL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933643AbZDHQKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:10:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:55426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933472AbZDHQKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:10:51 -0400
Date: Wed, 8 Apr 2009 16:09:49 GMT
From: Oleg Nesterov <oleg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ia6432@inbox.ru, peterz@infradead.org, roland@redhat.com,
       tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, ia6432@inbox.ru, roland@redhat.com,
       tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu
In-Reply-To: <20090327000610.GA10108@redhat.com>
References: <20090327000610.GA10108@redhat.com>
Subject: [tip:timers/urgent] posix-timers: fix RLIMIT_CPU && setitimer(CPUCLOCK_PROF)
Message-ID: <tip-8f2e586567b1bad72dac7c3810fe9a2ef7117506@git.kernel.org>
Git-Commit-ID: 8f2e586567b1bad72dac7c3810fe9a2ef7117506
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:09:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f2e586567b1bad72dac7c3810fe9a2ef7117506
Gitweb:     http://git.kernel.org/tip/8f2e586567b1bad72dac7c3810fe9a2ef7117506
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 27 Mar 2009 01:06:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 17:51:39 +0200

posix-timers: fix RLIMIT_CPU && setitimer(CPUCLOCK_PROF)

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


---
 kernel/posix-cpu-timers.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8e5d9a6..bb53185 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -18,7 +18,7 @@ void update_rlimit_cpu(unsigned long rlim_new)
 
 	cputime = secs_to_cputime(rlim_new);
 	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
-	    cputime_lt(current->signal->it_prof_expires, cputime)) {
+	    cputime_gt(current->signal->it_prof_expires, cputime)) {
 		spin_lock_irq(&current->sighand->siglock);
 		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
 		spin_unlock_irq(&current->sighand->siglock);
