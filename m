Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZGMNxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZGMNxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbZGMNxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:53:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbZGMNx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:53:29 -0400
Date: Mon, 13 Jul 2009 09:53:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090713135324.GB3685@infradead.org>
References: <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com> <20090709075100.GU2714@wotan.suse.de> <4A59A517.1080605@panasas.com> <20090712144717.GA18163@infradead.org> <20090713065917.GO14666@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713065917.GO14666@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 08:59:17AM +0200, Nick Piggin wrote:
> Agreed, if it is a common sequence / requirement for filesystems
> then of course I will not object to a helper to make things clearer
> or share code.
> 
> I would like to see inode_setattr renamed into simple_setattr, and
> then also .setattr made mandatory, so I don't like to cut code out
> of inode_setattr which makes it unable to be the simple_setattr
> after the old truncate code is removed.

But inode_setattr isn't anything like simple_setattr.  Except for
the truncate special case it's really just a helper to copy values
into the inode.  It doesn't even even have the same prototype as
->setattr.

A simple_setattr would look like the following:

int simple_setattr(struct dentry *dentry, struct iattr *iattr)
{
	struct inode *inode = dentry->d_inode;
	int error;

	error = inode_change_ok(inode, iattr);
        if (error)
                return error;

	if ((iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid) ||
	    (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)) {
		if (vfs_dq_transfer(inode, iattr))
			return -EDQUOT;
	}

	if (iattr->ia_valid & ATTR_ATTR_SIZE &&
	    iattr->ia_size !== i_size_read(inode) &&
	    inode->i_op->new_truncate) {
		error = simple_setsize(inode, attr->ia_size);
		if (error)
			return error;
	}

	return inode_setattr(inode, attr);
}

