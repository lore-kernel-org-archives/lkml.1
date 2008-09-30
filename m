Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbYI3UPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbYI3UPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYI3UP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:15:27 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58583 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYI3UP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:15:26 -0400
Date: Tue, 30 Sep 2008 15:15:24 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 03/14] Security: Add hook to calculate context based on
	a negative dentry.
Message-ID: <20080930201524.GC21039@us.ibm.com>
References: <1222707986-26606-1-git-send-email-dpquigl@tycho.nsa.gov> <1222707986-26606-4-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222707986-26606-4-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David P. Quigley (dpquigl@tycho.nsa.gov):
> There is a time where we need to calculate a context without the
> inode having been created yet. To do this we take the negative dentry and
> calculate a context based on the process and the parent directory contexts.
> 
> Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> ---
>  include/linux/security.h |   14 ++++++++++++++
>  security/security.c      |    7 +++++++
>  security/selinux/hooks.c |   36 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 57 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 8b5b041..42b9128 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1379,6 +1379,9 @@ struct security_operations {
>  	void (*sb_clone_mnt_opts) (const struct super_block *oldsb,
>  				   struct super_block *newsb);
>  	int (*sb_parse_opts_str) (char *options, struct security_mnt_opts *opts);
> +	int (*dentry_init_security) (struct dentry *dentry, int mode,
> +				     void **ctx, u32 *ctxlen);

This of course needs a description at top of include/linux/security.h.

> +
> 
>  	int (*inode_alloc_security) (struct inode *inode);
>  	void (*inode_free_security) (struct inode *inode);
> @@ -1651,6 +1654,8 @@ int security_sb_set_mnt_opts(struct super_block *sb, struct security_mnt_opts *o
>  void security_sb_clone_mnt_opts(const struct super_block *oldsb,
>  				struct super_block *newsb);
>  int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts);
> +int security_dentry_init_security (struct dentry *dentry, int mode,
> +				   void **ctx, u32 *ctxlen);
> 
>  int security_inode_alloc(struct inode *inode);
>  void security_inode_free(struct inode *inode);
> @@ -1994,6 +1999,15 @@ static inline int security_inode_alloc(struct inode *inode)
>  static inline void security_inode_free(struct inode *inode)
>  { }
> 
> +static inline int security_dentry_init_security (struct dentry *dentry,
> +						 int mode,
> +						 void **ctx,
> +						 u32 *ctxlen)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +
>  static inline int security_inode_init_security(struct inode *inode,
>  						struct inode *dir,
>  						char **name,
> diff --git a/security/security.c b/security/security.c
> index d0fd42a..b22a110 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -349,6 +349,13 @@ void security_inode_free(struct inode *inode)
>  	security_ops->inode_free_security(inode);
>  }
> 
> +int security_dentry_init_security (struct dentry *dentry, int mode,
> +				   void **ctx, u32 *ctxlen)
> +{
> +	return security_ops->dentry_init_security (dentry, mode, ctx, ctxlen);
> +}
> +EXPORT_SYMBOL(security_dentry_init_security);
> +
>  int security_inode_init_security(struct inode *inode, struct inode *dir,
>  				  char **name, void **value, size_t *len)
>  {
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index b07871b..680db1d 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2504,6 +2504,41 @@ static void selinux_inode_free_security(struct inode *inode)
>  	inode_free_security(inode);
>  }
> 
> +/*
> + * For now, we need a way to compute a SID for

Just 'Compute a SID for...' ?

> + * a dentry as the inode is not yet available
> + * (and under NFSv4 has no label backed by an EA anyway.
> + */
> +static int selinux_dentry_init_security(struct dentry *dentry, int mode, void **ctx, u32 *ctxlen)
> +{
> +	struct task_security_struct *tsec;
> +	struct inode_security_struct *dsec;
> +	struct superblock_security_struct *sbsec;
> +	struct inode *dir = dentry->d_parent->d_inode;
> +	u32 newsid;
> +	int rc;
> +
> +	tsec = current->security;
> +	dsec = dir->i_security;
> +	sbsec = dir->i_sb->s_security;
> +
> +	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
> +		newsid = tsec->create_sid;
> +	} else {
> +		rc = security_transition_sid(tsec->sid, dsec->sid,
> +					     inode_mode_to_security_class(mode),
> +					     &newsid);
> +		if (rc) {
> +			printk(KERN_WARNING "%s:  "
> +			       "security_transition_sid failed, rc=%d\n",
> +			       __FUNCTION__, -rc);
> +			return rc;
> +		}
> +	}
> +
> +	return security_sid_to_context(newsid, (char **)ctx, ctxlen);
> +}
> +
>  static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
>  				       char **name, void **value,
>  				       size_t *len)
> @@ -5413,6 +5448,7 @@ static struct security_operations selinux_ops = {
>  	.sb_clone_mnt_opts =		selinux_sb_clone_mnt_opts,
>  	.sb_parse_opts_str = 		selinux_parse_opts_str,
> 
> +	.dentry_init_security =		selinux_dentry_init_security,
> 
>  	.inode_alloc_security =		selinux_inode_alloc_security,
>  	.inode_free_security =		selinux_inode_free_security,
> -- 
> 1.5.5.1
> 
> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.
