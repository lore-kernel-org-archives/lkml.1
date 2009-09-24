Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbZIXLbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbZIXLbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZIXLbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:31:37 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:54384 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZIXLbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:31:36 -0400
Date: Thu, 24 Sep 2009 13:31:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Jan Engelhardt <jengelh@medozas.de>,
       Johan van Baarlen <jf@vanbaarlen.demon.nl>
Subject: [GIT PULL] cputime tree
Message-ID: <20090924133136.7b7c834e@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

with git commit 79741dd "idle cputime accounting" the semantic
of the stime field of the idle processes has changed. It used to
contain the amount of time the idle process has been scheduled.
Since git commit 79741dd is contains the cpu time spent in the
system by the idle process.

This change broke the output of second field of /proc/uptime. On
systems without VIRT_CPU_ACCOUNTING the field is always zero.
The legacy output of the field is the amount of time the idle
process has been scheduled on cpu #0. It is good enough to
calculate the load on an uni-processor system, it is useless
on a multi-processor. To restore the legacy behaviour and give
meaning to the multi-processor case the best we could come up
with is to add the idle time over all cpus. That fixes uni-
processors systems and gives a defined semantic on smp.

So please pull from 'cputime' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git cputime

to receive the following updates:

Michael Abbott (1):
      Fix idle time field in /proc/uptime

 fs/proc/uptime.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

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
