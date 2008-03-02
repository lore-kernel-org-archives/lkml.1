Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYCBSmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYCBSmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYCBSlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:41:11 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:44220 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYCBSlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:41:07 -0500
Date: Sun, 2 Mar 2008 21:44:44 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] exit_notify: fix kill_orphaned_pgrp() usage with mt exit
Message-ID: <20080302184444.GA16371@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. exit_notify() always calls kill_orphaned_pgrp(). This is wrong, we
   should do this only when the whole process exits.

2. exit_notify() uses "current" as "ignored_task", obviously wrong.
   Use ->group_leader instead.

Test case:

	void hup(int sig)
	{
		printf("HUP received\n");
	}

	void *tfunc(void *arg)
	{
		sleep(2);
		printf("sub-thread exited\n");
		return NULL;
	}

	int main(int argc, char *argv[])
	{
		if (!fork()) {
			signal(SIGHUP, hup);
			kill(getpid(), SIGSTOP);
			exit(0);
		}

		pthread_t thr;
		pthread_create(&thr, NULL, tfunc, NULL);

		sleep(1);
		printf("main thread exited\n");
		syscall(__NR_exit, 0);

		return 0;
	}

output:

	main thread exited
	HUP received
	Hangup

With this patch the output is:

	main thread exited
	sub-thread exited
	HUP received

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/exit.c~3_OG_EXIT	2008-03-02 19:42:56.000000000 +0300
+++ 25/kernel/exit.c	2008-03-02 21:21:51.000000000 +0300
@@ -754,7 +754,7 @@ static void forget_original_parent(struc
  * Send signals to all our closest relatives so that they know
  * to properly mourn us..
  */
-static void exit_notify(struct task_struct *tsk)
+static void exit_notify(struct task_struct *tsk, int group_dead)
 {
 	int state;
 
@@ -770,7 +770,8 @@ static void exit_notify(struct task_stru
 	exit_task_namespaces(tsk);
 
 	write_lock_irq(&tasklist_lock);
-	kill_orphaned_pgrp(tsk, NULL);
+	if (group_dead)
+		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
 	/* Let father know we died
 	 *
@@ -985,7 +986,7 @@ NORET_TYPE void do_exit(long code)
 		module_put(tsk->binfmt->module);
 
 	proc_exit_connector(tsk);
-	exit_notify(tsk);
+	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
 	mpol_free(tsk->mempolicy);
 	tsk->mempolicy = NULL;

