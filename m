Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbYCTP3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbYCTP3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbYCTP3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:29:07 -0400
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:42798 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755605AbYCTP3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:29:05 -0400
X-YMail-OSG: okQM_b0VM1nyQ.q6dH.hsi6ailOxyR0XZ.YjsOQfuI1y1GASQ_beyt9r80wAOOXoRYETJOwvJGeLJqCxsOWYOQhTvw--
X-RocketYMMF: rancidfat
Date: Thu, 20 Mar 2008 08:29:03 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 1/1] file capabilities: remove cap_task_kill() (-git)
To: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       morgan@kernel.org, buraphalinuxserver@gmail.com,
       lcapitulino@mandriva.com.br
In-Reply-To: <20080320031803.GA23254@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <142099.68238.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Linus Torvalds (torvalds@linux-foundation.org):
> > 
> > 
> > On Wed, 19 Mar 2008, Andrew Morton wrote:
> > > 
> > > umm,
> > > 
> > > security/smack/smack_lsm.c: In function 'smack_task_kill':
> > > security/smack/smack_lsm.c:1122: error: implicit declaration of function
> 'cap_task_kill'
> 
> Right, that was against
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> which doesn't yet have smack.  I should've been clear about that.
> 
> > Serge, can you resend with that fixed and the tested-by added?
> > 
> > 		Linus
> 
> Following is the version against this morning's mmotm with the tested-by
> added.
> 
> thanks,
> -serge
> 
> 
> >From c50b1c9f7a9e9434c8ddb50cb81e6b342638b8e0 Mon Sep 17 00:00:00 2001
> From: Serge Hallyn <serge@hallyn.com>
> Date: Fri, 29 Feb 2008 15:14:57 +0000
> Subject: [PATCH 1/1] file capabilities: remove cap_task_kill() (-mmotm)
> 
> The original justification for cap_task_kill() was as follows:
> 
> 	check_kill_permission() does appropriate uid equivalence checks.
> 	However with file capabilities it becomes possible for an
> 	unprivileged user to execute a file with file capabilities
> 	resulting in a more privileged task with the same uid.
> 
> However now that cap_task_kill() always returns 0 (permission
> granted) when p->uid==current->uid, the whole hook is worthless,
> and only likely to create more subtle problems in the corner cases
> where it might still be called but return -EPERM.  Those cases
> are basically when uids are different but euid/suid is equivalent
> as per the check in check_kill_permission().
> 
> One example of a still-broken application is 'at' for non-root users.
> 
> This patch removes cap_task_kill().
> 
> Signed-off-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Andrew G. Morgan <morgan@kernel.org>
> Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  include/linux/security.h   |    3 +--
>  security/capability.c      |    1 -
>  security/commoncap.c       |   33 ---------------------------------
>  security/smack/smack_lsm.c |    5 -----
>  4 files changed, 1 insertions(+), 41 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 2231526..13fd76a 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -59,7 +59,6 @@ extern int cap_inode_need_killpriv(struct dentry *dentry);
>  extern int cap_inode_killpriv(struct dentry *dentry);
>  extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t
> old_suid, int flags);
>  extern void cap_task_reparent_to_init (struct task_struct *p);
> -extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int
> sig, u32 secid);
>  extern int cap_task_prctl(int option, unsigned long arg2, unsigned long
> arg3,
>  			  unsigned long arg4, unsigned long arg5, long *rc_p);
>  extern int cap_task_setscheduler (struct task_struct *p, int policy, struct
> sched_param *lp);
> @@ -2276,7 +2275,7 @@ static inline int security_task_kill (struct
> task_struct *p,
>  				      struct siginfo *info, int sig,
>  				      u32 secid)
>  {
> -	return cap_task_kill(p, info, sig, secid);
> +	return 0;
>  }
>  
>  static inline int security_task_wait (struct task_struct *p)
> diff --git a/security/capability.c b/security/capability.c
> index 8340655..38ac54e 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -40,7 +40,6 @@ static struct security_operations capability_ops = {
>  	.inode_need_killpriv =		cap_inode_need_killpriv,
>  	.inode_killpriv =		cap_inode_killpriv,
>  
> -	.task_kill =			cap_task_kill,
>  	.task_setscheduler =		cap_task_setscheduler,
>  	.task_setioprio =		cap_task_setioprio,
>  	.task_setnice =			cap_task_setnice,
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 200361d..e8c3f5e 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -537,34 +537,6 @@ int cap_task_setnice (struct task_struct *p, int nice)
>  	return cap_safe_nice(p);
>  }
>  
> -int cap_task_kill(struct task_struct *p, struct siginfo *info,
> -				int sig, u32 secid)
> -{
> -	/*
> -	 * Running a setuid root program raises your capabilities.
> -	 * Killing your own setuid root processes was previously
> -	 * allowed.
> -	 * We must preserve legacy signal behavior in this case.
> -	 */
> -	if (p->uid == current->uid)
> -		return 0;
> -
> -	if (secid)
> -		/*
> -		 * Signal sent as a particular user.
> -		 * Capabilities are ignored.  May be wrong, but it's the
> -		 * only thing we can do at the moment.
> -		 * Used only by usb drivers?
> -		 */
> -		return 0;
> -	if (cap_issubset(p->cap_permitted, current->cap_permitted))
> -		return 0;
> -	if (capable(CAP_KILL))
> -		return 0;
> -
> -	return -EPERM;
> -}
> -
>  /*
>   * called from kernel/sys.c for prctl(PR_CABSET_DROP)
>   * done without task_capability_lock() because it introduces
> @@ -596,11 +568,6 @@ int cap_task_setnice (struct task_struct *p, int nice)
>  {
>  	return 0;
>  }
> -int cap_task_kill(struct task_struct *p, struct siginfo *info,
> -				int sig, u32 secid)
> -{
> -	return 0;
> -}
>  #endif
>  
>  int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 4365fad..2a5eb83 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1117,11 +1117,6 @@ static int smack_task_movememory(struct task_struct
> *p)
>  static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>  			   int sig, u32 secid)
>  {
> -	int rc;
> -
> -	rc = cap_task_kill(p, info, sig, secid);
> -	if (rc != 0)
> -		return rc;
>  	/*
>  	 * Sending a signal requires that the sender
>  	 * can write the receiver.
> -- 
> 1.5.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
