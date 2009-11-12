Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbZKLOWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbZKLOWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZKLOWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:22:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbZKLOWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:22:21 -0500
Date: Thu, 12 Nov 2009 15:22:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Whitehouse <swhiteho@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 2/2] dlm: Add down/up_write_non_owner to keep lockdep
 happy
Message-ID: <20091112142211.GA468@elte.hu>
References: <1255445776-3112-1-git-send-email-swhiteho@redhat.com>
 <1255445776-3112-2-git-send-email-swhiteho@redhat.com>
 <1255445776-3112-3-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255445776-3112-3-git-send-email-swhiteho@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Whitehouse <swhiteho@redhat.com> wrote:

> I looked at possibly changing this to use completions, but
> it seems that the usage here is not easily adapted to that.
> This patch adds suitable annotation to the write side of
> the ls_in_recovery semaphore so that we don't get nasty
> messages from lockdep when mounting a gfs2 filesystem.

What do those 'nasty messages' say? If they expose some bug and this
patch works around that bug by hiding it then NAK ...

        Ingo

[patch quoted below]

> 
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  fs/dlm/lockspace.c    |    2 +-
>  fs/dlm/member.c       |    2 +-
>  fs/dlm/recoverd.c     |    2 +-
>  include/linux/rwsem.h |    4 ++++
>  kernel/rwsem.c        |   16 ++++++++++++++++
>  5 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
> index 8dde538..fa0cc22 100644
> --- a/fs/dlm/lockspace.c
> +++ b/fs/dlm/lockspace.c
> @@ -551,7 +551,7 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
>  	INIT_LIST_HEAD(&ls->ls_root_list);
>  	init_rwsem(&ls->ls_root_sem);
>  
> -	down_write(&ls->ls_in_recovery);
> +	down_write_non_owner(&ls->ls_in_recovery);
>  
>  	spin_lock(&lslist_lock);
>  	ls->ls_create_count = 1;
> diff --git a/fs/dlm/member.c b/fs/dlm/member.c
> index b128775..99bd086 100644
> --- a/fs/dlm/member.c
> +++ b/fs/dlm/member.c
> @@ -318,7 +318,7 @@ int dlm_ls_stop(struct dlm_ls *ls)
>  	 */
>  
>  	if (new)
> -		down_write(&ls->ls_in_recovery);
> +		down_write_non_owner(&ls->ls_in_recovery);
>  
>  	/*
>  	 * The recoverd suspend/resume makes sure that dlm_recoverd (if
> diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
> index fd677c8..376479a 100644
> --- a/fs/dlm/recoverd.c
> +++ b/fs/dlm/recoverd.c
> @@ -40,7 +40,7 @@ static int enable_locking(struct dlm_ls *ls, uint64_t seq)
>  	if (ls->ls_recover_seq == seq) {
>  		set_bit(LSFL_RUNNING, &ls->ls_flags);
>  		/* unblocks processes waiting to enter the dlm */
> -		up_write(&ls->ls_in_recovery);
> +		up_write_non_owner(&ls->ls_in_recovery);
>  		error = 0;
>  	}
>  	spin_unlock(&ls->ls_recover_lock);
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index efd348f..34643df 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -80,12 +80,16 @@ extern void down_write_nested(struct rw_semaphore *sem, int subclass);
>   *   proper abstraction for this case is completions. ]
>   */
>  extern void down_read_non_owner(struct rw_semaphore *sem);
> +extern void down_write_non_owner(struct rw_semaphore *sem);
>  extern void up_read_non_owner(struct rw_semaphore *sem);
> +extern void up_write_non_owner(struct rw_semaphore *sem);
>  #else
>  # define down_read_nested(sem, subclass)		down_read(sem)
>  # define down_write_nested(sem, subclass)	down_write(sem)
>  # define down_read_non_owner(sem)		down_read(sem)
> +# define down_write_non_owner(sem)		down_write(sem)
>  # define up_read_non_owner(sem)			up_read(sem)
> +# define up_write_non_owner(sem)		up_write(sem)
>  #endif
>  
>  #endif /* _LINUX_RWSEM_H */
> diff --git a/kernel/rwsem.c b/kernel/rwsem.c
> index cae050b..2c57eef 100644
> --- a/kernel/rwsem.c
> +++ b/kernel/rwsem.c
> @@ -126,6 +126,15 @@ void down_read_non_owner(struct rw_semaphore *sem)
>  
>  EXPORT_SYMBOL(down_read_non_owner);
>  
> +void down_write_non_owner(struct rw_semaphore *sem)
> +{
> +	might_sleep();
> +
> +	 __down_write(sem);
> +}
> +
> +EXPORT_SYMBOL(down_write_non_owner);
> +
>  void down_write_nested(struct rw_semaphore *sem, int subclass)
>  {
>  	might_sleep();
> @@ -143,6 +152,13 @@ void up_read_non_owner(struct rw_semaphore *sem)
>  
>  EXPORT_SYMBOL(up_read_non_owner);
>  
> +void up_write_non_owner(struct rw_semaphore *sem)
> +{
> +	__up_write(sem);
> +}
> +
> +EXPORT_SYMBOL(up_write_non_owner);
> +
>  #endif

