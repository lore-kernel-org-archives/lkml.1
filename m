Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0BJKp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:45:26 -0500
Received: from matrixpower.ru ([195.178.208.66]:56366 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab0BJKpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:45:24 -0500
Date: Wed, 10 Feb 2010 13:45:15 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in pohmelfs
Message-ID: <20100210104515.GA6207@ioremap.net>
References: <20100210100428.GL30031@ZenIV.linux.org.uk> <20100210101246.GA3509@ioremap.net> <20100210102422.GM30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210102422.GM30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 10:24:22AM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> On Wed, Feb 10, 2010 at 01:12:46PM +0300, Evgeniy Polyakov wrote:
> > On Wed, Feb 10, 2010 at 10:04:28AM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> > > a) pohmelfs_construct_path_string() will do interesting things if you
> > > call it while chrooted into jail and pohmelfs mounted deeper in that
> > > jail.  Try it.
> > 
> > Should it walk upto mountpoint?
> 
> It will happily give you path from absolute root to root of chroot jail +
> path from fs root to your dentry.  Which is probably not what you want.

I thouht of always providing path to mountpoint instead of just root.
Full path names are rather messy to work with, so I consider
per-directory objects only in the next version, but drawback is lookup
time.

> > > b) just why do we care about root of chroot jail in pohmelfs_path_length()?
> > > Not to mention anything else, current->fs->root/mnt may be changed under
> > > you if you share current->fs with another thread, but even aside of that,
> > > why does filesystem care about chroot of caller at all?
> > > 
> > > What's going on there?
> > 
> > It tries to construct a full path upto mountpoint. Effectively it should
> > do similar to non-exported dentry_path() things. There is a race between
> > getting buffer size and filling with the actual path, but we take care
> > about that by restarting if needed.
> 
> To mountpoint or to fs root?  And what's going on with d_find_alias()?

To root if it happend to be under mountpoint.

> AFAICS, you are doing that for regular files as well as directories,
> and you do support link(2) in there, so dentry (and path) obtained from
> that will be random.

Not exactly random, but can change.
Links support is rather subtle because of that, yes.

Plan was to add external attribute or increase inode size to include
parent name, but when I coded that it was so messy in respect of
renames, that was dropped.

-- 
	Evgeniy Polyakov
