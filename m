Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXIFQoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXIFQoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 12:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXIFQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 12:44:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44025 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbXIFQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 12:44:07 -0400
Date: Thu, 6 Sep 2007 12:43:06 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, jengelh@computergmbh.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 1/1] Unionfs: cache-coherency - dentries
Message-ID: <20070906164306.GC25035@filer.fsl.cs.sunysb.edu>
References: <Pine.LNX.4.64.0709030849260.4454@fbirervta.pbzchgretzou.qr> <11888627882517-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11888627882517-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 07:39:48PM -0400, Josef 'Jeff' Sipek wrote:
...
>  /*
> + * Determine if the lower inode objects have changed from below the unionfs
> + * inode.  Return 1 if changed, 0 otherwise.
> + */
> +bool is_newer_lower(const struct dentry *dentry)
> +{
> +	int bindex;
> +	struct inode *inode;
> +	struct inode *lower_inode;
> +
> +	/* ignore if we're called on semi-initialized dentries/inodes */
> +	if (!dentry || !UNIONFS_D(dentry))
> +		return false;
> +	inode = dentry->d_inode;
> +	if (!inode || !UNIONFS_I(inode) ||
> +	    ibstart(inode) < 0 || ibend(inode) < 0)
> +		return false;
> +
> +	for (bindex = ibstart(inode); bindex <= ibend(inode); bindex++) {
> +		lower_inode = unionfs_lower_inode_idx(inode, bindex);
> +		if (!lower_inode)
> +			continue;
> +		/*
> +		 * We may want to apply other tests to determine if the
> +		 * lower inode's data has changed, but checking for changed
> +		 * ctime and mtime on the lower inode should be enough.
> +		 */
> +		if (timespec_compare(&inode->i_mtime,
> +				     &lower_inode->i_mtime) < 0) {
> +			printk("unionfs: new lower inode mtime "
> +			       "(bindex=%d, name=%s)\n", bindex,
> +			       dentry->d_name.name);
> +			return true; /* mtime changed! */
> +		}
> +		if (timespec_compare(&inode->i_ctime,
> +				     &lower_inode->i_ctime) < 0) {
> +			printk("unionfs: new lower inode ctime "
> +			       "(bindex=%d, name=%s)\n", bindex,
> +			       dentry->d_name.name);
> +			return true; /* ctime changed! */
> +		}
> +	}
> +	return true;		/* default: lower is not newer */

This was a thinko, it should have returned false. I'll send an updated
patch for completeness.

Josef 'Jeff' Sipek.

-- 
Only two things are infinite, the universe and human stupidity, and I'm not
sure about the former.
		- Albert Einstein
