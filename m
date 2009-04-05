Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbZDERtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbZDERtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 13:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZDERtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 13:49:08 -0400
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:37546 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750975AbZDERtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 13:49:05 -0400
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49D8EF0C.3020503@schaufler-ca.com>
Date: Sun, 05 Apr 2009 10:49:00 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Etienne Basset <etienne.basset@numericable.fr>
CC: LSM <linux-security-module@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-audit@redhat.com, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] security/smack implement logging V2
References: <49D8700A.8030605@numericable.fr>
In-Reply-To: <49D8700A.8030605@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Basset wrote:
> the following patch, add logging of Smack security decisions. 
> This is of course very useful to understand what your current smack policy does.
> As suggested by Casey, it also now forbids labels with ' or "
>   

It occurred to me later that \ should be disallowed as well.

> It introduces a '/smack/logging' switch :
> 0: no logging
> 1: log denied (default)
> 2: log accepted 
> 3: log denied&accepted 
>
>
>
> Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
> ---
> diff --git a/security/smack/Kconfig b/security/smack/Kconfig
> index 603b087..d83e708 100644
> --- a/security/smack/Kconfig
> +++ b/security/smack/Kconfig
> @@ -1,6 +1,6 @@
>  config SECURITY_SMACK
>  	bool "Simplified Mandatory Access Control Kernel Support"
> -	depends on NETLABEL && SECURITY_NETWORK
> +	depends on NETLABEL && SECURITY_NETWORK && AUDIT
>   

AUDIT can't be required. While MAC does make sense in certain
embedded environments, audit does not.

>  	default n
>  	help
>  	  This selects the Simplified Mandatory Access Control Kernel.
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 42ef313..4639d56 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -20,6 +20,7 @@
>  #include <net/netlabel.h>
>  #include <linux/list.h>
>  #include <linux/rculist.h>
> +#include <linux/lsm_audit.h>
>  
>  /*
>   * Why 23? CIPSO is constrained to 30, so a 32 byte buffer is
> @@ -179,6 +180,11 @@ struct smack_known {
>  #define MAY_NOT		0
>  
>  /*
> + * Number of access types used by Smack (rwxa)
> + */
> +#define SMK_NUM_ACCESS_TYPE 4
> +
> +/*
>   * These functions are in smack_lsm.c
>   */
>  struct inode_smack *new_inode_smack(char *);
> @@ -237,4 +243,22 @@ static inline char *smk_of_inode(const struct inode *isp)
>  	return sip->smk_inode;
>  }
>  
> +/*
> + * logging functions
> + */
> +struct smack_log_policy {
> +	int log_accepted;
> +	int log_denied;
> +};
>   

Use bits in a integer rather than a pair of integers unless you
are anticipating using multiple values for them.

> +
> +extern struct smack_log_policy log_policy;
> +
> +void smack_log(char *subject_label, char *object_label,
> +		int request,
> +		int result, struct common_audit_data *auditdata);
> +
> +int smk_access_log(char *subjectlabel, char *olabel, int access,
> +			 struct common_audit_data *a);
> +int smk_curacc_log(char *olabel, int access, struct common_audit_data *a);
>   

It looks like the only difference between these are their non-logging
versions is the logging. I say go ahead and add the auditdata parameter
to smk_access and smk_curacc and allow for the case where it is NULL.

> +
>  #endif  /* _SECURITY_SMACK_H */
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index ac0a270..2da8a40 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -13,6 +13,7 @@
>  #include <linux/types.h>
>  #include <linux/fs.h>
>  #include <linux/sched.h>
> +
>   

Remove the empty line.

>  #include "smack.h"
>  
>  struct smack_known smack_known_huh = {
> @@ -59,6 +60,14 @@ LIST_HEAD(smack_known_list);
>   */
>  static u32 smack_next_secid = 10;
>  
> +/* what events do we log
> + * can be overwriten at run-time by /smack/logging
> + */
> +struct smack_log_policy log_policy = {
> +	.log_accepted = 0,
> +	.log_denied   = 1
> +};
> +
>   

As I mentioned before, log_policy should be an integer with
bits defined for accepted and denied logging.

>  /**
>   * smk_access - determine if a subject has a specific access to an object
>   * @subject_label: a pointer to the subject's Smack label
> @@ -185,6 +194,129 @@ int smk_curacc(char *obj_label, u32 mode)
>  	return rc;
>  }
>  
> +/**
> + * smack_str_from_perm : helper to transalate an int to a
> + * readable string
> + * @string : the string to fill
> + * @access : the int
> + *
> + **/
> +static inline void smack_str_from_perm(char *string, int access)
> +{
> +	int i = 0;
> +	if (access & MAY_READ)
> +		string[i++] = 'r';
> +	if (access & MAY_WRITE)
> +		string[i++] = 'w';
> +	if (access & MAY_EXEC)
> +		string[i++] = 'x';
> +	if (access & MAY_APPEND)
> +		string[i++] = 'a';
> +	string[i] = '\0';
> +}
> +
> +/**
> + * smack_log_callback - SMACK specific information
> + * will be called by generic audit code
> + * @ab : the audit_buffer
> + * @a  : audit_data
> + *
> + */
> +static void smack_log_callback(struct audit_buffer *ab, void *a)
> +{
> +	struct common_audit_data *ad = a;
> +#define smack_info lsm_priv.smack_audit_data
>   

Create a variable of the right type and assign it rather than this define.

> +	audit_log_format(ab, "SMACK[%s]: action=%s", ad->function,
> +			ad->smack_info.result ? "denied" : "granted");
> +	audit_log_format(ab, " subject=");
> +	audit_log_untrustedstring(ab, ad->smack_info.subject);
>   

I'm not 100% sure, but I think that untrustedstring is unnecessary
with {'"\} disallowed and Smack labels always known to be NULL
terminated strings.

> +	audit_log_format(ab, " object=");
> +	audit_log_untrustedstring(ab, ad->smack_info.object);
> +	audit_log_format(ab, " requested=%s", ad->smack_info.request);
> +#undef smack_info
> +}
> +
> +/**
> + *  smack_log - Audit the granting or denial of permissions.
> + *  @subject_label : smack label of the requester
> + *  @object_label  : smack label of the object being accessed
> + *  @request: requested permissions
> + *  @result: result from smk_access
> + *  @a:  auxiliary audit data
> + *
> + * Audit the granting or denial of permissions in accordance
> + * with the policy.
> + **/
> +void smack_log(char *subject_label, char *object_label, int request,
> +		int result, struct common_audit_data *a)
> +{
> +	char request_buffer[SMK_NUM_ACCESS_TYPE + 1];
> +	u32 denied;
> +	u32 audited = 0;
> +
> +	/* check if we have to log the current event */
> +	if (result != 0) {
> +		denied = 1;
> +		if  (log_policy.log_denied)
> +			audited = 1;
> +	} else {
> +		denied = 0;
> +		if (log_policy.log_accepted)
> +			audited = 1;
> +	}
> +	if (audited == 0)
> +		return;
>   

        if (result == 0 && (log_policy & LOG_ACCEPTED) == 0)
                return;
        if (result == 1 && (log_policy & LOG_DENIED) == 0)
                return;

Cleaner, no?

> +
> +	if (a->function == NULL)
> +		a->function = "unknown";
> +
> +#define smack_info lsm_priv.smack_audit_data
>   

Use a variable instead of the define.

> +	/* end preparing the audit data */
> +	smack_str_from_perm(request_buffer, request);
> +	a->smack_info.subject = subject_label;
> +	a->smack_info.object  = object_label;
> +	a->smack_info.request = request_buffer;
> +	a->smack_info.result  = result;
> +	a->lsm_pre_audit = smack_log_callback;
> +
> +	common_lsm_audit(a);
> +#undef smack_info
> +}
> +
> +/**
> + * smk_curracc_log : check access of current on olabel
> + * @olabel : label being accessed
> + * @access : access requested
> + * @a	   : pointer to data
> + *
> + * return the same perm return by smk_curacc
> + */
> +int smk_curacc_log(char *olabel, int access, struct common_audit_data *a)
> +{
> +	int rc;
> +	rc = smk_curacc(olabel, access);
> +	smack_log(current_security(), olabel, access, rc, a);
> +	return rc;
> +}
>   

I definitely think that adding the audit data to smk_curacc would work.

> +
> +/**
> + * smk_access_log : check access of slabel on olabel
> + * @slabel : subjet label
> + * @olabel : label being accessed
> + * @access : access requested
> + * @a	   : pointer to data
> + *
> + * return the same perm return by smk_access
> + */
> +int smk_access_log(char *slabel, char *olabel, int access,
> +		struct common_audit_data *a)
> +{
> +	int rc;
> +	rc = smk_access(slabel, olabel, access);
> +	smack_log(slabel, olabel, access, rc, a);
> +	return rc;
> +}
> +
>   

As above.

>  static DEFINE_MUTEX(smack_known_lock);
>  
>  /**
> @@ -209,7 +341,8 @@ struct smack_known *smk_import_entry(const char *string, int len)
>  		if (found)
>  			smack[i] = '\0';
>  		else if (i >= len || string[i] > '~' || string[i] <= ' ' ||
> -			 string[i] == '/') {
> +				string[i] == '/' || string[i] == '"' ||
> +				string[i] == 0x27) {
>   

I would prefer '\'' to 0x27, and add a check for '\\' please.


>  			smack[i] = '\0';
>  			found = 1;
>  		} else
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 9215149..c1844ed 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -103,14 +103,21 @@ struct inode_smack *new_inode_smack(char *smack)
>  static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
>  {
>  	int rc;
> +	struct common_audit_data ad;
>  
>  	rc = cap_ptrace_may_access(ctp, mode);
>  	if (rc != 0)
>  		return rc;
>  
> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
> +	ad.u.tsk = ctp;
>   

It would be nice if audit data was only manipulated if audit is
installed, but I don't like the idea of ifdeffing everything
very much either. How about a static inline in smack.h that is
ifdeffed for audit? smack_audit_init? There would need to be one
for each field, too.

Assign the result of current_security() to a variable so
you don't have to call it multiple times. This comment applies
in all instances below.


> +	/* we won't log here, because rc can be overriden */
>  	rc = smk_access(current_security(), task_security(ctp), MAY_READWRITE);
>  	if (rc != 0 && capable(CAP_MAC_OVERRIDE))
> -		return 0;
> +		rc = 0;
> +
> +	smack_log(current_security(), task_security(ctp),
> +			 MAY_READWRITE, rc, &ad);
>  	return rc;
>  }
>  
> @@ -125,14 +132,21 @@ static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
>  static int smack_ptrace_traceme(struct task_struct *ptp)
>  {
>  	int rc;
> -
> +	struct common_audit_data ad;
>  	rc = cap_ptrace_traceme(ptp);
>  	if (rc != 0)
>  		return rc;
>  
> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
> +	ad.u.tsk = ptp;
> +
> +	/* we won't log here, because rc can be overriden */
>  	rc = smk_access(task_security(ptp), current_security(), MAY_READWRITE);
>  	if (rc != 0 && has_capability(ptp, CAP_MAC_OVERRIDE))
> -		return 0;
> +		rc = 0;
> +
> +	smack_log(task_security(ptp), current_security(),
> +			 MAY_READWRITE, rc, &ad);
>  	return rc;
>  }
>  
> @@ -327,8 +341,14 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
>  static int smack_sb_statfs(struct dentry *dentry)
>  {
>  	struct superblock_smack *sbp = dentry->d_sb->s_security;
> +	struct common_audit_data ad;
> +	int rc;
>  
> -	return smk_curacc(sbp->smk_floor, MAY_READ);
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = dentry;
> +
> +	rc = smk_curacc_log(sbp->smk_floor, MAY_READ, &ad);
> +	return rc;
>  }
>  
>  /**
> @@ -346,8 +366,12 @@ static int smack_sb_mount(char *dev_name, struct path *path,
>  			  char *type, unsigned long flags, void *data)
>  {
>  	struct superblock_smack *sbp = path->mnt->mnt_sb->s_security;
> +	struct common_audit_data ad;
>  
> -	return smk_curacc(sbp->smk_floor, MAY_WRITE);
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = path->dentry;
> +	ad.u.fs.path.mnt = path->mnt;
> +	return smk_curacc_log(sbp->smk_floor, MAY_WRITE, &ad);
>  }
>  
>  /**
> @@ -361,10 +385,14 @@ static int smack_sb_mount(char *dev_name, struct path *path,
>  static int smack_sb_umount(struct vfsmount *mnt, int flags)
>  {
>  	struct superblock_smack *sbp;
> +	struct common_audit_data ad;
>  
>  	sbp = mnt->mnt_sb->s_security;
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = mnt->mnt_mountpoint;
> +	ad.u.fs.path.mnt = mnt;
>  
> -	return smk_curacc(sbp->smk_floor, MAY_WRITE);
> +	return smk_curacc_log(sbp->smk_floor, MAY_WRITE, &ad);
>  }
>  
>  /*
> @@ -441,15 +469,20 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
>  static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
>  			    struct dentry *new_dentry)
>  {
> -	int rc;
>  	char *isp;
> +	struct common_audit_data ad;
> +	int rc;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = old_dentry;
>  
>  	isp = smk_of_inode(old_dentry->d_inode);
> -	rc = smk_curacc(isp, MAY_WRITE);
> +	rc = smk_curacc_log(isp, MAY_WRITE, &ad);
>  
>  	if (rc == 0 && new_dentry->d_inode != NULL) {
>  		isp = smk_of_inode(new_dentry->d_inode);
> -		rc = smk_curacc(isp, MAY_WRITE);
> +		ad.u.fs.path.dentry = new_dentry;
> +		rc = smk_curacc_log(isp, MAY_WRITE, &ad);
>  	}
>  
>  	return rc;
> @@ -466,18 +499,24 @@ static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
>  static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
>  {
>  	struct inode *ip = dentry->d_inode;
> +	struct common_audit_data ad;
>  	int rc;
>  
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = dentry;
> +
>  	/*
>  	 * You need write access to the thing you're unlinking
>  	 */
> -	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
> -	if (rc == 0)
> +	rc = smk_curacc_log(smk_of_inode(ip), MAY_WRITE, &ad);
> +	if (rc == 0) {
>  		/*
>  		 * You also need write access to the containing directory
>  		 */
> -		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
> -
> +		ad.u.fs.path.dentry = NULL;
> +		ad.u.fs.inode = dir;
> +		rc = smk_curacc_log(smk_of_inode(dir), MAY_WRITE, &ad);
> +	}
>  	return rc;
>  }
>  
> @@ -491,17 +530,24 @@ static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
>   */
>  static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
>  {
> +	struct common_audit_data ad;
>  	int rc;
>  
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = dentry;
> +
>  	/*
>  	 * You need write access to the thing you're removing
>  	 */
> -	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> -	if (rc == 0)
> +	rc = smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_WRITE, &ad);
> +	if (rc == 0) {
>  		/*
>  		 * You also need write access to the containing directory
>  		 */
> -		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
> +		ad.u.fs.path.dentry = NULL;
> +		ad.u.fs.inode = dir;
> +		rc = smk_curacc_log(smk_of_inode(dir), MAY_WRITE, &ad);
> +	}
>  
>  	return rc;
>  }
> @@ -525,15 +571,19 @@ static int smack_inode_rename(struct inode *old_inode,
>  {
>  	int rc;
>  	char *isp;
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = old_dentry;
>  
>  	isp = smk_of_inode(old_dentry->d_inode);
> -	rc = smk_curacc(isp, MAY_READWRITE);
> +	rc = smk_curacc_log(isp, MAY_READWRITE, &ad);
>  
>  	if (rc == 0 && new_dentry->d_inode != NULL) {
>  		isp = smk_of_inode(new_dentry->d_inode);
> -		rc = smk_curacc(isp, MAY_READWRITE);
> +		ad.u.fs.path.dentry = new_dentry;
> +		rc = smk_curacc_log(isp, MAY_READWRITE, &ad);
>  	}
> -
>  	return rc;
>  }
>  
> @@ -548,14 +598,16 @@ static int smack_inode_rename(struct inode *old_inode,
>   */
>  static int smack_inode_permission(struct inode *inode, int mask)
>  {
> +	struct common_audit_data ad;
>  	/*
>  	 * No permission to check. Existence test. Yup, it's there.
>  	 */
>  	if (mask == 0)
>  		return 0;
> -
> -	return smk_curacc(smk_of_inode(inode), mask);
> -}
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.inode = inode;
> +	return smk_curacc_log(smk_of_inode(inode), mask, &ad);
> + }
>  
>  /**
>   * smack_inode_setattr - Smack check for setting attributes
> @@ -566,13 +618,15 @@ static int smack_inode_permission(struct inode *inode, int mask)
>   */
>  static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
>  {
> +	struct common_audit_data ad;
>  	/*
>  	 * Need to allow for clearing the setuid bit.
>  	 */
>  	if (iattr->ia_valid & ATTR_FORCE)
>  		return 0;
> -
> -	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = dentry;
> +	return smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_WRITE, &ad);
>  }
>  
>  /**
> @@ -584,7 +638,12 @@ static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
>   */
>  static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
>  {
> -	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = dentry;
> +	ad.u.fs.path.mnt = mnt;
> +	return smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_READ, &ad);
>  }
>  
>  /**
> @@ -602,6 +661,7 @@ static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
>  static int smack_inode_setxattr(struct dentry *dentry, const char *name,
>  				const void *value, size_t size, int flags)
>  {
> +	struct common_audit_data ad;
>  	int rc = 0;
>  
>  	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
> @@ -615,8 +675,11 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
>  	} else
>  		rc = cap_inode_setxattr(dentry, name, value, size, flags);
>  
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = dentry;
>  	if (rc == 0)
> -		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> +		rc = smk_curacc_log(smk_of_inode(dentry->d_inode),
> +					 MAY_WRITE, &ad);
>  
>  	return rc;
>  }
> @@ -671,7 +734,11 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
>   */
>  static int smack_inode_getxattr(struct dentry *dentry, const char *name)
>  {
> -	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = dentry;
> +	return smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_READ, &ad);
>  }
>  
>  /*
> @@ -685,6 +752,7 @@ static int smack_inode_getxattr(struct dentry *dentry, const char *name)
>   */
>  static int smack_inode_removexattr(struct dentry *dentry, const char *name)
>  {
> +	struct common_audit_data ad;
>  	int rc = 0;
>  
>  	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
> @@ -695,8 +763,11 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
>  	} else
>  		rc = cap_inode_removexattr(dentry, name);
>  
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = dentry;
>  	if (rc == 0)
> -		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> +		rc = smk_curacc_log(smk_of_inode(dentry->d_inode),
> +					 MAY_WRITE, &ad);
>  
>  	return rc;
>  }
> @@ -855,12 +926,16 @@ static int smack_file_ioctl(struct file *file, unsigned int cmd,
>  			    unsigned long arg)
>  {
>  	int rc = 0;
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path = file->f_path;
>  
>  	if (_IOC_DIR(cmd) & _IOC_WRITE)
> -		rc = smk_curacc(file->f_security, MAY_WRITE);
> +		rc = smk_curacc_log(file->f_security, MAY_WRITE, &ad);
>  
>  	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ))
> -		rc = smk_curacc(file->f_security, MAY_READ);
> +		rc = smk_curacc_log(file->f_security, MAY_READ, &ad);
>  
>  	return rc;
>  }
> @@ -874,7 +949,11 @@ static int smack_file_ioctl(struct file *file, unsigned int cmd,
>   */
>  static int smack_file_lock(struct file *file, unsigned int cmd)
>  {
> -	return smk_curacc(file->f_security, MAY_WRITE);
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path.dentry = file->f_path.dentry;
> +	return smk_curacc_log(file->f_security, MAY_WRITE, &ad);
>  }
>  
>  /**
> @@ -888,8 +967,12 @@ static int smack_file_lock(struct file *file, unsigned int cmd)
>  static int smack_file_fcntl(struct file *file, unsigned int cmd,
>  			    unsigned long arg)
>  {
> +	struct common_audit_data ad;
>  	int rc;
>  
> +	COMMON_AUDIT_DATA_INIT(&ad, FS);
> +	ad.u.fs.path = file->f_path;
> +
>  	switch (cmd) {
>  	case F_DUPFD:
>  	case F_GETFD:
> @@ -897,7 +980,7 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
>  	case F_GETLK:
>  	case F_GETOWN:
>  	case F_GETSIG:
> -		rc = smk_curacc(file->f_security, MAY_READ);
> +		rc = smk_curacc_log(file->f_security, MAY_READ, &ad);
>  		break;
>  	case F_SETFD:
>  	case F_SETFL:
> @@ -905,10 +988,10 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
>  	case F_SETLKW:
>  	case F_SETOWN:
>  	case F_SETSIG:
> -		rc = smk_curacc(file->f_security, MAY_WRITE);
> +		rc = smk_curacc_log(file->f_security, MAY_WRITE, &ad);
>  		break;
>  	default:
> -		rc = smk_curacc(file->f_security, MAY_READWRITE);
> +		rc = smk_curacc_log(file->f_security, MAY_READWRITE, &ad);
>  	}
>  
>  	return rc;
> @@ -943,14 +1026,20 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
>  {
>  	struct file *file;
>  	int rc;
> +	struct common_audit_data ad;
>  
>  	/*
>  	 * struct fown_struct is never outside the context of a struct file
>  	 */
>  	file = container_of(fown, struct file, f_owner);
> +	/* we don't log here as rc can be overriden */
>  	rc = smk_access(file->f_security, tsk->cred->security, MAY_WRITE);
>  	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
>  		return 0;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
> +	ad.u.tsk = tsk;
> +	smack_log(file->f_security, tsk->cred->security, MAY_WRITE, rc, &ad);
>  	return rc;
>  }
>  
> @@ -963,7 +1052,10 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
>  static int smack_file_receive(struct file *file)
>  {
>  	int may = 0;
> +	struct common_audit_data ad;
>  
> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
> +	ad.u.fs.path = file->f_path;
>  	/*
>  	 * This code relies on bitmasks.
>  	 */
> @@ -972,7 +1064,7 @@ static int smack_file_receive(struct file *file)
>  	if (file->f_mode & FMODE_WRITE)
>  		may |= MAY_WRITE;
>  
> -	return smk_curacc(file->f_security, may);
> +	return smk_curacc_log(file->f_security, may, &ad);
>  }
>  
>  /*
> @@ -1052,6 +1144,22 @@ static int smack_kernel_create_files_as(struct cred *new,
>  }
>  
>  /**
> + * smk_curacc_on_task - helper to log task related access
> + * @p: the task object
> + * @access : the access requested
> + *
> + * Return 0 if access is permitted
> + */
> +static int smk_curacc_on_task(struct task_struct *p, int access)
> +{
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
> +	ad.u.tsk = p;
> +	return smk_curacc_log(task_security(p), access, &ad);
> +}
>   

I don't think that this is all that much help, and it adds a
level indirection. Better to do the audit initialization in a
consistent way, even if it is clumsy.

Hum. It does happen a lot. I suppose it's OK.

> +
> +/**
>   * smack_task_setpgid - Smack check on setting pgid
>   * @p: the task object
>   * @pgid: unused
> @@ -1060,7 +1168,7 @@ static int smack_kernel_create_files_as(struct cred *new,
>   */
>  static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
>  {
> -	return smk_curacc(task_security(p), MAY_WRITE);
> +	return smk_curacc_on_task(p, MAY_WRITE);
>  }
>  
>  /**
> @@ -1071,7 +1179,7 @@ static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
>   */
>  static int smack_task_getpgid(struct task_struct *p)
>  {
> -	return smk_curacc(task_security(p), MAY_READ);
> +	return smk_curacc_on_task(p, MAY_READ);
>  }
>  
>  /**
> @@ -1082,7 +1190,7 @@ static int smack_task_getpgid(struct task_struct *p)
>   */
>  static int smack_task_getsid(struct task_struct *p)
>  {
> -	return smk_curacc(task_security(p), MAY_READ);
> +	return smk_curacc_on_task(p, MAY_READ);
>  }
>  
>  /**
> @@ -1110,7 +1218,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
>  
>  	rc = cap_task_setnice(p, nice);
>  	if (rc == 0)
> -		rc = smk_curacc(task_security(p), MAY_WRITE);
> +		rc = smk_curacc_on_task(p, MAY_WRITE);
>  	return rc;
>  }
>  
> @@ -1127,7 +1235,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
>  
>  	rc = cap_task_setioprio(p, ioprio);
>  	if (rc == 0)
> -		rc = smk_curacc(task_security(p), MAY_WRITE);
> +		rc = smk_curacc_on_task(p, MAY_WRITE);
>  	return rc;
>  }
>  
> @@ -1139,7 +1247,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
>   */
>  static int smack_task_getioprio(struct task_struct *p)
>  {
> -	return smk_curacc(task_security(p), MAY_READ);
> +	return smk_curacc_on_task(p, MAY_READ);
>  }
>  
>  /**
> @@ -1157,7 +1265,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
>  
>  	rc = cap_task_setscheduler(p, policy, lp);
>  	if (rc == 0)
> -		rc = smk_curacc(task_security(p), MAY_WRITE);
> +		rc = smk_curacc_on_task(p, MAY_WRITE);
>  	return rc;
>  }
>  
> @@ -1169,7 +1277,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
>   */
>  static int smack_task_getscheduler(struct task_struct *p)
>  {
> -	return smk_curacc(task_security(p), MAY_READ);
> +	return smk_curacc_on_task(p, MAY_READ);
>  }
>  
>  /**
> @@ -1180,7 +1288,7 @@ static int smack_task_getscheduler(struct task_struct *p)
>   */
>  static int smack_task_movememory(struct task_struct *p)
>  {
> -	return smk_curacc(task_security(p), MAY_WRITE);
> +	return smk_curacc_on_task(p, MAY_WRITE);
>  }
>  
>  /**
> @@ -1198,18 +1306,23 @@ static int smack_task_movememory(struct task_struct *p)
>  static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>  			   int sig, u32 secid)
>  {
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
> +	ad.u.tsk = p;
>  	/*
>  	 * Sending a signal requires that the sender
>  	 * can write the receiver.
>  	 */
>  	if (secid == 0)
> -		return smk_curacc(task_security(p), MAY_WRITE);
> +		return smk_curacc_log(task_security(p), MAY_WRITE, &ad);
>  	/*
>  	 * If the secid isn't 0 we're dealing with some USB IO
>  	 * specific behavior. This is not clean. For one thing
>  	 * we can't take privilege into account.
>  	 */
> -	return smk_access(smack_from_secid(secid), task_security(p), MAY_WRITE);
> +	return smk_access_log(smack_from_secid(secid), task_security(p),
> +				 MAY_WRITE, &ad);
>  }
>  
>  /**
> @@ -1220,12 +1333,13 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>   */
>  static int smack_task_wait(struct task_struct *p)
>  {
> +	struct common_audit_data ad;
>  	int rc;
>  
> +	/* we don't log here, we can be overriden */
>  	rc = smk_access(current_security(), task_security(p), MAY_WRITE);
>  	if (rc == 0)
> -		return 0;
> -
> +		goto out_log;
>  	/*
>  	 * Allow the operation to succeed if either task
>  	 * has privilege to perform operations that might
> @@ -1239,7 +1353,11 @@ static int smack_task_wait(struct task_struct *p)
>  	 */
>  	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
>  		return 0;
>   

Did you miss this return, or is this check special?

> -
> +	/* we log only if we didn't get overriden */
> + out_log:
> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
> +	ad.u.tsk = p;
> +	smack_log(current_security(), task_security(p), MAY_WRITE, rc, &ad);
>  	return rc;
>  }
>  
> @@ -1455,12 +1573,18 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
>  	int sk_lbl;
>  	char *hostsp;
>  	struct socket_smack *ssp = sk->sk_security;
> +	struct common_audit_data ad;
>  
>  	rcu_read_lock();
>  	hostsp = smack_host_label(sap);
>  	if (hostsp != NULL) {
>  		sk_lbl = SMACK_UNLABELED_SOCKET;
> -		rc = smk_access(ssp->smk_out, hostsp, MAY_WRITE);
> +		COMMON_AUDIT_DATA_INIT(&ad, NET);
> +		ad.u.net.family = sap->sin_family;
> +		ad.u.net.dport = sap->sin_port;
> +		ad.u.net.v4info.daddr = sap->sin_addr.s_addr;
> +
> +		rc = smk_access_log(ssp->smk_out, hostsp, MAY_WRITE, &ad);
>  	} else {
>  		sk_lbl = SMACK_CIPSO_SOCKET;
>  		rc = 0;
> @@ -1656,6 +1780,23 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
>  }
>   

Now this is tricky. You'll get an audit record for single-label
hosts, but not for those that use CIPSO. The former is good, the
latter is bad.

>  
>  /**
> + * smk_curacc_shm : check if current has access on shm
> + * @shp : the object
> + * @access : access requested
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smk_curacc_shm(struct shmid_kernel *shp, int access)
> +{
> +	char *ssp = smack_of_shm(shp);
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, IPC);
> +	ad.u.ipc_id = shp->shm_perm.id;
> +	return smk_curacc_log(ssp, access, &ad);
> +}
> +
> +/**
>   * smack_shm_associate - Smack access check for shm
>   * @shp: the object
>   * @shmflg: access requested
> @@ -1664,11 +1805,10 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
>   */
>  static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
>  {
> -	char *ssp = smack_of_shm(shp);
>  	int may;
>  
>  	may = smack_flags_to_may(shmflg);
> -	return smk_curacc(ssp, may);
> +	return smk_curacc_shm(shp, may);
>  }
>  
>  /**
> @@ -1680,7 +1820,6 @@ static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
>   */
>  static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
>  {
> -	char *ssp;
>  	int may;
>  
>  	switch (cmd) {
> @@ -1703,9 +1842,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
>  	default:
>  		return -EINVAL;
>  	}
> -
> -	ssp = smack_of_shm(shp);
> -	return smk_curacc(ssp, may);
> +	return smk_curacc_shm(shp, may);
>  }
>  
>  /**
> @@ -1719,11 +1856,10 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
>  static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
>  			   int shmflg)
>  {
> -	char *ssp = smack_of_shm(shp);
>  	int may;
>  
>  	may = smack_flags_to_may(shmflg);
> -	return smk_curacc(ssp, may);
> +	return smk_curacc_shm(shp, may);
>  }
>  
>  /**
> @@ -1765,6 +1901,23 @@ static void smack_sem_free_security(struct sem_array *sma)
>  }
>  
>  /**
> + * smk_curacc_sem : check if current has access on sem
> + * @sma : the object
> + * @access : access requested
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smk_curacc_sem(struct sem_array *sma, int access)
> +{
> +	char *ssp = smack_of_sem(sma);
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, IPC);
> +	ad.u.ipc_id = sma->sem_perm.id;
> +	return smk_curacc_log(ssp, access, &ad);
> +}
> +
> +/**
>   * smack_sem_associate - Smack access check for sem
>   * @sma: the object
>   * @semflg: access requested
> @@ -1773,11 +1926,10 @@ static void smack_sem_free_security(struct sem_array *sma)
>   */
>  static int smack_sem_associate(struct sem_array *sma, int semflg)
>  {
> -	char *ssp = smack_of_sem(sma);
>  	int may;
>  
>  	may = smack_flags_to_may(semflg);
> -	return smk_curacc(ssp, may);
> +	return smk_curacc_sem(sma, may);
>  }
>  
>  /**
> @@ -1789,7 +1941,6 @@ static int smack_sem_associate(struct sem_array *sma, int semflg)
>   */
>  static int smack_sem_semctl(struct sem_array *sma, int cmd)
>  {
> -	char *ssp;
>  	int may;
>  
>  	switch (cmd) {
> @@ -1818,8 +1969,7 @@ static int smack_sem_semctl(struct sem_array *sma, int cmd)
>  		return -EINVAL;
>  	}
>  
> -	ssp = smack_of_sem(sma);
> -	return smk_curacc(ssp, may);
> +	return smk_curacc_sem(sma, may);
>  }
>  
>  /**
> @@ -1836,9 +1986,7 @@ static int smack_sem_semctl(struct sem_array *sma, int cmd)
>  static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops,
>  			   unsigned nsops, int alter)
>  {
> -	char *ssp = smack_of_sem(sma);
> -
> -	return smk_curacc(ssp, MAY_READWRITE);
> +	return smk_curacc_sem(sma, MAY_READWRITE);
>  }
>  
>  /**
> @@ -1880,6 +2028,23 @@ static char *smack_of_msq(struct msg_queue *msq)
>  }
>  
>  /**
> + * smk_curacc_msq : helper to check if current has access on msq
> + * @msq : the msq
> + * @access : access requested
> + *
> + * return 0 if current has access, error otherwise
> + */
> +static int smk_curacc_msq(struct msg_queue *msq, int access)
> +{
> +	char *msp = smack_of_msq(msq);
> +	struct common_audit_data ad;
> +
> +	COMMON_AUDIT_DATA_INIT(&ad, IPC);
> +	ad.u.ipc_id = msq->q_perm.id;
> +	return smk_curacc_log(msp, access, &ad);
> +}
> +
> +/**
>   * smack_msg_queue_associate - Smack access check for msg_queue
>   * @msq: the object
>   * @msqflg: access requested
> @@ -1888,11 +2053,10 @@ static char *smack_of_msq(struct msg_queue *msq)
>   */
>  static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
>  {
> -	char *msp = smack_of_msq(msq);
>  	int may;
>  
>  	may = smack_flags_to_may(msqflg);
> -	return smk_curacc(msp, may);
> +	return smk_curacc_msq(msq, may);
>  }
>  
>  /**
> @@ -1904,7 +2068,6 @@ static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
>   */
>  static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
>  {
> -	char *msp;
>  	int may;
>  
>  	switch (cmd) {
> @@ -1926,8 +2089,7 @@ static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
>  		return -EINVAL;
>  	}
>  
> -	msp = smack_of_msq(msq);
> -	return smk_curacc(msp, may);
> +	return smk_curacc_msq(msq, may);
>  }
>  
>  /**
> @@ -1941,11 +2103,10 @@ static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
>  static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
>  				  int msqflg)
>  {
> -	char *msp = smack_of_msq(msq);
> -	int rc;
> +	int may;
>  
> -	rc = smack_flags_to_may(msqflg);
> -	return smk_curacc(msp, rc);
> +	may = smack_flags_to_may(msqflg);
> +	return smk_curacc_msq(msq, may);
>  }
>  
>  /**
> @@ -1961,9 +2122,7 @@ static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
>  static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
>  			struct task_struct *target, long type, int mode)
>  {
> -	char *msp = smack_of_msq(msq);
> -
> -	return smk_curacc(msp, MAY_READWRITE);
> +	return smk_curacc_msq(msq, MAY_READWRITE);
>  }
>  
>  /**
> @@ -1976,10 +2135,13 @@ static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
>  static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
>  {
>  	char *isp = ipp->security;
> +	struct common_audit_data ad;
>  	int may;
> +	COMMON_AUDIT_DATA_INIT(&ad, IPC);
> +	ad.u.ipc_id = ipp->id;
>  
>  	may = smack_flags_to_may(flag);
> -	return smk_curacc(isp, may);
> +	return smk_curacc_log(isp, may, &ad);
>  }
>  
>  /**
> @@ -2238,8 +2400,12 @@ static int smack_unix_stream_connect(struct socket *sock,
>  {
>  	struct inode *sp = SOCK_INODE(sock);
>  	struct inode *op = SOCK_INODE(other);
> +	struct common_audit_data ad;
>  
> -	return smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_READWRITE);
> +	COMMON_AUDIT_DATA_INIT(&ad, NET);
> +	ad.u.net.sk = other->sk;
> +	return smk_access_log(smk_of_inode(sp), smk_of_inode(op),
> +				 MAY_READWRITE, &ad);
>  }
>  
>  /**
> @@ -2254,8 +2420,12 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
>  {
>  	struct inode *sp = SOCK_INODE(sock);
>  	struct inode *op = SOCK_INODE(other);
> +	struct common_audit_data ad;
>  
> -	return smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_WRITE);
> +	COMMON_AUDIT_DATA_INIT(&ad, NET);
> +	ad.u.net.sk = other->sk;
> +	return smk_access_log(smk_of_inode(sp), smk_of_inode(op),
> +				 MAY_WRITE, &ad);
>  }
>  
>  /**
> @@ -2370,6 +2540,7 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  	char smack[SMK_LABELLEN];
>  	char *csp;
>  	int rc;
> +	struct common_audit_data ad;
>  
>  	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
>  		return 0;
> @@ -2388,13 +2559,17 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  
>  	netlbl_secattr_destroy(&secattr);
>  
> +	COMMON_AUDIT_DATA_INIT(&ad, NET);
> +	ad.u.net.family = sk->sk_family;
> +	ad.u.net.netif = skb->iif;
> +	ipv4_skb_to_auditdata(skb, &ad, NULL);
>  	/*
>  	 * Receiving a packet requires that the other end
>  	 * be able to write here. Read access is not required.
>  	 * This is the simplist possible security model
>  	 * for networking.
>  	 */
> -	rc = smk_access(csp, ssp->smk_in, MAY_WRITE);
> +	rc = smk_access_log(csp, ssp->smk_in, MAY_WRITE, &ad);
>  	if (rc != 0)
>  		netlbl_skbuff_err(skb, rc, 0);
>  	return rc;
> @@ -2642,6 +2817,7 @@ static int smack_key_permission(key_ref_t key_ref,
>  				const struct cred *cred, key_perm_t perm)
>  {
>  	struct key *keyp;
> +	struct common_audit_data ad;
>  
>  	keyp = key_ref_to_ptr(key_ref);
>  	if (keyp == NULL)
> @@ -2657,8 +2833,12 @@ static int smack_key_permission(key_ref_t key_ref,
>  	 */
>  	if (cred->security == NULL)
>  		return -EACCES;
> +	COMMON_AUDIT_DATA_INIT(&ad, KEY);
> +	ad.u.key_struct.key = keyp->serial;
> +	ad.u.key_struct.key_desc = keyp->description;
>  
> -	return smk_access(cred->security, keyp->security, MAY_READWRITE);
> +	return smk_access_log(cred->security, keyp->security,
> +				 MAY_READWRITE, &ad);
>  }
>  #endif /* CONFIG_KEYS */
>  
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index e03a7e1..f141d31 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -41,6 +41,7 @@ enum smk_inos {
>  	SMK_AMBIENT	= 7,	/* internet ambient label */
>  	SMK_NETLBLADDR	= 8,	/* single label hosts */
>  	SMK_ONLYCAP	= 9,	/* the only "capable" label */
> +	SMK_LOGGING	= 10,	/* logging */
>  };
>  
>  /*
> @@ -1192,6 +1193,71 @@ static const struct file_operations smk_onlycap_ops = {
>  };
>  
>  /**
> + * smk_read_logging - read() for /smack/logging
> + * @filp: file pointer, not actually used
> + * @buf: where to put the result
> + * @cn: maximum to send along
> + * @ppos: where to start
> + *
> + * Returns number of bytes read or error code, as appropriate
> + */
> +static ssize_t smk_read_logging(struct file *filp, char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	char temp[32];
> +	ssize_t rc;
> +
> +	if (*ppos != 0)
> +		return 0;
> +
> +	sprintf(temp, "%d\n",
> +		 log_policy.log_denied + log_policy.log_accepted*2);
> +	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
> +	return rc;
> +}
> +
> +/**
> + * smk_write_logging - write() for /smack/logging
> + * @file: file pointer, not actually used
> + * @buf: where to get the data from
> + * @count: bytes sent
> + * @ppos: where to start
> + *
> + * Returns number of bytes written or error code, as appropriate
> + */
> +static ssize_t smk_write_logging(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	char temp[32];
> +	int i;
> +
> +	if (!capable(CAP_MAC_ADMIN))
> +		return -EPERM;
> +
> +	if (count >= sizeof(temp) || count == 0)
> +		return -EINVAL;
> +
> +	if (copy_from_user(temp, buf, count) != 0)
> +		return -EFAULT;
> +
> +	temp[count] = '\0';
> +
> +	if (sscanf(temp, "%d", &i) != 1)
> +		return -EINVAL;
> +	if (i < 0 || i > 3)
> +		return -EINVAL;
> +	log_policy.log_denied   = i & 1;
> +	log_policy.log_accepted = (i & 2) >> 1 ;
>   


Again, bits in a integer.

> +	return count;
> +}
> +
> +
> +
> +static const struct file_operations smk_logging_ops = {
> +	.read		= smk_read_logging,
> +	.write		= smk_write_logging,
> +};
> +/**
>   * smk_fill_super - fill the /smackfs superblock
>   * @sb: the empty superblock
>   * @data: unused
> @@ -1221,6 +1287,8 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
>  			{"netlabel", &smk_netlbladdr_ops, S_IRUGO|S_IWUSR},
>  		[SMK_ONLYCAP]	=
>  			{"onlycap", &smk_onlycap_ops, S_IRUGO|S_IWUSR},
> +		[SMK_LOGGING]	=
> +			{"logging", &smk_logging_ops, S_IRUGO|S_IWUSR},
>  		/* last one */ {""}
>  	};
>  
>
>
>   

