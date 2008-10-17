Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYJQQxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYJQQxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYJQQxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:53:20 -0400
Received: from lazybastard.de ([212.112.238.170]:50741 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbYJQQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:53:19 -0400
Date: Fri, 17 Oct 2008 18:53:00 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 01/16] Squashfs: inode operations
Message-ID: <20081017165300.GA8076@logfs.org>
References: <E1KqrTW-0001xC-9M@dylan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1KqrTW-0001xC-9M@dylan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of the comments below are a reason against mainline inclusion, imo.
They should get handled, but whether that happens before or after a
merge doesn't really matter.

On Fri, 17 October 2008 16:42:50 +0100, Phillip Lougher wrote:
> 
> +#include <linux/squashfs_fs.h>
> +#include <linux/squashfs_fs_sb.h>
> +#include <linux/squashfs_fs_i.h>

Current verdict seems to be that these files should live in fs/squashfs/,
not include/linux/.  No kernel code beside squashfs needs the headers
and userspace tools should have a private copy.

> +static int squashfs_new_inode(struct super_block *s, struct inode *i,
> +				struct squashfs_base_inode *inodeb)
> +{
> +	if (squashfs_get_id(s, le16_to_cpu(inodeb->uid), &i->i_uid) == 0)
> +		goto out;
> +	if (squashfs_get_id(s, le16_to_cpu(inodeb->guid), &i->i_gid) == 0)
> +		goto out;
> +
> +	i->i_ino = le32_to_cpu(inodeb->inode_number);
> +	i->i_mtime.tv_sec = le32_to_cpu(inodeb->mtime);
> +	i->i_atime.tv_sec = i->i_mtime.tv_sec;
> +	i->i_ctime.tv_sec = i->i_mtime.tv_sec;
> +	i->i_mode = le16_to_cpu(inodeb->mode);
> +	i->i_size = 0;
> +
> +	return 1;
> +
> +out:
> +	return 0;
> +}

Most code uses "sb" and "inode", which I consider easier to read - if
only for consistency.

> +int squashfs_read_inode(struct inode *i, long long inode)

Is your "long long inode" what most filesystems call "inode->i_ino"?  It
seems to be.

> +	if (squashfs_new_inode(s, i, inodeb) == 0)
> +			goto failed_read;

Most linux functions return 0 on success and -ESOMETHING on error.  You
return 0 on error and 1 on success.  That makes it likely for someone
else to do something like

	err = squashfs_foo(bar);
	if (err)
		goto fail;

Oops.

Jörn

-- 
Measure. Don't tune for speed until you've measured, and even then
don't unless one part of the code overwhelms the rest.
-- Rob Pike
