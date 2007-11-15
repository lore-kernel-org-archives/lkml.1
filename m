Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbXKOGOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbXKOGOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758685AbXKOGK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:10:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36558 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbXKOGKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:10:55 -0500
Date: Wed, 14 Nov 2007 22:09:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Frans Pop <elendil@planet.nl>
Subject: [patch 10/13] sched: keep utime/stime monotonic
Message-ID: <20071115060948.GK7602@kroah.com>
References: <20071115042610.731859958@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-keep-utime-stime-monotonic.patch"
In-Reply-To: <20071115060544.GA7602@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Frans Pop <elendil@planet.nl>

sched: keep utime/stime monotonic

cpustats use utime/stime as a ratio against sum_exec_runtime, as a
consequence it can happen - when the ratio changes faster than time
accumulates - that either can be appear to go backwards.

Combined backport for 2.6.23 of the following patches from mainline:
commit 73a2bcb0edb9ffb0b007b3546b430e2c6e415eee
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
  sched: keep utime/stime monotonic

commit 9301899be75b464ef097f0b5af7af6d9bd8f68a7
Author: Balbir Singh <balbir@linux.vnet.ibm.com>
  sched: fix /proc/<PID>/stat stime/utime monotonicity, part 2

Signed-off-by: Frans Pop <elendil@planet.nl>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/array.c       |    6 ++++--
 include/linux/sched.h |    1 +
 kernel/fork.c         |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -351,7 +351,8 @@ static cputime_t task_utime(struct task_
 	}
 	utime = (clock_t)temp;
 
-	return clock_t_to_cputime(utime);
+	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
+	return p->prev_utime;
 }
 
 static cputime_t task_stime(struct task_struct *p)
@@ -366,7 +367,8 @@ static cputime_t task_stime(struct task_
 	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
 			cputime_to_clock_t(task_utime(p));
 
-	return clock_t_to_cputime(stime);
+	p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+	return p->prev_stime;
 }
 #endif
 
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1022,6 +1022,7 @@ struct task_struct {
 
 	unsigned int rt_priority;
 	cputime_t utime, stime;
+	cputime_t prev_utime, prev_stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1045,6 +1045,8 @@ static struct task_struct *copy_process(
 
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
+	p->prev_utime = cputime_zero;
+	p->prev_stime = cputime_zero;
 
 #ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */

-- 
