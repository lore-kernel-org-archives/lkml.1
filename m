Return-Path: <linux-kernel-owner+w=401wt.eu-S1764568AbZD3Rpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764568AbZD3Rpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764743AbZD3RIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:47 -0400
Received: from kroah.org ([198.145.64.141]:56968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764659AbZD3RI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:50 2009
Message-Id: <20090430165750.453705212@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:57:11 -0700
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
       alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>
Subject: [patch 82/88] fix ptrace slowness
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=fix-ptrace-slowness.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 53da1d9456fe7f87a920a78fdbdcf1225d197cb7 upstream.

This patch fixes bug #12208:

  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12208
  Subject         : uml is very slow on 2.6.28 host

This turned out to be not a scheduler regression, but an already
existing problem in ptrace being triggered by subtle scheduler
changes.

The problem is this:

 - task A is ptracing task B
 - task B stops on a trace event
 - task A is woken up and preempts task B
 - task A calls ptrace on task B, which does ptrace_check_attach()
 - this calls wait_task_inactive(), which sees that task B is still on the runq
 - task A goes to sleep for a jiffy
 - ...

Since UML does lots of the above sequences, those jiffies quickly add
up to make it slow as hell.

This patch solves this by not rescheduling in read_unlock() after
ptrace_stop() has woken up the tracer.

Thanks to Oleg Nesterov and Ingo Molnar for the feedback.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/signal.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1552,7 +1552,15 @@ static void ptrace_stop(int exit_code, i
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
+		/*
+		 * Don't want to allow preemption here, because
+		 * sys_ptrace() needs this task to be inactive.
+		 *
+		 * XXX: implement read_unlock_no_resched().
+		 */
+		preempt_disable();
 		read_unlock(&tasklist_lock);
+		preempt_enable_no_resched();
 		schedule();
 	} else {
 		/*


