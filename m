Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbYEOHuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbYEOHuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYEOHt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:49:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58559 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYEOHt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:49:56 -0400
Date: Thu, 15 May 2008 08:49:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/24] vfs: truncate: append-only checking cleanup
Message-ID: <20080515074952.GU13907@ZenIV.linux.org.uk>
References: <20080506091327.259950960@szeredi.hu> <20080506091418.842237934@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506091418.842237934@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 11:13:37AM +0200, Miklos Szeredi wrote:
> -	error = -EPERM;
> -	if (IS_APPEND(inode))
> -		goto mnt_drop_write_and_out;
> -
>  	error = get_write_access(inode);
>  	if (error)
>  		goto mnt_drop_write_and_out;

errno change and worse than that - we
	a) get different errno with append-only file mmaped shared
	b) break_lease() happening, despite the file being append-only

> @@ -321,10 +317,6 @@ static long do_sys_ftruncate(unsigned in
>  	if (small && length > MAX_NON_LFS)
>  		goto out_putf;
>  
> -	error = -EPERM;
> -	if (IS_APPEND(inode))
> -		goto out_putf;
> -
>  	error = locks_verify_truncate(inode, file, length);

Again, errno change...

> @@ -1639,8 +1639,6 @@ int may_open(struct nameidata *nd, int a
>  	if (IS_APPEND(inode)) {
>  		if  ((flag & FMODE_WRITE) && !(flag & O_APPEND))
>  			return -EPERM;
> -		if (flag & O_TRUNC)
> -			return -EPERM;
>  	}

Bogus break_lease() following that...
