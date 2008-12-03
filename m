Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYLCSRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYLCSRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYLCSRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:17:31 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34136 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYLCSRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:17:30 -0500
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1228260925.2971.240.camel@nimitz>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
	 <1228260925.2971.240.camel@nimitz>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 13:17:16 -0500
Message-Id: <1228328236.2821.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 15:35 -0800, Dave Hansen wrote: 
> On Tue, 2008-12-02 at 16:47 -0500, Mimi Zohar wrote:
> > index 0000000..6c6fcd9
> > --- /dev/null
> > +++ b/security/integrity/ima/Kconfig
> > @@ -0,0 +1,34 @@
> > +#
> > +# IBM Integrity Measurement Architecture
> > +#
> > +config IMA
> > +	bool "Integrity Measurement Architecture(IMA)"
> > +	depends on INTEGRITY
> > +	depends on ACPI
> > +	select SECURITYFS
> > +	select CRYPTO
> > +	select CRYPTO_HMAC
> > +	select CRYPTO_MD5
> > +	select CRYPTO_SHA1
> > +	select TCG_TPM
> > +	select TCG_TIS
> > +	help
> > +	  The Trusted Computing Group(TCG) runtime Integrity
> > +	  Measurement Architecture(IMA) maintains a list of hash
> > +	  values of executables and other sensitive system files
> > +	  loaded into the run-time of this system.  If your system
> > +	  has a TPM chip, then IMA also maintains an aggregate
> > +	  integrity value over this list inside the TPM hardware.
> > +	  These measurements and the aggregate (signed inside the
> > +	  TPM) can be retrieved and presented to remote parties to
> > +	  establish system properties. If unsure, say N.
> 
> This still doesn't tell me how it helps me.  "If an attacker managed to
> change the contents of an important system file being measured, we can
> tell."  Right?

Yes, that is a clearer description. Thanks.

> > +config IMA_MEASURE_PCR_IDX
> > +	int "PCR for Aggregate (8 <= Index <= 14)"
> > +	depends on IMA
> > +	range 8 14
> > +	default 10
> > +	help
> > +	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
> > +	  that IMA uses to maintain the integrity aggregate of the
> > +	  measurement list.  If unsure, use the default 10.
> 
> Why would you want to change this?  Can it be done at runtime instead of
> compile time?  I don't know what a PCR is.

The only reason to change it would be if in the future, TCG decides on a
standard PCR for IMA, other than 10, or if they pick 10 for something
else. We really don't need a runtime variable for this, but kconfig
makes it easy to change once if necessary in the future.

> > +#define ima_printk(level, format, arg...)		\
> > +	printk(level "ima (%s): " format, __func__, ## arg)
> > +
> > +#define ima_error(format, arg...)	\
> > +	ima_printk(KERN_ERR, format, ## arg)
> > +
> > +#define ima_info(format, arg...)	\
> > +	ima_printk(KERN_INFO, format, ## arg)
> 
> Please don't.  Can you use pr_debug() and friends?

will clean this up.

> > +/* digest size for IMA, fits SHA1 or MD5 */
> > +#define IMA_DIGEST_SIZE		20
> 
> When another algorithm (with a longer digest) is added, will we detect
> that without this just plain breaking?
>  

As the kernel command line option "ima_hash=" verifies the crypto
algorithm specified, changes to the code would be required to support a
new algorithm anyway.

> > +struct ima_h_table {
> > +	atomic_long_t len;	/* number of stored measurements in the list */
> > +	atomic_long_t violations;
> > +	unsigned int max_htable_size;
> > +	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
> > +	atomic_t queue_len[IMA_MEASURE_HTABLE_SIZE];
> > +};
> > +extern struct ima_h_table ima_htable;
> > +
> > +static inline unsigned long IMA_HASH_KEY(u8 *digest)
> > +{
> > +	return (hash_long(*digest, IMA_HASH_BITS));
> > +}
> 
> 'return' isn't a function. :)

> Also, please lower-case this sucker so we know it isn't a macro.

Ok

> > +void ima_add_violation(struct inode *inode, const unsigned char *filename,
> > +		       char *op, char *cause)
> > +{
> > +	int result, namelen;
> > +	struct ima_inode_measure_entry measure_entry;
> > +	struct ima_store_template_data template = {
> > +		.name = "ima",
> > +		.len = sizeof(measure_entry),
> > +		.data = (char *)&measure_entry,
> > +		.violation = 1,
> > +	};
> 
> If '.data' is a char*, perhaps it should be a void*.  If it already is a
> void*, you don't need a cast. 
> 
> > +int ima_must_measure(void *data)
> > +{
> > +	struct ima_measure_data *mdata = (struct ima_measure_data *)data;
> 
> No need to cast a void*.  You have several of these.  Please find all of
> them and fix them up.

Thank you. will be in the next set patches.

> > +	struct ima_iint_cache *iint;
> > +	int must_measure = -EACCES;
> > +
> > +	if (!S_ISREG(mdata->inode->i_mode))
> > +		return -EPERM;
> > +	if ((mdata->mask & MAY_WRITE) || (mdata->mask & MAY_APPEND))
> > +		return -EPERM;
> > +
> > +	rcu_read_lock();
> > +	iint = ima_iint_lookup(mdata->inode);
> > +	if (iint)
> > +		kref_get(&iint->refcount);
> > +	rcu_read_unlock();
> 
> All of ima_iint_lookup()'s callers do the exact same thing.  Please just
> make it ima_iint_find_get(), and do the RCU and kref_get() internally
> and once.

cleaner, thanks.

> > +	if (!iint) {
> > +		int rc;
> > +
> > +		/* Most insertions are done at inode_alloc,
> > +		 * except those allocated before late_initcall.
> > +		 * Can't initialize at security_initcall,
> > +		 * got to wait at least until proc_init.
> > +		 */
> > +		rc = ima_iint_insert(mdata->inode);
> > +		if (rc < 0)
> > +			return rc;
> > +
> > +		rcu_read_lock();
> > +		iint = ima_iint_lookup(mdata->inode);
> > +		if (!iint) {
> > +			rcu_read_unlock();
> > +			return -ENOMEM;
> > +		}
> > +		kref_get(&iint->refcount);
> > +		rcu_read_unlock();
> > +	}
> 
> How about a retry goto instead of just copying the code again?  Better
> yet, can you just stick all of this in a helper function?

After the ima_iint_find_get() recommendation above, this becomes a lot
smaller.

> > +int ima_iint_insert(struct inode *inode)
> > +{
> > +	struct ima_iint_cache *iint;
> > +	int rc = 0;
> > +
> > +	iint = kzalloc(sizeof(*iint), GFP_KERNEL);
> 
> Does this basically get done for every inode, or only special ones?  I
> just wonder if having a dedicated slab with a constructor to do
> redundant things like mutex_init() would be helpful.

every inode, except those allocated before init_latecall.

> > +static void ima_add_boot_aggregate(void)
> > +{
> > +	struct ima_inode_measure_entry measure_entry;
> > +	struct ima_store_template_data template = {
> > +		.name = "ima",
> > +		.len = sizeof(measure_entry),
> > +		.data = (char *)&measure_entry,
> > +	};
> > +	int namelen, result;
> > +
> > +	memset(&measure_entry, 0, sizeof measure_entry);
> > +	namelen = strlen(boot_aggregate_name);
> > +	if (namelen > IMA_EVENT_NAME_LEN_MAX)
> > +		namelen = IMA_EVENT_NAME_LEN_MAX;
> > +	memcpy(measure_entry.file_name, boot_aggregate_name, namelen);
> > +
> > +	if (ima_used_chip) {
> > +		int i;
> > +		u8 pcr_i[IMA_DIGEST_SIZE];
> > +		struct hash_desc desc;
> > +		struct crypto_hash *tfm;
> > +		struct scatterlist sg;
> 
> All of this stack stuff with very important, large sounding names makes
> me nervous.  Can you reassure me?

The crypto code here will be moved to ima_crypto.c and will be
refactored, cleaning up the code. Both measure_entry and template could
be allocated/freed each time, but does that make sense?

> > +		tfm = crypto_alloc_hash(ima_hash, 0, CRYPTO_ALG_ASYNC);
> > +		if (!tfm || IS_ERR(tfm)) {
> > +			ima_error("error initializing digest.\n");
> > +			return;
> > +		}
> > +		desc.tfm = tfm;
> > +		desc.flags = 0;
> > +		crypto_hash_init(&desc);
> > +
> > +		/* cumulative sha1 over tpm registers 0-7 */
> > +		for (i = 0; i < 8; i++) {
> 
> Surely there's a NR_TPM_REGISTERS or similar somewhere.

Will look.

> > +static void ima_file_free(struct file *file)
> > +{
> > +	struct inode *inode = file->f_dentry->d_inode;
> > +	struct ima_iint_cache *iint;
> > +
> > +	if (S_ISDIR(inode->i_mode))
> > +		return;
> > +	if ((file->f_mode & FMODE_WRITE) &&
> > +	    (atomic_read(&inode->i_writecount) == 1)) {
> > +		rcu_read_lock();
> > +		iint = ima_iint_lookup(inode);
> > +		if (!iint) {
> > +			rcu_read_unlock();
> > +			return;
> > +		}
> > +		kref_get(&iint->refcount);
> > +		rcu_read_unlock();
> > +
> > +		mutex_lock(&iint->mutex);
> > +		if (iint->version != inode->i_version)
> > +			iint->flags &= ~IMA_MEASURED;
> > +		mutex_unlock(&iint->mutex);
> > +		kref_put(&iint->refcount, iint_free);
> > +	}
> > +}
> 
> I'm also wondering if there's a way to wrap up the mutex operations
> since this seems to be done the exact same way every time.  Dunno, maybe
> it is too much locking obfuscation for just a few lines saved.

Unlike the ima_iint_lookup(), the code within the mutex locking differs
between calls.

> > +static int ima_path_check_integrity(struct path *path, int mask)
> > +{
> > +	struct ima_measure_data mdata;
> > +
> > +	memset(&mdata, 0, sizeof mdata);
> > +	mdata.inode = path->dentry->d_inode;
> > +	mdata.mask = mask;
> > +	mdata.function = PATH_CHECK;
> > +
> > +	/* Invalidate PCR, if a measured file is already open for read */
> > +	if ((mdata.mask & (MAY_WRITE | MAY_READ)) == MAY_WRITE) {
> 
> It would warm my heart to see something like this:
> 
> int mdata_is_write_only(struct ima_measure_data *mdata)
> {
> 	if (mdata.mask & MAY_READ)
> 		return 0;
> 	return mdata.mask & MAY_WRITE;
> }
> 
> I don't know about you, but I find that immeasurably nicer.  Is it even
> right?

In addition to MAY_READ/MAY_WRITE, there might be other flags.

Mimi

