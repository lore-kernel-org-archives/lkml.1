Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZFZBtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZFZBtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 21:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZFZBtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 21:49:46 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39253 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZFZBtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 21:49:45 -0400
Date: Thu, 25 Jun 2009 21:49:35 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern
Message-ID: <20090626014931.GA31302@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625163050.d6a71a13.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 04:30:50PM -0700, Andrew Morton wrote:
> On Mon, 22 Jun 2009 13:28:18 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Add/Modify some features of the core_pattern infrastructure:
> 
> It would have been preferable to present this as three separate patches
> rather than a bundle?
> 
Arguably, yes.  I can certain split the recursive dump detection out into a
separate patch if you like, but I'd rather keep the sysctl and core wait bits
together.  They aren't explicitly dependent on one another, but the sysctl
provides a mechanism to limit the backlog of waiting dumps, which I think is
important for people to have if they're going to use the core waiting feature.

> > 1) Change how we detect recursive dumps.  Currently we have a mechanism by which
> > we try to compare pathnames of the crashing process to the core_pattern path.
> > This is broken for a dozen reasons, and just doesn't work in any sort of robust
> > way.  I'm replacing it with the use of a 0 RLIMIT_CORE value.  Since helper
> > apps set RLIMIT_CORE to zero, we don't write out core files for any process with
> > that particular limit set.  It the core_pattern is a pipe, any non-zero limit is
> > translated to RLIM_INFINITY.  This allows complete dumps to be captured, but
> > prevents infinite recursion in the event that the core_pattern process itself
> > crashes.
> 
> Seems reasonable.
> 
Cool, thanks!

> > 2) Allow for the kernel to wait for a core_pattern process to complete.  One of
> > the things core_pattern processes might do is interrogate the status of a
> > crashing process via its /proc/pid directory.  To ensure that that directory is
> > not removed prematurely, we wait for the process to exit prior to cleaning it
> > up.
> 
> hm.
> 
Apport (which this patch was initially written for) does exactly this, and it
normally works because it gets the data it needs out of proc quickly, before the
kernel removes it, this just guarantees that behavior.

> > 3) Introduce a core_pipe_limit sysctl.
> 
> Please document this?  Documentation/filesystems/proc.txt, perhaps.
> 
Sure, I can do that.

> >  As we would like to avoid boundless
> > process creation in response to large numbers of parallel process crashes, this
> > sysctl limits the number of parallel dumps we can process.  If
> > core_pattern_limit is set to X, only X dumps will be processed in parallel, dump
> > X+1 will be dropped and its miss will be logged.  Setting this sysctl to zero
> > will allow limitless parallel dumps, but will also not wait for the
> > core_pattern process to complete before cleaning up the crashing process, so as
> > to avoid holding on to all that exess memory if load gets too high.
> 
> This seems like it adds unreliability and perhaps DoSability.
> 
Quite the opposite, actually.  If this sysctl is zero, no waiting takes place.
Any non-zero value allows only that many processes to wait in do_coredump in
parallel.  Any crashes above that, simply get logged to syslog, and the
userspace helper isn't forked.  It prevents an infinite number of core_patter
helper processes from running in parallel and blocking forever.

> Did you consider resolving this problem by throttling (ie: an upper
> limit on the number of concurrent dumpers) rather than by discarding?
Thats exactly what it does.  Perhaps I didn't explain it clear enough.  I'll
repost in the morning, separating the patch into two segments (the recursion
detection and the sysctl+core waiting), and I'll add documentation in proc.txt
that clarifies the meaning and use of the sysctl.

Thanks for the feedback!
Neil

> 
> > This resolves kernel.org bug 13355:
> > http://bugzilla.kernel.org/show_bug.cgi?id=13355
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > Reported-by: Earl Chew <earl_chew@agilent.com>
> > 
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 895823d..d5a635e 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -62,6 +62,8 @@
> >  
> >  int core_uses_pid;
> >  char core_pattern[CORENAME_MAX_SIZE] = "core";
> > +unsigned int core_pipe_limit;
> > +
> >  int suid_dumpable = 0;
> >  
> >  /* The maximal length of core_pattern is also specified in sysctl.c */
> > @@ -1701,6 +1703,8 @@ int get_dumpable(struct mm_struct *mm)
> >  	return (ret >= 2) ? 2 : ret;
> >  }
> >  
> > +static atomic_t core_dump_count = ATOMIC_INIT(0);
> 
> fyi, we decided that the `= ATOMIC_INIT(0)' is no longer needed in this
> case - we just use the all-zeroes pattern for atomic_t's.
> 
> This won't make any difference if gcc manages to move the atomic_t out of
> .data and into .bss.  Whether it succesfully does that for this
> construct I do not know.
> 
> 
> Also, core_dump_count could be made static inside do_coredump(), which
> is a little neater.
> 
> >  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  {
> >  	struct core_state core_state;
> > @@ -1717,7 +1721,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
> >  	char **helper_argv = NULL;
> >  	int helper_argc = 0;
> > -	char *delimit;
> > +	pid_t pid = 0;
> > +	int dump_count;
> >  
> >  	audit_core_dumps(signr);
> >  
> > @@ -1784,42 +1789,53 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  		goto fail_unlock;
> >  
> >   	if (ispipe) {
> > +
> > +		if (core_limit == 0) {
> > +			/*
> > +			 * Normally core limits are irrelevant to pipes, since
> > +			 * we're not writing to the file system, but we use
> > +			 * core_limit of 0 here as a speacial value. Any
> > +			 * non-zero limit gets set to RLIM_INFINITY below, but
> > +			 * a limit of 0 skips the dump.  This is a consistent
> > +			 * way to catch recursive crashes.  We can still crash
> > +			 * if the core_pattern binary sets RLIM_CORE =  !0
> > +			 * but it runs as root, and can do lots of stupid things
> > +			 */
> > +			printk(KERN_WARNING "Process %d(%s) has RLIMIT_CORE set to 0\n",
> > +				task_tgid_vnr(current), current->comm);
> 
> whoa.  What does task_tgid_vnr() do?
> 
> <reads that function and three levels of callee>
> 
> <gets grumpy at undocumentedness, stops and then guesses>
> 
> Thread group leader's PID relative to its pid namespace?
> 
> > +			printk(KERN_WARNING "Aborting core\n");
> > +			goto fail_unlock;
> > +		}
> > +
> >  		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
> >  		if (!helper_argv) {
> >  			printk(KERN_WARNING "%s failed to allocate memory\n",
> >  			       __func__);
> >  			goto fail_unlock;
> >  		}
> > -		/* Terminate the string before the first option */
> > -		delimit = strchr(corename, ' ');
> > -		if (delimit)
> > -			*delimit = '\0';
> > -		delimit = strrchr(helper_argv[0], '/');
> > -		if (delimit)
> > -			delimit++;
> > -		else
> > -			delimit = helper_argv[0];
> > -		if (!strcmp(delimit, current->comm)) {
> > -			printk(KERN_NOTICE "Recursive core dump detected, "
> > -					"aborting\n");
> > -			goto fail_unlock;
> > +
> > +		dump_count = atomic_inc_return(&core_dump_count);
> > +		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
> > +			printk(KERN_WARNING "Capturing too many dumps at once\n");
> 
> hm, unprivileged-user-triggerable printk.  Doesn't matter much.
> 
> However if we're really going to emit userspace runtime debugging info
> from the kernel, those messages should provide some means by which the
> offending userspace can be identified.  Which container, user,
> application, etc is causing the problem?  On a really large and busy
> system, a message like this could be quite puzzling.
> 
> > +			goto fail_dropcount;
> >  		}
> >  
> >  		core_limit = RLIM_INFINITY;
> >  
> >  		/* SIGPIPE can happen, but it's just never processed */
> > - 		if (call_usermodehelper_pipe(corename+1, helper_argv, NULL,
> > -				&file)) {
> > - 			printk(KERN_INFO "Core dump to %s pipe failed\n",
> > +		if (call_usermodehelper_pipe(helper_argv[0],  helper_argv, NULL,
> > +				&file, &pid)) {
> > +			printk(KERN_CRIT "Core dump to %s pipe failed\n",
> >  			       corename);
> > - 			goto fail_unlock;
> > +			goto fail_dropcount;
> >   		}
> > +
> >   	} else
> >   		file = filp_open(corename,
> >  				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
> >  				 0600);
> >  	if (IS_ERR(file))
> > -		goto fail_unlock;
> > +		goto fail_dropcount;
> >  	inode = file->f_path.dentry->d_inode;
> >  	if (inode->i_nlink > 1)
> >  		goto close_fail;	/* multiple links - don't dump */
> > @@ -1845,10 +1861,16 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  
> >  	retval = binfmt->core_dump(signr, regs, file, core_limit);
> >  
> > +	if (ispipe && core_pipe_limit)
> > +		sys_wait4(pid, NULL, 0, NULL);
> > +
> >  	if (retval)
> >  		current->signal->group_exit_code |= 0x80;
> >  close_fail:
> >  	filp_close(file, NULL);
> > +fail_dropcount:
> > +	if (ispipe)
> > +		atomic_dec(&core_dump_count);
> >  fail_unlock:
> >  	if (helper_argv)
> >  		argv_free(helper_argv);
> > diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> > index 384ca8b..07e9f53 100644
> > --- a/include/linux/kmod.h
> > +++ b/include/linux/kmod.h
> > @@ -65,7 +65,8 @@ enum umh_wait {
> >  };
> >  
> >  /* Actually execute the sub-process */
> > -int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
> > +int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait,
> > +			     pid_t *pid);
> >  
> >  /* Free the subprocess_info. This is only needed if you're not going
> >     to call call_usermodehelper_exec */
> > @@ -80,7 +81,7 @@ call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
> >  	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
> >  	if (info == NULL)
> >  		return -ENOMEM;
> > -	return call_usermodehelper_exec(info, wait);
> > +	return call_usermodehelper_exec(info, wait, NULL);
> >  }
> >  
> >  static inline int
> > @@ -95,14 +96,14 @@ call_usermodehelper_keys(char *path, char **argv, char **envp,
> >  		return -ENOMEM;
> >  
> >  	call_usermodehelper_setkeys(info, session_keyring);
> > -	return call_usermodehelper_exec(info, wait);
> > +	return call_usermodehelper_exec(info, wait, NULL);
> >  }
> >  
> >  extern void usermodehelper_init(void);
> >  
> >  struct file;
> >  extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
> > -				    struct file **filp);
> > +				    struct file **filp, pid_t *pid);
> >  
> >  extern int usermodehelper_disable(void);
> >  extern void usermodehelper_enable(void);
> > diff --git a/kernel/kmod.c b/kernel/kmod.c
> > index 7e95bed..9828286 100644
> > --- a/kernel/kmod.c
> > +++ b/kernel/kmod.c
> > @@ -126,6 +126,7 @@ struct subprocess_info {
> >  	char **envp;
> >  	enum umh_wait wait;
> >  	int retval;
> > +	pid_t helper_pid;
> >  	struct file *stdin;
> >  	void (*cleanup)(char **argv, char **envp);
> >  };
> > @@ -204,7 +205,15 @@ static int wait_for_helper(void *data)
> >  	 * populate the status, but will return -ECHILD. */
> >  	allow_signal(SIGCHLD);
> >  
> > +	/*
> > +	 * Set the pid to zero here, since
> > +	 * The helper process will have exited
> > +	 * by the time the caller reads this
> > +	 */
> 
> There's no need to cram the comments into 50 columns.
> 
> This sentence has a random capitalised word in the middle, and no full-stop ;)
> 
> > +	sub_info->helper_pid = 0;
> > +
> >  	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
> > +
> >  	if (pid < 0) {
> >  		sub_info->retval = pid;
> >  	} else {
> > @@ -253,9 +262,11 @@ static void __call_usermodehelper(struct work_struct *work)
> >  	if (wait == UMH_WAIT_PROC || wait == UMH_NO_WAIT)
> >  		pid = kernel_thread(wait_for_helper, sub_info,
> >  				    CLONE_FS | CLONE_FILES | SIGCHLD);
> > -	else
> > +	else {
> >  		pid = kernel_thread(____call_usermodehelper, sub_info,
> >  				    CLONE_VFORK | SIGCHLD);
> > +		sub_info->helper_pid = pid;
> > +	}
> >  
> >  	switch (wait) {
> >  	case UMH_NO_WAIT:
> > @@ -369,6 +380,7 @@ struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
> >  	sub_info->path = path;
> >  	sub_info->argv = argv;
> >  	sub_info->envp = envp;
> > +	sub_info->helper_pid = 0;
> >  	sub_info->cred = prepare_usermodehelper_creds();
> >  	if (!sub_info->cred) {
> >  		kfree(sub_info);
> > @@ -457,7 +469,7 @@ EXPORT_SYMBOL(call_usermodehelper_stdinpipe);
> >   * (ie. it runs with full root capabilities).
> >   */
> >  int call_usermodehelper_exec(struct subprocess_info *sub_info,
> > -			     enum umh_wait wait)
> > +			     enum umh_wait wait, pid_t *pid)
> >  {
> >  	DECLARE_COMPLETION_ONSTACK(done);
> >  	int retval = 0;
> > @@ -481,7 +493,8 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
> >  		goto unlock;
> >  	wait_for_completion(&done);
> >  	retval = sub_info->retval;
> > -
> > +	if (pid)
> > +		*pid = sub_info->helper_pid;
> 
> I query the addition of helper_pid.
> 
> That pid already gets returned in sub_info->retval, does it not?  Did
> we just duplicate that?
> 
> If we indeed do need this new field, can this apparent duplication be
> cleaned up?  For example, can the copying of the PID into ->retval be
> removed, and switch all pid-using sites over to use the new
> ->helper_pid?
> 
> >  out:
> >  	call_usermodehelper_freeinfo(sub_info);
> >  unlock:
> > @@ -502,11 +515,11 @@ EXPORT_SYMBOL(call_usermodehelper_exec);
> >   * lower-level call_usermodehelper_* functions.
> >   */
> >  int call_usermodehelper_pipe(char *path, char **argv, char **envp,
> > -			     struct file **filp)
> > +			     struct file **filp, pid_t *pid)
> >  {
> >  	struct subprocess_info *sub_info;
> >  	int ret;
> > -
> > +	
> >  	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
> >  	if (sub_info == NULL)
> >  		return -ENOMEM;
> > @@ -515,7 +528,8 @@ int call_usermodehelper_pipe(char *path, char **argv, char **envp,
> >  	if (ret < 0)
> >  		goto out;
> >  
> > -	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
> > +	ret = call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC, pid);
> > +	return ret;
> >  
> >    out:
> >  	call_usermodehelper_freeinfo(sub_info);
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index e7998cf..30f7dc8 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1863,7 +1863,7 @@ int orderly_poweroff(bool force)
> >  
> >  	call_usermodehelper_setcleanup(info, argv_cleanup);
> >  
> > -	ret = call_usermodehelper_exec(info, UMH_NO_WAIT);
> > +	ret = call_usermodehelper_exec(info, UMH_NO_WAIT, NULL);
> >  
> >    out:
> >  	if (ret && force) {
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index b2970d5..2346c0f 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -75,6 +75,7 @@ extern int max_threads;
> >  extern int core_uses_pid;
> >  extern int suid_dumpable;
> >  extern char core_pattern[];
> > +extern unsigned int core_pipe_limit;
> 
> Bah.
> 
> We should fix this one day.
> 
> >  extern int pid_max;
> >  extern int min_free_kbytes;
> >  extern int pid_max_min, pid_max_max;
> > @@ -396,6 +397,14 @@ static struct ctl_table kern_table[] = {
> >  		.proc_handler	= &proc_dostring,
> >  		.strategy	= &sysctl_string,
> >  	},
> > +	{
> > +		.ctl_name	= CTL_UNNUMBERED,
> > +		.procname	= "core_pipe_limit",
> > +		.data		= &core_pipe_limit,
> > +		.maxlen		= sizeof(unsigned int),
> > +		.mode		= 0644,
> > +		.proc_handler	= &proc_dointvec,
> > +	},
> 
> Please ensure that the core_pipe_limit documentation describes its
> units.  
> 
> It's "number of concurrent coredumps, system-wide", yes?
> 
> It does make coredumping unreliable, doesn't it? :(
> 
