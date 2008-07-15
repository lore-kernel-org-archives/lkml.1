Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYGOUmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYGOUmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763378AbYGOUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:41:27 -0400
Received: from cobra.newdream.net ([66.33.216.30]:57076 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763373AbYGOUlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:41:25 -0400
Date: Tue, 15 Jul 2008 13:41:25 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
In-Reply-To: <20080715195333.GK21590@fieldses.org>
Message-ID: <Pine.LNX.4.64.0807151326130.1976@cobra.newdream.net>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
 <20080715195333.GK21590@fieldses.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, J. Bruce Fields wrote:
> >  - There is some built-in delay before statistics fully propagate up 
> > toward the root of the hierarchy.  Changes are propagated 
> > opportunistically when lock/lease state allows, with an upper bound of (by 
> > default) ~30 seconds for each level of directory nesting.
> 
> That makes it less useful, e.g., for somebody with cached data trying to
> validate their cache, or for something like git trying to check a
> directory tree for changes.

Having fully up to date values would definitely be nice, but unfortunately 
doesn't play nice with the fact that different parts of the directory 
hierarchy may be managed by different metadata servers.  A primary goal in 
implementing this was to minimize any impact on performance.  The uses I 
had I mind were more in line with quota-based accounting than cache 
validation.

I think I can adjust the propagation heuristics/timeouts to make updates 
seem more or less immediate to a user in most cases, but that won't be 
sufficient for a tool like git that needs to reliably identify very recent 
updates.  For backup software wanting a consistent file system image, it 
should really be operating on a snapshot as well, in which case a delay 
between taking the snapshot and starting the scan for changes would allow 
those values to propagate.

> >  - Ceph internally distinguishes between multiple links to the same file 
> > (there is a single 'primary' link, and then zero or more 'remote' links).  
> > Only the primary link contributes toward the 'rbytes' total.
> 
> Is that only true for 'rbytes'?

The same goes for rctime.  As far as the recursive stats go, the other 
stats (file/directory counts) aren't affected.  The primary/remote 
hard link distinction is fundamental to the way metadata is internally 
managed and stored by the MDS, though, if that's what you mean (inode 
content is embedded with the primary link's directory metadata).

sage


> 
> --b.
> 
> > 
> >  - The 'rbytes' summation is over i_size, not blocks used.  That means 
> > sparse files "appear" larger than the storage space they actually consume.
> > 
> >  - Directories don't yet contribute anything to the 'rbytes' total.  They
> > should probably include an estimate of the storage consumed by directory 
> > metadata.  For this reason, and because the size isn't rounded up to the 
> > block size, the 'rbytes' total will usually be slightly smaller than what 
> > you get from 'du'.
> > 
> >  - Currently no stats for the root directory itself.
> > 
> > 
> > I'm extremely interested in what people think of overloading the file 
> > system interface in this way.  Handy?  Crufty?  Dangerous?  Does anybody 
> > know of any applications that rely on or expect meaningful values for a 
> > directory's i_size?  Or read() a directory?
> > 
> > 
> > More information on the recursive accounting at
> > 
> > 	http://ceph.newdream.net/wiki/Recursive_accounting
> > 
> > and Ceph itself at
> > 
> > 	http://ceph.newdream.net/
> > 
> > Cheers-
> > sage
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
