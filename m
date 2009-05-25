Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZEYTA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZEYTA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZEYTAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:00:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49837 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZEYTAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:00:13 -0400
Date: Mon, 25 May 2009 20:55:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090525185502.GA20781@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the non-traced sub-thread calls do_notify_parent_cldstop(), we send the
notification to group_leader->real_parent and we report group_leader's pid.

But, if group_leader is traced we use the wrong ->parent->nsproxy->pid_ns,
the tracer and parent can live in different namespaces. Change the code
to use "parent" instead of tsk->parent.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/signal.c~CLDSTOP_NS	2009-05-25 20:24:50.000000000 +0200
+++ PTRACE/kernel/signal.c	2009-05-25 20:33:37.000000000 +0200
@@ -1496,7 +1496,7 @@ static void do_notify_parent_cldstop(str
 	 * see comment in do_notify_parent() abot the following 3 lines
 	 */
 	rcu_read_lock();
-	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
 	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 

