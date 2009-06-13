Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZFMSwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZFMSwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 14:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZFMSwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 14:52:25 -0400
Received: from waste.org ([66.93.16.53]:50542 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFMSwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 14:52:24 -0400
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0906131456090.5069@sister.anvils>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org>
	 <Pine.LNX.4.64.0906131456090.5069@sister.anvils>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 13:51:25 -0500
Message-Id: <1244919085.4496.192.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-13 at 15:15 +0100, Hugh Dickins wrote:
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
> > 
> > This used to work before commit c3b1b1cbf0 as previously, ramfs would
> > ignore all options.  But now, we get:
> > ramfs: bad mount option: size=10M
> > mount: mounting mdev on /dev failed: Invalid argument
> 
> I rather think the correct response to bugzilla #12843 should have
> been to say, either use chmod 1777 yourself, or use CONFIG_SHMEM=y.
> I fear we'll now get a line of requests for support of uid, gid, ...
> in ramfs; whereas ramfs is about blind simplicity, not feature bloat.
> However, that mode= feature is now in, so I guess we ride with it.

Ugh, hadn't noticed that go by.

> > 
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> > another option might be to restore the previous behavior where ramfs simply
> > ignored all unknown mount options ...
> 
> Yes, that would be my preference, return to the blind simplicity, with
> that one exception for mode=.  Alternative patch suggested at the bottom,
> let's see if Cc's added feel strongly about it one way or another.



> Thanks,
> Hugh
> 
> > 
> >  fs/ramfs/inode.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> > index 3a6b193..57a797c 100644
> > --- a/fs/ramfs/inode.c
> > +++ b/fs/ramfs/inode.c
> > @@ -203,6 +203,16 @@ static int ramfs_parse_options(char *data, struct ramfs_mount_opts *opts)
> >  			opts->mode = option & S_IALLUGO;
> >  			break;
> >  		default:
> > +#ifndef CONFIG_SHMEM
> > +			/* If tmpfs is using us to emulate it, ignore its options */
> > +			if (!strncmp(p, "gid=", 4) ||
> > +			    !strncmp(p, "mpol=", 5) ||
> > +			    !strncmp(p, "nr_blocks=", 10) ||
> > +			    !strncmp(p, "nr_inodes=", 10) ||
> > +			    !strncmp(p, "size=", 5) ||
> > +			    !strncmp(p, "uid=", 4))
> > +				continue;
> > +#endif
> >  			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
> >  			return -EINVAL;
> >  		}
> > -- 
> > 1.6.3.1
> 
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

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


