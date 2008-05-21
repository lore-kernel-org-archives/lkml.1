Return-Path: <linux-kernel-owner+w=401wt.eu-S937053AbYEUUej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937053AbYEUUej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763962AbYEUUe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:34:29 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44852 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbYEUUe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:34:27 -0400
Date: Wed, 21 May 2008 15:34:05 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: protect legacy apps from insufficient
	privilege
Message-ID: <20080521203405.GA27901@sergelap.wowway.com>
References: <483444C1.6050308@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483444C1.6050308@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> This is a fail-safe additional feature for filesystem capability support.
>
> Cheers
>
> Andrew
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
>
> iD8DBQFINES/+bHCR3gb8jsRAmPdAJsG8fKTNBXYmUb3CJDchLQ1MCYgDQCg2uQl
> ltlVX1O9D6BtDK/4+gsoq8U=
> =AUc0
> -----END PGP SIGNATURE-----

> From 916b252d3b631214acea6df6c61e94ce6770fdf7 Mon Sep 17 00:00:00 2001
> From: Andrew G. Morgan <morgan@kernel.org>
> Date: Thu, 15 May 2008 23:17:13 -0700
> Subject: [PATCH] Protect legacy applications from executing with insufficient privilege.
> 
> When cap_bset suppresses some of the forced (fP) capabilities of a
> file, it is generally only safe to execute the program if it
> understands how to recognize it doesn't have enough privilege to work
> correctly. For legacy applications (fE!=0), which have no
> non-destructive way to determine that they are missing privilege, we
> fail to execute (EPERM) any executable that requires fP capabilities,
> but would otherwise get pP' < fP. This is a fail-safe permission check.
> 
> For some discussion of why it is problematic for (legacy) privileged
> applications to run with less than the set of capabilities requested
> for them, see:
> 
>  http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html
> 
> With this iteration of this support, we do not include setuid-0 based
> privilege protection from the bounding set. That is, the admin can still
> (ab)use the bounding set to suppress the privileges of a setuid-0
> program.
> 
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

Assuming (as it appears) the only change from last time is that you
dropped the part changing cap_bprm_apply_creds() contraints for a
ptraced process, then

Acked-by: Serge Hallyn <serue@us.ibm.com>

I'll try to give it a good test-run next week.

thanks,
-serge

> ---
>  include/linux/binfmts.h |    2 +-
>  security/commoncap.c    |  109 ++++++++++++++++++++++++++---------------------
>  2 files changed, 62 insertions(+), 49 deletions(-)
> 
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index ee0ed48..826f623 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -38,7 +38,7 @@ struct linux_binprm{
>  		     misc_bang:1;
>  	struct file * file;
>  	int e_uid, e_gid;
> -	kernel_cap_t cap_inheritable, cap_permitted;
> +	kernel_cap_t cap_post_exec_permitted;
>  	bool cap_effective;
>  	void *security;
>  	int argc, envc;
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 5edabc7..84f1ab5 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -155,8 +155,7 @@ void cap_capset_set (struct task_struct *target, kernel_cap_t *effective,
>  
>  static inline void bprm_clear_caps(struct linux_binprm *bprm)
>  {
> -	cap_clear(bprm->cap_inheritable);
> -	cap_clear(bprm->cap_permitted);
> +	cap_clear(bprm->cap_post_exec_permitted);
>  	bprm->cap_effective = false;
>  }
>  
> @@ -191,6 +190,7 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
>  {
>  	__u32 magic_etc;
>  	unsigned tocopy, i;
> +	int ret;
>  
>  	if (size < sizeof(magic_etc))
>  		return -EINVAL;
> @@ -218,19 +218,42 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
>  		bprm->cap_effective = false;
>  	}
>  
> -	for (i = 0; i < tocopy; ++i) {
> -		bprm->cap_permitted.cap[i] =
> -			le32_to_cpu(caps->data[i].permitted);
> -		bprm->cap_inheritable.cap[i] =
> -			le32_to_cpu(caps->data[i].inheritable);
> -	}
> -	while (i < VFS_CAP_U32) {
> -		bprm->cap_permitted.cap[i] = 0;
> -		bprm->cap_inheritable.cap[i] = 0;
> -		i++;
> +	ret = 0;
> +
> +	CAP_FOR_EACH_U32(i) {
> +		if (i >= tocopy) {
> +			/*
> +			 * Legacy capability sets have no upper bits
> +			 */
> +			bprm->cap_post_exec_permitted.cap[i] = 0;
> +		} else {
> +			__u32 value_cpu;
> +			/*
> +			 * pP' = (X & fP) | (pI & fI)
> +			 */
> +			value_cpu = le32_to_cpu(caps->data[i].permitted);
> +			bprm->cap_post_exec_permitted.cap[i] = (
> +					current->cap_bset.cap[i] & value_cpu
> +				) | (
> +					current->cap_inheritable.cap[i] &
> +					le32_to_cpu(caps->data[i].inheritable)
> +				);
> +			if (value_cpu &
> +			    ~bprm->cap_post_exec_permitted.cap[i]) {
> +				/*
> +				 * insufficient to execute correctly
> +				 */
> +				ret = -EPERM;
> +			}
> +		}
>  	}
>  
> -	return 0;
> +	/*
> +	 * For legacy apps, with no internal support for recognizing they
> +	 * do not have enough capabilities, we return an error if they are
> +	 * missing some "forced" (aka file-permitted) capabilities.
> +	 */
> +	return (bprm->cap_effective ? ret : 0);
>  }
>  
>  /* Locate any VFS capabilities: */
> @@ -262,9 +285,9 @@ static int get_file_caps(struct linux_binprm *bprm)
>  		goto out;
>  
>  	rc = cap_from_disk(&vcaps, bprm, rc);
> -	if (rc)
> +	if (rc == -EINVAL)
>  		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
> -			__func__, rc, bprm->filename);
> +		       __func__, rc, bprm->filename);
>  
>  out:
>  	dput(dentry);
> @@ -297,25 +320,24 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
>  	int ret;
>  
>  	ret = get_file_caps(bprm);
> -	if (ret)
> -		printk(KERN_NOTICE "%s: get_file_caps returned %d for %s\n",
> -			__func__, ret, bprm->filename);
> -
> -	/*  To support inheritance of root-permissions and suid-root
> -	 *  executables under compatibility mode, we raise all three
> -	 *  capability sets for the file.
> -	 *
> -	 *  If only the real uid is 0, we only raise the inheritable
> -	 *  and permitted sets of the executable file.
> -	 */
>  
> -	if (!issecure (SECURE_NOROOT)) {
> +	if (!issecure(SECURE_NOROOT)) {
> +		/*
> +		 * To support inheritance of root-permissions and suid-root
> +		 * executables under compatibility mode, we override the
> +		 * capability sets for the file.
> +		 *
> +		 * If only the real uid is 0, we do not set the effective
> +		 * bit.
> +		 */
>  		if (bprm->e_uid == 0 || current->uid == 0) {
> -			cap_set_full (bprm->cap_inheritable);
> -			cap_set_full (bprm->cap_permitted);
> +			/* pP' = (cap_bset & ~0) | (pI & ~0) */
> +			bprm->cap_post_exec_permitted = cap_combine(
> +				current->cap_bset, current->cap_inheritable
> +				);
> +			bprm->cap_effective = (bprm->e_uid == 0);
> +			ret = 0;
>  		}
> -		if (bprm->e_uid == 0)
> -			bprm->cap_effective = true;
>  	}
>  
>  	return ret;
> @@ -323,17 +345,9 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
>  
>  void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
>  {
> -	/* Derived from fs/exec.c:compute_creds. */
> -	kernel_cap_t new_permitted, working;
> -
> -	new_permitted = cap_intersect(bprm->cap_permitted,
> -				 current->cap_bset);
> -	working = cap_intersect(bprm->cap_inheritable,
> -				 current->cap_inheritable);
> -	new_permitted = cap_combine(new_permitted, working);
> -
>  	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
> -	    !cap_issubset (new_permitted, current->cap_permitted)) {
> +	    !cap_issubset(bprm->cap_post_exec_permitted,
> +			  current->cap_permitted)) {
>  		set_dumpable(current->mm, suid_dumpable);
>  		current->pdeath_signal = 0;
>  
> @@ -343,8 +357,9 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
>  				bprm->e_gid = current->gid;
>  			}
>  			if (!capable (CAP_SETPCAP)) {
> -				new_permitted = cap_intersect (new_permitted,
> -							current->cap_permitted);
> +				bprm->cap_post_exec_permitted = cap_intersect(
> +					bprm->cap_post_exec_permitted,
> +					current->cap_permitted);
>  			}
>  		}
>  	}
> @@ -356,9 +371,9 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
>  	 * in the init_task struct. Thus we skip the usual
>  	 * capability rules */
>  	if (!is_global_init(current)) {
> -		current->cap_permitted = new_permitted;
> +		current->cap_permitted = bprm->cap_post_exec_permitted;
>  		if (bprm->cap_effective)
> -			current->cap_effective = new_permitted;
> +			current->cap_effective = bprm->cap_post_exec_permitted;
>  		else
>  			cap_clear(current->cap_effective);
>  	}
> @@ -373,9 +388,7 @@ int cap_bprm_secureexec (struct linux_binprm *bprm)
>  	if (current->uid != 0) {
>  		if (bprm->cap_effective)
>  			return 1;
> -		if (!cap_isclear(bprm->cap_permitted))
> -			return 1;
> -		if (!cap_isclear(bprm->cap_inheritable))
> +		if (!cap_isclear(bprm->cap_post_exec_permitted))
>  			return 1;
>  	}
>  
> -- 
> 1.5.3.7
> 

