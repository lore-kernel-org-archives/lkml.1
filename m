Return-Path: <linux-kernel-owner+w=401wt.eu-S1765941AbXKQUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765941AbXKQUMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 15:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761980AbXKQUML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 15:12:11 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33635 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761651AbXKQUMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 15:12:10 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_task_stat: don't use task_pid_nr_ns() lockless
References: <20071117183109.GA2605@tv-sign.ru>
Date: Sat, 17 Nov 2007 13:11:00 -0700
In-Reply-To: <20071117183109.GA2605@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 17 Nov 2007 21:31:09 +0300")
Message-ID: <m1fxz4ws2z.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Without rcu/tasklist/siglock lock task_pid_nr_ns() may read the freed memory,
> move the callsite under ->siglock.
>
> Sadly, we can report pid == 0 if the task was detached.

We only get detached in release_task so it is a pretty small window
where we can return pid == 0.  Usually get_task_pid will fail first
and we will return -ESRCH.  Still the distance from open to 

There is another bug in here as well.  current->nsproxy->pid_ns is wrong.
What we want is: ns = dentry->d_sb->s_fs_info;

Otherwise we will have file descriptor passing races and the like.

We could also do: proc_pid(inode) to get the pid, which is a little
more race free, and will prevent us from returning pid == 0.

In either event it looks like we need to implement some proper
file operations for these proc files, maybe even going to seq file
status.

Eric
