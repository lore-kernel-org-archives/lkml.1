Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXKSJbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXKSJbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbXKSJbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:31:10 -0500
Received: from sacred.ru ([62.205.161.221]:37104 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbXKSJbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:31:09 -0500
Message-ID: <474157A7.1060504@openvz.org>
Date: Mon, 19 Nov 2007 12:30:15 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_task_stat: don't use task_pid_nr_ns() lockless
References: <20071117183109.GA2605@tv-sign.ru> <m1fxz4ws2z.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1fxz4ws2z.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 19 Nov 2007 12:30:50 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
>> Without rcu/tasklist/siglock lock task_pid_nr_ns() may read the freed memory,
>> move the callsite under ->siglock.
>>
>> Sadly, we can report pid == 0 if the task was detached.
> 
> We only get detached in release_task so it is a pretty small window
> where we can return pid == 0.  Usually get_task_pid will fail first
> and we will return -ESRCH.  Still the distance from open to 
> 
> There is another bug in here as well.  current->nsproxy->pid_ns is wrong.
> What we want is: ns = dentry->d_sb->s_fs_info;

Actually I thought about this recently - if we produce the list
of tasks based on the sb's namespace, then we should fill the
tasks' files according to the sb's namespace as well, not according
to the current namespace.

> Otherwise we will have file descriptor passing races and the like.

Can you elaborate?

> We could also do: proc_pid(inode) to get the pid, which is a little
> more race free, and will prevent us from returning pid == 0.
> 
> In either event it looks like we need to implement some proper
> file operations for these proc files, maybe even going to seq file
> status.
> 
> Eric
> 

