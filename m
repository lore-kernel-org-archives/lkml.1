Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbXISR2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbXISR2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXISR15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:27:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53855 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXISR14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:27:56 -0400
Date: Wed, 19 Sep 2007 18:27:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 02/24] rearrange may_open() to be r/o friendly
Message-ID: <20070919172754.GB20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182720.A41D6484@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182720.A41D6484@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:20AM -0700, Dave Hansen wrote:
> 
> may_open() calls vfs_permission() before it does checks for
> IS_RDONLY(inode).  It checks _again_ inside of vfs_permission().
> 
> The check inside of vfs_permission() is going away eventually.
> With the mnt_want/drop_write() functions, all of the r/o
> checks (except for this one) are consistently done before
> calling permission().  Because of this, I'd like to use
> permission() to hold a debugging check to make sure that
> the mnt_want/drop_write() calls are actually being made.
> 
> So, to do this:
> 1. remove the IS_RDONLY() check from permission()
> 2. enforce that you must mnt_want_write() before
>    even calling permission()
> 3. enable a debugging in permission()
> 
> We need to rearrange may_open().  Here's the patch.

>  int permission(struct inode *inode, int mask, struct nameidata *nd)
>  {
>  	int retval, submask;
> +	struct vfsmount *mnt = NULL;
> +
> +	if (nd)
> +		mnt = nd->mnt;
>  
>  	if (mask & MAY_WRITE) {
>  		umode_t mode = inode->i_mode;
> @@ -251,7 +255,7 @@ int permission(struct inode *inode, int 
>  		 * MAY_EXEC on regular files is denied if the fs is mounted
>  		 * with the "noexec" flag.
>  		 */
> -		if (nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))
> +		if (mnt && (mnt->mnt_flags & MNT_NOEXEC))

Why is this entirely unrelated cleanup in this patch?

Except for that it looks fine.
