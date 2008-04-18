Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYDRMV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYDRMV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYDRMVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:21:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41353 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYDRMVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:21:17 -0400
To: jamie@shareable.org
CC: szaka@ntfs-3g.org, me@bobcopeland.com, miklos@szeredi.hu,
       hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080418115237.GA25089@shareable.org> (message from Jamie Lokier
	on Fri, 18 Apr 2008 12:52:38 +0100)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <20080414004521.GA30489@hash.localnet> <Pine.LNX.4.61.0804181302180.29728@dhcppc2> <20080418115237.GA25089@shareable.org>
Message-Id: <E1JmpZz-0005pB-8q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Apr 2008 14:20:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Szabolcs Szakacsits wrote:
> > If you have the free hot caches then it performs the same as in-kernel 
> > file systems, user space isn't involved at all.
> 
> Presumably if "user space isn't involved at all", it must require that
> user space has granted caching rights to the kernel over a FUSE
> cache coherency protocol?
> 

Most filesystems (ntfs-3g included) cannot be modified from the
outside, so coherency isn't an issue.

Otherwise currently fuse provides rather crude settings for caching:

  - timeout for attributes (per-inode, default 1s)
  - timeout for names (per-dentry, default 1s)
  - page cache is bypassed completely (per-file, default off)
  - invalidation of page cache on open (per-open, default on)

Writes are synchronous even in the caching case, for various reasons.
That is one of the reasons why write performance can be worse than
read performance.  For some filesystems (ntfs-3g), this limitation
could be lifted, but that requires that the mtime handling be moved to
the kernel in these cases, which is not yet possible.

There are also plans to add some sort of cache coherency protocol,
where the filesystem can asynchronously call back to fuse to
invalidate data or metadata.

> Otherwise I don't see how the kernel could coherently cache file pages
> for some kinds of FUSE filesystems.  (E.g. sshfs, for example: every
> operation must surely invoke a user space request or involve granting
> a caching right to the kernel, to keep accesses coherent with other
> users of the same remote files).
> 
> Ergo, either its not coherent, or there is some coherency protocol,
> which does require _some_ work in the user space implementation.

Sshfs is not coherent (but neither is NFS), it just has timeouts for
caches and invalidation based on modification time.

Miklos
