Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbZJAXlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbZJAXlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZJAXlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:41:13 -0400
Received: from kroah.org ([198.145.64.141]:42082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbZJAXiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:22 2009
Message-Id: <20091001233322.365718536@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Abbott <michael.abbott@diamond.ac.uk>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 24/30] Fix idle time field in /proc/uptime
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=fix-idle-time-field-in-proc-uptime.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Abbott <michael.abbott@diamond.ac.uk>

commit 96830a57de1197519b62af6a4c9ceea556c18c3d upstream.

Git commit 79741dd changes idle cputime accounting, but unfortunately
the /proc/uptime file hasn't caught up.  Here the idle time calculation
from /proc/stat is copied over.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/uptime.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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


