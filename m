Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYJBIRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYJBIRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYJBIQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:16:58 -0400
Received: from verein.lst.de ([213.95.11.210]:41267 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYJBIQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:16:56 -0400
Date: Thu, 2 Oct 2008 10:16:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute support
Message-ID: <20081002081644.GB24717@lst.de>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com> <1222293680-15451-14-git-send-email-mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222293680-15451-14-git-send-email-mfasheh@suse.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 03:00:54PM -0700, Mark Fasheh wrote:
>  	xattr.o			\
> +	xattr_user.o		\
> +	xattr_trusted.o

Please don't split this up, it's always been a really stupid idea in
extN.  The only difference between secure, trusted and user attrs is
that they go into a different namespace bit (and have different
permission checking, but that's handled in the VFS).  I have some
upcoming patches to store a fs private flag in struct xattr_handler
so that even those flags wrappers can go away, and each of the
namespaces will just be five lines of code for the xattr_handler
declaration.

> +static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
> +{
> +	struct xattr_handler *handler = NULL;
> +
> +	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
> +		handler = ocfs2_xattr_handler_map[name_index];
> +
> +	return handler;
> +}

You seem to need the handler mostly for getting back to the prefix
from the handler.  This is a pretty clear indicator that you don't
want to use the xattr_handler splitting but deal with the whole
attr name.  Take a look at the btrfs code after my recent xattr changes
on how to handle this more nicely.


> +
> +static inline u32 ocfs2_xattr_name_hash(struct inode *inode,
> +					char *prefix,
> +					int prefix_len,
> +					char *name,
> +					int name_len)

And I think there's far too much inlining going on in here..

