Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYCAWF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYCAWF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 17:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYCAWFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 17:05:10 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:59932 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbYCAWFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 17:05:08 -0500
Message-ID: <47C9D313.3080900@kernel.org>
Date: Sat, 01 Mar 2008 14:05:07 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: serge@hallyn.com
CC: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>, Mike Galbraith <efault@gmx.de>,
       buraphalinuxserver@gmail.com, elendil@planet.nl
Subject: Re: [PATCH 1/1] file capabilities: remove cap_task_kill()
References: <20080228173817.GA32661@vino.hallyn.com>
In-Reply-To: <20080228173817.GA32661@vino.hallyn.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

serge@hallyn.com wrote:
| The original justification for cap_task_kill() was as follows:
|
| 	check_kill_permission() does appropriate uid equivalence checks.
| 	However with file capabilities it becomes possible for an
| 	unprivileged user to execute a file with file capabilities
| 	resulting in a more privileged task with the same uid.
|
| However now that cap_task_kill() always returns 0 (permission
| granted) when p->uid==current->uid, the whole hook is worthless,
| and only likely to create more subtle problems in the corner cases
| where it might still be called but return -EPERM.  Those cases
| are basically when uids are different but euid/suid is equivalent
| as per the check in check_kill_permission().
|
| This patch removes cap_task_kill().
|
| Signed-off-by: Serge Hallyn <serge@hallyn.com>
| ---
|  include/linux/security.h   |    3 +--
|  security/capability.c      |    1 -
|  security/commoncap.c       |   40
- ----------------------------------------
|  security/smack/smack_lsm.c |    5 -----
|  4 files changed, 1 insertions(+), 48 deletions(-)
|
| diff --git a/include/linux/security.h b/include/linux/security.h
| index fe52cde..95cb830 100644
| --- a/include/linux/security.h
| +++ b/include/linux/security.h
| @@ -63,7 +63,6 @@ extern int cap_inode_need_killpriv(struct dentry
*dentry);
|  extern int cap_inode_killpriv(struct dentry *dentry);
|  extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid,
uid_t old_suid, int flags);
|  extern void cap_task_reparent_to_init (struct task_struct *p);
| -extern int cap_task_kill(struct task_struct *p, struct siginfo *info,
int sig, u32 secid);
|  extern int cap_task_setscheduler (struct task_struct *p, int policy,
struct sched_param *lp);
|  extern int cap_task_setioprio (struct task_struct *p, int ioprio);
|  extern int cap_task_setnice (struct task_struct *p, int nice);
| @@ -2138,7 +2137,7 @@ static inline int security_task_kill (struct
task_struct *p,
|  				      struct siginfo *info, int sig,
|  				      u32 secid)
|  {
| -	return cap_task_kill(p, info, sig, secid);
| +	return 0;
|  }
|
|  static inline int security_task_wait (struct task_struct *p)
| diff --git a/security/capability.c b/security/capability.c
| index 9e99f36..2c6e06d 100644
| --- a/security/capability.c
| +++ b/security/capability.c
| @@ -40,7 +40,6 @@ static struct security_operations capability_ops = {
|  	.inode_need_killpriv =		cap_inode_need_killpriv,
|  	.inode_killpriv =		cap_inode_killpriv,
|
| -	.task_kill =			cap_task_kill,
|  	.task_setscheduler =		cap_task_setscheduler,
|  	.task_setioprio =		cap_task_setioprio,
|  	.task_setnice =			cap_task_setnice,
| diff --git a/security/commoncap.c b/security/commoncap.c
| index bb0c095..06d5c94 100644
| --- a/security/commoncap.c
| +++ b/security/commoncap.c
| @@ -540,41 +540,6 @@ int cap_task_setnice (struct task_struct *p, int
nice)
|  	return cap_safe_nice(p);
|  }
|
| -int cap_task_kill(struct task_struct *p, struct siginfo *info,
| -				int sig, u32 secid)
| -{
| -	if (info != SEND_SIG_NOINFO && (is_si_special(info) ||
SI_FROMKERNEL(info)))
| -		return 0;
| -
| -	/*
| -	 * Running a setuid root program raises your capabilities.
| -	 * Killing your own setuid root processes was previously
| -	 * allowed.
| -	 * We must preserve legacy signal behavior in this case.
| -	 */
| -	if (p->uid == current->uid)
| -		return 0;
| -
| -	/* sigcont is permitted within same session */
| -	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
| -		return 0;
| -
| -	if (secid)
| -		/*
| -		 * Signal sent as a particular user.
| -		 * Capabilities are ignored.  May be wrong, but it's the
| -		 * only thing we can do at the moment.
| -		 * Used only by usb drivers?
| -		 */
| -		return 0;
| -	if (cap_issubset(p->cap_permitted, current->cap_permitted))
| -		return 0;
| -	if (capable(CAP_KILL))
| -		return 0;
| -
| -	return -EPERM;
| -}
| -
|  /*
|   * called from kernel/sys.c for prctl(PR_CABSET_DROP)
|   * done without task_capability_lock() because it introduces
| @@ -605,11 +570,6 @@ int cap_task_setnice (struct task_struct *p, int
nice)
|  {
|  	return 0;
|  }
| -int cap_task_kill(struct task_struct *p, struct siginfo *info,
| -				int sig, u32 secid)
| -{
| -	return 0;
| -}
|  #endif
|
|  void cap_task_reparent_to_init (struct task_struct *p)
| diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
| index 770eb06..a9ca412 100644
| --- a/security/smack/smack_lsm.c
| +++ b/security/smack/smack_lsm.c
| @@ -1124,11 +1124,6 @@ static int smack_task_movememory(struct
task_struct *p)
|  static int smack_task_kill(struct task_struct *p, struct siginfo *info,
|  			   int sig, u32 secid)
|  {
| -	int rc;
| -
| -	rc = cap_task_kill(p, info, sig, secid);
| -	if (rc != 0)
| -		return rc;
|  	/*
|  	 * Special cases where signals really ought to go through
|  	 * in spite of policy. Stephen Smalley suggests it may

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHydMS+bHCR3gb8jsRAjOsAJ9uFe8/h1uBzFDtxy77haw1E7v4PACgw4kg
P7pDqvlQLP6kPWzj/KmGo00=
=4U5z
-----END PGP SIGNATURE-----
