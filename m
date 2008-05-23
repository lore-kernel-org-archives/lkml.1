Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbYEWXge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbYEWXge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYEWXg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:36:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30640 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYEWXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:36:24 -0400
Date: Fri, 23 May 2008 16:30:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
Message-Id: <20080523163027.50021215.randy.dunlap@oracle.com>
In-Reply-To: <1211555145.16195.18.camel@new-host>
References: <1211555145.16195.18.camel@new-host>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 11:05:45 -0400 Mimi Zohar wrote:


> ---
> Index: linux-2.6.26-rc3-git2/security/integrity/ima/Kconfig
> ===================================================================
> --- /dev/null
> +++ linux-2.6.26-rc3-git2/security/integrity/ima/Kconfig
> @@ -0,0 +1,68 @@
> +#
> +# IBM Integrity Measurement Architecture
> +#
> +
> +config IMA_MEASURE
> +	bool "TCG run-time Integrity Measurement Architecture(IMA)"

What is TCG?  It seems to be missing from all of those other TLAs.

> +	depends on INTEGRITY
> +	depends on ACPI
> +	select CRYPTO
> +	select CRYPTO_HMAC
> +	select CRYPTO_MD5
> +	select CRYPTO_SHA1
> +	select TCG_TPM
> +	help
> +	  IMA maintains a list of hash values of executables and
> +	  other sensitive system files loaded into the run-time
> +	  of this system. If your system has a TPM chip, then IMA
> +	  also maintains an aggregate integrity value over this
> +	  list inside the TPM hardware.  These measurements and
> +	  the aggregate (signed inside the TPM) can be retrieved
> +	  and presented to remote parties to establish system
> +	  properties. If unsure, say N.
> +
> +config IMA_BOOTPARAM
> +	bool "IMA boot parameter"
> +	depends on IMA_MEASURE
> +	default n
> +	help
> +	  This option adds a kernel parameter 'ima', which allows IMA
> +	  to be disabled at boot.  If this option is selected, IMA
> +	  functionality can be disabled with ima=0 on the kernel
> +	  command line.  The purpose of this option is to allow a single
> +	  kernel image to be distributed with IMA built in, but not
> +	  necessarily enabled.
> +
> +	  If you are unsure how to answer this question, answer N.
> +
> +config IMA_BOOTPARAM_VALUE
> +	int "IMA boot parameter default value"
> +	depends on IMA_BOOTPARAM
> +	range 0 1
> +	default 0
> +	help
> +	  This option sets the default value for the kernel parameter
> +	  'ima=', which allows IMA to be disabled at boot.  If this
> +	  option is set to 0 (zero), the IMA kernel parameter will
> +	  default to 0, disabling IMA at bootup.  If this option is
> +	  set to 1 (one), the IMA kernel parameter will default to 1,
> +	  enabling IMA at bootup.
> +
> +	  If you are unsure how to answer this question, answer 0.
> +
> +config IMA_MEASURE_PCR_IDX
> +	int "PCR for Aggregate (8<= Index <= 14)"
> +	depends on IMA_MEASURE
> +	range 8 14
> +	default 10
> +	help
> +	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
> +	  that IMA uses to maintain the integrity aggregate of the
> +	  measurement list.  If unsure, use the default 10.
> +
> +config IMA_BASE_HOOKS
> +	bool "IMA base hooks"
> +	depends on IMA_MEASURE
> +	default n
> +	help
> +	  Enable this option to allow the LSM module to enforce integrity.
> Index: linux-2.6.26-rc3-git2/security/integrity/ima/Makefile
> ===================================================================
> --- /dev/null
> +++ linux-2.6.26-rc3-git2/security/integrity/ima/Makefile
> @@ -0,0 +1,6 @@
> +
> +obj-$(CONFIG_IMA_MEASURE) += ima.o
> +
> +ifeq ($(CONFIG_IMA_MEASURE), y)
> +ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o
> +endif

Why are the ifeq and endif lines needed?


> Index: linux-2.6.26-rc3-git2/security/integrity/ima/ima_main.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.26-rc3-git2/security/integrity/ima/ima_main.c
> @@ -0,0 +1,415 @@

...

> +/**
> + * ima_alloc_integrity - allocate and attach an integrity structure
> + * associated with the inode.
> + * @inode: the inode structure
> + *
> + * Returns 0 on success, -ENOMEM on failure
> + */

kernel-doc notation first line (short description) cannot be continued
on the following line(s).

> +static int ima_inode_alloc_integrity(struct inode *inode)
> +{
> +	struct ima_iint_cache *iint;
> +
> +	iint = ima_alloc_integrity();
> +	if (!iint)
> +		return -ENOMEM;
> +
> +	inode->i_integrity = iint;
> +	timespec_set(&iint->mtime, &inode->i_mtime);
> +	return 0;
> +}
> +
> +/**
> + * ima_inode_free_integrity - free the integrity structure associated with
> + * the inode.
> + * @inode: the inode structure
> + */

ditto.

> +static void ima_inode_free_integrity(struct inode *inode)
> +{
> +	struct ima_iint_cache *iint = inode->i_integrity;
> +
> +	if (iint) {
> +		inode->i_integrity = NULL;
> +		kfree(iint);
> +	}
> +}
> +
> +/**
> + * ima_inode_permission

Missing short function description.

> + * @inode: pointer to the inode to be measured
> + * @mask: contains MAY_READ, MAY_WRITE, MAY_APPEND or MAY_EXECUTE
> + * @nd: pointer to a nameidata
> + *
> + * Measure the file associated with the inode, if the
> + * file is open for read and the results of the call to
> + * ima_must_measure() require the file to be measured.
> + *
> + * Invalidate the PCR:
> + * 	- Opening a file for write when already open for read,
> + *	  results in a time of measure, time of use (ToMToU) error.
> + *	- Opening a file for read when already open for write,
> + * 	  could result in a file measurement error.
> + */
> +static int ima_inode_permission(struct inode *inode, int mask,
> +				struct nameidata *nd)
> +{
> +	struct ima_data idata;
> +	struct ima_args_data *data = &idata.data.args;
> +
> +	memset(&idata, 0, sizeof idata);
> +	ima_fixup_argsdata(data, inode, NULL, NULL, nd, mask, INODE_PERMISSION);
> +
> +	/* The file name is not required, but only a hint. */
> +	if (nd)
> +		data->filename = (!nd->path.dentry->d_name.name) ?
> +		    (char *)nd->path.dentry->d_iname :
> +		    (char *)nd->path.dentry->d_name.name;
> +
> +	/* Invalidate PCR, if a measured file is already open for read */
> +	if ((mask == MAY_WRITE) || (mask == MAY_APPEND)) {
> +		int mask_sav = data->mask;
> +		int rc;
> +
> +		data->mask = MAY_READ;
> +		rc = ima_must_measure(&idata);
> +		if (!rc) {
> +			if (atomic_read(&(data->dentry->d_count)) - 1 >
> +			    atomic_read(&(inode->i_writecount)))
> +				ima_add_violation(inode, data->filename,
> +						  "invalid_pcr", "ToMToU");
> +		}
> +		data->mask = mask_sav;
> +		goto out;
> +	}
> +
> +	/* measure executables later */
> +	if (mask & MAY_READ) {
> +		int rc;
> +
> +		rc = ima_must_measure(&idata);
> +		if (!rc) {
> +			/* Invalidate PCR, if a measured file is
> +			 * already open for write.
> +			 */
> +			if (atomic_read(&(inode->i_writecount)) > 0)
> +				ima_add_violation(inode, data->filename,
> +						  "invalid_pcr",
> +						  "open_writers");
> +
> +			idata.type = IMA_DATA;
> +			rc = ima_collect_measurement(&idata);
> +			if (!rc)
> +				ima_store_measurement(&idata);
> +		}
> +	}
> +out:
> +	return 0;
> +}
> +
> +/**
> + * ima_file_mmap

ditto.

> + * @inode: pointer to the inode to be measured
> + * @mask: contains MAY_READ, MAY_WRITE, MAY_APPEND or MAY_EXECUTE
> + * @nd: pointer to a nameidata
> + *
> + * Measure files being mmapped executable based on the ima_must_measure()
> + * policy decision.
> + */
> +static int ima_file_mmap(struct file *file, unsigned long reqprot,
> +			 unsigned long prot, unsigned long flags,
> +			 unsigned long addr, unsigned long addr_only)
> +{
> +	struct ima_data idata;
> +	struct ima_args_data *data = &idata.data.args;
> +	int rc = 0;
> +
> +	if (!file || !file->f_dentry)
> +		return rc;
> +	if (!(prot & VM_EXEC))
> +		return rc;
> +
> +	ima_fixup_argsdata(data, NULL, NULL, file, NULL, MAY_EXEC, FILE_MMAP);
> +	data->filename = (file->f_dentry->d_name.name) ?
> +	    (char *)file->f_dentry->d_iname :
> +	    (char *)file->f_dentry->d_name.name;
> +
> +	rc = ima_must_measure(&idata);
> +	if (!rc) {
> +		idata.type = IMA_DATA;
> +		rc = ima_collect_measurement(&idata);
> +		if (!rc)
> +			ima_store_measurement(&idata);
> +	}
> +	return 0;
> +}
> +
> +/**
> + * ima_bprm_check_integrity

ditto.

> + * @bprm: contains the linux_binprm structure
> + *
> + * The OS protects against an executable file, already open for write,
> + * from being executed in deny_write_access() and an executable file,
> + * already open for execute, from being modified in get_write_access().
> + * So we can be certain that what we verify and measure here is actually
> + * what is being executed.
> + */
> +static int ima_bprm_check_integrity(struct linux_binprm *bprm)
> +{
> +	struct ima_data idata;
> +	struct ima_args_data *data = &idata.data.args;
> +	int rc = 0;
> +
> +	ima_fixup_argsdata(data, NULL, NULL, bprm->file, NULL, MAY_EXEC,
> +			   BPRM_CHECK);
> +	data->filename = bprm->filename;
> +
> +	rc = ima_must_measure(&idata);
> +	if (!rc) {
> +		idata.type = IMA_DATA;
> +		rc = ima_collect_measurement(&idata);
> +		if (!rc)
> +			ima_store_measurement(&idata);
> +	}
> +	return 0;
> +}
> +
...

> Index: linux-2.6.26-rc3-git2/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.26-rc3-git2.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6.26-rc3-git2/Documentation/kernel-parameters.txt
> @@ -44,6 +44,7 @@ parameter is applicable:
>  	FB	The frame buffer device is enabled.
>  	HW	Appropriate hardware is enabled.
>  	IA-64	IA-64 architecture is enabled.
> +	IMA	Integrity measurement architecture is enabled.
>  	IOSCHED	More than one I/O scheduler is enabled.
>  	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
>  	ISAPNP	ISA PnP code is enabled.
> @@ -804,6 +805,17 @@ and is between 256 and 4096 characters. 
>  	ihash_entries=	[KNL]
>  			Set number of hash buckets for inode cache.
>  
> +	ima=		[IMA] Disable or enable IMA at boot time.
> +			Format: { "0" | "1" }
> +			See security/ima/Kconfig help text.
> +			0 -- disable.
> +			1 -- enable.
> +			Default value is set via kernel config option.
> +
> +	ima_hash=	[IMA] runtime ability to define hash crypto alg.
> +			Format: { "MD5" | "SHA1" }
> +			Default is "SHA1".
> +
>  	in2000=		[HW,SCSI]
>  			See header of drivers/scsi/in2000.c.
>  
> Index: linux-2.6.26-rc3-git2/security/integrity/ima/ima_api.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.26-rc3-git2/security/integrity/ima/ima_api.c
> @@ -0,0 +1,362 @@

...

> +/**
> + * ima_store_inode_measure - create and store an inode template measurement
> + * @name:ascii file name associated with the measurement hash
> + * @hash_len:length of hash value in bytes (16 for MD5, 20 for SHA1)
> + * @hash:actual hash value pre-calculated

Please put a space after the ':'s above.

> + *
> + * Returns 0 on success, error code otherwise
> + */
> +static int ima_store_inode_measure(struct inode *inode,
> +				   const unsigned char *name,
> +				   int hash_len, char *hash, int violation)
> +{
> +	struct ima_inode_measure_entry measure_entry, *entry = &measure_entry;
> +	int result;
> +	int namelen;
> +	char *op = "add_measure";
> +	char *cause = " ";
> +
> +	memset(entry, 0, sizeof *entry);
> +	if (!violation)
> +		memcpy(entry->digest, hash, hash_len > IMA_DIGEST_SIZE ?
> +		       IMA_DIGEST_SIZE : hash_len);
> +	if (name) {
> +		namelen = strlen(name);
> +		memcpy(entry->file_name, name, namelen > IMA_EVENT_NAME_LEN_MAX
> +		       ? IMA_EVENT_NAME_LEN_MAX : namelen);
> +		entry->file_name[namelen] = '\0';
> +	}
> +	result = ima_store_template_measure("ima", sizeof *entry, (char *)entry,
> +					    violation, &cause);
> +	if (result < 0)
> +		integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
> +				    name, op, cause, result);
> +	return result;
> +}
> +
> +/**
> + * ima_add_violation - violations are flagged in the measurement list
> + * with zero hash values.

Short description must be on one line.

> + * @inode: inode associated with the violation
> + * @fname: name associated with the inode
> + * @op: string pointer to audit operation (i.e. "invalid_pcr", "add_measure")
> + * @cause: string pointer to reason for violation (i.e. "ToMToU")
> + *
> + * By extending the PCR with 0xFF's instead of with zeroes, the PCR
> + * value is invalidated.
> + */
> +void ima_add_violation(struct inode *inode, const unsigned char *fname,
> +		       char *op, char *cause)
> +{
> +	int result;
> +
> +	/* can overflow, only indicator */
> +	atomic_inc(&ima_htable.violations);
> +
> +	result = ima_store_inode_measure(inode, fname, 0, NULL, 1);
> +	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, fname, op,
> +			    cause, result);
> +}
> +
> +/**
> + * skip_measurement - quick sanity check to make sure that only regular
> + * files opened for read-only or execute are measured.

Ditto.

> + * @inode: inode being measured
> + * @mask: contains the permission mask
> + *
> + * Return 1 to skip measure, 0 to measure

You can put as much text here (following the parameters) as you like/need.

> + */
> +static int skip_measurement(struct inode *inode, int mask)
> +{
> +	/* skip pseudo/virtual devices */
> +	if ((inode->i_sb->s_magic == PROC_SUPER_MAGIC)
> +	    || (inode->i_sb->s_magic == SYSFS_MAGIC)
> +	    || (inode->i_sb->s_magic == DEBUGFS_MAGIC)
> +	    || (inode->i_sb->s_magic == TMPFS_MAGIC)
> +	    || (inode->i_sb->s_magic == SECURITYFS_MAGIC)
> +	    || S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
> +		return 1;	/* can't measure */
> +
> +	if (special_file(inode->i_mode) || S_ISLNK(inode->i_mode))
> +		return 1;	/* don't measure */
> +
> +	if (S_ISREG(inode->i_mode))
> +		return 0;	/* measure */
> +	return 1;		/* don't measure */
> +}
> +
> +/**
> + * ima_must_measure - measure decision based on policy.
> + * @d - pointer to struct ima_data containing ima_args_data

 * @d:

> + *
> + * The policy is defined in terms of keypairs: subj=, obj=, func=, mask=
> + *	subj and obj: are LSM specific.
> + * 	func: INODE_PERMISSION | BPRM_CHECK | FILE_MMAP
> + * 	mask: contains the permission mask
> + *
> + * Return 0 to measure, error code otherwise
> +*/
> +int ima_must_measure(void *d)
> +{
> +	struct ima_data *idata = (struct ima_data *)d;
> +	struct ima_args_data *data = &idata->data.args;
> +
> +	if ((data->mask & MAY_WRITE) || (data->mask & MAY_APPEND))
> +		return -EPERM;
> +
> +	if (skip_measurement(data->inode, data->mask))
> +		return -EPERM;
> +
> +	if (integrity_measure_policy(data->inode, data->function, data->mask))
> +		return 0;
> +	return -EACCES;
> +}
> +
> +/**
> + * ima_collect_measurement - collect an IMA measurement and store results
> + * in the inode

Short description on 1 line.

> + * @d - pointer to struct ima_data, containing ima_args_data

 * @d:

> + *
> + * Return 0 on success, error code otherwise
> + */
> +int ima_collect_measurement(void *d)
> +{
> +	struct ima_iint_cache *iint;
> +	struct ima_data *idata = (struct ima_data *)d;
> +	struct ima_args_data *data = &idata->data.args;
> +	struct inode *inode = data->inode;
> +	struct dentry *dentry = data->dentry;
> +	struct nameidata *nd = data->nd;
> +	struct file *file = data->file;
> +	int result = 0;
> +
> +	if (!ima_enabled || idata->type != IMA_DATA)
> +		return -EPERM;
> +
> +	if (!inode || !dentry)
> +		return -EINVAL;
> +
> +	iint = inode->i_integrity;
> +	mutex_lock(&iint->mutex);
> +	if (!iint->measured) {
> +		memset(iint->digest, 0, IMA_DIGEST_SIZE);
> +		result = ima_calc_hash(dentry, file, nd, iint->digest);
> +	} else
> +		result = -EEXIST;
> +	mutex_unlock(&iint->mutex);
> +	return result;
> +}
> +
> +/**
> + * ima_store_measurement - either create and store an IMA template,
> + * or just store some other type of template measurement

ditto..

> + * @d - pointer to struct ima_data, containing either ima_args_data, used

ditto...

> + * to create an IMA template, or a template.
> + */
> +void ima_store_measurement(void *d)
> +{
> +	struct ima_data *idata = (struct ima_data *)d;
> +	int result;
> +	char *op = "add_template_measure";
> +	char *cause = "";
> +
> +	if (idata->type == IMA_DATA) {
> +		struct ima_args_data *data = &idata->data.args;
> +		struct ima_iint_cache *iint;
> +
> +		iint = data->inode->i_integrity;
> +		mutex_lock(&iint->mutex);
> +		if (iint->measured) {
> +			mutex_unlock(&iint->mutex);
> +			return;
> +		}
> +		result = ima_store_inode_measure(data->inode, data->filename,
> +						 IMA_DIGEST_SIZE, iint->digest,
> +						 0);
> +		if (!result || result == -EEXIST)
> +			iint->measured = 1;
> +		mutex_unlock(&iint->mutex);
> +	} else if (idata->type == IMA_TEMPLATE) {
> +		struct ima_store_data *template = (struct ima_store_data *)
> +		    &idata->data.template;
> +
> +		result = ima_store_template_measure(template->name,
> +						    template->len,
> +						    template->data, 0, &cause);
> +		if (result < 0)
> +			integrity_audit_msg(AUDIT_INTEGRITY_PCR, NULL,
> +					    template->name, op, cause, result);
> +	}
> +}

---
~Randy
