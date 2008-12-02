Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYLBXfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYLBXfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYLBXfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:35:33 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54925 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYLBXfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:35:31 -0500
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 15:35:25 -0800
Message-Id: <1228260925.2971.240.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 16:47 -0500, Mimi Zohar wrote:
> index 0000000..6c6fcd9
> --- /dev/null
> +++ b/security/integrity/ima/Kconfig
> @@ -0,0 +1,34 @@
> +#
> +# IBM Integrity Measurement Architecture
> +#
> +config IMA
> +	bool "Integrity Measurement Architecture(IMA)"
> +	depends on INTEGRITY
> +	depends on ACPI
> +	select SECURITYFS
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

This still doesn't tell me how it helps me.  "If an attacker managed to
change the contents of an important system file being measured, we can
tell."  Right?

> +config IMA_MEASURE_PCR_IDX
> +	int "PCR for Aggregate (8 <= Index <= 14)"
> +	depends on IMA
> +	range 8 14
> +	default 10
> +	help
> +	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
> +	  that IMA uses to maintain the integrity aggregate of the
> +	  measurement list.  If unsure, use the default 10.

Why would you want to change this?  Can it be done at runtime instead of
compile time?  I don't know what a PCR is. :(

> +#define ima_printk(level, format, arg...)		\
> +	printk(level "ima (%s): " format, __func__, ## arg)
> +
> +#define ima_error(format, arg...)	\
> +	ima_printk(KERN_ERR, format, ## arg)
> +
> +#define ima_info(format, arg...)	\
> +	ima_printk(KERN_INFO, format, ## arg)

Please don't.  Can you use pr_debug() and friends?

> +/* digest size for IMA, fits SHA1 or MD5 */
> +#define IMA_DIGEST_SIZE		20

When another algorithm (with a longer digest) is added, will we detect
that without this just plain breaking?

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
> +	return (hash_long(*digest, IMA_HASH_BITS));
> +}

'return' isn't a function. :)

Also, please lower-case this sucker so we know it isn't a macro.

> +void ima_add_violation(struct inode *inode, const unsigned char *filename,
> +		       char *op, char *cause)
> +{
> +	int result, namelen;
> +	struct ima_inode_measure_entry measure_entry;
> +	struct ima_store_template_data template = {
> +		.name = "ima",
> +		.len = sizeof(measure_entry),
> +		.data = (char *)&measure_entry,
> +		.violation = 1,
> +	};

If '.data' is a char*, perhaps it should be a void*.  If it already is a
void*, you don't need a cast. 

> +int ima_must_measure(void *data)
> +{
> +	struct ima_measure_data *mdata = (struct ima_measure_data *)data;

No need to cast a void*.  You have several of these.  Please find all of
them and fix them up.

> +	struct ima_iint_cache *iint;
> +	int must_measure = -EACCES;
> +
> +	if (!S_ISREG(mdata->inode->i_mode))
> +		return -EPERM;
> +	if ((mdata->mask & MAY_WRITE) || (mdata->mask & MAY_APPEND))
> +		return -EPERM;
> +
> +	rcu_read_lock();
> +	iint = ima_iint_lookup(mdata->inode);
> +	if (iint)
> +		kref_get(&iint->refcount);
> +	rcu_read_unlock();

All of ima_iint_lookup()'s callers do the exact same thing.  Please just
make it ima_iint_find_get(), and do the RCU and kref_get() internally
and once.

> +	if (!iint) {
> +		int rc;
> +
> +		/* Most insertions are done at inode_alloc,
> +		 * except those allocated before late_initcall.
> +		 * Can't initialize at security_initcall,
> +		 * got to wait at least until proc_init.
> +		 */
> +		rc = ima_iint_insert(mdata->inode);
> +		if (rc < 0)
> +			return rc;
> +
> +		rcu_read_lock();
> +		iint = ima_iint_lookup(mdata->inode);
> +		if (!iint) {
> +			rcu_read_unlock();
> +			return -ENOMEM;
> +		}
> +		kref_get(&iint->refcount);
> +		rcu_read_unlock();
> +	}

How about a retry goto instead of just copying the code again?  Better
yet, can you just stick all of this in a helper function?

> +int ima_iint_insert(struct inode *inode)
> +{
> +	struct ima_iint_cache *iint;
> +	int rc = 0;
> +
> +	iint = kzalloc(sizeof(*iint), GFP_KERNEL);

Does this basically get done for every inode, or only special ones?  I
just wonder if having a dedicated slab with a constructor to do
redundant things like mutex_init() would be helpful.

> +void ima_iint_delete(struct inode *inode)
> +{
> +	struct ima_iint_cache *iint;
> +
> +	spin_lock(&ima_iint_lock);
> +	iint = radix_tree_delete(&ima_iint_store, (unsigned long)inode);
> +	spin_unlock(&ima_iint_lock);
> +	if (iint)
> +		kref_put(&iint->refcount, iint_free);
> +}

If you're looking for another way to split your patch out, you could
just stick use inode->integrity for the first patch, then introduce your
radix-tree in a subsequent patch.  It would be functionally fine, and
more clearly separate out the ideas.

> diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
> new file mode 100644
> index 0000000..374b368
> --- /dev/null
> +++ b/security/integrity/ima/ima_init.c
> @@ -0,0 +1,90 @@
> +/*
> + * Copyright (C) 2005,2006,2007,2008 IBM Corporation
> + *
> + * Authors:
> + * Reiner Sailer      <sailer@watson.ibm.com>
> + * Leendert van Doorn <leendert@watson.ibm.com>
> + * Mimi Zohar         <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + * File: ima_init.c
> + *             initialization and cleanup functions
> + */
> +#include <linux/module.h>
> +#include <linux/scatterlist.h>
> +#include "ima.h"
> +
> +/* name for boot aggregate entry */
> +static char *boot_aggregate_name = "boot_aggregate";
> +int ima_used_chip;
> +
> +static void ima_add_boot_aggregate(void)
> +{
> +	struct ima_inode_measure_entry measure_entry;
> +	struct ima_store_template_data template = {
> +		.name = "ima",
> +		.len = sizeof(measure_entry),
> +		.data = (char *)&measure_entry,
> +	};
> +	int namelen, result;
> +
> +	memset(&measure_entry, 0, sizeof measure_entry);
> +	namelen = strlen(boot_aggregate_name);
> +	if (namelen > IMA_EVENT_NAME_LEN_MAX)
> +		namelen = IMA_EVENT_NAME_LEN_MAX;
> +	memcpy(measure_entry.file_name, boot_aggregate_name, namelen);
> +
> +	if (ima_used_chip) {
> +		int i;
> +		u8 pcr_i[IMA_DIGEST_SIZE];
> +		struct hash_desc desc;
> +		struct crypto_hash *tfm;
> +		struct scatterlist sg;

All of this stack stuff with very important, large sounding names makes
me nervous.  Can you reassure me?

> +		tfm = crypto_alloc_hash(ima_hash, 0, CRYPTO_ALG_ASYNC);
> +		if (!tfm || IS_ERR(tfm)) {
> +			ima_error("error initializing digest.\n");
> +			return;
> +		}
> +		desc.tfm = tfm;
> +		desc.flags = 0;
> +		crypto_hash_init(&desc);
> +
> +		/* cumulative sha1 over tpm registers 0-7 */
> +		for (i = 0; i < 8; i++) {

Surely there's a NR_TPM_REGISTERS or similar somewhere.

> +			ima_pcrread(i, pcr_i, sizeof(pcr_i));
> +			/* now accumulate with current aggregate */
> +			sg_init_one(&sg, (u8 *) pcr_i, IMA_DIGEST_SIZE);
> +			crypto_hash_update(&desc, &sg, IMA_DIGEST_SIZE);
> +		}
> +		crypto_hash_final(&desc, measure_entry.digest);
> +		crypto_free_hash(tfm);
> +	} else
> +		template.violation = 1;
> +
> +	/* now add measurement; if TPM bypassed, we have a ff..ff entry */
> +	result = ima_store_template(&template);
> +}
> +
> +int ima_init(void)
> +{
> +	int rc;
> +
> +	ima_used_chip = 0;
> +	rc = tpm_pcr_read(IMA_TPM, 0, NULL);
> +	if (rc == 0)
> +		ima_used_chip = 1;
> +
> +	if (!ima_used_chip)
> +		ima_info("No TPM chip found(rc = %d), activating TPM-bypass!\n",
> +			 rc);

For the record, I think this is the kind of place that it's worth going
over 80 chars.

> +static void ima_file_free(struct file *file)
> +{
> +	struct inode *inode = file->f_dentry->d_inode;
> +	struct ima_iint_cache *iint;
> +
> +	if (S_ISDIR(inode->i_mode))
> +		return;
> +	if ((file->f_mode & FMODE_WRITE) &&
> +	    (atomic_read(&inode->i_writecount) == 1)) {
> +		rcu_read_lock();
> +		iint = ima_iint_lookup(inode);
> +		if (!iint) {
> +			rcu_read_unlock();
> +			return;
> +		}
> +		kref_get(&iint->refcount);
> +		rcu_read_unlock();
> +
> +		mutex_lock(&iint->mutex);
> +		if (iint->version != inode->i_version)
> +			iint->flags &= ~IMA_MEASURED;
> +		mutex_unlock(&iint->mutex);
> +		kref_put(&iint->refcount, iint_free);
> +	}
> +}

I'm also wondering if there's a way to wrap up the mutex operations
since this seems to be done the exact same way every time.  Dunno, maybe
it is too much locking obfuscation for just a few lines saved.

> +static int ima_path_check_integrity(struct path *path, int mask)
> +{
> +	struct ima_measure_data mdata;
> +
> +	memset(&mdata, 0, sizeof mdata);
> +	mdata.inode = path->dentry->d_inode;
> +	mdata.mask = mask;
> +	mdata.function = PATH_CHECK;
> +
> +	/* Invalidate PCR, if a measured file is already open for read */
> +	if ((mdata.mask & (MAY_WRITE | MAY_READ)) == MAY_WRITE) {

It would warm my heart to see something like this:

int mdata_is_write_only(struct ima_measure_data *mdata)
{
	if (mdata.mask & MAY_READ)
		return 0;
	return mdata.mask & MAY_WRITE;
}

I don't know about you, but I find that immeasurably nicer.  Is it even
right?

> +		int rc;
> +
> +		mdata.mask = MAY_READ;
> +		rc = ima_must_measure(&mdata);
> +		if (!rc || rc == -EEXIST) {
> +			if (atomic_read(&(path->dentry->d_count)) - 1 >
> +			    atomic_read(&(mdata.inode->i_writecount)))
> +				ima_add_violation(mdata.inode,
> +						  path->dentry->d_name.name,
> +						  "invalid_pcr", "ToMToU");
> +		}
> +		return 0;
> +	}


I have memories of talking about this bit.  I was confused and you
explained it to me, but it still isn't explained in the code. :(  Again,
I'm not convinced that this works.  Can the code convince me, or should
I go digging in my inbox?

Could you please break this out into a separate function where you have
some room to comment it and don't have to wrap it at 80 columns so
badly?

> +	/* measure executables later */
> +	if ((mdata.mask & (MAY_WRITE | MAY_READ)) == MAY_READ) {
> +		int rc;
> +
> +		rc = ima_must_measure(&mdata);
> +		if (!rc || rc == -EEXIST) {
> +			/* Invalidate PCR, if a measured file is
> +			 * already open for write.
> +			 */
> +			if (atomic_read(&(mdata.inode->i_writecount)) > 0)
> +				ima_add_violation(mdata.inode,
> +						  path->dentry->d_name.name,
> +						  "invalid_pcr",
> +						  "open_writers");
> +		}
> +		if (!rc) {
> +			struct dentry *de = dget(path->dentry);
> +			struct vfsmount *mnt = mntget(path->mnt);
> +			struct file *file;
> +
> +			file = dentry_open(de, mnt, O_RDONLY);
> +			if (IS_ERR(file)) {
> +				ima_info("%s dentry_open failed\n",
> +					 de->d_name.name);
> +			} else if (file) {
> +				rc = ima_collect_measurement(file);
> +				if (!rc) {
> +					struct ima_store_data sdata;
> +
> +					sdata.file = file;
> +					sdata.filename =
> +					    file->f_dentry->d_name.name;
> +					ima_store_measurement(&sdata);
> +				}
> +				fput(file);
> +			}
> +		}
> +	}
> +	return 0;
> +}

I really think this hurts readability.  I also see three callers to
ima_collect_measurement() that do the exact same thing. 

Mimi, I'm really getting the idea that this patch hasn't had much work
put into its structure.  I'm going to stop reviewing it now because I'm
running into the same issues again and again and I think these issues
are really slowing down my ability to look at it.

Please take a really, really hard look at these patches, all 3000 lines
of it, and try to rework them.  Find common bits of code that are
duplicated or copy-n-pasted around.  Find functions that have gotten too
long and break them up.  I bet you can knock a couple hundred lines of
code off this sucker, easy.

If I've misunderstood things in your code, please go back and comment
them.  If I got confused, surely someone else could.  

-- Dave

