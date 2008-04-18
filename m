Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYDRM5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYDRM5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYDRM5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:57:32 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43996 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYDRM5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:57:31 -0400
Date: Fri, 18 Apr 2008 13:57:18 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: szaka@ntfs-3g.org, me@bobcopeland.com, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080418125718.GD25089@shareable.org>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>, szaka@ntfs-3g.org,
	me@bobcopeland.com, hch@infradead.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <20080414004521.GA30489@hash.localnet> <Pine.LNX.4.61.0804181302180.29728@dhcppc2> <20080418115237.GA25089@shareable.org> <E1JmpZz-0005pB-8q@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JmpZz-0005pB-8q@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Most filesystems (ntfs-3g included) cannot be modified from the
> outside, so coherency isn't an issue.
> 
> Otherwise currently fuse provides rather crude settings for caching:
> 
>   - timeout for attributes (per-inode, default 1s)
>   - timeout for names (per-dentry, default 1s)
>   - page cache is bypassed completely (per-file, default off)
>   - invalidation of page cache on open (per-open, default on)

Seems sensible.  As someone who is deep in coherency protocols at the
moment (I'm writing a robust distributed database/filesystem) I don't
like the crudeness, but for FUSE's real life use it seems a fine choice :-)

> There are also plans to add some sort of cache coherency protocol,
> where the filesystem can asynchronously call back to fuse to
> invalidate data or metadata.

Great!

I suggest adding another option (as well) where the filesystem can ask
fuse to send it synchronous validation requests - some things require
that.  (In my own work, the choice of A->B async invalidation and B->A
synchronous validation is heuristic: some usage patterns benefit from
one, some from the other.)

> > Otherwise I don't see how the kernel could coherently cache file pages
> > for some kinds of FUSE filesystems.  (E.g. sshfs, for example: every
> > operation must surely invoke a user space request or involve granting
> > a caching right to the kernel, to keep accesses coherent with other
> > users of the same remote files).
> > 
> > Ergo, either its not coherent, or there is some coherency protocol,
> > which does require _some_ work in the user space implementation.
> 
> Sshfs is not coherent (but neither is NFS), it just has timeouts for
> caches and invalidation based on modification time.

Fwiw, I think NFS version 4 is coherent (it uses leases), and older
NFS should be coherent when you use fcntl file locks (it's not very
efficient though).

I have been bitten a few times by timeout based caches in the past
(NFS and SMB (pre-oplock)).  Simple things like editing a file, then
running "ssh compiler-box make" from the editor quietly building
incorrect code - and even subsequent make commands don't fix it.  Or
when I edit a file, then tell someone I've changed the file - and then
they edit the file, and my edits are lost.  Very annoying.  Nobody
should build those kind of caches into new software.  :-)

-- Jamie
