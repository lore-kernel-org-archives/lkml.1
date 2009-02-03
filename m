Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZBCTlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZBCTlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZBCTlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:41:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39454 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZBCTlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:41:42 -0500
Date: Tue, 3 Feb 2009 20:39:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: do_each_pid_task() needs rcu lock
Message-ID: <20090203193904.GA23695@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ftrace: use struct pid" commit 978f3a45d9499c7a447ca7615455cefb63d44165
converted ftrace_pid_trace to "struct pid*". But we can't use
do_each_pid_task() without rcu_read_lock() even if we know the pid
itself can't go away (it was pinned in ftrace_pid_write). The exiting
task can detach itself from this pid at any moment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/trace/ftrace.c~FTRACE_PID	2009-01-12 23:07:51.000000000 +0100
+++ 6.29-rc3/kernel/trace/ftrace.c	2009-02-03 20:23:59.000000000 +0100
@@ -1736,9 +1736,12 @@ static void clear_ftrace_pid(struct pid 
 {
 	struct task_struct *p;
 
+	rcu_read_lock();
 	do_each_pid_task(pid, PIDTYPE_PID, p) {
 		clear_tsk_trace_trace(p);
 	} while_each_pid_task(pid, PIDTYPE_PID, p);
+	rcu_read_unlock();
+
 	put_pid(pid);
 }
 
@@ -1746,9 +1749,11 @@ static void set_ftrace_pid(struct pid *p
 {
 	struct task_struct *p;
 
+	rcu_read_lock();
 	do_each_pid_task(pid, PIDTYPE_PID, p) {
 		set_tsk_trace_trace(p);
 	} while_each_pid_task(pid, PIDTYPE_PID, p);
+	rcu_read_unlock();
 }
 
 static void clear_ftrace_pid_task(struct pid **pid)

