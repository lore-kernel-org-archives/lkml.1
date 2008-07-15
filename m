Return-Path: <linux-kernel-owner+w=401wt.eu-S1762986AbYGOTxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762986AbYGOTxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbYGOTxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:53:36 -0400
Received: from mail.fieldses.org ([66.93.2.214]:35303 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbYGOTxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:53:35 -0400
Date: Tue, 15 Jul 2008 15:53:33 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
Message-ID: <20080715195333.GK21590@fieldses.org>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:28:22AM -0700, Sage Weil wrote:
> Fields prefixed with 'r' are recursively defined, while 
> entries/files/subdirs is just for the one directory.  'rctime' is the most 
> recent ctime within the hierarchy, which should be useful for backup 
> software or anything else scanning the hierarchy for recent changes.
> 
> Naturally, there are a few caveats:
> 
>  - There is some built-in delay before statistics fully propagate up 
> toward the root of the hierarchy.  Changes are propagated 
> opportunistically when lock/lease state allows, with an upper bound of (by 
> default) ~30 seconds for each level of directory nesting.

That makes it less useful, e.g., for somebody with cached data trying to
validate their cache, or for something like git trying to check a
directory tree for changes.

>  - Ceph internally distinguishes between multiple links to the same file 
> (there is a single 'primary' link, and then zero or more 'remote' links).  
> Only the primary link contributes toward the 'rbytes' total.

Is that only true for 'rbytes'?

--b.

> 
>  - The 'rbytes' summation is over i_size, not blocks used.  That means 
> sparse files "appear" larger than the storage space they actually consume.
> 
>  - Directories don't yet contribute anything to the 'rbytes' total.  They
> should probably include an estimate of the storage consumed by directory 
> metadata.  For this reason, and because the size isn't rounded up to the 
> block size, the 'rbytes' total will usually be slightly smaller than what 
> you get from 'du'.
> 
>  - Currently no stats for the root directory itself.
> 
> 
> I'm extremely interested in what people think of overloading the file 
> system interface in this way.  Handy?  Crufty?  Dangerous?  Does anybody 
> know of any applications that rely on or expect meaningful values for a 
> directory's i_size?  Or read() a directory?
> 
> 
> More information on the recursive accounting at
> 
> 	http://ceph.newdream.net/wiki/Recursive_accounting
> 
> and Ceph itself at
> 
> 	http://ceph.newdream.net/
> 
> Cheers-
> sage
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
