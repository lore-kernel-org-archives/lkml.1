Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZIIGEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZIIGEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 02:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZIIGEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 02:04:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbZIIGEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 02:04:52 -0400
Date: Tue, 8 Sep 2009 22:58:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johan van Baarlen <JF@vanbaarlen.demon.nl>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
Message-Id: <20090908225858.04d56dce.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0908141315310.1670@venus.araneidae.co.uk>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0908141315310.1670@venus.araneidae.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009 13:18:08 +0100 (BST) Michael Abbott <michael@araneidae.co.uk> wrote:

> Reviving this:
> 
> On Sat, 9 May 2009, Jan Engelhardt wrote:
> > starting from v2.6.28-4930-g79741dd lasting thru at least v2.6.29.1,
> > the second field of /proc/uptime always shows 0.00. This happens for
> > both the typical i386 (my case) and on an ARM (according to Michael,
> > cc'ed).
> > 
> > >From the commit log of 79741dd:
> > 
> > 	"""The cpu time spent by the idle process actually doing
> > 	something is currently accounted as idle time. This is plain
> > 	wrong, the architectures that support VIRT_CPU_ACCOUNTING=y
> > 	can do better: distinguish between the time spent doing
> > 	nothing and the time spent by idle doing work. The first is
> > 	accounted with account_idle_time and the second with
> > 	account_system_time."""
> > 
> > Citing Michael from our irc conversation:
> > 
> > 	"""the writer[committer] [says] that [the] idle process time
> > 	isn't really idle time ... but that's all that /proc/uptime
> > 	looks at. I guess fs/proc/uptime.c needs to catch up."""
> > 
> > So, were the updates to uptime.c missed, or do we now live on with
> > /proc/uptime constantly having 0?
> 
> My previous patch seems to have run into the sand.  It every so nearly got 
> pulled into mainstream as far as I can tell, but didn't seem to make it; 
> no idea what happened.
> 
> So here we go again:
> 

Imagine my surprise to find a version of this patch lurking in Martin's
tree since June 22.  It's a regression fix!

Johan, does this patch help with the regression you reported in
http://bugzilla.kernel.org/show_bug.cgi?id=14131 ?

Thanks.


commit 27bf8712477db47c891e6198000c985631cd18de
Author:     Michael Abbott <michael.abbott@diamond.ac.uk>
AuthorDate: Mon Jun 22 12:19:25 2009 +0200
Commit:     Martin Schwidefsky <schwidefsky@de.ibm.com>
CommitDate: Mon Jun 22 12:20:44 2009 +0200

    [PATCH] Fix idle time field in /proc/uptime
    
    Git commit 79741dd changes idle cputime accounting, but unfortunately
    the /proc/uptime file hasn't caught up.  Here the idle time calculation
    from /proc/stat is copied over.
    
    Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 0c10a0b..766b1d4 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -4,13 +4,18 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/kernel_stat.h>
 #include <asm/cputime.h>
 
 static int uptime_proc_show(struct seq_file *m, void *v)
 {
 	struct timespec uptime;
 	struct timespec idle;
-	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
+	int i;
+	cputime_t idletime = cputime_zero;
+
+	for_each_possible_cpu(i)
+		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);

