Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZGFQLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZGFQLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZGFQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:11:26 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3515 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZGFQLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:11:25 -0400
Date: Mon, 6 Jul 2009 16:48:48 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
In-Reply-To: <20090525122820.044e1e35@skybase>
Message-ID: <Pine.LNX.4.64.0907031206420.27250@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905181421300.1088@venus.araneidae.co.uk>
 <20090525122820.044e1e35@skybase>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like I dropped the ball on this.  Didn't realise the patch would 
just evaporate...

On Mon, 25 May 2009, Martin Schwidefsky wrote:
> On Mon, 18 May 2009 14:23:03 +0100 (BST)
> Michael Abbott <michael@araneidae.co.uk> wrote:
> 
> > diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
> > index 0c10a0b..0f43395 100644
> > --- a/fs/proc/uptime.c
> > +++ b/fs/proc/uptime.c
> > @@ -4,13 +4,19 @@
> >  #include <linux/sched.h>
> >  #include <linux/seq_file.h>
> >  #include <linux/time.h>
> > +#include <linux/kernel_stat.h>
> >  #include <asm/cputime.h>
> > 
> >  static int uptime_proc_show(struct seq_file *m, void *v)
> >  {
> >  	struct timespec uptime;
> >  	struct timespec idle;
> > -	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
> > +	int len, i;
> > +	cputime_t idletime = 0;
> > +
> > +	for_each_possible_cpu(i) 
> > +		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
> > +	idletime = cputime64_to_clock_t(idletime);
> > 
> >  	do_posix_clock_monotonic_gettime(&uptime);
> >  	monotonic_to_bootbased(&uptime);
> 
> I found another problem with this patch: why do you convert the
> idletime from cputime_t to clock_t ? The call to cputime_to_timespec
> takes a cputime_t and the conversion from cputime to clock_t returns a
> value that is way to small on s390. After removing that line it works
> for me but I wonder why you added it.

I've tidied up the patch a trifle, the idle time processing is now very 
nearly an exactly copy of that in fs/proc/stat.c.  

Unfortunately this now begs more questions:

1. Why is idle time processing so different from up time, in particular 
why am I still allowing uptime to overflow in a year and four months or 
so?  

Answer: I'm trying to just fix idle time, and the uptime calculation looks 
like a can of worms to me.

2. Is this really the right calculation of idle time, in particular what 
about multiple CPUs?

Answer: I don't have a multi-process test system, so I'm not qualified to 
investigate.  My view is that idle time should match uptime, ie should be 
in literal elapsed machine time (so should really be divided by the number 
of CPUs here), but it's clear that doing this properly is not 
straighforward.

As for whether it is "safe" to compute idle time this way, this code is 
just a copy of what is done in fs/proc/stat.c, so worry about that first!


It's rather a shame that /proc/uptime idle time reporting has been busted 
now for what will be three kernel releases in a row.


>From b885468d04475522486e7004de5dba29df1a28a8 Mon Sep 17 00:00:00 2001
From: Michael Abbott <michael.abbott@diamond.ac.uk>
Date: Mon, 11 May 2009 07:14:19 +0100
Subject: [PATCH] Fix idle time field in /proc/uptime

Git commit 79741dd changes idle cputime accounting, but unfortunately
the /proc/uptime file hasn't caught up.  Here the idle time calculation
from /proc/stat is copied over.  Further changes from commit e1c8053
are also included in this fix.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
 fs/proc/uptime.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 0c10a0b..2d573f7 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -4,22 +4,34 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/kernel_stat.h>
 #include <asm/cputime.h>
+#include <asm/div64.h>
+
+#ifndef arch_idle_time
+#define arch_idle_time(cpu) 0
+#endif
 
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
+		idle = cputime64_add(idle, arch_idle_time(i));
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
 
-- 
1.6.1.3

