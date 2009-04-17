Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZDQAFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZDQAFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZDQAF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:05:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43107 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZDQAF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:05:29 -0400
Date: Fri, 17 Apr 2009 01:05:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@ftp.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090417000515.GG26366@ZenIV.linux.org.uk>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416143626.GA17683@infradead.org> <20090416164927.GB19281@elte.hu> <20090416170150.GA526@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416170150.GA526@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 01:01:50PM -0400, Christoph Hellwig wrote:
> ->remount_fs should be easy enough to, we do have proper per-sb
> protection here, but do_remount_sb will need a bit of an audit.
> (and of course pushing lock_kernel down into the many instances and
> leave the cleanup-work to the fs maintainers).
> 
> The actual mount path is more interesting as there are quite a few cases
> there.  As a first step you can take lock_kernel from outside do_mount
> into the various do_foo calls inside it, and then work on those piece
> by piece.

The only place that might care is ->get_sb() (i.e. old ->read_super()).
And only for protection of fs-type-wide data structures inside the
fs/foo/* - anything in VFS doesn't give a damn (e.g. a realistic candidate
might be something that maintains a private list of all sb->s_fs_info for
this type and doesn't bother to do any locking, relying on BKL for all
manipulations).

->write_super() and ->put_super() are other candidates, for the same
reason.  That's where BKL is generic_shutdown is coming from.

Note that while we do have other users of do_kern_mount(), they tend to
be limited to subset of fs types, so again, do not assume that "we use
do_kern_mount() without BKL anyway" means that we are safe on that path.

I'd suggest pushing that crap down into individual filesystems again.
They *ARE* serialized for given superblock, so we really are looking for
cross-fs-instance data structures.
