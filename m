Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYCETTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYCETTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYCETTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:19:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54038 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYCETTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:19:33 -0500
Date: Wed, 5 Mar 2008 20:17:11 +0100
From: Chris Friedhoff <chris@friedhoff.org>
To: linux-security-module@vger.kernel.org
Cc: chris@friedhoff.org, serge@hallyn.com, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Mike Galbraith <efault@gmx.de>, buraphalinuxserver@gmail.com,
       elendil@planet.nl, stable@kernel.org
Subject: Re: [PATCH 1/1] file capabilities: remove cap_task_kill()
Message-Id: <20080305201711.8092b852.chris@friedhoff.org>
In-Reply-To: <20080229212634.GA7278@vino.hallyn.com>
References: <20080228173817.GA32661@vino.hallyn.com>
	<20080229174007.0a934cc6@mandriva.com.br>
	<20080229212634.GA7278@vino.hallyn.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.1; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/xTli8EWurj8RL6IOnNyijbkxSPiwPmJsxLwd
 LbNc1/L25tmrYJF8TsbBtqxR4x265GGspckMaDzbIVWxoF4jfg
 dKU2eLOBEU9CeBXK3x91VLksJUr1zU1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It works here against 2.6.24.3.
Originaly it was a fix - if I recall correctly - to allow a self
started X to kill completly. This works with the patch.

Chris


On Fri, 29 Feb 2008 15:26:34 -0600
serge@hallyn.com wrote:

> Quoting Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br):
> > Em Thu, 28 Feb 2008 11:38:17 -0600
> > serge@hallyn.com escreveu:
> > 
> > | The original justification for cap_task_kill() was as follows:
> > | 
> > | 	check_kill_permission() does appropriate uid equivalence checks.
> > | 	However with file capabilities it becomes possible for an
> > | 	unprivileged user to execute a file with file capabilities
> > | 	resulting in a more privileged task with the same uid.
> > | 
> > | However now that cap_task_kill() always returns 0 (permission
> > | granted) when p->uid==current->uid, the whole hook is worthless,
> > | and only likely to create more subtle problems in the corner cases
> > | where it might still be called but return -EPERM.  Those cases
> > | are basically when uids are different but euid/suid is equivalent
> > | as per the check in check_kill_permission().
> > | 
> > | This patch removes cap_task_kill().
> > 
> >  2.6.24 seems to have the same bug, what about a rediff for it and
> > submit the patch to -stable team?
> 
> Luiz, could you confirm that the below works?
> 
> thanks,
> -serge
> 
> From c77b7d418933c14707383f06a1da61169e84071b Mon Sep 17 00:00:00 2001
> From: Serge Hallyn <serge@hallyn.com>
> Date: Fri, 29 Feb 2008 15:14:57 +0000
> Subject: [PATCH 1/1] file capabilities: remove cap_task_kill()
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
> This patch removes cap_task_kill().
> 
> Signed-off-by: Serge Hallyn <serge@hallyn.com>
> ---
>  include/linux/security.h |    3 +--
>  security/capability.c    |    1 -
>  security/commoncap.c     |   39 ---------------------------------------
>  3 files changed, 1 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index ac05083..d842ee3 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -62,7 +62,6 @@ extern int cap_inode_need_killpriv(struct dentry *dentry);
>  extern int cap_inode_killpriv(struct dentry *dentry);
>  extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
>  extern void cap_task_reparent_to_init (struct task_struct *p);
> -extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
>  extern int cap_task_setscheduler (struct task_struct *p, int policy, struct sched_param *lp);
>  extern int cap_task_setioprio (struct task_struct *p, int ioprio);
>  extern int cap_task_setnice (struct task_struct *p, int nice);
> @@ -2112,7 +2111,7 @@ static inline int security_task_kill (struct task_struct *p,
>  				      struct siginfo *info, int sig,
>  				      u32 secid)
>  {
> -	return cap_task_kill(p, info, sig, secid);
> +	return 0;
>  }
>  
>  static inline int security_task_wait (struct task_struct *p)
> diff --git a/security/capability.c b/security/capability.c
> index 9e99f36..2c6e06d 100644
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
> index ea61bc7..6e9065c 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -527,40 +527,6 @@ int cap_task_setnice (struct task_struct *p, int nice)
>  	return cap_safe_nice(p);
>  }
>  
> -int cap_task_kill(struct task_struct *p, struct siginfo *info,
> -				int sig, u32 secid)
> -{
> -	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
> -		return 0;
> -
> -	/*
> -	 * Running a setuid root program raises your capabilities.
> -	 * Killing your own setuid root processes was previously
> -	 * allowed.
> -	 * We must preserve legacy signal behavior in this case.
> -	 */
> -	if (p->euid == 0 && p->uid == current->uid)
> -		return 0;
> -
> -	/* sigcont is permitted within same session */
> -	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
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
>  #else
>  int cap_task_setscheduler (struct task_struct *p, int policy,
>  			   struct sched_param *lp)
> @@ -575,11 +541,6 @@ int cap_task_setnice (struct task_struct *p, int nice)
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
>  void cap_task_reparent_to_init (struct task_struct *p)
> -- 
> 1.5.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------------------
Chris Friedhoff
chris@friedhoff.org
