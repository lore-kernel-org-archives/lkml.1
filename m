Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0BJKYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:24:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47460 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0BJKYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:24:23 -0500
Date: Wed, 10 Feb 2010 10:24:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in
 pohmelfs
Message-ID: <20100210102422.GM30031@ZenIV.linux.org.uk>
References: <20100210100428.GL30031@ZenIV.linux.org.uk>
 <20100210101246.GA3509@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210101246.GA3509@ioremap.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 01:12:46PM +0300, Evgeniy Polyakov wrote:
> On Wed, Feb 10, 2010 at 10:04:28AM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> > a) pohmelfs_construct_path_string() will do interesting things if you
> > call it while chrooted into jail and pohmelfs mounted deeper in that
> > jail.  Try it.
> 
> Should it walk upto mountpoint?

It will happily give you path from absolute root to root of chroot jail +
path from fs root to your dentry.  Which is probably not what you want.
 
> > b) just why do we care about root of chroot jail in pohmelfs_path_length()?
> > Not to mention anything else, current->fs->root/mnt may be changed under
> > you if you share current->fs with another thread, but even aside of that,
> > why does filesystem care about chroot of caller at all?
> > 
> > What's going on there?
> 
> It tries to construct a full path upto mountpoint. Effectively it should
> do similar to non-exported dentry_path() things. There is a race between
> getting buffer size and filling with the actual path, but we take care
> about that by restarting if needed.

To mountpoint or to fs root?  And what's going on with d_find_alias()?
AFAICS, you are doing that for regular files as well as directories,
and you do support link(2) in there, so dentry (and path) obtained from
that will be random.
