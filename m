Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbYJODcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbYJODcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 23:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYJODcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 23:32:03 -0400
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:56404
	"EHLO QMTA03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbYJODcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 23:32:00 -0400
X-Authority-Analysis: v=1.0 c=1 a=QRrVz1ppMu4A:10 a=6l_f0kDhyVEA:10
 a=ye6wd2jDDb6w8gPa7ZAA:9 a=xlduFtWR97VI2pqT_zkA:7
 a=fpueN9hCVHL6ZlL3r7dt8rKLQHgA:4 a=nbrB6oW77rQA:10
Date: Tue, 14 Oct 2008 22:32:01 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 3/3] integrity: IMA as an integrity service provider
Message-ID: <20081015033201.GA19409@hallyn.com>
References: <cover.1223869200.git.zohar@localhost.localdomain> <eed26e96710921cf350f6ae55d00f5178fe165be.1223869200.git.zohar@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eed26e96710921cf350f6ae55d00f5178fe165be.1223869200.git.zohar@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> This is a re-release of Integrity Measurement Architecture(IMA) as an
> independent Linunx Integrity Module(LIM) service provider.
> 
> This version addresses the merge issues resulting from the removal of
> the nameidata parameter to inode_permission().
>   - The parameter changes to integrity_inode_permission() are reflected
>     here in this patch.
> 
> As a LIM integrity provider, IMA implements the new LIM must_measure(),
> collect_measurement(), store_measurement(), and display_template() API
> calls. The store_measurement() call supports two types of data, IMA
> (i.e. file data) and generic template data.
> 
> IMA provides hardware (TPM) based measurement and attestation for both
> files and other types of template measurements. As the Trusted Computing
> (TPM) model requires, IMA measures all files before they are accessed
> in any way (on the bprm_check_integrity, file_mmap and inode_permission
> hooks), and commits the measurements to the TPM.  In addition, IMA
> maintains a list of these hash values, which can be used to validate
> the aggregate PCR value.  The TPM can sign these measurements, and thus
> the system can prove to itself and to a third party these measurements
> in a way that cannot be circumvented by malicious or compromised software.
> 
> When store_measurement() is called for the IMA type of data, the file
> measurement and the file name hint are used to form an IMA template.
> IMA then calculates the IMA template measurement(hash) and submits it
> to the TPM chip for inclusion in one of the chip's Platform Configuration
> Registers (PCR).
> 
> When store_measurement() is called for generic template data, IMA
> calculates the measurement(hash) of the template data, and submits
> the template measurement to the TPM chip for inclusion in one of the
> chip's Platform Configuration Registers(PCR).
> 
> In order to view the contents of template data through securityfs, the
> template_display() function must be defined in the registered
> template_operations.  In the case of the IMA template, the list of
> file names and files hashes submitted can be viewed through securityfs.
> 
> As mentioned above, IMA maintains a list of hash values of executables
> and other sensitive system files loaded into the run-time of the system.
> Our work has shown that requests for integrity appraisal and measurement
> need to be based on knowledge of the filesystem, requiring the system
> to either be labeled with integrity data or depend on the existent LSM
> security labels.  The previous set of integrity patches modified the LSM
> modules to be integrity context aware, meaning that the LSM modules made
> integrity data/metadata appraisal and measurement API calls based on
> an understanding of the LSM security labels.  Both of the LSM maintainers
> felt that the changes were too intrusive and that integrity enforcement
> should be made by the integrity provider, not the LSM module.
> 
> To address these concerns, Stephen Smalley suggested using the
> security_audit_rule_match(), renamed to security_filter_rule_match(), to
> define LSM specific integrity measurement policy rules, in lieu of
> modifying the LSM modules.  In the current set of patches, the integrity
> API calls can be made either by IMA, based on an LSM specific integrity
> policy, or by an integrity context aware LSM.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  Documentation/ABI/testing/ima_policy |   60 +++++
>  Documentation/kernel-parameters.txt  |    5 +
>  include/linux/ima.h                  |   46 ++++
>  security/integrity/Kconfig           |    5 +-
>  security/integrity/Makefile          |    2 +
>  security/integrity/ima/Kconfig       |   48 ++++
>  security/integrity/ima/Makefile      |    9 +
>  security/integrity/ima/ima.h         |  170 ++++++++++++
>  security/integrity/ima/ima_api.c     |  348 +++++++++++++++++++++++++
>  security/integrity/ima/ima_crypto.c  |  153 +++++++++++
>  security/integrity/ima/ima_fs.c      |  473 ++++++++++++++++++++++++++++++++++
>  security/integrity/ima/ima_init.c    |  105 ++++++++
>  security/integrity/ima/ima_main.c    |  354 +++++++++++++++++++++++++
>  security/integrity/ima/ima_policy.c  |  334 ++++++++++++++++++++++++
>  security/integrity/ima/ima_queue.c   |  124 +++++++++
>  15 files changed, 2233 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/ABI/testing/ima_policy
>  create mode 100644 include/linux/ima.h
>  create mode 100644 security/integrity/ima/Kconfig
>  create mode 100644 security/integrity/ima/Makefile
>  create mode 100644 security/integrity/ima/ima.h
>  create mode 100644 security/integrity/ima/ima_api.c
>  create mode 100644 security/integrity/ima/ima_crypto.c
>  create mode 100644 security/integrity/ima/ima_fs.c
>  create mode 100644 security/integrity/ima/ima_init.c
>  create mode 100644 security/integrity/ima/ima_main.c
>  create mode 100644 security/integrity/ima/ima_policy.c
>  create mode 100644 security/integrity/ima/ima_queue.c
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> new file mode 100644
> index 0000000..c9ab220
> --- /dev/null
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -0,0 +1,60 @@
> +What:		security/ima/policy
> +Date:		May 2008
> +Contact:	Mimi Zohar <zohar@us.ibm.com>
> +Description:
> +		The Trusted Computing Group(TCG) runtime Integrity
> +		Measurement Architecture(IMA) maintains a list of hash
> +		values of executables and other sensitive system files
> +		loaded into the run-time of this system.  At runtime,
> +		the policy can be constrained based on LSM specific data.
> +		Policies are loaded into security/ima/policy by opening
> +		the file, writing the rules one at a time and then
> +		closing the file.  The new policy takes effect after
> +		the security/ima/policy is closed.
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
> +			# SELINUX_MAGIC
> +			dont_measure fsmagic=0xF97CFF8C
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
> +			dont_measure obj_type=var_log_t
> +			dont_measure obj_type=auditd_log_t
> +			measure subj_user=system_u func=INODE_PERM mask=MAY_READ
> +			measure subj_role=system_r func=INODE_PERM mask=MAY_READ
> +
> +		Smack:
> +			measure subj_user=_ func=INODE_PERM mask=MAY_READ
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 772d19a..982556d 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -44,6 +44,7 @@ parameter is applicable:
>  	FB	The frame buffer device is enabled.
>  	HW	Appropriate hardware is enabled.
>  	IA-64	IA-64 architecture is enabled.
> +	IMA     Integrity measurement architecture is enabled.
>  	INTEGRITY Integrity support is enabled.
>  	IOSCHED	More than one I/O scheduler is enabled.
>  	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
> @@ -858,6 +859,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  	ihash_entries=	[KNL]
>  			Set number of hash buckets for inode cache.
>  
> +	ima_hash=	[IMA] runtime ability to define hash crypto algorithm.
> +			Format: { "MD5" | "SHA1" }
> +			Default is "SHA1".
> +
>  	in2000=		[HW,SCSI]
>  			See header of drivers/scsi/in2000.c.
>  
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> new file mode 100644
> index 0000000..c777b71
> --- /dev/null
> +++ b/include/linux/ima.h
> @@ -0,0 +1,46 @@
> +/*
> + * ima.h
> + *
> + * Copyright (C) 2008 IBM Corporation
> + * Author: Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, version 2 of the License.
> + */
> +
> +#ifndef _LINUX_IMA_H
> +#define _LINUX_IMA_H
> +
> +/* IMA LIM Data */
> +enum ima_type { IMA_DATA, IMA_METADATA, IMA_TEMPLATE };
> +
> +struct ima_args_data {
> +	const char	*filename;
> +	struct file 	*file;
> +	struct path 	*path;
> +	struct dentry 	*dentry;
> +	struct inode 	*inode;
> +	enum lim_hooks	function;
> +	u32		osid;
> +	int 		mask;
> +};
> +
> +struct ima_store_data {
> +	char 		*name;
> +	int 		len;
> +	char 		*data;
> +	int  		violation;
> +};
> +
> +struct ima_data {
> +	enum ima_type 	type;
> +	union {
> +		struct ima_args_data 	args;
> +		struct ima_store_data	template;
> +	} data;
> +};
> +
> +void ima_fixup_argsdata(struct ima_args_data *data, struct file *file,
> +			struct path *path, int mask, int function);
> +#endif
> diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
> index 3c29050..28b44e3 100644
> --- a/security/integrity/Kconfig
> +++ b/security/integrity/Kconfig
> @@ -2,8 +2,6 @@
>  # Integrity configuration
>  #
>  
> -menu "Integrity options"
> -
>  config INTEGRITY
>  	bool "Enable different integrity models"
>  	help
> @@ -21,4 +19,5 @@ config INTEGRITY_AUDIT
>  	  allows integrity auditing to be disabled at boot.  If this
>  	  option is selected, integrity auditing can be disabled with
>  	  'integrity_audit=0' on the kernel command line.
> -endmenu
> +
> +source security/integrity/ima/Kconfig
> diff --git a/security/integrity/Makefile b/security/integrity/Makefile
> index c9fb803..8eb7a4a 100644
> --- a/security/integrity/Makefile
> +++ b/security/integrity/Makefile
> @@ -4,3 +4,5 @@
>  
>  # Object file lists
>  obj-$(CONFIG_INTEGRITY)			+= integrity.o integrity_audit.o
> +
> +obj-$(CONFIG_IMA)			+= ima/
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> new file mode 100644
> index 0000000..ca25b0b
> --- /dev/null
> +++ b/security/integrity/ima/Kconfig
> @@ -0,0 +1,48 @@
> +#
> +# IBM Integrity Measurement Architecture
> +#
> +
> +config IMA
> +	bool "Integrity Measurement Architecture(IMA)"
> +	depends on INTEGRITY
> +	depends on ACPI
> +	select CRYPTO
> +	select CRYPTO_HMAC
> +	select CRYPTO_MD5
> +	select CRYPTO_SHA1
> +	select TCG_TPM
> +	select TCG_TIS
> +	help
> +	  The Trusted Computing Group(TCG) runtime Integrity
> +	  Measurement Architecture(IMA) maintains a list of hash
> +	  values of executables and other sensitive system files
> +	  loaded into the run-time of this system.  If your system
> +	  has a TPM chip, then IMA also maintains an aggregate
> +	  integrity value over this list inside the TPM hardware.
> +	  These measurements and the aggregate (signed inside the
> +	  TPM) can be retrieved and presented to remote parties to
> +	  establish system properties. If unsure, say N.
> +
> +config IMA_MEASURE_PCR_IDX
> +	int "PCR for Aggregate (8 <= Index <= 14)"
> +	depends on IMA
> +	range 8 14
> +	default 10
> +	help
> +	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
> +	  that IMA uses to maintain the integrity aggregate of the
> +	  measurement list.  If unsure, use the default 10.
> +
> +config IMA_BASE_HOOKS
> +	bool "IMA base hooks"
> +	depends on IMA
> +	default n
> +	help
> +	  Enable this option to allow the LSM module to enforce integrity.
> +
> +config IMA_LSM_RULES
> +	bool "Enable LSM measurement policy rules"
> +	depends on IMA && (SECURITY_SELINUX || SECURITY_SMACK)
> +	default y
> +	help
> +	  Disabling this option will not enforce LSM based policy rules.
> diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
> new file mode 100644
> index 0000000..f3aced4
> --- /dev/null
> +++ b/security/integrity/ima/Makefile
> @@ -0,0 +1,9 @@
> +#
> +# Makefile for building Trusted Computing Group's(TCG) runtime Integrity
> +# Measurement Architecture(IMA).
> +#
> +
> +obj-$(CONFIG_IMA) += ima.o
> +
> +ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
> +	 ima_policy.o
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> new file mode 100644
> index 0000000..aed5f9f
> --- /dev/null
> +++ b/security/integrity/ima/ima.h
> @@ -0,0 +1,170 @@
> +/*
> + * Copyright (C) 2005,2006,2007,2008 IBM Corporation
> + *
> + * Authors:
> + * Reiner Sailer <sailer@watson.ibm.com>
> + * Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + * File: ima.h
> + *	internal ima definitions
> + */
> +
> +#ifndef __LINUX_IMA_H
> +#define __LINUX_IMA_H
> +
> +#include <linux/types.h>
> +#include <linux/crypto.h>
> +#include <linux/security.h>
> +#include <linux/integrity.h>
> +#include <linux/hash.h>
> +#include <linux/tpm.h>
> +
> +#define ima_printk(level, format, arg...)		\
> +	printk(level "ima (%s): " format, __func__, ## arg)
> +
> +#define ima_error(format, arg...)	\
> +	ima_printk(KERN_ERR, format, ## arg)
> +
> +#define ima_info(format, arg...)	\
> +	ima_printk(KERN_INFO, format, ## arg)
> +
> +/* digest size for IMA, fits SHA1 or MD5 */
> +#define IMA_DIGEST_SIZE		20
> +#define IMA_EVENT_NAME_LEN_MAX	255
> +
> +#define IMA_HASH_BITS 9
> +#define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
> +
> +/* set during initialization */
> +extern int ima_used_chip;
> +extern char *ima_hash;
> +
> +struct ima_measure_entry {
> +	u8 digest[IMA_DIGEST_SIZE];	/* sha1 or md5 measurement hash */
> +	char template_name[IMA_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
> +	int template_len;
> +	char *template;
> +};
> +
> +struct ima_queue_entry {
> +	struct hlist_node hnext;	/* place in hash collision list */
> +	struct list_head later;		/* place in ima_measurements list */
> +	struct ima_measure_entry *entry;
> +};
> +extern struct list_head ima_measurements;	/* list of all measurements */
> +
> +/* declarations */
> +extern int ima_template_mode;
> +extern const struct template_operations ima_template_ops;
> +
> +/* Internal IMA function definitions */
> +int ima_init(void);
> +void ima_cleanup(void);
> +int ima_fs_init(void);
> +void ima_fs_cleanup(void);
> +void ima_create_htable(void);
> +int ima_add_measure_entry(struct ima_measure_entry *entry, int violation);
> +struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest);
> +int ima_calc_hash(struct file *file, struct path *path, char *digest);
> +int ima_calc_template_hash(int template_len, char *template, char *digest);
> +void ima_add_violation(struct inode *inode, const unsigned char *fname,
> +			char *op, char *cause);
> +
> +enum ima_action {DONT_MEASURE, MEASURE};
> +int ima_match_policy(struct inode *inode, enum lim_hooks func, int mask);
> +int ima_add_rule(int, char *subj_user, char *subj_role, char *subj_type,
> +		 char *obj_user, char *obj_role, char *obj_type,
> +		 char *func, char *mask, char *fsmagic, char *uid);
> +void ima_init_policy(void);
> +void ima_update_policy(void);
> +
> +
> +/* LIM API function definitions */
> +int ima_must_measure(void *d);
> +int ima_collect_measurement(void *d);
> +int ima_appraise_measurement(void *d);
> +void ima_store_measurement(void *d);
> +void ima_template_show(struct seq_file *m, void *e,
> +			     enum integrity_show_type show);
> +
> +
> +/*
> + * used to protect h_table and sha_table
> + */
> +extern spinlock_t ima_queue_lock;
> +
> +struct ima_h_table {
> +	atomic_long_t len;	/* number of stored measurements in the list */
> +	atomic_long_t violations;
> +	unsigned int max_htable_size;
> +	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
> +	atomic_t queue_len[IMA_MEASURE_HTABLE_SIZE];
> +};
> +extern struct ima_h_table ima_htable;
> +
> +static inline unsigned long IMA_HASH_KEY(u8 *digest)
> +{
> +	 return(hash_ptr(digest, IMA_HASH_BITS));
> +}
> +
> +/* TPM "Glue" definitions */
> +
> +#define IMA_TPM ((((u32)TPM_ANY_TYPE)<<16) | (u32)TPM_ANY_NUM)
> +static inline void ima_extend(const u8 *hash)
> +{
> +	if (!ima_used_chip)
> +		return;
> +
> +	if (tpm_pcr_extend(IMA_TPM, CONFIG_IMA_MEASURE_PCR_IDX, hash) != 0)
> +		ima_error("Error Communicating to TPM chip\n");
> +}
> +
> +static inline void ima_pcrread(int idx, u8 *pcr, int pcr_size)
> +{
> +	if (!ima_used_chip)
> +		return;
> +
> +	if (tpm_pcr_read(IMA_TPM, idx, pcr) != 0)
> +		ima_error("Error Communicating to TPM chip\n");
> +}
> +
> +struct ima_inode_measure_entry {
> +	u8 digest[IMA_DIGEST_SIZE];	/* sha1/md5 measurement hash */
> +	char file_name[IMA_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
> +};
> +
> +/* inode integrity data */
> +struct ima_iint_cache {
> +	u64 		version;
> +	int 		measured;
> +	u8 		hmac[IMA_DIGEST_SIZE];
> +	u8 		digest[IMA_DIGEST_SIZE];
> +	struct mutex mutex;
> +};
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
> +				   void *lsmrule, struct audit_context *actx)
> +{
> +	return -EINVAL;
> +}
> +#endif
> +#endif
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> new file mode 100644
> index 0000000..c6d93bc
> --- /dev/null
> +++ b/security/integrity/ima/ima_api.c
> @@ -0,0 +1,348 @@
> +/*
> + * Copyright (C) 2008 IBM Corporation
> + *
> + * Author: Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + * File: ima_api.c
> + *            - implements the LIM API
> + */
> +#include <linux/module.h>
> +#include <linux/integrity.h>
> +#include <linux/magic.h>
> +#include <linux/writeback.h>
> +#include <linux/string.h>
> +#include <linux/list.h>
> +#include <linux/audit.h>
> +#include <linux/ima.h>
> +
> +#include "ima.h"
> +
> +const struct template_operations ima_template_ops = {
> +	.must_measure = ima_must_measure,
> +	.collect_measurement = ima_collect_measurement,
> +	.store_measurement = ima_store_measurement,
> +	.display_template = ima_template_show
> +};
> +
> +/**
> + * mode_setup - for compatability with non-template IMA versions
> + * @str: is pointer to a string
> + */
> +int ima_template_mode = 1;
> +static int __init mode_setup(char *str)
> +{
> +	if (strncmp(str, "ima", 3) == 0)
> +		ima_template_mode = 0;
> +	if (strncmp(str, "template", 7) == 0)
> +		ima_template_mode = 1;
> +	ima_info("template_mode %s \n",
> +		  ima_template_mode ? "template" : "ima");
> +	return 1;
> +}
> +
> +__setup("ima_mode=", mode_setup);
> +
> +/**
> + * ima_digest_cpy - copy the hash in the IMA template structure to a digest
> + * @template_name: string containing the name of the template (i.e. "ima")
> + * @template: pointer to template structure
> + * @digest: pointer to the digest
> + *
> + * Returns 0 on success, error code otherwise
> + */
> +static int ima_digest_cpy(char *template_name, void *template, u8 *digest)
> +{
> +	int rc, result = 0;
> +	struct ima_inode_measure_entry *inode_template =
> +	    (struct ima_inode_measure_entry *)template;
> +
> +	rc = strcmp(template_name, "ima");
> +	if (rc == 0)
> +		memcpy(digest, inode_template->digest,
> +		       sizeof inode_template->digest);
> +	else
> +		result = -ENODATA;
> +	return result;
> +}
> +
> +/**
> + * ima_store_template_measure - collect and protect template measurements
> + * @template_name: string containing the name of the template (i.e. "ima")
> + * @template_len: length of the template data
> + * @template: actual template data
> + * @violation: invalidate pcr measurement indication
> + * @audit_cause: string containing the audit failure cause
> + *
> + * Calculate the hash of a template entry, add the template entry
> + * to an ordered list of measurement entries maintained inside the kernel,
> + * and also update the aggregate integrity value (maintained inside the
> + * configured TPM PCR) over the hashes of the current list of measurement
> + * entries.
> + *
> + * Applications retrieve the current kernel-held measurement list through
> + * the securityfs entries in /sys/kernel/security/ima. The signed aggregate
> + * TPM PCR (called quote) can be retrieved using a TPM user space library
> + * and is used to validate the measurement list.
> + *
> + * Returns 0 on success, error code otherwise
> + */
> +static int ima_store_template_measure(char *template_name, int template_len,
> +				      char *template, int violation,
> +				      char **audit_cause)
> +{
> +	struct ima_measure_entry *entry;
> +	u8 digest[IMA_DIGEST_SIZE];
> +	struct ima_queue_entry *qe;
> +	int count, result = 0;
> +
> +	memset(digest, 0, IMA_DIGEST_SIZE);
> +	if (!violation) {
> +		int rc = -ENODATA;
> +
> +		if (!ima_template_mode)
> +			rc = ima_digest_cpy(template_name, template, digest);
> +		if (rc < 0)
> +			result = ima_calc_template_hash(template_len, template,
> +							digest);
> +
> +		/* hash exists already? */
> +		qe = ima_lookup_digest_entry(digest);
> +		if (qe) {
> +			*audit_cause = "hash_exists";
> +			result = -EEXIST;
> +			goto out;
> +		}
> +	}
> +
> +	/* create new entry and add to measurement list */
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry) {
> +		*audit_cause = "ENOMEM";
> +		result = -ENOMEM;
> +		goto out;
> +	}
> +
> +	entry->template = kzalloc(template_len, GFP_KERNEL);
> +	if (!entry->template) {
> +		*audit_cause = "ENOMEM";
> +		result = -ENOMEM;
> +		goto out;
> +	}
> +	if (!template_name) {
> +		*audit_cause = "null_template_name";
> +		count = 1;
> +	} else {
> +		count = strlen(template_name);
> +		if (count > IMA_EVENT_NAME_LEN_MAX)
> +			count = IMA_EVENT_NAME_LEN_MAX;
> +		memcpy(entry->template_name, template_name, count);
> +	}
> +	entry->template_name[count] = '\0';
> +	entry->template_len = template_len;
> +	memcpy(entry->template, template, template_len);
> +	memcpy(entry->digest, digest, IMA_DIGEST_SIZE);
> +
> +	result = ima_add_measure_entry(entry, violation);
> +	if (result < 0)
> +		kfree(entry);
> +out:
> +	return result;
> +}
> +
> +/**
> + * ima_store_inode_measure - create and store an inode template measurement
> + * @name: ascii file name associated with the measurement hash
> + * @hash_len: length of hash value in bytes (16 for MD5, 20 for SHA1)
> + * @hash: actual hash value pre-calculated
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
> + * ima_add_violation - add violation to measurement list.
> + * @inode: inode associated with the violation
> + * @fname: name associated with the inode
> + * @op: string pointer to audit operation (i.e. "invalid_pcr", "add_measure")
> + * @cause: string pointer to reason for violation (i.e. "ToMToU")
> + *
> + * Violations are flagged in the measurement list with zero hash values.
> + * By extending the PCR with 0xFF's instead of with zeroes, the PCR
> + * value is invalidated.
> + */
> +void ima_add_violation(struct inode *inode, const unsigned char *fname,
> +		       char *op, char *cause)
> +{
> +	int result;
> +
> +	/* can overflow, only indicator */
> +	atomic_long_inc(&ima_htable.violations);
> +
> +	result = ima_store_inode_measure(inode, fname, 0, NULL, 1);
> +	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, fname, op,
> +			    cause, result);
> +}
> +
> +/**
> + * skip_measurement - measure only regular files, skip everything else.
> + * @inode: inode being measured
> + * @mask: contains the permission mask
> + *
> + * Quick sanity check to make sure that only regular files opened
> + * for read-only or execute are measured.
> + *
> + * Return 1 to skip measure, 0 to measure
> + */
> +static int skip_measurement(struct inode *inode, int mask)
> +{
> +	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
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
> + * @template_data: pointer to struct ima_data containing ima_args_data
> + *
> + * The policy is defined in terms of keypairs:
> + * 		subj=, obj=, type=, func=, mask=, fsmagic=
> + *	subj,obj, and type: are LSM specific.
> + * 	func: INODE_PERMISSION | BPRM_CHECK | FILE_MMAP
> + * 	mask: contains the permission mask
> + *	fsmagic: hex value
> + *
> + * Return 0 to measure. For matching a DONT_MEASURE policy, no policy,
> + * or other error, return an error code.
> +*/
> +int ima_must_measure(void *template_data)
> +{
> +	struct ima_data *idata = (struct ima_data *)template_data;
> +	struct ima_args_data *data = &idata->data.args;
> +	int rc;
> +
> +	if ((data->mask & MAY_WRITE) || (data->mask & MAY_APPEND))
> +		return -EPERM;
> +
> +	if (skip_measurement(data->inode, data->mask))
> +		return -EPERM;
> +
> +	rc = ima_match_policy(data->inode, data->function, data->mask);
> +	if (rc)
> +		return 0;
> +	return -EACCES;
> +}
> +
> +/**
> + * ima_collect_measurement - collect file measurements and store in the inode
> + * @template_data: pointer to struct ima_data containing ima_args_data
> + *
> + * Return 0 on success, error code otherwise
> + */
> +int ima_collect_measurement(void *template_data)
> +{
> +	struct ima_iint_cache *iint;
> +	struct ima_data *idata = (struct ima_data *)template_data;
> +	struct ima_args_data *data = &idata->data.args;
> +	struct dentry *dentry = data->dentry;
> +	struct inode *inode = data->inode;
> +	int result = 0;
> +
> +	if (idata->type != IMA_DATA)
> +		return -EPERM;
> +
> +	if (!inode || !dentry)
> +		return -EINVAL;
> +
> +	iint = inode->i_integrity;
> +	mutex_lock(&iint->mutex);

ima_collect_measurement will be called under rcu_read_lock(),
won't it?  So you can't take a mutex, bc that could sleep.

> +	if (!iint->measured) {
> +		memset(iint->digest, 0, IMA_DIGEST_SIZE);
> +		result = ima_calc_hash(data->file, data->path, iint->digest);
> +	} else
> +		result = -EEXIST;
> +	mutex_unlock(&iint->mutex);
> +	return result;
> +}
> +
> +/**
> + * ima_store_measurement - store file and template measurements
> + * @template_data: pointer to struct ima_data containing ima_args_data,
> + * used to create an IMA template, or a template.
> + *
> + * For file measurements, first create an IMA template and then store it.
> + * For all other types of template measurements, just store it.
> + */
> +void ima_store_measurement(void *template_data)
> +{
> +	struct ima_data *idata = (struct ima_data *)template_data;
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

Same here.

-serge
