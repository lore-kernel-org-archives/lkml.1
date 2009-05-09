Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZEITFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZEITFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 15:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZEITFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 15:05:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34282 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbZEITFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 15:05:22 -0400
Date: Sat, 9 May 2009 20:59:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: roland@redhat.com, jmorris@namei.org, chrisw@sous-sol.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, eparis@redhat.com,
       sds@tycho.nsa.gov, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] CRED: Rename cred_exec_mutex to reflect that it's
	a guard against ptrace
Message-ID: <20090509185906.GB10396@redhat.com>
References: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay,

On 05/08, David Howells wrote:
>
> @@ -185,10 +185,11 @@ int ptrace_attach(struct task_struct *task)
>  	if (same_thread_group(task, current))
>  		goto out;
>
> -	/* Protect exec's credential calculations against our interference;
> -	 * SUID, SGID and LSM creds get determined differently under ptrace.
> +	/* Protect the target's credential calculations against our
> +	 * interference; SUID, SGID and LSM creds get determined differently
> +	 * under ptrace.
>  	 */
> -	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
> +	retval = mutex_lock_interruptible(&task->cred_guard_mutex);
>  	if (retval  < 0)
>  		goto out;
>
> @@ -232,7 +233,7 @@ repeat:
>  bad:
>  	write_unlock_irqrestore(&tasklist_lock, flags);
>  	task_unlock(task);
> -	mutex_unlock(&task->cred_exec_mutex);
> +	mutex_unlock(&task->cred_guard_mutex);

This rename is obviously fine, but conflicts with
ptrace-do-not-use-task_lock-for-attach.patch in -mm tree:

-bad:
-       write_unlock_irqrestore(&tasklist_lock, flags);
-       task_unlock(task);
+unlock_tasklist:
+       write_unlock_irq(&tasklist_lock);
+unlock_creds:
        mutex_unlock(&task->cred_exec_mutex);
 out:
        return retval;


Hmm. Ingo's "rename ptrace_may_access => ptrace_access_check" conflicts
with my patch too.


Andrew, Roland, I guess I should re-send
	
	ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
	ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
	ptrace-do-not-use-task_lock-for-attach.patch

patches?

Oleg.

