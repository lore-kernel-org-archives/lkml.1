Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbZBBXhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbZBBXhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZBBXha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:37:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbZBBXha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:37:30 -0500
Date: Mon, 2 Feb 2009 17:40:53 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 4/6] integrity: IMA policy
Message-ID: <20090202234053.GC18452@hallyn.com>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com> <d425393d2c23920afb060c268e105b291d38b2bd.1233262163.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d425393d2c23920afb060c268e105b291d38b2bd.1233262163.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> Support for a user loadable policy through securityfs
> with support for LSM specific policy data.
> 
> Based on comments made by: Matt Helsley, Serge Hallyn
> - replaced policy parsing code with version using strsep and match_token
> - only replace default policy with a valid policy
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Apart from comments below,

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> new file mode 100644
> index 0000000..6434f0d
> --- /dev/null
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -0,0 +1,61 @@
> +What:		security/ima/policy
> +Date:		May 2008
> +Contact:	Mimi Zohar <zohar@us.ibm.com>
> +Description:
> +		The Trusted Computing Group(TCG) runtime Integrity
> +		Measurement Architecture(IMA) maintains a list of hash
> +		values of executables and other sensitive system files
> +		loaded into the run-time of this system.  At runtime,
> +		the policy can be constrained based on LSM specific data.
> +		Policies are loaded into the securityfs file ima/policy
> +		by opening the file, writing the rules one at a time and
> +		then closing the file.  The new policy takes effect after
> +		the file ima/policy is closed.
> +
> +		rule format: action [condition ...]
> +
> +		action: measure | dont_measure
> +		condition:= base | lsm
> +			base:	[[func=] [mask=] [fsmagic=] [uid=]]
> +			lsm:	[[subj_user=] [subj_role=] [subj_type=]
> +				 [obj_user=] [obj_role=] [obj_type=]]
> +
> +		base: 	func:= [BPRM_CHECK][FILE_MMAP][INODE_PERMISSION]
> +			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
> +			fsmagic:= hex value
> +			uid:= decimal value
> +		lsm:  	are LSM specific
> +
> +		default policy:
> +			# PROC_SUPER_MAGIC
> +			dont_measure fsmagic=0x9fa0
> +			# SYSFS_MAGIC
> +			dont_measure fsmagic=0x62656572
> +			# DEBUGFS_MAGIC
> +			dont_measure fsmagic=0x64626720
> +			# TMPFS_MAGIC
> +			dont_measure fsmagic=0x01021994
> +			# SECURITYFS_MAGIC
> +			dont_measure fsmagic=0x73636673
> +
> +			measure func=BPRM_CHECK
> +			measure func=FILE_MMAP mask=MAY_EXEC
> +			measure func=INODE_PERM mask=MAY_READ uid=0
> +
> +		The default policy measures all executables in bprm_check,
> +		all files mmapped executable in file_mmap, and all files
> +		open for read by root in inode_permission.
> +
> +		Examples of LSM specific definitions:
> +
> +		SELinux:
> +			# SELINUX_MAGIC
> +			dont_measure fsmagic=0xF97CFF8C
> +
> +			dont_measure obj_type=var_log_t
> +			dont_measure obj_type=auditd_log_t
> +			measure subj_user=system_u func=INODE_PERM mask=MAY_READ
> +			measure subj_role=system_r func=INODE_PERM mask=MAY_READ
> +
> +		Smack:
> +			measure subj_user=_ func=INODE_PERM mask=MAY_READ
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index 2a761c8..3d2b6ee 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -47,3 +47,9 @@ config IMA_AUDIT
>  	  auditing messages can be enabled with 'ima_audit=1' on
>  	  the kernel command line.
>  
> +config IMA_LSM_RULES
> +	bool
> +	depends on IMA && (SECURITY_SELINUX || SECURITY_SMACK)
> +	default y
> +	help
> +	  Disabling this option will disregard LSM based policy rules
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 236b74e..5b72cdb 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -138,4 +138,28 @@ enum ima_hooks { PATH_CHECK = 1, FILE_MMAP, BPRM_CHECK };
>  int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask);
>  void ima_init_policy(void);
>  void ima_update_policy(void);
> +int ima_parse_add_rule(char *);
> +void ima_delete_rules(void);
> +
> +/* LSM based policy rules require audit */
> +#ifdef CONFIG_IMA_LSM_RULES
> +
> +#define security_filter_rule_init security_audit_rule_init
> +#define security_filter_rule_match security_audit_rule_match
> +
> +#else
> +
> +static inline int security_filter_rule_init(u32 field, u32 op, char *rulestr,
> +					    void **lsmrule)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
> +					     void *lsmrule,
> +					     struct audit_context *actx)
> +{
> +	return -EINVAL;
> +}
> +#endif /* CONFIG_IMA_LSM_RULES */
>  #endif
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index 5044e4c..752a344 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -19,9 +19,11 @@
>  #include <linux/seq_file.h>
>  #include <linux/rculist.h>
>  #include <linux/rcupdate.h>
> +#include <linux/parser.h>
>  
>  #include "ima.h"
>  
> +static int valid_policy = 1;
>  #define TMPBUFLEN 12
>  static ssize_t ima_show_htable_value(char __user *buf, size_t count,
>  				     loff_t *ppos, atomic_long_t *val)
> @@ -237,11 +239,66 @@ static struct file_operations ima_ascii_measurements_ops = {
>  	.release = seq_release,
>  };
>  
> +static ssize_t ima_write_policy(struct file *file, const char __user *buf,
> +				size_t datalen, loff_t *ppos)
> +{
> +	char *data;
> +	int rc;
> +
> +	if (datalen >= PAGE_SIZE)
> +		return -ENOMEM;
> +	if (*ppos != 0) {
> +		/* No partial writes. */
> +		return -EINVAL;
> +	}
> +	data = kmalloc(datalen + 1, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(data, buf, datalen)) {
> +		kfree(data);
> +		return -EFAULT;
> +	}
> +	*(data + datalen) = '\0';
> +	rc = ima_parse_add_rule(data);
> +	if (rc < 0) {
> +		datalen = -EINVAL;
> +		valid_policy = 0;
> +	}
> +
> +	kfree(data);
> +	return datalen;
> +}
> +
>  static struct dentry *ima_dir;
>  static struct dentry *binary_runtime_measurements;
>  static struct dentry *ascii_runtime_measurements;
>  static struct dentry *runtime_measurements_count;
>  static struct dentry *violations;
> +static struct dentry *ima_policy;
> +
> +/*
> + * ima_release_policy - start using the new measure policy rules.
> + *
> + * Initially, ima_measure points to the default policy rules, now
> + * point to the new policy rules, and remove the securityfs policy file.
> + */
> +static int ima_release_policy(struct inode *inode, struct file *file)
> +{
> +	if (!valid_policy) {
> +		ima_delete_rules();
> +		return 0;
> +	}
> +	ima_update_policy();
> +	securityfs_remove(ima_policy);
> +	ima_policy = NULL;
> +	return 0;
> +}
> +
> +static struct file_operations ima_measure_policy_ops = {
> +	.write = ima_write_policy,
> +	.release = ima_release_policy
> +};
>  
>  int ima_fs_init(void)
>  {
> @@ -276,13 +333,20 @@ int ima_fs_init(void)
>  	if (!violations || IS_ERR(violations))
>  		goto out;
>  
> -	return 0;
> +	ima_policy = securityfs_create_file("policy",
> +					    S_IRUSR | S_IRGRP | S_IWUSR,
> +					    ima_dir, NULL,
> +					    &ima_measure_policy_ops);
> +	if (!ima_policy || IS_ERR(ima_policy))
> +		goto out;

Of course, James' same comment applies here :)

> +/**
> + * ima_parse_add_rule - add a rule to measure_policy_rules
> + * @rule - ima measurement policy rule
> + *
> + * Uses a mutex to protect the policy list from multiple concurrent writers.
> + * Returns 0 on success, an error code on failure.
> + */
> +int ima_parse_add_rule(char *rule)
> +{
> +	const char *op = "add_rule";
> +	struct ima_measure_rule_entry *entry;
> +	int result = 0;
> +	int audit_info = 0;
> +
> +	/* Prevent installed policy from changing */
> +	if (ima_measure != &measure_default_rules) {
> +		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> +				    NULL, op, "already exists",
> +				    -EACCES, audit_info);
> +		return -EACCES;
> +	}
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry) {
> +		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> +				    NULL, op, "-ENOMEM", -ENOMEM, audit_info);
> +		return -ENOMEM;
> +	}
> +
> +	INIT_LIST_HEAD(&entry->list);
> +
> +	result = ima_parse_rule(rule, entry);
> +	if (!result) {
> +		mutex_lock(&ima_measure_mutex);
> +		list_add_tail(&entry->list, &measure_policy_rules);
> +		mutex_unlock(&ima_measure_mutex);
> +	}

Should you kfree(entry) if ima_parse_rule() failed?

