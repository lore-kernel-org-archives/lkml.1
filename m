Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514Ab0AZX6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0AZX6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482Ab0AZX63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:58:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104Ab0AZX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:58:17 -0500
Date: Tue, 26 Jan 2010 15:53:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, jmoskovc@redhat.com, mingo@redhat.com,
       drbd-dev@lists.linbit.com, benh@kernel.crashing.org,
       t.sailer@alumni.ethz.ch, abelay@mit.edu, gregkh@suse.de,
       spock@gentoo.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       mfasheh@suse.com, menage@google.com, shemminger@linux-foundation.org,
       takedakn@nttdata.co.jp
Subject: Re: [PATCH] exec: allow core_pipe recursion check to look for a
 value of 1 rather than 0
Message-Id: <20100126155359.c5ad7cd3.akpm@linux-foundation.org>
In-Reply-To: <20100121200806.GA29801@shamino.rdu.redhat.com>
References: <20100121200806.GA29801@shamino.rdu.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010 15:08:06 -0500
Neil Horman <nhorman@tuxdriver.com> wrote:

> Hey all-
> 	So, about 6 months ago, I made a set of changes to how the
> core-dump-to-a-pipe feature in the kernel works.  We had reports of several
> races, including some reports of apps bypassing our recursion check so that a
> process that was forked as part of a core_pattern setup could infinitely crash
> and refork until the system crashed.
> 
> 	We fixes those by improving our recursion checks.  The new check
> basically refuses to fork a process if its core limit is zero, which works well.
> 
> 	Unfortunately, I've been getting grief from maintainer of user space
> programs that are inserted as the forked process of core_pattern.  They contend
> that in order for their programs (such as abrt and apport) to work, all the
> running processes in a system must have their core limits set to a non-zero
> value, to which I say 'yes'.  I did this by design, and think thats the right
> way to do things.
> 
> 	But I've been asked to ease this burden on user space enough times that
> I thought I would take a look at it.  The first suggestion was to make the
> recursion check fail on a non-zero 'special' number, like one.  That way the
> core collector process could set its core size ulimit to 1, and enable the
> kernel's recursion detection.  This isn't a bad idea on the surface, but I don't
> like it since its opt-in, in that if a program like abrt or apport has a bug and
> fails to set such a core limit, we're left with a recursively crashing system
> again.
> 
> 	So I've come up with this.  What I've done is modify the
> call_usermodehelper api such that an extra parameter is added, a function
> pointer which will be called by the user helper task, after it forks, but before
> it exec's the required process.  This will give the caller the opportunity to
> get a call back in the processes context, allowing it to do whatever it needs to
> to the process in the kernel prior to exec-ing the user space code.  In the case
> of do_coredump, this callback is ues to set the core ulimit of the helper
> process to 1.  This elimnates the opt-in problem that I had above, as it allows
> the ulimit for core sizes to be set to the value of 1, which is what the
> recursion check looks for in do_coredump.
> 
> 	This patch has been tested successfully by some of the Abrt maintainers
> in fedora, with good results.  Patch applies to the latest -mm tree as of this
> AM.
> 

hrm.  Fair enough, I guess..

> +/*
> + * This is used as a helper to set up the task that execs
> + * our user space core collector application
> + * Its called in the context of the task thats going to 
> + * exec itself to be the helper, so we can modify current here
> + */

It's worth spending another 15 seconds on the comments.  That way, they
end up looking like they're written in English.

> +void core_pipe_setup(void)
> +{
> +	task_lock(current->group_leader);
> +	current->signal->rlim[RLIMIT_CORE].rlim_cur = 1;
> +	task_unlock(current->group_leader);
> +}

I'll make this static.

> --- a/fs/nfs/cache_lib.c
> +++ b/fs/nfs/cache_lib.c
> @@ -46,7 +46,7 @@ int nfs_cache_upcall(struct cache_detail *cd, char *entry_name)
>  
>  	if (nfs_cache_getent_prog[0] == '\0')
>  		goto out;
> -	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> +	ret = call_usermodehelper(argv[0], argv, envp, NULL, UMH_WAIT_EXEC);
>  	/*
>  	 * Disable the upcall mechanism if we're getting an ENOENT or
>  	 * EACCES error. The admin can re-enable it on the fly by using
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index f3df0ba..dddf780 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -407,7 +407,7 @@ static void ocfs2_leave_group(const char *group)
>  	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
>  	envp[2] = NULL;
>  
> -	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
> +	ret = call_usermodehelper(argv[0], argv, envp, NULL, UMH_WAIT_PROC);
>  	if (ret < 0) {
>  		printk(KERN_ERR
>  		       "ocfs2: Error %d running user helper "
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index 384ca8b..ca5e531 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -48,7 +48,9 @@ struct subprocess_info;
>  
>  /* Allocate a subprocess_info structure */
>  struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
> -						  char **envp, gfp_t gfp_mask);
> +						  char **envp, 
> +						  void (*finit)(void),
> +						  gfp_t gfp_mask);

What does "finit" mean?  Doesn't seem very intuitive.

>  /* Set various pieces of state into the subprocess_info structure */
>  void call_usermodehelper_setkeys(struct subprocess_info *info,
> @@ -72,12 +74,13 @@ int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
>  void call_usermodehelper_freeinfo(struct subprocess_info *info);
>  
>  static inline int
> -call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
> +call_usermodehelper(char *path, char **argv, char **envp, 
> +		    void (*finit)(void), enum umh_wait wait)
>  {
>  	struct subprocess_info *info;
>  	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
>  
> -	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
> +	info = call_usermodehelper_setup(path, argv, envp, finit, gfp_mask);
>  	if (info == NULL)
>  		return -ENOMEM;
>  	return call_usermodehelper_exec(info, wait);

The semantics of the `finit' callback should be documented here.  It's
a kernel-wide interface and others might want to use it.


You're not a big fan of checkpatch, it seems.
