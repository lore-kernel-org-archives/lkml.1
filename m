Return-Path: <linux-kernel-owner+w=401wt.eu-S1763760AbXHXVTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763760AbXHXVTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbXHXVTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:19:45 -0400
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:36005 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751888AbXHXVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:19:44 -0400
X-YMail-OSG: Ww.8XZ4VM1mnBtFBy2Yix8OFJ67Braz0iEtv8Hc699.SCfTpa__m6kHNBdjVl3QuzftKoc3JdCpnq4M86PCXF1wZl60otg6xez4Hg4GXrnOuBxMnS4yqZlcNKwHxryN9C1B1oOMltCgS26Q-
Date: Fri, 24 Aug 2007 16:19:42 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: [2.6 patch] remove securebits
Message-ID: <20070824211942.GA24478@vino.hallyn.com>
References: <20070824210649.GG30705@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824210649.GG30705@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Adrian Bunk (bunk@kernel.org):
> It seems that since it was added in kernel 2.2.0 (sic) securebits 
> was never used.
> 
> This patch therefore removes it.

Actually IIUC Andrew Morgan had plans of making securebits per-process,
which would make them far more usable.

Now maybe he'd just as soon start with a clean slate...  Andrew?

-serge

> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  include/linux/sched.h      |    1 -
>  include/linux/securebits.h |   30 ------------------------------
>  kernel/capability.c        |    1 -
>  security/commoncap.c       |   34 ++++++++++++++--------------------
>  security/dummy.c           |   16 +++++++---------
>  5 files changed, 21 insertions(+), 61 deletions(-)
> 
> 30c1d49582d183ea4a7ee0ffd886dcd9e2344115 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2b3c936..be2e9c4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -67,7 +67,6 @@ struct sched_param {
>  #include <linux/smp.h>
>  #include <linux/sem.h>
>  #include <linux/signal.h>
> -#include <linux/securebits.h>
>  #include <linux/fs_struct.h>
>  #include <linux/compiler.h>
>  #include <linux/completion.h>
> diff --git a/include/linux/securebits.h b/include/linux/securebits.h
> deleted file mode 100644
> index 5b06178..0000000
> --- a/include/linux/securebits.h
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -#ifndef _LINUX_SECUREBITS_H
> -#define _LINUX_SECUREBITS_H 1
> -
> -#define SECUREBITS_DEFAULT 0x00000000
> -
> -extern unsigned securebits;
> -
> -/* When set UID 0 has no special privileges. When unset, we support
> -   inheritance of root-permissions and suid-root executable under
> -   compatibility mode. We raise the effective and inheritable bitmasks
> -   *of the executable file* if the effective uid of the new process is
> -   0. If the real uid is 0, we raise the inheritable bitmask of the
> -   executable file. */
> -#define SECURE_NOROOT            0
> -
> -/* When set, setuid to/from uid 0 does not trigger capability-"fixes"
> -   to be compatible with old programs relying on set*uid to loose
> -   privileges. When unset, setuid doesn't change privileges. */
> -#define SECURE_NO_SETUID_FIXUP   2
> -
> -/* Each securesetting is implemented using two bits. One bit specify
> -   whether the setting is on or off. The other bit specify whether the
> -   setting is fixed or not. A setting which is fixed cannot be changed
> -   from user-level. */
> -
> -#define issecure(X) ( (1 << (X+1)) & SECUREBITS_DEFAULT ? 	\
> -		      (1 << (X)) & SECUREBITS_DEFAULT :		\
> -		      (1 << (X)) & securebits )
> -
> -#endif /* !_LINUX_SECUREBITS_H */
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 20914d8..d3696a9 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -15,7 +15,6 @@
>  #include <linux/pid_namespace.h>
>  #include <asm/uaccess.h>
>  
> -unsigned securebits = SECUREBITS_DEFAULT; /* systemwide security settings */
>  kernel_cap_t cap_bset = CAP_INIT_EFF_SET;
>  
>  /*
> diff --git a/security/commoncap.c b/security/commoncap.c
> index ff87b80..ce8f686 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -241,14 +241,12 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
>  	 *  and permitted sets of the executable file.
>  	 */
>  
> -	if (!issecure (SECURE_NOROOT)) {
> -		if (bprm->e_uid == 0 || current->uid == 0) {
> -			cap_set_full (bprm->cap_inheritable);
> -			cap_set_full (bprm->cap_permitted);
> -		}
> -		if (bprm->e_uid == 0)
> -			bprm->cap_effective = true;
> +	if (bprm->e_uid == 0 || current->uid == 0) {
> +		cap_set_full (bprm->cap_inheritable);
> +		cap_set_full (bprm->cap_permitted);
>  	}
> +	if (bprm->e_uid == 0)
> +		bprm->cap_effective = true;
>  
>  	return ret;
>  }
> @@ -393,9 +391,7 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
>  	case LSM_SETID_ID:
>  	case LSM_SETID_RES:
>  		/* Copied from kernel/sys.c:setreuid/setuid/setresuid. */
> -		if (!issecure (SECURE_NO_SETUID_FIXUP)) {
> -			cap_emulate_setxuid (old_ruid, old_euid, old_suid);
> -		}
> +		cap_emulate_setxuid (old_ruid, old_euid, old_suid);
>  		break;
>  	case LSM_SETID_FS:
>  		{
> @@ -408,16 +404,14 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
>  			 *          if not, we might be a bit too harsh here.
>  			 */
>  
> -			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
> -				if (old_fsuid == 0 && current->fsuid != 0) {
> -					cap_t (current->cap_effective) &=
> -					    ~CAP_FS_MASK;
> -				}
> -				if (old_fsuid != 0 && current->fsuid == 0) {
> -					cap_t (current->cap_effective) |=
> -					    (cap_t (current->cap_permitted) &
> -					     CAP_FS_MASK);
> -				}
> +			if (old_fsuid == 0 && current->fsuid != 0) {
> +				cap_t (current->cap_effective) &=
> +				    ~CAP_FS_MASK;
> +			}
> +			if (old_fsuid != 0 && current->fsuid == 0) {
> +				cap_t (current->cap_effective) |=
> +				    (cap_t (current->cap_permitted) &
> +				     CAP_FS_MASK);
>  			}
>  			break;
>  		}
> diff --git a/security/dummy.c b/security/dummy.c
> index 6999456..88bb1bc 100644
> --- a/security/dummy.c
> +++ b/security/dummy.c
> @@ -37,15 +37,13 @@ static int dummy_capget (struct task_struct *target, kernel_cap_t * effective,
>  			 kernel_cap_t * inheritable, kernel_cap_t * permitted)
>  {
>  	*effective = *inheritable = *permitted = 0;
> -	if (!issecure(SECURE_NOROOT)) {
> -		if (target->euid == 0) {
> -			*permitted |= (~0 & ~CAP_FS_MASK);
> -			*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
> -		}
> -		if (target->fsuid == 0) {
> -			*permitted |= CAP_FS_MASK;
> -			*effective |= CAP_FS_MASK;
> -		}
> +	if (target->euid == 0) {
> +		*permitted |= (~0 & ~CAP_FS_MASK);
> +		*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
> +	}
> +	if (target->fsuid == 0) {
> +		*permitted |= CAP_FS_MASK;
> +		*effective |= CAP_FS_MASK;
>  	}
>  	return 0;
>  }
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
