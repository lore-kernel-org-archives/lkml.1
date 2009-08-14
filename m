Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZHNMSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZHNMSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZHNMSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:18:12 -0400
Received: from araneidae.co.uk ([62.3.233.233]:2749 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847AbZHNMSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:18:12 -0400
Date: Fri, 14 Aug 2009 13:18:08 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Jan Engelhardt <jengelh@medozas.de>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Re: /proc/uptime idle counter remains at 0
In-Reply-To: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0908141315310.1670@venus.araneidae.co.uk>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviving this:

On Sat, 9 May 2009, Jan Engelhardt wrote:
> starting from v2.6.28-4930-g79741dd lasting thru at least v2.6.29.1,
> the second field of /proc/uptime always shows 0.00. This happens for
> both the typical i386 (my case) and on an ARM (according to Michael,
> cc'ed).
> 
> >From the commit log of 79741dd:
> 
> 	"""The cpu time spent by the idle process actually doing
> 	something is currently accounted as idle time. This is plain
> 	wrong, the architectures that support VIRT_CPU_ACCOUNTING=y
> 	can do better: distinguish between the time spent doing
> 	nothing and the time spent by idle doing work. The first is
> 	accounted with account_idle_time and the second with
> 	account_system_time."""
> 
> Citing Michael from our irc conversation:
> 
> 	"""the writer[committer] [says] that [the] idle process time
> 	isn't really idle time ... but that's all that /proc/uptime
> 	looks at. I guess fs/proc/uptime.c needs to catch up."""
> 
> So, were the updates to uptime.c missed, or do we now live on with
> /proc/uptime constantly having 0?

My previous patch seems to have run into the sand.  It every so nearly got 
pulled into mainstream as far as I can tell, but didn't seem to make it; 
no idea what happened.

So here we go again:

commit 6d67e34f45a92f347388e35bd84bf0361e660d3b
Author: Michael Abbott <michael.abbott@diamond.ac.uk>
Date:   Mon May 11 07:14:19 2009 +0100

    Fix idle time field in /proc/uptime
    
    Git commit 79741dd changes idle cputime accounting, but unfortunately
    the /proc/uptime file hasn't caught up.  Here the idle time calculation
    from /proc/stat is copied over.  Further changes from commit e1c8053
    are also included in this fix.
    
    Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>

diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 0c10a0b..be286b4 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -4,22 +4,32 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/kernel_stat.h>
 #include <asm/cputime.h>
+#include <asm/div64.h>
 
 static int uptime_proc_show(struct seq_file *m, void *v)
 {
 	struct timespec uptime;
-	struct timespec idle;
-	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
+	int i;
+	cputime64_t idle = cputime64_zero;
+	unsigned long int idle_mod;
+
+	for_each_possible_cpu(i) {
+		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
+#ifdef arch_idle_time
+		idle = cputime64_add(idle, arch_idle_time(i));
+#endif
+	}
+	idle = cputime64_to_clock_t(idle);
+	idle_mod = do_div(idle, 100);
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
-	cputime_to_timespec(idletime, &idle);
-	seq_printf(m, "%lu.%02lu %lu.%02lu\n",
+	seq_printf(m, "%lu.%02lu %llu.%02lu\n",
 			(unsigned long) uptime.tv_sec,
 			(uptime.tv_nsec / (NSEC_PER_SEC / 100)),
-			(unsigned long) idle.tv_sec,
-			(idle.tv_nsec / (NSEC_PER_SEC / 100)));
+			idle, idle_mod);
 	return 0;
 }
 
