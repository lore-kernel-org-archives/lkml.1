Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZFNKm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZFNKm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZFNKmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:42:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:48701 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZFNKmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:42:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,217,1243839600"; 
   d="scan'208";a="154078949"
Date: Sun, 14 Jun 2009 18:42:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
Message-ID: <20090614104212.GA5977@localhost>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> <Pine.LNX.4.64.0906131456090.5069@sister.anvils> <20090614100110.GA19875@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090614100110.GA19875@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 06:01:10PM +0800, Wu Fengguang wrote:
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

Sorry I take back the previous patch. It makes sense to not break
existing user space tools, but a warning message looks OK to remind
people of possibly unexpected behavior.

Thanks,
Fengguang
 
---
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

Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: stable@kernel.org
---

 fs/ramfs/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux.orig/fs/ramfs/inode.c
+++ linux/fs/ramfs/inode.c
@@ -202,9 +202,14 @@ static int ramfs_parse_options(char *dat
 				return -EINVAL;
 			opts->mode = option & S_IALLUGO;
 			break;
+		/*
+		 * Traditionally ramfs has ignored all mount options,
+		 * and as it is used as a !CONFIG_SHMEM simple substitute
+		 * for tmpfs, ignore other mount options with a warning.
+		 */
 		default:
 			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
-			return -EINVAL;
+			break;
 		}
 	}
 
