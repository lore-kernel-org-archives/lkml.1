Return-Path: <linux-kernel-owner+w=401wt.eu-S1757153AbXKAPC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbXKAPC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXKAPCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:02:21 -0400
Received: from sacred.ru ([62.205.161.221]:33249 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbXKAPCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:02:20 -0400
Message-ID: <4729EA74.8090602@openvz.org>
Date: Thu, 01 Nov 2007 18:02:12 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>
In-Reply-To: <20071101144307.GA29566@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 01 Nov 2007 18:02:09 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> while checking recent commits to the kernel core i took a look at the 
> PID namespaces implementation, and it has a fatal flaw: it breaks 
> futexes and various libraries (and other stuff) that use PIDs as the 
> means of identifying tasks, by not providing any means of global 
> identification that works across PID namespaces. (PIDs _are_ a very 

You're not 100% correct here. The task_pid_nr() does return you a
unique pid, so you do have the way to identify the task.

Another thing - you should *not* allow tasks to communicate across
pid namespaces using any pids - this just breaks the pid namespaces
idea.

As far as the futexes are concerned - I do not allow threads live 
in different pid namespaces (more correct fix would be not to allow 
tasks share the mm_struct across pid namespaces, but this is a one
line fix), so the situation when you have two threads in different 
namespaces is impossible.

Thanks,
Pavel

> convenient and global way of identifying contexts.)
> 
> i asked Ulrich about this and it turns out he has warned about this 
> early on:
> 
>   http://www.nabble.com/Re%3A-question%3A-pid-space-semantics.-p3409990.html
> 
> but this problem is still present in the code, and it has been recently 
> committed into mainline via:
> 
>   commit 30e49c263e36341b60b735cbef5ca37912549264
>   Author: Pavel Emelyanov <xemul@openvz.org>
>   Date:   Thu Oct 18 23:40:10 2007 -0700
> 
>       pid namespaces: allow cloning of new namespace
> 
> without these problems having been resolved. A full-scale revert is 
> probably too intrusive, but at minimum we need to turn off user-space 
> access to this feature via this simple patch. Until this issue is 
> resolved properly the new PID namespace code needs to be turned off. 
> Letting this into 2.6.24 would be a disaster.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/fork.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: v/kernel/fork.c
> ===================================================================
> --- v.orig/kernel/fork.c
> +++ v/kernel/fork.c
> @@ -1420,6 +1420,14 @@ long do_fork(unsigned long clone_flags,
>  	int trace = 0;
>  	long nr;
>  
> +	/*
> +	 * PID namespaces are broken at the moment: they do not allow
> +	 * certain PID based syscalls (such as futexes) to be used
> +	 * across namespaces. This is broken and must not be allowed,
> +	 * so we keep this feature turned off until it's properly fixed.
> +	 */
> +	clone_flags &= ~CLONE_NEWPID;
> +
>  	if (unlikely(current->ptrace)) {
>  		trace = fork_traceflag (clone_flags);
>  		if (trace)
> 

