Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYDGHAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYDGHAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 03:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYDGHAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 03:00:00 -0400
Received: from sacred.ru ([62.205.161.221]:60528 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbYDGG77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 02:59:59 -0400
Message-ID: <47F9CB64.8040009@openvz.org>
Date: Mon, 07 Apr 2008 11:21:08 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH] fix SEM_UNDO with namespaces, take 2
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org> <m1od8tiom7.fsf@ebiederm.dsl.xmission.com> <20080403194418.GA11105@sergelap.austin.ibm.com> <20080404043902.GA14177@sergelap.austin.ibm.com> <47F8E824.6090600@colorfullife.com> <47F8F99D.1070701@colorfullife.com>
In-Reply-To: <47F8F99D.1070701@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 07 Apr 2008 10:57:32 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Hi,
> 
> below is the second attempt to fix SEM_UNDO + unshare():
> lookup_undo (in ipc/sem.c) is not namespace-aware, thus all entries in 
> sysvsem.undo_list must be from the same namespace.
> The patch enforces that by detaching the current thread from 
> sysvsem.undo_list in switch_task_namespaces() if the ipc namespace is 
> changed.
> 
> The patch boots and passes simple sysvsem+unshare tests.
> 
> Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>
> 
> @@ -211,6 +211,18 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
>  
>  	might_sleep();
>  
> +	if ((p->nsproxy == NULL && new != NULL) ||
> +		(p->nsproxy != NULL && new == NULL) ||
> +		(p->nsproxy != NULL && new != NULL && p->nsproxy->ipc_ns != new->ipc_ns)) {
> +		/* switching the IPC namespace is considered equivalent to sys_exit() wrt.
> +		 * to outstanding SEM_UNDO undos: After switching to the new IPC namespace,
> +		 * the semaphore arrays from the old namespace are not accessible anymore.
> +		 * 
> +		 * Additionally, an implicit sys_unshare(CLONE_SYSVSEM) is performed.
> +		 */
> +		exit_sem(p);
> +	}
> +

No, switch_task_namespaces is the wrong place to do this. It is to be 
done in copy_ipc_ns. If you need a task for which a new namespace is 
being prepared, then pass one into it.

>  	ns = p->nsproxy;
>  
>  	rcu_assign_pointer(p->nsproxy, new);

