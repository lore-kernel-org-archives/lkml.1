Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZEAJJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZEAJJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZEAJJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:09:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbZEAJJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:09:01 -0400
Date: Fri, 1 May 2009 05:08:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/2] A new way of attaching information to inodes
Message-ID: <20090501090858.GA15363@infradead.org>
References: <1241112678-6615-1-git-send-email-jack@suse.cz> <20090430194339.GE19276@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430194339.GE19276@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:43:39PM -0400, Theodore Tso wrote:
> One of the things on my "round tuit" list was separating out those
> inode fields which are only needed when the inode is in use, and
> separating them out into a separate data structure, so that the 90+%
> of the inodes which are just being cached, and are not active, don't
> burn space in struct inode.  In particular, we can probably move out
> i_mutex, i_alloc_sem, i_size_seqcount, i_flock, and perhaps others.

I think that's generally a good idea, but I don't think we should
use this mechanism for it.  Just split the inode into two structures,
as struct cached_inode and a struct active_inode and make the struct
inode an anonymous union of the two.

> The same applies for the filesystem-specific portion of the in-core
> inode; and for some filesystems there might be even more opportunity
> for savings there.

I'd rather move them out into the filesystem.  E.g. i_alloc_sem is
specific to those few filesystem that support O_DIRECT but don't
actually do good enough internal locking - we'd be much better
off just having the i_alloc_sem equivalent inside those filesystems
and get rid of the calls to it in the VFS which only hurt the others.

Similarly I'd really love to get rid of the quota calls in the VFS but
instead move calls to these helpers into the filesystems - it's not
a function of the VFS switch and that way we can easily keep the quota
inode in the FS without a feature table.

