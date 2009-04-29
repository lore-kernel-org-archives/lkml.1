Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbZD2WcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbZD2WcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759444AbZD2WVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:35 -0400
Received: from kroah.org ([198.145.64.141]:40500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759265AbZD2WVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:27 2009
Message-Id: <20090429220927.416887820@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nathan Lynch <ntl@pobox.com>,
       Nigel Cunningham <nigel@tuxonice.net>,
       containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org, Matt Helsley <matthltc@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 29/58] sched: do not count frozen tasks toward load
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0060-sched-do-not-count-frozen-tasks-toward-load.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nathan Lynch <ntl@pobox.com>

upstream commit: e3c8ca8336707062f3f7cb1cd7e6b3c753baccdd

Freezing tasks via the cgroup freezer causes the load average to climb
because the freezer's current implementation puts frozen tasks in
uninterruptible sleep (D state).

Some applications which perform job-scheduling functions consult the
load average when making decisions.  If a cgroup is frozen, the load
average does not provide a useful measure of the system's utilization
to such applications.  This is especially inconvenient if the job
scheduler employs the cgroup freezer as a mechanism for preempting low
priority jobs.  Contrast this with using SIGSTOP for the same purpose:
the stopped tasks do not count toward system load.

Change task_contributes_to_load() to return false if the task is
frozen.  This results in /proc/loadavg behavior that better meets
users' expectations.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Nigel Cunningham <nigel@tuxonice.net>
Tested-by: Nigel Cunningham <nigel@tuxonice.net>
Cc: containers@lists.linux-foundation.org
Cc: linux-pm@lists.linux-foundation.org
Cc: Matt Helsley <matthltc@us.ibm.com>
LKML-Reference: <20090408194512.47a99b95@manatee.lan>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -201,7 +201,8 @@ extern unsigned long long time_sync_thre
 #define task_is_stopped_or_traced(task)	\
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
-				((task->state & TASK_UNINTERRUPTIBLE) != 0)
+				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
+				 (task->flags & PF_FROZEN) == 0)
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)


