Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbXEDMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbXEDMXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbXEDMXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:23:19 -0400
Received: from thunk.org ([69.25.196.29]:32885 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbXEDMXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:23:18 -0400
Date: Fri, 4 May 2007 08:23:08 -0400
From: Theodore Tso <tytso@mit.edu>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: David Chinner <dgc@sgi.com>, "Cabot, Mason B" <mason.b.cabot@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070504122307.GA25339@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Valerie Henson <val_henson@linux.intel.com>,
	David Chinner <dgc@sgi.com>,
	"Cabot, Mason B" <mason.b.cabot@intel.com>,
	linux-kernel@vger.kernel.org
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070502154414.GB77450368@melbourne.sgi.com> <20070503211450.GA3869@nifty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503211450.GA3869@nifty>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 02:14:52PM -0700, Valerie Henson wrote:
> But in terms of what we should do to fix it, there is the possibility
> of some debate.  In general, I think there is a lot of code stuck down
> in individual file systems - especially in XFS - that could be
> usefully hoisted up to a higher level as generic helper functions.
> For example, we've got at least two implementations of reservations,
> one in XFS and one in ext3/4.  At least some of the code could be
> generic - both file systems want to reserve long contiguous extents -
> with the actual mechanics of looking up and reserving free blocks
> implemented in per-fs code.

I'm not so sure.

Most of the block allocation (and pre-allocation) code is actually of
necessity going to be filesystem specific.  There are patches
currently in the ext4 patch queue which would provide a
filesystem-generic preallocate system call, and that makes sense.  And
delayed allocation could be done more in the VM --- but the actual
reservation code?  It's not at all clear it makes sense to try to
generalize it, since filesystems like XFS which look up free blocks
via extents have fundamentally different abstractions which would be
more efficient for them.

> I'd really like to see a generic VFS-level detection of
> read()/write()/creat()/mkdir()/etc. patterns which could detect things
> like "Oh, this file is likely to be deleted immediately, wait and see
> if it goes away and don't bother sending it on to the FS immediately"
> or "Looks like this file will grow pretty big, let's go pre-allocate
> some space for it."  This is probably best done as a set of helper
> functions in the usual way.

What patterns do you think means things like "this file is likely to
be deleted immediate", or "this file will grow pretty big"?  I don't
think there are any that would be generally valid.

The only thing which I think makes sense is to delayed allocation,
which as I said part of which could be done in the VM/VFS layer, and
an explicit API for large files that need to persistent preallocation.

						- Ted
