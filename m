Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZFNKlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZFNKlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZFNKk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:40:56 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:18190 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963AbZFNKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:40:56 -0400
X-Trace: 211662493/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.75.0/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.75.0
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmYFAJpwNEpPRUsA/2dsb2JhbACBT88WhA0F
X-IronPort-AV: E=Sophos;i="4.42,217,1243810800"; 
   d="scan'208";a="211662493"
Date: Sun, 14 Jun 2009 11:39:56 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
In-Reply-To: <20090614100110.GA19875@localhost>
Message-ID: <Pine.LNX.4.64.0906141119030.13473@sister.anvils>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org>
 <Pine.LNX.4.64.0906131456090.5069@sister.anvils> <20090614100110.GA19875@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Wu Fengguang wrote:
> On Sat, Jun 13, 2009 at 10:15:51PM +0800, Hugh Dickins wrote:
> > On Sat, 13 Jun 2009, Mike Frysinger wrote:
> > 
> > > On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
> > > fail when tmpfs options are used.  This is because tmpfs creates a small
> > > wrapper around ramfs which rejects unknown options, and ramfs itself only
> > > supports a tiny subset of what tmpfs supports.  This makes it pretty hard
> > > to use the same userspace systems across different configuration systems.
> > > As such, ramfs should ignore the tmpfs options when tmpfs is merely a
> > > wrapper around ramfs.
> > 
> > Yes, indeed, thanks a lot for reporting this.
> > 
> > But I'm uneasy with making ramfs behaviour differ with CONFIG_SHMEM
> > (perhaps that's silly: certainly tmpfs behaviour differs with it),
> > and uneasy with coding a list of options we need to remember to keep
> > in synch with mm/shmem.c.  It's easier to justify ignoring all options,
> > than rejecting some while ignoring others yet not respecting them.
> 
> We can avoid the burden of syncing a list of options between
> ramfs<>tmpfs by a slightly differently patch. Hopefully this makes
> ramfs behave like other filesystems when used standalone.

We could do; but I'm still preferring not.  How about you, Matt?
You decide, I think Andrew has chosen a different race track from
"The Merge Window" this weekend.

Either of our patches (or Mike's orginal) fixes Mike's actual problem:
but I'd rather keep ramfs as close as we can to its original behaviour,
and as simple as possible; not making it behave differently in the
CONFIG_SHMEM=y and CONFIG_SHMEM=n cases (you can still "mount -t ramfs"
when ramfs is also being used to serve "mount -t tmpfs").

> 
> Thanks,
> Fengguang
> 
> ---
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
> Acked-by: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Sorry, no, this one is not yet Signed-off-by me (nor Acked yet by Matt).
Though I admit we're arguing over a trifle!

Hugh

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Cc: stable@kernel.org
> ---
> 
>  fs/ramfs/inode.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- linux.orig/fs/ramfs/inode.c
> +++ linux/fs/ramfs/inode.c
> @@ -202,9 +202,17 @@ static int ramfs_parse_options(char *dat
>  				return -EINVAL;
>  			opts->mode = option & S_IALLUGO;
>  			break;
> +#ifndef	CONFIG_SHMEM
> +		/*
> +		 * We might like to report bad mount options here;
> +		 * but traditionally ramfs has ignored all mount options,
> +		 * and as it is used as a !CONFIG_SHMEM simple substitute
> +		 * for tmpfs, better continue to ignore other mount options.
> +		 */
>  		default:
>  			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
>  			return -EINVAL;
> +#endif
>  		}
>  	}
