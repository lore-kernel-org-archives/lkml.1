Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZFNLOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZFNLOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZFNLOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:14:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:10689 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbZFNLOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:14:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,217,1243839600"; 
   d="scan'208";a="154084099"
Date: Sun, 14 Jun 2009 19:14:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
Message-ID: <20090614111440.GC6046@localhost>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> <Pine.LNX.4.64.0906131456090.5069@sister.anvils> <20090614100110.GA19875@localhost> <20090614104212.GA5977@localhost> <8bd0f97a0906140346t6b19f00aq29cfd4c554682f07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0906140346t6b19f00aq29cfd4c554682f07@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 06:46:24PM +0800, Mike Frysinger wrote:
> On Sun, Jun 14, 2009 at 06:42, Wu Fengguang wrote:
> > On Sun, Jun 14, 2009 at 06:01:10PM +0800, Wu Fengguang wrote:
> > Sorry I take back the previous patch. It makes sense to not break
> > existing user space tools, but a warning message looks OK to remind
> > people of possibly unexpected behavior.
> >
> >                default:
> >                        printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
> > -                       return -EINVAL;
> > +                       break;
> 
> hmm, if the warning was wrapped in #ifdef CONFIG_SHMEM, i'd be ok with
> this.  otherwise we end up with warnings that can (should) be ignored
> when tmpfs is being emulated with ramfs.

We may change the "ramfs:" accordingly. But *silently* ignoring
options is bad anyway?

Does this message look better?

+			printk(KERN_WARNING "%s: ignoring mount option: %s\n",
+			       sb->s_id, p);

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

 fs/ramfs/inode.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- linux.orig/fs/ramfs/inode.c
+++ linux/fs/ramfs/inode.c
@@ -182,8 +182,9 @@ struct ramfs_fs_info {
 	struct ramfs_mount_opts mount_opts;
 };
 
-static int ramfs_parse_options(char *data, struct ramfs_mount_opts *opts)
+static int ramfs_parse_options(struct super_block *sb, char *data)
 {
+	struct ramfs_mount_opts *opts = sb->s_fs_info;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 	int token;
@@ -202,9 +203,15 @@ static int ramfs_parse_options(char *dat
 				return -EINVAL;
 			opts->mode = option & S_IALLUGO;
 			break;
+		/*
+		 * Traditionally ramfs has ignored all mount options,
+		 * and as it is used as a !CONFIG_SHMEM simple substitute
+		 * for tmpfs, ignore other mount options with a warning.
+		 */
 		default:
-			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
-			return -EINVAL;
+			printk(KERN_WARNING "%s: ignoring mount option: %s\n",
+			       sb->s_id, p);
+			break;
 		}
 	}
 
@@ -227,7 +234,7 @@ static int ramfs_fill_super(struct super
 		goto fail;
 	}
 
-	err = ramfs_parse_options(data, &fsi->mount_opts);
+	err = ramfs_parse_options(sb, data);
 	if (err)
 		goto fail;
 
