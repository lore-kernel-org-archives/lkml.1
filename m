Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZGHMDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZGHMDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbZGHMDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:03:05 -0400
Received: from ru.mvista.com ([213.79.90.228]:45985 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753087AbZGHMDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:03:04 -0400
Date: Wed, 8 Jul 2009 16:03:02 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
 cond_resched*()
Message-ID: <20090708120302.GA6341@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
 <20090708005000.GA12380@redhat.com>
 <1247034263.9777.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1247034263.9777.24.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 08:24:23AM +0200, Peter Zijlstra wrote:
> On Wed, 2009-07-08 at 02:50 +0200, Oleg Nesterov wrote:
> 
> > 	/*
> > 	 * It is valid to assume CPU-locality during early bootup:
> > 	 */
> > 	if (system_state != SYSTEM_RUNNING)
> > 		goto out;
> > 
> > this doesn't look right, smp_init() is called before we set
> > SYSTEM_RUNNING.
> 
> The thing is, there's also ton's of code that might end up calling
> cond_resched() and co before the scheduler is fully initialized.

Hm. Speaking of cond_resched*() only, then it should be pretty
safe to convert the SYSTEM_RUNNING checks to scheduler_running,
no? scheduler_running is set after sched_init().

Something like this

diff --git a/kernel/sched.c b/kernel/sched.c
index 7c9098d..555360b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6561,7 +6561,7 @@ static void __cond_resched(void)
 int __sched _cond_resched(void)
 {
 	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE) &&
-					system_state == SYSTEM_RUNNING) {
+					scheduler_running) {
 		__cond_resched();
 		return 1;
 	}
@@ -6579,7 +6579,7 @@ EXPORT_SYMBOL(_cond_resched);
  */
 int cond_resched_lock(spinlock_t *lock)
 {
-	int resched = need_resched() && system_state == SYSTEM_RUNNING;
+	int resched = need_resched() && scheduler_running;
 	int ret = 0;
 
 	if (spin_needbreak(lock) || resched) {
@@ -6599,7 +6599,7 @@ int __sched cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
-	if (need_resched() && system_state == SYSTEM_RUNNING) {
+	if (need_resched() && scheduler_running) {
 		local_bh_enable();
 		__cond_resched();
 		local_bh_disable();
