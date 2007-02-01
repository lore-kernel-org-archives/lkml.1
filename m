Return-Path: <linux-kernel-owner+w=401wt.eu-S1422822AbXBALsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422822AbXBALsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422825AbXBALsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:48:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60321 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422822AbXBALsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:48:04 -0500
Date: Thu, 1 Feb 2007 12:46:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: jbohac@suse.cz
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, arjan@infradead.org,
       tglx@linutronix.de, johnstul@us.ibm.com, Andrew Morton <akpm@osdl.org>
Subject: [-mm patch] x86_64 GTOD: offer scalable vgettimeofday
Message-ID: <20070201114644.GB26453@elte.hu>
References: <20070201095952.589234000@jet.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201095952.589234000@jet.suse.cz>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* jbohac@suse.cz <jbohac@suse.cz> wrote:

> Inter-CPU monotonicity can not, however, be guaranteed in a vsyscall, 
> so vsyscall is not used by default. [...]

note that this is not actually the case. My patch below, ontop of -mm, 
implements a fully monotonic gettimeofday as an optional vsyscall 
feature.

The 'price' paid for it is lower resolution - but it's still good for 
those benchmarking TPC-C runs - and /alot/ simpler. It's also quite a 
bit faster than any TSC based vgettimeofday, because it doesnt have to 
do an RDTSC (or RDTSCP) instruction nor any approximation of the time.

	Ingo

---------------------------->
Subject: [patch] x86_64 GTOD: offer scalable vgettimeofday
From: Ingo Molnar <mingo@elte.hu>

offer scalable vgettimeofday independently of whether the TSC is 
synchronous or not. Off by default. Results in low resolution 
gettimefday().

this patch also fixes an SMP bug in sys_vtime(): we should read 
__vsyscall_gtod_data.wall_time_tv.tv_sec only once.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86_64/kernel/vsyscall.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux.orig/arch/x86_64/kernel/vsyscall.c
+++ linux/arch/x86_64/kernel/vsyscall.c
@@ -107,6 +107,22 @@ static __always_inline void do_vgettimeo
 	cycle_t now, base, mask, cycle_delta;
 	unsigned long seq, mult, shift, nsec_delta;
 	cycle_t (*vread)(void);
+
+	if (likely(__vsyscall_gtod_data.sysctl_enabled == 2)) {
+		struct timeval tmp;
+
+		do {
+			barrier();
+			*tv = __vsyscall_gtod_data.wall_time_tv;
+			barrier();
+			tmp = __vsyscall_gtod_data.wall_time_tv;
+
+		} while (tmp.tv_usec != tv->tv_usec ||
+					tmp.tv_sec != tv->tv_sec);
+
+		return;
+	}
+
 	do {
 		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
 
@@ -151,11 +167,19 @@ int __vsyscall(0) vgettimeofday(struct t
  * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
+	time_t secs;
+
 	if (!__vsyscall_gtod_data.sysctl_enabled)
 		return time_syscall(t);
-	else if (t)
-		*t = __vsyscall_gtod_data.wall_time_tv.tv_sec;
-	return __vsyscall_gtod_data.wall_time_tv.tv_sec;
+
+	/*
+	 * Make sure that what we return is the same number we
+	 * write:
+	 */
+	secs = __vsyscall_gtod_data.wall_time_tv.tv_sec;
+	if (t)
+		*t = secs;
+	return secs;
 }
 
 /* Fast way to get current CPU and node.
