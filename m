Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYLSNVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYLSNVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 08:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYLSNU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:20:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55747 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYLSNU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:20:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <7A24DF798E223B4C9864E8F92E8C93EC01AAF3F8@SACMVEXC1-PRD.hq.netapp.com>
References: <7A24DF798E223B4C9864E8F92E8C93EC01AAF3F8@SACMVEXC1-PRD.hq.netapp.com>
To: "Muntz, Daniel" <Dan.Muntz@netapp.com>
Cc: dhowells@redhat.com, "Andrew Morton" <akpm@linux-foundation.org>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org,
       steved@redhat.com, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 13:20:46 +0000
Message-ID: <10926.1229692846@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Muntz, Daniel <Dan.Muntz@netapp.com> wrote:

> Local disk cache was great for AFS back around 1992.  Typical networks
> were 10 or 100Mbps (slower than disk access at the time), and memories
> were small (typical 16MB).

Yes.  If you connect an NFS client to an NFS server by GigE and have no other
load on the net, and the NFS server can keep the whole dataset in RAM, then
the CacheFiles backend kills your performance.  I have pointed out that you
need to consider carefully whether a local cache is right for you.

> FS-Cache appears to help only with read traffic--one reason why the web
> loves caching--and only for reads that would miss the buffer/page cache
> (memories are now "large").

FS-Cache itself doesn't care whether you're trying to cache read traffic or
write traffic.  The in-kernel AFS filesystem will cache reads and writes, but
the NFS fs will only cache reads as I have currently implemented it.

The reason I did this is that if you make a write on an AFS file, you can
immediately tell if it overlapped with a write from another client, and you
can then nuke your caches.

On NFS, you can't, at least not without proper change attribute support in
NFSv4.  This is not so much a problem with the NFS protocol as a problem with
the fact that the backing filesystems that NFS uses don't or didn't support
it.

However, the same problem affects the NFS pagecache.  If you do a write to an
NFS server, *that* can then be undetectably out of sync with the server.  If
you don't mind that state persisting on disk, FS-Cache presents no barrier to
NFS files that are open for writing being cached too.

> Solaris has had CacheFS since ~1995, HPUX had a port of it since ~1997.  I'd
> be interested in evidence of even a small fraction of Solaris and/or HPUX
> shops using CacheFS.  I am aware of customers who thought it sounded like a
> good idea, but ended up ditching it for various reasons (e.g., CacheFS just
> adds overhead if you almost always hit your local mem cache).

I know that Solaris and Windows have it; I don't have any facts about how
widely it is used.

> One argument in favor that I don't see here is that local disk cache is
> persistent (I'm assuming it is in your implementation).

It can be.  As I said in my email:

	I've tried to implement just the minimal useful functionality for
	persistent caching.  There is more to be added, but it's not immediately
	necessary.

The CacheFiles backend is persistent, but you could write a backend that
isn't, if you, for example, wanted to make use of the >4G of RAM permitted to
some Pentium motherboards as a huge ramdisk.

Not having fully persistent caching allows you to skimp on what metadata you
store to disk.

> Addressing 1 and 2 in your list, I'd be curious how often a miss in core
> is a hit on disk.

It depends on what you're doing.  I'm not sure I can give you a better answer
than that.

> Number 3 scares me.  How does this play with the expected semantics of NFS?

I don't know.  Yet it's something you want to do for AFS, I think.

> Number 5 is hard, if not provably requiring human intervention to do syncs
> when writes are involved (see Disconnected AFS work by UM/CITI/Huston, and
> work at CMU).

Yeah, I appreciate that it's, erm, 'yucky'.  You can aliken it to doing a GIT
pull or CVS update into your tree and then having to manually fix up the
conflicts.

David
