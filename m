Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbXEJRLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbXEJRLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761248AbXEJRL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:11:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761195AbXEJRLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:11:24 -0400
Date: Thu, 10 May 2007 19:10:58 +0200
From: Tomas Janousek <tjanouse@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com,
       Albert Cahalan <acahalan@gmail.com>
Subject: [PATCH] Use boot based time for uptime in /proc
Message-ID: <5189f7a1983d01ddaef747b594f39dadf655baba.1178816485.git.tomi@nomi.cz>
References: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 411187fb05cd11676b0979d9fbf3291db69dbce2 caused uptime not to increase
during suspend. This may cause confusion so I restore the old behaviour by
using the boot based time instead of monotonic for uptime.

Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
---
 fs/proc/proc_misc.c |    1 +
 kernel/timer.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 0782d34..d84956c 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -107,6 +107,7 @@ static int uptime_read_proc(char *page, char **start, off_t off,
 	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
 
 	do_posix_clock_monotonic_gettime(&uptime);
+	monotonic_to_bootbased(&uptime);
 	cputime_to_timespec(idletime, &idle);
 	len = sprintf(page,"%lu.%02lu %lu.%02lu\n",
 			(unsigned long) uptime.tv_sec,
diff --git a/kernel/timer.c b/kernel/timer.c
index d5e1d6f..3a8ba7d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1106,6 +1106,7 @@ int do_sysinfo(struct sysinfo *info)
 		getnstimeofday(&tp);
 		tp.tv_sec += wall_to_monotonic.tv_sec;
 		tp.tv_nsec += wall_to_monotonic.tv_nsec;
+		monotonic_to_bootbased(&tp);
 		if (tp.tv_nsec - NSEC_PER_SEC >= 0) {
 			tp.tv_nsec = tp.tv_nsec - NSEC_PER_SEC;
 			tp.tv_sec++;
-- 
1.5.1.4


-- 
TJ. (Brno, CZ), BaseOS, Red Hat
