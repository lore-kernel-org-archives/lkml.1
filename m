Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYLIKGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYLIKGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 05:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYLIKGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 05:06:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYLIKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:06:20 -0500
Date: Tue, 9 Dec 2008 05:06:19 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Diego Elio 'Flameeyes' Petten??" <flameeyes@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add basic export support to HFS+.
Message-ID: <20081209100619.GA18141@infradead.org>
References: <20081204174706.10397.94789.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204174706.10397.94789.stgit@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 06:47:06PM +0100, Diego Elio 'Flameeyes' Petten?? wrote:
> From: Diego E. 'Flameeyes' Petten?? <flameeyes@gmail.com>
> 
> The functions' skeleton is taken from ext2/super.c and seems to work
> fine for R/W access to HFS+ non-journaled case-sensitive filesystems.
> 
> It's probably slow and has a lot of space for improvement but it's
> still better than having no hope to export HFS+ filesystems.
> 
> Signed-off-by: Diego E. 'Flameeyes' Petten?? <flameeyes@gmail.com>
> ---
> 
>  fs/hfsplus/super.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 49 insertions(+), 0 deletions(-)
> 

> +static struct inode *hfsplus_export_get_inode(struct super_block *sb,
> +					      u64 ino, u32 generation)
> +{
> +	struct inode *inode;
> +
> +	if (ino < HFSPLUS_FIRSTUSER_CNID && ino != HFSPLUS_ROOT_CNID)
> +		return ERR_PTR(-ESTALE);
> +
> +	/* iget isn't really right if the inode is currently unallocated!!
> +	 */

I don't understand this comment.  This interface is only used when
getting the FH for an already allocated inode.  hfsplus_iget is what
all other operations use in hfsplus, so it seems fine.  hfs experts
might chime in that something else might be needed due to the strange
ways links work in hfs, but from the VFS POW it seems fine.

> +	inode = hfsplus_iget(sb, ino);
> +	if (IS_ERR(inode))
> +		return ERR_CAST(inode);
> +	if (generation && inode->i_generation != generation) {
> +		/* we didn't find the right inode.. */
> +		iput(inode);
> +		return ERR_PTR(-ESTALE);
> +	}

hfsplus never updates i_generation, so this check is superflous.  Brad,
Roman: is there something that can help to guard against inode number
reuse on HFS/HFSplus?


> +/* Yes, most of these are left as NULL!!
> + * A NULL value implies the default, which (hopefully) works with
> + * hfs+-like file systems, but can be improved upon.
> + * Currently only fh_to_dentry is required.
> + */

You _do_ need a get_parent, otherwise access will magically fail once
any directory inode in a path is out of the cache.  This can be
trivially reproduced by unexporting and unmounting a filesystem while
a client has a cwd deep inside the exported filesystem.

And otherwise I don't think this comment is helpful in the code,
fh_to_parent / fh_To_dentry and get_parent is what most simpler
filesystems have.

