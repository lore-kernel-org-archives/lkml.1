Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbYBSPKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbYBSPKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYBSPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:10:19 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:34501 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbYBSPKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:10:17 -0500
Subject: Re: [PATCH] [RFC] Smack update for file capabilities
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: linux-security-module@vger.kernel.org, serue@us.ibm.com, morgan@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <47BA1BAE.6020001@schaufler-ca.com>
References: <47BA1BAE.6020001@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 19 Feb 2008 10:09:53 -0500
Message-Id: <1203433793.9902.61.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-18 at 15:58 -0800, Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> This patch assumes "Smack unlabeled outgoing ambient packets - v4"
> which is one reason it's RFC.
> 
> Update the Smack LSM to allow the registration of the capability
> "module" as a secondary LSM. Integrate the new hooks required for
> file based capabilities.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> ---
> 
>  security/smack/smack_lsm.c |   63 +++++++++++++++++++++++++++++++++--
>  1 file changed, 60 insertions(+), 3 deletions(-)
> 
> diff -uprN -X linux-2.6.25-g0216-precap//Documentation/dontdiff linux-2.6.25-g0216-precap/security/smack/smack_lsm.c linux-2.6.25-g0216/security/smack/smack_lsm.c
> --- linux-2.6.25-g0216-precap/security/smack/smack_lsm.c	2008-02-18 10:53:45.000000000 -0800
> +++ linux-2.6.25-g0216/security/smack/smack_lsm.c	2008-02-18 14:15:25.000000000 -0800
> @@ -584,6 +584,12 @@ static int smack_inode_getattr(struct vf
>  static int smack_inode_setxattr(struct dentry *dentry, char *name,
>  				void *value, size_t size, int flags)
>  {
> +	int rc;
> +
> +	rc = cap_inode_setxattr(dentry, name, value, size, flags);
> +	if (rc != 0)
> +		return rc;

You only want to do that if the attribute isn't one of the Smack
attributes.  Otherwise, the capability module will apply a CAP_SYS_ADMIN
check on setting anything in the security namespace, including the Smack
attributes.

> +
>  	if (!capable(CAP_MAC_ADMIN)) {
>  		if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
>  		    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
> @@ -658,6 +664,12 @@ static int smack_inode_getxattr(struct d
>   */
>  static int smack_inode_removexattr(struct dentry *dentry, char *name)
>  {
> +	int rc;
> +
> +	rc = cap_inode_removexattr(dentry, name);
> +	if (rc != 0)
> +		return rc;

Ditto.

> +
>  	if (strcmp(name, XATTR_NAME_SMACK) == 0 && !capable(CAP_MAC_ADMIN))
>  		return -EPERM;
>  
> @@ -1016,7 +1028,12 @@ static void smack_task_getsecid(struct t
>   */
>  static int smack_task_setnice(struct task_struct *p, int nice)
>  {
> -	return smk_curacc(p->security, MAY_WRITE);
> +	int rc;
> +
> +	rc = cap_task_setnice(p, nice);
> +	if (rc == 0)
> +		rc = smk_curacc(p->security, MAY_WRITE);
> +	return rc;
>  }
>  
>  /**
> @@ -1028,7 +1045,12 @@ static int smack_task_setnice(struct tas
>   */
>  static int smack_task_setioprio(struct task_struct *p, int ioprio)
>  {
> -	return smk_curacc(p->security, MAY_WRITE);
> +	int rc;
> +
> +	rc = cap_task_setioprio(p, ioprio);
> +	if (rc == 0)
> +		rc = smk_curacc(p->security, MAY_WRITE);
> +	return rc;
>  }
>  
>  /**
> @@ -1053,7 +1075,12 @@ static int smack_task_getioprio(struct t
>  static int smack_task_setscheduler(struct task_struct *p, int policy,
>  				   struct sched_param *lp)
>  {
> -	return smk_curacc(p->security, MAY_WRITE);
> +	int rc;
> +
> +	rc = cap_task_setscheduler(p, policy, lp);
> +	if (rc == 0)
> +		rc = smk_curacc(p->security, MAY_WRITE);
> +	return rc;
>  }
>  
>  /**
> @@ -1093,6 +1120,11 @@ static int smack_task_movememory(struct 
>  static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>  			   int sig, u32 secid)
>  {
> +	int rc;
> +
> +	rc = cap_task_kill(p, info, sig, secid);
> +	if (rc != 0)
> +		return rc;
>  	/*
>  	 * Special cases where signals really ought to go through
>  	 * in spite of policy. Stephen Smalley suggests it may
> @@ -1778,6 +1810,27 @@ static int smack_ipc_permission(struct k
>  	return smk_curacc(isp, may);
>  }
>  
> +/* module stacking operations */
> +
> +/**
> + * smack_register_security - stack capability module
> + * @name: module name
> + * @ops: module operations - ignored
> + *
> + * Allow the capability module to register.
> + */
> +static int smack_register_security(const char *name,
> +				   struct security_operations *ops)
> +{
> +	if (strcmp(name, "capability") != 0)
> +		return -EINVAL;
> +
> +	printk(KERN_INFO "%s:  Registering secondary module %s\n",
> +	       __func__, name);
> +
> +	return 0;
> +}
> +
>  /**
>   * smack_d_instantiate - Make sure the blob is correct on an inode
>   * @opt_dentry: unused
> @@ -2412,6 +2465,8 @@ static struct security_operations smack_
>  	.inode_post_setxattr = 		smack_inode_post_setxattr,
>  	.inode_getxattr = 		smack_inode_getxattr,
>  	.inode_removexattr = 		smack_inode_removexattr,
> +	.inode_need_killpriv =		cap_inode_need_killpriv,
> +	.inode_killpriv =		cap_inode_killpriv,
>  	.inode_getsecurity = 		smack_inode_getsecurity,
>  	.inode_setsecurity = 		smack_inode_setsecurity,
>  	.inode_listsecurity = 		smack_inode_listsecurity,
> @@ -2471,6 +2526,8 @@ static struct security_operations smack_
>  	.netlink_send =			cap_netlink_send,
>  	.netlink_recv = 		cap_netlink_recv,
>  
> +	.register_security = 		smack_register_security,
> +
>  	.d_instantiate = 		smack_d_instantiate,
>  
>  	.getprocattr = 			smack_getprocattr,
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Stephen Smalley
National Security Agency

