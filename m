Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbZFNMQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbZFNMQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZFNMQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:16:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:57618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbZFNMQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:16:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,217,1243839600"; 
   d="scan'208";a="154096312"
Date: Sun, 14 Jun 2009 20:16:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
Message-ID: <20090614121645.GB7949@localhost>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> <Pine.LNX.4.64.0906131456090.5069@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906131456090.5069@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 10:15:51PM +0800, Hugh Dickins wrote:
> On Sat, 13 Jun 2009, Mike Frysinger wrote:
> 
> > On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
> > fail when tmpfs options are used.  This is because tmpfs creates a small
> > wrapper around ramfs which rejects unknown options, and ramfs itself only
> > supports a tiny subset of what tmpfs supports.  This makes it pretty hard
> > to use the same userspace systems across different configuration systems.
> > As such, ramfs should ignore the tmpfs options when tmpfs is merely a
> > wrapper around ramfs.
> 
> Yes, indeed, thanks a lot for reporting this.
> 
> But I'm uneasy with making ramfs behaviour differ with CONFIG_SHMEM
> (perhaps that's silly: certainly tmpfs behaviour differs with it),
> and uneasy with coding a list of options we need to remember to keep
> in synch with mm/shmem.c.  It's easier to justify ignoring all options,
> than rejecting some while ignoring others yet not respecting them.
> 
[snip] 
> [PATCH] ramfs: ignore unknown mount options
> 
> From: Mike Frysinger <vapier@gentoo.org>
> 
> On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
> fail when tmpfs options are used.  This is because tmpfs creates a small
> wrapper around ramfs which rejects unknown options, and ramfs itself only
> supports a tiny subset of what tmpfs supports.  This makes it pretty hard
> to use the same userspace systems across different configuration systems.
> As such, ramfs should ignore the tmpfs options when tmpfs is merely a
> wrapper around ramfs.
> 
> This used to work before commit c3b1b1cbf0 as previously, ramfs would
> ignore all options.  But now, we get:
> ramfs: bad mount option: size=10M
> mount: mounting mdev on /dev failed: Invalid argument
> 
> Another option might be to restore the previous behavior, where ramfs
> simply ignored all unknown mount options ... which is what Hugh prefers.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: stable@kernel.org
> ---
> 
>  fs/ramfs/inode.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> --- 2.6.30/fs/ramfs/inode.c	2009-06-10 04:05:27.000000000 +0100
> +++ linux/fs/ramfs/inode.c	2009-06-13 14:45:33.000000000 +0100
> @@ -202,9 +202,12 @@ static int ramfs_parse_options(char *dat
>  				return -EINVAL;
>  			opts->mode = option & S_IALLUGO;
>  			break;
> -		default:
> -			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
> -			return -EINVAL;
> +		/*
> +		 * We might like to report bad mount options here;
> +		 * but traditionally ramfs has ignored all mount options,
> +		 * and as it is used as a !CONFIG_SHMEM simple substitute
> +		 * for tmpfs, better continue to ignore other mount options.
> +		 */
>  		}
>  	}
>  

Acked-by: Wu Fengguang <fengguang.wu@intel.com> 
