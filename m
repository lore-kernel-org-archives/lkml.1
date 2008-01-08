Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbYAHV7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbYAHV7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYAHV6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:58:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59090 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbYAHV62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:58:28 -0500
Date: Tue, 8 Jan 2008 15:58:07 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, shaggy@us.ibm.com, sandeen@redhat.com,
       jmoyer@redhat.com
Subject: Re: [PATCH] eCryptfs: Fix dentry handling on create error, unlink, and inode destroy
Message-ID: <20080108215807.GE10989@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080108052542.GX10989@localhost.austin.ibm.com> <20080107214517.ebf5a5bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107214517.ebf5a5bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 09:45:17PM -0800, Andrew Morton wrote:
> On Mon, 7 Jan 2008 23:25:42 -0600 Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> 
> > --- a/fs/ecryptfs/inode.c
> > +++ b/fs/ecryptfs/inode.c
> > @@ -120,22 +120,9 @@ ecryptfs_do_create(struct inode *directory_inode,
> >  	rc = ecryptfs_create_underlying_file(lower_dir_dentry->d_inode,
> >  					     ecryptfs_dentry, mode, nd);
> >  	if (rc) {
> > -		struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
> > -		struct ecryptfs_inode_info *inode_info =
> > -			ecryptfs_inode_to_private(ecryptfs_inode);
> > -
> > -		printk(KERN_WARNING "%s: Error creating underlying file; "
> > -		       "rc = [%d]; checking for existing\n", __FUNCTION__, rc);
> > -		if (inode_info) {
> > -			mutex_lock(&inode_info->lower_file_mutex);
> > -			if (!inode_info->lower_file) {
> > -				mutex_unlock(&inode_info->lower_file_mutex);
> > -				printk(KERN_ERR "%s: Failure to set underlying "
> > -				       "file; rc = [%d]\n", __FUNCTION__, rc);
> > -				goto out_lock;
> > -			}
> > -			mutex_unlock(&inode_info->lower_file_mutex);
> > -		}
> > +		printk(KERN_ERR "%s: Failure to create dentry in lower fs; "
> > +		       "rc = [%d]\n", __FUNCTION__, rc);
> > +		goto out_lock;
> >  	}
> >  	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
> >  				directory_inode->i_sb, 0);
> 
> Will this cause an undesirable log storm if the underlying fs runs
> out of space?

When you're bumping up against the end of your storage space, you will
get a lot more that just this message in your logs. There are printk's
in ecryptfs_write_lower(), ecryptfs_encrypt_page(), ecryptfs_write(),
and ecryptfs_write_metadata_to_contents() that will get pretty
noisy. Is it worth wrapping those in a higher level of verbosity?

Mike
