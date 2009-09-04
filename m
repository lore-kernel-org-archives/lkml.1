Return-Path: <linux-kernel-owner+w=401wt.eu-S932720AbZIDPtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbZIDPtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932335AbZIDPtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:49:21 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44332 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbZIDPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:49:20 -0400
Date: Fri, 4 Sep 2009 10:49:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: sds@tycho.nsa.gov, jmorris@namei.org, casey@schaufler-ca.com,
       gregkh@suse.de, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] LSM/SELinux: inode_{get,set,notify}secctx hooks to
	access LSM security context information.
Message-ID: <20090904154917.GB15342@us.ibm.com>
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov> <1252002358-6612-3-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252002358-6612-3-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David P. Quigley (dpquigl@tycho.nsa.gov):
> This patch introduces three new hooks. The inode_getsecctx hook is used to get
> all relevant information from an LSM about an inode. The inode_setsecctx is

The 'security_xyz_getctx' namespace is getting a bit polluted.  I suspect
I should take this as a hint to rename my
	selinux_file_get_ctx()
to
	selinux_checkpoint_file()
or
	selinux_checkpoint_file_ctx()

to more clearly distinguish it from your hooks and the existing
secid_to_secctx() set of .hooks

> used to set both the in-core and on-disk state for the inode based on a context
> derived from inode_getsecctx.The final hook inode_notifysecctx will notify the
> LSM of a change for the in-core state of the inode in question. These hooks are
> for use in the labeled NFS code and addresses concerns of how to set security
> on an inode in a multi-xattr LSM. For historical reasons Stephen Smalley's
> explanation of the reason for these hooks is pasted below.
> 
> Quote Stephen Smalley
> 
> inode_setsecctx:  Change the security context of an inode.  Updates the
> in core security context managed by the security module and invokes the
> fs code as needed (via __vfs_setxattr_noperm) to update any backing
> xattrs that represent the context.  Example usage:  NFS server invokes
> this hook to change the security context in its incore inode and on the
> backing file system to a value provided by the client on a SETATTR
> operation.

So this is only to be called by kernel code, right?  Hence no
authorization checks needed?

> inode_notifysecctx:  Notify the security module of what the security
> context of an inode should be.  Initializes the incore security context
> managed by the security module for this inode.  Example usage:  NFS
> client invokes this hook to initialize the security context in its
> incore inode to the value provided by the server for the file when the
> server returned the file's attributes to the client.
> 
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  include/linux/security.h   |   55 ++++++++++++++++++++++++++++++++++++++++++++
>  security/capability.c      |   17 +++++++++++++
>  security/security.c        |   18 ++++++++++++++
>  security/selinux/hooks.c   |   29 +++++++++++++++++++++++
>  security/smack/smack_lsm.c |   24 +++++++++++++++++++
>  5 files changed, 143 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 1f16eea..a88fc49 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1351,6 +1351,41 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	audit_rule_init.
>   *	@rule contains the allocated rule
>   *
> + * @inode_notifysecctx:
> + *	Notify the security module of what the security context of an inode
> + *	should be.  Initializes the incore security context managed by the
> + *	security module for this inode.  Example usage:  NFS client invokes
> + *	this hook to initialize the security context in its incore inode to the
> + *	value provided by the server for the file when the server returned the
> + *	file's attributes to the client.
> + *
> + * 	Must be called with inode->i_mutex locked.
> + *
> + * 	@inode we wish to set the security context of.
> + * 	@ctx contains the string which we wish to set in the inode.
> + * 	@ctxlen contains the length of @ctx.
> + *
> + * @inode_setsecctx:
> + * 	Change the security context of an inode.  Updates the
> + * 	incore security context managed by the security module and invokes the
> + * 	fs code as needed (via __vfs_setxattr_noperm) to update any backing
> + * 	xattrs that represent the context.  Example usage:  NFS server invokes
> + * 	this hook to change the security context in its incore inode and on the
> + * 	backing filesystem to a value provided by the client on a SETATTR
> + * 	operation.

If someone is using fs/cachefiles, do these changes get automatically
kicked up to the cached view?

> + * 	Must be called with inode->i_mutex locked.
> + *
> + * 	@dentry contains the inode we wish to set the security context of.
> + * 	@ctx contains the string which we wish to set in the inode.
> + * 	@ctxlen contains the length of @ctx.
> + *
> + * @inode_getsecctx:
> + * 	Returns a string containing all relavent security context information

Is it worth spelling out even more clearly that the string needs to be freed
by the caller?

> + *
> + * 	@inode we wish to set the security context of.
> + *	@ctx is a pointer in which to place the allocated security context.
> + *	@ctxlen points to the place to put the length of @ctx.
>   * This is the main security structure.
>   */
>  struct security_operations {
> @@ -1556,6 +1591,10 @@ struct security_operations {
>  	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
>  	void (*release_secctx) (char *secdata, u32 seclen);
> 
> +	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
> +	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
> +	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
> +
>  #ifdef CONFIG_SECURITY_NETWORK
>  	int (*unix_stream_connect) (struct socket *sock,
>  				    struct socket *other, struct sock *newsk);
> @@ -1796,6 +1835,9 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
>  int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
>  void security_release_secctx(char *secdata, u32 seclen);
> 
> +int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
> +int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
> +int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
>  #else /* CONFIG_SECURITY */
>  struct security_mnt_opts {
>  };
> @@ -2537,6 +2579,19 @@ static inline int security_secctx_to_secid(const char *secdata,
>  static inline void security_release_secctx(char *secdata, u32 seclen)
>  {
>  }
> +
> +static inline int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif	/* CONFIG_SECURITY */
> 
>  #ifdef CONFIG_SECURITY_NETWORK
> diff --git a/security/capability.c b/security/capability.c
> index 88f752e..f77684f 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -792,6 +792,20 @@ static void cap_release_secctx(char *secdata, u32 seclen)
>  {
>  }
> 
> +static int cap_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
> +{
> +	return 0;
> +}
> +
> +static int cap_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
> +{
> +	return 0;
> +}
> +
> +static int cap_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
> +{
> +	return 0;
> +}
>  #ifdef CONFIG_KEYS
>  static int cap_key_alloc(struct key *key, const struct cred *cred,
>  			 unsigned long flags)
> @@ -992,6 +1006,9 @@ void security_fixup_ops(struct security_operations *ops)
>  	set_to_cap_if_null(ops, secid_to_secctx);
>  	set_to_cap_if_null(ops, secctx_to_secid);
>  	set_to_cap_if_null(ops, release_secctx);
> +	set_to_cap_if_null(ops, inode_notifysecctx);
> +	set_to_cap_if_null(ops, inode_setsecctx);
> +	set_to_cap_if_null(ops, inode_getsecctx);
>  #ifdef CONFIG_SECURITY_NETWORK
>  	set_to_cap_if_null(ops, unix_stream_connect);
>  	set_to_cap_if_null(ops, unix_may_send);
> diff --git a/security/security.c b/security/security.c
> index dc7674f..42a6d28 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -959,6 +959,24 @@ void security_release_secctx(char *secdata, u32 seclen)
>  }
>  EXPORT_SYMBOL(security_release_secctx);
> 
> +int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
> +{
> +	return security_ops->inode_notifysecctx(inode, ctx, ctxlen);
> +}
> +EXPORT_SYMBOL(security_inode_notifysecctx);
> +
> +int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
> +{
> +	return security_ops->inode_setsecctx(dentry, ctx, ctxlen);
> +}
> +EXPORT_SYMBOL(security_inode_setsecctx);
> +
> +int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
> +{
> +	return security_ops->inode_getsecctx(inode, ctx, ctxlen);
> +}
> +EXPORT_SYMBOL(security_inode_getsecctx);
> +
>  #ifdef CONFIG_SECURITY_NETWORK
> 
>  int security_unix_stream_connect(struct socket *sock, struct socket *other,
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 8d8b69c..f1d5677 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5252,6 +5252,32 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
>  	kfree(secdata);
>  }
> 
> +/*
> + *	called with inode->i_mutex locked
> + */
> +static int selinux_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
> +{
> +	return selinux_inode_setsecurity(inode, XATTR_SELINUX_SUFFIX, ctx, ctxlen, 0);
> +}
> +
> +/*
> + *	called with inode->i_mutex locked
> + */
> +static int selinux_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
> +{
> +	return __vfs_setxattr_noperm(dentry, XATTR_NAME_SELINUX, ctx, ctxlen, 0);
> +}
> +
> +static int selinux_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
> +{
> +	int len = 0;
> +	len = selinux_inode_getsecurity(inode, XATTR_SELINUX_SUFFIX,
> +						ctx, true);
> +	if (len < 0)
> +		return len;
> +	*ctxlen = len;
> +	return 0;
> +}
>  #ifdef CONFIG_KEYS
> 
>  static int selinux_key_alloc(struct key *k, const struct cred *cred,
> @@ -5448,6 +5474,9 @@ static struct security_operations selinux_ops = {
>  	.secid_to_secctx =		selinux_secid_to_secctx,
>  	.secctx_to_secid =		selinux_secctx_to_secid,
>  	.release_secctx =		selinux_release_secctx,
> +	.inode_notifysecctx =		selinux_inode_notifysecctx,
> +	.inode_setsecctx =		selinux_inode_setsecctx,
> +	.inode_getsecctx =		selinux_inode_getsecctx,
> 
>  	.unix_stream_connect =		selinux_socket_unix_stream_connect,
>  	.unix_may_send =		selinux_socket_unix_may_send,
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 0023182..62af40e 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3029,6 +3029,27 @@ static void smack_release_secctx(char *secdata, u32 seclen)
>  {
>  }
> 
> +static int smack_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
> +{
> +	return smack_inode_setsecurity(inode, XATTR_SMACK_SUFFIX, ctx, ctxlen, 0);
> +}
> +
> +static int smack_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
> +{
> +	return __vfs_setxattr_noperm(dentry, XATTR_NAME_SMACK, ctx, ctxlen, 0);	
> +}
> +
> +static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
> +{
> +	int len = 0;
> +	len = smack_inode_getsecurity(inode, XATTR_SMACK_SUFFIX, ctx, true);
> +
> +	if (len < 0)
> +		return len;
> +	*ctxlen = len;
> +	return 0;
> +}
> +
>  struct security_operations smack_ops = {
>  	.name =				"smack",
> 
> @@ -3155,6 +3176,9 @@ struct security_operations smack_ops = {
>  	.secid_to_secctx = 		smack_secid_to_secctx,
>  	.secctx_to_secid = 		smack_secctx_to_secid,
>  	.release_secctx = 		smack_release_secctx,
> +	.inode_notifysecctx =		smack_inode_notifysecctx,
> +	.inode_setsecctx =		smack_inode_setsecctx,
> +	.inode_getsecctx =		smack_inode_getsecctx,
>  };
> 
> 
> -- 
> 1.5.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
