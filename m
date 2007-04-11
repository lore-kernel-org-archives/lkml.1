Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXDKT2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXDKT2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128AbXDKT2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:28:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:36705 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbXDKT2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:28:44 -0400
Date: Wed, 11 Apr 2007 23:28:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread: Don't depend on work queues (take 2)
Message-ID: <20070411192809.GA106@tv-sign.ru>
References: <20070410185133.GA104@tv-sign.ru> <m13b37v517.fsf@ebiederm.dsl.xmission.com> <20070411000316.52f2551e.akpm@linux-foundation.org> <m1hcrmsr4g.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hcrmsr4g.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Eric W. Biederman wrote:
> 
> @@ -435,8 +436,12 @@ static void __init setup_command_line(char *command_line)
>  static void noinline rest_init(void)
>  	__releases(kernel_lock)
>  {
> +	int pid;
>  	kernel_thread(init, NULL, CLONE_FS | CLONE_SIGHAND);
>  	numa_default_policy();
> +
> +	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
> +	kthreadd_task = find_task_by_pid(pid);
>  	unlock_kernel();

Just curious. What if kernel/kthread.c declares

	static struct task_struct *kthreadd_task = &init_task;

an then kthreadd_setup() does kthreadd_task = current. I assume it is always
safe to try_to_wake_up(idle_thread), because it always TASK_RUNNING. This
way we don't need to export kthreadd_task.

> +	spin_lock(&kthread_create_lock);
> +	list_add_tail(&create.list, &kthread_create_list);
> +	wake_up_process(kthreadd_task);
> +	spin_unlock(&kthread_create_lock);

Very minor nit, but we don't need to do wake_up under spin_unlock().

Oleg.

