Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbYB1Xyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbYB1Xyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYB1Xyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:54:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYB1Xyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:54:32 -0500
Date: Thu, 28 Feb 2008 18:54:27 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
Message-ID: <20080228235427.GA17757@infradead.org>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov> <1204150294-4678-4-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204150294-4678-4-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 05:11:26PM -0500, David P. Quigley wrote:
> This patch adds two new fields to the iattr structure. The first field holds a
> security label while the second contains the length of this label. In addition
> the patch adds a new helper function inode_setsecurity which calls the LSM to
> set the security label on the inode. Finally the patch modifies the necessary
> functions such that fsnotify_change can handle notification requests for
> dnotify and inotify.

Please don't overload setattr with this.  Just looking at your callers
shows that it's much cleaner as a separate method.

Now what's really lacking is a desciption _why_ you actually need it
to start with.  The current method to set security labels is through
the security.* xattrs.  Now if we want to clean up that somewhat
messy method that might be a good idea, but we should do it for all
callers and not just some.

> +#define DN_LABEL        0x00000040      /* File (re)labeled */

An any inotify/dnotify additions should be separate from the vfs to
filesystem interface.  Please make it a separate patch and describe
properly why it's needed in it's description.

> index df6b95d..1169963 100644
> --- a/include/linux/xattr.h
> +++ b/include/linux/xattr.h
> @@ -50,6 +50,7 @@ ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
>  ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
>  ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
>  int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
> +int vfs_setxattr_locked(struct dentry *, char *, void *, size_t, int);
>  int vfs_removexattr(struct dentry *, char *);
>  
>  ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
> -- 
> 1.5.3.8
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
