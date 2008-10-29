Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYJ2TQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYJ2TQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYJ2TQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:16:44 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:63291 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbYJ2TQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:16:43 -0400
Subject: Re: [PATCH -v1 2/3] vm: use new has_capability_noaudit
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, jmorris@nameil.org,
       serue@us.ibm.com, morgan@kernel.org, casey@schaufler-ca.com,
       esandeen@redhat.com
In-Reply-To: <20081029190658.31292.10620.stgit@paris.rdu.redhat.com>
References: <20081029190652.31292.5901.stgit@paris.rdu.redhat.com>
	 <20081029190658.31292.10620.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 29 Oct 2008 15:15:23 -0400
Message-Id: <1225307723.6588.119.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-29 at 15:06 -0400, Eric Paris wrote:
> The oomkiller calculations make decisions based on capabilities.  Since
> these are not security decisions and LSMs should not record if they fall
> the request they should use the new has_capability_noaudit() interface so
> the denials will not be recorded.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  fs/proc/base.c |    2 +-
>  mm/oom_kill.c  |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 486cf3f..ef83e81 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1020,7 +1020,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
>  	task = get_proc_task(file->f_path.dentry->d_inode);
>  	if (!task)
>  		return -ESRCH;
> -	if (oom_adjust < task->oomkilladj && !capable(CAP_SYS_RESOURCE)) {
> +	if (oom_adjust < task->oomkilladj && !has_capability_noaudit(current, CAP_SYS_RESOURCE)) {

This one looks like an actual permission check to see whether the
current task is authorized to modify this value (by writing to some proc
node).  Which should be audited.  Unlike the others, where they are
checking whether some other task has a capability in order to help
decide priorities for the OOM killer.


>  		put_task_struct(task);
>  		return -EACCES;
>  	}
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 64e5b4b..34a458a 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -129,8 +129,8 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  	 * Superuser processes are usually more important, so we make it
>  	 * less likely that we kill those.
>  	 */
> -	if (has_capability(p, CAP_SYS_ADMIN) ||
> -	    has_capability(p, CAP_SYS_RESOURCE))
> +	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> +	    has_capability_noaudit(p, CAP_SYS_RESOURCE))
>  		points /= 4;
>  
>  	/*
> @@ -139,7 +139,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  	 * tend to only have this flag set on applications they think
>  	 * of as important.
>  	 */
> -	if (has_capability(p, CAP_SYS_RAWIO))
> +	if (has_capability_noaudit(p, CAP_SYS_RAWIO))
>  		points /= 4;
>  
>  	/*
-- 
Stephen Smalley
National Security Agency

