Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZEKJHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZEKJHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbZEKJHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:07:17 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3684 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757155AbZEKJHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:07:15 -0400
Date: Mon, 11 May 2009 10:07:14 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Jan Engelhardt <jengelh@medozas.de>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
In-Reply-To: <Pine.LNX.4.64.0905110656180.6983@venus.araneidae.co.uk>
Message-ID: <Pine.LNX.4.64.0905111005400.13704@venus.araneidae.co.uk>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
 <20090510191229.71f43f3c@skybase> <alpine.LSU.2.00.0905110237310.17675@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0905110656180.6983@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Michael Abbott wrote:
> So as a simple solution, I've attached a patch where I just copy the 
> idle field processing from fs/proc/stat.c.  I expect that on a 
> multi-processor machine things may not be quite so simple -- as up time 
> is in elapsed wall-clock time, then so should idle time be, so we 
> probably need to also divide by the number of processors.  Afraid I 
> don't have a multiprocessor test system, and /proc/stat seems ok, so 
> I've not made this refinement.

To hopefully help, I've rebased the patch onto current git 
(fs/proc/uptime.c has undergone some unrelated changes).


Date: Mon, 11 May 2009 07:14:19 +0100
Subject: [PATCH] Fix idle time field in /proc/uptime

Git commit 79741dd changes idle cputime accounting, but unfortunately
the /proc/uptime file hasn't caught up.  Here the idle time calculation
from /proc/stat is copied over.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
 fs/proc/uptime.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 0c10a0b..0f43395 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -4,13 +4,19 @@
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
+	int len, i;
+	cputime_t idletime = 0;
+
+	for_each_possible_cpu(i) 
+		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
+	idletime = cputime64_to_clock_t(idletime);
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
-- 
1.6.1.3

