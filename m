Return-Path: <linux-kernel-owner+w=401wt.eu-S1030331AbXAYQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030331AbXAYQcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030330AbXAYQcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:32:31 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44278 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030324AbXAYQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:32:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Cedric Le Goater <clg@fr.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Daniel Hokka Zakrisson <daniel@hozac.com>, herbert@13thfloor.at,
       akpm@osdl.org, trond.myklebust@fys.uio.no,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] namespaces: fix race at task exit
References: <20070125150542.GA27472@sergelap.austin.ibm.com>
Date: Thu, 25 Jan 2007 09:29:13 -0700
In-Reply-To: <20070125150542.GA27472@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Thu, 25 Jan 2007 09:05:42 -0600")
Message-ID: <m14pqfysrq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> In do_exit(), the exit_task_namespaces() was placed after
> exit_notify() because exit_notify ends up using the pid
> namespace both to access the reaper, and for detaching the
> pid.  However, this placement allows an nfs server to reap
> the task before exit_task_namespaces() completes.
>
> This patch moves the exit_task_namespaces() into release_task,
> below release_thread() which puts the pids(), and just above
> the call_rcu(delayed_put_task_struct).  I believe this should
> solve both problems.


For the pid namespace this seems to be correct placement.
For the mount namespace this would seem to exacerbate the problem
because it now gets called after the task has been reaped!

I'd love to be convinced otherwise but I do not believe we
can safely exit both the mount and the pid namespace at the
same location in the code.

The NFS unmount currently wants a killable thread as it
uses interruptible sleeps.  How does starting that process
after the process in which it lives aid this?

But thanks for remembering this.  This is a real problem we
do need to solve.

Eric
