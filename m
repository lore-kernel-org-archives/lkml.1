Return-Path: <linux-kernel-owner+w=401wt.eu-S932191AbXHUTA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbXHUTA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbXHUTAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:00:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44720 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbXHUTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:00:14 -0400
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200708211901.l7LJ1Dg2372490@sabah.engr.sgi.com>
Subject: [PATCH] Assign task_struct.exit_code before taskstats_exit()
To: linux-kernel@vger.kernel.org
Date: Tue, 21 Aug 2007 12:01:13 -0700 (PDT)
In-Reply-To: <no.id> from "jlim" at Aug 20, 2007 07:22:15 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

taskstats.ac_exitcode is assigned to task_struct.exit_code in bacct_add_tsk()
through the following kernel function calls: 

  do_exit()
    taskstats_exit()
      fill_pid()
        bacct_add_tsk()

The problem is that in do_exit(), task_struct.exit_code is set to 'code' only
after taskstats_exit() has been called.  So we need to move the assignment
before taskstats_exit().

Diff'd against: linux/kernel/git/stable/linux-2.6.22.y.git

Signed-off-by: Jonathan Lim <jlim@sgi.com>

--- a/kernel/exit.c	2007-08-20 16:37:55.000000000 -0700
+++ b/kernel/exit.c	2007-08-21 11:00:56.000000000 -0700
@@ -941,6 +941,7 @@ fastcall NORET_TYPE void do_exit(long co
 	if (unlikely(tsk->audit_context))
 		audit_free(tsk);
 
+	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
 	exit_mm(tsk);
@@ -961,7 +962,6 @@ fastcall NORET_TYPE void do_exit(long co
 	if (tsk->binfmt)
 		module_put(tsk->binfmt->module);
 
-	tsk->exit_code = code;
 	proc_exit_connector(tsk);
 	exit_task_namespaces(tsk);
 	exit_notify(tsk);
