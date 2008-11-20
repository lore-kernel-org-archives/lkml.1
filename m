Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbYKTSPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbYKTSPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYKTSPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:15:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbYKTSPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:15:24 -0500
Date: Thu, 20 Nov 2008 13:15:23 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 3/4] integrity: IMA as an integrity service provider
Message-ID: <20081120181523.GA4444@infradead.org>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com> <342f87b65eae2369d96501d8d4935d6be0f46678.1227137423.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <342f87b65eae2369d96501d8d4935d6be0f46678.1227137423.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, after the API is sorted out I had a quick looks at this patch.

The first very odd thing is the data strucutures:

> +struct ima_args_data {
> +	const char *filename;
> +	struct file *file;
> +	struct path *path;
> +	struct dentry *dentry;
> +	struct inode *inode;
> +	enum lim_hooks function;
> +	u32 osid;
> +	int mask;
> +};

You can always get from a file to a path, from a path to a dentry,
from a dentry to and inode and from a path to some defintion of a
filename.  So a lot of things here seems very redundant.

When looking at how it's used it's acually even worse.  AFAICS the
code would be a lot cleaner if you'd just kill struct ima_args_data
and the odd pass arguments as void pointers obsfucations and just
pass the file/path + mask directly to the lower level functions.

That's also help killing things like ima_store_measurement which
do entirely different things depending on idata->type.

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

This could just be an

	if (!S_ISREG(inode->i_mode))

in the caller..

> +static int update_file_hash(struct file *f, struct path *path,
> +			    struct hash_desc *desc)

Please split this into a update_file_hash that always operates on a
struct file, and a wrapper around it that creates the struct file
for the cases that needs it.

> +void ima_fixup_argsdata(struct ima_args_data *data, struct file *file,
> +			struct path *path, int mask, int function)
> +{
> +	struct dentry *dentry = NULL;
> +
> +	data->file = file;
> +	data->path = path;
> +	data->mask = mask;
> +	data->function = function;
> +
> +	if (file)
> +		data->dentry = dentry = file->f_dentry;
> +
> +	if (path) {
> +		if (!dentry)
> +			data->dentry = dentry = path->dentry;
> +	}
> +	if (dentry)
> +		data->inode = dentry->d_inode;
> +
> +	return;
> +}

You have two different callers for this, either file NULL or path NULL
but never neither or both.  So just do the setup in the callers and do
the right thing there.  (and please kill the inode member, it's entirely
superflous)

> +static void ima_file_free(struct file *file)
> +{
> +	struct inode *inode = NULL;
> +	struct ima_iint_cache *iint;
> +
> +	if (!file->f_dentry)	/* can be NULL */
> +		return;

No, it can't.

> +
> +	inode = file->f_dentry->d_inode;
> +	if (S_ISDIR(inode->i_mode))
> +		return;
> +	if ((file->f_mode & FMODE_WRITE) &&
> +	    (atomic_read(&inode->i_writecount) == 1)) {

> + * Returns 0 on success, -ENOMEM on failure
> + */
> +static int ima_inode_alloc_integrity(struct inode *inode)
> +{
> +	return ima_iint_insert(inode);
> +}
> +
> +/**
> + * ima_inode_free_integrity - free the integrity structure
> + * @inode: the inode structure
> + */
> +static void ima_inode_free_integrity(struct inode *inode)
> +{
> +	ima_iint_delete(inode);
> +}

Why these wrappers?

> +	/* The file name is only a hint. */
> +	dentry = path->dentry;
> +	data->filename = (!dentry->d_name.name) ? (char *)dentry->d_iname :
> +	    (char *)dentry->d_name.name;

d_iname is the internal storage for d_name, always use d_name only.

> +	/* Invalidate PCR, if a measured file is already open for read */
> +	if ((mask == MAY_WRITE) || (mask == MAY_APPEND)) {

MAY_APPEND is ORed into a mask, but never used standalone.

> +		if (!rc) {
> +			if (atomic_read(&(data->dentry->d_count)) - 1 >
> +			    atomic_read(&(inode->i_writecount)))
> +				ima_add_violation(inode, data->filename,
> +						  "invalid_pcr", "ToMToU");
> +		}

> +			if (atomic_read(&(inode->i_writecount)) > 0)
> +				ima_add_violation(inode, data->filename,
> +						  "invalid_pcr",
> +						  "open_writers");

All these d_count and i_writecount access needs a lot of explanation,
they certainly don't make sense as-is, but I'd like to find out what
you're actually trying to do here.

> +	if (!file || !file->f_dentry)
> +		return rc;

Can't happen.

> +#define audit_type(type) AUDIT_ ##type
> +#define lsm_type(type) LSM_ ##type

Just spelling out the constants would be a lot more readable..

