Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbXKZVgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbXKZVgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbXKZVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:36:34 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34634 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbXKZVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:36:32 -0500
Date: Mon, 26 Nov 2007 15:36:31 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: akpm@osdl.org, torvalds@osdl.org, Andrew Morgan <morgan@kernel.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] -mm (2.4.26-rc3-mm1) v2  Smack using capabilities 32
	and 33
Message-ID: <20071126213631.GA14892@sergelap.austin.ibm.com>
References: <474B2EE0.5080102@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474B2EE0.5080102@schaufler-ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> This patch takes advantage of the increase in capability bits
> to allocate capabilities for Mandatory Access Control. Whereas
> Smack was overloading a previously allocated capability it is
> now using a pair, one for overriding access control checks and
> the other for changes to the MAC configuration.
> 
> The two capabilities allocated should be obvious in their intent.
> The comments in capability.h are intended to make it clear that
> there is no intention that implementations of MAC LSM modules
> be any more constrained by the presence of these capabilities
> than an implementation of DAC LSM modules are by the analogous
> DAC capabilities.
> 
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Looks good from here.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> 
> ---
> 
> The companion patch for libcap-2.02 is provided as an attachment.
> The attachment is not a kernel patch, although it would be easy to
> mistake it for one.
> 
> Introduces CAP_FS_MASK_B1 and uses it as appropriate. I think that
> I found all the places it needs to be used, but don't hesitate to
> let me know if I missed something.
> 
> Thank you.
> 
>  include/linux/capability.h |   24 ++++++++++++++++++++++--
>  security/smack/smack.h     |    8 --------
>  security/smack/smack_lsm.c |    8 ++++----
>  security/smack/smackfs.c   |   12 ++++++------
>  4 files changed, 32 insertions(+), 20 deletions(-)
> 
> diff -uprN -X linux-2.6.24-rc3-mm1-base/Documentation/dontdiff linux-2.6.24-rc3-mm1-base/include/linux/capability.h linux-2.6.24-rc3-mm1-smack/include/linux/capability.h
> --- linux-2.6.24-rc3-mm1-base/include/linux/capability.h	2007-11-22 01:51:36.000000000 -0800
> +++ linux-2.6.24-rc3-mm1-smack/include/linux/capability.h	2007-11-25 21:38:34.000000000 -0800
> @@ -314,6 +314,23 @@ typedef struct kernel_cap_struct {
> 
>  #define CAP_SETFCAP	     31
> 
> +/* Override MAC access.
> +   The base kernel enforces no MAC policy.
> +   An LSM may enforce a MAC policy, and if it does and it chooses
> +   to implement capability based overrides of that policy, this is
> +   the capability it should use to do so. */
> +
> +#define CAP_MAC_OVERRIDE     32
> +
> +/* Allow MAC configuration or state changes.
> +   The base kernel requires no MAC configuration.
> +   An LSM may enforce a MAC policy, and if it does and it chooses
> +   to implement capability based checks on modifications to that
> +   policy or the data required to maintain it, this is the
> +   capability it should use to do so. */
> +
> +#define CAP_MAC_ADMIN        33
> +
>  /*
>   * Bit location of each capability (used by user-space library and kernel)
>   */
> @@ -336,6 +353,8 @@ typedef struct kernel_cap_struct {
>  			    | CAP_TO_MASK(CAP_FOWNER)		\
>  			    | CAP_TO_MASK(CAP_FSETID))
> 
> +# define CAP_FS_MASK_B1     (CAP_TO_MASK(CAP_MAC_OVERRIDE))
> +
>  #if _LINUX_CAPABILITY_U32S != 2
>  # error Fix up hand-coded capability macro initializers
>  #else /* HAND-CODED capability initializers */
> @@ -343,8 +362,9 @@ typedef struct kernel_cap_struct {
>  # define CAP_EMPTY_SET    {{ 0, 0 }}
>  # define CAP_FULL_SET     {{ ~0, ~0 }}
>  # define CAP_INIT_EFF_SET {{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }}
> -# define CAP_FS_SET       {{ CAP_FS_MASK_B0, 0 }}
> -# define CAP_NFSD_SET     {{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), 0 }}
> +# define CAP_FS_SET       {{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 } }
> +# define CAP_NFSD_SET     {{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
> +			     CAP_FS_MASK_B1 } }
> 
>  #endif /* _LINUX_CAPABILITY_U32S != 2 */
> 
> diff -uprN -X linux-2.6.24-rc3-mm1-base/Documentation/dontdiff linux-2.6.24-rc3-mm1-base/security/smack/smackfs.c linux-2.6.24-rc3-mm1-smack/security/smack/smackfs.c
> --- linux-2.6.24-rc3-mm1-base/security/smack/smackfs.c	2007-11-22 01:51:43.000000000 -0800
> +++ linux-2.6.24-rc3-mm1-smack/security/smack/smackfs.c	2007-11-24 11:29:29.000000000 -0800
> @@ -241,7 +241,7 @@ static ssize_t smk_write_load(struct fil
>  	 * No partial writes.
>  	 * Enough data must be present.
>  	 */
> -	if (!capable(CAP_MAC_OVERRIDE))
> +	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
>  	if (*ppos != 0)
>  		return -EINVAL;
> @@ -474,7 +474,7 @@ static ssize_t smk_write_cipso(struct fi
>  	 * No partial writes.
>  	 * Enough data must be present.
>  	 */
> -	if (!capable(CAP_MAC_OVERRIDE))
> +	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
>  	if (*ppos != 0)
>  		return -EINVAL;
> @@ -601,7 +601,7 @@ static ssize_t smk_write_doi(struct file
>  	char temp[80];
>  	int i;
> 
> -	if (!capable(CAP_MAC_OVERRIDE))
> +	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
> 
>  	if (count >= sizeof(temp) || count == 0)
> @@ -666,7 +666,7 @@ static ssize_t smk_write_direct(struct f
>  	char temp[80];
>  	int i;
> 
> -	if (!capable(CAP_MAC_OVERRIDE))
> +	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
> 
>  	if (count >= sizeof(temp) || count == 0)
> @@ -747,7 +747,7 @@ static ssize_t smk_write_ambient(struct 
>  	char in[SMK_LABELLEN];
>  	char *smack;
> 
> -	if (!capable(CAP_MAC_OVERRIDE))
> +	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
> 
>  	if (count >= SMK_LABELLEN)
> @@ -840,7 +840,7 @@ static ssize_t smk_write_nltype(struct f
>  	char *cp;
>  	int i;
> 
> -	if (!capable(CAP_MAC_OVERRIDE))
> +	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
> 
>  	if (count >= 40)
> diff -uprN -X linux-2.6.24-rc3-mm1-base/Documentation/dontdiff linux-2.6.24-rc3-mm1-base/security/smack/smack.h linux-2.6.24-rc3-mm1-smack/security/smack/smack.h
> --- linux-2.6.24-rc3-mm1-base/security/smack/smack.h	2007-11-22 01:51:43.000000000 -0800
> +++ linux-2.6.24-rc3-mm1-smack/security/smack/smack.h	2007-11-22 03:03:19.000000000 -0800
> @@ -162,14 +162,6 @@ struct smack_known {
>  #define MAY_NOT		0
> 
>  /*
> - * There are not enough CAP bits available to make this
> - * real, so Casey borrowed the capability that looks to
> - * him like it has the best balance of similarity amd
> - * low use.
> - */
> -#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE
> -
> -/*
>   * These functions are in smack_lsm.c
>   */
>  struct inode_smack *new_inode_smack(char *);
> diff -uprN -X linux-2.6.24-rc3-mm1-base/Documentation/dontdiff linux-2.6.24-rc3-mm1-base/security/smack/smack_lsm.c linux-2.6.24-rc3-mm1-smack/security/smack/smack_lsm.c
> --- linux-2.6.24-rc3-mm1-base/security/smack/smack_lsm.c	2007-11-22 01:51:43.000000000 -0800
> +++ linux-2.6.24-rc3-mm1-smack/security/smack/smack_lsm.c	2007-11-24 11:31:43.000000000 -0800
> @@ -585,7 +585,7 @@ static int smack_inode_setxattr(struct d
>  				void *value, size_t size, int flags)
>  {
>  	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
> -		!__capable(current, CAP_MAC_OVERRIDE))
> +		!__capable(current, CAP_MAC_ADMIN))
>  		return -EPERM;
> 
>  	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> @@ -649,14 +649,14 @@ static int smack_inode_getxattr(struct d
>   * @dentry: the object
>   * @name: name of the attribute
>   *
> - * Removing the Smack attribute requires CAP_MAC_OVERRIDE
> + * Removing the Smack attribute requires CAP_MAC_ADMIN
>   *
>   * Returns 0 if access is permitted, an error code otherwise
>   */
>  static int smack_inode_removexattr(struct dentry *dentry, char *name)
>  {
>  	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
> -		!__capable(current, CAP_MAC_OVERRIDE))
> +		!__capable(current, CAP_MAC_ADMIN))
>  		return -EPERM;
> 
>  	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> @@ -1956,7 +1956,7 @@ static int smack_setprocattr(struct task
>  {
>  	char *newsmack;
> 
> -	if (!__capable(p, CAP_MAC_OVERRIDE))
> +	if (!__capable(p, CAP_MAC_ADMIN))
>  		return -EPERM;
> 
>  	/*
> 

> diff -uprN libcap-2.02/libcap/include/linux/capability.h libcap-2.02-smack/libcap/include/linux/capability.h
> --- libcap-2.02/libcap/include/linux/capability.h	2007-11-10 09:34:04.000000000 -0800
> +++ libcap-2.02-smack/libcap/include/linux/capability.h	2007-11-25 20:51:56.000000000 -0800
> @@ -314,6 +314,23 @@ typedef struct kernel_cap_struct {
> 
>  #define CAP_SETFCAP	     31
> 
> +/* Override MAC access.
> +   The base kernel enforces no MAC policy.
> +   An LSM may enforce a MAC policy, and if it does and it chooses
> +   to implement capability based overrides of that policy, this is
> +   the capability it should use to do so. */
> +
> +#define CAP_MAC_OVERRIDE     32
> +
> +/* Allow MAC configuration or state changes.
> +   The base kernel requires no MAC configuration.
> +   An LSM may enforce a MAC policy, and if it does and it chooses
> +   to implement capability based checks on modifications to that
> +   policy or the data required to maintain it, this is the
> +   capability it should use to do so. */
> +
> +#define CAP_MAC_ADMIN        33
> +
>  /*
>   * Bit location of each capability (used by user-space library and kernel)
>   */
> @@ -336,6 +353,8 @@ typedef struct kernel_cap_struct {
>  			    |CAP_TO_MASK(CAP_FOWNER)            \
>  			    |CAP_TO_MASK(CAP_FSETID))
> 
> +# define CAP_FS_MASK_B1     (CAP_TO_MASK(CAP_MAC_OVERRIDE))
> +
>  #if _LINUX_CAPABILITY_U32S != 2
>  # error Fix up hand-coded capability macro initializers
>  #else /* HAND-CODED capability initializers */
> @@ -343,8 +362,9 @@ typedef struct kernel_cap_struct {
>  # define CAP_EMPTY_SET    {{ 0, 0 }}
>  # define CAP_FULL_SET     {{ ~0, ~0 }}
>  # define CAP_INIT_EFF_SET {{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }}
> -# define CAP_FS_SET       {{ CAP_FS_MASK_B0, 0 }}
> -# define CAP_NFSD_SET     {{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), 0 }}
> +# define CAP_FS_SET       {{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 }}
> +# define CAP_NFSD_SET     {{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
> +			     CAP_FS_MASK_B1 }}
> 
>  #endif /* _LINUX_CAPABILITY_U32S != 2 */
> 

