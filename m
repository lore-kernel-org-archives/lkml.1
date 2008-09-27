Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbYI0E7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYI0E7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 00:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYI0E7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 00:59:01 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:47458 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYI0E7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 00:59:00 -0400
Message-ID: <48DDBD6E.1070108@kernel.org>
Date: Fri, 26 Sep 2008 21:58:22 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] file capabilities: clean up setcap code
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com> <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com> <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com> <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com> <c9c64bbdfd3f1c665f0d1b08b82f77622be701cc.1222451103.git.serue@us.ibm.com>
In-Reply-To: <c9c64bbdfd3f1c665f0d1b08b82f77622be701cc.1222451103.git.serue@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge,

I have to say I'm a bit confused by this one. Specifically, the
cap_get_target_pid() change. In your 5/6 patch, you say this change
("the previous patch") makes the kernel bigger? Is this because of the
cap_get_target_pid() changes? Since you are fighting to reduce space, if
it bloats the code does the cap_get_target_pid() part of the change make
sense?

Cheers

Andrew

Serge E. Hallyn wrote:
> Clean up the sys_capset codepath a bit to account for the fact
> that you can now not ever, never, capset on another task.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  kernel/capability.c |   83 +++++++++++++++++++-------------------------------
>  1 files changed, 32 insertions(+), 51 deletions(-)
> 
> diff --git a/kernel/capability.c b/kernel/capability.c
> index d39c989..92dd85b 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -132,46 +132,31 @@ static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
>   * process. The net result is that we can limit our use of locks to
>   * when we are reading the caps of another process.
>   */
> -static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
> +static int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
>  				     kernel_cap_t *pIp, kernel_cap_t *pPp)
>  {
>  	int ret;
> +	struct task_struct *target;
>  
> -	if (pid && (pid != task_pid_vnr(current))) {
> -		struct task_struct *target;
> +	if (!pid || pid == task_pid_vnr(current))
> +		return security_capget(current, pEp, pIp, pPp);
>  
> -		spin_lock(&task_capability_lock);
> -		read_lock(&tasklist_lock);
> +	spin_lock(&task_capability_lock);
> +	read_lock(&tasklist_lock);
>  
> -		target = find_task_by_vpid(pid);
> -		if (!target)
> -			ret = -ESRCH;
> -		else
> -			ret = security_capget(target, pEp, pIp, pPp);
> +	target = find_task_by_vpid(pid);
> +	if (!target)
> +		ret = -ESRCH;
> +	else
> +		ret = security_capget(target, pEp, pIp, pPp);
>  
> -		read_unlock(&tasklist_lock);
> -		spin_unlock(&task_capability_lock);
> -	} else
> -		ret = security_capget(current, pEp, pIp, pPp);
> +	read_unlock(&tasklist_lock);
> +	spin_unlock(&task_capability_lock);
>  
>  	return ret;
>  }
>  
>  /*
> - * With filesystem capability support configured, the kernel does not
> - * permit the changing of capabilities in one process by another
> - * process. (CAP_SETPCAP has much less broad semantics when configured
> - * this way.)
> - */
> -static inline int do_sys_capset_other_tasks(pid_t pid,
> -					    kernel_cap_t *effective,
> -					    kernel_cap_t *inheritable,
> -					    kernel_cap_t *permitted)
> -{
> -	return -EPERM;
> -}
> -
> -/*
>   * Atomically modify the effective capabilities returning the original
>   * value. No permission check is performed here - it is assumed that the
>   * caller is permitted to set the desired effective capabilities.
> @@ -293,6 +278,9 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>  	if (get_user(pid, &header->pid))
>  		return -EFAULT;
>  
> +	if (pid && (pid != task_pid_vnr(current)))
> +		return -EPERM;
> +
>  	if (copy_from_user(&kdata, data, tocopy
>  			   * sizeof(struct __user_cap_data_struct))) {
>  		return -EFAULT;
> @@ -310,30 +298,23 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>  		i++;
>  	}
>  
> -	if (pid && (pid != task_pid_vnr(current)))
> -		ret = do_sys_capset_other_tasks(pid, &effective, &inheritable,
> -						&permitted);
> -	else {
> -		/*
> -		 * This lock is required even when filesystem
> -		 * capability support is configured - it protects the
> -		 * sys_capget() call from returning incorrect data in
> -		 * the case that the targeted process is not the
> -		 * current one.
> -		 */
> -		spin_lock(&task_capability_lock);
> +	/*
> +	 * This lock protects the sys_capget() call from
> +	 * returning incorrect data in the case that the targeted
> +	 * process is not the current one.
> +	 */
> +	spin_lock(&task_capability_lock);
>  
> -		ret = security_capset_check(current, &effective, &inheritable,
> -					    &permitted);
> -		/*
> -		 * Having verified that the proposed changes are
> -		 * legal, we now put them into effect.
> -		 */
> -		if (!ret)
> -			security_capset_set(current, &effective, &inheritable,
> -					    &permitted);
> -		spin_unlock(&task_capability_lock);
> -	}
> +	ret = security_capset_check(current, &effective, &inheritable,
> +				    &permitted);
> +	/*
> +	 * Having verified that the proposed changes are
> +	 * legal, we now put them into effect.
> +	 */
> +	if (!ret)
> +		security_capset_set(current, &effective, &inheritable,
> +				    &permitted);
> +	spin_unlock(&task_capability_lock);
>  
>  
>  	return ret;
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI3b1s+bHCR3gb8jsRAkWCAJ4j5Q5NQc2TD8B+WOYJ1JIqV1GdqQCg1qQU
+qzZPOvwo/W/73BuA+HvuxQ=
=fRje
-----END PGP SIGNATURE-----
