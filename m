Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZAEI0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZAEI0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 03:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZAEIZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 03:25:52 -0500
Received: from tundra.namei.org ([65.99.196.166]:2138 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbZAEIZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 03:25:51 -0500
Date: Mon, 5 Jan 2009 19:25:06 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [TOMOYO #14 (mmotm 2008-12-30-16-05) 01/10] Add in_execve flag
 into task_struct.
In-Reply-To: <20090101050938.558328702@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.1.10.0901051924140.16049@tundra.namei.org>
References: <20090101050741.372438529@I-love.SAKURA.ne.jp> <20090101050938.558328702@I-love.SAKURA.ne.jp>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 2009, Tetsuo Handa wrote:

> This patch allows LSM modules to determine whether current process is in an
> execve operation or not so that they can behave differently while an execve
> operation is in progress.
> 
> This allows TOMOYO to dispense with a readability check on a file to be
> executed under the process's current credentials, and to do it instead under
> the proposed credentials.
> 
> This is required with the new COW credentials because TOMOYO is no longer
> allowed to mark the state temporarily in the security struct attached to the
> task_struct.

Serge previously queried this flag:

http://article.gmane.org/gmane.linux.kernel.lsm/7611

The issue does not appear to have been resolved.


> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>  fs/compat.c           |    3 +++
>  fs/exec.c             |    3 +++
>  include/linux/sched.h |    2 ++
>  3 files changed, 8 insertions(+)
> 
> --- linux-2.6.28-mm1.orig/fs/compat.c
> +++ linux-2.6.28-mm1/fs/compat.c
> @@ -1402,6 +1402,7 @@ int compat_do_execve(char * filename,
>  	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
>  	if (retval < 0)
>  		goto out_free;
> +	current->in_execve = 1;
>  
>  	retval = -ENOMEM;
>  	bprm->cred = prepare_exec_creds();
> @@ -1454,6 +1455,7 @@ int compat_do_execve(char * filename,
>  		goto out;
>  
>  	/* execve succeeded */
> +	current->in_execve = 0;
>  	mutex_unlock(&current->cred_exec_mutex);
>  	acct_update_integrals(current);
>  	free_bprm(bprm);
> @@ -1470,6 +1472,7 @@ out_file:
>  	}
>  
>  out_unlock:
> +	current->in_execve = 0;
>  	mutex_unlock(&current->cred_exec_mutex);
>  
>  out_free:
> --- linux-2.6.28-mm1.orig/fs/exec.c
> +++ linux-2.6.28-mm1/fs/exec.c
> @@ -1306,6 +1306,7 @@ int do_execve(char * filename,
>  	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
>  	if (retval < 0)
>  		goto out_free;
> +	current->in_execve = 1;
>  
>  	retval = -ENOMEM;
>  	bprm->cred = prepare_exec_creds();
> @@ -1359,6 +1360,7 @@ int do_execve(char * filename,
>  		goto out;
>  
>  	/* execve succeeded */
> +	current->in_execve = 0;
>  	mutex_unlock(&current->cred_exec_mutex);
>  	acct_update_integrals(current);
>  	free_bprm(bprm);
> @@ -1377,6 +1379,7 @@ out_file:
>  	}
>  
>  out_unlock:
> +	current->in_execve = 0;
>  	mutex_unlock(&current->cred_exec_mutex);
>  
>  out_free:
> --- linux-2.6.28-mm1.orig/include/linux/sched.h
> +++ linux-2.6.28-mm1/include/linux/sched.h
> @@ -1155,6 +1155,8 @@ struct task_struct {
>  	/* ??? */
>  	unsigned int personality;
>  	unsigned did_exec:1;
> +	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
> +				 * execve */
>  	pid_t pid;
>  	pid_t tgid;
>  
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
James Morris
<jmorris@namei.org>
