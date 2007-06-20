Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbXFTLuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbXFTLuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbXFTLuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:50:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33495 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbXFTLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:50:04 -0400
Subject: Re: [RFC][Patch 1/1] IBAC Patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@us.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070619222314.GA24880@vino.hallyn.com>
References: <1182199690.8577.11.camel@localhost.localdomain>
	 <20070619222314.GA24880@vino.hallyn.com>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 07:52:41 -0400
Message-Id: <1182340361.9195.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 17:23 -0500, Serge E. Hallyn wrote:

> > +#define get_file_security(file) ((unsigned long)(file->f_security))
> > +#define set_file_security(file, val) (file->f_security = (void *)val)
> > +
> > +#define get_task_security(task) ((unsigned long)(task->security))
> > +#define set_task_security(task, val) (task->security = (void *)val)
> 
> I understand the above are likely remnants of stacker lsm support, and I
> hate to say this, but not only is having those in there going to be
> frowned upon, it then leads you later on to do things like
> 
> 	if (get_file_security(file)==0)
> 
> when using 0 for null upsets people in itself.

Instead of allocating memory for file->f_security, it uses 
file->f_security itself, for storing 0 or 1.  So it isn't
checking to see if it is NULL per se.

> > +
> > +#define XATTR_MEASURE_SUFFIX "measure"
> > +#define XATTR_MEASURE_SUFFIX_LEN (sizeof (XATTR_MEASURE_SUFFIX) -1)
> > +
> > +struct ibac_isec_data {
> > +	int mmapped;		/* no. of times inode mmapped */
> > +	int measure;		/* inode tagged to be measured */
> > +	spinlock_t lock;	/* protect inode state */
> > +};
> > +
> > +static int ibac_inode_alloc_security(struct inode *inode)
> > +{
> > +	struct ibac_isec_data *isec;
> > +
> > +	isec = kzalloc(sizeof(struct ibac_isec_data), GFP_KERNEL);
> > +	if (!isec)
> > +		return -ENOMEM;
> > +
> > +	spin_lock_init(&isec->lock);
> > +	inode->i_security = isec;
> 
> Heh, for file and task security you use the above helpers, but for inode
> you do it like this?  :)  Please replace all x_security assignments and
> checks with this format.

For file and task, the code uses the security field itself to store
information as opposed to allocating storage for it.   In the case of 
inode, it is using it for both the original digsig mmap tracking and 
now to tag the inode that it needs to be measured.  Tagging the inode
to be measured is based on the existence of the security.measure xattr,
which is controlled by a userspace application.  The difference is
that storage is allocated for inode->i_security.

> > +/*
> > + * For all inodes allocate inode->i_security(isec), before the security
> > + * subsystem is enabled.
> > + */
> > +static void ibac_fixup_inodes(void)
> > +{
> > +	struct super_block *sb;
> > +
> > +	spin_lock(&sb_lock);
> > +	list_for_each_entry(sb, &super_blocks, s_list) {
> > +		struct inode *inode;
> > +
> > +		spin_unlock(&sb_lock);
> > +
> > +		spin_lock(&inode_lock);
> > +		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > +			spin_unlock(&inode_lock);
> > +
> > +			spin_lock(&inode->i_lock);
> > +			if (!inode->i_security)
> > +				ibac_inode_alloc_security(inode);
> 
> since ibac_inode_alloc_security can return -ENOMEM, maybe you should at
> least check for that condition and warn the user?

Yes, that definitely is a good idea.  Will do.

> > +			spin_unlock(&inode->i_lock);
> > +
> > +			spin_lock(&inode_lock);
> > +		}
> > +		spin_unlock(&inode_lock);
> > +
> > +		spin_lock(&sb_lock);
> > +	}
> > +	spin_unlock(&sb_lock);
> > +}
> > +

> > +static int ibac_inode_permission(struct inode *inode, int mask,
> > +				 struct nameidata *nd)
> > +{
> > +	struct ibac_isec_data *isec = inode->i_security;
> > +	struct dentry *dentry;
> > +	char *path = NULL;
> > +	char *fname = NULL;
> > +	int rc = 0;
> > +	int measure;
> > +
> > +	dentry = (!nd || !nd->dentry) ? d_find_alias(inode) : nd->dentry;
> > +	if (!dentry)
> > +		return 0;
> > +	if (nd) {		/* preferably use fullname */
> > +		path = (char *)__get_free_page(GFP_KERNEL);
> > +		if (path)
> > +			fname = d_path(nd->dentry, nd->mnt, path, PAGE_SIZE);
> > +	}
> > +
> > +	if (!fname)		/* no choice, use short name */
> > +		fname = (!dentry->d_name.name) ? (char *)dentry->d_iname :
> > +		    (char *)dentry->d_name.name;
> 
> Please separate the above out into a helper function.

Ok.

> This name is only ever used for debugging, right?  I didn't miss any
> place where the name is used for some security decision?

Correct, the filename is not used for any security decision, but it 
is passed to integrity_measure(), which the IMA integrity provider
associates with the given hash value.  To see the filename hints
'cat /sys/kernel/security/ima/ascii_runtime_measurements'.

> > +
> > +	/* Measure labeled files */
> > +	spin_lock(&isec->lock);
> > +	measure = isec->measure;
> > +	spin_unlock(&isec->lock);
> > +
> > +	if (S_ISREG(inode->i_mode) && (measure == 1)
> > +	    && (mask & MAY_READ)) {
> > +		rc = verify_metadata_integrity(dentry);
> > +		if (rc == 0)
> > +			rc = verify_and_measure_integrity(dentry, NULL,
> > +							  fname, mask);
> > +	}
> > +
> > +	/* Deny permission to write, if currently mmapped. */
> > +	if (inode && mask & MAY_WRITE) {
> > +		spin_lock(&isec->lock);
> > +		if (isec->mmapped > 0) {
> > +			printk(KERN_INFO "%s: %s - denied write access"
> > +			       " (isec=%d)\n",
> > +			       __FUNCTION__, fname, isec->mmapped);
> > +			rc = -EPERM;
> > +		}
> > +		spin_unlock(&isec->lock);
> > +	}
> > +
> > +	if (!nd || !nd->dentry)
> > +		dput(dentry);
> > +	if (path)
> > +		free_page((unsigned long)path);
> > +	return rc;
> > +}

