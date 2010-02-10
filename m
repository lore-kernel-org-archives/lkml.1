Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0BJULK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 15:11:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701Ab0BJULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 15:11:08 -0500
Date: Wed, 10 Feb 2010 12:10:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Veaceslav Falico <vfalico@redhat.com>
Subject: Re: [PATCH 1/1] kernel core: use helpers for rlimits fix
Message-Id: <20100210121009.a48ed15c.akpm@linux-foundation.org>
In-Reply-To: <1265831948-7873-1-git-send-email-jslaby@suse.cz>
References: <1265831948-7873-1-git-send-email-jslaby@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010 20:59:08 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> This is unmerged part of
> kernel-core-use-helpers-for-rlimits.patch
> 
> Please amend.
> 
> --
> 
> Make sure compiler won't do weird things with limits. E.g. fetching
> them twice may return 2 different values after writable limits are
> implemented.
> 
> I.e. either use rlimit helpers added in
> 3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
> or ACCESS_ONCE if not applicable.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  kernel/fork.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 11a84db..13ec487 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -828,12 +828,14 @@ void __cleanup_sighand(struct sighand_struct *sighand)
>   */
>  static void posix_cpu_timers_init_group(struct signal_struct *sig)
>  {
> +	unsigned long cpu_limit;
> +
>  	/* Thread group counters. */
>  	thread_group_cputime_init(sig);
>  
> -	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
> -		sig->cputime_expires.prof_exp =
> -			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
> +	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
> +	if (cpu_limit != RLIM_INFINITY) {
> +		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
>  		sig->cputimer.running = 1;
>  	}

problem is, this patch is all tangled up with
copy_signal-cleanup-clean-thread_group_cputime_init.patch.

I changed the above fix to be:

--- a/kernel/fork.c~kernel-core-use-helpers-for-rlimits-fix
+++ a/kernel/fork.c
@@ -827,6 +827,8 @@ void __cleanup_sighand(struct sighand_st
  */
 static void posix_cpu_timers_init_group(struct signal_struct *sig)
 {
+	unsigned long cpu_limit;
+
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
@@ -841,9 +843,9 @@ static void posix_cpu_timers_init_group(
 	sig->cputime_expires.virt_exp = cputime_zero;
 	sig->cputime_expires.sched_exp = 0;
 
-	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
-		sig->cputime_expires.prof_exp =
-			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
+	if (cpu_limit != RLIM_INFINITY) {
+		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
 		sig->cputimer.running = 1;
 	}
 
_

and mangled
copy_signal-cleanup-clean-thread_group_cputime_init.patch to suit:

From: Veaceslav Falico <vfalico@redhat.com>

Remove unneeded initializations in thread_group_cputime_init() and in
posix_cpu_timers_init_group().  They are useless after kmem_cache_zalloc()
was used in copy_signal().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 kernel/fork.c         |   11 -----------
 2 files changed, 13 deletions(-)

diff -puN include/linux/sched.h~copy_signal-cleanup-clean-thread_group_cputime_init include/linux/sched.h
--- a/include/linux/sched.h~copy_signal-cleanup-clean-thread_group_cputime_init
+++ a/include/linux/sched.h
@@ -2394,9 +2394,7 @@ void thread_group_cputimer(struct task_s
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
-	sig->cputimer.cputime = INIT_CPUTIME;
 	spin_lock_init(&sig->cputimer.lock);
-	sig->cputimer.running = 0;
 }
 
 static inline void thread_group_cputime_free(struct signal_struct *sig)
diff -puN kernel/fork.c~copy_signal-cleanup-clean-thread_group_cputime_init kernel/fork.c
--- a/kernel/fork.c~copy_signal-cleanup-clean-thread_group_cputime_init
+++ a/kernel/fork.c
@@ -833,17 +833,6 @@ static void posix_cpu_timers_init_group(
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
-	/* Expiration times and increments. */
-	sig->it[CPUCLOCK_PROF].expires = cputime_zero;
-	sig->it[CPUCLOCK_PROF].incr = cputime_zero;
-	sig->it[CPUCLOCK_VIRT].expires = cputime_zero;
-	sig->it[CPUCLOCK_VIRT].incr = cputime_zero;
-
-	/* Cached expiration times. */
-	sig->cputime_expires.prof_exp = cputime_zero;
-	sig->cputime_expires.virt_exp = cputime_zero;
-	sig->cputime_expires.sched_exp = 0;
-
 	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 	if (cpu_limit != RLIM_INFINITY) {
 		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
_

Resulting in:

static void posix_cpu_timers_init_group(struct signal_struct *sig)
{
	unsigned long cpu_limit;

	/* Thread group counters. */
	thread_group_cputime_init(sig);

	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
	if (cpu_limit != RLIM_INFINITY) {
		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
		sig->cputimer.running = 1;
	}

	/* The timer lists. */
	INIT_LIST_HEAD(&sig->cpu_timers[0]);
	INIT_LIST_HEAD(&sig->cpu_timers[1]);
	INIT_LIST_HEAD(&sig->cpu_timers[2]);
}

