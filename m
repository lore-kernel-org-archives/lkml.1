Return-Path: <linux-kernel-owner+w=401wt.eu-S1751601AbZH0Rfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbZH0Rfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZH0Rfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:35:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZH0Rfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:35:42 -0400
Date: Thu, 27 Aug 2009 13:35:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
       linux-fsdevel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
       ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
       Anton Altaparmakov <aia21@cantab.net>,
       linux-ntfs-dev@lists.sourceforge.net,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090827173540.GA19115@infradead.org>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <1250875447-15622-8-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250875447-15622-8-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int generic_write_sync(struct file *file, loff_t pos, loff_t count)
> +{
> +	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
> +		return 0;
> +	return generic_sync_file(file, file->f_path.dentry, pos,
> +				 pos + count - 1,
> +				 SYNC_SUBMIT_DATA | SYNC_WAIT_DATA);
> +}
> +EXPORT_SYMBOL(generic_write_sync);

>  
> +/* Flags for generic_sync_file */
> +#define SYNC_INODE		1
> +#define SYNC_SUBMIT_DATA	2
> +#define SYNC_WAIT_DATA		4

When I think about this more I really hate the latter two flags.
There's really no reason to just do only either the submit or wait.
I'd say kill the flags for now and just implement generic_write_sync
as:

int generic_write_sync(struct file *file, loff_t pos, loff_t count)
{
	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
		return 0;
	return vfs_fsync_range(file, file->f_path.dentry, pos,
			       pos + count - 1, 1);
}

and we can look into replacing the datasync flag with something more
meaningfull later through the whole fsync stack.
