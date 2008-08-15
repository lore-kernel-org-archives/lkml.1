Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbYHOHUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbYHOHUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 03:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYHOHU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 03:20:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbYHOHU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 03:20:28 -0400
Date: Fri, 15 Aug 2008 00:19:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       snakebyte@gmx.de
Subject: Re: [PATCH 1/2] omfs: fix potential oops when directory size is
 corrupted
Message-Id: <20080815001956.6b16f383.akpm@linux-foundation.org>
In-Reply-To: <1218770022-31956-1-git-send-email-me@bobcopeland.com>
References: <1218770022-31956-1-git-send-email-me@bobcopeland.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 23:13:41 -0400 Bob Copeland <me@bobcopeland.com> wrote:

> --- a/fs/omfs/inode.c
> +++ b/fs/omfs/inode.c
> @@ -232,8 +232,7 @@ struct inode *omfs_iget(struct super_block *sb, ino_t ino)
>  		inode->i_mode = S_IFDIR | (S_IRWXUGO & ~sbi->s_dmask);
>  		inode->i_op = &omfs_dir_inops;
>  		inode->i_fop = &omfs_dir_operations;
> -		inode->i_size = be32_to_cpu(oi->i_head.h_body_size) +
> -			sizeof(struct omfs_header);
> +		inode->i_size = sbi->s_sys_blocksize;
>  		inc_nlink(inode);
>  		break;
>  	case OMFS_FILE:

We don't need to use i_size_write() on this code path, but we do in other
places.  There's also i_size_read().  I wonder if omfs gets it right
everywhere..
