Return-Path: <linux-kernel-owner+w=401wt.eu-S1763833AbYF0Uxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763833AbYF0Uxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762346AbYF0UwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:52:08 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40193 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759670AbYF0UwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:52:04 -0400
Date: Fri, 27 Jun 2008 15:52:00 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 1/4] security: filesystem capabilities bugfix1
Message-ID: <20080627205200.GA17415@us.ibm.com>
References: <48635799.3010500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48635799.3010500@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Bugfix for the fragile setuid fixup code in the case that filesystem
> capabilities are supported.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
>
> iD8DBQFIY1eZ+bHCR3gb8jsRAgneAJ4jvnswg0+5Rkr69YFbFYXexK8vNQCgnAS7
> jF5ZqrBAAtU7RNVHia18ODk=
> =cOzB
> -----END PGP SIGNATURE-----

> From a44789119274e6596f08f7d7b967130cf1ae7bb7 Mon Sep 17 00:00:00 2001
> From: Andrew G. Morgan <morgan@kernel.org>
> Date: Wed, 25 Jun 2008 23:12:32 -0700
> Subject: [PATCH] Security fix for experimental filesystem capability code.
> 
> This commit includes a bugfix for the fragile setuid fixup code in
> the case that filesystem capabilities are supported (in access()).
> The effect of this fix is gated on filesystem capability support
> because changing securebits is only supported when filesystem
> capabilities support is configured.)
> 
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/open.c                  |   38 +++++++++++++++++++++++---------------
>  include/linux/capability.h |    2 ++
>  include/linux/securebits.h |   15 ++++++++-------
>  kernel/capability.c        |   21 +++++++++++++++++++++
>  4 files changed, 54 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index a145008..3b53948 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -16,6 +16,7 @@
>  #include <linux/namei.h>
>  #include <linux/backing-dev.h>
>  #include <linux/capability.h>
> +#include <linux/securebits.h>
>  #include <linux/security.h>
>  #include <linux/mount.h>
>  #include <linux/vfs.h>
> @@ -425,7 +426,7 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
>  {
>  	struct nameidata nd;
>  	int old_fsuid, old_fsgid;
> -	kernel_cap_t old_cap;
> +	kernel_cap_t uninitialized_var(old_cap);  /* !SECURE_NO_SETUID_FIXUP */
>  	int res;
>  
>  	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
> @@ -433,23 +434,27 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
>  
>  	old_fsuid = current->fsuid;
>  	old_fsgid = current->fsgid;
> -	old_cap = current->cap_effective;
>  
>  	current->fsuid = current->uid;
>  	current->fsgid = current->gid;
>  
> -	/*
> -	 * Clear the capabilities if we switch to a non-root user
> -	 *
> -	 * FIXME: There is a race here against sys_capset.  The
> -	 * capabilities can change yet we will restore the old
> -	 * value below.  We should hold task_capabilities_lock,
> -	 * but we cannot because user_path_walk can sleep.
> -	 */
> -	if (current->uid)
> -		cap_clear(current->cap_effective);
> -	else
> -		current->cap_effective = current->cap_permitted;
> +	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
> +		/*
> +		 * Clear the capabilities if we switch to a non-root user
> +		 */
> +#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
> +		/*
> +		 * FIXME: There is a race here against sys_capset.  The
> +		 * capabilities can change yet we will restore the old
> +		 * value below.  We should hold task_capabilities_lock,
> +		 * but we cannot because user_path_walk can sleep.
> +		 */
> +#endif /* ndef CONFIG_SECURITY_FILE_CAPABILITIES */
> +		if (current->uid)
> +			old_cap = cap_set_effective(__cap_empty_set);
> +		else
> +			old_cap = cap_set_effective(current->cap_permitted);
> +	}
>  
>  	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
>  	if (res)
> @@ -478,7 +483,10 @@ out_path_release:
>  out:
>  	current->fsuid = old_fsuid;
>  	current->fsgid = old_fsgid;
> -	current->cap_effective = old_cap;
> +
> +	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
> +		(void) cap_set_effective(old_cap);
> +	}
>  
>  	return res;
>  }
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index fa830f8..0267384 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -501,6 +501,8 @@ extern const kernel_cap_t __cap_empty_set;
>  extern const kernel_cap_t __cap_full_set;
>  extern const kernel_cap_t __cap_init_eff_set;
>  
> +kernel_cap_t cap_set_effective(const kernel_cap_t pE_new);
> +
>  int capable(int cap);
>  int __capable(struct task_struct *t, int cap);
>  
> diff --git a/include/linux/securebits.h b/include/linux/securebits.h
> index c1f19db..92f09bd 100644
> --- a/include/linux/securebits.h
> +++ b/include/linux/securebits.h
> @@ -7,14 +7,15 @@
>     inheritance of root-permissions and suid-root executable under
>     compatibility mode. We raise the effective and inheritable bitmasks
>     *of the executable file* if the effective uid of the new process is
> -   0. If the real uid is 0, we raise the inheritable bitmask of the
> +   0. If the real uid is 0, we raise the effective (legacy) bit of the
>     executable file. */
>  #define SECURE_NOROOT			0
>  #define SECURE_NOROOT_LOCKED		1  /* make bit-0 immutable */
>  
> -/* When set, setuid to/from uid 0 does not trigger capability-"fixes"
> -   to be compatible with old programs relying on set*uid to loose
> -   privileges. When unset, setuid doesn't change privileges. */
> +/* When set, setuid to/from uid 0 does not trigger capability-"fixup".
> +   When unset, to provide compatiblility with old programs relying on
> +   set*uid to gain/lose privilege, transitions to/from uid 0 cause
> +   capabilities to be gained/lost. */
>  #define SECURE_NO_SETUID_FIXUP		2
>  #define SECURE_NO_SETUID_FIXUP_LOCKED	3  /* make bit-2 immutable */
>  
> @@ -26,10 +27,10 @@
>  #define SECURE_KEEP_CAPS		4
>  #define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */
>  
> -/* Each securesetting is implemented using two bits. One bit specify
> +/* Each securesetting is implemented using two bits. One bit specifies
>     whether the setting is on or off. The other bit specify whether the
> -   setting is fixed or not. A setting which is fixed cannot be changed
> -   from user-level. */
> +   setting is locked or not. A setting which is locked cannot be
> +   changed from user-level. */
>  #define issecure_mask(X)	(1 << (X))
>  #define issecure(X)		(issecure_mask(X) & current->securebits)
>  
> diff --git a/kernel/capability.c b/kernel/capability.c
> index cfbe442..901e0fd 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -121,6 +121,27 @@ static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
>   * uninteresting and/or not to be changed.
>   */
>  
> +/*
> + * Atomically modify the effective capabilities returning the original
> + * value. No permission check is performed here - it is assumed that the
> + * caller is permitted to set the desired effective capabilities.
> + */
> +kernel_cap_t cap_set_effective(const kernel_cap_t pE_new)
> +{
> +	kernel_cap_t pE_old;
> +
> +	spin_lock(&task_capability_lock);
> +
> +	pE_old = current->cap_effective;
> +	current->cap_effective = pE_new;
> +
> +	spin_unlock(&task_capability_lock);
> +
> +	return pE_old;
> +}
> +
> +EXPORT_SYMBOL(cap_set_effective);
> +
>  /**
>   * sys_capget - get the capabilities of a given process.
>   * @header: pointer to struct that contains capability version and
> -- 
> 1.5.3.7
> 

