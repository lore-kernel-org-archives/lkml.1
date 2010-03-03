Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0CCUcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:32:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab0CCUcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:32:10 -0500
Date: Wed, 3 Mar 2010 15:31:50 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Union mount core rewrite v1
Message-ID: <20100303203150.GB19689@shell>
References: <1267567889-4637-1-git-send-email-vaurora@redhat.com> <E1NmsNN-0003s9-P1@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NmsNN-0003s9-P1@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 06:28:49PM +0100, Miklos Szeredi wrote:
> On Tue,  2 Mar 2010, Valerie Aurora wrote:
> > This is a major rewrite of parts of union mounts, in particular the
> > pathname lookup code.  For more info about union mounts, see:
> > 
> > http://valerieaurora.org/union/
> > 
> > The previous code had two important problems fixed in this series:
> > 
> > - On file open, is_unionized() grabs vfsmount lock and walks up the
> >   mount tree even for non-union mounts.
> > 
> > - Pathname lookup required three cut-n-pasted versions of two complex
> >   functions, one for each of cached/real/"hashed" lookups.
> 
> Looks much better :)

Thanks for the review. :)

> > This rewrite reduces the additional cost of a non-union lookup in a
> > CONFIG_UNION_MOUNT kernel to either 1 or 2 mount flag tests (but adds
> > the requirement that file systems be unioned only at their root
> > directories).  This rewrite implements lookup with one lookup_union()
> > function for all types of lookups.
> > 
> > This posted patch series includes only the union lookup, mount, and
> > readdir patches and not the relatively uncontroversial whiteout and
> > fallthru code.
> 
> Special inode/dentry flags (whiteout, fallthrough, opaque) are not
> trivially the right solution:
> 
>  - they are invisible from userspace, new APIs are necessary to manipulate them
>  - they are difficult to support on network filesystems
>  - they are not useful for anything other than union mounts/filesystems
> 
> Extended attributes are a more standard way to add such info to files.
> Hard links would allow sharing a single inode for all whiteout entries
> and one for all fallthrough entries.
> 
> Have these options been considered as an alternative?

Thanks for bringing that up!  We have considered them and aren't sure
what the best solution is - all the options, including our current
example implementations, have serious drawbacks.  Fortunately, the
implementation of whiteouts, etc. is fairly separate from the main
body of union mount code.  For example, I'm pretty sure you could
implement whiteouts, fallthrus, and opaque flags in ext2 as system
extended attributes or as hard links (or as crazy special symlinks)
without changing any other non-ext2 patches.  We already switched once
from encoding whiteouts with reserved inode numbers in ext3 to
whiteouts as a new dentry type flag in ext2 and that didn't affect
other patches.  In general, I am happy with whatever the maintainer of
the underlying file system prefers.

The advantage of the system extended attribute approach is that any
file system with xattrs also supports union mounts.  It might be worth
implementing for that reason alone.

-VAL
