Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbZFMOQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbZFMOQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZFMOQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:16:43 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:25603 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754167AbZFMOQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:16:42 -0400
X-Trace: 214622559/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.101.221/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.101.221
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAH9RM0pPRWXd/2dsb2JhbACBT88ehA0F
X-IronPort-AV: E=Sophos;i="4.42,214,1243810800"; 
   d="scan'208";a="214622559"
Date: Sat, 13 Jun 2009 15:15:51 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mike Frysinger <vapier@gentoo.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
In-Reply-To: <1244872920-13511-1-git-send-email-vapier@gentoo.org>
Message-ID: <Pine.LNX.4.64.0906131456090.5069@sister.anvils>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009, Mike Frysinger wrote:

> On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
> fail when tmpfs options are used.  This is because tmpfs creates a small
> wrapper around ramfs which rejects unknown options, and ramfs itself only
> supports a tiny subset of what tmpfs supports.  This makes it pretty hard
> to use the same userspace systems across different configuration systems.
> As such, ramfs should ignore the tmpfs options when tmpfs is merely a
> wrapper around ramfs.

Yes, indeed, thanks a lot for reporting this.

But I'm uneasy with making ramfs behaviour differ with CONFIG_SHMEM
(perhaps that's silly: certainly tmpfs behaviour differs with it),
and uneasy with coding a list of options we need to remember to keep
in synch with mm/shmem.c.  It's easier to justify ignoring all options,
than rejecting some while ignoring others yet not respecting them.

> 
> This used to work before commit c3b1b1cbf0 as previously, ramfs would
> ignore all options.  But now, we get:
> ramfs: bad mount option: size=10M
> mount: mounting mdev on /dev failed: Invalid argument

I rather think the correct response to bugzilla #12843 should have
been to say, either use chmod 1777 yourself, or use CONFIG_SHMEM=y.
I fear we'll now get a line of requests for support of uid, gid, ...
in ramfs; whereas ramfs is about blind simplicity, not feature bloat.
However, that mode= feature is now in, so I guess we ride with it.

> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> another option might be to restore the previous behavior where ramfs simply
> ignored all unknown mount options ...

Yes, that would be my preference, return to the blind simplicity, with
that one exception for mode=.  Alternative patch suggested at the bottom,
let's see if Cc's added feel strongly about it one way or another.

Thanks,
Hugh

> 
>  fs/ramfs/inode.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index 3a6b193..57a797c 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -203,6 +203,16 @@ static int ramfs_parse_options(char *data, struct ramfs_mount_opts *opts)
>  			opts->mode = option & S_IALLUGO;
>  			break;
>  		default:
> +#ifndef CONFIG_SHMEM
> +			/* If tmpfs is using us to emulate it, ignore its options */
> +			if (!strncmp(p, "gid=", 4) ||
> +			    !strncmp(p, "mpol=", 5) ||
> +			    !strncmp(p, "nr_blocks=", 10) ||
> +			    !strncmp(p, "nr_inodes=", 10) ||
> +			    !strncmp(p, "size=", 5) ||
> +			    !strncmp(p, "uid=", 4))
> +				continue;
> +#endif
>  			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
>  			return -EINVAL;
>  		}
> -- 
> 1.6.3.1

[PATCH] ramfs: ignore unknown mount options

From: Mike Frysinger <vapier@gentoo.org>

On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
fail when tmpfs options are used.  This is because tmpfs creates a small
wrapper around ramfs which rejects unknown options, and ramfs itself only
supports a tiny subset of what tmpfs supports.  This makes it pretty hard
to use the same userspace systems across different configuration systems.
As such, ramfs should ignore the tmpfs options when tmpfs is merely a
wrapper around ramfs.

This used to work before commit c3b1b1cbf0 as previously, ramfs would
ignore all options.  But now, we get:
ramfs: bad mount option: size=10M
mount: mounting mdev on /dev failed: Invalid argument

Another option might be to restore the previous behavior, where ramfs
simply ignored all unknown mount options ... which is what Hugh prefers.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: stable@kernel.org
---

 fs/ramfs/inode.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- 2.6.30/fs/ramfs/inode.c	2009-06-10 04:05:27.000000000 +0100
+++ linux/fs/ramfs/inode.c	2009-06-13 14:45:33.000000000 +0100
@@ -202,9 +202,12 @@ static int ramfs_parse_options(char *dat
 				return -EINVAL;
 			opts->mode = option & S_IALLUGO;
 			break;
-		default:
-			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
-			return -EINVAL;
+		/*
+		 * We might like to report bad mount options here;
+		 * but traditionally ramfs has ignored all mount options,
+		 * and as it is used as a !CONFIG_SHMEM simple substitute
+		 * for tmpfs, better continue to ignore other mount options.
+		 */
 		}
 	}
 
