Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZEROJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZEROJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZEROJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:09:06 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:39717 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbZEROJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:09:05 -0400
Date: Mon, 18 May 2009 16:09:04 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: [GIT PULL] cputime patch for 2.6.30-rc6
Message-ID: <20090518160904.7df88425@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'cputime' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git cputime

to receive the following updates:

Michael Abbott (1):
      Fix idle time field in /proc/uptime

 fs/proc/uptime.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 0c10a0b..c0ac0d7 100644
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
