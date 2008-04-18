Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbYDRQC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbYDRQC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbYDRQCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:02:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59629 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbYDRQCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:02:37 -0400
To: jamie@shareable.org
CC: miklos@szeredi.hu, szaka@ntfs-3g.org, me@bobcopeland.com,
       hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080418125718.GD25089@shareable.org> (message from Jamie Lokier
	on Fri, 18 Apr 2008 13:57:18 +0100)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <20080414004521.GA30489@hash.localnet> <Pine.LNX.4.61.0804181302180.29728@dhcppc2> <20080418115237.GA25089@shareable.org> <E1JmpZz-0005pB-8q@pomaz-ex.szeredi.hu> <20080418125718.GD25089@shareable.org>
Message-Id: <E1Jmt23-0006Bq-Kk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Apr 2008 18:01:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There are also plans to add some sort of cache coherency protocol,
> > where the filesystem can asynchronously call back to fuse to
> > invalidate data or metadata.
> 
> Great!
> 
> I suggest adding another option (as well) where the filesystem can ask
> fuse to send it synchronous validation requests - some things require
> that.  (In my own work, the choice of A->B async invalidation and B->A
> synchronous validation is heuristic: some usage patterns benefit from
> one, some from the other.)

Yes, that makes sense.  I expect this could be done by extending the
existing requests with a flag saying the result is already cached.
And then the filesystem can either reply with a special "cached data
is valid" code, or it can reply normally with the fresh data.

> > > Otherwise I don't see how the kernel could coherently cache file pages
> > > for some kinds of FUSE filesystems.  (E.g. sshfs, for example: every
> > > operation must surely invoke a user space request or involve granting
> > > a caching right to the kernel, to keep accesses coherent with other
> > > users of the same remote files).
> > > 
> > > Ergo, either its not coherent, or there is some coherency protocol,
> > > which does require _some_ work in the user space implementation.
> > 
> > Sshfs is not coherent (but neither is NFS), it just has timeouts for
> > caches and invalidation based on modification time.
> 
> Fwiw, I think NFS version 4 is coherent (it uses leases), and older
> NFS should be coherent when you use fcntl file locks (it's not very
> efficient though).
> 
> I have been bitten a few times by timeout based caches in the past
> (NFS and SMB (pre-oplock)).  Simple things like editing a file, then
> running "ssh compiler-box make" from the editor quietly building
> incorrect code - and even subsequent make commands don't fix it.  Or
> when I edit a file, then tell someone I've changed the file - and then
> they edit the file, and my edits are lost.  Very annoying.  Nobody
> should build those kind of caches into new software.  :-)

Oh well, you can turn off caching if it bothers you :)  OTOH it would
be rather hard (and probably against the point) to try to extend the
sftp protocol to handle cache coherency.  Sshfs is not meant to be a
normal filesystem (although some people are trying to use it for home
directories and such), just a simple way to access remote files.

Miklos
