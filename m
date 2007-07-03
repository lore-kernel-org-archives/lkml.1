Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbXGCMOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbXGCMOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbXGCMOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:14:40 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:33560 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758980AbXGCMOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:14:38 -0400
Subject: Re: [PATCH 1/1] file caps: update selinux xattr hooks
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070702220627.GA12463@sergelap.austin.ibm.com>
References: <20070628182255.GA13144@sergelap.austin.ibm.com>
	 <1183387015.12218.25.camel@moss-spartans.epoch.ncsc.mil>
	 <20070702220627.GA12463@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 03 Jul 2007 08:14:06 -0400
Message-Id: <1183464846.12218.248.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-02 at 17:06 -0500, Serge E. Hallyn wrote:
> Thanks Stephen, does the following version appear correct?  It just
> checks for a different cap for security.capability, then if granted
> goes on to check FILE__GETATTR before granting setxattr or removexattr
> on any security.* xattr.
> 
> thanks,
> -serge
> 
> >From 5ec50bc22d3320565002658433829f7dc5bc0aa5 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Mon, 2 Jul 2007 14:07:51 -0400
> Subject: [PATCH 1/1] file caps: update selinux xattr hooks (v2)
> 
> SELinux does not call out to it's secondary module for setxattr
> or removexattr mediation, as the secondary module would
> incorrectly prevent writing of selinux xattrs.  This means
> that when selinux and capability are both loaded, admins will
> be able to write file capabilities with CAP_SYS_ADMIN as before,
> not with CAP_SETFCAP.
> 
> Update the selinux hooks to hardcode logic for the special
> consideration for file caps.
> 
> Note that the setxattr and removexattr logic for non selinux
> attrs appears to be identical.  So I do have another patch
> where selinux_inode_setotherxattr takes an extra argument
> u32 av (in case removexattr ever gets its own av permission)
> so removexattr can shrink and just use that.  But first I
> thought I'd see if this version is even close correct :)

Yes, looks sane, and feel free to have both hooks use a common helper
for non-selinux attributes.  I don't think you even need to bother with
the u32 av argument; if we later split the check, we can change it then
(it isn't as though these functions need to have a stable interface).

> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  security/selinux/hooks.c |   48 ++++++++++++++++++++++++++++-----------------
>  1 files changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index af42820..336525c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2289,6 +2289,25 @@ static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
>  	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
>  }
>  
> +static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
> +{
> +	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> +		     sizeof XATTR_SECURITY_PREFIX - 1)) {
> +		if (!strcmp(name, XATTR_NAME_CAPS)) {
> +			if (!capable(CAP_SETFCAP))
> +				return -EPERM;
> +		} else if (!capable(CAP_SYS_ADMIN)) {
> +			/* A different attribute in the security namespace.
> +			   Restrict to administrator. */
> +			return -EPERM;
> +		}
> +	}
> +
> +	/* Not an attribute we recognize, so just check the
> +	   ordinary setattr permission. */
> +	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
> +}
> +
>  static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
>  {
>  	struct task_security_struct *tsec = current->security;
> @@ -2299,19 +2318,8 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
>  	u32 newsid;
>  	int rc = 0;
>  
> -	if (strcmp(name, XATTR_NAME_SELINUX)) {
> -		if (!strncmp(name, XATTR_SECURITY_PREFIX,
> -			     sizeof XATTR_SECURITY_PREFIX - 1) &&
> -		    !capable(CAP_SYS_ADMIN)) {
> -			/* A different attribute in the security namespace.
> -			   Restrict to administrator. */
> -			return -EPERM;
> -		}
> -
> -		/* Not an attribute we recognize, so just check the
> -		   ordinary setattr permission. */
> -		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
> -	}
> +	if (strcmp(name, XATTR_NAME_SELINUX))
> +		return selinux_inode_setotherxattr(dentry, name);
>  
>  	sbsec = inode->i_sb->s_security;
>  	if (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)
> @@ -2387,11 +2395,15 @@ static int selinux_inode_removexattr (struct dentry *dentry, char *name)
>  {
>  	if (strcmp(name, XATTR_NAME_SELINUX)) {
>  		if (!strncmp(name, XATTR_SECURITY_PREFIX,
> -			     sizeof XATTR_SECURITY_PREFIX - 1) &&
> -		    !capable(CAP_SYS_ADMIN)) {
> -			/* A different attribute in the security namespace.
> -			   Restrict to administrator. */
> -			return -EPERM;
> +			     sizeof XATTR_SECURITY_PREFIX - 1)) {
> +			if (!strcmp(name, XATTR_NAME_CAPS)) {
> +				if (!capable(CAP_SETFCAP))
> +					return -EPERM;
> +			} else if (!capable(CAP_SYS_ADMIN)) {
> +				/* A different attribute in the security
> +				   namespace.  Restrict to administrator. */
> +				return -EPERM;
> +			}
>  		}
>  
>  		/* Not an attribute we recognize, so just check the
-- 
Stephen Smalley
National Security Agency

