Return-Path: <linux-kernel-owner+w=401wt.eu-S1765688AbYCSXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765688AbYCSXAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936952AbYCSVYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:24:19 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33591 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934033AbYCSVYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:24:18 -0400
Date: Tue, 18 Mar 2008 18:38:11 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: rfc, leader_pid_type()
Message-ID: <20080318153811.GA3488@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, Pavel.

Without tasklist lock held, task_tgid/task_pgrp/task_session can return the
bogus NULL. Note that the last 2 can return NULL even if task == current.

What do you think if we add yet another helper?

	struct pid *leader_pid_type(struct task_struct *task, enum pid_type type)
	{
		struct pid *ret;
	retry:
		ret = task->group_leader->pids[type].pid;
		if (likely(ret != NULL) || !pid_alive(task))
			return ret;
		/*
		 * We hit the old leader in the middle of de_thread(),
		 * or setsid/setpgrp is in progress.
		 */
		cpu_relax();
		goto retry;
	}

Yes, we already have a lot helpers... The one potential user is
check_kill_permission(), but it can live without it.

What do you think, do you see other possible users? Say, do_task_stat() may
report sid = 0, but this is minor of course...

Oleg.	

