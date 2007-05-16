Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbXEPCQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbXEPCQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 22:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbXEPCP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 22:15:59 -0400
Received: from lazybastard.de ([212.112.238.170]:39767 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbXEPCP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 22:15:58 -0400
Date: Wed, 16 May 2007 04:11:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516021139.GA3175@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org> <20070516000630.GD1220@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070516000630.GD1220@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 02:06:31 +0200, Jörn Engel wrote:
>
> > > +
> > > +	if (dest) {
> > > +		/* symlink */
> > > +		ret = logfs_inode_write(inode, dest, destlen, 0);
> > > +	} else {
> > > +		/* creat/mkdir/mknod */
> > > +		ret = __logfs_write_inode(inode);
> > > +	}
> > > +	super->s_victim_ino = 0;
> > > +	if (ret) {
> > > +		if (!dest)
> > > +			li->li_flags |= LOGFS_IF_STILLBORN;
> > > +		/* FIXME: truncate symlink */
> > > +		inode->i_nlink--;
> > > +		iput(inode);
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (inode->i_mode & S_IFDIR)
> > > +		dir->i_nlink++;
> > 
> > You have helper functions for i_nlink++, which remember to do
> > mark_inode_dirty()?
> 
> I do.  Looks like I should use them here and in at least one other
> place.  Will recheck them all.

Actually, this code was correct.  New inodes get written immediatly to
ensure catching -ENOSPC at a place where errors can get returned.  After
leaving this function, the inode is not dirty.  Either it has been
written or it is marked LOGFS_IF_STILLBORN never will be.

Your intuition was still good.  Link() did need the change you
indicated.

Jörn

-- 
Joern's library part 14:
http://www.sandpile.org/
